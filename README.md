
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reproduce the Analysis from Gerard (2021)

[![NSF-2132247](https://img.shields.io/badge/NSF-2132247-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=2132247)

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
                       "future"))
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

-   [alpha\_tetra.nb](./analysis/alpha_tetra.nb) is a Mathematica
    notebook that solves for the double reduction parameter given the
    gamete genotype frequencies in a tetraploid population at
    equilibrium. The segregation probabilities come from Table 9 of
    Fisher and Mather (1943).
-   [hex\_equi.nb](./analysis/hex_equi.nb) is a Mathematica notebook
    that calculates gamete frequencies at equilibrium for hexaploids.
-   [diploid.nb](./analysis/diploid.nb) is a Mathematica notebook that
    explores the *U*-statistic approach to testing for equilibrium in
    diploids.

## Session Information

    R version 4.1.1 (2021-08-10)
    Platform: x86_64-pc-linux-gnu (64-bit)
    Running under: Ubuntu 20.04.3 LTS

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
    [1] stats4    parallel  stats     graphics  grDevices utils     datasets 
    [8] methods   base     

    other attached packages:
     [1] updog_2.1.1                 future_1.22.1              
     [3] VariantAnnotation_1.38.0    Rsamtools_2.8.0            
     [5] Biostrings_2.60.2           XVector_0.32.0             
     [7] SummarizedExperiment_1.22.0 Biobase_2.52.0             
     [9] GenomicRanges_1.44.0        GenomeInfoDb_1.28.4        
    [11] IRanges_2.26.0              S4Vectors_0.30.0           
    [13] MatrixGenerics_1.4.3        matrixStats_0.61.0         
    [15] BiocGenerics_0.38.0         BiocManager_1.30.16        
    [17] phwelike_1.0.0              hwep_0.0.1                 
    [19] latex2exp_0.5.0             ggthemes_4.2.4             
    [21] forcats_0.5.1               stringr_1.4.0              
    [23] dplyr_1.0.7                 purrr_0.3.4                
    [25] readr_2.0.1                 tidyr_1.1.3                
    [27] tibble_3.1.4                ggplot2_3.3.5              
    [29] tidyverse_1.3.1             devtools_2.4.2             
    [31] usethis_2.0.1              

    loaded via a namespace (and not attached):
      [1] readxl_1.3.1             backports_1.2.1          BiocFileCache_2.0.0     
      [4] BiocParallel_1.26.2      listenv_0.8.0            digest_0.6.28           
      [7] foreach_1.5.1            htmltools_0.5.2          fansi_0.5.0             
     [10] magrittr_2.0.1           memoise_2.0.0            BSgenome_1.60.0         
     [13] tzdb_0.1.2               remotes_2.4.0            globals_0.14.0          
     [16] modelr_0.1.8             doFuture_0.12.0          prettyunits_1.1.1       
     [19] colorspace_2.0-2         blob_1.2.2               rvest_1.0.1             
     [22] rappdirs_0.3.3           haven_2.4.3              xfun_0.26               
     [25] RcppArmadillo_0.10.6.0.0 callr_3.7.0              crayon_1.4.1            
     [28] RCurl_1.98-1.5           jsonlite_1.7.2           iterators_1.0.13        
     [31] glue_1.4.2               gtable_0.3.0             zlibbioc_1.38.0         
     [34] DelayedArray_0.18.0      pkgbuild_1.2.0           scales_1.1.1            
     [37] DBI_1.1.1                rngtools_1.5.2           Rcpp_1.0.7              
     [40] progress_1.2.2           bit_4.0.4                httr_1.4.2              
     [43] ellipsis_0.3.2           pkgconfig_2.0.3          XML_3.99-0.8            
     [46] dbplyr_2.1.1             utf8_1.2.2               tidyselect_1.1.1        
     [49] rlang_0.4.11             AnnotationDbi_1.54.1     munsell_0.5.0           
     [52] cellranger_1.1.0         tools_4.1.1              cachem_1.0.6            
     [55] cli_3.0.1                generics_0.1.0           RSQLite_2.2.8           
     [58] broom_0.7.9              evaluate_0.14            fastmap_1.1.0           
     [61] yaml_2.2.1               processx_3.5.2           knitr_1.34              
     [64] bit64_4.0.5              fs_1.5.0                 KEGGREST_1.32.0         
     [67] doRNG_1.8.2              xml2_1.3.2               biomaRt_2.48.3          
     [70] compiler_4.1.1           rstudioapi_0.13          filelock_1.0.2          
     [73] curl_4.3.2               png_0.1-7                testthat_3.0.4          
     [76] reprex_2.0.1             stringi_1.7.4            ps_1.6.0                
     [79] GenomicFeatures_1.44.2   desc_1.3.0               lattice_0.20-44         
     [82] Matrix_1.3-4             vctrs_0.3.8              pillar_1.6.2            
     [85] lifecycle_1.0.1          bitops_1.0-7             rtracklayer_1.52.1      
     [88] R6_2.5.1                 BiocIO_1.2.0             parallelly_1.28.1       
     [91] sessioninfo_1.1.1        codetools_0.2-18         assertthat_0.2.1        
     [94] pkgload_1.2.2            rprojroot_2.0.2          rjson_0.2.20            
     [97] withr_2.4.2              GenomicAlignments_1.28.0 GenomeInfoDbData_1.2.6  
    [100] hms_1.1.0                grid_4.1.1               rmarkdown_2.11          
    [103] lubridate_1.7.10         restfulr_0.0.13         

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
in Natural Autopolyploid Populations.” *Unpublished Manuscript*.

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
