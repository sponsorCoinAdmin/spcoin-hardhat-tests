// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
/// @title ERC20 Contract
import "../accounts/UnSubscribe.sol";
import "../accounts/Transactions.sol";

contract StakingManager is UnSubscribe{
    constructor() {
    }

    // SPONSOR   ~ Deposit Sponsor Rewards means as a SPONSOR deposit rewards baser on my source(Recipient)
    //             ~ _sourceKey  = RECIPIENT ADDRESS
    //             ~ _depositKey = SPONSOR ADDRESS
    // RECIPIENT ~ Deposit 
    //             ~ _sourceKey  = SPONSOR ADDRESS
    //             ~ _depositKey = RECIPIENT ADDRESS
    // AGENT     ~ Deposit 
    //             ~ _sourceKey  = RECIPIENT ADDRESS
    //             ~ _depositKey = AGENT ADDRESS

    function depositStakingRewards( uint _accountType, address _sponsorKey,
                                    address _recipientKey, uint _recipientRate,
                                    address _agentKey, uint _agentRate, uint _amount)
        public returns ( uint ) {
        // console.log("SOL=>1.0 getAccountTypeString(_accountType)", getAccountTypeString(_accountType));

        address sourceKey = _recipientKey;
        address depositKey = _agentKey;
        uint rate = 0;
        string memory errMsg = "";
        if (_accountType == SPONSOR) { 
            _recipientRate  = annualInflation;
            errMsg = concat("RECIPIENT ACCOUNT ",  toString(_recipientKey), " NOT FOUND FOR SPONSOR ACCOUNT ",  toString(_sponsorKey));
            require (sponsorHasRecipient( _recipientKey, _sponsorKey ), errMsg);
console.log("SPONSOR BEFORE _amount",toString(_amount));
            _amount -= (_amount * annualInflation) / 100;
console.log("SPONSOR AFTER _amount",toString(_amount));
            sourceKey = _recipientKey;
            depositKey = _sponsorKey;
            rate = _recipientRate;
        } else if (_accountType == RECIPIENT) { 
            errMsg = concat("SPONSOR ACCOUNT ",  toString(_sponsorKey), " NOT FOUND FOR RECIPIENT ACCOUNT ",  toString(_recipientKey));
            require (recipientHasSponsor( _sponsorKey, _recipientKey ), errMsg);
            uint sponsorAmount = (_amount/_recipientRate) * 100;
console.log("RECIPIENT BEFORE _amount",toString(_amount));
            _amount -= (_amount * _recipientRate) / 100;
console.log("RECIPIENT AFTER _amount",toString(_amount));
            depositStakingRewards(SPONSOR, _sponsorKey,
                                _recipientKey, _recipientRate,
                                _agentKey, _agentRate, sponsorAmount);
            sourceKey = _sponsorKey;
            depositKey = _recipientKey;   
            rate = _recipientRate;
        } else if (_accountType == AGENT) {
            errMsg = concat("RECIPIENT ACCOUNT ",  toString(_recipientKey), " NOT FOUND FOR AGENT ACCOUNT ",  toString(_agentKey));
            require (agentHasRecipient( _recipientKey, _agentKey ), errMsg);
            uint recipientAmount = (_amount/_agentRate) * 100;
console.log("AGENT _amount",toString(_amount));
            depositStakingRewards(RECIPIENT, _sponsorKey,
                                _recipientKey, _recipientRate,
                                _agentKey, _agentRate, recipientAmount);
            sourceKey = _recipientKey;
            depositKey = _agentKey;
            rate = _agentRate;
        }
        return depositAccountStakingRewards( _accountType, sourceKey, depositKey, rate, _amount );
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function depositAccountStakingRewards( uint _accountType, address _sourceKey, address _depositKey, uint _rate, uint _amount )
        internal returns ( uint ) {
        require (_amount > 0, "AMOUNT BALANCE MUST BE LARGER THAN 0");
        // console.log("SOL=>2.0 depositAccountStakingRewards(_accountType)", getAccountTypeString(_accountType));
        // console.log("SOL=>2.1 _sourceKey  = ", _sourceKey);
        // console.log("SOL=>2.2 _depositKey = ", _depositKey);
        // console.log("SOL=>2.3 _rate       = ", _rate);
        // console.log("SOL=>2.4 _amount     = ", _amount);
        totalSupply += _amount;

        // console.log("SOL=>4 FETCHING depositAccount = accountMap[", _depositKey, "]");
        AccountStruct storage depositAccount = accountMap[_depositKey];

        RewardTypeStruct storage rewardsRecord = depositAccount.rewardsMap[getAccountTypeString(_accountType)];

        depositAccount.totalStakingRewards += _amount;
        rewardsRecord.stakingRewards += _amount;
        // mapping(address => RewardAccountStruct) storage rewardsMap = rewardsRecord.rewardsMap;

        RewardAccountStruct storage rewardAccountRecord;

        rewardAccountRecord = rewardsRecord.rewardsMap[_sourceKey];
        // console.log("SOL=>2.6 rewardsRecord.stakingRewards   = ", rewardsRecord.stakingRewards);
        // console.log("SOL=>2.7 rewardsRecord.stakingRewards = ", rewardsRecord.stakingRewards);
        // console.log("SOL=>2.8 rewardsRecord.stakingRewards     = ", rewardsRecord.stakingRewards);

        rewardAccountRecord.stakingRewards += _amount;

        uint256[] storage rewardRateList = rewardAccountRecord.rewardRateList;
        RewardRateStruct storage rewardRateRecord = rewardAccountRecord.rewardRateMap[_rate];
        if (rewardRateRecord.rate != _rate) {
            rewardRateList.push(_rate);
            rewardRateRecord.rate = _rate;
        }
        // console.log("SOL=>2.9 rewardRateList.length = ",rewardRateList.length);
        // console.log("SOL=>2.10 rewardRateRecord.rate = ",rewardRateRecord.rate);
        rewardRateRecord.stakingRewards += _amount;
        // console.log("SOL=>2.11 rewardRateRecord.stakingRewards = ", rewardRateRecord.stakingRewards);
        RewardsTransactionStruct[] storage rewardTransactionList = rewardRateRecord.rewardTransactionList;
        depositRewardTransaction( rewardTransactionList, _amount );
        // console.log("SOL=>2.12 rewardTransactionList[0].stakingRewards = ", rewardTransactionList[0].stakingRewards);

        // TESTING REMOVE LATER
        // console.log("===================================================================================================================");
        // uint rewardSourceType = getRewardSourceType(_accountType);
        // console.log("SOL=>2.13 rewardSourceType = ", getAccountTypeString(rewardSourceType));
        getRewardAccounts(_depositKey, _accountType);
        // console.log("===================================================================================================================");
        //END TESTION

        return rewardAccountRecord.stakingRewards;
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function getRewardAccounts(address _accountKey, uint _rewardType)
        public view returns (string memory memoryRewards) {
        // console.log("SOL=>17 getRewardAccounts(", _accountKey, ", ", getAccountTypeString(_rewardType));
        
        memoryRewards = "";
        AccountStruct storage depositAccount = accountMap[_accountKey];
        address[] storage accountSearchList;
        string memory ACCOUNT_TYPE_DELIMITER = "";
        if ( _rewardType == SPONSOR ) {
           accountSearchList = depositAccount.recipientAccountList;
           ACCOUNT_TYPE_DELIMITER = "RECIPIENT_ACCOUNT:";
        }
        else if ( _rewardType == RECIPIENT ) {
           accountSearchList = depositAccount.sponsorAccountList;
           ACCOUNT_TYPE_DELIMITER = "SPONSOR_ACCOUNT:";
        }
        else if ( _rewardType == AGENT ) {
            accountSearchList = depositAccount.agentsParentRecipientAccountList;
            ACCOUNT_TYPE_DELIMITER = "RECIPIENT_ACCOUNT:";
        }
        else return memoryRewards;

        // Check the Recipient's Sponsor List
        // console.log("SOL=>17.1 accountSearchList.length = ", accountSearchList.length);
        for (uint idx = 0; idx < accountSearchList.length; idx++) {
            address accountKey = accountSearchList[idx];
        // console.log("SOL=>17.2 accountKey =", accountKey);
           memoryRewards = concat(memoryRewards, ACCOUNT_TYPE_DELIMITER, toString(accountKey));
        // console.log("SOL=>17.3 memoryRewards =", accountKey);

            ///////////////// **** START REPLACE LATER **** ///////////////////////////

            RewardTypeStruct storage rewardsRecord = depositAccount.rewardsMap[getAccountTypeString(_rewardType)];
            RewardAccountStruct storage accountReward;
            accountReward = rewardsRecord.rewardsMap[accountKey];
            memoryRewards = concat(memoryRewards, getRewardRateRecords(accountReward));

            // console.log("SOL=>17 accountKey[", idx,"] = ", accountSearchList[idx]);
            // console.log("SOL=>17.4 memoryRewards =", accountKey);
        }
        // console.log("SOL=>17.5 RETURNING MEMORY REWARDS =", memoryRewards);
        return memoryRewards;
    }

    function getRewardRateRecords(RewardAccountStruct storage _rewardAccountRecord)
        internal  view returns (string memory memoryRewards) {
// console.log("SOL=>18 getRewardRateRecords(RewardAccountStruct storage _rewardAccountRecord)");
        
        uint256[] storage rewardRateList = _rewardAccountRecord.rewardRateList;
// console.log("SOL=>18.1 BEFORE memoryRewards", memoryRewards);
// console.log("*** ISSUE HERE SOL=>18.2 rewardRateList.length", rewardRateList.length);

        for (uint rateIdx = 0; rateIdx < rewardRateList.length; rateIdx++) {
            uint rate = rewardRateList[rateIdx];
// console.log("SOL=>18.3 rate", rate);

            RewardRateStruct storage rewardRateRecord = _rewardAccountRecord.rewardRateMap[rate];
            RewardsTransactionStruct[] storage rewardTransactionList = rewardRateRecord.rewardTransactionList;

            memoryRewards = concat(memoryRewards, ",", toString(_rewardAccountRecord.stakingRewards));
                // console.log("SOL=> _rewardAccountRecord.rewardTransactionList.length         = ", _rewardAccountRecord.rewardTransactionList.length);
                // console.log("SOL=> _rewardAccountRecord.rewardTransactionList.stakingRewards = ", _rewardAccountRecord.stakingRewards);
            memoryRewards = concat(memoryRewards, "\nRATE:", toString(rate));
            memoryRewards = concat(memoryRewards, ",", toString(rewardRateRecord.stakingRewards));

// console.log("SOL=>18.4 rewardTransactionList.length", rewardTransactionList.length);
            if (rewardTransactionList.length != 0) {
                string memory stringRewards = serializeRewardsTransactionList(rewardTransactionList);
// console.log("SOL=>18.5 stringRewards", stringRewards);
                memoryRewards = concat(memoryRewards, "\n" , stringRewards);
            }
        }
        // console.log("SOL=>21 AFTER memoryRewards", memoryRewards);
        // console.log("*** END SOL ******************************************************************************");
// console.log("SOL=>18.6 stringRewards", memoryRewards);
        return memoryRewards;
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
















    function depositRewardTransaction(  RewardsTransactionStruct[] storage rewardTransactionList,
                                        uint _amount )  internal {
        // console.log("SOL=>9 depositRewardTransaction("); 
        // console.log("SOL=>10 stakingAccountRecord.stakingRewards = ", stakingAccountRecord.stakingRewards);
        // console.log("SOL=>12               _amount               = ", _amount, ")" );
        // console.log("SOL=>13 BEFORE rewardTransactionList.length = ", rewardTransactionList.length);

        RewardsTransactionStruct memory  rewardsTransactionRecord;
        rewardsTransactionRecord.stakingRewards = _amount;
        rewardsTransactionRecord.updateTime = block.timestamp;
        rewardTransactionList.push(rewardsTransactionRecord);
        // console.log("SOL=>14 AFTER rewardTransactionList.length = ", rewardTransactionList.length);
    }

//////////////// RETREIVE STAKING REWARDS /////////////////////////////////////////////////////////////////////

    function serializeRewardsTransactionList(RewardsTransactionStruct[] storage _rewardTransactionList)
        internal  view returns (string memory memoryRewards) {
        for (uint idx = 0; idx < _rewardTransactionList.length; idx++) {
            RewardsTransactionStruct storage rewardTransaction = _rewardTransactionList[idx];
            // console.log("SOL6=> rewardTransaction.updateTime     = ", rewardTransaction.updateTime);
            // console.log("SOL7=> rewardTransaction.stakingRewards = ", rewardTransaction.stakingRewards);

            memoryRewards = concat(memoryRewards, toString(rewardTransaction.updateTime));
            memoryRewards = concat(memoryRewards, ",", toString(rewardTransaction.stakingRewards));
            if (idx < _rewardTransactionList.length - 1) {
                memoryRewards = concat(memoryRewards , "\n" );
            }
           // console.log("SOL=>21 getRewardAccounts:Transaction =", memoryRewards);
           // console.log("rewardsRecordList", memoryRewards);
           // console.log("*** END SOL ******************************************************************************");
        }
        return memoryRewards;
    }

    function getSerializedAccountRewards(address _accountKey)
        public view returns (string memory) {
        require(isAccountInserted(_accountKey));
        return serializeRewards(accountMap[_accountKey]);
    }
}