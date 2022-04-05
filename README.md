# cupsserver

## quick start

```
docker build . -t cupsserver
mv data/printers.ini.example data/printers.ini
docker-compose up
```

## tips

+ place your custom install-script to data/whateveryouwant.install.sh and it will run once, only you have to do is docker-compose restart
