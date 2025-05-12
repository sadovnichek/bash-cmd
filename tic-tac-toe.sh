#!usr/bin/bash

help=" Tic-tac-toe game\n Usage: bash tic-tac-toe.sh -[symbol]\n symbol is 'x' or 'o' which one you want to play by\n Make sure that you have file finals.txt in the same directory with this script"

model="000000000"

get_char(){
	if [ "$1" -eq 0 ]; then
		echo " ";
	fi
	if [ "$1" -eq 1 ]; then
		echo "x";
	fi
	if [ "$1" -eq 2 ]; then
		echo "o";
	fi
}

print_model(){
	for (( i=0; i<9; i=i+3 )); 
	do
		if (( i == 3 || i == 6 )); then
			echo "—   —   —"
		fi
		first=$(get_char ${model:$i:1})
		second=$(get_char ${model:$((i+1)):1})
		third=$(get_char ${model:$((i+2)):1})
		echo "${first} | ${second} | ${third}"
	done
}

check_final(){
	while IFS= read -r regex; do
		if [[ $model =~ $regex ]]; then
			if [[ "$1" == 1 ]]; then 
				echo Final! x has win! 
			else 
				echo Final! o has win! 
			fi
			exit 0
		fi
	done < "finals.txt"
	
	all_cells_filled=$"[1-2][1-2][1-2][1-2][1-2][1-2][1-2][1-2][1-2]"
	if [[ $model =~ $all_cells_filled ]]; then
		echo Draw
		exit 0
	fi
}

get_ai_step(){
	ai_symbol=$1
	player_symbol=$([ "$ai_symbol" == 1 ] && echo 2 || echo 1)
	stop=0
	stupid_ai_probability=$(( RANDOM % 101 ))
	if (( $stupid_ai_probability < 95 )); then
		for (( i=0; i<9; i++ )); do
			if [[ ${model:$i:1} == "0" ]]; then
				next_model=${model:0:$i}${ai_symbol}${model:$((i+1))}
				while IFS= read -r regex; do
					if [[ $next_model =~ $regex ]]; then
						echo $i
						stop=1
						break
					fi
				done < "finals.txt"
			fi
			if (( $stop == 1 )); then
				break
			fi
		done
		for (( i=0; i<9; i++ )); do
			if [[ ${model:$i:1} == "0" ]]; then
				next_model_opposite=${model:0:$i}${player_symbol}${model:$((i+1))}
				while IFS= read -r regex; do
					if [[ $next_model_opposite =~ $regex ]]; then
						echo $i
						stop=1
						break
					fi
				done < "finals.txt"
			fi
			if (( $stop == 1 )); then
				break
			fi
		done
	fi
	if (( $stop != 1 )); then
		while true; do
			position=$((RANDOM % 9))
			if [[ ${model:$position:1} == "0" ]]; then
				echo $position
				break
			fi
		done
	fi
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -x) player_symbol="1";;
        -o) player_symbol="2";;
        -h|--help) echo -e $help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

symbol=1
echo Tic-tac-toe game
while true;
do
	print_model
	check_final $((symbol-1))
	if (( player_symbol == symbol )); then
		read -p "Next move: " input
		two_digits=($input)
		i=${two_digits[0]}
		j=${two_digits[1]}
		if (( i < 1 || i > 3 || j < 1 || j > 3)); then
			echo "Invalid input. Enter two digits from 1 to 3"
			continue
		fi
		position=$((3 * ($i - 1) + $j - 1))
		if [[ ${model:$position:1} != "0" ]]; then
			echo "Cell is not empty!"
			continue
		fi
	else
		echo AI move...
		sleep 1
		position=$(get_ai_step $symbol)
	fi
	model=${model:0:$position}${symbol}${model:$((position+1))}
	symbol=$([ "$symbol" == 1 ] && echo 2 || echo 1)
done
