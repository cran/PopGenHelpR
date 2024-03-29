## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
# Load the package
library(PopGenHelpR)

## ----load data----------------------------------------------------------------
data("Fst_dat")
data("Het_dat")
data("Q_dat")
data("HornedLizard_Pop")
data("HornedLizard_VCF")

## ----Plot Ancestry------------------------------------------------------------
# First, we seperate the list elements into two seperate objects. The q-matrix (Qmat) and the locality information for each individual (Loc).
Qmat <- Q_dat[[1]]
Loc <- Q_dat[[2]]

# Now we will generate both population and individual plots by setting plot.type to 'all'. If you wanted, you could only generate individual or population plots by setting plot.type to "individual" and "population", respectively.
Test_all <- Plot_ancestry(anc.mat = Qmat, pops = Loc, K = 5,
plot.type = 'all', col = c('#d73027', '#f46d43', '#e0f3f8', '#74add1', '#313695'), Lat_buffer = 1, Long_buffer = 1)


Test_all$`Individual Ancestry Plot`


Test_all$`Population Ancestry Plot`

## ----Differentiation----------------------------------------------------------
# Isolate our fst matrix and locality information
Fst <- Fst_dat[[1]]
Loc <- Fst_dat[[2]]
# Plot the heatmap, the statistic argument is used to label the plot.
Fstat_hmap <- Pairwise_heatmap(dat = Fst, statistic = 'FST')
# Look at the plot
Fstat_hmap

## ----Differentiation map------------------------------------------------------
# Closest Neighbor
Fst_map <- Dif_Stats_Map(dat = Fst, pops = Loc, neighbors = 1,
                     col = c('#FFFF00','#FFC000','#FFA500','#e31a1c','#800026'),
                     Lat_buffer = 1, Long_buffer = 1)
Fst_map$`Differentiation Map`

Fst_map2 <- Dif_Stats_Map(dat = Fst, pops = Loc, neighbors = c('East_West', 'East_South', 'South_West'),
                     col = c('#FFFF00','#FFC000','#FFA500','#e31a1c','#800026'),
                     Lat_buffer = 1, Long_buffer = 1)
Fst_map2$`Differentiation Map`

## ----Diversity----------------------------------------------------------------
# Similar to our heat map, we use the statistic argument to label our figures and any output raster you create.
Div_map <- Div_Stats_Map(dat = Het_dat, plot.type = 'point',
statistic = "Heterozygosity", col = c('blue', 'orange', 'red'), Lat_buffer = 1, Long_buffer = 1, prefix = 'Test_het')

Div_map$`Heterozygosity Map`

