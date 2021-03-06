#!bin/bash

#submission creation script for TEPID analysis

cd rawdata_wgs

mkdir tepid_results

READ1FILE=($(ls *_1.fastq.gz))
GENOMEPATH="../genome_files/Bdistachyon_192"
YAHAGENOMEPATH="../genome_files/Bdistachyon_192.X15_01_65525S"
for FILE in "${READ1FILE[@]}"

do

ID=(${FILE//_1.fastq.gz/ })
echo ${ID[0]}
DATE=$(date)

printf "#!/bin/bash\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -P xe2\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -q normal\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l walltime=24:00:00\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l mem=16GB\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l jobfs=15GB\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l ncpus=12\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l software=TEPID\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l wd\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "#This script was generated automatically on $DATE\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "module load samtools/1.2\n" >> ${ID[0]}_alignment.qsub.script
printf "module load python/2.7.11\n" >> ${ID[0]}_alignment.qsub.script
printf "module load bowtie2/2.2.5\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "tepid-map -x ${GENOMEPATH} -y ${YAHAGENOMEPATH} -p 12 -s 200 -n ${ID[0]} -1 $FILE -2 ${FILE//_1.fastq.gz/_2.fastq.gz}\n" >> ${ID[0]}_alignment.qsub.script
printf "tepid-discover -p 12 -n ${ID[0]} -c ${ID[0]}.bam -s ${ID[0]}.split.bam -t \$HOME/bin/TEPID/Annotation/Brachypodium/Brachy_TE_v2.2.bed.gz\n" >> ${ID[0]}_alignment.qsub.script
printf "mv deletion_reads_${ID[0]}.txt tepid_results/\n" >> ${ID[0]}_alignment.qsub.script
printf "mv deletions_${ID[0]}.bed tepid_results/\n" >> ${ID[0]}_alignment.qsub.script
printf "mv insertion_reads_${ID[0]}.txt tepid_results/\n" >> ${ID[0]}_alignment.qsub.script
printf "mv insertions_${ID[0]}.bed tepid_results/\n" >> ${ID[0]}_alignment.qsub.script
done

for SUB in *.script
do
qsub $SUB
done
