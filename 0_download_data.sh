
#!bin/bash

########################low coverage 2500 runs

mkdir rawdata_lowcoverage
printf "rawdata_lowcoverage\n" >> .gitignore #make sure git doesn't pull big files
cd rawdata_lowcoverage

#start pulling SRA file SRR identifiers for skim sequencing, skip the data used for high-coverage
SRALIST=$(tail -n +2 ../sequencing_record.txt | grep -v "S[Pp]1"  | cut -f 14)

for SRAFILE in $SRALIST
do
    #download SRA files from NCBI,
    wget -nc http://sra-download.ncbi.nlm.nih.gov/srapub/${SRAFILE}
    mv ${SRAFILE} ${SRAFILE}.sra
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

#renaming files to SAMPLEID.fastq.gz
SAMPLEID=$(tail -n +2 ../sequencing_record.txt | grep -v "S[pP]1" | cut -f 1 | sort | uniq)

printf "input1\tinput2\toutput_file\n" > renaming_sra_files.log
for SAMPLE in $SAMPLEID
do
    expectedfiles=$(tail -n +2 ../sequencing_record.txt | grep -v "S[Pp]1" | grep $SAMPLE | cut -f 14 )
    if [ "$(echo ${expectedfiles} | wc -w)" -eq 1 ]; then
      mv ${expectedfiles}.fastq.gz ${SAMPLE}.fastq.gz
      printf "${expectedfiles}.fastq.gz\t\t${SAMPLE}.fastq.gz\n" >> renaming_sra_files.log
    else
      for FILE in $expectedfiles;
      do
        cat ${FILE}.fastq.gz >> ${SAMPLE}.fastq.gz
        rm ${FILE}.fastq.gz
      done
    printf "$(echo $expectedfiles | cut -d ' ' -f1).fastq.gz\t$(echo $expectedfiles | cut -d ' ' -f2).fastq.gz\t${SAMPLE}.fastq.gz\n" >> renaming_sra_files.log
    fi
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
