/*
*This test class provides test coverage to EditTestCaseExtension code
*/
@isTest
private class EditTestCaseExtensionTest {
	
	
		static testMethod void EditTestCaseExtensionTest(){
         Profile p = [select id from profile where name='System Administrator']; 
         User u = new User(alias = 'standt', email='user@bme.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='user@bme.com');
             System.runAs(u) {
             //Test data
             Test_Case__c testcaseObj = new Test_Case__c();
             insert testcaseObj ;
             Test_Case__c testcaseObj1 = new Test_Case__c();
             insert testcaseObj1 ;
             Test_Case__c testcaseObj2 = new Test_Case__c();
             insert testcaseObj2 ;
             
             Test_Case_Step__c TestCaseStep= new Test_Case_Step__c(Test_Case__c=testcaseObj.Id);
             insert TestCaseStep;
             Test_Case_Step__c TestCaseStep1= new Test_Case_Step__c(Step_Number__c = 0, Test_Case__c=testcaseObj.Id);
             insert TestCaseStep1;
             Test_Case_Step__c TestCaseStep2= new Test_Case_Step__c(Step_Number__c = 1);
             insert TestCaseStep2;
             Test_Case_Step__c TestCaseStep3= new Test_Case_Step__c();
             insert TestCaseStep3;
             Test_Case_Step__c TestCaseStep4= new Test_Case_Step__c(Step_Number__c = 1, Test_Case__c=testcaseObj1.Id);
             insert TestCaseStep4;
             Test_Case_Step__c TestCaseStep5= new Test_Case_Step__c(Step_Number__c = 1, Test_Case__c=testcaseObj1.Id);
             insert TestCaseStep5;
             Test_Case_Step__c TestCaseStep6= new Test_Case_Step__c(Step_Number__c = 1, Test_Case__c=testcaseObj2.Id);
             insert TestCaseStep6;
             
             Test_Case_Result__c tsResultObj = new Test_Case_Result__c(Test_Case_Step__c=TestCaseStep.Id);
             insert tsResultObj;
             
             List<Test_Case_Result__c> tcaseresultList = new List<Test_Case_Result__c>();
             tcaseresultList.add(tsResultObj);
             
                             
             ApexPages.StandardController stdController = new ApexPages.StandardController(testcaseObj);
             ApexPages.StandardController stdController1 = new ApexPages.StandardController(testcaseObj1);
             ApexPages.StandardController stdController2 = new ApexPages.StandardController(testcaseObj2);
             EditTestCaseExtension edittestcaseextensiontest= new EditTestCaseExtension(stdController);
             EditTestCaseExtension edittestcaseextensiontest1= new EditTestCaseExtension(stdController);
             EditTestCaseExtension edittestcaseextensiontest2= new EditTestCaseExtension(stdController);
             EditTestCaseExtension edittestcaseextensiontest3= new EditTestCaseExtension(stdController1);
             EditTestCaseExtension edittestcaseextensiontest4= new EditTestCaseExtension(stdController2);
             edittestcaseextensiontest.gettestcase();
             edittestcaseextensiontest.settestcase(testcaseObj);
             edittestcaseextensiontest.getTestCaseSteps();
             edittestcaseextensiontest.testcasestepList[0].selected = true;
             edittestcaseextensiontest.getSelected();
             edittestcaseextensiontest.GetSelectedAccounts();
             edittestcaseextensiontest1.GetSelectedAccounts();
             edittestcaseextensiontest.getobj();
             edittestcaseextensiontest.setobj(TestCaseStep);
             edittestcaseextensiontest.AddTestCaseStep();
             edittestcaseextensiontest.setobj(TestCaseStep1);
             edittestcaseextensiontest.AddTestCaseStep();
             edittestcaseextensiontest.setobj(TestCaseStep2);
             edittestcaseextensiontest.AddTestCaseStep();
             system.debug('begin');
             edittestcaseextensiontest1.setobj(TestCaseStep3);
             edittestcaseextensiontest1.AddTestCaseStep();
             edittestcaseextensiontest.AddStep_Cancel();
             edittestcaseextensiontest.removeTestCaseStep();
             edittestcaseextensiontest2.removeTestCaseStep();
             edittestcaseextensiontest.updateTestCaseStep();
             
             edittestcaseextensiontest3.getTestCaseSteps();
             edittestcaseextensiontest3.updateTestCaseStep();
             
             edittestcaseextensiontest4.getTestCaseSteps();
             edittestcaseextensiontest4.testcasestepList[0].selected = true;
             edittestcaseextensiontest4.updateTestCaseStep();
             
             edittestcaseextensiontest.ZeroStepNumber();
             edittestcaseextensiontest.DuplicateStepNumber();
             edittestcaseextensiontest.DuplicateStepNumber_AddClick();
             edittestcaseextensiontest.InsertTestStep();
             EditTestCaseExtension.accountWrapper wrap = new EditTestCaseExtension.accountWrapper (TestCaseStep);
             }
        }

}