
temp=$(ls -1 *_R1*)
for I in $temp
do
  ID=$(echo $I | cut -d'-' -f1)
  FILE1=$I
  FILE2=$(echo $I | sed s/_R1/_R2/g)

REFGENOMEPATH=/home/steve/genomes_temp/Bdistachyon/v1.2/assembly/Bdistachyon_192
#gzip -d $FILE1
#gzip -d $FILE2

#trip reads to remove nextera adapters as well as forst 9bp which are bias
trim_galore --paired $FILE1 $FILE2

bowtie -S -p 8 $REFGENOMEPATH -1 ${FILE1::-9}_val_1.fq.gz -2 ${FILE2::-9}_val_2.fq.gz > ${ID}.sam
# -S output alignments in SAM format
#done

samtools view -Sb ${ID}.sam > ${ID}.bam #SAM to BAM
samtools sort ${ID}.bam > ${ID}.sorted.bam #sort the BAM file
samtools rmdup ${ID}.sorted.bam > ${ID}.sorted.rmdup.bam
#rm *.sam

#gzip $FILE1
#gzip $FILE2
done

samtools mpileup -Ougf ${REFGENOMEPATH}.fa ${ID}.sorted.bam | bcftools call -mvO z -o ${ID}.variants.vcf.gz
# -O output base positions on reads
# -u uncompressed output
# -g BCF format
# -f fasta reference

# -m multiallelic-caller
# -v variants-only
# -O output type compressed VCF (z)

tabix -p vcf ${ID}.variants.vcf.gz #index the vcf.gz file

#req for proper vcftools working, add to .bashrc
#PATH=$PATH:/opt/apps/htslib-1.3.2/bin/tabix
#PERL5LIB=$PERL5LIB:/home/steve/bin/vcftools-0.1.15/src/perl

cat $REFGENOMEPATH | vcf-consensus ${ID}.variants.vcf.gz > ${ID}.snpcorrected.fa


#########################
#freebayes ??

bamaddrg -b BdTR
