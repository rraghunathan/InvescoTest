/**
*   @author Priyanka Sindhu
*   @date 27/02/2014
*   @description Class providing test data for test class

    Apex Class Name:  TestData 
    Version     : 1.0.1 
    Created Date: 27/02/2014
    Function    :  Class providing test data for test classes
    Modification Log :
    -----------------------------------------------------------------------------
    Developer                   Date                    Description
    ----------------------------------------------------------------------------                 
    
*/
public with sharing virtual class TestData {
    
    public List<User> users {get; set;}
    public Integer listSize {get;set;}
    
    /*
     * @Constructor
     * @param listSize Sets test records created count. 
     */ 
    public TestData(Integer listSize) {
        this.listSize = listSize;
    }

    /*
     * Method name      : runAsUser
     * @description     : 
     *                  : Method to create a User    
     * Return           : User
    */
    public static User runAsUser(String uniqueKey,String sRole) {
        return new User(
            Alias = uniqueKey,
            Email = uniqueKey + '@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test' + uniqueKey,
            FirstName = uniqueKey,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [select Id from Profile where Name = 'System Administrator' limit 1].Id,
            TimeZoneSidKey = 'America/Chicago',
            Username = uniqueKey + '@test' + Math.round(Math.random() * 10000) + '.com',
            UserRoleId = [select Id from UserRole where Name =: sRole limit 1].Id
         );
    }
    
    public static User newStnrdUser(String uniqueKey){
        return new User(
            Alias = uniqueKey,
            Email = uniqueKey + '@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test' + uniqueKey,
            FirstName = uniqueKey,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [select Id from Profile where Name = 'Standard User' limit 1].Id,
            TimeZoneSidKey = 'America/Chicago',
            Username = uniqueKey + '@test' + Math.round(Math.random() * 10000) + '.com',
            IsActive = true
           );
    }
    
    /*
    *  Method Name : createUsersData
    *  @description : creates users data
    */
    public void createUsersData(){
        users  = new List<User>();
        for(Integer i=0;i<listSize;i++){
              User u = TestData.newStnrdUser('s_User'+i);
              users.add(u);
        }
    
    }


}