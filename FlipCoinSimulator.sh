#!/bin/bash -x

#CONSTANTS
IS_HEAD=0

#DECLARE DICTIONARY
declare -A singletDictionary

#READING VALUE FOR NO OF ITERATIONS
read -p "Enter No of Iterations : " numberIteration

for (( index=1; index<=$numberIteration; index++ ))
do
	randomFlip=$((RANDOM%2))
	#STORING HEADCOUNT AND TAILCOUNT IN DICTIONARY
	if [ $randomFlip -eq $IS_HEAD ]
	then
		((singletDictionary[HEADS]++))
	else
		((singletDictionary[TAILS]++))
	fi
done

percentHeads=`echo "scale=2; ${singletDictionary[HEADS]}*100/$numberIteration" | bc`
percentTails=`echo "scale=2; ${singletDictionary[TAILS]}*100/$numberIteration" | bc`
