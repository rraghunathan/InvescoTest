public with sharing class StatusReportController {
    
    public Boolean sumOfDel{get;set;}
    public Boolean statusSummary{get;set;}
    public Boolean accomplishments{get;set;}
    public Boolean nextSteps{get;set;}
    public Boolean delOfMileStones{get;set;}
    public Boolean showIssues{get;set;}
    public Boolean showRisks{get;set;}
    public List<String> reqIssueStatus{get;set;}
    public List<String> reqIssueComplexity{get;set;}
    public List<String> reqIssuePriority{get;set;}
    public List<String> reqRiskStatus{get;set;}
    public List<String> reqRiskComplexity{get;set;}
    public List<String> reqRiskPriority{get;set;}
    public String dashboardURL{get;set;}
    public Boolean dispDashboard;
    public Id currentReleaseId{get;set;}
    public String overallStatus{get;set;}
    public String budgetStatus{get;set;}
    public String resourceStatus{get;set;}
    public String scopeStatus{get;set;}
    public Status_Reports__c stReport{get;set;}
    public String resrc{get;set;}
    public String proj{get;set;}
    public String budget{get;set;}
    public String scope{get;set;} 
    public Map<String,String> resrcMapping{get;set;}
    public Map<String,String> projMapping{get;set;}
    public Map<String,String> budgetMapping{get;set;}
    public Map<String,String> milestoneMapping{get;set;} 
    public Integer delCompStatus{get;set;}
    public List<Project_Item__c> issuesList{get;set;}
    public List<Project_Item__c> risksList{get;set;}
    public List<MilestoneWrapper> mileStones{get;set;}
    public String issueRecType;
    public String riskRecType;
    public Boolean statusReport{get;set;}
    public Boolean statusSmry{get;set;}
    public String statusIndURL{get;set;}
    public Deliverables__c deliverableStart{get;set;}
    public Deliverables__c deliverableEnd{get;set;}
    public Milestone__c milestoneStart{get;set;}
    public Milestone__c milestoneEnd{get;set;}
    public List<Milestone__c> milestoneList{get;set;}
    public List<Deliverables__c> deliverablesList{get;set;}
    public List<String> reqMilestoneStatus{get;set;}
    public List<String> reqDeliverableStatus{get;set;}
    public Id orgId{get;set;}
    public String serverURL{get;set;}
    public Map<String,Id> wordImgs{get;set;}
    public Id statusImgId{get;set;}
    public Id projImgId{get;set;}
    public Id scopeImgId{get;set;}
    public Id budgetImgId{get;set;}
    public Id resrcImgId{get;set;}
    public List<String> imageDocs;
    public String docName{get;set;}
    
    public PageReference step1() {
        return Page.StatusReportPage1;
    }
    
    public PageReference step2() {      
        return Page.StatusReportPage2;
    }
    
    public PageReference step3() {      
        return Page.StatusReportPage3;
    }
    
    public PageReference step4() {
        return Page.StatusReportPage4;
    }
    
    public Boolean getDispDashboard(){
        if(dashboardURL == NULL || dashboardURL == ''){
            return false;
        }else{
            return true;
        }
    }
    
    public PageReference generateWord(){
        return Page.GenerateStatusReportInWord;
    }
    
    public PageReference generatePDF(){
        return Page.GenerateStatusReportInPDF;
    }
    
    public StatusReportController(ApexPages.StandardController controller){        
        sumOfDel = false;
        statusSummary = false;
        accomplishments = false;
        nextSteps = false;
        delOfMileStones = false;
        showIssues = false;
        showRisks = false;
        statusReport = false;
        statusSmry = false;
        delCompStatus = 0;  
        issueRecType = 'Issue';
        riskRecType = 'Risk';
        wordImgs = new Map<String,Id>();
        docName = '';
        imageDocs = new List<String>{'ImageRed','ImageYellow','ImageGreen'};
        List<Document> docList = [select Id,Name from Document where Name in :imageDocs];
        for(Document doc : docList){
            wordImgs.put(doc.Name,doc.Id);
        }
        orgId = UserInfo.getOrganizationId();
        serverURL = ApexPages.currentPage().getHeaders().get('Host');
        milestoneList = new List<MileStone__c>();
        deliverablesList = new List<Deliverables__c>();
        deliverableStart = new Deliverables__c();
        deliverableEnd = new Deliverables__c();
        milestoneStart = new Milestone__c();
        milestoneEnd = new Milestone__c();
        mileStones = new List<MilestoneWrapper>();
        resrcMapping = new Map<String,String>();
        projMapping = new Map<String,String>();
        budgetMapping = new Map<String,String>();
        milestoneMapping = new Map<String,String>();
        reqIssueStatus = new List<String>();
        reqIssueComplexity = new List<String>();
        reqIssuePriority = new List<String>();
        reqRiskStatus = new List<String>();
        reqRiskComplexity = new List<String>();
        reqRiskPriority = new List<String>();
        reqDeliverableStatus = new List<String>();
        reqMilestoneStatus = new List<String>();
        issuesList = new List<Project_Item__c>();
        risksList = new List<Project_Item__c>();
        //Release__c release = (Release__c)controller.getRecord();
        Status_Reports__c statusReport = (Status_Reports__c)controller.getRecord();        
        stReport = [select Name, Budget_Status__c, Key_Accomplishments__c, Next_Steps__c, Overall_Status__c, Overall_Status_Indicator__c, Period_Ending_On__c,
                                 Period_Starting_On__c, Resource_Status__c, Scope_Status__c, Status_Summary__c, Release__c, Project__c 
                                 from Status_Reports__c where Id = :statusReport.Id]; 
        docName = stReport.Project__c + ' Status Report - ' + String.valueOf(stReport.Period_Ending_On__c);  
        currentReleaseId = stReport.Release__c;
        statusIndURL = stReport.Overall_Status_Indicator__c.subString(stReport.Overall_Status_Indicator__c.indexOf('src="') + 5,stReport.Overall_Status_Indicator__c.indexOf('" alt='));
        for(Project_Status_Mapping__c mapping : Project_Status_Mapping__c.getAll().values()){
            projMapping.put(mapping.Name,mapping.Image_URL__c.replace('http://',''));
        }
        for(Budget_Status_Mapping__c mapping : Budget_Status_Mapping__c.getAll().values()){
            budgetMapping.put(mapping.Name.replace(' ',''),mapping.Image_URL__c.replace('http://',''));
        }
        for(Resource_Scope_Status_Mapping__c mapping : Resource_Scope_Status_Mapping__c.getAll().values()){
            resrcMapping.put(mapping.Name,mapping.Image_URL__c.replace('http://',''));
        }
        for(Milestone_Status_Mapping__c mapping : Milestone_Status_Mapping__c.getAll().values()){
            milestoneMapping.put(mapping.Name,mapping.Status__c);
        }
        resrc = resrcMapping.get(stReport.Resource_Status__c);
        proj = projMapping.get(stReport.Overall_Status__c);
        budget = budgetMapping.get(stReport.Budget_Status__c.replace(' ',''));
        scope = resrcMapping.get(stReport.Scope_Status__c);   
        statusImgId = wordImgs.get(getImageName(stReport.Overall_Status_Indicator__c));
        projImgId = wordImgs.get(getImageName(proj));
        scopeImgId = wordImgs.get(getImageName(scope));
        budgetImgId = wordImgs.get(getImageName(budget));
        resrcImgId = wordImgs.get(getImageName(resrc));
        Integer cnt = 0;
        List<Deliverables__c> delList = [select Completed__c from Deliverables__c where Release__c = :currentReleaseId]; 
        for(Deliverables__c del : delList){
            if(del.Completed__c != NULL){
                cnt += Integer.valueOf(del.Completed__c.replace('%',''));
            }
        }
        if(!delList.isEmpty()){
            delCompStatus = cnt/delList.size();
        }       
        for(Milestone__c mile : [select Name, Start_Date__c, Target_Completion_Date__c, Status__c from Milestone__c where Release__c = :currentReleaseId]){
            if(milestoneMapping.containsKey(mile.Status__c)){
                milestones.add(new MilestoneWrapper(mile,milestoneMapping.get(mile.Status__c)));
            }else{
                milestones.add(new MilestoneWrapper(mile,''));
            }
        }
    }
    
    public List<SelectOption> getStatusValues()
    {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult = Project_Item__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All','All'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }               
        return options;
    }
    
    public List<SelectOption> getPriorityValues()
    {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult = Project_Item__c.Priority__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All','All'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }               
        return options;
    }
    
    public List<SelectOption> getComplexityValues()
    {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult = Project_Item__c.Complexity__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All','All'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }               
        return options;
    }
    
    public List<SelectOption> getDelStatusValues()
    {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult = Deliverables__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All','All'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }               
        return options;
    }
    
    public List<SelectOption> getMileStatusValues()
    {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult = MileStone__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All','All'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }               
        return options;
    }
    
    public Class MilestoneWrapper{
        public String name{get;set;}
        public Date startDate{get;set;}
        public Date dueDate{get;set;}
        public String status{get;set;}
        public MilestoneWrapper(Milestone__c milest, String mileStatus){
            name = milest.Name;
            startDate = milest.Start_Date__c;
            dueDate = milest.Target_Completion_Date__c;
            status = mileStatus;
        }
    }
    
    public PageReference populatePItems(){
        List<SelectOption> sValues = getStatusValues();
        List<SelectOption> pValues = getPriorityValues();
        List<SelectOption> cValues = getComplexityValues();
        Set<String> reqIssueStatusSet = new Set<String>();
        reqIssueStatusSet.addAll(reqIssueStatus);
        Set<String> reqRiskStatusSet = new Set<String>();
        reqRiskStatusSet.addAll(reqRiskStatus);
        Set<String> reqIssuePrioritySet = new Set<String>();
        reqIssuePrioritySet.addAll(reqIssuePriority);
        Set<String> reqRiskPrioritySet = new Set<String>();
        reqRiskPrioritySet.addAll(reqRiskPriority);
        Set<String> reqIssueComplexitySet = new Set<String>();
        reqIssueComplexitySet.addAll(reqIssueComplexity);
        Set<String> reqRiskComplexitySet = new Set<String>();
        reqRiskComplexitySet.addAll(reqRiskComplexity);
        if(reqIssueStatusSet.contains('All')){
            for(SelectOption op : sValues){
                reqIssueStatusSet.add(op.getValue());
            }
            reqIssueStatusSet.add(null);
        }
        if(reqRiskStatusSet.contains('All')){
            for(SelectOption op : sValues){
                reqRiskStatusSet.add(op.getValue());
            }
            reqRiskStatusSet.add(null);
        }
        if(reqIssuePrioritySet.contains('All')){
            for(SelectOption op : pValues){
                reqIssuePrioritySet.add(op.getValue());
            }
            reqIssuePrioritySet.add(null);
        }
        if(reqRiskPrioritySet.contains('All')){
            for(SelectOption op : pValues){
                reqRiskPrioritySet.add(op.getValue());
            }
            reqRiskPrioritySet.add(null);
        }
        if(reqIssueComplexitySet.contains('All')){
            for(SelectOption op : cValues){
                reqIssueComplexitySet.add(op.getValue());
            }
            reqIssueComplexitySet.add(null);
        }
        if(reqRiskComplexitySet.contains('All')){
            for(SelectOption op : cValues){
                reqRiskComplexitySet.add(op.getValue());
            }
            reqRiskComplexitySet.add(null);
        }
        List<Project_Item__c> pItems = [select Name, Summary__c, Priority__c, Due_Date__c, Status__c, Complexity__c, Date_Submitted__c, Risk_Probability__c, RecordType.Name from Project_Item__c where Release__c = :currentReleaseId 
                                                                                and (Status__c in :reqIssueStatusSet or Status__c in :reqRiskStatusSet) and (Complexity__c in :reqIssueComplexitySet or
                                                                                     Complexity__c in :reqRiskComplexitySet) and (Priority__c in :reqIssuePrioritySet or Priority__c in :reqRiskPrioritySet)];
        for(Project_Item__c pi : pItems){
            if(pi.RecordType.Name == issueRecType && reqIssueStatusSet.contains(pi.Status__c) && reqIssueComplexitySet.contains(pi.Complexity__c) && reqIssuePrioritySet.contains(pi.Priority__c)){
                issuesList.add(pi);
            }else if(pi.RecordType.Name == riskRecType && reqRiskStatusSet.contains(pi.Status__c) && reqRiskComplexitySet.contains(pi.Complexity__c) && reqRiskPrioritySet.contains(pi.Priority__c)){
                risksList.add(pi);
            }               
        }
        return null;    
    }
    
    public PageReference fetchDelNMileStones(){
        //if(deliverableStart.Status__c)
        Set<String> reqMileStatus = new Set<String>();
        reqMileStatus.addAll(reqMilestoneStatus);
        Set<String> reqDelStatus = new Set<String>();
        reqDelStatus.addAll(reqDeliverableStatus);
        Id releaseId = currentReleaseId;
        String milestoneQuery = 'select Id, Name, Status__c, Actual_Completion_Date__c, Target_Completion_Date__c from Milestone__c where Release__c = :releaseId';
        if(milestoneStart.Target_Completion_Date__c != NULL){
            Date ms =  milestoneStart.Target_Completion_Date__c;
            milestoneQuery += ' and Target_Completion_Date__c >= :ms';
        }
        if(milestoneEnd.Target_Completion_Date__c != NULL){
            Date me =  milestoneEnd.Target_Completion_Date__c;
            milestoneQuery += ' and Target_Completion_Date__c <= :me';
        }
        if(milestoneStart.Actual_Completion_Date__c != NULL){
            Date msa =  milestoneStart.Actual_Completion_Date__c;
            milestoneQuery += ' and Actual_Completion_Date__c >= :msa';
        }
        if(milestoneEnd.Actual_Completion_Date__c != NULL){
            Date mea =  milestoneEnd.Actual_Completion_Date__c;
            milestoneQuery += ' and Actual_Completion_Date__c <= :mea';
        }
        Set<String> reqMilestoneStatusSet = new Set<String>();
        reqMilestoneStatusSet.addAll(reqMileStatus); 
        if(reqMilestoneStatusSet.contains('All')){
            for(SelectOption op : getMileStatusValues()){
                reqMilestoneStatusSet.add(op.getValue());
            }
            reqMilestoneStatusSet.add(null);
        }
        if(!reqMilestoneStatusSet.isEmpty()){
                milestoneQuery += ' and Status__c in :reqMilestoneStatusSet';
        }
        milestoneList = (List<Milestone__c>)Database.query(milestoneQuery);
        String deliverableQuery = 'select Id, Name, Completed__c, Actual_Completion_Date__c, Planned_Completion_Date__c, Release_Phase__c, Status__c from Deliverables__c where Release__c = :releaseId';
        Set<String> reqDeliverableStatusSet = new Set<String>();
        reqDeliverableStatusSet.addAll(reqDelStatus); 
        if(deliverableStart.Planned_Completion_Date__c != NULL){
            Date ds =  deliverableStart.Planned_Completion_Date__c;
            deliverableQuery += ' and Planned_Completion_Date__c >= :ds';
        }
        if(deliverableEnd.Planned_Completion_Date__c != NULL){
            Date de =  deliverableEnd.Planned_Completion_Date__c;
            deliverableQuery += ' and Planned_Completion_Date__c <= :de';
        }
        if(deliverableStart.Actual_Completion_Date__c != NULL){
            Date dsa =  deliverableStart.Actual_Completion_Date__c;
            deliverableQuery += ' and Actual_Completion_Date__c >= :dsa';
        }
        if(deliverableEnd.Actual_Completion_Date__c != NULL){
            Date dea =  deliverableEnd.Actual_Completion_Date__c;
            deliverableQuery += ' and Actual_Completion_Date__c <= :dea';
        }
        if(reqDeliverableStatusSet.contains('All')){
            for(SelectOption op : getDelStatusValues()){
                reqDeliverableStatusSet.add(op.getValue());
            }
            reqDeliverableStatusSet.add(null);
        }
        if(!reqDeliverableStatusSet.isEmpty()){
                deliverableQuery += ' and Status__c in :reqDeliverableStatusSet';
        }        
        deliverablesList = (List<Deliverables__c>)Database.query(deliverableQuery);   
        return null;
    }
    
    public void actionFunction(){}
    
    public String getImageName(String url){
        String imgName = '';
        if(url != NULL){
            if(url.contains('yellow')){
                imgName = 'ImageYellow';
            } else if(url.contains('red')){
                imgName = 'ImageRed';
            } else if(url.contains('green')){
                imgName = 'ImageGreen';
            }
        }
        return imgName;
    }
}