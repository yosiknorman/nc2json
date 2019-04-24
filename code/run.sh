#!/bin/bash

./nc2json.R
for i in `ls ../json_FA | grep ".geojson"`; do
	baru=`echo $i | sed s/".geojson"//g`
	ogr2ogr -f kml "../json_FA/$baru.kml" "../json_FA/$i"
	rm ../json_FA/$i
done

