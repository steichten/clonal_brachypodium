
cd rawdata_lowcoverage

#move sra conversion qsub files

mkdir sraconvert_logs
mv *convert.qsub.script sraconvert_logs
mv *.e* sraconvert_logs
mv *.o* sraconvert_logs


#move alignment qsub files
mkdir alignment_logs
mv *convert.qsub.script alignment_logs
mv *.e* alignment_logs
mv *.o* alignment_logs

##################

cd ../rawdata_highcoverage

mkdir sraconvert_logs
mv *convert.qsub.script sraconvert_logs
mv *.e* sraconvert_logs
mv *.o* sraconvert_logs


#move alignment qsub files
mkdir alignment_logs
mv *convert.qsub.script alignment_logs
mv *.e* alignment_logs
mv *.o* alignment_logs




#done
