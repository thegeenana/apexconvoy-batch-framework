@IsTest
private class ApexConvoyScopeResultTest {
    @IsTest
    static void createsAllSucceededResult() {
        ApexConvoyScopeResult result =
            ApexConvoyScopeResult.allSucceeded(25);

        System.assertEquals(25, result.attempted);
        System.assertEquals(25, result.succeeded);
        System.assertEquals(0, result.failed);
    }

    @IsTest
    static void rejectsInconsistentCounts() {
        try {
            new ApexConvoyScopeResult(10, 8, 1);
            System.assert(false, 'Expected ApexConvoyException');
        } catch (ApexConvoyException expected) {
            System.assert(
                expected.getMessage().contains('attempted')
            );
        }
    }

    @IsTest
    static void summaryAggregatesCompletedScopes() {
        ApexConvoySummary summary =
            new ApexConvoySummary('execution-1', 'correlation-1');

        summary.record(new ApexConvoyScopeResult(10, 9, 1));
        summary.record(new ApexConvoyScopeResult(5, 5, 0));
        summary.complete();

        System.assertEquals(2, summary.completedScopes);
        System.assertEquals(15, summary.attemptedRecords);
        System.assertEquals(14, summary.succeededRecords);
        System.assertEquals(1, summary.failedRecords);
        System.assertNotEquals(null, summary.finishedAt);
    }
}
