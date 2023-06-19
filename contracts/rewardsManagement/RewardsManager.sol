// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
/// @title ERC20 Contract
import "./StakingManager.sol";

contract RewardsManager is StakingManager{
    constructor() {
    }

    function updateRewards( address _sourceKey , uint _accountType )
        public view {
        AccountStruct storage account = accountMap[_sourceKey];
        RewardTypeStruct storage rewardsRecord = account.rewardsMap[getAccountTypeString(_accountType)];
        RewardAccountStruct storage rewardAccountRecord;
        rewardAccountRecord = rewardsRecord.rewardsMap[_sourceKey];
        updateSponsorRewardRecords(rewardAccountRecord);
    }

    function updateSponsorRewardRecords( RewardAccountStruct storage rewardAccountRecord )
        internal view returns (uint  rewards) {
        rewards = updateRewardRecords( rewardAccountRecord );
        return rewards;
    }

    function updateRecipientRewardRecords( RewardAccountStruct storage rewardAccountRecord )
        internal  view returns (uint  rewards) {

        rewards = updateRewardRecords( rewardAccountRecord );
        return rewards;
    }

    function updateAgentRewardRecords( RewardAccountStruct storage rewardAccountRecord )
        internal view returns (uint  rewards) {

        rewards = updateRewardRecords( rewardAccountRecord );
        return rewards;
    }

    function updateRewardRecords( RewardAccountStruct storage rewardAccountRecord )
        internal view returns (uint  rewards) {

        uint256[] storage rewardRateList  = rewardAccountRecord.rewardRateList;
        // mapping(uint256 => RewardRateStruct) storagerewardRateMap;

        for (uint idx = 0; idx < rewardRateList.length; idx++) {
            uint rateIdx = rewardRateList[idx];
            RewardRateStruct memory rewardRateRecord = rewardAccountRecord.rewardRateMap[rateIdx];
            rewards += getCalculateRewards(year, rewardRateRecord.rate, rewardRateRecord.stakingRewards);
        }
        return rewards;
   }

    function getCalculateRewards(uint lastUpdateTime, uint interestRate, uint quantity) public view returns(uint rewards) {
        uint accountTimeInSecondeSinceUpdate = getTimeMultiplier(lastUpdateTime);
        rewards = (quantity * accountTimeInSecondeSinceUpdate * interestRate) / 100;
        return rewards;
    }

}