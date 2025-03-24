#Taking GR ChIP-seq summits and creating files of +- 25 bp windows surrounding the summits
msPath='../../Manuscript_data/'
outputs='../../figure_outputs/'
chipPath='../../chip_atac_data/'

export PATH=$PATH:../../../homer/bin

# cat ${msPath}GR_summits_A549.bed | awk 'BEGIN{OFS="\t"}{print $1,$2 -25,$3 +24}' > ${outputs}GR_summits_A549_50bp.bed

# cat ${msPath}GR_summits_U2OS-hGR.bed | awk 'BEGIN{OFS="\t"}{print $1,$2 -25,$3 +24}' > ${outputs}GR_summits_U2OS-hGR_50bp.bed

# #Writing files of GR ChIP-seq peaks that are shared or cell type-specific
# intersectBed -wa -a ${outputs}GR_summits_A549_50bp.bed \
# -b ${outputs}GR_summits_U2OS-hGR_50bp.bed > ${outputs}A549_U2OS_GR_overlap.bed

# intersectBed -wa -v -a ${outputs}GR_summits_A549_50bp.bed \
# -b ${outputs}GR_summits_U2OS-hGR_50bp.bed > ${outputs}A549_GR_unique.bed

# intersectBed -wa -v -a ${outputs}GR_summits_U2OS-hGR_50bp.bed \
# -b ${outputs}GR_summits_A549_50bp.bed > ${outputs}U2OS_GR_unique.bed

#With Deeptools, plotting signal of GR ChIP-seq and ATAC-seq data, 
#+- 500 bp from GR peaks, in A549 and U2OS cells, 
#at GR peaks that are shared or cell type-specific. 
#Bigwigs for GR came from GSE163398. 
#ATAC-seq data was re-aligned using the ENCODE ATAC-seq pipeline 
#(https://github.com/ENCODE-DCC/atac-seq-pipeline) 
#using fastqs from ENCSR220ASC (A549) and GSE109589 (U2OS)

# bigwigAverage \
#     -b ${chipPath}GSM7782685_U2OS_ATAC.bw \
#        ${chipPath}GSM7782686_USO2_ATAC.bw \
#        ${chipPath}GSM7782687_U2OS_ATAC.bw \
#     -o ${chipPath}U2OS_ATAC.bw --verbose -p 4

# computeMatrix reference-point \
#     -R ${outputs}A549_U2OS_GR_overlap.bed ${outputs}A549_GR_unique.bed ${outputs}U2OS_GR_unique.bed \
#     -S \
#         ${chipPath}GSM4978295_A549_GR_EtOH.bigwig \
#         ${chipPath}GSM4978294_A549_GR_Dex.bigwig \
#         ${chipPath}ENCFF214BCI_A549_ATAC_combined.bw \
#         ${chipPath}GSM4978297_U2OS_GR_EtOH.bigwig \
#         ${chipPath}GSM4978296_U2OS_GR_Dex.bigwig \
#         ${chipPath}U2OS_ATAC.bw \
#     -out ${outputs}A549_U2OS_GR_ATAC_3categories_1kb.computeMatrix.gz \
#     --missingDataAsZero \
#     -a 1000 -b 1000 \
#     -p 4 --verbose

# computeMatrix reference-point \
#     -R ${outputs}A549_U2OS_GR_overlap.bed ${outputs}A549_GR_unique.bed ${outputs}U2OS_GR_unique.bed \
#     -S \
#         ${chipPath}GSM4978295_A549_GR_EtOH.bigwig \
#         ${chipPath}GSM4978294_A549_GR_Dex.bigwig \
#         ${chipPath}ENCFF214BCI_A549_ATAC_combined.bw \
#         ${chipPath}GSM4978297_U2OS_GR_EtOH.bigwig \
#         ${chipPath}GSM4978296_U2OS_GR_Dex.bigwig \
#         ${chipPath}U2OS_ATAC.bw \
#     -out ${outputs}A549_U2OS_GR_ATAC_3categories_500bp.computeMatrix.gz \
#     --missingDataAsZero \
#     -a 500 -b 500 \
#     -p 4 --verbose

# plotHeatmap \
#     --matrixFile ${outputs}A549_U2OS_GR_ATAC_3categories_1kb.computeMatrix.gz \
#     --outFileName ${outputs}A549_U2OS_GR_ATAC_3categories_1kb.heatmap.pdf \
#     --xAxisLabel GORs --refPointLabel center \
#     --colorMap Reds Reds Blues Reds Reds Blues \
#     --zMin 0 --zMax 100 100 25 100 100 1 \
#     --verbose

# plotHeatmap \
#     --matrixFile ${outputs}A549_U2OS_GR_ATAC_3categories_500bp.computeMatrix.gz \
#     --outFileName ${outputs}A549_U2OS_GR_ATAC_3categories_500bp.heatmap.pdf \
#     --xAxisLabel GORs --refPointLabel center \
#     --colorMap Reds Reds Blues Reds Reds Blues \
#     --zMin 0 --zMax 100 100 25 100 100 1 \
#     --verbose

# Creating fasta files to use in HOMER that are +-150 bp from the GR summit. 
#The hg38.fa file is too large for Github but came from 
#https://hgdownload.cse.ucsc.edu/goldenpath/hg38/bigZips/hg38.fa.gz

# # All GORs in A549 cells
# cat ${msPath}GR_summits_A549.bed | \
#   awk 'BEGIN{OFS="\t"}{print $1,$2 -150,$3 +149}' | \
#   grep -v chrM | grep -v chrEBV | sed '/_/d' | \
#   fastaFromBed -fi ${msPath}hg38.fa -bed stdin -fo ${outputs}A549_GORs.fa

# # All GORs in U2OS cells
# cat ${msPath}GR_summits_U2OS-hGR.bed | \
#   awk 'BEGIN{OFS="\t"}{print $1,$2 -150,$3 +149}' | \
#   grep -v chrM | grep -v chrEBV | sed '/_/d' | \
#   fastaFromBed -fi ${msPath}hg38.fa -bed stdin -fo ${outputs}U2OS_GORs.fa

# # GORs shared in A549 and U2OS cells
# cat ${outputs}A549_U2OS_GR_overlap.bed | \
#   awk 'BEGIN{OFS="\t"}{print $1,$2 -125,$3 +124}' | \
#   grep -v chrM | grep -v chrEBV | sed '/_/d' | \
#   fastaFromBed -fi ${msPath}hg38.fa -bed stdin -fo ${outputs}A549_U2OS_GR_overlap.fa

# # GORs only in A549 cells
# cat ${outputs}A549_GR_unique.bed | \
#   awk 'BEGIN{OFS="\t"}{print $1,$2 -125,$3 +124}' | \
#   grep -v chrM | grep -v chrEBV | sed '/_/d' | \
#   fastaFromBed -fi ${msPath}hg38.fa -bed stdin -fo ${outputs}A549_GR_unique.fa

# # GORs only in U2OS cells
# cat ${outputs}U2OS_GR_unique.bed | \
#   awk 'BEGIN{OFS="\t"}{print $1,$2 -125,$3 +124}' | \
#   grep -v chrM | grep -v chrEBV | sed '/_/d' | \
#   fastaFromBed -fi ${msPath}hg38.fa -bed stdin -fo ${outputs}U2OS_GR_unique.fa

# # GORs only in A549 or U2OS cells, but not in both cell types
# cat ${outputs}A549_GR_unique.bed U2OS_GR_unique.bed | \
#   awk 'BEGIN{OFS="\t"}{print $1,$2 -125,$3 +124}' | \
#   grep -v chrM | grep -v chrEBV | sed '/_/d' | \
#   fastaFromBed -fi ${msPath}hg38.fa -bed stdin -fo ${outputs}A549_U2OS_distinct_overlap.fa

# Running HOMER 

# hoco=${msPath}'HOCOMOCOv11_core_HUMAN_mono_homer_format_0.001.motif'

# # Finding motifs specific to A549 GORs
# findMotifs.pl ${outputs}A549_GORs.fa fasta ${outputs}A549_GORs_vs_U2OS \
#   -len 8,10,12 -fastaBg ${outputs}U2OS_GORs.fa \
#   -mcheck $hoco -bits -nogo -mknown $hoco 

# # Finding motifs specific to U2OS GORs
# findMotifs.pl ${outputs}U2OS_GORs.fa fasta ${outputs}U2OS_GORs_vs_A549 \
#   -len 8,10,12 -fastaBg ${outputs}A549_GORs.fa \
#   -mcheck $hoco -bits -nogo -mknown $hoco 

# # Finding motifs specific to shared GORs
# findMotifs.pl ${outputs}A549_U2OS_GR_overlap.fa fasta \
#   ${outputs}overlapping_vs_unique_GORS \
#   -len 8,10,12 \
#   -fastaBg ${outputs}A549_U2OS_distinct_overlap.fa \
#   -mcheck $hoco -bits -nogo -mknown $hoco 
   

   # TODO: update to have correct data sources
## Code used in 2C to run Deeptools for making metaplots of TF occupancy at shared and cell type-specific GORs. 
## ChIP-seq data was re-aligned using the ENCODE ChIP-seq pipeline (https://github.com/ENCODE-DCC/chip-seq-pipeline) 
## using fastqs from GSE90454 (FOXA2), ENCSR701TCU (CEBPB), ENCSR656VWZ (JUNB), ENCSR593DGU (FOSL2), and ENCSR192PBJ (JUN). 
## Bigwigs for GR came from GSE163398. ATAC-seq data was re-aligned using the ENCODE ATAC-seq pipeline 
## (https://github.com/ENCODE-DCC/atac-seq-pipeline) using fastqs from ENCSR220ASC (A549).

# computeMatrix reference-point \
#     -R \
#         ${outputs}A549_U2OS_GR_overlap.bed \
#         ${outputs}A549_GR_unique.bed \
#         ${outputs}U2OS_GR_unique.bed \
#     -S \
#         ${chipPath}ENCFF214BCI_A549_ATAC_combined.bw \
#         ${chipPath}ENCFF863XVE_A549_CEBPB.bigWig \
#         ${chipPath}ENCFF640SEZ_A549_FOXA1.bigWig \
#         ${chipPath}ENCFF322HMV_A549_FOXA2.bigWig \
#         ${chipPath}ENCFF082UOK_A549_FOSL2.bigWig\
#         ${chipPath}ENCFF129REO_A549_FOSL2.bigWig \
#         ${chipPath}ENCFF522ITF_A549_JUN.bigWig \
#         ${chipPath}ENCFF364KVI_A549_JUNB.bigWig \
#         ${chipPath}ENCFF292YDK_A549_JUND.bigWig \
#         ${chipPath}GSM4978294_A549_GR_Dex.bigwig \
#     -out ${outputs}A549_U2OS_GR_ATAC_3categories_ChIPdata_1kb.computeMatrix.gz  \
#     --missingDataAsZero -a 1000 -b 1000 -p 4

    # computeMatrix reference-point \
    # -R \
    #    ${outputs}A549_U2OS_GR_overlap.bed \
    #     ${outputs}A549_GR_unique.bed \
    #     ${outputs}U2OS_GR_unique.bed \
    # -S \
    #     ${chipPath}ENCFF214BCI_A549_ATAC_combined.bw \
    #     ${chipPath}ENCFF863XVE_A549_CEBPB.bigWig \
    #     ${chipPath}ENCFF640SEZ_A549_FOXA1.bigWig \
    #     ${chipPath}ENCFF322HMV_A549_FOXA2.bigWig \
    #     ${chipPath}ENCFF082UOK_A549_FOSL2.bigWig\
    #     ${chipPath}ENCFF129REO_A549_FOSL2.bigWig \
    #     ${chipPath}ENCFF522ITF_A549_JUN.bigWig \
    #     ${chipPath}ENCFF364KVI_A549_JUNB.bigWig \
    #     ${chipPath}ENCFF292YDK_A549_JUND.bigWig \
    #     ${chipPath}GSM4978294_A549_GR_Dex.bigwig \
    # -out ${outputs}A549_U2OS_GR_ATAC_3categories_ChIPdata_500bp.computeMatrix.gz  \
    # --missingDataAsZero -a 500 -b 500 -p 4




# plotProfile \
#   --matrixFile ${outputs}A549_U2OS_GR_ATAC_3categories_ChIPdata_1kb.computeMatrix.gz \
#   --outFileName ${outputs}A549_U2OS_GR_ATAC_3categories_ChIPdata_1kb.metaplot.pdf \
#   --refPointLabel center \
#   --yMin 0 --yMax 30 20 50 50 30 10 35 25 15 50 \
#   --colors Blue Green Magenta


#  plotProfile \
#   --matrixFile ${outputs}A549_U2OS_GR_ATAC_3categories_ChIPdata_500bp.computeMatrix.gz \
#   --outFileName ${outputs}A549_U2OS_GR_ATAC_3categories_ChIPdata_500bp.metaplot.pdf \
#   --refPointLabel center \
#   --yMin 0 --yMax 30 20 50 50 30 10 35 25 15 50 \
#     --colors Blue Green Magenta 




## Code used in 2D to find log odds scores of GBS's
# Using Homer to find all GBS scores

GCR=${msPath}'GCR_HUMAN.H11MO.0.A.motif'
 
findMotifs.pl ${outputs}A549_U2OS_GR_overlap.fa fasta test/ -find $GCR > ${outputs}overlapping_GORS_GCR_scores.txt

findMotifs.pl ${outputs}A549_GR_unique.fa fasta test/ -find $GCR > ${outputs}overlapping_GORS_GCR_scores_A549.txt

findMotifs.pl ${outputs}U2OS_GR_unique.fa fasta test/ -find $GCR > ${outputs}overlapping_GORS_GCR_scores_U2OS.txt

