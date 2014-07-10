public class reportStatusWizardExtension {

    public reportStatusWizardExtension(ApexPages.StandardController controller) {

    }
    
    public pagereference next(){
    
        PageReference newPage = Page.ReportStatus_Issues_Risks_OpenItems;
        return newPage.setRedirect(true);
    
    }

}