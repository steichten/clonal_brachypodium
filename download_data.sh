


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
shasum -c rawdata_shasums.sha




wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/sralite/ByExp/litesra/SRX/SRX235/SRX2357078/SRR5032082/SRR5032082.sra