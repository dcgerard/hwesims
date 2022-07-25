
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reproduce the Analysis from Gerard (2022)

[![NSF-2132247](https://img.shields.io/badge/NSF-2132247-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=2132247)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5531872.svg)](https://doi.org/10.5281/zenodo.5531872)

This repo contains the scripts and instructions to reproduce the results
of Gerard (2022). This involves simulations and real data analyses using
the data from Shirasawa et al. (2017)
(<https://github.com/dcgerard/KDRIsweetpotatoXushu18S1LG2017>) and
Delomas et al. (2021)
([doi:10.5061/dryad.crjdfn33r](https://www.doi.org/10.5061/dryad.crjdfn33r)).

## Instructions

To run these scripts, you will need to have the latest version of R, GNU
Make, wget, and 7-zip, running on a Linux system.

1.  Install the appropriate R packages

    ``` r
    install.packages(c("devtools",
                       "tidyverse",
                       "ggthemes",
                       "latex2exp",
                       "BiocManager",
                       "future",
                       "ggpmisc",
                       "GGally"))
    BiocManager::install("VariantAnnotation")
    devtools::install_github("dcgerard/hwep")
    devtools::install_github("dcgerard/phwelike")
    devtools::install_github("dcgerard/updog")
    ```

    The `{hwep}` package contains the new methods from Gerard (2022),
    while the `{phwelike}` package contains the code written by Jiang,
    Ren, and Wu (2021) and placed in package form by me.

2.  Run `make` in the terminal.

## Other Files

-   [alpha_tetra.nb](./analysis/alpha_tetra.nb) is a Mathematica
    notebook that solves for the double reduction parameter given the
    gamete genotype frequencies in a tetraploid population at
    equilibrium. The segregation probabilities come from Table 9 of
    Fisher and Mather (1943).
-   [hex_equi.nb](./analysis/hex_equi.nb) is a Mathematica notebook that
    calculates gamete frequencies at equilibrium for hexaploids.
-   [diploid.nb](./analysis/diploid.nb) is a Mathematica notebook that
    explores the U-statistic approach to testing for equilibrium in
    diploids.

## Session Information

    R version 4.2.1 (2022-06-23)
    Platform: x86_64-pc-linux-gnu (64-bit)
    Running under: Ubuntu 20.04.4 LTS

    Matrix products: default
    BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
    LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/liblapack.so.3

    locale:
     [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
     [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
     [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
     [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
     [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

    attached base packages:
    [1] stats4    stats     graphics  grDevices utils     datasets  methods  
    [8] base     

    other attached packages:
     [1] GGally_2.1.2                ggpmisc_0.4.7              
     [3] ggpp_0.4.4                  updog_2.1.3                
     [5] future_1.26.1               VariantAnnotation_1.42.1   
     [7] Rsamtools_2.12.0            Biostrings_2.64.0          
     [9] XVector_0.36.0              SummarizedExperiment_1.26.1
    [11] Biobase_2.56.0              GenomicRanges_1.48.0       
    [13] GenomeInfoDb_1.32.2         IRanges_2.30.0             
    [15] S4Vectors_0.34.0            MatrixGenerics_1.8.1       
    [17] matrixStats_0.62.0          BiocGenerics_0.42.0        
    [19] BiocManager_1.30.18         phwelike_1.0.0             
    [21] hwep_2.0.0                  latex2exp_0.9.4            
    [23] ggthemes_4.2.4              forcats_0.5.1              
    [25] stringr_1.4.0               dplyr_1.0.9                
    [27] purrr_0.3.4                 readr_2.1.2                
    [29] tidyr_1.2.0                 tibble_3.1.7               
    [31] ggplot2_3.3.6               tidyverse_1.3.1            
    [33] devtools_2.4.3              usethis_2.1.6              

    loaded via a namespace (and not attached):
      [1] readxl_1.4.0             backports_1.4.1          BiocFileCache_2.4.0     
      [4] plyr_1.8.7               splines_4.2.1            BiocParallel_1.30.3     
      [7] listenv_0.8.0            rstantools_2.2.0         inline_0.3.19           
     [10] digest_0.6.29            foreach_1.5.2            htmltools_0.5.2         
     [13] fansi_1.0.3              magrittr_2.0.3           memoise_2.0.1           
     [16] BSgenome_1.64.0          tzdb_0.3.0               remotes_2.4.2           
     [19] globals_0.15.1           modelr_0.1.8             RcppParallel_5.1.5      
     [22] doFuture_0.12.2          prettyunits_1.1.1        colorspace_2.0-3        
     [25] blob_1.2.3               rvest_1.0.2              rappdirs_0.3.3          
     [28] haven_2.5.0              xfun_0.31                RcppArmadillo_0.11.2.0.0
     [31] callr_3.7.0              crayon_1.5.1             RCurl_1.98-1.7          
     [34] jsonlite_1.8.0           survival_3.2-13          iterators_1.0.14        
     [37] glue_1.6.2               gtable_0.3.0             zlibbioc_1.42.0         
     [40] MatrixModels_0.5-0       DelayedArray_0.22.0      pkgbuild_1.3.1          
     [43] rstan_2.21.5             SparseM_1.81             scales_1.2.0            
     [46] DBI_1.1.3                rngtools_1.5.2           Rcpp_1.0.9              
     [49] progress_1.2.2           bit_4.0.4                StanHeaders_2.21.0-7    
     [52] httr_1.4.3               RColorBrewer_1.1-3       ellipsis_0.3.2          
     [55] reshape_0.8.9            pkgconfig_2.0.3          loo_2.5.1               
     [58] XML_3.99-0.10            dbplyr_2.2.1             utf8_1.2.2              
     [61] tidyselect_1.1.2         rlang_1.0.3              AnnotationDbi_1.58.0    
     [64] munsell_0.5.0            cellranger_1.1.0         tools_4.2.1             
     [67] cachem_1.0.6             cli_3.3.0                generics_0.1.3          
     [70] RSQLite_2.2.14           broom_1.0.0              evaluate_0.15           
     [73] fastmap_1.1.0            yaml_2.3.5               processx_3.7.0          
     [76] knitr_1.39               bit64_4.0.5              fs_1.5.2                
     [79] KEGGREST_1.36.2          doRNG_1.8.2              quantreg_5.93           
     [82] xml2_1.3.3               biomaRt_2.52.0           compiler_4.2.1          
     [85] rstudioapi_0.13          filelock_1.0.2           curl_4.3.2              
     [88] png_0.1-7                reprex_2.0.1             stringi_1.7.8           
     [91] ps_1.7.1                 GenomicFeatures_1.48.3   lattice_0.20-45         
     [94] Matrix_1.4-1             vctrs_0.4.1              pillar_1.7.0            
     [97] lifecycle_1.0.1          bitops_1.0-7             rtracklayer_1.56.1      
    [100] R6_2.5.1                 BiocIO_1.6.0             gridExtra_2.3           
    [103] parallelly_1.32.0        sessioninfo_1.2.2        codetools_0.2-18        
    [106] MASS_7.3-58              assertthat_0.2.1         pkgload_1.3.0           
    [109] rjson_0.2.21             withr_2.5.0              GenomicAlignments_1.32.0
    [112] GenomeInfoDbData_1.2.8   parallel_4.2.1           hms_1.1.1               
    [115] grid_4.2.1               rmarkdown_2.14           lubridate_1.8.0         
    [118] restfulr_0.0.15         

## Acknowledgments

This material is based upon work supported by the National Science
Foundation under Grant
No. [2132247](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2132247).
The opinions, findings, and conclusions or recommendations expressed are
those of the author and do not necessarily reflect the views of the
National Science Foundation.

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-delomas2021genotyping" class="csl-entry">

Delomas, Thomas A., Stuart C. Willis, Blaine L. Parker, Donella Miller,
Paul Anders, Andrea Schreier, and Shawn Narum. 2021. “Genotyping Single
Nucleotide Polymorphisms and Inferring Ploidy by Amplicon Sequencing for
Polyploid, Ploidy-Variable Organisms.” *Molecular Ecology Resources* 21
(7): 2288–98. <https://doi.org/10.1111/1755-0998.13431>.

</div>

<div id="ref-fisher1943inheritance" class="csl-entry">

Fisher, Ronald A, and K Mather. 1943. “The Inheritance of Style Length
in *Lythrum Salicaria*.” *Annals of Eugenics* 12 (1): 1–23.
<https://doi.org/10.1111/j.1469-1809.1943.tb02307.x>.

</div>

<div id="ref-gerard2022double" class="csl-entry">

Gerard, David. 2022. “Double Reduction Estimation and Equilibrium Tests
in Natural Autopolyploid Populations.” *Biometrics* In press.
<https://doi.org/10.1111/biom.13722>.

</div>

<div id="ref-jiang2021computational" class="csl-entry">

Jiang, Libo, Xiangyu Ren, and Rongling Wu. 2021. “Computational
Characterization of Double Reduction in Autotetraploid Natural
Populations.” *The Plant Journal* 105 (6): 1703–9.
<https://doi.org/10.1111/tpj.15126>.

</div>

<div id="ref-shirasawa2017high" class="csl-entry">

Shirasawa, Kenta, Masaru Tanaka, Yasuhiro Takahata, Daifu Ma, Qinghe
Cao, Qingchang Liu, Hong Zhai, et al. 2017. “A High-Density SNP Genetic
Map Consisting of a Complete Set of Homologous Groups in Autohexaploid
Sweetpotato (*Ipomoea Batatas*).” *Scientific Reports* 7.
<https://doi.org/10.1038/srep44207>.

</div>

</div>
