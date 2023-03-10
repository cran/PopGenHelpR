#' A genetic differentiation matrix and locality information for each population. This data was generated
#' by subsetting data of Farleigh et al., 2021.
#'
#' A symmetric matrix with estimated genetic differentiation (Fst) between 3 populations.
#' @usage data(Fst_dat)
#' @format A list with two elements:
#' \describe{
#' \item{Fst_dat}{Data frame with three rows and three columns}
#' \item{Loc_dat}{Data frame containing the locality information for each population}
#'
#' ...
#' }
#' @examples
#' data(Fst_dat)
#' Fst <- Fst_dat[[1]]
#' Loc <- Fst_dat[[2]]
#' \donttest{
#' Test <- Dif_Stats_Map(dat = Fst, pops = Loc,
#' neighbors = 2, countries = c('united states of america', 'mexico'),
#' col = c('#fd8d3c','#fc4e2a','#e31a1c','#bd0026','#800026'),Lat_buffer = 1, Long_buffer = 1)
#' }
#'
#' Fstat_plot <- Pairwise_heatmap(dat = Fst, statistic = 'FST')
#'
#' @source Farleigh, K., Vladimirova, S. A., Blair, C., Bracken, J. T., Koochekian, N., Schield, D. R., ... & Jezkova, T. (2021). The effects of climate and demographic history in shaping genomic variation across populations of the Desert Horned Lizard (Phrynosoma platyrhinos). Molecular Ecology, 30(18), 4481-4496.
#'
"Fst_dat"
##########################################################################
#' A data frame of hypothetical heterozygosity data produced by Div_Stats.
#'
#' Data frame containing 5 columns and 3 rows
#' @usage data(Het_dat)
#' @format A data frame with 5 columns and 3 rows:
#' \describe{
#' \item{Heterozygosity}{Estimated heterozygosity}
#' \item{Pop}{Population assignment}
#' \item{Standard.Deviation}{standard deviation}
#' \item{Long}{Longitude}
#' \item{Lat}{Latitude}
#'
#' ...
#' }
#' @examples
#'  \donttest{
#' data(Het_dat)
#' Test_het <- Div_Stats_Map(dat = Het_dat, plot.type = 'point',
#' statistic = "Heterozygosity", countries = c('united states of america', 'mexico'),
#' Lat_buffer = 1, Long_buffer = 1, prefix = 'Test_het')
#' }
#'
#' @source Coordinates and population names taken from Farleigh, K., Vladimirova, S. A., Blair, C., Bracken, J. T., Koochekian, N., Schield, D. R., ... & Jezkova, T. (2021). The effects of climate and demographic history in shaping genomic variation across populations of the Desert Horned Lizard (Phrynosoma platyrhinos). Molecular Ecology, 30(18), 4481-4496.
#'
"Het_dat"
##########################################################################
#' A list representing a q-matrix and the locality information associated with the qmatrix
#'
#' List with two elements
#' @usage data(Q_dat)
#' @format A list with two elements:
#' \describe{
#' \item{Qmat}{A q-matrix with 6 columns and 30 rows, the first column lists the sample name and the remaining 5 represent the contribution a genetic cluster to that individuals ancestry}
#' \item{Loc_dat}{The locality information for each individual in the q-matrix}
#'
#' ...
#' }
#' @examples
#' \donttest{
#' data(Q_dat)
#' Qmat <- Q_dat[[1]]
#' Loc <- Q_dat[[2]]
#' Test_all <- Plot_ancestry(anc.mat = Qmat, pops = Loc, K = 5,
#' plot.type = 'all', col = c('red', 'orange', 'pink', 'purple', 'blue'),
#' countries = c("united states of america", "mexico"), Lat_buffer = 1, Long_buffer = 1)
#' }
#'
#' @source Data was generated by package authors.
#'
"Q_dat"

