



for FILE in *.fastq.gz
do
ID=(${FILE//_/ })
DATE=$(date)
printf "#!/bin/bash\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -P xe2\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -q normal\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -l walltime=12:00:00\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -l mem=31GB\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -l jobfs=150GB\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -l ncpus=8\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -l software=bismark_aligner\n" >> ${ID[0]}_dss_clone1.script
printf "#PBS -l wd\n" >> ${ID[0]}_dss_clone1.script
printf "\n" >> ${ID[0]}_dss_clone1.script
printf "\n" >> ${ID[0]}_dss_clone1.script
printf "#This script was generated automatically on $DATE\n" >> ${ID[0]}_dss_clone1.script
printf "\n" >> ${ID[0]}_dss_clone1.script
printf "module load java\n" >> ${ID[0]}_dss_clone1.script
printf "module load samtools/1.3.1\n" >> ${ID[0]}_dss_clone1.script
printf "module load python/2.7.11\n" >> ${ID[0]}_dss_clone1.script
printf "module load perl/5.22.1\n" >> ${ID[0]}_dss_clone1.script
printf "\n" >> ${ID[0]}_dss_clone1.script
printf "export PATH=\$PATH:\$HOME/bin:\$HOME/.local/bin/\n" >> ${ID[0]}_dss_clone1.script
printf "\n" >> ${ID[0]}_dss_clone1.script
printf "../alignment.sh -se_epi $FILE ../genomes/ ${ID[0]}\n" >> ${ID[0]}_dss_clone1.script

done

#for each of these submissions, submit to the queue system

for SUB in *alignment.qsub.script
do
qsub $SUB
done

#done

for COMBO in {1..10}
do
printf "#!/bin/bash\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -P xe2\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -q normal\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l walltime=02:00:00\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l mem=15GB\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l jobfs=15GB\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l ncpus=8\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l software=R_DSS\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l wd\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "module load R/3.4.0\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "R --vanilla\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "metadata=read.delim('dss_metadata.txt',head=T)\n" >> ${COMBO}_dss_clone1.script
printf "nohyb=subset(metadata,metadata\$ClonalGroup!='HYB1' & metadata\$ClonalGroup!='HYB2')\n" >> ${COMBO}_dss_clone1.script
printf "clone1 = subset(nohyb,nohyb\$ClonalGroup=='Clone1')\n" >> ${COMBO}_dss_clone1.script
printf "combinations=combn(unique(clone1\$Accession),2)\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "library(DSS)\n" >> ${COMBO}_dss_clone1.script
printf "i=$COMBO\n" >> ${COMBO}_dss_clone1.script
printf "namecombo = paste(combinations[1,i],"_vs_",combinations[2,i],sep='')\n" >> ${COMBO}_dss_clone1.script
printf "f1=as.character(combinations[1,i])\n" >> ${COMBO}_dss_clone1.script
printf "f2=as.character(combinations[2,i])\n" >> ${COMBO}_dss_clone1.script
printf "f1.ids=clone1[which(clone1\$Accession==f1),1][1:3] #1:3 are spring, 4:6 are fall\n" >> ${COMBO}_dss_clone1.script
printf "f2.ids=clone1[which(clone1\$Accession==f2),1][1:3]\n" >> ${COMBO}_dss_clone1.script
printf "f1.files=paste(f1.ids,'.fastq.gz_CpG.bed.bismark.cov.dss',sep='')\n" >> ${COMBO}_dss_clone1.script
printf "f2.files=paste(f2.ids,'.fastq.gz_CpG.bed.bismark.cov.dss',sep='')\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "f1.1=read.delim(f1.files[1],head=T)\n" >> ${COMBO}_dss_clone1.script
printf "f1.2=read.delim(f1.files[2],head=T)\n" >> ${COMBO}_dss_clone1.script
printf "f1.3=read.delim(f1.files[3],head=T)\n" >> ${COMBO}_dss_clone1.script
printf "f2.1=read.delim(f2.files[1],head=T)\n" >> ${COMBO}_dss_clone1.script
printf "f2.2=read.delim(f2.files[2],head=T)\n" >> ${COMBO}_dss_clone1.script
printf "f2.3=read.delim(f2.files[3],head=T)\n" >> ${COMBO}_dss_clone1.script
printf "test=makeBSseqData(list(f1.1,f1.2,f1.3,f2.1,f2.2,f2.3),c(paste(rep(f1,3),1:3,sep='_'),paste(rep(f2,3),1:3,sep='_')))\n" >> ${COMBO}_dss_clone1.script
printf "dmltest=DMLtest(test,group1=paste(rep(f1,3),1:3,sep='_'),group2=paste(rep(f2,3),1:3,sep='_'),smoothing=T)\n" >> ${COMBO}_dss_clone1.script
printf "dmls=callDML(dmltest)\n" >> ${COMBO}_dss_clone1.script
printf "write.table(dmls,paste(namecombo,'.dmls',sep=''))\n" >> ${COMBO}_dss_clone1.script
printf "quit()\n" >> ${COMBO}_dss_clone1.script
printf "n\n" >> ${COMBO}_dss_clone1.script
printf "#\n" >> ${COMBO}_dss_clone1.script
done



for COMBO in {1..231}
do
printf "#!/bin/bash\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -P xe2\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -q normal\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l walltime=24:00:00\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l mem=15GB\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l jobfs=15GB\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l ncpus=8\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l software=R_DSS\n" >> ${COMBO}_dss_clone1.script
printf "#PBS -l wd\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "module load R/3.4.0\n" >> ${COMBO}_dss_clone1.script
printf "\n" >> ${COMBO}_dss_clone1.script
printf "Rscript dss_clone1.R $COMBO\n" >> ${COMBO}_dss_clone1.script

done
