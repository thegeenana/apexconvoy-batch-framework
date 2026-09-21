public class ApexConvoyScopeResult {
    public Integer attempted { get; private set; }
    public Integer succeeded { get; private set; }
    public Integer failed { get; private set; }

    public ApexConvoyScopeResult(
        Integer attempted,
        Integer succeeded,
        Integer failed
    ) {
        this.attempted = nonNegative(attempted);
        this.succeeded = nonNegative(succeeded);
        this.failed = nonNegative(failed);

        if (this.succeeded + this.failed != this.attempted) {
            throw new ApexConvoyException(
                'Scope result must satisfy attempted = succeeded + failed.'
            );
        }
    }

    public static ApexConvoyScopeResult allSucceeded(Integer recordCount) {
        Integer count = nonNegative(recordCount);
        return new ApexConvoyScopeResult(count, count, 0);
    }

    public static ApexConvoyScopeResult fromSaveResults(
        Database.SaveResult[] saveResults
    ) {
        Integer succeeded = 0;
        Integer failed = 0;

        if (saveResults != null) {
            for (Database.SaveResult result : saveResults) {
                if (result.isSuccess()) {
                    succeeded++;
                } else {
                    failed++;
                }
            }
        }

        return new ApexConvoyScopeResult(
            succeeded + failed,
            succeeded,
            failed
        );
    }

    private static Integer nonNegative(Integer value) {
        return value == null || value < 0 ? 0 : value;
    }
}
