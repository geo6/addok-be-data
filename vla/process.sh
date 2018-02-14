#!/bin/sh
# Source : https://download.agiv.be/Producten/Detail?id=447&title=CRAB_Adressenlijst
# Source: https://download.agiv.be/Producten/Detail?id=72&title=CRAB_stratenlijst

mkdir -p ./$(date +%Y%m%d)
cd ./$(date +%Y%m%d)

[ ! -f "CRAB_Adressenlijst.zip" ] && \
    wget "https://downloadagiv.blob.core.windows.net/crab-adressenlijst/Shapefile/CRAB_Adressenlijst.zip" && \
    unzip -d "CRAB_Adressenlijst" "CRAB_Adressenlijst.zip"

[ ! -f "CRAB_stratenlijst.zip" ] && \
    wget "https://downloadagiv.blob.core.windows.net/crab-stratenlijst/dBASE/CRAB_stratenlijst.zip" && \
    unzip -d "CRAB_stratenlijst" "CRAB_stratenlijst.zip"

[ ! -f "Wegenregister_SHAPE_20171221.zip" ] && \
    wget "https://downloadagiv.blob.core.windows.net/wegenregister/Wegenregister_SHAPE_20171221.zip" && \
    unzip "Wegenregister_SHAPE_20171221.zip"

sudo -u postgres dropdb --if-exists "crab" && \
sudo -u postgres createdb "crab" && \
sudo -u postgres psql -d "crab" -c "CREATE EXTENSION postgis;"

sudo -u postgres ogr2ogr --config SHAPE_ENCODING "ISO-8859-1" -f "PostgreSQL" \
    -s_srs "EPSG:31370" -t_srs "EPSG:4326" \
    -lco "GEOM_TYPE=geography" \
    -nln "crabadr" -progress \
    "PG:dbname=crab" "./CRAB_Adressenlijst/Shapefile/CrabAdr.shp"
sudo -u postgres ogr2ogr -f "PostgreSQL" \
    -nln "straatnm" -progress \
    "PG:dbname=crab" "./CRAB_stratenlijst/dBASE/straatnm.dbf"
sudo -u postgres ogr2ogr --config SHAPE_ENCODING "ISO-8859-1" -f "PostgreSQL" \
    -s_srs "EPSG:31370" -t_srs "EPSG:4326" \
    -lco "GEOM_TYPE=geography" \
    -nln "wegsegment" -progress \
    "PG:dbname=crab" "./Wegenregister_SHAPE_20171221/Shapefile/Wegsegment.shp"

sudo -u postgres psql --set ON_ERROR_STOP=on -d "crab" -f "../process.sql" && \
sudo -u postgres psql --no-align --tuples-only -d "crab" -f "../export.sql" > "crab.sjson" && \
gzip crab.sjson
