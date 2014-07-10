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
private class Test_StatusReportController {
    static testMethod void myUnitTest() {
        Project__c proj = new Project__c(Name = 'Test Project', Project_Summary__c = 'Test', Project_Status__c = 'In Progress');
        insert proj;
        Release__c rel = new Release__c(Name = 'Test Release', Type__c = 'Major', Status__c = 'In Progress', Start_Date__c = Date.Today(), End_Date__c = Date.Today() + 1, Project__c = proj.Id);
        insert rel;
        Work_Package__c wp = new Work_Package__c(Status__c = 'In Progress', Priority__c = 'Medium', Release__c = rel.Id);
        insert wp;
        Status_Reports__c stReport = new Status_Reports__c(Name = 'Test Report', Period_Starting_On__c = Date.Today(), Period_Ending_On__c = Date.Today() + 1, Release__c = rel.Id, Overall_Status__c = 'On Track', Budget_Status__c = 'Within Budget', Resource_Status__c = 'Yellow', Scope_Status__c = 'Red', 
                                                  Status_Summary__c = 'Test', Key_Accomplishments__c = 'Test', Next_Steps__c = 'Test');
        insert stReport;
        Deliverables__c del = new Deliverables__c(Name = 'Test Deliverable', Release__c = rel.Id, Status__c = 'Completed', Planned_Completion_Date__c = Date.Today(), Actual_Completion_Date__c = Date.Today() + 1, Completed__c = '100');
        insert del;
        List<Milestone__c> mileList = new List<Milestone__c>{
                                    new Milestone__c(Name = 'Test Milestone1', Release__c = rel.Id, Status__c = 'Completed', Target_Completion_Date__c = Date.Today(), Actual_Completion_Date__c = Date.Today() + 1),
                                    new Milestone__c(Name = 'Test Milestone2', Release__c = rel.Id, Status__c = 'Deferred', Target_Completion_Date__c = Date.Today(), Actual_Completion_Date__c = Date.Today() + 1)
                                    };
        insert mileList;
        Project_Status_Mapping__c psm = new Project_Status_Mapping__c(Name = 'On Track', Image_URL__c = '/img/samples/light_green.gif');
        insert psm;
        Budget_Status_Mapping__c bsm = new Budget_Status_Mapping__c(Name = 'Within Budget', Image_URL__c = '/img/samples/light_green.gif');
        insert bsm;
        List<Resource_Scope_Status_Mapping__c> rsmList = new List<Resource_Scope_Status_Mapping__c>{
                                                            new Resource_Scope_Status_Mapping__c(Name = 'Yellow', Image_URL__c = '/img/samples/light_yellow.gif'),
                                                            new Resource_Scope_Status_Mapping__c(Name = 'Red', Image_URL__c = '/img/samples/light_red.gif')};
        insert rsmList; 
        Milestone_Status_Mapping__c msm = new Milestone_Status_Mapping__c(Name = 'Completed', Status__c = 'Complete');
        insert msm;
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
        Document doc = new Document(Name = 'ImageYellow', FolderId = UserInfo.getUserId());
        insert doc;
        PageReference pageRef = Page.StatusReportPage1;
        Test.startTest();
        PageReference pr = new PageReference(pageRef+'?id='+stReport.id);
        Test.setCurrentPageReference(pr);
        StatusReportController pageCon = new StatusReportController(new ApexPages.StandardController(stReport));
        pageCon.statusReport = true;
        pageCon.accomplishments = true;
        pageCon.sumOfDel = true;
        pageCon.statusSmry = true;
        pageCon.reqDeliverableStatus.add('All');
        pageCon.DeliverableStart.Planned_Completion_Date__c = Date.Today();
        pageCon.DeliverableStart.Actual_Completion_Date__c = Date.Today();
        pageCon.DeliverableEnd.Planned_Completion_Date__c = Date.Today() + 1;
        pageCon.DeliverableEnd.Actual_Completion_Date__c = Date.Today() + 1;
        pageCon.reqMilestoneStatus.add('All');
        pageCon.MilestoneStart.Target_Completion_Date__c = Date.Today();
        pageCon.MilestoneEnd.Target_Completion_Date__c = Date.Today() + 1;
        pageCon.MilestoneStart.Actual_Completion_Date__c = Date.Today();
        pageCon.MilestoneEnd.Actual_Completion_Date__c = Date.Today() + 1;
        pageCon.nextSteps = true;
        pageCon.delOfMileStones = true;
        pageCon.step2();
        pageCon.showIssues = true;
        pageCon.reqIssueStatus.add('All');
        pageCon.reqIssueComplexity.add('All');
        pageCon.reqIssuePriority.add('All');
        pageCon.showRisks = true;
        pageCon.reqRiskStatus.add('All');
        pageCon.reqRiskComplexity.add('All');
        pageCon.reqRiskPriority.add('All');
        pageCon.step1();
        pageCon.step3();
        pageCon.getComplexityValues();
        pageCon.getDelStatusValues();
        pageCon.getMileStatusValues();
        pageCon.getPriorityValues();
        pageCon.getStatusValues();
        pageCon.populatePItems();
        pageCon.fetchDelNMileStones();
        pageCon.getDispDashboard();
        pageCon.dashboardURL = 'www.test.com';
        pageCon.getDispDashboard();
        pageCon.step4();        
        pageCon.actionFunction();
        pageCon.generateWord();
        pageCon.generatePDF();        
        Test.stopTest();
    }
}