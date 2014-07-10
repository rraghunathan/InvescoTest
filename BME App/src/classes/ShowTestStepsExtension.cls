public with sharing class ShowTestStepsExtension {
    
    public ShowTestStepsExtension(ApexPages.StandardController controller) {
    }
     
     List<Test_Case_Step__c> testcasesteps = new List<Test_Case_Step__c>();
      public List<Test_Case_Step__c> getTestSteps()
      {
      testcasesteps =[Select Id , step_number__c , Step_Description__c , Expected_Result__c from Test_Case_Step__c where Test_Case__c=:ApexPages.currentPage().getParameters().get('id') order by step_number__c ];
      return testcasesteps ;
      }
    public static testMethod void ShowTestStepsExtensionTest() {
    Test_Case__c testcasetest = new Test_Case__c(Name='Test',Summary__c='TestSummary');
     insert testcasetest ; 
    //Create an instance of the controller extension
    ShowTestStepsExtension objExt= new ShowTestStepsExtension (new ApexPages.StandardController(testcasetest));
    objExt.getTestSteps();
    }
  

}