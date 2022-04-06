# cupsserver

## quick start

```
docker build . -t dmittr/cupsserver
mv data/printers.ini.example data/printers.ini
docker-compose up
```

## much quicker start

```
git clone https://github.com/dmittr/cupsserver.git && cd cupsserver
mv data/printers.ini.example data/printers.ini
docker-compose up
```


## tips

+ place your custom install-script to data/whateveryouwant.install.sh and it will run once, only you have to do is 'docker-compose restart'
+ edit data/printers.ini as you need, then 'docker-compose restart' 
