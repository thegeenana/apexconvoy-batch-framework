@IsTest
private class AccountNameNormalisationBatchTest {
    @IsTest
    static void normalisesAccountsAcrossMultipleScopes() {
        insert new List<Account>{
            new Account(Name = '  Big Bear  '),
            new Account(Name = ' BrightClean '),
            new Account(Name = 'Northstar Dental  ')
        };

        Test.startTest();
        Id jobId = Database.executeBatch(
            new AccountNameNormalisationBatch('test-correlation'),
            2
        );
        Test.stopTest();

        Map<String, Account> byName = new Map<String, Account>();
        for (Account account : [
            SELECT Name
            FROM Account
        ]) {
            byName.put(account.Name, account);
        }

        System.assert(byName.containsKey('Big Bear'));
        System.assert(byName.containsKey('BrightClean'));
        System.assert(byName.containsKey('Northstar Dental'));

        AsyncApexJob job = [
            SELECT Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
            FROM AsyncApexJob
            WHERE Id = :jobId
        ];
        System.assertEquals('Completed', job.Status);
        System.assertEquals(0, job.NumberOfErrors);
        System.assert(job.TotalJobItems >= 2);
    }
}
