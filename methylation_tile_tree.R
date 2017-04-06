
options(echo=T)
argo=commandArgs(trailingOnly=T)
argo=unlist(strsplit(argo,' '))
context=argo[1]
metapath=argo[2]
files=argo[3:length(argo)]
print(files)
print(metapath)
print(context)
current=Sys.time()

#install.packages('data.table')
#library(data.table)
#install.packages('dendextend')
library(dendextend)
#functions
##############
merge_wigs <- function(filelist){
  all=list()
  for (i in 1:length(filelist)){
    tmp = read.delim(filelist[i],head=F,skip=1)
    tmp=tmp[,1:4]
    colnames(tmp)[4]=filelist[i]
    filename=files[i]
    all[[filename]]=tmp
  }
  goob = all %>% Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by=c('V1','V2','V3')), .)
  return(goob)
}

calculate_dist <- function(data,column){
  meta=read.delim(metapath,head=F)
  current=names(data[,4:ncol(data)])
  c2=matrix(unlist(strsplit(current,'_')),ncol=3,byrow=T)
  c2=c2[,1]
  #split by period for the SRA downloaded files
  c2=matrix(unlist(strsplit(c2,'\\.')),ncol=3,byrow=T)
  c2=c2[,1]
  meta82=meta[meta$V1 %in% c2,]
  meta82=meta82[match(c2,meta82$V1),]
  colnames(data)[4:ncol(data)]=as.character(meta82[,column])
  hc=hclust(as.dist(1-cor(as.matrix(data[,4:ncol(data)]),use='pairwise.complete.obs')))
  return(hc)
}

plot_dendro <- function(hc,column,title){
  pdf(paste(title,'methylation_dendrogram.',current,'.pdf',sep='_'),height=9,width=60)
  dendro_labels=gsub('_.*','',gsub('\\.[0-9]*','',as.character(meta82[,column])))
  dendro_colors=as.numeric(as.factor(gsub('_.*','',gsub('\\.[0-9]*','',as.character(meta82[,8])))))
  hc=as.dendrogram(hc)
  #labels(hc)=dendro_labels[order.dendrogram(hc)]
  labels_colors(hc) = dendro_colors[order.dendrogram(hc)]
  print(plot(hc,main=paste(title,sep=' ')))
  dev.off()
}

calculate_cor <- function(data,column){
  meta=read.delim(metapath,head=F)
  current=names(data[,4:ncol(data)])
  c2=matrix(unlist(strsplit(current,'_')),ncol=7,byrow=T)
  c2=c2[,1]
  c2=gsub('^..','',c2)
  meta82=meta[meta$V1 %in% c2,]
  meta82=meta82[match(c2,meta82$V1),]
  colnames(data)[4:ncol(data)]=as.character(meta82[,column])
  cor_matrix=as.matrix(cor(data[,4:ncol(data)],use='pairwise.complete.obs'))
  return(cor_matrix)
}

plot_heatmap <- function(cor_matrix,title){
  pdf(paste(title,'methylation_heatmap.',current,'.pdf',sep='_'),height=15,width=15)
  print(heatmap(cor_matrix,main=paste(title,sep=' ')))
  dev.off()
  return(NULL)
}
##############



all=merge_wigs(files)


write.table(all,paste(context,'_alltiles_merged.',current,'.txt',sep=''),sep='\t',row.names=F,quote=F)


tile.dist=calculate_dist(all,6)
saveRDS(tile.dist,paste(context,'_tile.dist.rds',sep=''))
plot_dendro(tile.dist,6,paste(context,'_sample',sep=''))
tile.cor=calculate_cor(all,6)
saveRDS(tile.cor,paste(context,'_tile.cor.rds',sep=''))
plot_heatmap(tile.cor,paste(context,'_sample',sep=''))

tile.dist=calculate_dist(all,8)
saveRDS(tile.dist,paste(context,'_tile.dist.sample.rds',sep=''))
plot_dendro(tile.dist,6,paste(context,'_clonal',sep=''))
tile.cor=calculate_cor(all,8)
saveRDS(tile.cor,paste(context,'_tile.cor.sample.rds',sep=''))
plot_heatmap(tile.cor,paste(context,'_sample',sep=''))
