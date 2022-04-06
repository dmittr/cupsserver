#!/bin/bash

inifile=$1
htmlfile=$2
printersconf="/etc/cups/printers.conf"

if [[ -f "${printersconf}" ]] ; then
    for i in $(grep "^<.*Printer .*>$" "${printersconf}" | cut -d ' ' -f 2 | tr -d '>') ; do
      echo "Removing printer: $i"
      lpadmin -x $i
    done
fi


echo "<html><head><meta http-equiv='content-type' content='text/html; charset=utf-8' /></head><body>Windows<br><ul><li>В windows заходим в \"Устройства и принтеры\" через панель управления</li>
<li>Установка принтера &gt; Добавить сетевой, беспроводной или Bluetooth принтер &gt; Остановить</li>
<li>Нужный принтер отсутствует в списке &gt; Выбрать общий принтер по имени:<ul>" > ${htmlfile}

for printer in $(cat ${inifile}|tr -d " "|tr -d "\t"|cut -f 1 -d "|") ; do 
	SOCKET="$(cat ${inifile}|tr -d " "|tr -d "\t"|grep "^${printer}|"|cut -d "|" -f 2)"
	DEVICE="$(cat ${inifile}|tr -d " "|tr -d "\t"|grep "^${printer}|"|cut -d "|" -f 3)"
	LOCATION="$(cat ${inifile}|tr -d " "|tr -d "\t"|grep "^${printer}|"|cut -d "|" -f 4)"
	DRIVER="$(cat ${inifile}|tr -d " "|tr -d "\t"|grep "^${printer}|"|cut -d "|" -f 5)"
	
	echo Adding ${printer}
	echo "lpadmin -p ${printer} -v "${SOCKET}"  -m \"${DRIVER}\" -L \"${LOCATION}\" -D \"${DEVICE}\" -o printer-is-shared=true -E"
	lpadmin -p ${printer} -v "${SOCKET}" -m "${DRIVER}" -L "${LOCATION}" -D "${DEVICE}" -o printer-is-shared=true -E
	lpadmin -p ${printer} -o Media=A4
	lpadmin -p ${printer} -o PageSize=A4 -E
	LINUX_CMD="$LINUX_CMD
lpadmin -p ${printer} -v ipp://$APP_DOMAIN:631/printers/${printer} -m raw -o printer-is-shared=false -L \"${LOCATION}\" -D \"${DEVICE}\" -E;lpadmin -p ${printer} -o printer-error-policy=retry-job;lpadmin -p ${printer} -o Media=A4;lpadmin -p ${printer} -o PageSize=A4 -E"
	echo "<li><b>http://$APP_DOMAIN:631/printers/$NAME</b> - $DEV $LOC</li>" >> ${htmlfile}
done

echo "</ul></li><li>Далее -&gt Изготовитель:Generic, Модель: MS Publisher Imagesetter -&gt OK, Далее, Готово</li></ul><br><br>Linux:<br><pre>$LINUX_CMD</pre>" >> ${htmlfile}