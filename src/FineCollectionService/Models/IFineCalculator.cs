namespace FineCollectionService.Models;

public interface IFineCalculator
{
    public int CalculateFine(string licenseKey, int violationInKmh);
}
