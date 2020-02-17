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

#FUNCTION TO CONVERT DICTIONARY TO ARRAY OF COMBINATIONS AND COUNTS
function dictionaryToArray(){
	local combinationAndCountArray=("$@")
	local NO_OF_RECORDS=$((${#combinationAndCountArray[@]}/2))
	for (( i=0; i<$NO_OF_RECORDS; i++ ))
	do
		newCombinationAndCountArray[$i]=${combinationAndCountArray[$i]}:${combinationAndCountArray[$NO_OF_RECORDS + $i]}
	done
	echo ${newCombinationAndCountArray[@]}
}

#CONVERTING COUNT TO PERCENTAGE IN ALL COMBINATION ARRAYS
function calculatePercentage(){
	local combinationAndCountArray=("$@")
	for i in ${!combinationAndCountArray[@]}
	do
		key=$(echo ${combinationAndCountArray[$i]} | cut -f 1 -d ":")
		count=$(echo ${combinationAndCountArray[$i]} | cut -f 2 -d ":")
		combinationAndPercentArray[$i]=$key:`echo "scale=2; $count*100/$numberIteration" | bc`
	done
	echo ${combinationAndPercentArray[@]}
}

#FUNCTION TO SORT COMBINATION ARRAYS PERCENTAGE WISE IN DESCENDING ORDER
function sortArray(){
	local combinationAndPercentArray=("$@")
	local NO_OF_RECORDS=${#combinationAndPercentArray[@]}
	for (( i=0; i<$NO_OF_RECORDS; i++ ))
	do
		for (( j=0; j<$(($NO_OF_RECORDS-1)); j++ ))
		do
			firstElement=$(echo ${combinationAndPercentArray[j]} | awk -F: '{print $2}')
			secondElement=$(echo ${combinationAndPercentArray[j+1]} | cut -f 2 -d ":")
			if (( $(echo "$firstElement < $secondElement" |bc -l) ))
			then
				temp=${combinationAndPercentArray[j]}
				combinationAndPercentArray[j]=${combinationAndPercentArray[j+1]}
				combinationAndPercentArray[j+1]=$temp
			fi
		done
	done
	echo ${combinationAndPercentArray[@]}
}

function winningCombination(){
array=("$@")
i=0
winningCombination=${array[0]}
while [ $i -lt $((${#array[@]}-1)) ]
do
	first=$(echo "${array[0]}" | cut -f 2 -d ":")
	second=$(echo "${array[i+1]}" | cut -f 2 -d ":")
	if (( $(echo "$first == $second" |bc -l) ))
	then
		winningCombination=$winningCombination" "${array[i+1]}
	else
		break
	fi
	((i++))
done
echo $winningCombination
}

flipCoin $numberIteration $SINGLET
flipCoin $numberIteration $DOUBLET
flipCoin $numberIteration $TRIPLET

singletArray=($(dictionaryToArray ${!singletDictionary[@]} ${singletDictionary[@]}))
doubletArray=($(dictionaryToArray ${!doubletDictionary[@]} ${doubletDictionary[@]}))
tripletArray=($(dictionaryToArray ${!tripletDictionary[@]} ${tripletDictionary[@]}))

singletArray=($(calculatePercentage ${singletArray[@]}))
doubletArray=($(calculatePercentage ${doubletArray[@]}))
tripletArray=($(calculatePercentage ${tripletArray[@]}))

singletArray=($(sortArray ${singletArray[@]}))
doubletArray=($(sortArray ${doubletArray[@]}))
tripletArray=($(sortArray ${tripletArray[@]}))

singletWinningCombination=($(winningCombination ${singletArray[@]}))
doubletWinningCombination=($(winningCombination ${doubletArray[@]}))
tripletWinningCombination=($(winningCombination ${tripletArray[@]}))
