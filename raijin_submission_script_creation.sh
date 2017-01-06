


for FILE in *.fastq.gz
do
ID=(${FILE//_/ })
DATE=$(date)
printf "#!/bin/bash\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -P xe2\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -q normal\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l walltime=08:00:00\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l mem=16GB\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l jobfs=150GB\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l ncpus=8\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l software=bismark_aligner\n" >> ${ID[0]}_alignment.qsub.script
printf "#PBS -l wd\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "#This script was generated automatically on $DATE\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "module load java\n" >> ${ID[0]}_alignment.qsub.script
printf "module load samtools/1.3.1\n" >> ${ID[0]}_alignment.qsub.script
printf "module load python/2.7.11\n" >> ${ID[0]}_alignment.qsub.script
printf "module load perl/5.22.1\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "export PATH=\$PATH:\$HOME/bin:\$HOME/.local/bin/\n" >> ${ID[0]}_alignment.qsub.script
printf "\n" >> ${ID[0]}_alignment.qsub.script
printf "\$HOME/scripts/wgbs_pipelinev0.4.sh -se_epi $FILE ../genomes/ ${ID[0]}\n" >> ${ID[0]}_alignment.qsub.script

done

for SUB in *.script
do
qsub $SUB
done