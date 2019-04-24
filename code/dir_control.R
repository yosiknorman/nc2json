csv = read.csv("../FirstAttemps_txt/MCSPostPrecessing.txt", sep = "[", header = F)
csv = gsub(x = as.matrix(csv), pattern = "]", replacement = "")
csv =csv[,2]
csv = gsub(x = as.matrix(csv), pattern = "\\'", replacement = "")
csvlist = list()
for(i in 1:length(csv)){
  csvlist[[i]] = strsplit(csv[i], split = "\\, ")[[1]]
}


# >>>>>>>>>>>>>>>>>>>>>>... MAKE DUMMY DATA ...<<<<<<<<<<<<<<<<<<<<<
# depan =strsplit(lsf, split = "F")[[1]][1]
# f_i =paste0(depan, csvlist[[7]], ".nc")
# for(i in 1:length(f_i)){
#   system(paste0("cp -rf ../FirstAttemps_nc/cloudElements2007-10-27_00_00_00F1CE1.nc ../FirstAttemps_nc/", f_i[i]))
# }