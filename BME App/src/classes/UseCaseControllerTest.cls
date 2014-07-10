/*
*UseCaseControllerTest class provides test coverage for the methods in class UseCaseContoller
*/
@isTest	
private class UseCaseControllerTest {
	
	/*
	*Test coverage
	*/
     static testMethod void CaseControllerUseMethod(){
     
	     //Use Data Creation
	     Release__c r = new Release__c(Name='RTest',Type__c='Major',Status__c='Scoping');
         insert r;
         Work_Package__c wp = new Work_Package__c(Work_Package_Name__c='WPTEST',Status__c='Not Started',Priority__c='High',Release__c=r.id);
         insert wp;
	     Use_Case__c usecaseuse = new Use_Case__c(Use_Case_Name__c='UseSummary', Trigger__c='Test Scenario',Work_Package__c=wp.id);
	     insert usecaseuse ; 
	     System.assertEquals(usecaseuse.Use_Case_Name__c, 'UseSummary');
	     
	      Use_Case_step__c usecasestepuse0= new Use_Case_step__c(Use_Case__c=usecaseuse.id,Step_Number__c=0,Step_Description__c='Step 0 test',Expected_Result__c='test');
	     insert usecasestepuse0 ; 
	     
	     Use_Case_step__c usecasestepuse1 = new Use_Case_step__c(Use_Case__c=usecaseuse.id,Step_Number__c=1,Step_Description__c='Step 1 test',Expected_Result__c='test');
	     insert usecasestepuse1 ; 
	     
	     Use_Case_step__c usecasestepuse2 = new Use_Case_step__c(Use_Case__c=usecaseuse.id,Step_Number__c=2,Step_Description__c='Step 2 test',Expected_Result__c='test');
	     insert usecasestepuse2 ; 
	     
	     Use_Case_step__c usecasestepuse3 = new Use_Case_step__c(Use_Case__c=usecaseuse.id,Step_Number__c=2,Step_Description__c='Step 3 test',Expected_Result__c='test');
	     insert usecasestepuse3 ;
	     
	     List<Use_Case_step__c> usecasestepuseList = new List<Use_Case_step__c>();
	     insert usecasestepuseList ;
	     usecasestepuseList.add(usecasestepuse0);
	     usecasestepuseList.add(usecasestepuse1);
	     usecasestepuseList.add(usecasestepuse2);
	     usecasestepuseList.add(usecasestepuse3);
	     
	     System.assertEquals(usecasestepuseList.size() , 4);
	     
	    
	     //Class Object Creation
	     UseCaseController casecontroller = new UseCaseController();
	     Apexpages.Pagereference pgRef = casecontroller.CancelNewUseCase();
	     //Method Call 
	     casecontroller.getusecase();
	     casecontroller.setusecase(usecaseuse);
	     casecontroller.getobj();
	     casecontroller.setobj(usecasestepuse1);
	     casecontroller.AddUseCaseStep();
	     
	     casecontroller.ZeroStep(usecasestepuseList);
	     casecontroller.DuplicateStep(usecasestepuseList);
	     
	     Id caseId = casecontroller.InsertUseCase();
	     casecontroller.SaveUseCase();
	     casecontroller.SaveAndNewUseCase();
	     casecontroller.getUseCaseSteps();
	     casecontroller.getSelected();
	     casecontroller.GetSelectedAccounts();
	     UseCaseController.accountwrapper accwrapper = new UseCaseController.accountwrapper(usecasestepuse1 );
	    
	     casecontroller.removeUseCaseStep();
	     casecontroller.updateUseCaseStep();
	     Apexpages.Pagereference pgRefCncl = casecontroller.CancelUseCase();
	     Apexpages.Pagereference pgRefCnclStp = casecontroller.AddStep_Cancel();
	     
	     CaseController.usCcsSize = 1;
	     CaseController.dpStp = true;
	     CaseController.zrStp = false;
	     CaseController.InsertUseCase();
	     
	     CaseController.usCcsSize = 1;
	     CaseController.dpStp = false;
	     CaseController.zrStp = true;
	     CaseController.InsertUseCase();
	     
	     CaseController.usCcsSize = 1;
	     CaseController.dpStp = false;
	     CaseController.zrStp = false;
	     
	     CaseController.usecaseid = usecaseuse.id;
	     CaseController.SaveUseCase();
	     CaseController.SaveAndNewUseCase();
	     
	     CaseController.allusecasesteps.add(usecasestepuse1);
	     CaseController.allusecasesteps.add(usecasestepuse2);
	     CaseController.allusecasesteps.add(usecasestepuse3);
	     CaseController.getUseCaseSteps();
	     
	     UseCaseController.accountwrapper actw1 = new UseCaseController.accountwrapper(usecasestepuse1);
	     actw1.selected = true;
	     UseCaseController.accountwrapper actw2 = new UseCaseController.accountwrapper(usecasestepuse2);
	     actw2.selected = true;
	     CaseController.usecasestepList.add(actw1); 
	     CaseController.usecasestepList.add(actw2);
	     CaseController.getSelected();
	     CaseController.GetSelectedAccounts();
	       
	     CaseController.removeUseCaseStepList.add(usecasestepuse2);
	     CaseController.removeUseCaseStep();
	     
     }
     

}