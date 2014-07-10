/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ReportStatusWizardExtension {
    static testMethod void myUnitTest() {
        Project__c proj = new Project__c(Name = 'Test Project', Project_Summary__c = 'Test', Project_Status__c = 'In Progress');
        insert proj;
        Release__c rel = new Release__c(Name = 'Test Release', Type__c = 'Major', Status__c = 'In Progress', Start_Date__c = Date.Today(), End_Date__c = Date.Today() + 1, Project__c = proj.Id);
        insert rel;
        Status_Reports__c stReport = new Status_Reports__c(Name = 'Test Report', Period_Starting_On__c = Date.Today(), Period_Ending_On__c = Date.Today() + 1, Release__c = rel.Id, Overall_Status__c = 'On Track', Budget_Status__c = 'Within Budget', Resource_Status__c = 'Yellow', Scope_Status__c = 'Red', 
        										  Status_Summary__c = 'Test', Key_Accomplishments__c = 'Test', Next_Steps__c = 'Test');
        insert stReport;
        PageReference pageRef = Page.ReportStatusWizard;
        Test.startTest();
        PageReference pr = new PageReference(pageRef+'?id='+stReport.id);
        Test.setCurrentPageReference(pr);
        ReportStatusWizardExtension pageCon = new ReportStatusWizardExtension(new ApexPages.StandardController(rel));
        pageCon.next();
        Test.stopTest();
    }
}