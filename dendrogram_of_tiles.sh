mkdir -p ./100bp_wigs/{cg,chg,chh}

find -name "*CpG*.wig" | xargs cp -t 100bp_wigs/cg/
find -name "*CHG*.wig" | xargs cp -t 100bp_wigs/chg/
find -name "*CHH*.wig" | xargs cp -t 100bp_wigs/chh/

cd 100bp_wigs/cg

Rscript methylation_tile_tree.R CpG

Rscript methylation_tile_tree.R CHG

Rscript methylation_tile_tree.R CHH