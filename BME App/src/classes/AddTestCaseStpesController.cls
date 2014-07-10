public class AddTestCaseStpesController {

    public AddTestCaseStpesController(ApexPages.StandardController controller) {

    }
    Public static testMethod void UseCaseControllerTest(){
         Profile p = [select id from profile where name='System Administrator']; 
         User u = new User(alias = 'standt', email='user@bme.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='user@bme.com');
             System.runAs(u) {
             //Test data
             //Test data
             Test_Case__c testcaseObj = new Test_Case__c();
             insert testcaseObj ;
             
             Test_Case_Step__c TestCaseStep= new Test_Case_Step__c(Test_Case__c=testcaseObj.Id);
             insert TestCaseStep;
             
                         
             ApexPages.StandardController stdController = new ApexPages.StandardController(testcaseObj);
             AddTestCaseStpesController addtestcasestpescontroller = new AddTestCaseStpesController (stdController ); 
            }
           }

}