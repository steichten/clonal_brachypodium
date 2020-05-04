# Extended Genotype analysis of 'clonal' _Brachypodium distachyon_ populations

---
<img src='https://borevitzlab.anu.edu.au/wp-content/uploads/2017/05/chamber1.jpg'>
---

Analysis steps for clonal Brachypodium methylation project (BVZ0049)

The scripts provided in this repository are tied to the published manuscript:

### [Extending the Genotype in Brachypodium by Including DNA Methylation Reveals a Joint Contribution with Genetics on Adaptive Traits](https://www.ncbi.nlm.nih.gov/pubmed/32132166/?utm_source=gquery&utm_medium=referral&utm_campaign=CitationSensor)

### Abstract:
>Epigenomic changes have been considered a potential missing link underlying phenotypic variation in quantitative traits but is potentially confounded with the underlying DNA sequence variation. Although the concept of epigenetic inheritance has been discussed in depth, there have been few studies attempting to directly dissect the amount of epigenomic variation within inbred natural populations while also accounting for genetic diversity. By using known genetic relationships between Brachypodium lines, multiple sets of nearly identical accession families were selected for phenotypic studies and DNA methylome profiling to investigate the dual role of (epi)genetics under simulated natural seasonal climate conditions. Despite reduced genetic diversity, appreciable phenotypic variation was still observable in the measured traits (height, leaf width and length, tiller count, flowering time, ear count) between as well as within the inbred accessions. However, with reduced genetic diversity there was diminished variation in DNA methylation within families. Mixed-effects linear modelling revealed large genetic differences between families and a minor contribution of DNA methylation variation on phenotypic variation in select traits. Taken together, this analysis suggests a limited but significant contribution of DNA methylation towards heritable phenotypic variation relative to genetic differences.

---

# Outline

1. Download all sequence data from Short Read Archive (600+ samples)
2. Prepare annotation files and index reference genome sequence for alignment
3. Perform bisulfite alignments
4. Create master datafiles of methylation for analysis
5. Format and create datafiles for phenotypes

# Software Requirements

- [Bismark](https://github.com/FelixKrueger/Bismark) (0.13.0)
- [samtools](https://github.com/samtools/samtools) (1.2)
- [R](https://www.r-project.org/) (3.3.2)
- [trimgalore](https://github.com/FelixKrueger/TrimGalore) (0.4.2)
- [cutadapt](https://github.com/marcelm/cutadapt) (1.9.1)
- [bedtools](https://github.com/arq5x/bedtools2) (2.25.0)
- [sratools](https://github.com/ncbi/sra-tools) (2.8.0)
- [fastqc](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/) (0.11.5)
- [bowtie1](https://github.com/BenLangmead/bowtie) (1.1.2)


# Notes

- `metadata.txt` contains information on all 604 clonal samples which were sequenced. This is parsed in some of the initia scripts to pull data from the SRA

- `sequencing_record.txt` has the SRA Run IDs (SRR) highlight the low coverage, high coverage, and WGS data used in this work.






---
