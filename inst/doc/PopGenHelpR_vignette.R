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

## ----Plot Ancestry, eval=FALSE------------------------------------------------
#  # First, we seperate the list elements into two seperate objects. The q-matrix (Qmat) and the locality information for each individual (Loc).
#  Qmat <- Q_dat[[1]]
#  Loc <- Q_dat[[2]]
#  
#  # Now we will generate both population and individual plots by seeting plot.type to 'all'. If you wanted, you could only generate individual or population plots by setting plot.type to "individual" and "population", respectively.
#  Test_all <- Plot_ancestry(anc.mat = Qmat, pops = Loc, K = 5,
#  plot.type = 'all', col = c('red', 'orange', 'pink', 'purple', 'blue'), countries = c("united states of america", "mexico"), Lat_buffer = 1, Long_buffer = 1)
#  knitr::include_graphics("img/Plot_Ancestry-1.png")
#  knitr::include_graphics("img/Plot_Ancestry-2.png")

## ----Plot Ancestry Maps, eval=FALSE-------------------------------------------
#  Test_all$`Individual Map`
#  knitr::include_graphics("img/Plot_Ancestry_Maps-1.png")
#  Test_all$`Population Map`
#  knitr::include_graphics("img/Plot_Ancestry_Maps-1.png")

## ----Differentiation, eval=FALSE----------------------------------------------
#  # Isolate our fst matrix and locality information
#  Fst <- Fst_dat[[1]]
#  Loc <- Fst_dat[[2]]
#  # Plot the heatmap, the statistic argument is used to label the plot.
#  Fstat_hmap <- Pairwise_heatmap(dat = Fst, statistic = 'FST')
#  # Look at the plot
#  Fstat_hmap
#  knitr::include_graphics("img/Differentiation-1.png")

## ----Differentiation map, eval=FALSE------------------------------------------
#  # Closest Neighbor
#  Fst_map <- Dif_Stats_Map(dat = Fst, pops = Loc, neighbors = 1,
#                       countries = c('united states of america', 'mexico'),
#                       col = c('#fd8d3c','#fc4e2a','#e31a1c','#bd0026','#800026'),
#                       Lat_buffer = 1, Long_buffer = 1)
#  Fst_map$`Differentiation Map`
#  knitr::include_graphics("img/Differentiation_map-1.png")
#  
#  Fst_map2 <- Dif_Stats_Map(dat = Fst, pops = Loc, neighbors = c('East_West', 'East_South', 'South_West'), countries = c('united states of america', 'mexico'),
#                       col = c('#fd8d3c','#fc4e2a','#e31a1c','#bd0026','#800026'),
#                       Lat_buffer = 1, Long_buffer = 1)
#  Fst_map2$`Differentiation Map`
#  knitr::include_graphics("img/Differentiation_map-1.png")

## ----Diversity, eval=FALSE----------------------------------------------------
#  # Similar to our heat map, we use the statistic argument to label our figures and any output raster you create.
#  Div_map <- Div_Stats_Map(dat = Het_dat, plot.type = 'point',
#  statistic = "Heterozygosity", col = c('blue', 'orange', 'red'), countries = c('united states of america', 'mexico'), Lat_buffer = 1, Long_buffer = 1, prefix = 'Test_het')
#  
#  Div_map$`Heterozygosity Map`
#  knitr::include_graphics("img/Diversity-1.png")

