public with sharing class ShowUseCaseStepsExtension {
    
    public ShowUseCaseStepsExtension(ApexPages.StandardController controller) {
    }
     
     List<Use_Case_Step__c> useCaseSteps = new List<Use_Case_Step__c>();
      public List<Use_Case_Step__c> getUseCaseSteps()
      {
      useCaseSteps =[Select Id , step_number__c , Step_Description__c , Expected_Result__c from Use_Case_Step__c where Use_Case__c=:ApexPages.currentPage().getParameters().get('id') order by step_number__c ];
      return useCaseSteps ;
      }
    public static testMethod void ShowUseCaseStepsExtensionTest() {
    Use_Case_Step__c useCasetest = new Use_Case_Step__c(Step_Description__c='TestSummary');
     insert useCasetest; 
    //Create an instance of the controller extension
    ShowUseCaseStepsExtension objExt= new ShowUseCaseStepsExtension (new ApexPages.StandardController(useCasetest));
    objExt.getUseCaseSteps();
    }
  

}