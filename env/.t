#TESTING ALIAS MANAGEMENT
alias t=". $SPONSOR_COIN_ENV/.t"
alias tm=". $SPONSOR_COIN_ENV/.tm"
alias vt="vi $SPONSOR_COIN_ENV/.t;t"
alias vtm="vi $SPONSOR_COIN_ENV/.tm;tm"

# TESTING ALIAS COMMAND'S
alias hhcompile="clear;npx hardhat compile"
alias hhdeploy="npx hardhat run scripts/deploy.js --network sepolia"
alias hhdeploygoerli="npx hardhat run scripts/deploy.js --network goerli"
alias hhnode="clear; npx hardhat node  2>&1 > $SPONSOR_COIN_LOGS/hhnode.out &"
alias hhsize="npx hardhat size-contracts"
alias hhtest="reset;clear; npx hardhat test 2>&1 | tee ./test.out/hhtest.out"
alias remixd="nohup node $SPONSOR_COIN_HOME/node_modules/@remix-project/remixd/src/bin/remixd.js 2>&1 > $SPONSOR_COIN_LOGS/remixd.out &"
