public with sharing class useCaseViewPageController {
    public boolean isTest{set; get;}
    public List<Use_Case_Step__c> useCaseStep ;
    public Boolean showUseCaseSteps = FALSE;
    public Boolean showNoUseCaseStepsRecs = FALSE;

    public Boolean getshowUseCaseSteps(){ return showUseCaseSteps;}
    public void setshowUseCaseSteps(Boolean showUseCaseSteps){ this.showUseCaseSteps = showUseCaseSteps;}

    public Boolean getshowNoUseCaseStepsRecs() { return showNoUseCaseStepsRecs;}
    public void setshowNoUseCaseStepsRecs(Boolean showNoUseCaseStepsRecs) {this.showNoUseCaseStepsRecs = showNoUseCaseStepsRecs;}



    public useCaseViewPageController(ApexPages.StandardController controller) {
        useCaseSteps();
    }

    public List<Use_Case_Step__c> getShowTestStepsList(){ 

        if(useCaseStep != null){

            return useCaseStep;

        }else{

            return new List<Use_Case_Step__c>();

        }
    }
    
    
        public void useCaseSteps() {
            
            try{
            useCaseStep = [Select Id,Step_Number__c,Step_Description__c,Expected_Result__c
                           From Use_Case_Step__c
                           Where Use_Case__c =:ApexPages.CurrentPage().getParameters().get('Id') ORDER BY Step_Number__c ASC];
            
            
            if(useCaseStep == null || useCaseStep.size() <= 0 || (isTest!=null && isTest)){
                
                throw new UseCaseViewPageException('No use case steps found');
            }
            
            showUseCaseSteps = TRUE;
            showNoUseCaseStepsRecs = FALSE;

        }catch(Exception ex){

            System.debug('No Test Case Steps defined : '+ex.getMessage());
            showUseCaseSteps = FALSE;
            showNoUseCaseStepsRecs = TRUE;
        }
        
    }
    
    /*
    *Custom exception class
    */
    public class UseCaseViewPageException extends Exception {
        
 
    }

}