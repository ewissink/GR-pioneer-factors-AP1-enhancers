# bigwigAverage \
#     -b ../chip_atac_data/GSM7782685_U2OS_ATAC.bw \
#        ../chip_atac_data/GSM7782686_USO2_ATAC.bw \
#        ../chip_atac_data/GSM7782687_U2OS_ATAC.bw \
#     -o ../chip_atac_data/U2OS_ATAC.bw --verbose -p 4

export bed_path='../Data_from_analyses/'
export chip_path='../chip_atac_data/'
computeMatrix reference-point \
    -R ${bed_path}A549_U2OS_GR_overlap.bed ${bed_path}A549_GR_unique.bed ${bed_path}U2OS_GR_unique.bed \
    -S \
        ${chip_path}GSM4978295_A549_GR_EtOH.bigwig \
        ${chip_path}GSM4978294_A549_GR_Dex.bigwig \
        ${chip_path}ENCFF214BCI_A549_ATAC_combined.bw \
        ${chip_path}GSM4978297_U2OS_GR_EtOH.bigwig \
        ${chip_path}GSM4978296_U2OS_GR_Dex.bigwig \
        ${chip_path}U2OS_ATAC.bw \
    -out A549_U2OS_GR_ATAC_3categories_1kb.computeMatrix.gz \
    --missingDataAsZero \
    -a 1000 -b 1000 \
    -p 4 --verbose

plotHeatmap \
    --matrixFile A549_U2OS_GR_ATAC_3categories_1kb.computeMatrix.gz \
    --outFileName A549_U2OS_GR_ATAC_3categories_1kb.heatmap.pdf \
    --xAxisLabel ’GORs’ --refPointLabel ’center’ \
    --colorMap Reds Reds Blues Reds Reds Blues \
    --zMin 0 --zMax 100 100 25 100 100 1 \
    --verbose