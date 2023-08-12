# NOTE: Requires git setup

currDir=$PWD
repo=spCoinHardHatTests
# repo=spCoinUniSwapTests
git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$repo.git
cd ./$repo/setupEnv
. ./spCoinEnvSetup.sh
cd $currDir
