#!/usr/bin/env bash

#====================
#====================

# shell script for normalizing uniquely mapped PROseq reads by subsampling to the lowest read number
	     
#====================
#====================

# Required:
					      
#1. bedtools - can be installed with 'sudo apt install bedtools' (version 2.26.0)
#2. samtools - can be installed with 'sudo apt install samtools' (version 1.7)
#3. bedgraphToBigwig - can be installed with 'conda install -c bioconda ucsc-bedgraphtobigwig'
					      				              
#=============================================================================================

#Paths

bgToBigWig="/home/emw97/Seq_utils/bedGraphToBigWig"
expchrominfo="/home/emw97/Seq_utils/hg38.chrom.sizes_ref.txt"

#Sample names
samples="
GR_A549_WT_0dex_A
GR_A549_WT_01dex_A
GR_A549_WT_100dex_A
GR_A549_dGOR_0dex_A
GR_A549_dGOR_01dex_A
GR_A549_dGOR_100dex_A
GR_A549_WT_0dex_B
GR_A549_WT_01dex_B
GR_A549_WT_100dex_B
GR_A549_dGOR_0dex_B
GR_A549_dGOR_01dex_B
GR_A549_dGOR_100dex_B
GR_U20S_WT_0dex_A
GR_U20S_WT_01dex_A
GR_U20S_WT_100dex_A
GR_U20S_dGOR_0dex_A
GR_U20S_dGOR_01dex_A
GR_U20S_dGOR_100dex_A
GR_U20S_WT_0dex_B
GR_U20S_WT_01dex_B
GR_U20S_WT_100dex_B
GR_U20S_dGOR_0dex_B
GR_U20S_dGOR_01dex_B
GR_U20S_dGOR_100dex_B
"

for sample in ${samples}
	do
	echo "Making bams"
	echo $sample
	/home/emw97/bedtools2/bin/bedToBam -i ${sample%%.*}_hg38_sorted.bed -g ${expchrominfo} > ${sample%%.*}_hg.bam
done

### finding read numbers

wc -l *hg38_sorted.bed

#    7678129 GR_A549_dGOR_01dex_A_hg38_sorted.bed
#    7779975 GR_A549_dGOR_01dex_B_hg38_sorted.bed
#   15144272 GR_A549_dGOR_0dex_A_hg38_sorted.bed
#    8052076 GR_A549_dGOR_0dex_B_hg38_sorted.bed
#    3567459 GR_A549_dGOR_100dex_A_hg38_sorted.bed
#    9433922 GR_A549_dGOR_100dex_B_hg38_sorted.bed
#    6491604 GR_A549_WT_01dex_A_hg38_sorted.bed
#   17968215 GR_A549_WT_01dex_B_hg38_sorted.bed
#    7106617 GR_A549_WT_0dex_A_hg38_sorted.bed
#   18153195 GR_A549_WT_0dex_B_hg38_sorted.bed
#   10494645 GR_A549_WT_100dex_A_hg38_sorted.bed
#   12091801 GR_A549_WT_100dex_B_hg38_sorted.bed
#    6533838 GR_U20S_dGOR_01dex_A_hg38_sorted.bed
#   17255004 GR_U20S_dGOR_01dex_B_hg38_sorted.bed
#    5861089 GR_U20S_dGOR_0dex_A_hg38_sorted.bed
#   13713840 GR_U20S_dGOR_0dex_B_hg38_sorted.bed
#    8746348 GR_U20S_dGOR_100dex_A_hg38_sorted.bed
#   10530249 GR_U20S_dGOR_100dex_B_hg38_sorted.bed
#   10334232 GR_U20S_WT_01dex_A_hg38_sorted.bed
#   12491112 GR_U20S_WT_01dex_B_hg38_sorted.bed
#    5779420 GR_U20S_WT_0dex_A_hg38_sorted.bed
#   13342787 GR_U20S_WT_0dex_B_hg38_sorted.bed
#    4350297 GR_U20S_WT_100dex_A_hg38_sorted.bed
#   12245336 GR_U20S_WT_100dex_B_hg38_sorted.bed


# Percentages to use for subsampling:
#    0.4646 GR_A549_dGOR_01dex_A_hg38_sorted.bed
#    0.4585 GR_A549_dGOR_01dex_B_hg38_sorted.bed
#    0.2356 GR_A549_dGOR_0dex_A_hg38_sorted.bed
#    0.4430 GR_A549_dGOR_0dex_B_hg38_sorted.bed
#    1.0    GR_A549_dGOR_100dex_A_hg38_sorted.bed
#    0.3782 GR_A549_dGOR_100dex_B_hg38_sorted.bed
#    0.5495 GR_A549_WT_01dex_A_hg38_sorted.bed
#    0.1985 GR_A549_WT_01dex_B_hg38_sorted.bed
#    0.5020 GR_A549_WT_0dex_A_hg38_sorted.bed
#    0.1965 GR_A549_WT_0dex_B_hg38_sorted.bed
#    0.3399 GR_A549_WT_100dex_A_hg38_sorted.bed
#    0.2950 GR_A549_WT_100dex_B_hg38_sorted.bed
#    0.5460 GR_U20S_dGOR_01dex_A_hg38_sorted.bed
#    0.2067 GR_U20S_dGOR_01dex_B_hg38_sorted.bed
#    0.6087 GR_U20S_dGOR_0dex_A_hg38_sorted.bed
#    0.2601 GR_U20S_dGOR_0dex_B_hg38_sorted.bed
#    0.4079 GR_U20S_dGOR_100dex_A_hg38_sorted.bed
#    0.3388 GR_U20S_dGOR_100dex_B_hg38_sorted.bed
#    0.3452 GR_U20S_WT_01dex_A_hg38_sorted.bed
#    0.2856 GR_U20S_WT_01dex_B_hg38_sorted.bed
#    0.6172 GR_U20S_WT_0dex_A_hg38_sorted.bed
#    0.2674 GR_U20S_WT_0dex_B_hg38_sorted.bed
#    0.8200 GR_U20S_WT_100dex_A_hg38_sorted.bed
#    0.2913 GR_U20S_WT_100dex_B_hg38_sorted.bed

gzip *.bed

samtools view -o A549_dGOR_01dex_A_subsampled.bam -b -s 0.4646 GR_A549_dGOR_01dex_A_hg38.bam
samtools view -o A549_dGOR_01dex_B_subsampled.bam -b -s 0.4585 GR_A549_dGOR_01dex_B_hg38.bam
samtools view -o A549_dGOR_0dex_A_subsampled.bam -b -s 0.2356 GR_A549_dGOR_0dex_A_hg38.bam
samtools view -o A549_dGOR_0dex_B_subsampled.bam -b -s 0.4430 GR_A549_dGOR_0dex_B_hg38.bam
cp GR_A549_dGOR_100dex_A_hg38.bam ./A549_dGOR_100dex_A_subsampled.bam
samtools view -o A549_dGOR_100dex_B_subsampled.bam -b -s 0.3782 GR_A549_dGOR_100dex_B_hg38.bam

samtools view -o A549_WT_01dex_A_subsampled.bam -b -s 0.5495 GR_A549_WT_01dex_A_hg38.bam
samtools view -o A549_WT_01dex_B_subsampled.bam -b -s 0.1985 GR_A549_WT_01dex_B_hg38.bam
samtools view -o A549_WT_0dex_A_subsampled.bam -b -s 0.5020 GR_A549_WT_0dex_A_hg38.bam
samtools view -o A549_WT_0dex_B_subsampled.bam -b -s 0.1965 GR_A549_WT_0dex_B_hg38.bam
samtools view -o A549_WT_100dex_A_subsampled.bam -b -s 0.3399 GR_A549_WT_100dex_A_hg38.bam
samtools view -o A549_WT_100dex_B_subsampled.bam -b -s 0.2950 GR_A549_WT_100dex_B_hg38.bam

samtools view -o U2OS_dGOR_01dex_A_subsampled.bam -b -s 0.5460 GR_U20S_dGOR_01dex_A_hg38.bam
samtools view -o U2OS_dGOR_01dex_B_subsampled.bam -b -s 0.2067 GR_U20S_dGOR_01dex_B_hg38.bam
samtools view -o U2OS_dGOR_0dex_A_subsampled.bam -b -s 0.2356 GR_U20S_dGOR_0dex_A_hg38.bam
samtools view -o U2OS_dGOR_0dex_B_subsampled.bam -b -s 0.2601 GR_U20S_dGOR_0dex_B_hg38.bam
samtools view -o U2OS_dGOR_100dex_A_subsampled.bam -b -s 0.4079 GR_U20S_dGOR_100dex_A_hg38.bam
samtools view -o U2OS_dGOR_100dex_B_subsampled.bam -b -s 0.3388 GR_U20S_dGOR_100dex_B_hg38.bam

samtools view -o U2OS_WT_01dex_A_subsampled.bam -b -s 0.3452 GR_U20S_WT_01dex_A_hg38.bam
samtools view -o U2OS_WT_01dex_B_subsampled.bam -b -s 0.2856 GR_U20S_WT_01dex_B_hg38.bam
samtools view -o U2OS_WT_0dex_A_subsampled.bam -b -s 0.6172 GR_U20S_WT_0dex_A_hg38.bam
samtools view -o U2OS_WT_0dex_B_subsampled.bam -b -s 0.2674 GR_U20S_WT_0dex_B_hg38.bam
samtools view -o U2OS_WT_100dex_A_subsampled.bam -b -s 0.8200 GR_U20S_WT_100dex_A_hg38.bam
samtools view -o U2OS_WT_100dex_B_subsampled.bam -b -s 0.2913 GR_U20S_WT_100dex_B_hg38.bam




for sample in $samples
	do
	echo $sample
	samtools sort -o ${sample%%.*}_subsampled_sorted.bam ${sample%%.*}_subsampled.bam
	genomeCoverageBed -ibam ${sample%%.*}_subsampled_sorted.bam -strand + -3 -bg -g ${expchrominfo} > ${sample%%.*}_subsampled_plus.bedgraph
	${bgToBigWig} ${sample%%.*}_subsampled_plus.bedgraph $expchrominfo ${sample%%.*}_subsampled_plus.bw
	genomeCoverageBed -ibam ${sample%%.*}_subsampled_sorted.bam -strand - -scale -1 -3 -bg -g ${expchrominfo} >  ${sample%%.*}_subsampled_minus.bedgraph 
	${bgToBigWig} ${sample%%.*}_subsampled_minus.bedgraph  $expchrominfo ${sample%%.*}_subsampled_minus.bw
	done
	
rm *.bedgraph
gzip *.bed
