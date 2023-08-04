# Requires git setup
export SPONSOR_COIN_ROOT_DIR=$PWD
export SPONSOR_COIN_DIR=sponsorCoinHHTests;
export SPONSOR_COIN_DEV_DIR=spCoinEnvSetup;
echo "DownLoading Sponsor Coin Development Envirement from gitHub"
git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$SPONSOR_COIN_DIR.git
cd $SPONSOR_COIN_DIR
. ./spCoinEnvSetup.sh
