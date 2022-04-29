
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reproduce the Analysis from Gerard (2021)

[![NSF-2132247](https://img.shields.io/badge/NSF-2132247-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=2132247)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5531872.svg)](https://doi.org/10.5281/zenodo.5531872)

This repo contains the scripts and instructions to reproduce the results
of Gerard (2021). This involves simulations and real data analyses using
the data from Shirasawa et al. (2017)
(<http://sweetpotato-garden.kazusa.or.jp/>) and Delomas et al. (2021)
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
                       "ggpmisc"))
    BiocManager::install("VariantAnnotation")
    devtools::install_github("dcgerard/hwep")
    devtools::install_github("dcgerard/phwelike")
    devtools::install_github("dcgerard/updog")
    ```

    The `{hwep}` package contains the new methods from Gerard (2021),
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

    R version 4.2.0 (2022-04-22)
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
     [1] ggpmisc_0.4.6               ggpp_0.4.4                 
     [3] updog_2.1.3                 future_1.25.0              
     [5] VariantAnnotation_1.42.0    Rsamtools_2.12.0           
     [7] Biostrings_2.64.0           XVector_0.36.0             
     [9] SummarizedExperiment_1.26.0 Biobase_2.56.0             
    [11] GenomicRanges_1.48.0        GenomeInfoDb_1.32.0        
    [13] IRanges_2.30.0              S4Vectors_0.34.0           
    [15] MatrixGenerics_1.8.0        matrixStats_0.62.0         
    [17] BiocGenerics_0.42.0         BiocManager_1.30.17        
    [19] phwelike_1.0.0              hwep_0.0.2                 
    [21] latex2exp_0.9.4             ggthemes_4.2.4             
    [23] forcats_0.5.1               stringr_1.4.0              
    [25] dplyr_1.0.9                 purrr_0.3.4                
    [27] readr_2.1.2                 tidyr_1.2.0                
    [29] tibble_3.1.6                ggplot2_3.3.5              
    [31] tidyverse_1.3.1             devtools_2.4.3             
    [33] usethis_2.1.5              

    loaded via a namespace (and not attached):
      [1] readxl_1.4.0             backports_1.4.1          BiocFileCache_2.4.0     
      [4] BiocParallel_1.30.0      listenv_0.8.0            digest_0.6.29           
      [7] foreach_1.5.2            htmltools_0.5.2          fansi_1.0.3             
     [10] magrittr_2.0.3           memoise_2.0.1            BSgenome_1.64.0         
     [13] tzdb_0.3.0               remotes_2.4.2            globals_0.14.0          
     [16] modelr_0.1.8             doFuture_0.12.2          prettyunits_1.1.1       
     [19] colorspace_2.0-3         blob_1.2.3               rvest_1.0.2             
     [22] rappdirs_0.3.3           haven_2.5.0              xfun_0.30               
     [25] RcppArmadillo_0.11.0.0.0 callr_3.7.0              crayon_1.5.1            
     [28] RCurl_1.98-1.6           jsonlite_1.8.0           iterators_1.0.14        
     [31] glue_1.6.2               gtable_0.3.0             zlibbioc_1.42.0         
     [34] MatrixModels_0.5-0       DelayedArray_0.22.0      pkgbuild_1.3.1          
     [37] SparseM_1.81             scales_1.2.0             DBI_1.1.2               
     [40] rngtools_1.5.2           Rcpp_1.0.8.3             progress_1.2.2          
     [43] bit_4.0.4                httr_1.4.2               ellipsis_0.3.2          
     [46] pkgconfig_2.0.3          XML_3.99-0.9             dbplyr_2.1.1            
     [49] utf8_1.2.2               tidyselect_1.1.2         rlang_1.0.2             
     [52] AnnotationDbi_1.58.0     munsell_0.5.0            cellranger_1.1.0        
     [55] tools_4.2.0              cachem_1.0.6             cli_3.3.0               
     [58] generics_0.1.2           RSQLite_2.2.12           broom_0.8.0             
     [61] evaluate_0.15            fastmap_1.1.0            yaml_2.3.5              
     [64] processx_3.5.3           knitr_1.39               bit64_4.0.5             
     [67] fs_1.5.2                 KEGGREST_1.36.0          doRNG_1.8.2             
     [70] quantreg_5.88            xml2_1.3.3               biomaRt_2.52.0          
     [73] brio_1.1.3               compiler_4.2.0           rstudioapi_0.13         
     [76] filelock_1.0.2           curl_4.3.2               png_0.1-7               
     [79] testthat_3.1.4           reprex_2.0.1             stringi_1.7.6           
     [82] ps_1.7.0                 GenomicFeatures_1.48.0   desc_1.4.1              
     [85] lattice_0.20-45          Matrix_1.4-1             vctrs_0.4.1             
     [88] pillar_1.7.0             lifecycle_1.0.1          bitops_1.0-7            
     [91] rtracklayer_1.56.0       R6_2.5.1                 BiocIO_1.6.0            
     [94] parallelly_1.31.1        sessioninfo_1.2.2        codetools_0.2-18        
     [97] assertthat_0.2.1         pkgload_1.2.4            rprojroot_2.0.3         
    [100] rjson_0.2.21             withr_2.5.0              GenomicAlignments_1.32.0
    [103] GenomeInfoDbData_1.2.8   parallel_4.2.0           hms_1.1.1               
    [106] grid_4.2.0               rmarkdown_2.14           lubridate_1.8.0         
    [109] restfulr_0.0.13         

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

<div id="ref-gerard2021double" class="csl-entry">

Gerard, David. 2021. “Double Reduction Estimation and Equilibrium Tests
in Natural Autopolyploid Populations.” *bioRxiv*.
<https://doi.org/10.1101/2021.09.24.461731>.

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
