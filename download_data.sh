


mkdir rawdata_lowcoverage
printf "rawdata_lowcoverage\n" >> .gitignore
cd rawdata_lowcoverage

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


###### SP1 high-coverage data

cd ../
mkdir rawdata_highcoverage
printf "rawdata_highcoverage\n" >> .gitignore
cd rawdata_highcoverage

#start pulling SRA files for skim data
SRALIST=$(tail -n +2 ../sequencing_record.txt | grep "S[pP]1"  | cut -f 14)

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
for sampleid in $(grep "S[pP]1" ../sequencing_record.txt | cut -f 1 | sort | uniq)
do

    sra_files=$(grep ${sampleid} ../sequencing_record.txt | grep "S[pP]1" | cut -f 14)

    if [[ -f $(echo ${sra_files} | cut -d ' ' -f1).fastq.gz && $(echo ${sra_files} | cut -d ' ' -f2).fastq.gz ]]; then
     echo "${sra_files} both exist. Combining..."
     cat $(echo ${sra_files} | cut -d ' ' -f1).fastq.gz $(echo ${sra_files} | cut -d ' ' -f2).fastq.gz > ${sampleid}_combined.fastq.gz
     echo "${sra_files} combined and moved to ${sampleid}_combined.fastq.gz" >> renaming_sra_files.log
    else
     echo "Both files ${sra_files} are not present. Skipping!"
    fi
    
done




