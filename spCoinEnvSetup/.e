set -o vi

# ENVIRONMENT MENU SETTINGS
cd $SPONSOR_COIN_HOME
export SPONSOR_COIN_HOME=/c/Users/robin/OneDrive/Dev/gitRepo/sponsorcoin/WIP/sponsorCoinHHTests
export SPONSOR_COIN_ENV=/c/Users/robin/OneDrive/Dev/gitRepo/sponsorcoin/WIP/sponsorCoinHHTests/spCoinEnvSetup
export SPONSOR_COIN_LOGX=/c/Users/robin/OneDrive/Dev/gitRepo/sponsorcoin/WIP/sponsorCoinHHTests/spCoinEnvSetup/logs

# ALIAS ENVIRONMENT MENU SETTINGS
alias e=". $SPONSOR_COIN_ENV/.e"
alias me=". $SPONSOR_COIN_ENV/.me"
alias ve="vi $SPONSOR_COIN_ENV/.e;e"
alias vme="vi $SPONSOR_COIN_ENV/.me;me"

#SET UP ALIASES
. $SPONSOR_COIN_ENV"/.a"
. $SPONSOR_COIN_ENV"/.t"
alias  cdcurr="cd $SPONSOR_COIN_HOME"
cdcurr
tm
