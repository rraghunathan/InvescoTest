public with sharing class Release1_Charts_GanttController {

    public String mytarget {get; 
      set{
        this.mytarget = value;
        init();
      }
      }
    public String objectType {get;set;}
    public String startDateFieldName {get;set;}
    public String endDateFieldName {get;set;}
    public String idFieldName {get;set;}
    //public String titleFieldName {get;set;}
    public String fullViewURL {get;set;}
    public String projectGanttJson{get;set;}
 
    private String nameFieldName;
    private String completedFieldName;
    private String filterFieldName;
    public String pcompleteFieldName{get;set;}
    
    
    private List<Sobject> sobjectList;
    private static final String REGEXP_QUOTES    = '(?<!\\\\)"';
    
    public static final String COLOR_COMPLETE = '#333333';
    public static final String COLOR_LATE = '#808080';
    public static final String COLOR_FUTURE = '#357EC7';
    public static final String COLOR_CURRENT = '#008000';
    
    public Release1_Charts_GanttController()
    {
      init();
    }
    
    private void init()
    {
      if (myTarget != null)
      {
         initFieldNames();
          retrieveData();
        projectGanttJson = toJSon();
        
      }
    }
    
    public String getProjectGanttJson() {
        
        init();
        return projectGanttJson;
    }
    
    /*
    *   Initialize the variables depending on the object type possible values: 
    *   Milestone1_Milestone__c and Milestone1_Task__c
    */
    private void initFieldNames(){
      if(mytarget != null){
        if(mytarget.startsWith(Schema.SObjectType.Project__c.getKeyPrefix())){
          /*startDateFieldName = 'Kickoff__c';
          endDateFieldName = 'Deadline__c';
          nameFieldName = 'NameClean__c';
          filterFieldName = 'Project__c';*/
          
          startDateFieldName = Release__c.Start_Date__c.getDescribe().getName();
          endDateFieldName = Release__c.End_Date__c.getDescribe().getName();
          nameFieldName = Release__c.Name.getDescribe().getName();
          filterFieldName = Release__c.Project__c.getDescribe().getName();
          pcompleteFieldName=Release__c.Complete__c.getDescribe().getName();          
          //objectType = 'Milestone1_Milestone__c';
          objectType = Schema.SObjectType.Release__c.getName();
        }else if(mytarget.startsWith(Schema.SObjectType.Release__c.getKeyPrefix())){
          
          //titleFieldName=Work_Plan__c.Percent_Complete__c.getDescribe().getName();  
          startDateFieldName = Work_Plan__c.Start_Date__c.getDescribe().getName();
          endDateFieldName = Work_Plan__c.End_Date__c.getDescribe().getName();
          nameFieldName = Work_Plan__c.Name.getDescribe().getName();
          filterFieldName = Work_Plan__c.Release__c.getDescribe().getName();
          pcompleteFieldName=Work_Plan__c.Percent_Complete__c.getDescribe().getName();                   
          objectType = Schema.SObjectType.Work_Plan__c.getName();
        } else {
          throw new Milestone1_Exception('[initFieldNames] Unable to generate JSON for ' + mytarget);
        }
        idFieldName = 'Id';
        completedFieldName = 'Complete__c';  
      }
    }
    
    /*
    *   Retrieve the data doing a dynamic query by object type.
    */
    private void retrieveData(){
      String query = '';
      if(pcompleteFieldName == completedFieldName){
          query = 'Select ' + pcompleteFieldName + ',' + idFieldName+','+startDateFieldName+','+endDateFieldName +','+nameFieldName+
               ' from '+objectType+ ' where '+filterFieldName+'=\''+mytarget+'\' order by ' + startDateFieldName ;
      } else{
          query = 'Select ' + pcompleteFieldName + ',' + idFieldName+','+startDateFieldName+','+endDateFieldName +','+nameFieldName+ ',' +completedFieldName +
               ' from '+objectType+ ' where '+filterFieldName+'=\''+mytarget+'\' order by ' + startDateFieldName ;
      }
      system.debug('&&&&&&& Query' + query);
      sobjectList = Database.query(query);
    }
    
    /**
    *  Generate the output in json format to be rendered in the jquery gantt.
    */
    private String toJSon(){
      
      String ret = 'var ganttData' +mytarget + ' = [{id: 1, name: "", series: [';
      Boolean addComma=false,completed;
      Date startDate,endDate;
      String name,id,pcomplete ;
        for (Sobject current : sobjectList){ 
            
            if(current.get(startDateFieldName) == null){
              startDate = Date.today();
            }else{
              startDate = Date.valueOf(current.get(startDateFieldName));
            }
            if(current.get(endDateFieldName) == null){
              endDate = startDate;
            }else{
              endDate = Date.valueOf(current.get(endDateFieldName));
            }
            completed = Boolean.valueOf(current.get(completedFieldName));
            name = escapeDoubleQuotes(String.valueOf(current.get(nameFieldName)));
            id = String.valueOf(current.get(idFieldName));
            pcomplete = String.valueOf(current.get(pcompleteFieldName));
            if (addComma) { ret += ','; }
            
            String color=COLOR_CURRENT;
            
            if (completed) {
                color=COLOR_COMPLETE;
            } else if (endDate < Date.today()) {
                color=COLOR_LATE;
            } else if (startDate > Date.today()) {
                color=COLOR_FUTURE;
            }
            
            ret +=   '{'+
                'id:"'+id+'",'+ 
                'name: "'+name+'",'+
                'start: new Date(' +startDate.year() +',' + (startDate.month()-1) +',' + startDate.day() +'),'+
                 'end: new Date(' +endDate.year() +',' + (endDate.month()-1) + ',' + endDate.day() +'), ' +
                  'color: "' + color + '"'+
                  '}';
                  
            addComma=true;
            
        }
        
        ret+=']}];';
        return ret;     
    }
    
    private String escapeDoubleQuotes(String word){
      return word.replaceAll(REGEXP_QUOTES,'\\\\"');
    }

}