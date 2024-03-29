# PopGenHelpR 1.2.1
- August 14th, 2023
* `Div_Stats` and `Dif_stats` have been updated to accept a vcf file or vcfR object as input. 
* `Div_Stats` and `Dif_stats` have been updated to accept a csv file or data frame for population assignment. 
* `Plot_ancestry` has been updated to generate structure-like plots using ggplot2 instead of base R and to handle character and numeric values for individual and population names. Note that individual and populations must be of the same type (i.e., both numeric or both characters). 
* The dependency `rnaturalearth` is no longer used. We now use `spData` for mapping data. 
* The vignette has been updated to accommodate the changes noted above. 

# PopGenHelpR 1.1.1 
- July 17th, 2023
* The horned lizard data was added so that examples can be run by users.
* The write argument has been added to `Div_Stats` and `Dif_stats` so that files are not automatically written to the working directory. 

# PopGenHelpR 1.0.1 
- July 17th, 2023
*  PopGenHelpR has been updated to rnaturalearthhires in Suggests field of the DESCRIPTION file and now use it conditonally. 


# PopGenHelpR 1.0.0
*  First development of PopGenHelpR, publication on Github, and submission to the CRAN (02/06/2023)
