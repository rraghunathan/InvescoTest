/* 
*AddUseCaseStepExtTest class provides test coverage for AddUseCaseStepExtTest class
*/
@isTest
private class AddUseCaseStepExtTest {
	
	
	/*
	*This method tests 
	*/
	static testMethod void testUseCaseStepExtTest(){
			Use_Case_Step__c ucs = new Use_Case_Step__c();
			insert ucs;
		 	ApexPages.StandardController sc = new ApexPages.StandardController(ucs);
		 	addUseCaseStepExt auc = new addUseCaseStepExt(sc);
		 	System.assert(true); //no exceptions then test succeeds
	}

}