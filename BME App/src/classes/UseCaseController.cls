public with sharing class UseCaseController 
{
    public boolean zrStp {set; get;}
    public boolean dpStp {set; get;}
    public Integer usCcsSize {set; get;} 
    //Save Use Case Record along with Use Case Steps
    public Id usecaseid{set; get;}
    public List<accountwrapper> usecasestepList {set; get;}
    public List<Use_Case_Step__c> allusecasesteps {set; get;}
    public List <Use_Case_Step__c>  removeUseCaseStepList {set; get;}
    
    /*
    *constructor for initialization
    */
    public UseCaseController (ApexPages.StandardController controller) {
              usecase=(Use_Case__c)controller.getRecord();
              usecasestepList = new List<accountwrapper>();
              allusecasesteps = new List<Use_Case_Step__c>();
              removeUseCaseStepList  = new List <Use_Case_Step__c> ();
              
    }
    public UseCaseController(){
        usecasestepList = new List<accountwrapper>();
        allusecasesteps = new List<Use_Case_Step__c>();
        removeUseCaseStepList  = new List <Use_Case_Step__c> ();
    }
    
    public PageReference CancelNewUseCase() {
    // Redirect user to the detail page for the new Case.
     PageReference casePage = new PageReference('/a06');
     casePage.setRedirect(true);
     return casePage ;
    
        
    }

    //No of Steps
     public Boolean noStepCount{ get; set; } 
    
    
    //--------------------- UseCase Add-------------------------------------------
    //Getter/Setter for Use Case valueshttps://na6.salesforce.com/s.gif
     Use_Case__c usecase = new Use_Case__c();
     public Use_Case__c getusecase()
     {
     return usecase ;
     }
     public void setusecase(Use_Case__c usecasecc)
     {
     usecase.Use_Case_Name__c = usecasecc.Use_Case_Name__c;
     usecase.Related_Use_Case__c = usecasecc.Related_Use_Case__c;
     usecase.Signed_off_on__c  = usecasecc.Signed_off_on__c ;
    
     usecase.Actor__c = usecasecc.Actor__c;
     usecase.System_Touch_points__c = usecasecc.System_Touch_points__c;
     usecase.Trigger__c = usecasecc.Trigger__c;

     usecase.Assumptions__c = usecasecc.Assumptions__c;
     usecase.Pre_condition__c = usecasecc.Pre_condition__c;
     usecase.Process_Dependencies__c = usecasecc.Process_Dependencies__c;
     usecase.Post_Condition__c = usecasecc.Post_Condition__c;

     }
    
    
    //Check whether Step Number entered is 0
    Public boolean ZeroStep(List<Use_Case_Step__c> allusecasesteps)
    {
    Boolean flag = false;
    for(Use_case_Step__c usestep : allusecasesteps)
    {
     if(usestep.step_number__c<=0)
     flag = true;
    }
    return flag;
    }
    
    //Check for Duplicate Step Number 
    Public boolean DuplicateStep(List<Use_Case_Step__c> allusecasesteps)
    {
    Boolean flag = false;
    for(Integer i = 0 ; i< allusecasesteps.size();i++)
    {
    for(Integer j = i+1 ; j< allusecasesteps.size();j++)
     {
     if(allusecasesteps[i].step_number__c==allusecasesteps[j].step_number__c)
     flag = true;
     break;
     }
    }
    return flag;
    }
    
    Public Id InsertUseCase()
    {
        
    /*if(usCcsSize == 0) {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must add atleast one step to the Use Case.'));
     return null;
     }
     else */
     if(zrStp != null && zrStp)
     {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Number should be greater than 0.'));
     return null;
     }
     else if(dpStp != null && dpStp)
     {
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Step Number should be Unque.'));
     return null;
     }
     else
     {
     Use_Case__c newusecase = new Use_Case__c();
     newusecase.Use_Case_Name__c = usecase.Use_Case_Name__c;
     newusecase.Related_Use_Case__c = usecase.Related_Use_Case__c;
     newusecase.Signed_off_on__c  = usecase.Signed_off_on__c ;
     newusecase.Work_Package__c = usecase.Work_Package__c;
    
     newusecase.Actor__c = usecase.Actor__c;
     newusecase.System_Touch_points__c = usecase.System_Touch_points__c;
      
     newusecase.Trigger__c = usecase.Trigger__c;
     newusecase.Assumptions__c = usecase.Assumptions__c;
     newusecase.Pre_condition__c = usecase.Pre_condition__c;
     newusecase.Process_Dependencies__c = usecase.Process_Dependencies__c;
     newusecase.Post_Condition__c = usecase.Post_Condition__c;
     
     Database.SaveResult sr;
     if(Use_Case__c.SObjectType.getDescribe().isCreateable())
         sr = Database.insert(newusecase,false);
     System.debug('isSuccess-------------------->'+sr.getErrors());
     //Insert UseCaseStep Records along with UseCase Id
     if(sr.isSuccess())
     {
     for(Integer stepcount=0;stepcount<allusecasesteps.size();stepcount++)
         allusecasesteps[stepcount].Use_Case__c = newusecase.id ;
     if(Use_Case_Step__c.SObjectType.getDescribe().isCreateable())
         insert allusecasesteps;
     allusecasesteps.clear();
     }
     return newusecase.id;
    }
    }
    
    public PageReference SaveUseCase() {
     usCcsSize = allusecasesteps.size();
     zrStp = ZeroStep(allusecasesteps);
     dpStp = DuplicateStep(allusecasesteps); 
     System.debug('usecaseid---------------------->'+usecaseid);
     if(usecaseid == null) {
       usecaseid = InsertUseCase();
     }
     if(usecaseid != null)
     {
     // Redirect user to the detail page for the new Case.
     PageReference casePage = new PageReference('/' + usecaseid );
     casePage.setRedirect(true);
     return casePage ;
     }
     else
     return null;
    }
    
    public PageReference SaveAndNewUseCase() {
     usCcsSize = allusecasesteps.size();
     zrStp = ZeroStep(allusecasesteps);
     dpStp = DuplicateStep(allusecasesteps);
     if(usecaseid == null) {
        usecaseid = InsertUseCase();
     }
     if(usecaseid != null)
     {
     //Redirect user to the UserCase Visualforce page for the new Case Creation.
     PageReference casePage = new PageReference('/apex/addusecase');
     casePage.setRedirect(true);
     return casePage ;
     }
     else
     return null;
    }
    
     public PageReference CancelUseCase()
     {
     //Redirect user to the UserCase Visualforce page for the new Case Creation.
     PageReference casePage = new PageReference('/a05/o');
     casePage.setRedirect(true);
     return casePage ;
     }
    
    
  //--------------------- UseCaseStep Add/Remove -------------------------------------------
    List<Use_Case_Step__c> selectedusecasesteps = new List<Use_Case_Step__c>();
        
    public List<accountwrapper> getUseCaseSteps()
    {   
        usecasestepList.clear();
        for(Use_Case_Step__c a : allusecasesteps)
        usecasestepList.add(new accountwrapper(a));
        return usecasestepList;
    }
    
    public PageReference getSelected()
    {
        selectedusecasesteps.clear();
        for(accountwrapper accwrapper : usecasestepList )
        if(accwrapper.selected == true)
        selectedusecasesteps.add(accwrapper.acc);
        return null;
    }
    
    public List<Use_Case_Step__c> GetSelectedAccounts()
    {
        if(selectedusecasesteps.size()>0)
        return selectedusecasesteps;
        else
        return null;
    }    
    
    public class accountwrapper
    {
        public Use_Case_Step__c acc{get; set;}
        public Boolean selected {get; set;}
        public accountwrapper(Use_Case_Step__c a)
        {
            acc = a;
            selected = false;
        }
    }
    
    //------------------------------- Add new UseCaseStep Record ----------------------------------------------------
    //Getter/Setter for Use Step values
     Use_Case_Step__c obj = new Use_Case_Step__c();
     public Use_Case_Step__c getobj()
     {
     return obj;
     }
     public void setobj(Use_Case_Step__c objcc)
     {
     obj.Step_Number__c = objcc.Step_Number__c;
     obj.Step_Description__c = objcc.Step_Description__c;
     obj.Expected_Result__c = objcc.Expected_Result__c;
     }
  
    public PageReference AddUseCaseStep() {
    System.debug('--Add UseStep--');
    Use_Case_Step__c newusecasestep = new Use_Case_Step__c();
    newusecasestep.Step_Number__c = obj.Step_Number__c;
    newusecasestep.Step_Description__c = obj.Step_Description__c;
    newusecasestep.Expected_Result__c = obj.Expected_Result__c;
    allusecasesteps.add(newusecasestep);
    System.debug('--allusecasesteps--'+allusecasesteps);
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
    
    //--------------------------------- Remove Selected UseCaseStep Record ---------------------------------------
    // Remove Function 
     
     
     List <Use_Case_Step__c>  tempUseStepList = new List <Use_Case_Step__c> ();
     
     
     public pagereference removeUseCaseStep() {
       
       System.debug('--Remove Called.--');
       for(accountwrapper accwrapper : usecasestepList)
        if(accwrapper.selected == true)
        removeUseCaseStepList.add(accwrapper.acc);
         for(Integer i=0;i<removeUseCaseStepList.size();i++)
         {
         for(Integer j=0;j<allusecasesteps.size();j++)
         {
         if(removeUseCaseStepList[i]==allusecasesteps[j])
         allusecasesteps.remove(j);
         
         }
        }
        //No of Steps
        if(allusecasesteps.size()==0)
        noStepCount = false;      
        return null ;
        }
     //--------------------------------- Update Selected UseCaseStep Record ---------------------------------------
    //Update Function 
     List <Use_Case_Step__c> updatedUseStepList = new List <Use_Case_Step__c> ();
     public PageReference updateUseCaseStep() {
     return null;
}

 Public static testMethod void UseCaseControllerTest(){
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
             
                         
            ApexPages.StandardController stdController = new ApexPages.StandardController(usecaseObj);
            UseCaseController usecasecontroller1 = new UseCaseController (stdController); 
            
            UseCaseController usecasecontroller = new UseCaseController (); 
            usecasecontroller.usecaseid = usecaseObj.Id;
            usecasecontroller.CancelNewUseCase();
            usecasecontroller.getusecase();
            usecasecontroller.setusecase(usecaseObj);
            usecasecontroller.ZeroStep(usecaseList );
            usecasecontroller.DuplicateStep(usecaseList);
            usecasecontroller.InsertUseCase();
            usecasecontroller.SaveUseCase();
            usecasecontroller.SaveAndNewUseCase();
            usecasecontroller.CancelUseCase();
            usecasecontroller.getUseCaseSteps();
            usecasecontroller.getSelected();
            usecasecontroller.GetSelectedAccounts();
            usecasecontroller.getobj();
            usecasecontroller.setobj(UseCaseStepObj);
            usecasecontroller.AddUseCaseStep();
            usecasecontroller.AddStep_Cancel();
            usecasecontroller.removeUseCaseStep();
            usecasecontroller.updateUseCaseStep();
             }
           }

    
     
}