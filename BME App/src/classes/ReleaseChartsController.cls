/*
    Name : ReleaseChartsController
    Purpose : Serves as controller class for Release page */
    
public with sharing class ReleaseChartsController {
    //Current Relase record
    public Release__c currentRelease{get;set;}
    //List of Statuses
    public List<String> statusList{get;set;}
    //Map to store frequency of deliverable statuses    
    public Map<String,Integer> statusCountMap{get;set;}
    public Map<String,Integer> riskImpact{get;set;}
    public Map<String,Integer> allIssues{get;set;}
    public List<String> risksList{get;set;}
    public Map<String,Integer> workPkgStatus{get;set;}
    public List<String> wpStatus{get;set;}
    public Id issueRtId, riskRtId;
    public Boolean display{get;set;}
       
    public ReleaseChartsController(ApexPages.StandardController controller){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Project_Item__c; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        if(rtMapByName.containsKey('Issue')){
            issueRtId =  rtMapByName.get('Issue').getRecordTypeId();
        }
        if(rtMapByName.containsKey('Risk')){
            riskRtId =  rtMapByName.get('Risk').getRecordTypeId();
        }
        
        statusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Deliverables__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
             statusList.add(f.getLabel());
        }
        
        List<String> impactLevelList = new List<String>();
        fieldResult = Project_Item__c.Level_of_Impact__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
             impactLevelList.add(f.getLabel());
        }
        
        List<String> issueStatusList = new List<String>();
        fieldResult = Project_Item__c.Status__c.getDescribe();
        ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
            issueStatusList.add(f.getLabel());
        } 
             
        statusCountMap = new Map<String,Integer>();
        Release__c release = (Release__c)controller.getRecord();
        currentRelease = [select Id from Release__c where Id = :release.Id];
        List<AggregateResult> dStatus = [select count(Id) cnt,Status__c from Deliverables__c where Release__c = :release.Id group by Status__c];        
        for(AggregateResult ar : dStatus){
            statusCountMap.put((String)ar.get('Status__c'),(Integer)ar.get('cnt'));
        }
        for(String st : statusList){
            if(!statusCountMap.containsKey(st)){
                statusCountMap.put(st,0);
            }
        }        
        if(!dStatus.isEmpty()){
            display = true;
        }else{
            display =  false;
        }
              
        List<AggregateResult> issuesList = [select count(Id) cnt,Status__c from Project_Item__c where Release__c = :release.Id and RecordTypeId = :issueRtId group by Status__c];
        allIssues = new Map<String,Integer>();
        for(AggregateResult ar : issuesList){
            allIssues.put((String)ar.get('Status__c'), (Integer)ar.get('cnt'));
        }
        for(String st : issueStatusList){
            if(!allIssues.containsKey(st)){
                allIssues.put(st,0);
            }
        }
        
        riskImpact = new Map<String,Integer>();
        risksList = new List<String>();
        Schema.DescribeFieldResult pFieldResult = Project_Item__c.Level_of_Impact__c.getDescribe();
        List<Schema.PicklistEntry> plentry = pFieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : plentry){
             risksList.add(f.getLabel());
        }
        List<AggregateResult> risks = [select count(Id) cnt,Level_of_Impact__c from Project_Item__c where Release__c = :release.Id and RecordTypeId = :riskRtId group by Level_of_Impact__c];
        for(AggregateResult ar : risks){
            riskImpact.put((String)ar.get('Level_of_Impact__c'), (Integer)ar.get('cnt'));
        }
        for(String st : risksList){
            if(!riskImpact.containsKey(st)){
                riskImpact.put(st,0);
            }
        }
        
        wpStatus = new List<String>();
        Schema.DescribeFieldResult sfieldResult = Work_Package__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> plent = sfieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : plent){
             wpStatus.add(f.getLabel());
        }       
        workPkgStatus = new Map<String,Integer>();
        List<AggregateResult> wStatus = [select count(Id) cnt,Status__c from Work_Package__c where Release__c = :release.Id group by Status__c];
        for(AggregateResult ar : wStatus){
            workPkgStatus.put((String)ar.get('Status__c'),(Integer)ar.get('cnt'));
        }
        for(String st : wpStatus){
            if(!workPkgStatus.containsKey(st)){
                workPkgStatus.put(st,0);
            }
        }
    }
}