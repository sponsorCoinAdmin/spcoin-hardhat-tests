export SPONSOR_COIN_ENV=$PWD;
export SPONSOR_COIN_DIR=${SPONSOR_COIN_ENV%/*};
export SPONSOR_COIN_ROOT=${SPONSOR_COIN_DIR%/*};
export SPONSOR_COIN_LOGS=$SPONSOR_COIN_ENV/logs


export SPONSOR_COIN_DIR=sponsorCoinHHTests;
export SPONSOR_COIN_ROOT=$PWD

export SPONSOR_COIN_DIR=sponsorCoinHHTests;
echo "DownLoading Sponsor Coin Development Envirement from gitHub"
git clone --recurse-submodules git@github.com:sponsorCoinAdmin/$SPONSOR_COIN_DIR.git
cd $SPONSOR_COIN_DIR
. ./spCoinEnvSetup.sh


echo "Installing the Node Libraries"
npm i
echo "Configuring SponsorCoin Environment"
export SPONSOR_COIN_HOME=$SPONSOR_COIN_ROOT/$SPONSOR_COIN_DIR
export SPONSOR_COIN_ENV=$SPONSOR_COIN_HOME/$SPONSOR_COIN_DEV_DIR

echo "Adding startup configuration Files to Sponsor Coin environment setup file $SPONSOR_COIN_ENV/.e"
echo "export SPONSOR_COIN_HOME=$SPONSOR_COIN_HOME" | tee -a $SPONSOR_COIN_ENV/.e
echo "export SPONSOR_COIN_ENV=$SPONSOR_COIN_ENV" | tee -a $SPONSOR_COIN_ENV/.e
echo "export SPONSOR_COIN_LOG=$SPONSOR_COIN_LOGS" | tee -a $SPONSOR_COIN_ENV/.e

echo "Adding sponsor coin startup configuration Files to bootstrap file ~/.baschrc"
echo ". "$SPONSOR_COIN_ENV"/.e" | tee -a ~/.bashrc
. $SPONSOR_COIN_ENV/.e
echo "***IMPORTANT *** Please ensure the '.env' file is configured for proper operations"
