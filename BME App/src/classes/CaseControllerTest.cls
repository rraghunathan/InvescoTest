/*
*This class provides test coverage for CaseController code
*/
@isTest
private class CaseControllerTest {
	
	 
   //------------------------------Test Methods -------------------------------------------------------------------------
     static testMethod void CaseControllerTestMethod(){
     
     //Test Data Creation
     Test_Case__c testcaseObj = new Test_Case__c();
     insert testcaseObj ;
             
     Test_Case__c testcasetest = new Test_Case__c(Summary__c='TestSummary');
     insert testcasetest ; 
     System.assertEquals(testcasetest.Summary__c, 'TestSummary');
     
     Test_Case_step__c testcasesteptest1 = new Test_Case_step__c(Test_Case__c=testcasetest.id,Step_Number__c=1);
     insert testcasesteptest1 ; 
     
     Test_Case_step__c testcasesteptest2 = new Test_Case_step__c(Test_Case__c=testcasetest.id,Step_Number__c=2);
     insert testcasesteptest2 ;
     
     Test_Case_step__c testcasesteptest3 = new Test_Case_step__c(Test_Case__c=testcasetest.id,Step_Number__c=0);
     insert testcasesteptest3 ;
     Test_Case_step__c testcasesteptest4 = new Test_Case_step__c(Test_Case__c=testcasetest.id,Step_Number__c=0);
     insert testcasesteptest4 ;
     
     Test_Case_step__c testcasesteptest5 = new Test_Case_step__c(Test_Case__c=testcasetest.id,Step_Number__c=1);
     insert testcasesteptest5 ;
     Test_Case_step__c testcasesteptest6 = new Test_Case_step__c(Test_Case__c=testcasetest.id,Step_Number__c=1);
     insert testcasesteptest6 ;    
     
     List<Test_Case_step__c> testcasesteptestList = new List<Test_Case_step__c>();
     insert testcasesteptestList ;
     testcasesteptestList.add(testcasesteptest1);
     testcasesteptestList.add(testcasesteptest2);
     
     List<Test_Case_step__c> testcasesteptestList2 = new List<Test_Case_step__c>();
     insert testcasesteptestList2 ;
     testcasesteptestList2.add(testcasesteptest3);
     testcasesteptestList2.add(testcasesteptest4);
     
     List<Test_Case_step__c> testcasesteptestList1 = new List<Test_Case_step__c>();
     insert testcasesteptestList1 ;
     testcasesteptestList1.add(testcasesteptest5);
     testcasesteptestList1.add(testcasesteptest6);
    
     System.assertEquals(testcasesteptestList.size() , 2);
     
    
     //Class Object Creation
     CaseController casecontroller1 = new CaseController (); //Test Empty Constructor
     ApexPages.StandardController stdController = new ApexPages.StandardController(testcasetest );
     CaseController casecontroller= new CaseController (stdController);
     CaseController casecontroller2= new CaseController (stdController);  
     
     //Method Call 
     CaseController.accountwrapper accwrapper = new CaseController.accountwrapper(testcasesteptest1);
     accwrapper.Selected = true;
    
     casecontroller.gettestcase();
     casecontroller.settestcase(testcasetest);
     casecontroller.getobj();
     casecontroller.setobj(testcasesteptest1);
     casecontroller.AddTestCaseStep();
     casecontroller.CancelTestCase();
     casecontroller.AddStep_Cancel();
     
     casecontroller.ZeroStep(testcasesteptestList);
     casecontroller.ZeroStep(testcasesteptestList2);
     casecontroller.DuplicateStep(testcasesteptestList);
     casecontroller.DuplicateStep(testcasesteptestList2);
     
     Id caseId = casecontroller.InsertTestCase();
     Id caseId1 = casecontroller.InsertTestCase();
     casecontroller.setobj(testcasesteptest1);
     casecontroller.AddTestCaseStep();
     casecontroller.setobj(testcasesteptest1);
     casecontroller.AddTestCaseStep();
     Id caseId2 = casecontroller.InsertTestCase();
     casecontroller.setobj(testcasesteptest3);
     casecontroller.AddTestCaseStep();
     Id caseId3 = casecontroller.InsertTestCase();
     
     casecontroller.SaveTestCase();
     casecontroller2.setobj(testcasesteptest2);
     casecontroller2.AddTestCaseStep();
     casecontroller2.SaveTestCase();
     casecontroller.SaveAndNewTestCase();
     casecontroller2.setobj(testcasesteptest2);
     casecontroller2.AddTestCaseStep();
     casecontroller2.SaveAndNewTestCase();
     casecontroller2.setobj(testcasesteptest1);
     casecontroller2.AddTestCaseStep();
     casecontroller2.getTestCaseSteps(); 
     casecontroller2.testCasesteplist[0].selected = true;
     casecontroller2.getSelected();
     casecontroller2.GetSelectedAccounts();
     casecontroller.GetSelectedAccounts();
     casecontroller2.removeTestCaseStep();
     
     casecontroller.removeTestCaseStep();
     casecontroller.updateTestCaseStep();
     casecontroller.CancelNewTestCase();
     }

}