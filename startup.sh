#!/bin/bash

if [[ ! -f /first_run_ok ]] ; then
	echo "Install"

	echo "Set TZ=$TZ"
	DEBIAN_FRONTEND=noninteractive
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
	apt-get update
	apt-get dist-upgrade
	apt-get install -y sudo cups cups-client cups-bsd cups-filters foomatic-db-compressed-ppds printer-driver-all openprinting-ppds hpijs-ppds hp-ppd hplip printer-driver-cups-pdf
	apt-get clean
	#rm -rf /var/lib/apt/lists/*

	useradd -m -s /bin/bash cupsadmin
	if [[ ! -z "$CUPS_ADMIN_PASSWD" ]] ; then
		echo cupsadmin:$CUPS_ADMIN_PASSWD | chpasswd
		usermod -U cupsadmin
	else
		usermod -L cupsadmin
	fi 

	touch /first_run_ok
fi

cp -v /data/cupsd.conf /etc/cups/
cp -v /data/cups-files.conf /etc/cups/

for i in $(ls /data/*.install.sh) ; do
	name=$(basename ${i})
	test -f "/installed_${name}" && break
	test -x "${i}" || chmod +x ${i}
	${i} && touch "/installed_${name}"
done

# CUPS init
/usr/sbin/cupsd
sleep 1
CUPS_PID="$(pidof cupsd)"

# Populate printers
test -x /rebuild.sh || chmod +x /rebuild.sh
/rebuild.sh /data/printers.ini /var/www/html/index.html

# CUPS reload
kill -1 $CUPS_PID
sleep 5
kill -9 $CUPS_PID

# CUPS run
echo "Staring CUPS"
/usr/sbin/cupsd -f