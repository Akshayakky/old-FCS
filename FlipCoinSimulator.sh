#!/bin/bash -x

#CONSTANTS
IS_HEAD=0
DOUBLET=2

#DECLARE DICTIONARY
declare -A doubletDictionary

#READING VALUE FOR NO OF ITERATIONS
read -p "Enter No of Iterations : " numberIteration

#FUNCTION TO SIMULATE DOUBLET COMBINATION
function flipCoin(){
	for (( index=1; index<=$1; index++ ))
	do
		for (( coins=1; coins<=$2; coins++ ))
		do
			randomFlip=$((RANDOM%2))
			if [ $randomFlip -eq $IS_HEAD ]
			then
				flipCombination=$flipCombination"H"
			else
				flipCombination=$flipCombination"T"
			fi
		done
		#STORING HEAD AND TAIL COMBINATION COUNT IN DICTIONARY
		((doubletDictionary[$flipCombination]++))
		flipCombination=""
	done
}

#FUNCTION TO STORE COIN FLIP COMBINATION AND CORRESPONDING PERCENTAGE
function calculatePercentage(){
	for i in ${!doubletDictionary[@]}
	do
#		doubletDictionary[$i]=`echo "scale=2; ${doubletDictionary[$i]}*100/$numberIteration" | bc`
		doubletDictionary[$i]=`echo "scale=2; ${doubletDictionary[$i]}*100/$numberIteration" | bc | awk '{printf "%.3f",$0}'`
	done
}

flipCoin $numberIteration $DOUBLET
calculatePercentage
