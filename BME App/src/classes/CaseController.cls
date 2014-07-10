public with sharing class CaseController 
{
           public List<accountwrapper> testcasestepList {set; get;}
     public CaseController (ApexPages.StandardController controller) {
              testcase=(Test_Case__c)controller.getRecord();
              testcasestepList = new List<accountwrapper>();
              
    } 
    
    public CaseController(){
    
    }
    
    public PageReference CancelNewTestCase() {
    // Redirect user to the detail page for the new Case.
     PageReference casePage = new PageReference('/a05');
     casePage.setRedirect(true);
     return casePage ;
    
        
    }

    //No of Steps
     public Boolean noStepCount{ get; set; } 
    
    
    //--------------------- TestCase Add-------------------------------------------
    //Getter/Setter for Test Case valueshttps://na6.salesforce.com/s.gif
     Test_Case__c testcase = new Test_Case__c();
     public Test_Case__c gettestcase()
     {
     return testcase ;
     }
     public void settestcase(Test_Case__c testcasecc)
     {
     testcase.Test_Case_Name__c = testcasecc.Test_Case_Name__c;
     testcase.Summary__c  = testcasecc.Summary__c ;
     testcase.Type__c = testcasecc.Type__c;
     testcase.Status__c  = testcasecc.Status__c ;
     testcase.Assigned_To__c = testcasecc.Assigned_To__c;
     testcase.Use_Case__c = testcase.Use_Case__c;
     }
    
    //Save Test Case Record along with Test Case Steps
    Id testcaseid; 
    //Check whether Step Number entered is 0
    Public boolean ZeroStep(List<Test_Case_Step__c> alltestcasesteps)
    {
    Boolean flag = false;
    for(Test_case_Step__c teststep : alltestcasesteps)
    {
     if(teststep.step_number__c<=0)
     flag = true;
    }
    return flag;
    }
    
    //Check for Duplicate Step Number 
    Public boolean DuplicateStep(List<Test_Case_Step__c> alltestcasesteps)
    {
    Boolean flag = false;
    for(Integer i = 0 ; i< alltestcasesteps.size();i++)
    {
    for(Integer j = i+1 ; j< alltestcasesteps.size();j++)
     {
     if(alltestcasesteps[i].step_number__c==alltestcasesteps[j].step_number__c)
     flag = true;
     break;
     }
    }
    return flag;
    }
    
    Public Id InsertTestCase()
    {
    
    /*if(alltestcasesteps.size()== 0) {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must add atleast one step to the Test Case.'));
     return null;
     }
     else */if(ZeroStep(alltestcasesteps)==true)
     {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Number should be greater than 0.'));
     return null;
     }
     else if(DuplicateStep(alltestcasesteps)==true)
     {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Number should be Unque.'));
     return null;
     }
     else
     {
     Test_Case__c newtestcase = new Test_Case__c();
     newtestcase.Test_Case_Name__c = testcase.Test_Case_Name__c;
     newtestcase.Summary__c = testcase.Summary__c;
     newtestcase.Type__c = testcase.Type__c;
     newtestcase.Status__c = testcase.Status__c;
     newtestcase.Assigned_To__c = testcase.Assigned_To__c;
     newtestcase.Use_Case__c = testcase.Use_Case__c;
     Database.SaveResult sr;
     if(Test_Case__c.SObjectType.getDescribe().isCreateable())
         sr = Database.insert(newtestcase,false);
     
     //Insert TestCaseStep Records along with TestCase Id
     if(sr.isSuccess())
     {
     for(Integer stepcount=0;stepcount<alltestcasesteps.size();stepcount++)
         alltestcasesteps[stepcount].Test_Case__c = newtestcase.id ;
     if(Test_Case_Step__c.SObjectType.getDescribe().isCreateable())
         insert alltestcasesteps;
     alltestcasesteps.clear();
     }
     return newtestcase.id;
    }
    }
    
    public PageReference SaveTestCase() {
     testcaseid = InsertTestCase();
     System.debug('@@@@@@@@testcaseId'+ testcaseId);
     if(testcaseid != null)
     {
     // Redirect user to the detail page for the new Case.
     PageReference casePage = new PageReference('/' + testcaseid );
     casePage.setRedirect(true);
     return casePage ;
     }
     else
     return null;
    }
    
    public PageReference SaveAndNewTestCase() {
   
     testcaseid = InsertTestCase();
     
     if(testcaseid != null)
     {
     //Redirect user to the UserCase Visualforce page for the new Case Creation.
     PageReference casePage = new PageReference('/apex/addtestcase');
     casePage.setRedirect(true);
     return casePage ;
     }
     else
     return null;
    }
    
     public PageReference CancelTestCase()
     {
     //Redirect user to the UserCase Visualforce page for the new Case Creation.
     PageReference casePage = new PageReference('/a05/o');
     casePage.setRedirect(true);
     return casePage ;
     }
    
    
  //--------------------- TestCaseStep Add/Remove -------------------------------------------
    List<Test_Case_Step__c> alltestcasesteps = new List<Test_Case_Step__c>();
    List<Test_Case_Step__c> selectedtestcasesteps = new List<Test_Case_Step__c>();
        
    public List<accountwrapper> getTestCaseSteps()
    {   
        testcasestepList.clear();
        for(Test_Case_Step__c a : alltestcasesteps)
        testcasestepList.add(new accountwrapper(a));
        return testcasestepList;
    }
    
    public PageReference getSelected()
    {
        selectedtestcasesteps.clear();
        for(accountwrapper accwrapper : testcasestepList )
        if(accwrapper.selected == true)
        selectedtestcasesteps.add(accwrapper.acc);
        return null;
    }
    
    public List<Test_Case_Step__c> GetSelectedAccounts()
    {
        if(selectedtestcasesteps.size()>0)
        return selectedtestcasesteps;
        else
        return null;
    }    
    
    public class accountwrapper
    {
        public Test_Case_Step__c acc{get; set;}
        public Boolean selected {get; set;}
        public accountwrapper(Test_Case_Step__c a)
        {
            acc = a;
            selected = false;
        }
    }
    
    //------------------------------- Add new TestCaseStep Record ----------------------------------------------------
    //Getter/Setter for Test Step values
     Test_Case_Step__c obj = new Test_Case_Step__c();
     public Test_Case_Step__c getobj()
     {
     return obj;
     }
     public void setobj(Test_Case_Step__c objcc)
     {
     obj.Step_Number__c = objcc.Step_Number__c;
     obj.Step_Description__c = objcc.Step_Description__c;
     obj.Expected_Result__c = objcc.Expected_Result__c;
     }
  
    public PageReference AddTestCaseStep() {
    System.debug('--Add TestStep--');
    Test_Case_Step__c newtestcasestep = new Test_Case_Step__c();
    newtestcasestep.Step_Number__c = obj.Step_Number__c;
    newtestcasestep.Step_Description__c = obj.Step_Description__c;
    newtestcasestep.Expected_Result__c = obj.Expected_Result__c;
    alltestcasesteps.add(newtestcasestep);
    System.debug('--alltestcasesteps--'+alltestcasesteps);
    nostepcount = true;
    
    obj.Step_Number__c = obj.Step_Number__c+1;
    obj.Step_Description__c = null;
    obj.Expected_Result__c = null;
    return null;
    }
    
    public PageReference AddStep_Cancel() {
    obj.Clear();
    return null;

    }
    
    //--------------------------------- Remove Selected TestCaseStep Record ---------------------------------------
    // Remove Function 
     
     List <Test_Case_Step__c>  removeTestCaseStepList = new List <Test_Case_Step__c> ();
     List <Test_Case_Step__c>  tempTestStepList = new List <Test_Case_Step__c> ();
     
     
     public pagereference removeTestCaseStep() {
       
       System.debug('--Remove Called.--');
       for(accountwrapper accwrapper : testcasestepList)
        if(accwrapper.selected == true)
        removeTestCaseStepList.add(accwrapper.acc);
         for(Integer i=0;i<removeTestCaseStepList.size();i++)
         {
         for(Integer j=0;j<alltestcasesteps.size();j++)
         {
         if(removeTestCaseStepList[i]==alltestcasesteps[j])
         alltestcasesteps.remove(j);
         
         }
        }
        //No of Steps
        if(alltestcasesteps.size()==0)
        noStepCount = false;      
        return null ;
        }
     //--------------------------------- Update Selected TestCaseStep Record ---------------------------------------
    //Update Function 
     List <Test_Case_Step__c> updatedTestStepList = new List <Test_Case_Step__c> ();
     public PageReference updateTestCaseStep() {
     return null;
}


    
     
     
}