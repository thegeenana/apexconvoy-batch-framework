public abstract class ApexConvoyBatch
    implements Database.Batchable<SObject>, Database.Stateful {

    private String executionId;
    private String correlationId;
    private Integer scopeNumber;
    private ApexConvoySummary summary;

    public ApexConvoyBatch() {
        this(null);
    }

    public ApexConvoyBatch(String correlationId) {
        this.executionId = newIdentifier();
        this.correlationId = String.isBlank(correlationId)
            ? this.executionId
            : correlationId;
        this.scopeNumber = 0;
        this.summary = new ApexConvoySummary(
            this.executionId,
            this.correlationId
        );
    }

    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return buildQuery(context(batchContext, ApexConvoyPhase.START));
    }

    public void execute(
        Database.BatchableContext batchContext,
        List<SObject> records
    ) {
        scopeNumber++;
        ApexConvoyScopeResult result = processScope(
            records,
            context(batchContext, ApexConvoyPhase.EXECUTE)
        );
        summary.record(result);
    }

    public void finish(Database.BatchableContext batchContext) {
        summary.complete();
        onComplete(
            summary,
            context(batchContext, ApexConvoyPhase.FINISH)
        );
    }

    protected abstract Database.QueryLocator buildQuery(
        ApexConvoyContext context
    );

    protected abstract ApexConvoyScopeResult processScope(
        List<SObject> records,
        ApexConvoyContext context
    );

    protected virtual void onComplete(
        ApexConvoySummary summary,
        ApexConvoyContext context
    ) {
    }

    protected ApexConvoySummary currentSummary() {
        return summary;
    }

    private ApexConvoyContext context(
        Database.BatchableContext batchContext,
        ApexConvoyPhase phase
    ) {
        return new ApexConvoyContext(
            batchContext == null ? null : batchContext.getJobId(),
            executionId,
            correlationId,
            phase,
            scopeNumber
        );
    }

    private static String newIdentifier() {
        return EncodingUtil.convertToHex(Crypto.generateAesKey(128))
            .toLowerCase();
    }
}
