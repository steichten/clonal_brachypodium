options(echo=T)
argo=commandArgs(trailingOnly=T)
argo=unlist(strsplit(argo,' '))
context=argo[1]
positions=argo[2]
files=argo[3:length(argo)]
print(context)
current=format(Sys.time(), "%H-%M_%d-%m-%y")


library(rhdf5)
h5filename=paste(context,'_cov.h5',sep='')

#initialize the hdf5 file
h5createFile(h5filename)
h5createGroup(h5filename,'positions')
h5createGroup(h5filename,'met')
h5createGroup(h5filename,'unmet')

pos=read.delim(positions,head=F,stringsAsFactors = F,col.names=c('chrom','position'))
h5write(pos,file=h5filename,name='/positions/positions')

files=sort(substring(files,3))
print(files)

#sid=matrix(unlist(strsplit(files,'\\.')),ncol=8,byrow=T)[,1]

h5createDataset(h5filename,'met/met',c(nrow(pos),604),storage.mode='integer',chunk=c(5,1),level=7)
h5createDataset(h5filename,'unmet/unmet',c(nrow(pos),604),storage.mode='integer',chunk=c(5,1),level=7)

for(i in 1:length(files)){
  d1=read.delim(files[i],head=F)

  #5 is met read count
  #6 is unmet read count
  merged=merge(pos,d1[,c(1,2,5,6)],by.x=c('chrom','position'),by.y=c('V1','V2'),all.x=T)
  h5write(matrix(merged[,3],nc=1),file=h5filename,name='met/met', start=c(1,i))
  h5write(matrix(merged[,4],nc=1),file=h5filename,name='unmet/unmet',start=c(1,i))
  }

H5close()
#
