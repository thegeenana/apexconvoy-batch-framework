public class AccountNameNormalisationBatch extends ApexConvoyBatch {
    public AccountNameNormalisationBatch() {
        super();
    }

    public AccountNameNormalisationBatch(String correlationId) {
        super(correlationId);
    }

    protected override Database.QueryLocator buildQuery(
        ApexConvoyContext context
    ) {
        return Database.getQueryLocator([
            SELECT Id, Name
            FROM Account
            WHERE Name != null
        ]);
    }

    protected override ApexConvoyScopeResult processScope(
        List<SObject> records,
        ApexConvoyContext context
    ) {
        List<Account> accounts = new List<Account>();

        for (SObject record : records) {
            Account account = (Account) record;
            account.Name = account.Name.trim();
            accounts.add(account);
        }

        Database.SaveResult[] results = Database.update(accounts, false);
        return ApexConvoyScopeResult.fromSaveResults(results);
    }

    protected override void onComplete(
        ApexConvoySummary summary,
        ApexConvoyContext context
    ) {
        System.debug(
            LoggingLevel.INFO,
            'APEX_CONVOY ' + summary.toJson()
        );
    }
}
