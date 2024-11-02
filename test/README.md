# dev-contracts-spCoin

NOTE: This is the leader page for sponsorCoin setup

// SETTING UP THE HARDHAT TESTING ENVIRONMENT
    Step 1. Create a directory where you want to setup your sponsorCoin development environment
    Step 2. Download file https://github.com/sponsorCoinAdmin/sponsorCoinDev/blob/main/spCoinEnvSetup/spCoinSetup.sh from git repository.
    Step 3. Run the downloaded script as follows ". spCoinSetup.sh".
    Step 4. Use the example SAMPLE.env file to setup your keys for the network you are using.
    Step 5. cd into the development environment and run the test commands:
        5.1 Validate the SPONSOR_COIN_HOME by executing $SPONSOR_COIN_HOME.
        5.2 Validate the SPONSOR_COIN_ENV by executing $SPONSOR_COIN_ENV.
        5.3 Run the hardhat network tests as follows "hhtest".

// DEPLOYING TO SEPOLIA test network
    Step 1. Review the $SPONSOR_COIN_HOME/hardhat.config.js configuration file for  the sepolia network.
    Step 2. Ensure your .env is setup. See $SPONSOR_COIN_ENV/SAMPLE.env example file.
    Step 3. Deploy to sepolia by executing deployment script $SPONSOR_COIN_HOME/scripts/deploy.js
   
// DEPLOYING SPONSOR COIN ON REMIX
    ToDo: