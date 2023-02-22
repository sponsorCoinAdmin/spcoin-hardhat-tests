const { testHHAccounts, LSA, loadJunk  } = require("./hhTestAccounts");
const { AccountStruct,
        SponsorStruct,
        AgentStruct,
        RateHeaderStruct,
        TransactionStruct } = require("./dataTypes");

let spCoinContractDeployed;
let prefixText = "  ";
let indent = 2;

/*
console.log( AccountStruct.toString() );
console.log( SponsorStruct.toString() );
console.log( AgentStruct.toString() );
console.log( RateStruct.toString() );
console.log( TransactionStruct.toString() );
*/

loadTreeStructures = async(_spCoinContractDeployed) => {
    spCoinContractDeployed = _spCoinContractDeployed;
    let accountMap  = new Map;
    logFunctionHeader("dumpAccounts = async()");
    log("************************* dumpAccounts() *************************");
    let insertedArrayAccounts = await getInsertedAccounts();
//    dumpArray("Record ", insertedArrayAccounts);
    let maxCount = insertedArrayAccounts.length;
    let prefix = "";
//    logDetail("DUMPING " + maxCount + " ACCOUNT RECORDS");
    for(let idx = 0; idx < maxCount; idx++) {
        let accountKey = insertedArrayAccounts[idx];
        let accountStruct = new AccountStruct(accountKey);

        accountStruct.index = idx;
        accountStruct.accountKey = accountKey;
        logPrefix(prefix, "accountStruct(accountKey) = accountStruct(" + accountKey + ")");
        log(accountStruct.toString(prefix + "  "));

        accountMap.set(accountKey, accountStruct);

        log("Account[" + idx + "]:" + accountKey );
        accountStruct.sponsorMap = await loadAccountSponsors(2, accountKey);
    }
    return accountMap;
}

loadAccountSponsors = async(_logLevel, _accountKey) => {
    logFunctionHeader("loadAccountSponsors = async(" + _accountKey + ")");
    let prefix = setIndentPrefixLevel(prefixText, _logLevel);
    let sponsorMap = new Map;
    insertedAccountSponsors = await getInsertedAccountSponsors("Sponsor", _accountKey);
    let maxCount = insertedAccountSponsors.length;
    logDetail("   DUMPING " + maxCount + " SPONSOR RECORDS");

    for(let idx = 0; idx < maxCount; idx++) {
        let sponsorKey = insertedAccountSponsors[idx];
        let sponsorIndex = await spCoinContractDeployed.getSponsorIndex(_accountKey, sponsorKey);
        let sponsorActIdx = await spCoinContractDeployed.getAccountIndex(sponsorKey);
        sponsorStruct = new SponsorStruct(sponsorKey);

        sponsorStruct.index = idx;
        sponsorStruct.parentAccountKey = _accountKey;
        sponsorStruct.sponsorKey = sponsorKey;
        logPrefix(prefix, "sponsorStruct(sponsorKey) = sponsorStruct(" + sponsorKey + ")");
        log(sponsorStruct.toString(prefix + "  "));

        sponsorMap.set(sponsorKey, sponsorStruct);
        logPrefix(prefix, "Sponsor[" + sponsorIndex + "] => Account[" + sponsorActIdx + "]:" + sponsorKey);
        sponsorStruct.agentMap = await loadSponsorAgents(_logLevel + indent, _accountKey, sponsorKey);
    }
    return sponsorMap;
}

loadSponsorAgents = async(_logLevel, _accountKey, _sponsorKey) => {
    logFunctionHeader("loadSponsorAgents = async(" + _accountKey + ", " + _sponsorKey + ")");
    let prefix = setIndentPrefixLevel(prefixText, _logLevel);
    let agentMap  = new Map;
    let insertedSponsorAgents = await getInsertedSponsorAgents("Agent", _accountKey, _sponsorKey);
    let maxCount = insertedSponsorAgents.length;
//    log("        DUMPING " + maxCount + " AGENT RECORDS FOR SPONSOR " + _sponsorKey);
    for(let idx = 0; idx < maxCount; idx++) {
        let agentKey = insertedSponsorAgents[idx];
        let agentIndex = await spCoinContractDeployed.getAgentIndex(_accountKey, _sponsorKey, agentKey);
        let agentActIdx = await spCoinContractDeployed.getAccountIndex(agentKey);
        agentStruct = new AgentStruct(agentKey);

        agentStruct.index = idx;
        agentStruct.accountKey = _accountKey;
        agentStruct.parentSponsorKey = _sponsorKey;
        agentStruct.agentKey = agentKey;
        logPrefix(prefix, "agentStruct(agentKey) = agentStruct(" + agentKey + ")");
        log(agentStruct.toString(prefix + "  "));

        agentMap.set(agentKey, agentStruct);
        logPrefix(prefix, "Agent[" + agentIndex + "] => Account[" + agentActIdx + "]:" + agentKey);
    }
    return agentMap;
}

module.exports = {
    loadTreeStructures,
    loadAccountSponsors,
    loadSponsorAgents
}