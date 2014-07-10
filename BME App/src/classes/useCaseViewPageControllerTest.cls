/*
*This class provides Test coverage for TestCaseViewPageController class
*/
@isTest
private class useCaseViewPageControllerTest {
	
	static testMethod void useCaseViewPageControllerTest(){
		Profile p = [select id from profile where name='System Administrator']; 
		User u = new User(alias = 'standt', email='user@bme.com', 
				emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
				localesidkey='en_US', profileid = p.Id, 
				timezonesidkey='America/Los_Angeles', username='user@bme.com');
		System.runAs(u) {
			//Test data
			Release__c r = new Release__c(Name='RTest',Type__c='Major',Status__c='Scoping');
         	insert r;
         	Work_Package__c wp = new Work_Package__c(Work_Package_Name__c='WPTEST',Status__c='Not Started',Priority__c='High',Release__c=r.id);
        	 insert wp;
			Use_Case__c usecaseObj = new Use_Case__c(Use_Case_Name__c='UseSummary', Trigger__c='Test Scenario',Work_Package__c=wp.id);
			insert usecaseObj;

			Use_Case_Step__c UseCaseStepObj= new Use_Case_Step__c(Step_Number__c=1);
			insert UseCaseStepObj;

			List<Use_Case_Step__c> usecaseList = new List<Use_Case_Step__c>();
			usecaseList.add(UseCaseStepObj);


			ApexPages.StandardController stdController = new ApexPages.StandardController(UseCaseStepObj);
			useCaseViewPageController usecaseviewPagecontroller = new useCaseViewPageController (stdController); 
			usecaseviewPagecontroller.getshowUseCaseSteps();
			usecaseviewPagecontroller.setshowUseCaseSteps(true);
			usecaseviewPagecontroller.getshowNoUseCaseStepsRecs();
			usecaseviewPagecontroller.setshowNoUseCaseStepsRecs(true);
			usecaseviewPagecontroller.getShowTestStepsList(); 
			
			Use_Case__c usecaseObj1 = new Use_Case__c(Use_Case_Name__c='UseSummary', Trigger__c='Test Scenario',Work_Package__c=wp.id);
			insert usecaseObj1;

			Use_Case_Step__c UseCaseStepObj1= new Use_Case_Step__c(Step_Number__c=1);
			insert UseCaseStepObj1;
			
			
			ApexPages.StandardController stdController1 = new ApexPages.StandardController(UseCaseStepObj1);
			useCaseViewPageController usecaseviewPagecontroller1 = new useCaseViewPageController (stdController1); 
			usecaseviewPagecontroller1.useCaseStep = null;
			usecaseviewPagecontroller1.getShowTestStepsList();
			usecaseviewPagecontroller1.isTest = true;
			usecaseviewPagecontroller1.useCaseSteps();
		}
	}
	
	


}