make_heat = function(data, nama_data, UNIQ){
  fil1 = data
  # fil1 = cluster
  # nama_data = lsf
  if(class(fil1) != "RasterLayer" ){
    fhat = raster(fil1)
  }else{
    fhat = fil1
  }
  
  make_list_raster = function(x){
    mfh = as.matrix(x)
    mfh = t(apply(mfh, c(2), FUN = rev))
    lng = seq(extent(x)[1], extent(x)[2], length = x@ncols)
    lat = seq(extent(x)[3], extent(x)[4], length = x@nrows)
    res = list(lng = lng, lat = lat, fhat = mfh)
    return(res)
  }
  kde = make_list_raster(x = fhat)
  # rentang = c(180, 200,  210, 230)
  rentang = max(as.matrix(fhat))
  CL <- contourLines(kde$lng , kde$lat , kde$fhat,  levels = rentang)
  # ========================== BIKIN POLYGON ==========================
  pgons <- lapply(1:length(CL), function(i)
    Polygons(list(Polygon(cbind(CL[[i]]$x, CL[[i]]$y))), ID=i))
  # pgons[[1]]@
  spgons = SpatialPolygons(pgons)
  
  # class(pgons)
  # length(pgons)
  # class(pgons)
  
  
  
  crs(spgons) = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
    # ========================== URUTKAN POLIGON ==========================
  areaX  = c()
  for(i in 1:length(spgons)){
    areaX[i]= spgons@polygons[[i]]@area  
  }
  isort = order(areaX)
  spgons = spgons[rev(isort),]
  spgons = spgons[1,]
  spgons@polygons[[1]]@ID = as.character(UNIQ)
  # df = data.frame(namadata = rep(nama_data, length(spgons)), row.names = 1:length(spgons))
  # spgons = SpatialPolygonsDataFrame(spgons, df)
  
  # ================= EKSTRAK LEVEL KONTUR =======================
  # LEVS <- as.factor(sapply(CL, `[[`, "level"))
  # LEVS = LEVS[rev(isort)]
  # NLEV <- length(levels(LEVS))
  # ilevs = as.integer(as.matrix(LEVS))
  # for(i in 1:(length(rentang)-1)){
  #   ilevs[as.integer(as.matrix(LEVS)) == rentang[i+1]] = i
  # }
  
  # ================= BIKIN WARNA =======================
  # hh = colorRampPalette(c("red","yellow", "green"))
  # ================= HASIL =======================
  # hasil = list(warna = hh(NLEV)[ilevs], popup = as.character(LEVS), polygon = spgons, bobot_area = areaX)
  hasil = spgons
  return(hasil)
}

