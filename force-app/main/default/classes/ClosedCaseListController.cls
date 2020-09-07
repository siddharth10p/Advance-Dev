/**
 * @description       : This controller fetches all closed cases
 * @author            : Siddharth Pandit
 * @group             : 
 * @last modified on  : 08-28-2020
 * @last modified by  : Siddharth Pandit
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   08-28-2020   Siddharth Pandit   Initial Version
**/
public with sharing class ClosedCaseListController {
    public List<Case> getClosedCases() {
        return [SELECT Id, Account.Name, Contact.Name, Priority, CaseNumber
                FROM Case
                WHERE Status = 'Closed'];
    }

    public void doSearch() {
        
    }
}
