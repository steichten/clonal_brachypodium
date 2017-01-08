


mkdir rawdata
printf "rawdata\n" >> .gitignore
cd rawdata

#start pulling SRA files for skim data
SRALIST=$(tail -n +2 ../sequencing_record.txt | grep -v "S[pP]1"  | cut -f 14)

for SRAFILE in $SRALIST
do
    wget -N ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/${SRAFILE::-4}/${SRAFILE}/${SRAFILE}.sra
done

#confirm data files are as expected
#must make this shasum file
shasum -c ../rawdata_shasums.sha

#convert sra files back into gzipped fastq files for analysis
for FILE in *.sra
do
    fastq-dump --gzip ./$FILE
    rm $FILE
done

#rename all SRA files to their sampleID
for SRANAME in *.fastq.gz
do
    sra=${SRANAME::-9}
    line=$(grep ${sra} ../sequencing_record.txt | cut -f 1)
    mv $SRANAME ${line}.fastq.gz
    echo "$SRANAME moved to ${line}.fastq.gz" >> renaming_sra_files.log
done