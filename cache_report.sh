#!/bin/bash

for file in $@; do
    events=`grep 'Events shown' $file`
    totals=`grep 'PROGRAM TOTALS' $file`
    FS=';' read -ra totals_arr <<< "$totals"

	Dr=`  echo ${totals_arr[3]} | sed 's/,//g'`
	D1mr=`echo ${totals_arr[4]} | sed 's/,//g'`
	DLmr=`echo ${totals_arr[5]} | sed 's/,//g'`
	Dw=`  echo ${totals_arr[6]} | sed 's/,//g'`
	D1mw=`echo ${totals_arr[7]} | sed 's/,//g'`
	DLmw=`echo ${totals_arr[8]} | sed 's/,//g'`
	echo $file: Data, L1 writes: `expr $(expr 100 '*' $D1mw) '/' $Dw`%
	echo $file: Data, L1 reads : `expr $(expr 100 '*' $D1mr) '/' $Dw`%
	echo $file: Data, LL writes: `expr $(expr 100 '*' $DLmw) '/' $Dw`%
	echo $file: Data, LL reads : `expr $(expr 100 '*' $DLmr) '/' $Dw`%
	echo ''
done
