var trafficControlEndpoint = Environment.GetEnvironmentVariable("TRAFFIC_CONTROL_ENDPOINT");
if (string.IsNullOrWhiteSpace(trafficControlEndpoint))
{
    throw new InvalidOperationException("Traffic control endpoint is not configured");
}
var client = new HttpClient { BaseAddress = new Uri(trafficControlEndpoint) };

var cameras = Enumerable.Range(0, 4).Select(cameraNumber => new CameraSimulation(cameraNumber, client));

Parallel.ForEach(cameras, async camera => await camera.Start());

Task.Run(() => Thread.Sleep(Timeout.Infinite)).Wait();