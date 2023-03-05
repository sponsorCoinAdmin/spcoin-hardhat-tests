// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
/// @title ERC20 Contract
import "../accounts/Agents.sol";

contract Rates is Agents{

    constructor(){
    }

    /// @notice insert sponsors Agent
    /// @param _rate Rate record for transaction
    function insertSponsorRate(uint256 _rate) public onlyOwnerOrRootAdmin(msg.sender) returns (bool) {
/*
        insertAccountSponsor(_accountKey, _sponsorAccountKey);
        // addAccountRecord(_agentAccountKey);
        // addAccountRecord(_sponsorAccountKey);
        addAccountRecord(_agentAccountKey);

        SponsorStruct storage sponsorRec = getAccountSponsorRecByKey(_accountKey, _sponsorAccountKey);
        AgentStruct storage  agentRec = getAgentRec(_accountKey, _sponsorAccountKey, _agentAccountKey);

        if (!agentRec.inserted) {
            agentRec.index = sponsorRec.accountAgentKeys.length;
            agentRec.insertionTime = block.timestamp;
            agentRec.account  = _accountKey;
            agentRec.sponsor  = _sponsorAccountKey;
            agentRec.agent    = _agentAccountKey;
            agentRec.inserted = true;
            sponsorRec.accountAgentKeys.push(_agentAccountKey);
            return true;
        */
    }

}
