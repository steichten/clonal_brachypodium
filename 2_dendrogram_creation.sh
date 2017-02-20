#PBS -P xe2
#PBS -q normal
#PBS -l walltime=12:00:00
#PBS -l mem=32GB
#PBS -l jobfs=150GB
#PBS -l ncpus=8
#PBS -l software=R_dendrograms
#PBS -l wd

module load R
#SRE
#Feb2, 2017
#this script will take the aligned low coverage data and create 
#dendrograms in R to show the general relationship of samples

#go into lowcoverage folder
cd rawdata_lowcoverage

#make new folder for wig files
#mkdir -p ./100bp_wigs/{cg,chg,chh}

#grab all 100bp wig files from the aligned data outputs as variable for R
cgfiles=$(find -name "S*CpG*.wig")
chgfiles=$(find -name "S*CHG*.wig")
chhfiles=$(find -name "S*CHH*.wig")

#find -name "*CpG*.wig" | xargs cp -t 100bp_wigs/cg/
#find -name "*CHG*.wig" | xargs cp -t 100bp_wigs/chg/
#find -name "*CHH*.wig" | xargs cp -t 100bp_wigs/chh/

#make dendrogrames for each context. First argument is file prefix (CG/CHG/CHH), second is vector of all wigfiles for said context

Rscript ../methylation_tile_tree.R CG $cgfiles

Rscript ../methylation_tile_tree.R CHG $chgfiles

Rscript ../methylation_tile_tree.R CHH $chhfiles
