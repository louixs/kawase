#!/bin/bash

cd kawase.widget

function clean(){
  if [ -a kawase.db ]; then
    db_file_size=$(ls -l kawase.db | awk '{print $5}')
    #if the curr.db file size is bigger than 20 Mb, remove
    if (("$db_file_size" > "20000000")); then
      rm kawase.db
    fi
  fi
}

#=== cleaning ====#
clean #run cleaning
#======#

#function to scrape latest currency price on google finance 
function scrapeGoogleCurr() {
  agent="Googlebot/2.1 (+http://www.google.com/bot.html)"
  currInput=$1
  currData=$(curl -sAL $agent http://finance.google.com/finance/info\?client\=ig\&q\=CURRENCY:$1 | grep '"l"' | awk '{print $3}' | tr -d ' " ')

#https://www.google.com/finance\?q\=$currInput | ./pup '.pr .bld' | tail -c21 | head -c8

  echo $currData

}

#using the function to obtain curr data from google
usdjpy=$( scrapeGoogleCurr "USDJPY")
eurjpy=$( scrapeGoogleCurr "EURJPY")
gbpjpy=$( scrapeGoogleCurr "GBPJPY")

currTime=$( date +%b" "%d" "%a" "%T )

#echo "$currTime"
echo "USD/JPY $usdjpy,""EUR/JPY $eurjpy,""GBP/JPY $gbpjpy" >> kawase.db

latest=$(less kawase.db | tail -n1)
previous=$(less kawase.db | tail -n2 | head -n1)

echo $previous":"$latest
