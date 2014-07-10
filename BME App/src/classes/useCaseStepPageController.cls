public with sharing class useCaseStepPageController {

    public Use_Case_Step__c useCaseStepResult = new Use_Case_Step__c();

    public List<Use_Case_Step__c> getUseCaseStepResults() {
        List<Use_Case_Step__c> useCaseResultList = new List<Use_Case_Step__c>();


        useCaseStepResult.Step_Number__c = 0;
        useCaseStepResult.Step_Description__c = 'First';
        useCaseStepResult.Expected_Result__c = 'Expected Result';

        useCaseStepResult.Use_Case__c =ApexPages.currentPage().getParameters().get('useCaseStepId');

        useCaseResultList.add(useCaseStepResult);    
        return useCaseResultList;
    }

    public PageReference createUseCaseStepResult(){

        insert useCaseStepResult;
        System.debug('inserted use case step : '+ useCaseStepResult.Id);
        return null;
    }

    Public static testMethod void useCaseStepPageControllerTest(){
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
            Use_Case__c usecaseObj = new Use_Case__c(Trigger__c='Test', Use_Case_Name__c='Test1',Work_Package__c=wp.id);
            insert usecaseObj;

            Use_Case_Step__c UseCaseStepObj= new Use_Case_Step__c(Step_Number__c=1);
            insert UseCaseStepObj;

            List<Use_Case_Step__c> usecaseList = new List<Use_Case_Step__c>();
            usecaseList.add(UseCaseStepObj);

            useCaseStepPageController usecasesteppagecontroller = new useCaseStepPageController (); 
            usecasesteppagecontroller.getUseCaseStepResults();
            usecasesteppagecontroller.createUseCaseStepResult();
        }
    }

}