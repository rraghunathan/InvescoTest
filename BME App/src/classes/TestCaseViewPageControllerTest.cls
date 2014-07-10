/*
*This class provides Test coverage for TestCaseViewPageController class
*/
@isTest
private class TestCaseViewPageControllerTest {
    
    /*
    *Test method
    */
    static testMethod void testCaseViewPageControllerTest(){
        Profile p = [select id from profile where name='System Administrator']; 
        User u = new User(alias = 'standt', email='user@bme.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', username='user@bme.com');
        System.runAs(u) {
            //Test data
            Test_Case__c testcaseObj = new Test_Case__c();
            insert testcaseObj ;

            Test_Case_Step__c TestCaseStep= new Test_Case_Step__c(Test_Case__c=testcaseObj.Id);
            insert TestCaseStep;

            Test_Case_Result__c tsResultObj = new Test_Case_Result__c(Test_Case_Step__c=TestCaseStep.Id);
            insert tsResultObj;

            List<Test_Case_Result__c> tcaseresultList = new List<Test_Case_Result__c>();
            tcaseresultList.add(tsResultObj);

            ApexPages.StandardController stdController = new ApexPages.StandardController(TestCaseStep);
            testCaseViewPageController testcaseviewpagecontroller = new testCaseViewPageController (stdController); 
            testcaseviewpagecontroller.getshowTestSteps();
            testcaseviewpagecontroller.setshowTestSteps(true);
            testcaseviewpagecontroller.getshowNoTestStepsRecs();
            testcaseviewpagecontroller.setshowNoTestStepsRecs(true);
            testcaseviewpagecontroller.getShowTestStepsList();
            
            PageReference pageRef = Page.testCaseViewPage;
            PageReference pr = new PageReference(pageRef+'?Id='+testcaseObj.id);
            Test.setCurrentPageReference(pr);
            
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(TestCaseStep);
            testCaseViewPageController testcaseviewpagecontroller1 = new testCaseViewPageController (stdController1); 
            testcaseviewpagecontroller1.testCaseStep = null;
            testcaseviewpagecontroller1.getShowTestStepsList();
            testcaseviewpagecontroller1.isTest = true;
            testcaseviewpagecontroller1.testCaseSteps();
            
        }
    }

}