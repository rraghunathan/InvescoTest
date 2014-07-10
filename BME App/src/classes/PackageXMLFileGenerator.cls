/* Class Name  : PackageXMLFileGenerator
* Description  : To create package.XMl file for Migration
* Created By   : Vikram
* Created Date : 7/8/2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Vikram                   7/8/2014            1000                   Initial Version
*/
public with sharing class PackageXMLFileGenerator {
    
    public string MigReqIds;
    public set<string> MigrationReqSet;
    
    public string XmlStringFormed{get;set;}
    public string ComponentType='';
    public set<string> ComponentNamesset;
    public integer ComponentsCount=0;
    public integer Count=0;
    public map<string,set<string>> MigComponentsMap;
    public list<string> ComponentNamesList;
    public set<string> splitComponentNamesset;
    public set<string> CompNames;
    
    public PackageXMLFileGenerator()
    {
        try{
            XmlStreamWriter writer = new XmlStreamWriter();
            
            writer.writeStartDocument('utf-8', '1.0');        
            writer.writeStartElement(null, 'Package', null);
             writer.writeAttribute(null, null, 'xmlns', 'http://soap.sforce.com/2006/04/metadata');
            
            MigReqIds = Apexpages.currentpage().getparameters().get('SelIds');
            
            if(MigReqIds!=null && MigReqIds!='')
            {
                MigrationReqSet = new set<string>();
                list<string> MigIdsList = MigReqIds.split(',');
                
                for(Work_Package__c MigReqVar:[Select Id, Name, CreatedDate, Biz_Process_Design_Completed__c, Biz_Process_Design_Hrs_Remaining__c, Biz_Process_Design_Resource__c, Configuration_Completed__c, Configuration_Hrs_Remaining__c, Configuration_Resource__c, Description__c, Development_Completed__c, Development_Hrs_Remaining__c, Development_Resource__c, Estimated_Completion_Date__c, Estimated_Start_Date__c, Expected_Functional_Review_Date__c, Expected_Technical_Review_Date__c, Expected_User_Review_Date__c, Functional_Review_Completed__c, Info_Requirements_Completed__c, Integration_Description__c, Integrations__c, Key_Objects__c, Offshore_Developer_Resource__c, Priority__c, Progress_Statement__c, Progress__c, Related_Objects__c, Release__c, Requirements_Hrs_Remaining__c, Requirements_Resource__c, Status__c, Tech_Design_Completed__c, Tech_Design_Hrs_Remaining__c, Tech_Design_Resource__c, Technical_Review_Completed__c, Total_Level_of_Effort__c, Use_Cases_Completed__c, User_Design_Review_Complete__c, Wireframes_included__c, Work_Package_Name__c, Biz_Process_Design_Hours__c, Configuration_Hours__c, Development_Hours__c, Requirements_Hours__c, Tech_Design_Hours__c FROM Work_Package__c  where Status__c=:'In Progress' and id in : MigIdsList])
                {
                        MigrationReqSet.add(MigReqVar.id);                      
                }
                
                if(MigrationReqSet!=null && MigrationReqSet.size()>0)
                {
                    ComponentNamesset = new set<string>();
                    MigComponentsMap = new map<string,set<string>>();
                    splitComponentNamesset = new set<string>();
                                        
                    for(Component__c MigCompVar:[Select Id, Name, CreatedDate, Dependency_Details__c, Description__c, Last_Migrated_On__c, /*Last_Migrated_To__c,*/ Related_Component__c, Work_Package__c, Component_Type__c, Migrate_to_Sandbox__c FROM Component__c where Work_Package__c in : MigrationReqSet])
                    count++;
                    
                    for(Component__c MigCompVar:[select id,Name,Component_Type__c,Work_Package__c from Component__c where Work_Package__c in : MigrationReqSet])
                    {                       
                       ComponentsCount++; 
                       if(ComponentType == '' || ComponentType == null)
                       ComponentType = MigCompVar.Component_Type__c; 
                                             
                       if(ComponentType == MigCompVar.Component_Type__c)
                       {   
                            splitComponentNamesset = new set<string>();
                            if(MigCompVar.Name!=null && MigCompVar.Name.indexof(',')>0)
                            {
                                ComponentNamesList = MigCompVar.Name.split(',');
                                splitComponentNamesset.addAll(ComponentNamesList);
                            }
                             system.debug('MigComponentsMap========'+MigComponentsMap.keyset()+'=========ComponentType========'+ComponentType);                   
                            if(MigComponentsMap.containskey(ComponentType))
                            {    
                                CompNames = new set<string>();                           
                                if(splitComponentNamesset!=null && splitComponentNamesset.size()>0)
                                CompNames.addAll(splitComponentNamesset);
                                else
                                {
                                     CompNames = MigComponentsMap.get(ComponentType);
                                     CompNames.add(MigCompVar.Name);                                    
                                }
                                MigComponentsMap.put(MigCompVar.Component_Type__c,CompNames);                                                                                         
                            }   
                            else
                            {
                                if(splitComponentNamesset!=null && splitComponentNamesset.size()>0)
                                ComponentNamesset.addAll(splitComponentNamesset);
                                else
                                ComponentNamesset.add(MigCompVar.Name);                            
                            }
                            
                            if(ComponentsCount == count)
                            {
                                if(MigComponentsMap.containskey(ComponentType))
                                {
                                    set<string> CompNames = MigComponentsMap.get(ComponentType);                                   
                                    CompNames.addAll(ComponentNamesset);
                                    MigComponentsMap.put(MigCompVar.Component_Type__c,CompNames);
                                }
                                else
                                MigComponentsMap.put(ComponentType,ComponentNamesset);                 
                            }   
                       }
                       else
                       {    
                         system.debug('MigComponentsMap========in else==='+MigComponentsMap.keyset()+'=========ComponentType========'+ComponentType); 
                            if(MigComponentsMap.containskey(ComponentType))
                            {  
                                
                                set<string> CompNames = MigComponentsMap.get(ComponentType);
                                CompNames.addAll(ComponentNamesset);
                                MigComponentsMap.put(ComponentType,CompNames);
                                system.debug('MigComponentsMap========in else==='+MigComponentsMap);
                            }
                            else
                            MigComponentsMap.put(ComponentType,ComponentNamesset);                            
                            
                            splitComponentNamesset = new set<string>();
                             if(MigCompVar.Name!=null && MigCompVar.Name.indexof(',')>0)
                             {
                                ComponentNamesList = MigCompVar.Name.split(',');
                                splitComponentNamesset.addAll(ComponentNamesList);
                             }
                            
                            ComponentType = MigCompVar.Component_Type__c;
                            ComponentNamesset = new set<string>();
                            if(splitComponentNamesset!=null && splitComponentNamesset.size()>0)
                                ComponentNamesset.addAll(splitComponentNamesset);
                            else    
                                ComponentNamesset.add(MigCompVar.Name);                              
                           
                            if(ComponentsCount == count)
                            {
                                if(MigComponentsMap.containskey(ComponentType))
                                {
                                    set<string> CompNames = MigComponentsMap.get(ComponentType);
                                    CompNames.addAll(ComponentNamesset);
                                    MigComponentsMap.put(MigCompVar.Component_Type__c,CompNames);
                                }
                                else
                                MigComponentsMap.put(ComponentType,ComponentNamesset);         
                            }
                       }
                      
                    }
                    
                    
                    for(string str:MigComponentsMap.keyset())
                    {
                        writer.writeStartElement(null, 'types', null);
                        //writer.writeStartElement(null, 'members', null);
                        set<string> ComponentsSet = MigComponentsMap.get(str);
                        for(string strCompVal:ComponentsSet)
                        {
                            writer.writeStartElement(null, 'members', null);
                                writer.writeCharacters(strCompVal);
                            writer.writeEndElement();
                        }
                        
                            writer.writeStartElement(null, 'name', null);
                                writer.writeCharacters(str);
                            writer.writeEndElement(); 
                        writer.writeEndElement();
                    }
                }
                
                
            }
            
            writer.writeStartElement(null, 'version', null);
                writer.writeCharacters('29.0');
            writer.writeEndElement();
            
            writer.writeEndElement();    
            //system.debug('xml string========='+writer.getXmlString());          
            //writer.close(); 
            XmlStringFormed = writer.getXmlString();
        }
        catch(Exception ex)
        {
            system.debug('exception=========='+ex);
            system.debug('exception=========='+ex.getStackTraceString());
        }
    }
    
    }