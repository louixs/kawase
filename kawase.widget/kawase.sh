#!/bin/bash

cd kawase.widget

database=assets/kawase.db

function clean(){
  if [ -a $database ]; then
    db_file_size=$(ls -l $database | awk '{print $5}')
    #if the curr.db file size is bigger than 20 Mb, remove
    if (("$db_file_size" > "20000000")); then
      rm $database
    fi
  fi
}

#=== cleaning ====#
clean #run cleaning
#======#

#function to scrape latest currency price on google finance 
function scrapeCurr() {
  agent="Googlebot/2.1 (+http://www.google.com/bot.html)"
  currInput=$1
  currData=$(curl -sAL $agent http://finance.google.com/finance/info\?client\=ig\&q\=CURRENCY:$1 | grep '"l"' | awk '{print $3}' | tr -d ' " ')

#https://www.google.com/finance\?q\=$currInput | ./pup '.pr .bld' | tail -c21 | head -c8

  echo $currData

}

#using the function to obtain curr data from google
usdjpy=$( scrapeCurr "USDJPY")
eurjpy=$( scrapeCurr "EURJPY")
gbpjpy=$( scrapeCurr "GBPJPY")
sgdjpy=$( scrapeCurr "SGDJPY")

currTime=$( date +%b" "%d" "%a" "%T )

#echo "$currTime"
echo "datetime $currTime,USD/JPY $usdjpy,EUR/JPY $eurjpy,GBP/JPY $gbpjpy,SGD/JPY $sgdjpy" >> $database

last_two=$(cat $database | tail -n2)
previous=$(echo $last_two | head -n1)
latest=$(echo $last_two | tail -n1)


echo "$previous;$latest"
