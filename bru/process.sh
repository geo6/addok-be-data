#!/bin/sh
# Source : http://urbisdownload.gis.irisnet.be/fr/download/
# Note : https://wiki.postgresql.org/wiki/Converting_from_other_Databases_to_PostgreSQL#Microsoft_Access
# Note : https://github.com/brianb/mdbtools/blob/master/doc/mdb-export.txt

mkdir -p ./$(date +%Y%m%d)
cd ./$(date +%Y%m%d)

[ ! -f "UrbAdm_SHP.zip" ] && \
    wget "https://s.irisnet.be/v1/AUTH_ce3f7c74-fbd7-4b46-8d85-53d10d86904f/UrbAdm/UrbAdm_SHP.zip" && \
    unzip "UrbAdm_SHP.zip"
[ ! -f "UrbAdm_MDB.zip" ] && \
    wget "https://s.irisnet.be/v1/AUTH_ce3f7c74-fbd7-4b46-8d85-53d10d86904f/UrbAdm/UrbAdm_MDB.zip" && \
    unzip "UrbAdm_MDB.zip"

[ ! -f "mdb/urb_a_adpt.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_ADPT > "mdb/urb_a_adpt.tsv"
[ ! -f "mdb/urb_a_pn.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_PN > "mdb/urb_a_pn.tsv"
[ ! -f "mdb/urb_a_pn_syn.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_PN_SYN > "mdb/urb_a_pn_syn.tsv"
[ ! -f "mdb/urb_a_mu.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_MU > "mdb/urb_a_mu.tsv"
[ ! -f "mdb/urb_a_mz.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_MZ > "mdb/urb_a_mz.tsv"
[ ! -f "mdb/urb_a_sa.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_SA > "mdb/urb_a_sa.tsv"
[ ! -f "mdb/urb_a_sa_ss.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_SA_SS > "mdb/urb_a_sa_ss.tsv"
[ ! -f "mdb/urb_a_ss.tsv" ] && mdb-export -Q -d "\t" -D "%Y-%m-%d %H:%M:%S" "mdb/UrbAdm.mdb" URB_A_SS > "mdb/urb_a_ss.tsv"

cp mdb/*.tsv /tmp/

sudo -u postgres dropdb --if-exists "urbis" && \
sudo -u postgres createdb "urbis" && \
sudo -u postgres psql -d "urbis" -c "CREATE EXTENSION postgis;"

sudo -u postgres ogr2ogr -f "PostgreSQL" -s_srs "EPSG:31370" -t_srs "EPSG:4326" -lco "GEOM_TYPE=geography" -nlt "PROMOTE_TO_MULTI" -nln "urbadm_street_axis" -progress "PG:dbname=urbis" "shp/UrbAdm_STREET_AXIS.shp"

sudo -u postgres psql -d "urbis" -f "../import.sql" && \
sudo -u postgres psql -d "urbis" -f "../process.sql" && \
sudo -u postgres psql --no-align --tuples-only -d "urbis" -f "../export-fr.sql" > "urbis-fr.sjson" && \
sudo -u postgres psql --no-align --tuples-only -d "urbis" -f "../export-nl.sql" > "urbis-nl.sjson"

rm /tmp/*.tsv
