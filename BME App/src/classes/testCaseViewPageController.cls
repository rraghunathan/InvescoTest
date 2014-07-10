public with sharing class testCaseViewPageController {
        public boolean isTest{set; get;}
        public List<Test_Case_Step__c> testCaseStep ;
        public Boolean showTestSteps = FALSE;
        public Boolean showNoTestStepsRecs = FALSE;

        public Boolean getshowTestSteps(){ return showTestSteps;}
        public void setshowTestSteps(Boolean showTestSteps){ this.showTestSteps = showTestSteps;}

        public Boolean getshowNoTestStepsRecs() { return showNoTestStepsRecs;}
        public void setshowNoTestStepsRecs(Boolean showNoTestStepsRecs) {this.showNoTestStepsRecs = showNoTestStepsRecs;}



        public testCaseViewPageController(ApexPages.StandardController controller) {
                  testCaseSteps();
        }

        public List<Test_Case_Step__c> getShowTestStepsList(){ 

                if(testCaseStep != null){

                        return testCaseStep;

                }else{

                        return new List<Test_Case_Step__c>();

                }
        }
        
        
        public void testCaseSteps() {
                
                try{
                        testCaseStep = [Select Id,Step_Number__c,Step_Description__c,Expected_Result__c
                                        From Test_Case_Step__c
                                        Where Test_Case__c =: ApexPages.CurrentPage().getParameters().get('Id')];
                
                if(testCaseStep == null || testCaseStep.size() <= 0 || (isTest!=null && isTest)){
                        
                        throw new TestCaseViewPageException('No test case steps found');
                }
                                
                        showTestSteps = TRUE;
                        showNoTestStepsRecs = FALSE;
                        
                        

                }catch(Exception ex){

                        System.debug('No Test Case Steps defined : '+ex.getMessage());
                        showTestSteps = FALSE;
                        showNoTestStepsRecs = TRUE;
                }
        }
        
        /*
        *Custom exception class
    */
    public class TestCaseViewPageException extends Exception {
        
 
    }
}