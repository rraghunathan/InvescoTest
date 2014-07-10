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
private class Test_ReleaseChartsController {
    static testMethod void myUnitTest() {
        Project__c proj = new Project__c(Name = 'Test Project', Project_Summary__c = 'Test', Project_Status__c = 'In Progress');
        insert proj;
        Release__c rel = new Release__c(Name = 'Test Release', Type__c = 'Major', Status__c = 'In Progress', Start_Date__c = Date.Today(), End_Date__c = Date.Today() + 1, Project__c = proj.Id);
        insert rel;
        Work_Package__c wp = new Work_Package__c(Status__c = 'In Progress', Priority__c = 'Medium', Release__c = rel.Id);
        insert wp;
        Milestone__c mile = new Milestone__c(Name = 'Test Milestone', Release__c = rel.Id, Status__c = 'Completed', Target_Completion_Date__c = Date.Today(), Actual_Completion_Date__c = Date.Today() + 1);
        insert mile;
        Id issueRtId, riskRtId;
        Schema.DescribeSObjectResult d = Schema.SObjectType.Project_Item__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        if(rtMapByName.containsKey('Issue')){
            issueRtId = rtMapByName.get('Issue').getRecordTypeId();
        }
        if(rtMapByName.containsKey('Risk')){
            riskRtId = rtMapByName.get('Risk').getRecordTypeId();
        }
        List<Project_Item__c> projItems = new List<Project_Item__c>{
                                                new Project_Item__c(Summary__c = 'Test Issue', Status__c = 'Open', Priority__c = 'Critical', Due_Date__c = Date.Today(), Submitted_By__c = UserInfo.getUserId(), Release__c = rel.Id, RecordTypeId = issueRtId, Work_Package__c = wp.Id),
                                                new Project_Item__c(Summary__c = 'Test Risk', Status__c = 'Open', Priority__c = 'Critical', Due_Date__c = Date.Today(), Submitted_By__c = UserInfo.getUserId(), Release__c = rel.Id,RecordTypeId = riskRtId, Work_Package__c = wp.Id)};
        insert projItems;
        PageReference pageRef = Page.ReleaseCharts;
        Test.startTest();
        PageReference pr = new PageReference(pageRef+'?id='+rel.id);
        Test.setCurrentPageReference(pr);
        ReleaseChartsController pageCon = new ReleaseChartsController(new ApexPages.StandardController(rel));
        Deliverables__c del = new Deliverables__c(Name = 'Test Deliverable', Release__c = rel.Id, Status__c = 'Completed', Planned_Completion_Date__c = Date.Today(), Actual_Completion_Date__c = Date.Today() + 1, Completed__c = '100');
        insert del;
        ReleaseChartsController pageCon2 = new ReleaseChartsController(new ApexPages.StandardController(rel));
        Test.stopTest();
    }
}