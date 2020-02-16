#!/bin/bash -x

#CONSTANTS
IS_HEAD=0
SINGLET=1
DOUBLET=2
TRIPLET=3

#DECLARE DICTIONARY
declare -A singletDictionary
declare -A doubletDictionary
declare -A tripletDictionary

#READING VALUE FOR NO OF ITERATIONS
read -p "Enter No of Iterations : " numberIteration

#FUNCTION TO SIMULATE SINGLET, DOUBLET AND TRIPLET COMBINATION
function flipCoin(){
	local NO_OF_COINS=$2
	for (( index=1; index<=$1; index++ ))
	do
		for (( coins=1; coins<=$NO_OF_COINS; coins++ ))
		do
			randomFlip=$((RANDOM%2))
			if [ $randomFlip -eq $IS_HEAD ]
			then
				flipCombination=$flipCombination"H"
			else
				flipCombination=$flipCombination"T"
			fi
		done

		#STORING HEAD AND TAIL COMBINATION COUNT IN CORRESPONDING DICTIONARY
		if [ $NO_OF_COINS -eq $SINGLET ]
		then
			((singletDictionary[$flipCombination]++))
		elif [ $NO_OF_COINS -eq $DOUBLET ]
		then
			((doubletDictionary[$flipCombination]++))
		else
			((tripletDictionary[$flipCombination]++))
		fi
		flipCombination=""
	done
}

#CONVERTING COUNT TO PERCENTAGE IN ALL COMBINATION DICTIONARIES
function calculatePercentage(){
	local NO_OF_COINS=$1
	if [ $NO_OF_COINS -eq $SINGLET ]
	then
		for i in ${!singletDictionary[@]}
		do
			singletDictionary[$i]=`echo "scale=2; ${singletDictionary[$i]}*100/$numberIteration" | bc`
		done
	elif [ $NO_OF_COINS -eq $DOUBLET ]
	then
		for i in ${!doubletDictionary[@]}
		do
			doubletDictionary[$i]=`echo "scale=2; ${doubletDictionary[$i]}*100/$numberIteration" | bc`
		done
	else
		for i in ${!tripletDictionary[@]}
		do
			tripletDictionary[$i]=`echo "scale=2; ${tripletDictionary[$i]}*100/$numberIteration" | bc`
		done
	fi
}

#FUNCTION TO SORT COMBINATIONS PERCENTAGE WISE IN DESCENDING ORDER
function sort(){
	keysAndValuesArray=("$@")
	local count=1
	local NO_OF_RECORDS=$((${#keysAndValuesArray[@]}/2))
	#USING BUBBLESORT TO SORT KEYS AND VALUES IN keysAndValuesArray ARRAY
	for (( i=0; i<$NO_OF_RECORDS; i++ ))
	do
		for (( j=0; j<$(($NO_OF_RECORDS-1)); j++ ))
		do
			if (( $(echo "${keysAndValuesArray[j+$NO_OF_RECORDS]} < ${keysAndValuesArray[j+$NO_OF_RECORDS+1]}" |bc -l) ))
			then
				temp=${keysAndValuesArray[j]}
				keysAndValuesArray[j]=${keysAndValuesArray[j+1]}
				keysAndValuesArray[j+1]=$temp
				temp=${keysAndValuesArray[j+$NO_OF_RECORDS]}
				keysAndValuesArray[j+$NO_OF_RECORDS]=${keysAndValuesArray[j+1+$NO_OF_RECORDS]}
				keysAndValuesArray[j+1+$NO_OF_RECORDS]=$temp
			fi
		done
	done
}

flipCoin $numberIteration $SINGLET
flipCoin $numberIteration $DOUBLET
flipCoin $numberIteration $TRIPLET

calculatePercentage $SINGLET
calculatePercentage $DOUBLET
calculatePercentage $TRIPLET

sort ${!singletDictionary[@]} ${singletDictionary[@]}
singletWinningCombination=${keysAndValuesArray[0]}

sort ${!doubletDictionary[@]} ${doubletDictionary[@]}
doubletWinningCombination=${keysAndValuesArray[0]}

sort ${!tripletDictionary[@]} ${tripletDictionary[@]}
tripletWinningCombination=${keysAndValuesArray[0]}
