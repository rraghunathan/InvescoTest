/* Class Name     : PasswordResetController
 * Description    : This controller sets the password for multiple users at a given time.    
 * Developed By   : 
 * Created Date   : 01-16-2014

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                 Modification ID        Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * 
*/
public with sharing class PasswordResetController{
    // the soql without the order and limit
    public String soql {get;set;}
    public String Password { get; set; }
    // the collection of users to display
    public List<User> users {get;set;}
    public List<userWrapper> lstUser {get;set;}
    public Set<Id> selectedUsers {get;set;}
    public String chkUser{get;set;}
    public list<String> alphabetList{get;set;}
    public Boolean advancedFilter {get;set;}
    public String advancedSoql {get;set;}
    public String withoutFilterSoql {get;set;}
    public Decimal totalSize{get;set;}
    //Instantiate the StandardSetController  
    public ApexPages.StandardSetController con{get; set;}  
    public Boolean showSetPassword{get;set;} 
    public Boolean noRecords {get;set;}
    public integer selectedUserSize{get;set;}
      
    public PasswordResetController(ApexPages.StandardController controller) {
        
        selectedUserSize = 0;
        showSetPassword = true;
        noRecords = false;
        soql = 'Select UserRole.Name, UserRoleId, Profile.Name, ProfileId, LastName, FirstName From User where LastName != null';
        this.selectedUsers = new Set<Id>();
        advancedFilter = false;
        alphabetList = new list<String>{'All','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        runSearch();
    }
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
     
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
        set;
    }
    
    
    public PageReference doSelectedUsers(){
        this.selectedUsers.clear();
        for(UserWrapper uWrap: lstUser){
            if(uWrap.isSelected == true){
                this.selectedUsers.add(uWrap.uRec.Id);
            }
        }
        showSetPassword = true;
        selectedUserSize = selectedUsers.size();
        return null;
    }
     
     
     // toggles the sorting of query from asc<-->desc
     public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runSearch();
        // run the query again
        //runQuery();
     }
     
     
     // runs the search with parameters passed via Javascript
     public PageReference runAlphaSearch() {
         String alphaChar = Apexpages.currentPage().getParameters().get('alpha');
         
         String s;
         if(alphaChar!=null && !alphaChar.equals('')){
              if(alphaChar.equals('All')){
                  s ='';
              }else{
                  s = alphaChar;
              }
         }
         if(advancedSoql!=null && advancedSoql!='' && advancedFilter == true){
             soql = advancedSoql;
         }else if(withoutFilterSoql !=null && withoutFilterSoql !=''){
             soql  = withoutFilterSoql ;
         }
         soql += ' and '+sortField+' LIKE \''+String.escapeSingleQuotes(s)+'%\'';
         soql += '  ORDER BY ' +sortField + ' ' +sortDir ;
         con = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
          // sets the number of records in each page set  
         con.setPageSize(10); 
         return null;
     }
     
     // runs the search with parameters passed via Javascript
     public PageReference runSearch() {
             String firstName = Apexpages.currentPage().getParameters().get('firstname');
             String lastName = Apexpages.currentPage().getParameters().get('lastname');
             String profileName = Apexpages.currentPage().getParameters().get('profileName');
             String roleName = Apexpages.currentPage().getParameters().get('roleName');
             String email = Apexpages.currentPage().getParameters().get('email');
             advancedFilter = false;
             soql = 'Select UserRole.Name, UserRoleId, Profile.Name, ProfileId, Name, Email,LastName, FirstName From User where LastName != null';
             if(firstName!=null && !firstName.equals('')){
                  soql += ' and firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
                  advancedFilter = true;
                  advancedSoql = soql;
             }
             if(lastName!=null && !lastName.equals('')){
                  soql += ' and lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
                  advancedFilter = true;
                  advancedSoql = soql;
             }
             if(profileName!=null && !profileName.equals('') && !profileName.equals('All')){
                  soql += ' and Profile.Name LIKE \''+String.escapeSingleQuotes(profileName)+'%\'';  
                  advancedFilter = true;
                  advancedSoql = soql;
             }
             if(roleName!=null && !roleName.equals('') && !roleName.equals('All')){
                  soql += ' and UserRole.Name LIKE \''+String.escapeSingleQuotes(roleName)+'%\'';
                  advancedFilter = true;
                  advancedSoql = soql;
             }
             if(email!=null && !email.equals('')){
                  soql += ' and Email LIKE \''+String.escapeSingleQuotes(email)+'%\'';
                  advancedFilter = true;
                  advancedSoql = soql;
             }
             withoutFilterSoql = soql;
             soql += ' ORDER BY ' +sortField + ' ' +sortDir ;
             // run the query again
             con = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
             if (con.getRecords().size() + Limits.getQueryLocatorRows() > Limits.getLimitQueryLocatorRows()) {
                 ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Error,''+label.rt_GovernorLimitMsg);
                 ApexPages.addMessage(errMsg);  
                 return null;
                 System.debug('***Class:PasswordResetController --Method: runSearch --- Trying to fetch ' + con.getRecords().size() + ' records but governor limits will only allow ' + Limits.getLimitQueryLocatorRows());  
             }else{
                 System.debug('***Class:PasswordResetController --Method: runSearch --- Continue processing. Not going to hit DML governor limits'); 
             }
             // sets the number of records in each page set 
             con.setPageSize(10); 
             return null;
    }
     
    // retrieve all profiles
    public List<String> profileList{
        get {
           system.debug('***Class:PasswordResetController --Method: profileList ---ProfileList: '+profileList);
          if(profileList == null){
             profileList = new List<String>();
             List<Profile> profList = [SELECT Id, Name FROM Profile];
             for(Profile p : profList)
                  profileList.add(p.Name);
          }
          return profileList;          
        }
        set;
    }
      
    // retrieve all roles
    public List<String> roleList{
        get {
          if(roleList == null){
             roleList = new List<String>();
             List<UserRole> rleList = [SELECT Id, Name FROM UserRole];
             for(UserRole r: rleList)
                  roleList.add(r.Name);
          }
          return roleList ;          
        }
        set;
    }
      
    //Wrapper Class 
    public class UserWrapper{
        public User uRec{get;set;}
        public boolean isSelected{get;set;}
        
        public UserWrapper(User u,Boolean chk){
            this.uRec = u;
            this.isSelected = chk;
        }
    }
    
    /****************Pagination Methods***********************/    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
     
    //Indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
     
     // returns the page number of the current page set
     public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
     }
     
     // returns the first page of records
     public void first() {
         con.first();
     }
     
     // returns the last page of records
     public void last() {
         con.last();
     }
     
     // returns the previous page of records
     public void previous() {
         con.previous();
     }
     
     // returns the next page of records
     public void next() {
         con.next();
     }
     
     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
     
     /**********Pagination Methods End ******************/
     
     public List<UserWrapper> AllSearchUsers{  
        get{  
            if(con != null){
                lstUser = new List<UserWrapper>();
                for(User u: (List<user>)con.getRecords()){
                  if(selectedUsers!=null && selectedUsers.size()>0 && selectedUsers.contains(u.Id)){
                      lstUser.add(new UserWrapper(u,true));
                  }else{
                      lstUser.add(new UserWrapper(u,false));
                  }
               } 
                return lstUser;  
            }else{
                return null ;  
            }
        }  
        set;
     } 
     /* Method to set new password for selected users
     */
    Public Pagereference doSetPassword(){
        System.debug('***Class:PasswordResetController --Method: doSetPassword ---selectedUsers: '+selectedUsers);
        if(selectedUsers.size()>0){
            try{
                if(password != null && password.length() >= 8){
                    for(ID users : selectedUsers){
                        System.setPassword(users,password);
                    }
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,label.rt_Password_reset_successful);
                    ApexPages.addMessage(myMsg);
                    return null;
                }else if(password.length()<8){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,label.rt_InvalidPasswordMsg);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
             }catch(Exception e){
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Error,e.getMessage());
                ApexPages.addMessage(errMsg);  
                return null;
             }  
        }else{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,label.rt_SelectUserMsg);
           ApexPages.addMessage(myMsg);
        }
        showSetPassword = true;
        return null; 
        }
        
        
    /* Method to reset password for selected users
    */
    Public Pagereference resetUserPassword(){
         if(selectedUsers.size()>0){     
             try{
                        for(ID users : selectedUsers){
                            system.debug('***Class:PasswordResetController --Method: resetUserPassword ---Users: '+users);
                                System.resetPassword(users,true);
                        }
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,label.rt_Password_reset_successful);
                        ApexPages.addMessage(myMsg);
                        return null;
                        }catch(Exception e){
                                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Error,e.getMessage());
                                ApexPages.addMessage(errMsg);  
                                return null;
                        } 
                } 
                else{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,label.rt_SelectUserMsg);
           ApexPages.addMessage(myMsg);
        }
        showSetPassword = false;
        return null; 
    }
    
    public void setPasswordshow(){
        if(showSetPassword == false){
        showSetPassword = true;
        }
    }
    
    public void resetPasswordshow(){
       if(showSetPassword == true){
        showSetPassword = false;
        }
    }    
}