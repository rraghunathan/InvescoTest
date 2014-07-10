public with sharing class AddTestCaseStepResultsController {
    public Test_Case_Result__c tsResult = new Test_Case_Result__c();
    public PageReference editRecord() {
        tsResult = [select Id,Result_By__c,Comments__c,Tested_On__c,Status__c from Test_Case_Result__c where Id =: SelecteResultRecord];
        return null;
    }


    public PageReference editResult() {
        update tsResult;
        return null;
    }

    
    public boolean addrecord { get; set; }
    public String SelecteResultRecord {get;set;}
    
    public PageReference Cancel_Click() {
    PageReference casePage = new PageReference('/'+testcaseId);
    casePage.setRedirect(true);
    return casePage ;
    }
    public String SelecteResultId {get;set;}
    public String SelecteStepId {get;set;}
    public PageReference DeleteResult() {
        if (SelecteResultRecord == null) {              
            return null;      
        }
        System.debug('The Result Id is '+SelecteResultId);
        Test_Case_Result__c tobeDeleted = new Test_Case_Result__c (Id = SelecteResultRecord );     
        if(Test_Case_Result__c.SObjectType.getDescribe().isDeletable()){
            delete tobeDeleted;
        }
        LoadData();  
        return null;                               
    }
        
    
    public PageReference addNewResult() {        
        Test_Case_Result__c result = new Test_Case_Result__c();
        result.Result_By__c = tsResult.Result_By__c;
        result.Tested_On__c = tsResult.Tested_On__c;
        result.Status__c = tsResult.Status__c;
        result.Test_Case_Step__c = SelecteStepId;
        result.Comments__c = tsResult.Comments__c;
        if(Test_Case_Result__c.SObjectType.getDescribe().isCreateable()){
            Insert result;
        }
        LoadData();
        return null;
    }
    public string selectedCase{get;set;}
    public string selectedResult{get;set;}
    public String getUserInfo() {
        return UserInfo.getName();
    }


    public Test_Case_Result__c getTestResult() {
        if(addrecord == true){ 
         tsResult = new Test_Case_Result__c();  
         tsResult.Result_By__c =  UserInfo.getUserId();
         tsResult.Tested_On__c =  Date.today();
         tsResult.Status__c    = 'N/A';
         } 
        return tsResult;
    }


    
    
    Id testcaseId = ApexPages.currentPage().getParameters().get('id');
    //------------------------------- Show TestCase Record ----------------------------------------------------
     //Getter/Setter for Test Case values
     Test_Case__c testcase = new Test_Case__c();
     public Test_Case__c gettestcase()
     {
     System.debug('@@@@@@@@@@testcaseId '+testcaseId);
     testcase = [select Id ,CreatedById,OwnerId,LastModifiedById,Name ,Use_Case__c, Test_Case_No__c, Summary__c , Type__c ,Status__c ,Assigned_To__c from Test_Case__c where Id = :testcaseId];
     return testcase ;
     }
     public void settestcase(Test_Case__c testcasecc)
     {
     testcase.Name = testcasecc.Name;
     testcase.Summary__c  = testcasecc.Summary__c ;
     testcase.Type__c = testcasecc.Type__c;
     testcase.Status__c  = testcasecc.Status__c ;
     testcase.Assigned_To__c = testcasecc.Assigned_To__c;
     }
     
    //------------------------------- Show TestCaseStep Record ----------------------------------------------------
    //Getter/Setter for Test Step values
     List<Test_Case_Step__c> TestCaseSteps= new List<Test_Case_Step__c>();
     public void LoadData(){
         TestCaseSteps = [select (Select Id,Status__c, Comments__c,Result_By__r.Name, Tested_On__c From Test_Case_Results__r order by Tested_On__c asc),Name ,Step_Description__c , Step_Number__c,Expected_Result__c from Test_Case_Step__c  where Test_Case__c = :testcaseId order by Step_Number__c asc];
         
     }
     public List<Test_Case_Step__c> getTestCaseSteps()
     {
         LoadData(); 
         return TestCaseSteps;
     }
     public void setTestCaseSteps(List<Test_Case_Step__c> objcc)
     {
     TestCaseSteps = objcc ;
     }
    
   //------------------------------- Show TestCaseStepResult Record ----------------------------------------------------
    //Getter/Setter for Test Step Result values
     List<Test_Case_Result__c> TestCaseStepResultsList = new List<Test_Case_Result__c>();
     public List<Test_Case_Result__c> getTestCaseStepResults()
     {
     TestCaseStepResultsList = [select Name , Comments__c ,Test_Case_Step__c , Result_By__c , Tested_on__c from Test_Case_Result__c where Test_Case_Step__c IN:TestCaseSteps order by Test_Case_Step__c];
     return TestCaseStepResultsList ;
     }
     public void setTestCaseResults(List<Test_Case_Result__c> objcc)
     {
     TestCaseStepResultsList = objcc;
     }
     
     
     //------------------------------- Add TestCaseStepResult Record ----------------------------------------------------
     
     
     //Getter/Setter for Test Step values
     Test_Case_Result__c testcaseresultobj = new Test_Case_Result__c();
     
     public Test_Case_Result__c gettestcaseresultobj()
     {
     return testcaseresultobj;
     }
     
     public void settestcaseresultobj(Test_Case_Result__c testcaseresultobjcc)
     {
     testcaseresultobj.Test_Case_Step__c = testcaseresultobjcc.Test_Case_Step__c;
     testcaseresultobj.Tested_on__c  = testcaseresultobjcc.Tested_on__c;
     testcaseresultobj.Result_By__c  = testcaseresultobjcc.Result_By__c;
     testcaseresultobj.status__c = testcaseresultobjcc.status__c;
     testcaseresultobj.Comments__c = testcaseresultobjcc.Comments__c;
     }
    
     public PageReference AddTestCaseStepResult() {
     System.debug('Add Clicked-->>');
     
     Test_Case_Result__c newtestcaseresult = new Test_Case_Result__c();
     //newtestcaseresult.Test_Case_Step__c = selId ;
     newtestcaseresult.Test_Case_Step__c = testcaseresultobj.Test_Case_Step__c;
     newtestcaseresult.Tested_on__c  = testcaseresultobj.Tested_on__c;
     newtestcaseresult.Result_By__c  = testcaseresultobj.Result_By__c;
     newtestcaseresult.Comments__c = testcaseresultobj.Comments__c;
     if(Test_Case_Result__c.SObjectType.getDescribe().isCreateable())
         insert newtestcaseresult; 
     testcaseresultobj.Test_Case_Step__c = null;
     testcaseresultobj.Result_By__c = null;
     testcaseresultobj.status__c = null;
     testcaseresultobj.Comments__c = null;
     return null;
     }
    
     public PageReference CancelTestCaseStepResult() {
     testcaseresultobj.Test_Case_Step__c = null;
     testcaseresultobj.Tested_on__c = null ;
     testcaseresultobj.Result_By__c = null;
     
     
     return null;
    }
    

  }