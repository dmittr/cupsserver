#!/bin/bash

if [ -n "$ULD_DOWNLOAD_URL" ] ;
then
  echo "Download ULD drivers...";
  echo "ULD install url: $ULD_DOWNLOAD_URL";
  wget -O /tmp/uld.tar.gz $ULD_DOWNLOAD_URL
  [ $? -eq 0 ] || exit 1
  tar xzvf /tmp/uld.tar.gz -C /tmp/
  [ $? -eq 0 ] || exit 1
else
  ULD_DOWNLOAD_URL="https://ftp.hp.com/pub/softlib/software13/printers/SS/SL-C4010ND/uld_V1.00.39_01.17.tar.gz";
  echo "Download ULD drivers...";
  echo "ULD url (default): $ULD_DOWNLOAD_URL";
  wget -O /tmp/uld.tar.gz $ULD_DOWNLOAD_URL
  [ $? -eq 0 ] || exit 1
  tar xzvf /tmp/uld.tar.gz -C /tmp/
  [ $? -eq 0 ] || exit 1
fi

if [ ! -f "/tmp/uld/x86_64/rastertospl" ];
then
  echo "Samsung cups filter not found!"
  exit 1;
else
  echo "Install ULD drivers...";
  cp -v /tmp/uld/x86_64/libscmssc.so /usr/lib
  cp -v /tmp/uld/x86_64/smfpnetdiscovery /usr/lib/cups/backend
  cp -v /tmp/uld/x86_64/pstosecps /usr/lib/cups/filter
  cp -v /tmp/uld/x86_64/rastertospl /usr/lib/cups/filter
  [ $? -eq 0 ] || exit 1
  ln -s rastertospl /usr/lib/cups/filter/rastertosplc
  mkdir -p /usr/share/cups/model/suld
  for ppd in /tmp/uld/noarch/share/ppd/*.ppd; do gzip < "$ppd" > /usr/share/cups/model/suld/"${ppd##*/}".gz; done
  mkdir -p /usr/share/cups/model/suld/cms
  for cts in /tmp/uld/noarch/share/ppd/cms/*.cts; do cp "$cts" /usr/share/cups/model/suld/cms; done
  echo "Clean up temp files..."
  rm -rfv /tmp/uld/
fi

