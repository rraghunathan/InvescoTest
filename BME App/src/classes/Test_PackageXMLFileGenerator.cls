/* Class Name  : Test_PackageXMLFileGenerator
* Description  : Test class for creating package.xml file
* Created By   : Vikram   
* Created Date : 7/9/2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* vikram                 7/9/2014            1000                    Created           
*/
@isTest
private class Test_PackageXMLFileGenerator{   
    static testmethod void PackageXMLFileGenerator_TestMethod(){
        try{  
        Work_Package__c MigVar = new Work_Package__c ();
        MigVar.Status__c = 'In Progress';        
        insert migvar;       
        
        Component__c MCvar = new Component__c();
        MCvar.Name = 'PackageXMLFileGenerator,TEst_PackageXMLFileGenerator';
        MCvar.Component_Type__c = 'Apexclass';
        MCvar.Work_Package__c = migvar.id;        
        insert MCvar;
        
         Component__c MCobj = new Component__c();
        MCobj.Name = 'PackageXMLFileGenerator';
        MCobj.Component_Type__c = 'Apexclass';
        MCobj.Work_Package__c = migvar.id;       
        insert MCobj;
        
        Component__c MCobjvar = new Component__c();
        MCobjvar.Name = 'Account';
        MCobjvar.Component_Type__c = 'CustomObject';
        MCobjvar.Work_Package__c = migvar.id;        
        insert MCobjvar;       
        
        
        
        Work_Package__c Migobj = new Work_Package__c ();
        Migobj.Status__c = 'In Progress';       
        insert Migobj ;
        
        Component__c MigComp = new Component__c();
        MigComp.Name = 'PackageXMLFileGenerator';
        MigComp.Component_Type__c = 'Apexclass';
        MigComp.Work_Package__c = Migobj.id;
        insert MigComp;
        
        Component__c MigCompvar = new Component__c();
        MigCompvar.Name = 'PackageXMLFileGenerator,Test_PackageXMLFileGenerator';
        MigCompvar.Component_Type__c = 'Apexclass';
        MigCompvar.Work_Package__c = Migobj.id;
        insert MigCompvar;
        
        Component__c MigCompobj= new Component__c();
        MigCompobj.Name = 'Contact';
        MigCompobj.Component_Type__c = 'CustomObject';
        MigCompobj.Work_Package__c = Migobj.id;
        insert MigCompobj;
        
        
       
        string Ids = migvar.id+','+Migobj;
         Apexpages.currentpage().getparameters().put('SelIds',Ids);  
        PackageXMLFileGenerator  Classobj = new PackageXMLFileGenerator();
        
        }
        
        
        catch(Exception ex)
        {
            system.debug('exception========'+ex);
            system.debug('exception========'+ex.getStackTraceString());
        }
    }
    
    static testmethod void PackageXMLFileGenerator_TestMethod1(){
         try{  
        Work_Package__c MigVar = new Work_Package__c ();
        MigVar.Status__c = 'In Progress';        
        insert migvar;       
        
        Component__c MCvar = new Component__c();
        MCvar.Name = 'PackageXMLFileGenerator';
        MCvar.Component_Type__c = 'Apexclass';
        MCvar.Work_Package__c = migvar.id;        
        insert MCvar;
        
       
        
        Component__c MCobjvar = new Component__c();
        MCobjvar.Name = 'Account';
        MCobjvar.Component_Type__c = 'CustomObject';
        MCobjvar.Work_Package__c = migvar.id;        
        insert MCobjvar;       
        
          Component__c MCobj = new Component__c();
        MCobj.Name = 'PackageXMLFileGenerator';
        MCobj.Component_Type__c = 'Apexclass';
        MCobj.Work_Package__c = migvar.id;       
        insert MCobj;
        
        Component__c Componentvar = new Component__c();
        Componentvar.Name = 'PackageXMLFileGenerator_v1';
        Componentvar.Component_Type__c = 'Apexclass';
        Componentvar.Work_Package__c = migvar.id;        
        insert Componentvar;
        
        
        
        
       
        string Ids = migvar.id;
         Apexpages.currentpage().getparameters().put('SelIds',Ids);  
        PackageXMLFileGenerator  Classobj = new PackageXMLFileGenerator();
        
        }
        
        
        catch(Exception ex)
        {
            system.debug('exception========'+ex);
            system.debug('exception========'+ex.getStackTraceString());
        }
    }
    
    
    }