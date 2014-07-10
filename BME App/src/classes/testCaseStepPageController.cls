public with sharing class testCaseStepPageController {

    public Test_Case_Result__c testCaseStepResult = new Test_Case_Result__c();
    public List<Test_Case_Result__c> testCaseResultList ;
    public List<Test_Case_Result__c> getTestCaseStepResults() {

        if(testCaseResultList == null){
            testCaseResultList  = new List<Test_Case_Result__c>();
            testCaseStepResult.Result_By__c = UserInfo.getUserId();
            testCaseStepResult.Tested_On__c = System.Today();
            testCaseStepResult.Test_Case_Step__c = ApexPages.currentPage().getParameters().get('stepId');

            testCaseResultList.add(testCaseStepResult);    
        }
        return testCaseResultList;
    }

    public PageReference createTestCaseStepResult(){

        try{

            System.debug('@@@@@@createDefect '+createDefect);

            // Creating a defect if CreateDefect checkbox is checked
            if(createDefect == TRUE){
                defectRec.Defect_Status__c = 'Submitted';
                defectRec.Open_Date__c = System.Today();
                defectRec.Test_Case_Step__c = ApexPages.currentPage().getParameters().get('stepId');

                if(testCaseResultList != null){
                    if(Test_Case_Result__c.SObjectType.getDescribe().isCreateable())
                        insert testCaseResultList.get(0);

                    if(Defect__c.SObjectType.getDescribe().isCreateable())
                        insert defectRec;
                }

            }
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return null;
    }

    public Boolean createDefect = FALSE;

    public Boolean getCreateDefect(){
        return createDefect;
    }

    public void setCreateDefect(Boolean createDefect){ this.createDefect = createDefect; }

    public Defect__c defectRec = new Defect__c();
    public Defect__c getdefectRec(){ return defectRec;}
    public void setdefectRec(Defect__c defectRec){ this.defectRec = defectRec;}

    public PageReference showCreateDefectSection(){
        if(testCaseStepResult.Status__c =='Failed'){
            createDefect = TRUE;
        }else {
            createDefect = FALSE;       
        }

        System.debug('in defect create method : '+createDefect);
        return null;
    }

    Public static testMethod void testCaseStepPageControllerTest(){
        Profile p = [select id from profile where name='System Administrator']; 
        User u = new User(alias = 'standt', email='user@bme.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id,  
                timezonesidkey='America/Los_Angeles', username='user@bme.com');
        Defect__c TestdefectRec = new Defect__c();
        System.runAs(u) {
            //Test data
            testCaseStepPageController testcasesteppagecontroller = new testCaseStepPageController(); 


            testcasesteppagecontroller.getCreateDefect();
            testcasesteppagecontroller.setCreateDefect(true);
            testcasesteppagecontroller.showCreateDefectSection();
            testcasesteppagecontroller.createDefect= true;
            testcasesteppagecontroller.createTestCaseStepResult();
            testcasesteppagecontroller.getTestCaseStepResults();
            testcasesteppagecontroller.getdefectRec();
            testcasesteppagecontroller.setdefectRec(TestdefectRec); 
            
            testCaseStepPageController testcasesteppagecontroller1 = new testCaseStepPageController(); 
            Test_Case_Result__c testCaseStepResult = new Test_Case_Result__c();
            testcasesteppagecontroller1.testCaseStepResult.Status__c ='Failed';
            testcasesteppagecontroller1.showCreateDefectSection();
            
            testCaseStepPageController testcasesteppagecontroller2 = new testCaseStepPageController(); 
            testcasesteppagecontroller2.createDefect= true;
            testcasesteppagecontroller2.getTestCaseStepResults();
            testcasesteppagecontroller2.createTestCaseStepResult();
            testcasesteppagecontroller2.testCaseStepResult = null;
            testcasesteppagecontroller2.createTestCaseStepResult();
        }
    }
}