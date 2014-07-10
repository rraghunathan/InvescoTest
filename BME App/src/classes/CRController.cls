/*
  Name         : CRController
  Purpose      : Serves as controller class for CR Join page
  Created Date : 4/2/2012*/
  
public class CRController{
    
    public Change_Request__c crInst{get;set;}
    public List<ComponentWrapper> componentList{get;set;}
    public Component__c newComp{get;set;}
    public List<Component__c> newCompList{get;set;}
    
    public CRController(ApexPages.StandardController controller){
        Change_Request__c currentCR = (Change_Request__c)controller.getRecord();
        crInst = [select Id,Work_Package__c from Change_Request__c where Id = :currentCR.Id];
        componentList = new List<ComponentWrapper>();
        newComp = new Component__c();
        Set<Id> existingCompIds = new Set<Id>();
        for(CR_Components_Join__c joinRec : [select Change_Request__c, Component__c from CR_Components_Join__c where Change_Request__c = :currentCR.Id]){
            existingCompIds.add(joinRec.Component__c);  
        }
        for(Component__c cmp : [select Id,Name from Component__c where Work_Package__c = :crInst.Work_Package__c]){
            if(existingCompIds.contains(cmp.Id)){
                componentList.add(new ComponentWrapper(cmp.Name,cmp.Id,true,true));
            }
            else{
                componentList.add(new ComponentWrapper(cmp.Name,cmp.Id,false,false));
            }
        }
        newCompList = new List<Component__c>();
        newCompList.add(new Component__c());
        newCompList.add(new Component__c());
    }
    
    public class ComponentWrapper{
        public boolean selected{get;set;}
        public String name{get;set;}
        public Id compId{get;set;}
        public boolean created{get;set;}
        public componentWrapper(String name, Id compId, Boolean selected, Boolean created){
            this.name = name;
            this.compId = compId;
            this.selected = selected;
            this.created = created;
        }
    }
    
    public PageReference attach(){
        List<CR_Components_Join__c> crjRecords = new List<CR_Components_Join__c>();
        for(ComponentWrapper cw : componentList){
            if(cw.selected && !cw.created){
                crjRecords.add(new CR_Components_Join__c(Change_Request__c = crInst.Id, Component__c = cw.compId));
                cw.created = true;
            }
        }
        if(CR_Components_Join__c.SObjectType.getDescribe().isCreateable()){
            insert crjRecords;
        }
        return null;
    }
    
    public PageReference createCompNJoin(){
        try{
            Integer compCount = 0;
            List<Component__c> createComps = new List<Component__c>();
            Map<Id,String> compMap = new Map<Id,String>();
            for(Component__c comp : newCompList){
                if(comp.Name != NULL){
                    compCount++;
                    Component__c insertComp = new Component__c(Name = comp.Name, Work_Package__c = crInst.Work_Package__c, Last_Migrated_On__c = comp.Last_Migrated_On__c, Last_Migrated_To__c = comp.Last_Migrated_To__c);
                    createComps.add(insertComp);
                }
            }
            if(!createComps.isEmpty()){
                if(Component__c.SObjectType.getDescribe().isCreateable()){
                    insert createComps;
                }
                List<CR_Components_Join__c> createCRJoin = new List<CR_Components_Join__c>();
                for(Component__c comp : createComps){
                    CR_Components_Join__c newCRJoin = new CR_Components_Join__c(Change_Request__c = crInst.Id, Component__c = comp.Id);
                    compMap.put(comp.Id,comp.Name);
                    createCRJoin.add(newCRJoin);
                }
                if(CR_Components_Join__c.SObjectType.getDescribe().isCreateable()){
                    insert createCRJoin;
                }
                for(CR_Components_Join__c crComps : createCRJoin){
                    if(compMap.containsKey(crComps.Component__c)){
                        componentList.add(new ComponentWrapper(compMap.get(crComps.Component__c),crComps.Id,true,true));
                    }   
                }               
                return null;
            }
            if(compCount == 0){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Name and WorkPackage for the Components you create'));
                return null;
            }
        }
        catch(System.Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An unexpected exception occured. Please contact your System Admin'));
            System.debug('###Exception : '+ ex.getMessage());
            return null;    
        }
        return null;
    }
    
    public PageReference addRows(){
        newCompList.add(new Component__c());
        return null;
    }
    
    static testMethod void myUnitTest() {
        Project__c proj = new Project__c(Name = 'Test Project', Project_Summary__c = 'Test', Project_Status__c = 'In Progress');
        insert proj;
        Release__c rel = new Release__c(Name = 'Test Release', Type__c = 'Major', Status__c = 'In Progress', Start_Date__c = Date.Today(), End_Date__c = Date.Today() + 1, Project__c = proj.Id);
        insert rel;
        Work_Package__c wp = new Work_Package__c(Status__c = 'In Progress', Priority__c = 'Medium', Release__c = rel.Id);
        insert wp;
        Change_Request__c cr = new Change_Request__c(Status__c = 'Submitted for approval', Summary__c = 'Test', Work_Package__c = wp.Id);
        insert cr;
        List<Component__c> compList = new List<Component__c>{new Component__c(Work_Package__c = wp.Id, Name = 'Test1'), new Component__c(Work_Package__c = wp.Id, Name = 'Test2')};
        insert compList;
        Id cmpId;
        for(Component__c cmp : compList){
            cmpId = cmp.Id;
            break;
        }
        CR_Components_Join__c crj = new CR_Components_Join__c(Change_Request__c = cr.Id, Component__c = cmpId);
        insert crj;
        Test.startTest();
        CRController pageCon = new CRController(new ApexPages.StandardController(cr));
        for(CRController.ComponentWrapper wrp :  pageCon.componentList){
            if(!wrp.created){
                wrp.selected = true;
            }
        }
        pageCon.attach();
        pageCon.addRows();
        pageCon.createCompNJoin();
        pageCon.newCompList = compList.clone();
        pageCon.createCompNJoin();
        Test.stopTest();
    }
}