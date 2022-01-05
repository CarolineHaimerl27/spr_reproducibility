#! /bin/bash


currdir=$1
for j in `ls $currdir/*.out`
do
    gamename=`cat $j |grep "Syncing run"|awk  '{print $4}' `
    gamescore=`cat $j |grep "GameScoreAverage" |tail -n 1|awk '{print $3}'`
    echo "$gamename, $gamescore" >> gamescores_${currdir}.dat
done
