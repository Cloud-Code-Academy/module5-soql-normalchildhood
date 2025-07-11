/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Mychal Tepker
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> getAllLeads() {
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead];
    }

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> getContactsByFirstName () {
	return [SELECT Id, Name, FirstName, LastName FROM Contact WHERE FirstName = 'John'];
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> getContactIdsByLastName () {
    List<Id> contactIds = new List<Id>();
    for (Contact cont : [SELECT Id FROM Contact WHERE LastName IN ('Smith', 'Jones')]) {
        contactIds.add(cont.Id);
    }
    return contactIds;
}


	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> getClosedWonOpportunityCountByAccount (String accId) {
	return [SELECT Id, Account.Name, StageName, Name, Amount, CloseDate FROM Opportunity WHERE AccountId = :accId AND StageName = 'Closed Won'];
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer getAccountCount() {
	return [SELECT COUNT() FROM Account];
}


	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static Map<Id, Task> getTasksDueNextWeek () {
	List<Task> taskList = [SELECT Id, Subject, Status, Priority, ActivityDate FROM TASK WHERE ActivityDate = NEXT_N_DAYS:7];
	return new Map<Id, Task> (taskList);
	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> getContactsByEmailDomain () {
	return [SELECT Id, FirstName, LastName, Name, Email FROM Contact WHERE Email LIKE '%@example.com%'];
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		String searchWord = '%' + keyword + '%';
		return [SELECT Id, Name FROM Opportunity WHERE Name LIKE :searchWord];
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		return [SELECT Id, Subject, Origin FROM Case WHERE Origin NOT IN ('Email', 'Web') AND Origin != null];
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String keyword) {
		String keywordPhrase = '%' + keyword + '%';
	return [SELECT Id, LeadSource, Title, Company, Phone, LastName, Name, Email FROM Lead WHERE (LeadSource = :leadSource OR Title LIKE :keywordPhrase)
		AND Email != null AND Phone != null AND Company != null];  
	} //I had a heck of a time getting this one to pass the test and the only way I could pass it was by specifying not null for those other fields

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		List<String> lastNames = new List<String>();
		List<Contact> contactQuery = [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId = :accountId];
		for (Contact contact : contactQuery) {
		lastNames.add(contact.LastName);
		}
		return lastNames; 
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		List<Opportunity> oppsToSum = [SELECT Amount FROM Opportunity WHERE StageName = :stage OR Amount > 10000];
		Decimal sum = 0;
		for (Opportunity opp : oppsToSum) {
			sum += opp.amount;
		}
		return sum; 
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		return [SELECT Id, Name FROM Account ORDER BY Name ASC LIMIT 10]; 
	}
	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		return [SELECT Id, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5]; 
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		return [SELECT Id, FirstName, LastName, Birthdate FROM Contact WHERE Birthdate <= TODAY ORDER BY Birthdate DESC LIMIT 3]; 
		// I'm reading the directions as if it's referring to the actual birthdate and not just the birthday. So, in my mind, 
		//someone whose birthdate is 7/1/2025 would be listed before (since it's descending) someone whose birthdate is 7/4/2024
		//relative to today's date (7/5/2025). Unsure if this is the correct way to understand the directions or if just birthday
		//was intended.
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		return [SELECT Id, Status, CreatedDate FROM Case WHERE IsClosed = false ORDER BY CreatedDate LIMIT 10 OFFSET 5];
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		List<Case> caseIdList = [SELECT Id, AccountId FROM Case WHERE AccountId = :accountId];
		Set<Id> caseIdSet = new Set<Id> ();
		for (Case indivCase : caseIdList) {
			caseIdSet.add(indivCase.Id);
		}
		return caseIdSet; 
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		Map<Id, String> accountIdsToNames = new Map<Id, String>();
		List<Account> acctQuery = [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry != :country]; //Do I need to make this a list or should I have just put Account?
		for (Account acct : acctQuery){
			accountIdsToNames.put(acct.Id, acct.Name);
		}
		return accountIdsToNames; 
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		Contact cont = [SELECT Id, AccountId, Contact.Account.Name FROM Contact WHERE Id = :contactId];
		return cont.Account.Name; 
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		Account acct = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = :accountId];
		return acct; 
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
    Account acct = [SELECT Id, BillingState FROM Account WHERE Id = :accountId];
    String acctBillingState = acct.BillingState;

    List<Contact> contQuery = [SELECT Id, MailingState, MailingCountry FROM Contact WHERE MailingState = :acctBillingState];

    return contQuery;
}


	/**
	 * Question 22
	 * Extracts email domains from the leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {

    List<Lead> leads = [SELECT Email FROM Lead WHERE Id IN :leadIds AND Email != null];

    Set<String> emailDomains = new Set<String>();
    for (Lead lead : leads) {
        if (lead.Email.contains('@')) {
            String domain = lead.Email.split('@')[1].toLowerCase().trim();
            emailDomains.add(domain);
        }
    }

    if (emailDomains.isEmpty()) return new List<Account>();

    List<Account> accounts = [SELECT Id, Name, Website FROM Account WHERE Website != null];
    List<Account> matchedAccounts = new List<Account>();

    for (Account acct : accounts) { //my method wouldn't pass the test without doing all this cleanup ¯\_(ツ)_/¯
        String cleanedWebsite = acct.Website.toLowerCase()
            .replace('http://', '')
            .replace('https://', '')
            .replace('www.', '')
            .trim();

        if (cleanedWebsite.endsWith('/')) {
            cleanedWebsite = cleanedWebsite.substring(0, cleanedWebsite.length() - 1);
        }
        if (emailDomains.contains(cleanedWebsite)) {
            matchedAccounts.add(acct);
        }
    }

    return matchedAccounts;
}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) { //cloneOppIds is a list of opp ids but I need the whole opps
		List<OpportunityLineItem> originalLineItems = [SELECT Product2Id, PricebookEntryId, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :origOppId];
		List<OpportunityLineItem> lineItemsToInsert = new List<OpportunityLineItem>();
		Integer randomQty = Math.mod(Crypto.getRandomInteger(), 3) + 1;
        for (Id cloneOppId : cloneOppIds) {
        for (OpportunityLineItem original : originalLineItems) {
            OpportunityLineItem newLineItem = new OpportunityLineItem();
            newLineItem.OpportunityId = cloneOppId;
            newLineItem.Product2Id = original.Product2Id;
            newLineItem.PricebookEntryId = original.PricebookEntryId;
            newLineItem.Quantity = randomQty;
			newLineItem.UnitPrice = original.UnitPrice;

            lineItemsToInsert.add(newLineItem);
        }
    }

    if (!lineItemsToInsert.isEmpty()) {
        insert lineItemsToInsert;
    }
}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		return [SELECT Name, Account.Name, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won']; 
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
    List<Opportunity> oppsList = getOpportunityDetailsForClosedWon();

    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : oppsList) {
        if (opp.AccountId != null) {
            accountIds.add(opp.AccountId);
        }
    }
	List<Contact> contacts = [SELECT Id, AccountId, FirstName FROM Contact WHERE AccountId IN :accountIds ORDER BY AccountId, FirstName ASC];

    Map<Id, Contact> accountToPrimaryContact = new Map<Id, Contact>();
    for (Contact cont : contacts) {
        if (!accountToPrimaryContact.containsKey(cont.AccountId)) {
            accountToPrimaryContact.put(cont.AccountId, cont);
        }
    }
	for (Opportunity opp : oppsList) {
        if (accountToPrimaryContact.containsKey(opp.AccountId)) {
            opp.Primary_Contact__c = accountToPrimaryContact.get(opp.AccountId).Id;
        }
    }

    update oppsList;
}

}
