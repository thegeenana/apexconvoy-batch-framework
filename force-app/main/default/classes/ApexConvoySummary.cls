public class ApexConvoySummary {
    public String executionId { get; private set; }
    public String correlationId { get; private set; }
    public Datetime startedAt { get; private set; }
    public Datetime finishedAt { get; private set; }
    public Integer completedScopes { get; private set; }
    public Integer attemptedRecords { get; private set; }
    public Integer succeededRecords { get; private set; }
    public Integer failedRecords { get; private set; }

    public ApexConvoySummary(String executionId, String correlationId) {
        this.executionId = executionId;
        this.correlationId = correlationId;
        this.startedAt = Datetime.now();
        this.completedScopes = 0;
        this.attemptedRecords = 0;
        this.succeededRecords = 0;
        this.failedRecords = 0;
    }

    public void record(ApexConvoyScopeResult result) {
        if (result == null) {
            throw new ApexConvoyException(
                'processScope must return an ApexConvoyScopeResult.'
            );
        }

        completedScopes++;
        attemptedRecords += result.attempted;
        succeededRecords += result.succeeded;
        failedRecords += result.failed;
    }

    public void complete() {
        finishedAt = Datetime.now();
    }

    public String toJson() {
        return JSON.serialize(this);
    }
}
