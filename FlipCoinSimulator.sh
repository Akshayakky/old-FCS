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

#FUNCTION TO SORT COMBINATION ARRAYS PERCENTAGE WISE IN DESCENDING ORDER
function sortArray(){
	keysAndValuesArray=("$@")
	local NO_OF_RECORDS=${#keysAndValuesArray[@]}
	for (( i=0; i<$NO_OF_RECORDS; i++ ))
	do
		for (( j=0; j<$(($NO_OF_RECORDS-1)); j++ ))
		do
			firstElement=$(echo ${keysAndValuesArray[j]} | awk -F: '{print $2}')
			secondElement=$(echo ${keysAndValuesArray[j+1]} | cut -f 2 -d ":")
			if (( $(echo "$firstElement < $secondElement" |bc -l) ))
			then
				temp=${keysAndValuesArray[j]}
				keysAndValuesArray[j]=${keysAndValuesArray[j+1]}
				keysAndValuesArray[j+1]=$temp
			fi
		done
	done
	echo ${keysAndValuesArray[@]}
}

#FUNCTION TO CONVERT DICTIONARY TO ARRAY OF KEYS AND VALUES
function dictionaryToArray(){
	keysAndValuesArray=("$@")
	local NO_OF_RECORDS=$((${#keysAndValuesArray[@]}/2))
	for (( i=0; i<$NO_OF_RECORDS; i++ ))
	do
		returnArray[$i]=${keysAndValuesArray[$i]}:${keysAndValuesArray[$NO_OF_RECORDS + $i]}
	done
	echo ${returnArray[@]}
}

flipCoin $numberIteration $SINGLET
flipCoin $numberIteration $DOUBLET
flipCoin $numberIteration $TRIPLET

calculatePercentage $SINGLET
calculatePercentage $DOUBLET
calculatePercentage $TRIPLET

singletArray="$(dictionaryToArray ${!singletDictionary[@]} ${singletDictionary[@]})"
singletArray=($(sortArray $singletArray))
singletWinningCombination=${singletArray[0]}%

doubletArray="$(dictionaryToArray ${!doubletDictionary[@]} ${doubletDictionary[@]})"
doubletArray=($(sortArray $doubletArray))
doubletWinningCombination=${doubletArray[0]}%

tripletArray="$(dictionaryToArray ${!tripletDictionary[@]} ${tripletDictionary[@]})"
tripletArray=($(sortArray $tripletArray))
tripletWinningCombination=${tripletArray[0]}%
