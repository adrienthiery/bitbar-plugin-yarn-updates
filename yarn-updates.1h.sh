#!/bin/bash
# <bitbar.title>Yarn Updates</bitbar.title>
# <bitbar.author>adrienthiery</bitbar.author>
# <bitbar.author.github>adrienthiery</bitbar.author.github>
# <bitbar.desc>List available updates from Yarn (global)</bitbar.desc>

export PATH=/usr/local/bin:$PATH
export NVM_DIR="/Users/osedea/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

exit_with_error() {
  echo "err | color=red";
  exit 1;
}

SELF="$0"

list()
{
  TO_BE_UPGRADED=$(cd `yarn global dir` && yarn outdated | cut -d" " -f1 | awk '$1 != "yarn" && $1 != "info" && $1 != "" && $1 != "Package" && $1 != "Done" { print $0 }');

  UPDATE_COUNT=$(echo "$TO_BE_UPGRADED" | grep -c '[^[:space:]]');

  echo "↑$UPDATE_COUNT | dropdown=false"
  echo "---";
  if [ -n "$TO_BE_UPGRADED" ]; then
    echo "Upgrade all | bash=$SELF param1=upgrade-all terminal=false refresh=true"
    echo "$TO_BE_UPGRADED" | awk '{print $0 " | terminal=false refresh=true bash='$SELF' param1=upgrade-one param2="$0}'
  fi
}

upgrade_all()
{
  echo "Upgrading all" > /Users/osedea/Documents/BitBar/logs
  nvm use default &> /Users/osedea/Documents/BitBar/logs
  yarn global upgrade &> /Users/osedea/Documents/BitBar/logs
}

upgrade_one()
{
  echo "yarn global add $1" > /Users/osedea/Documents/BitBar/logs
  nvm use default &> /Users/osedea/Documents/BitBar/logs
  yarn global add $1 &> /Users/osedea/Documents/BitBar/logs
}

if [ "$1" = "upgrade-all" ]; then
    upgrade_all
elif [ "$1" = "upgrade-one" ]; then
    upgrade_one $2
else
    list
fi
