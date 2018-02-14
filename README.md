# Import Belgian addresses into [Addok](https://github.com/addok/addok)

Addok documentation : <http://addok.readthedocs.io/>

## Install

### PostgreSQL

<https://www.postgresql.org/download/>

### Tools

    sudo apt-get install unzip mdbtools

### GDAL library

<https://trac.osgeo.org/gdal/wiki/BuildingOnUnix>

#### Install required librairies

    sudo apt-get install build-essential libpq-dev libproj-dev pkg-config bash-completion

#### Download GDAL

Run the following commands in a non-root directory !

    wget http://download.osgeo.org/gdal/CURRENT/gdal-2.2.3.tar.gz
    tar -zxvf gdal-2.2.3.tar.gz
    cd gdal-2.2.3

#### Build GDAL

    ./configure --with-pg
    make

#### Install GDAL

    sudo make install

    export export PATH=/usr/local/bin:$PATH
    export export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
    export export GDAL_DATA=/usr/local/share/gdal

    sudo ldconfig

## Data

All the following data are open-data !

- **Brussels :** CIRB UrbIS ([Licence](http://bric.brussels/en/our-solutions/urbis-solutions/Licence_Open_data_Fr_v4.pdf)) : <http://urbisdownload.gis.irisnet.be/>

## Import

First, let's generate the data with the format Addok needs :

Brussels data (`urbis-fr.sjson` + `urbis-nl.sjson`) :

    cd bru/
    sh process.sh

Now, let's import the data into Addok :

    sudo -u addok -i
    source venv/bin/activate
    addok batch path/to/file.sjson
    addok ngrams

If you need to delete every data already imported into Addok use :

    addok reset
