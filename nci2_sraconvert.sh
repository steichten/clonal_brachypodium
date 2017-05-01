#!bin/bash

#initial sra file convertion to fastq

#prepare for submission on the raijin NCI cluster
#https://nci.org.au/

#adapt as needed for your own alignment needs

#go through and create submission scripts for all files
#note ability to change walltime, mem, jobfs, and ncpus

for ID in *.sra
do
DATE=$(date)

printf "#!/bin/bash\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -P xe2\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -q normal\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -l walltime=00:20:00\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -l mem=4GB\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -l jobfs=10GB\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -l ncpus=8\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -l software=fastq-dump\n" >> ${ID}_fq.convert.qsub.script
printf "#PBS -l wd\n" >> ${ID}_fq.convert.qsub.script
printf "\n" >> ${ID}_fq.convert.qsub.script
printf "\n" >> ${ID}_fq.convert.qsub.script
printf "#This script was generated automatically on $DATE\n" >> ${ID}_fq.convert.qsub.script
printf "\n" >> ${ID}_fq.convert.qsub.script
printf "module load java\n" >> ${ID}_fq.convert.qsub.script
printf "module load samtools/1.3.1\n" >> ${ID}_fq.convert.qsub.script
printf "module load python/2.7.11\n" >> ${ID}_fq.convert.qsub.script
printf "module load perl/5.22.1\n" >> ${ID}_fq.convert.qsub.script
printf "\n" >> ${ID}_fq.convert.qsub.script
printf "export PATH=\$PATH:\$HOME/bin:\$HOME/.local/bin/\n" >> ${ID}_fq.convert.qsub.script
printf "\n" >> ${ID}_fq.convert.qsub.script
printf "fastq-dump --gzip ./${ID}" >> ${ID}_fq.convert.qsub.script
printf "rm ${ID}" >> ${ID}_fq.convert.qsub.script
done

#for each of these submissions, submit to the queue system

for SUB in *convert.qsub.script
do
qsub $SUB
done

mkdir sraconvert_logs
mv *convert.qsub.script sraconvert_logs
mv *.e* sraconvert_logs
mv *.o* sraconvert_logs
#done
