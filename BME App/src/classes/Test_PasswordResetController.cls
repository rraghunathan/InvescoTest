/* Class Name : TestClass_PasswordResetController 
 * Description  : Test class for an Apex class PasswordResetController
 * Created By   : Deepika Rawat
 * Created On  : 01/27/2014

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Modification ID        Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Priyanka Sindhu         27/02/2014              Added custom data to avoid dependency on organization's data
*/

@isTest(seeAllData=false)
private class Test_PasswordResetController {
    
    public static User userObj = [select UserName, FirstName, LastName, Email,UserRoleId, ProfileId, profile.Name, UserRole.Name from User where id = :UserInfo.getUserId()];
    public static String profileName;
    public static String rolename;
    public static UserRole userRole = [SELECT Id, Name FROM UserRole limit 1];
    public static Profile userProfile  = [SELECT Id, Name FROM Profile limit 1];
    
    
    public Class LocalData{
        Public List<User> usrList {get;set;}
        
        public LocalData(){
            usrList = new list<User>();
            
            TestData setUpData = new TestData(10);
            setUpData.createUsersData();
            usrList = setUpData.users;
        }
    
    }
    
    static testmethod void testUserSearch(){
        LocalData td = new LocalData();
        test.startTest(); 
            Apexpages.currentPage().getParameters().put('firstname',userObj.firstName);
            Apexpages.currentPage().getParameters().put('LastName',userObj.LastName);
            Apexpages.currentPage().getParameters().put('email',userObj.email);
            Apexpages.currentPage().getParameters().put('profileName',userObj.Profile.name);
            Apexpages.currentPage().getParameters().put('roleName',userObj.UserRole.Name);
            Apexpages.currentPage().getParameters().put('alpha','All');
            
            ApexPages.StandardController controller = new ApexPages.StandardController(userObj); 
            PasswordResetController userSearchObj = new PasswordResetController(controller);
            
            
            ApexPages.StandardSetController con = new ApexPages.StandardSetController(td.usrList); 

            PasswordResetController.UserWrapper wrprObj = new PasswordResetController.UserWrapper(userObj,true);       
            userSearchObj.runAlphaSearch();
            userSearchObj.toggleSort();
        test.stopTest(); 
        
        System.assertEquals(userSearchObj.con.getRecords().size(), 1);    
    }
    
    static testmethod void testResetPswrd(){
        LocalData td = new LocalData();
        test.startTest();
            ApexPages.StandardController controller = new ApexPages.StandardController(userObj); 
            PasswordResetController userSearchObj = new PasswordResetController(controller);
            PasswordResetController.UserWrapper wrprObj = new PasswordResetController.UserWrapper(userObj,true);
            userSearchObj.selectedUsers.add(userObj.id);
            userSearchObj.password = 'TestingPassword';
            userSearchObj.doSetPassword();
            userSearchObj.resetUserPassword();
        test.stopTest();
   }
    
   static testmethod void testResetPswrdNoValue(){
        LocalData td = new LocalData();
        test.startTest();
            Apexpages.currentPage().getParameters().put('alpha',userObj.LastName.subString(0,1));
            ApexPages.StandardController controller = new ApexPages.StandardController(userObj); 
            PasswordResetController userSearchObj = new PasswordResetController(controller);
            PasswordResetController.UserWrapper wrprObj = new PasswordResetController.UserWrapper(userObj,true);
            userSearchObj.lstUser = userSearchObj.AllSearchUsers;
            userSearchObj.doSelectedUsers();
            userSearchObj.runAlphaSearch();
            userSearchObj.doSetPassword();
            userSearchObj.resetUserPassword(); 
            userSearchObj.setPasswordshow();
            userSearchObj.setPasswordshow(); 
        test.stopTest();   
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
        System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        } 
    }
    
    static testmethod void testRstPswrdWithWrongValue(){
        LocalData td = new LocalData();
        test.startTest();
            Apexpages.currentPage().getParameters().put('alpha','All');
            ApexPages.StandardController controller = new ApexPages.StandardController(userObj); 
            PasswordResetController userSearchObj = new PasswordResetController(controller);
            PasswordResetController.UserWrapper wrprObj = new PasswordResetController.UserWrapper(userObj,true);
            userSearchObj.lstUser = userSearchObj.AllSearchUsers;
            userSearchObj.doSelectedUsers();
            userSearchObj.password = 'test';
            userSearchObj.doSetPassword();
            userSearchObj.resetUserPassword();
        test.stopTest();
        
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        } 
    }
    
    static testmethod void testRstPswrdWithNoUser(){
        LocalData td = new LocalData();
        test.startTest();
            Apexpages.currentPage().getParameters().put('email','fl');
            ApexPages.StandardController controller = new ApexPages.StandardController(userObj); 
            PasswordResetController userSearchObj = new PasswordResetController(controller);
            PasswordResetController.UserWrapper wrprObj = new PasswordResetController.UserWrapper(userObj,false);
            userSearchObj.password = 'Test';
            userSearchObj.doSetPassword();
            userSearchObj.resetUserPassword();
        test.stopTest();
        List<ApexPages.Message> msgList = ApexPages.getMessages();
        
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        } 
    }
    
    
    static testmethod void testGetterMethods(){ 
        LocalData td = new LocalData();       
        test.startTest();
            ApexPages.StandardController controller = new ApexPages.StandardController(userObj);         
            PasswordResetController userSearchObj = new PasswordResetController(controller);
            list<string> stringList = new list<string> ();
            stringList = userSearchObj.profileList;
            stringList = userSearchObj.roleList;
            Boolean b = userSearchObj.hasNext;
            b = userSearchObj.hasPrevious;
            integer i = userSearchObj.pageNumber;
            userSearchObj.first();
            userSearchObj.last();
            userSearchObj.previous();
            userSearchObj.next();
            userSearchObj.cancel();
            userSearchObj.selectedUsers.add(userObj.id);
            userSearchObj.lstUser = userSearchObj.AllSearchUsers;
        test.stopTest();
    }
   
}