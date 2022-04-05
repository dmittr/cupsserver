FROM ubuntu:20.04

ENV TZ=Asia/Vladivostok

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && apt-get update \
&& apt-get install -y \
  sudo \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  printer-driver-cups-pdf \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

COPY ./startup.sh /
COPY ./rebuild.sh /

CMD ["/startup.sh"]
