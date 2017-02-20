
options(echo=T)
argo=commandArgs(trailingOnly=T)
argo=unlist(strsplit(argo,' '))
context=argo[1]
files=argo[2:length(argo)]
print(files)
print(context)
current=Sys.time()

install.packages('data.table')
library(data.table)

#functions
##############
merge_wigs <- function(filelist){
  all=read.delim(filelist[1],head=F,skip=1)
  all=all[,1:4]
  colnames(all)[4]=filelist[1]
  for(i in 2:length(filelist)){
    temp=read.delim(filelist[i],head=F,skip=1)
    temp=temp[,1:4]
    colnames(temp)[4]=filelist[i]
    all=merge(all,temp,by=c('V1','V2','V3'),all=T)
  }
  return(all)
}

calculate_dist <- function(data,column){
  meta=read.delim('../metadata.txt',head=F)
  current=names(data[,4:ncol(data)])
  c2=matrix(unlist(strsplit(current,'_')),ncol=7,byrow=T)
  c2=c2[,1]
  c2=gsub('^..','',c2)
  meta82=meta[meta$V1 %in% c2,]
  meta82=meta82[match(c2,meta82$V1),]
  colnames(data)[4:ncol(data)]=as.character(meta82[,column])
  hc=hclust(as.dist(1-cor(data[,4:ncol(data)],use='pairwise.complete.obs')))
  return(hc)
}

plot_dendro <- function(hc,title){
  pdf(paste(title,'methylation_dendrogram.',current,'.pdf',sep='_'),height=5,width=30)
  print(plot(hc,main=paste(title,sep=' ')))
  dev.off()
}
##############



all=merge_wigs(files)


write.table(all,paste(context,'_alltiles_merged.',current,'.txt',sep=''),sep='\t',row.names=F,quote=F)


tile.dist=calculate_dist(all,6)
plot_dendro(tile.dist,paste(argo[1],'_sample',sep=''))
tile.dist=calculate_dist(all,8)
plot_dendro(tile.dist,paste(argo[1],'_clonal',sep=''))


