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
private class Test_Release1_Charts_GanttController {
    static testMethod void myUnitTest() {
        Project__c proj = new Project__c(Name = 'Test Project', Project_Summary__c = 'Test', Project_Status__c = 'In Progress');
        insert proj;
        Release__c rel = new Release__c(Name = 'Test Release', Type__c = 'Major', Status__c = 'In Progress', Start_Date__c = Date.Today(), End_Date__c = Date.Today() + 1, Project__c = proj.Id);
        insert rel;
        Test.startTest();
        Release1_Charts_GanttController pageCon = new Release1_Charts_GanttController();
        pageCon.myTarget = proj.Id;
        pageCon.getProjectGanttJson();
        Release1_Charts_GanttController pageConRel = new Release1_Charts_GanttController();
        pageConRel.myTarget = rel.Id;
        pageConRel.getProjectGanttJson();
        Test.stopTest();
    }
}