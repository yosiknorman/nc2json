#!/usr/bin/Rscript
rm(list = ls())


# library("data.table")
library("raster") #v
library("sp")
library("geojsonio")
library("ncdf4")
# library("rgdal")
# library("maptools")
# library("KernSmooth")


lon = c(90, 150)
lat = c(-15, 15)
prf_FA = "../FirstAttemps_nc/"
lsf  = list.files(prf_FA, pattern = ".nc")

source("make_heat.R")
joz =function(file, UNIQ){
  cluster = raster( paste0(prf_FA, file))
  extent(cluster) = c(xmn = lon[1], xmx =lon[2], ymn = lat[1], ymx = lat[2])
  backup = cluster
  cluster[backup != 0] = 1
  g = make_heat(data = cluster, nama_data  = file, UNIQ = UNIQ)
  result = g@polygons[[1]]
  return(result)
}

cat("===========================>>>>>>>>> read MCSPostProcessing  .....!!!")
csv = read.csv("../FirstAttemps_txt/MCSPostPrecessing.txt", sep = "[", header = F)
csv = gsub(x = as.matrix(csv), pattern = "]", replacement = "")
csv =csv[,2]
csv = gsub(x = as.matrix(csv), pattern = "\\'", replacement = "")
csvlist = list()
for(i in 1:length(csv)){
  csvlist[[i]] = strsplit(csv[i], split = "\\, ")[[1]]
}

loop = function(index){
  mana = c()
  for(i in 1:length(csvlist[[index]])){
    mana[i] = grep(lsf ,  pattern = csvlist[[index]][i])
  }
  res = list()
  for(i in 1:length(mana)){
    res[[i]] =joz(file = lsf[mana[i]], UNIQ = i)
  }
  res = SpatialPolygons(res)
  df = data.frame(Date = substr(lsf[mana], 14, 32), Namefile = csvlist[[index]], joz = "joz")
  spgons = SpatialPolygonsDataFrame(res, df)
  crs(spgons) = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  geojson_write(spgons, file = paste0("../json_FA/event_", index), overwrite = T)
}

for(i in 1:length(csvlist)){
  loop(i )
}

# mana = c()
# for(i in 1:length(csvlist[[1]])){
#   mana[i] = grep(lsf ,  pattern = csvlist[[1]][i])
# }



# res = list()
# for(i in 1:length(mana)){
#   res[[i]] =joz(file = lsf[mana[i]], UNIQ = i)
# }
# res = SpatialPolygons(res)
# df = data.frame(Date = substr(lsf[mana], 14, 32), Namefile = csvlist[[1]], joz = "joz")
# spgons = SpatialPolygonsDataFrame(res, df)
# crs(spgons) = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

# source("make_heat.R")


# pgons = list(g1@polygons[[1]], g2@polygons[[1]])
# spgons = SpatialPolygons(pgons)
# 
# df = data.frame(namadata = lsf[1:2], joz = "joz")
# spgons = SpatialPolygonsDataFrame(spgons, df)





