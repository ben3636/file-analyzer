#!/bin/bash

###---DEFINE FUNCTIONS---###
function load(){
        for i in range {1..5}
        do
                echo "."
                echo
                sleep .05
        done
}

###---Initialize Hexdump File & List Signature Files---###
clear
file=$1
if [[ $1 == '' ]]
then
	echo "Must Specify Target File"
	load
	exit 0
else
	hexdump $1 | cut -f 2- -d " " > dump
fi
ls -1 sigs > sigs_list

###---Search Hexdump for Signatures---###
echo '' > hits
echo '' > Analysis-Report.txt
echo "Analyzing File..."
load
cat sigs_list | while read line
do
	magic_bytes=$(cat sigs/$line | grep Signature | awk ' { print $2 } ' | sed s/-/" "/g)
        result=$(cat dump | grep -io "$magic_bytes" | tee result)
	if [[ $result != '' ]]
	then
		echo $line >> hits
		num_of_hits=$(wc -l result)
		echo "$num_of_hits ---> $line ---> $magic_bytes" >> Analysis-Report.txt
	fi
done
cat Analysis-Report.txt | sort -r
