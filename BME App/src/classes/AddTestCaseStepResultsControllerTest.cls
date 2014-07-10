/*
*This test class provides test coverage for AddTestCaseStepResultsController code
*/
@isTest
private class AddTestCaseStepResultsControllerTest {
	
	    Public static testMethod void LAddTestCaseStepResultsControllerTest(){
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
             
             List<Test_Case_Step__c> testcasestepList = new List<Test_Case_Step__c>();
             testcasestepList.add(TestCaseStep);
             
             
             Test_Case_Result__c tsResultObj = new Test_Case_Result__c(Test_Case_Step__c=TestCaseStep.Id);
             insert tsResultObj;
             
             List<Test_Case_Result__c> tcaseresultList = new List<Test_Case_Result__c>();
             tcaseresultList.add(tsResultObj);
             
             
             //Add parameters to pag
             ApexPages.currentPage().getParameters().put('id',testcaseObj.Id);

             
             AddTestCaseStepResultsController addtestcaseStepresultscontroller= new AddTestCaseStepResultsController(); 
             addtestcaseStepresultscontroller.addrecord=true;
            
            
             addtestcaseStepresultscontroller.SelecteResultRecord = tsResultObj.Id;
             addtestcaseStepresultscontroller.editRecord();
             addtestcaseStepresultscontroller.editResult();
             addtestcaseStepresultscontroller.Cancel_Click();
             addtestcaseStepresultscontroller.addNewResult();
             addtestcaseStepresultscontroller.getTestCaseStepResults();
             addtestcaseStepresultscontroller.AddTestCaseStepResult();
             addtestcaseStepresultscontroller.CancelTestCaseStepResult();
             addtestcaseStepresultscontroller.getTestResult();
             addtestcaseStepresultscontroller.getTestCaseSteps();
             addtestcaseStepresultscontroller.setTestCaseSteps(testcasestepList);
              
             addtestcaseStepresultscontroller.settestcaseresultobj(tsResultObj);

             addtestcaseStepresultscontroller.gettestcase();
             addtestcaseStepresultscontroller.DeleteResult();
             addtestcaseStepresultscontroller.getUserInfo();
             addtestcaseStepresultscontroller.settestcase(testcaseObj );
             addtestcaseStepresultscontroller.setTestCaseResults(tcaseresultList);
             addtestcaseStepresultscontroller.gettestcaseresultobj();
             addtestcaseStepresultscontroller.SelecteResultRecord = null;
             addtestcaseStepresultscontroller.DeleteResult();
             }
         }

}