
options(echo=T)
current=Sys.time()
#functions
##############

calculate_dist <- function(data,column){
  meta=read.delim('./metadata.txt',head=F)
  current=names(data[,4:ncol(data)])
  c2=matrix(unlist(strsplit(current,'_')),ncol=3,byrow=T)
  c2=c2[,1]
  meta82=meta[meta$V1 %in% c2,]
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



all=read.delim('CG_alltiles_merged.2017-02-02 14:26:17.txt',head=F)
tile.dist=calculate_dist(all,6)
plot_dendro(tile.dist,paste('CG','_sample',sep=''))
tile.dist=calculate_dist(all,8)
plot_dendro(tile.dist,paste('CG','_clonal',sep=''))



all=read.delim('CHG_alltiles_merged.2017-02-02 14:57:39.txt',head=F)
tile.dist=calculate_dist(all,6)
plot_dendro(tile.dist,paste('CHG','_sample',sep=''))
tile.dist=calculate_dist(all,8)
plot_dendro(tile.dist,paste('CHG','_clonal',sep=''))


all=read.delim('CHH_alltiles_merged.2017-02-02 15:31:41.txt',head=F)
tile.dist=calculate_dist(all,6)
plot_dendro(tile.dist,paste('CHH','_sample',sep=''))
tile.dist=calculate_dist(all,8)
plot_dendro(tile.dist,paste('CHH','_clonal',sep=''))

