/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-13-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping = '/accountmgmt/')
global class AccountMgmt {
	@httpGet
    global static List<Account> getTopAccounts(){
		List<Account> accountList = [Select id,Name from Account];
		return accountList;
	}
	/*
	@httpGet
    global static List<Account> getTopAccounts(){
		Map<String,String> paramsMap = RestContext.request.params;
		String accIndustry = paramsMap.get('industry');
		List<Account> accountList = [Select id,Name,Industry from Account where Industry = :accIndustry];
		return accountList;
	}

	@httpGet
    global static AccountWrapper getTopAccounts(){
		Map<String,String> paramsMap = RestContext.request.params;
		String accIndustry = paramsMap.get('industry');
		Set<Id> accIds = new Set<Id>();
		List<Account> accountList = [Select id,Name,Industry from Account where Industry = :accIndustry];
        for(Account acc:accountList){
			accIds.add(acc.id);
		}
		List<Contact> conList = [Select id,lastname,firstname,email from contact where accountId in :accIds];
        List<Case> caseList = [Select id,priority,subject from case where accountId in :accIds];
        AccountWrapper accWrapper = new AccountWrapper();
        accWrapper.accList = accountList;
		accWrapper.conList = conList;
		accWrapper.caseList = caseList;
		return accWrapper;
	}

	//getting related data using wrapper calss
    global class AccountWrapper{
		global List<Account> accList;
		global List<Contact> conList;
		global List<Case> caseList;
    }*/
	

	/*@httpPost
    global static String createAccount(String accName,String accRating,String accIndustry){
		Account acc = new Account();
		acc.Name = accName;
		acc.Rating = accRating;
		acc.Industry = accIndustry;
        try{
			insert acc;
			return 'Account Created Successfully';
        }catch(exception ex){
			return ex.getMessage();
        }
	}*/
	
	@httpPost
    global static String createAccountAndContact(AccountInformation information){
		Account accRecord = information.accountRecord;
        Contact conRecord = information.contactRecord;
        try{
			insert accRecord;
            conRecord.accountId = accRecord.Id;
			insert conRecord;
			return 'Account and Contact Created Successfully';
        }
        catch(exception ex){
            return ex.getMessage();
        }
	}
	
    global class AccountInformation{
        global Account accountRecord {get;set;}
		global Contact contactRecord {get;set;}
	}

	@httpdelete
    global static String deleteAccount(){
		Map<String,String> paramsMap = RestContext.request.params;
        String accountId = paramsMap.get('accid');
		List<Account> accountList = [Select id from Account where id = :accountId];
        if(!accountList.isEmpty()){
            try{
				delete accountList;
				return 'Record deleted successfully';
            }catch(exception ex){
               return ex.getMessage(); 
            }
        }else{
            return 'Record Not found';
        }
	}	
}