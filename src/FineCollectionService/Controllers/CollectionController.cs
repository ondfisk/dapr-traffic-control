namespace FineCollectionService.Controllers;

[ApiController]
[Route("")]
public class CollectionController : ControllerBase
{
    private const string DAPR_SECRET_STORE = "secretstore";
    private const string DAPR_PUBSUB_BROKER = "pubsub";
    private const string DAPR_PUBSUB_TOPIC_NAME = "speedingviolations";
    private const string DAPR_PUBSUB_DEADLETTER_TOPIC_NAME = "deadletters";
    private const string DAPR_EMAIL_BINDING_NAME = "sendmail";
    private static string? _fineCalculatorLicenseKey;

    private readonly ILogger<CollectionController> _logger;
    private readonly IFineCalculator _fineCalculator;
    private readonly VehicleRegistrationService _vehicleRegistrationService;
    private readonly DaprClient _daprClient;

    public CollectionController(IFineCalculator fineCalculator, VehicleRegistrationService vehicleRegistrationService, DaprClient daprClient, ILogger<CollectionController> logger)
    {
        _logger = logger;
        _fineCalculator = fineCalculator;
        _vehicleRegistrationService = vehicleRegistrationService;
        _daprClient = daprClient;
    }

    [Topic(DAPR_PUBSUB_BROKER, DAPR_PUBSUB_TOPIC_NAME, DAPR_PUBSUB_DEADLETTER_TOPIC_NAME, false)]
    [Route("collectfine")]
    [HttpPost]
    public async Task<ActionResult> CollectFine(SpeedingViolation speedingViolation)
    {
        if (_fineCalculatorLicenseKey is null)
        {
            var secretName = Environment.GetEnvironmentVariable("FINE_CALCULATOR_LICENSE_SECRET_NAME") ?? "finecalculator.licensekey";
            var secretKey = Environment.GetEnvironmentVariable("FINE_CALCULATOR_LICENSE_SECRET_KEY") ?? "finecalculator.licensekey";
            var secrets = await _daprClient.GetSecretAsync(DAPR_SECRET_STORE, secretName);
            _fineCalculatorLicenseKey = secrets[secretName];
        }

        decimal fine = _fineCalculator.CalculateFine(_fineCalculatorLicenseKey, speedingViolation.ViolationInKmh);

        // get owner info (Dapr service invocation)
        var vehicleInfo = _vehicleRegistrationService.GetVehicleInfo(speedingViolation.VehicleId).Result;

        // log fine
        var fineString = fine == 0 ? "TBD by the prosecutor" : $"{fine} Euro";
        _logger.LogInformation("Sent speeding ticket to {Owner}. Road: {Road}, License number: {LicenseNumber}, Vehicle: {Make} {Model}, Violation: {ViolationInKmh} Km/h, Fine: {Fine}, On: {Timestamp}.", vehicleInfo.OwnerName, speedingViolation.RoadId, speedingViolation.VehicleId, vehicleInfo.Make, vehicleInfo.Model, speedingViolation.ViolationInKmh, fineString, speedingViolation.Timestamp);

        // send fine by email (Dapr output binding)
        var body = EmailUtils.CreateEmailBody(speedingViolation, vehicleInfo, fineString);
        var metadata = new Dictionary<string, string>
        {
            ["emailFrom"] = "noreply@cfca.gov",
            ["emailTo"] = vehicleInfo.OwnerEmail,
            ["subject"] = $"Speeding violation on the {speedingViolation.RoadId}"
        };
        await _daprClient.InvokeBindingAsync(DAPR_EMAIL_BINDING_NAME, "create", body, metadata);

        return Ok();
    }

    [Topic(DAPR_PUBSUB_BROKER, DAPR_PUBSUB_DEADLETTER_TOPIC_NAME)]
    [Route("deadletters")]
    [HttpPost]
    public ActionResult HandleDeadLetter(object message)
    {
        _logger.LogError("The service was not able to handle a CollectFine message.");

        try
        {
            var messageJson = JsonSerializer.Serialize<object>(message);
            _logger.LogInformation("Unhandled message content: {Message}", messageJson);
        }
        catch
        {
            _logger.LogError("Unhandled message's payload could not be deserialized.");
        }

        return Ok();
    }
}
