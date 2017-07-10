
options(echo=T)
argo=commandArgs(trailingOnly=T)
argo=unlist(strsplit(argo,' '))
context=argo[1]
metapath=argo[2]
files=argo[3:length(argo)]
print(files)
print(metapath)
print(context)
current=format(Sys.time(), "%H-%M_%d-%m-%y")


#install.packages('dendextend',dependencies=T)
library(dplyr)
library(dendextend)

##############
#functions
##############
merge_cov <- function(filelist,col){
  all=list()
  for (i in 1:length(filelist)){
    tmp = read.delim(filelist[i],head=F,skip=1)
    tmp=tmp[,c(1:3,col)]
    tmp = tmp %>% filter(V1=='Bd1')
    namechomp=gsub('.fastq.gz.*','',filelist[i]) #getting down to just the S60XXX sampleID
    namechomp=gsub('\\./','',namechomp) #get rid of leading './'
    colnames(tmp)[4]=namechomp
    #filename=files[i]
    all[[namechomp]]=tmp
  }
  goob = all %>% Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by=c('V1','V2','V3')), .)
  return(goob)
}
#############
calculate_dist <- function(data,column){
  colnames(data)[4:ncol(data)]=as.character(meta_used[,column])
  hc=hclust(as.dist(1-cor(as.matrix(data[,4:ncol(data)]),use='pairwise.complete.obs')))
  return(hc)
}
############
plot_dendro <- function(hc,column,title){
  pdf(paste(title,'methylation_dendrogram.',current,'.pdf',sep=''),height=9,width=70)
  dendro_labels=gsub('_.*','',gsub('\\.[0-9]*','',as.character(meta_used[,column])))
  dendro_colors=as.numeric(as.factor(gsub('_.*','',gsub('\\.[0-9]*','',as.character(meta_used[,8])))))
  hc=as.dendrogram(hc)
  #labels(hc)=dendro_labels[order.dendrogram(hc)]
  labels_colors(hc) = dendro_colors[order.dendrogram(hc)]
  print(plot(hc,main=paste(title,sep=' ')))
  dev.off()
}
###########
calculate_cor <- function(data,column){
  colnames(data)[4:ncol(data)]=as.character(meta_used[,column])
  cor_matrix=as.matrix(cor(data[,4:ncol(data)],use='pairwise.complete.obs'))
  return(cor_matrix)
}
###########
plot_heatmap <- function(cor_matrix,title){
  pdf(paste(title,'methylation_heatmap.',current,'.pdf',sep=''),height=30,width=30)
  print(heatmap(cor_matrix,main=paste(title,sep=' ')))
  dev.off()
  return(NULL)
}
##############


type=data.frame(class=c('prop','met','unmet'),column=c(4,5,6))

for(i in 1:nrow(type)){
  all=merge_cov(files,type[i,'column'])
  write.table(all,paste(context,'_allsites_',type[i,'class'],'.',current,'.txt',sep=''),sep='\t',row.names=F,quote=F)

  #gather metadata info for samples used for all sample comparisons
  meta=read.delim(metapath,head=T)
  currentnames=names(all[,4:ncol(all)])
  meta_used=meta[meta[,1] %in% currentnames,]
  meta_used=meta_used[match(currentnames,meta_used[,1]),]

  tile.dist=calculate_dist(all,6)
  saveRDS(tile.dist,paste(context,'.',type[i,'class'],'_tile.dist.',current,'.rds',sep=''))
  plot_dendro(tile.dist,6,paste(context,'.',type[i,'class'],'_sample.',current,'.',sep=''))
  tile.cor=calculate_cor(all,6)
  saveRDS(tile.cor,paste(context,'.',type[i,'class'],'_tile.cor.',current,'.rds',sep=''))
  plot_heatmap(tile.cor,paste(context,'.',type[i,'class'],'_sample.',current,'.',sep=''))

  tile.dist=calculate_dist(all,8)
  saveRDS(tile.dist,paste(context,'.',type[i,'class'],'_tile.dist.sample.',current,'.rds',sep=''))
  plot_dendro(tile.dist,6,paste(context,'.',type[i,'class'],'_clonal.',current,'.',sep=''))
  tile.cor=calculate_cor(all,8)
  saveRDS(tile.cor,paste(context,'.',type[i,'class'],'_tile.cor.sample.',current,'.rds',sep=''))
  plot_heatmap(tile.cor,paste(context,'.',type[i,'class'],'_clonal.',current,'.',sep=''))
}
#done
