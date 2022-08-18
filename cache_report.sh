#!/bin/bash

for file in $@; do
    events=`grep 'Events shown' $file`
    totals=`grep 'PROGRAM TOTALS' $file`
    FS=';' read -ra totals_arr <<< "$totals"

    #echo "${totals_arr[*]}"

    M=1
    if [[ ${totals_arr[1]} =~ \(.*\) ]];
    then
        M=2
    fi

    Dr=`  echo ${totals_arr[3*$M]} | sed 's/,//g'`
    D1mr=`echo ${totals_arr[4*$M]} | sed 's/,//g'`
    DLmr=`echo ${totals_arr[5*$M]} | sed 's/,//g'`
    Dw=`  echo ${totals_arr[6*$M]} | sed 's/,//g'`
    D1mw=`echo ${totals_arr[7*$M]} | sed 's/,//g'`
    DLmw=`echo ${totals_arr[8*$M]} | sed 's/,//g'`

    D1mwp=`expr $(expr 100 '*' $D1mw) '/' $Dw`
    D1mrp=`expr $(expr 100 '*' $D1mr) '/' $Dr`
    DLmwp=`expr $(expr 100 '*' $DLmw) '/' $Dw`
    DLmrp=`expr $(expr 100 '*' $DLmr) '/' $Dr`

    echo ''
    printf '%s: Data, L1 write miss rate: % 3d%% of % 5d\n' $file $D1mwp $Dw
    printf '%s:          read  miss rate: % 3d%% of % 5d\n' $file $D1mrp $Dr
    printf '%s:       LL write miss rate: % 3d%% of % 5d\n' $file $DLmwp $Dw
    printf '%s:          read  miss rate: % 3d%% of % 5d\n' $file $DLmrp $Dr
    echo ''
done
