#!/bin/bash
if [[ "$1" = "-h" || "$1" = "--help" ]]; then # описание help
	echo $0 Использование
	echo Аргументы: 
	echo 	         -s, --source: путь до директории, которую нужно копировать
	echo 		 -e, --extention: задать расширение
	echo		 -d, --destination: путь до директории, куда нужно копировать
	echo 		 -n, --number: максимальное число резервных копий в директории
	echo		 -p, --period: периодичность копирования в секундах
	echo		 -h, --help: помощь
	echo Порядок аргументов: -s [значение] -e [значение] -d [значение] -n [значение] -p [значение]
fi

I=`dpkg -s "zip" | grep "Status" ` # проверяем состояние пакета (dpkg) и ищем в выводе его статус (grep)

if [[ -n "$I" ]]; then #проверяем что нашли строку со статусом (что строка не пуста)
   if [[ "$1" = "-s" || "$1" = "--source" ]]; then
	path=$2 # задаём начальный путь
	cd $path #  переходим в него
	if [[ "$3" = "-e" || "$3" = "--extention" ]]; then
		ext=$4 # задаем расширение
		if [[ "$5" = "-d" || "$5" = "--destination" ]]; then
			dest=$6 # задаём конечный путь
			if [[ "$9" == "" ]]; then #идём сюда, если не указан период
				zip backup.zip $(find $path -maxdepth 1 -name "*$ext") > log.txt #создаем архив
				mv backup.zip $dest # перемещаем его в dest
				cd $dest
				mv backup.zip backup-$(date +%Y-%m-%d:%H:%M:%S).zip # переименовываем в вид "backup-текущая дата"
				md5sum backup-$(date +%Y-%m-%d:%H:%M:%S).zip >> checksum.txt
				if [[ "$7" = "-n" || "$7" = "--number" ]]; then
					number=$8 # максимальное число копий в одной директории
					current=$(find . -type f | wc -l) #текущее число файлов в директории
						if (( ($current - 1) > $number )); then
							while(( ($current - 1) > $number )) # - 1, т.к в current считается файл checksum
								do
								rm "$(ls -t | tail -1)"
								sed -i '1d' checksum.txt
								current=$(find . -type f | wc -l)
							done;
						fi
				fi
			fi
			if [[ "$9" = "-p" || "$9" = "--period" ]]; then ## идём сюда, если указан период
					period=${10}
					number=$8
					while(true)
					do
						zip backup.zip $(find $path -maxdepth 1 -name "*$ext") > log.txt
						mv backup.zip $dest
						cd $dest
						mv backup.zip backup-$(date +%Y-%m-%d:%H:%M:%S)
						md5sum backup-$(date +%Y-%m-%d:%H:%M:%S) >> checksum.txt
						current=$(find . -type f | wc -l) #текущее число файлов в директории
						if (( ($current - 1) > $number )); then
							while(( ($current - 1) > $number )) # - 3, т.к в current считается файл checksum
								do
								rm "$(ls -t | tail -1)"
								current=$(find . -type f | wc -l)
							done;
						fi
						cd $HOME
						cd $path
						sleep $period
					done;
			fi	
		fi
	fi
   fi
else
   exit # выход, если нет zip
fi

