public with sharing class EditTestCaseExtension {
     Test_Case__c testcaseobj;
     public EditTestCaseExtension (ApexPages.StandardController controller) {
              testcaseobj=(Test_Case__c)controller.getRecord();
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
     testcase.Name = testcasecc.Name;
     testcase.Summary__c  = testcasecc.Summary__c ;
     testcase.Type__c = testcasecc.Type__c;
     testcase.Status__c  = testcasecc.Status__c ;
     testcase.Assigned_To__c = testcasecc.Assigned_To__c;
     testcase.Use_Case__c = testcase.Use_Case__c;
     }
    
  
  //--------------------- TestCaseStep Add/Remove -------------------------------------------
    public List<accountwrapper> testcasestepList = new List<accountwrapper>();
    
    List<Test_Case_Step__c> selectedtestcasesteps = new List<Test_Case_Step__c>();
        
    public List<accountwrapper> getTestCaseSteps()
    {   
        testcasestepList.clear();
        for(Test_Case_Step__c a : [select Id , Step_Number__c ,Step_Description__c ,Expected_Result__c ,Test_Case__c from Test_Case_Step__c where  
            Test_Case__c= :testcaseobj.Id order by Step_Number__c])
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
    
         if(obj.Step_Number__c==0)
          {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Number should not be Zero.'));
           return null;
         }
       
        else if(DuplicateStepNumber_AddClick())
        {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Number already Exists.'));
         return null;
        }
        else
        {
            InsertTestStep();
            obj.Step_Number__c = obj.Step_Number__c!=null?obj.Step_Number__c+1:1;
            obj.Step_Description__c = null;
            obj.Expected_Result__c = null;
            return null;
        }
    }
    //Function : Cancel Button Click
    public PageReference AddStep_Cancel() {
    obj.Step_Number__c = null;
    obj.Step_Description__c = null;
    obj.Expected_Result__c = null;
    return null;
    }
    
    
    public void InsertTestStep(){
    Test_Case_Step__c newtestcasestep = new Test_Case_Step__c();
            newtestcasestep.Step_Number__c = obj.Step_Number__c;
            newtestcasestep.Step_Description__c = obj.Step_Description__c;
            newtestcasestep.Expected_Result__c = obj.Expected_Result__c;
            newtestcasestep.Test_Case__c= testcaseobj.Id;
            if(Test_Case_Step__c.SObjectType.getDescribe().isCreateable())
                insert newtestcasestep;
    }
    
    //--------------------------------- Remove Selected TestCaseStep Record ---------------------------------------
        
     List <Test_Case_Step__c>  removeTestCaseStepList = new List <Test_Case_Step__c> ();
     List <Test_Case_Step__c>  tempTestStepList = new List <Test_Case_Step__c> ();
     
     
     public pagereference removeTestCaseStep() {
       System.debug('--Remove Called.--');
       for(accountwrapper accwrapper : testcasestepList)
        if(accwrapper.selected == true)
        removeTestCaseStepList.add(accwrapper.acc);
        if(removeTestCaseStepList.size()==testcasestepList.size())
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Atleast One Step should be associated with Test Case.'));
        removeTestCaseStepList.clear();
        return null;
        }
        else
        {
            if(Test_Case_Step__c.SObjectType.getDescribe().isDeletable()){
                delete  removeTestCaseStepList;
            }
            removeTestCaseStepList.clear();
            return null;
        }
        
      }
        
        
     //--------------------------------- Update Selected TestCaseStep Record ---------------------------------------
    
     List <Test_Case_Step__c> updatedTestStepList = new List <Test_Case_Step__c> ();
     public PageReference updateTestCaseStep() {
     if(ZeroStepNumber())
     {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Value should not be Zero.'));
     return null;
     }
     else if (DuplicateStepNumber())
     {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Value should not be Duplicate.'));
     return null;
     }
     else
     { 
     System.debug('testcasestepList-->>'+testcasestepList);
     for(accountwrapper accwrapper : testcasestepList)
        if(accwrapper.selected == true)
        updatedTestStepList.add(accwrapper.acc);
        Update updatedTestStepList;
        System.debug('updatedTestStepList-->>'+updatedTestStepList);
        updatedTestStepList.clear();
        return null;
     }
}

//--------------------------------- Supporting Methods --------------------------------
    Boolean flag = false ;
    List <Test_Case_Step__c> tempList = new List <Test_Case_Step__c>();
    
    
    Public boolean ZeroStepNumber()
    {
    for(accountwrapper accwrapper : testcasestepList)
    if(accwrapper.acc.step_Number__c == 0)
    {
    flag = true;
    break;
    }
    tempList.clear(); 
    return flag;
    }
   
   
   Public boolean DuplicateStepNumber()
    {
    for(accountwrapper accwrapper : testcasestepList)
        tempList.add(accwrapper.acc);
    flag=false;
    for(Integer i = 0 ; i< tempList.size();i++)
    {
    for(Integer j = i+1 ; j< tempList.size();j++)
     {
         if(tempList[i].step_number__c==tempList[j].step_number__c)
         flag = true;
         break;
     }
    }
   tempList.clear();
    return flag;
   }
   
   
    Public boolean DuplicateStepNumber_AddClick()
    {
    flag=false;
    for(accountwrapper accwrapper : testcasestepList)
        tempList.add(accwrapper.acc);
    
    for(Integer i = 0 ; i< tempList.size();i++)
    {
        if(tempList[i].step_number__c==obj.step_number__c)
         {
         flag = true;
         break;
         }
     }
    tempList.clear(); 
    return flag;
    }
   
   
   
   
}