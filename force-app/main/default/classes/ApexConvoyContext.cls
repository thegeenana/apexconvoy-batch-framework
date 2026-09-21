public class ApexConvoyContext {
    public String asyncJobId { get; private set; }
    public String executionId { get; private set; }
    public String correlationId { get; private set; }
    public ApexConvoyPhase phase { get; private set; }
    public Integer scopeNumber { get; private set; }

    public ApexConvoyContext(
        String asyncJobId,
        String executionId,
        String correlationId,
        ApexConvoyPhase phase,
        Integer scopeNumber
    ) {
        this.asyncJobId = asyncJobId;
        this.executionId = executionId;
        this.correlationId = correlationId;
        this.phase = phase;
        this.scopeNumber = scopeNumber;
    }
}
