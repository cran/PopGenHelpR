#' \bold{WARNING! This function has been deprecated and is no longer supported. Please use the Ancestry_barchart and Piechart_map functions.}
#' Plot an ancestry matrix and map of ancestry pie charts.
#'
#' @param anc.mat Data frame or character string that supplies the input data. If it is a character string, the file should be a csv. The first column should be the names of each sample/population, followed by the estimated contribution of each cluster to that individual/pop.
#' @param pops Data frame or character string that supplies the input data. If it is a character string, the file should be a csv. The columns should be named Sample, containing the sample IDs; Population indicating the population assignment of the individual, population and sample names must be the same type (i.e., both numeric or both characters); Long, indicating the longitude of the sample; Lat, indicating the latitude of the sample.
#' @param K Numeric.The number of genetic clusters in your data set, please contact the package authors if you need help doing this.
#' @param plot.type Character string. Options are all, individual, and population. All is default and recommended, this will plot a barchart and piechart map for both the individuals and populations.
#' @param col Character vector indicating the colors you wish to use for plotting.
#' @param piesize Numeric. The radius of the pie chart for ancestry mapping.
#' @param Lat_buffer Numeric. A buffer to customize visualization.
#' @param Long_buffer Numeric. A buffer to customize visualization.
#'
#' @return A list containing your plots and the data frames used to generate the plots.
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' \donttest{
#' data(Q_dat)
#' Qmat <- Q_dat[[1]]
#' rownames(Qmat) <- Qmat[,1]
#' Loc <- Q_dat[[2]]
#' Test_all <- Plot_ancestry(anc.mat = Qmat, pops = Loc, K = 5,
#' plot.type = 'all', col <- c('red', 'maroon', 'navy', 'cyan', 'blue'), piesize = 0.35,
#' Lat_buffer = 1, Long_buffer = 1)}
Plot_ancestry <- function(anc.mat, pops, K, plot.type = 'all', col, piesize = 0.35, Lat_buffer, Long_buffer){


  .Deprecated("Plot_ancestry or Ancestry_barchart", msg = "The Plot_ancestry function has been deprecated as of PopGenHelpR v1.3.0 and will dissappear in v2.0.0. Please use the Piechart_map and Ancestry_barchart function(s) if you wish to plot ancestry maps or barcharts.")

  Pop <- coeff <- Sample <- value <- variable <- aes <- Long <- Lat <- alpha <- ID<- NULL
  # Read in ancestry matrix and pop file
  if(missing(anc.mat)){
    stop("Please supply an ancestry matrix file for plotting, if you have questions
         on how to generate an ancestry matrix please email the package author")
  }
  else if(is.data.frame(anc.mat) == TRUE){
    Ind_anc <- anc.mat
  }
  else if(is.character(anc.mat) == TRUE){
    Ind_anc <- utils::read.csv(anc.mat)
  }
  if(is.data.frame(pops) == TRUE){
    Pops <- pops
  }
  else if(is.character(pops) == TRUE){
    Pops <- utils::read.csv(pops)
  }
  if(missing(col)){
    stop("Please supply a vector of colors for plotting")
  }
  else if(length(col) < K){
    stop("Please supply at least as many colors as your K value")
  }
  else{
    col <- col
  }

  # Pull coordinates
  Coords <- Pops[,3:4]

  ################### Get the data for mapping
  # Get map data
  map <- spData::world["continent"]
  states <- spData::us_states["REGION"]
  ### Make a base map for the countries of interest
  base_map <- ggplot2::ggplot() + ggplot2::geom_sf(data = map, fill = "#f4f4f4") +
    ggplot2::geom_sf(data = states, fill = ggplot2::alpha("#f4f4f4", 0))

  ### Get coordinate ranges for our data
  Lat_Min <- min(Coords$Lat) - Lat_buffer
  Lat_Max <- max(Coords$Lat) + Lat_buffer
  Long_Min <- min(Coords$Long) - Long_buffer
  Long_Max <- max(Coords$Long) + Long_buffer

  ######################## Barcharts

  if(plot.type == 'all' & is.numeric(anc.mat[,1]) & is.numeric(pops[,2])){
    # Individual plots
    colnames(Ind_anc) <- c("Sample", paste0(rep("cluster", K), 1:K))
    qmatrix_melt <- reshape2::melt(Ind_anc, id = 'Sample', value = coeff)

    Indplot <- qmatrix_melt %>% ggplot2::ggplot(ggplot2::aes(x= Sample)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_continuous(breaks = 1:nrow(Ind_anc),labels = unique(qmatrix_melt$Sample))


    # Population plots
    Pop_anc <- Ind_anc[,-1]
    Pop_anc$Pop <- Pops$Population
    Pop_anc[,c(ncol(Pop_anc) +1,ncol(Pop_anc) +2)] <- Pops[,3:4]
    Pop_anc <- Pop_anc %>% dplyr::group_by(Pop) %>% dplyr::summarise(dplyr::across(dplyr::everything(), mean, na.rm = TRUE))
    Pop_anc_coeff <- Pop_anc[,c(1:(K+1))]
    qmatrix_melt_pop <- reshape2::melt(Pop_anc_coeff, id = 'Pop', value = coeff)

    Popplot <- qmatrix_melt_pop %>% ggplot2::ggplot(ggplot2::aes(x= Pop)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_continuous(breaks = 1:nrow(Pop_anc),labels = unique(qmatrix_melt_pop$Pop))

    # Map individuals

    # Add coordinates to the individual ancestry data frame
    Ind_anc[,c(ncol(Ind_anc) +1,ncol(Ind_anc) +2)] <- Pops[,3:4]


    Ind_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Ind_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Ind_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Ind_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')

    # Map populations
    Pop_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Pop_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Pop_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Pop_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')
    Output_all <- list(Ind_anc, Pop_anc, Indplot, Popplot, Ind_map, Pop_map)
    names(Output_all) <- c("Individual Plotting Data Frame", "Population Plotting Data Frame", "Individual Ancestry Plot", "Population Ancestry Plot", "Individual Map", "Population Map")
    return(Output_all)
  }
  else if(plot.type == 'all' & is.character(anc.mat[,1]) & is.character(pops[,2])) {
    # Individual plots
    colnames(Ind_anc) <- c("Sample", paste0(rep("cluster", K), 1:K))
    Ind_anc2 <- Ind_anc
    ord <- Ind_anc2[,1]
    Ind_anc2$ID <- Ind_anc2[,1]
    Ind_anc2$ID <- factor(Ind_anc2$ID, levels = ord)
    qmatrix_melt <- reshape2::melt(Ind_anc2[2:(K+2)], id = 'ID', value = coeff)

    Indplot <- qmatrix_melt %>% ggplot2::ggplot(ggplot2::aes(x= ID)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_discrete(labels = ord) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))


    # Population plots
    Pop_anc <- Ind_anc[,-1]
    Pop_anc$Pop <- Pops$Population
    Pop_anc[,c(ncol(Pop_anc) +1,ncol(Pop_anc) +2)] <- Pops[,3:4]
    Pop_anc <- Pop_anc %>% dplyr::group_by(Pop) %>% dplyr::summarise(dplyr::across(dplyr::everything(), mean, na.rm = TRUE)) %>%
      dplyr::ungroup()
    Pop_anc_coeff <- Pop_anc[,c(1:(K+1))]
    ord_pop <- Pop_anc_coeff$Pop
    Pop_anc_coeff$ID <- ord_pop
    Pop_anc_coeff$ID <- factor(Pop_anc_coeff$ID, levels = ord_pop)
    qmatrix_melt_pop <- reshape2::melt(Pop_anc_coeff[2:(K+2)], id = 'ID', value = coeff)

    Popplot <- qmatrix_melt_pop %>% ggplot2::ggplot(ggplot2::aes(x= ID)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_discrete(labels = ord_pop) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))

    # Map individuals

    # Add coordinates to the individual ancestry data frame
    Ind_anc[,c(ncol(Ind_anc) +1,ncol(Ind_anc) +2)] <- Pops[,3:4]


    Ind_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Ind_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Ind_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Ind_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')

    # Map populations
    Pop_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Pop_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Pop_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Pop_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')
    Output_all <- list(Ind_anc2, Pop_anc, Indplot, Popplot, Ind_map, Pop_map)
    names(Output_all) <- c("Individual Plotting Data Frame", "Population Plotting Data Frame", "Individual Ancestry Plot", "Population Ancestry Plot", "Individual Map", "Population Map")
    return(Output_all)
  }
  else if(plot.type == 'individual' & is.numeric(anc.mat[,1])){
    colnames(Ind_anc) <- c("Sample", paste0(rep("cluster", K), 1:K))
    qmatrix_melt <- reshape2::melt(Ind_anc, id = 'Sample', value = coeff)

    Indplot <- qmatrix_melt %>% ggplot2::ggplot(ggplot2::aes(x= Sample)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_continuous(breaks = 1:nrow(Ind_anc),labels = unique(qmatrix_melt$Sample))

    # Add coordinates to the individual ancestry data frame
    Ind_anc[,c(ncol(Ind_anc) +1,ncol(Ind_anc) +2)] <- Pops[,3:4]

    Ind_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Ind_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Ind_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Ind_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')
    Output_indanc <- list(Indplot, Ind_map, Ind_anc)
    names(Output_indanc) <- c("Individual Ancestry Matrix", "Individual Piechart Map", "Individual Plotting Data Frame")
    return(Output_indanc)
  }

  else if(plot.type == 'individual' & is.character(anc.mat[,1])){
    # Individual plots
    colnames(Ind_anc) <- c("Sample", paste0(rep("cluster", K), 1:K))
    Ind_anc2 <- Ind_anc
    ord <- Ind_anc2[,1]
    Ind_anc2$ID <- Ind_anc2[,1]
    Ind_anc2$ID <- factor(Ind_anc2$ID, levels = ord)
    qmatrix_melt <- reshape2::melt(Ind_anc2[2:(K+2)], id = 'ID', value = coeff)

    Indplot <- qmatrix_melt %>% ggplot2::ggplot(ggplot2::aes(x= ID)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_discrete(labels = ord) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))

    # Add coordinates to the individual ancestry data frame
    Ind_anc[,c(ncol(Ind_anc) +1,ncol(Ind_anc) +2)] <- Pops[,3:4]

    Ind_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Ind_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Ind_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Ind_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')
    Output_indanc <- list(Indplot, Ind_map, Ind_anc2)
    names(Output_indanc) <- c("Individual Ancestry Matrix", "Individual Piechart Map", "Individual Plotting Data Frame")
    return(Output_indanc)
  }

  else if(plot.type == 'population' & is.numeric(pops[,2])){
    # Population plots
    Pop_anc <- Ind_anc[,-1]
    Pop_anc$Pop <- Pops$Population
    Pop_anc[,c(ncol(Pop_anc) +1,ncol(Pop_anc) +2)] <- Pops[,3:4]
    Pop_anc <- Pop_anc %>% dplyr::group_by(Pop) %>% dplyr::summarise(dplyr::across(dplyr::everything(), mean, na.rm = TRUE))
    Pop_anc_coeff <- Pop_anc[,c(1:(K+1))]
    qmatrix_melt_pop <- reshape2::melt(Pop_anc_coeff, id = 'Pop', value = coeff)

    Popplot <- qmatrix_melt_pop %>% ggplot2::ggplot(ggplot2::aes(x= Pop)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_continuous(breaks = 1:nrow(Pop_anc),labels = unique(qmatrix_melt_pop$Pop))

    Pop_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Pop_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Pop_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Pop_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')

    Output_popanc <- list(Popplot, Pop_map, Pop_anc)
    names(Output_popanc) <- c("Population Ancestry Matrix", "Population Piechart Map", "Population Plotting Data Frame")
    return(Output_popanc)
  }
  else if(plot.type == 'population' & is.character(pops[,2])){
    # Population plots
    Pop_anc <- Ind_anc[,-1]
    Pop_anc$Pop <- Pops$Population
    Pop_anc[,c(ncol(Pop_anc) +1,ncol(Pop_anc) +2)] <- Pops[,3:4]
    Pop_anc <- Pop_anc %>% dplyr::group_by(Pop) %>% dplyr::summarise(dplyr::across(dplyr::everything(), mean, na.rm = TRUE)) %>%
      dplyr::ungroup()
    Pop_anc_coeff <- Pop_anc[,c(1:(K+1))]
    ord_pop <- Pop_anc_coeff$Pop
    Pop_anc_coeff$ID <- ord_pop
    Pop_anc_coeff$ID <- factor(Pop_anc_coeff$ID, levels = ord_pop)
    qmatrix_melt_pop <- reshape2::melt(Pop_anc_coeff[2:(K+2)], id = 'ID', value = coeff)

    Popplot <- qmatrix_melt_pop %>% ggplot2::ggplot(ggplot2::aes(x= ID)) +
      ggplot2::geom_bar(ggplot2::aes(y = value, fill = variable), stat = "identity", position = "fill",width = 1) +
      ggplot2::scale_fill_manual("Population", values = col[c(1:K)], labels = paste0(rep("Cluster ", K), 1:K)) +
      ggplot2::scale_color_manual(values = col[c(1:K)], guide = "none") +
      ggplot2::theme_minimal() +
      ggplot2::labs(y = "Ancestry Proportion", x = "") +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
                     panel.grid = ggplot2::element_blank()) +
      ggplot2::scale_y_continuous(limits = c(0,1), expand = c(0,0)) +
      ggplot2::scale_x_discrete(labels = ord_pop) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))

    Pop_map <- base_map + ggplot2::coord_sf(xlim = c(Long_Min, Long_Max),  ylim = c(Lat_Min, Lat_Max)) +
      scatterpie::geom_scatterpie(data = Pop_anc, ggplot2::aes(Long, Lat, r = piesize), cols = c(colnames(Pop_anc[2:(K+1)]))) +
      ggplot2::scale_fill_manual(breaks = c(colnames(Pop_anc[2:(K+1)])),
                                 labels = c(paste('Cluster', 1:K, sep = ' ')),
                                 values = c(col[1], col[2], col[3], col[4], col[5], col[6], col[7], col[8], col[9], col[10])) +
      ggplot2::theme(panel.grid=ggplot2::element_blank(), legend.position = "none") + ggplot2::xlab('Longitude') + ggplot2::ylab('Latitude')

    Output_popanc <- list(Popplot, Pop_map, Pop_anc)
    names(Output_popanc) <- c("Population Ancestry Matrix", "Population Piechart Map", "Population Plotting Data Frame")
    return(Output_popanc)
  }

  else {
    stop("Please supply input for plot.type. The options are 'all', 'individual', or 'population'.")

  }

}
