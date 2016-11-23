


mkdir rawdata_lowcoverage
mkdir rawdata_highcoverage

printf "rawdata_lowcoverage\n" >> .gitignore
printf "rawdata_highcoverage\n" >> .gitignore

cd rawdata_highcoverage

wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR503/SRR5032059/SRR5032059.sra #Bd21

#confirm data files are as expected
shasum -c rawdata_shasums.sha


#make directory structure
#download all of the sequence data for SP1 HiSeq2000
#download all of the sequence data for SP1 HiSeq2500 (first pass of library check)
#make fastq files
#merge fastq files from 2000 and 2500 run (as they are same library and sample)
#rename fastq files to sampleID

#download all sequence data for skim 2500 runs
#make fastq files
#rename fastq files

#download annotation data


