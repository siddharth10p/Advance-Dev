trigger OpportunityTrigger on Opportunity (after update) {
    Map<Id, List<Opportunity>> accIdOpptsMap = new Map<Id, List<Opportunity>>();
    for (Opportunity oppty : Trigger.new) {
        if (oppty.isWon && oppty.AccountId != null) {
            if (!accIdOpptsMap.containsKey(oppty.AccountId)) {
                accIdOpptsMap.put(oppty.AccountId, new List<Opportunity>());
            }
            accIdOpptsMap.get(oppty.AccountId).add(oppty);
        }
    } // End for

    List<Account> acctsToUpdate = new List<Account>();
    for (Account acct : [SELECT Id, Description
                        FROM Account
                        WHERE Id IN : accIdOpptsMap.keySet()]) {
        for (Opportunity opp : accIdOpptsMap.get(acct.Id)) {
            acct.Description = acct.Description != null ?
                    acct.Description + '; ' + opp.Name + '-' + (opp.Amount > 0 ? opp.Amount : 0) + '-' + Date.today() :
                    opp.Name + '-' + (opp.Amount > 0 ? opp.Amount : 0) + '-' + Date.today();
        }
        acctsToUpdate.add(acct);
    }

    if (acctsToUpdate.size() > 0) {
        update acctsToUpdate;
    }
}
