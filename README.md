
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reproduce the Analysis from Gerard (2021)

## Instructions

To run these scripts, you will need to have the latest version of R, and
GNU Make, running on a Linux system.

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

    The hwep package contains the new methods from Gerard (2021), while
    the phwelike package contains the code written by Jiang, Ren, and
    Wu (2021) and placed in package form by me.

2.  Run `make` in the terminal.

## Other Files

-   [alpha\_tetra.nb](./analysis/alpha_tetra.nb) is a Mathematica
    notebook that solves for the double reduction parameter given the
    gamete genotype frequencies in a tetraploid population at HWE. This
    file was used to derive Equation (XYZ) in Gerard (2021). The
    segregation probabilities come from Table 9 of Fisher and
    Mather (1943).
-   [diploid.nb](./analysis/diploid.nb) is a Mathematica notebook that
    explores the *U*-statistic approach to testing for equilibrium in
    diploids.
-   [hex\_equi.nb](./analysis/hex_equi.nb) is a Mathematica notebook
    that calculates gamete frequencies at equilibrium for hexaploids.

## Session Information

    R version 4.0.4 (2021-02-15)
    Platform: x86_64-pc-linux-gnu (64-bit)
    Running under: Ubuntu 20.04.2 LTS

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
     [1] updog_2.1.0                 future_1.21.0              
     [3] VariantAnnotation_1.36.0    Rsamtools_2.6.0            
     [5] Biostrings_2.58.0           XVector_0.30.0             
     [7] SummarizedExperiment_1.20.0 Biobase_2.50.0             
     [9] GenomicRanges_1.42.0        GenomeInfoDb_1.26.2        
    [11] IRanges_2.24.1              S4Vectors_0.28.1           
    [13] MatrixGenerics_1.2.1        matrixStats_0.58.0         
    [15] BiocGenerics_0.36.0         BiocManager_1.30.10        
    [17] phwelike_0.0.0.9000         hwep_0.0.0.9000            
    [19] latex2exp_0.4.0             ggthemes_4.2.4             
    [21] forcats_0.5.1               stringr_1.4.0              
    [23] dplyr_1.0.4                 purrr_0.3.4                
    [25] readr_1.4.0                 tidyr_1.1.2                
    [27] tibble_3.0.6                ggplot2_3.3.3              
    [29] tidyverse_1.3.0             devtools_2.3.2             
    [31] usethis_2.0.1              

    loaded via a namespace (and not attached):
     [1] colorspace_2.0-0         ellipsis_0.3.1           rprojroot_2.0.2         
     [4] RcppArmadillo_0.10.2.1.0 fs_1.5.0                 rstudioapi_0.13         
     [7] listenv_0.8.0            remotes_2.2.0            bit64_4.0.5             
    [10] AnnotationDbi_1.52.0     lubridate_1.7.9.2        xml2_1.3.2              
    [13] codetools_0.2-18         cachem_1.0.4             knitr_1.31              
    [16] pkgload_1.1.0            jsonlite_1.7.2           broom_0.7.5             
    [19] dbplyr_2.1.0             compiler_4.0.4           httr_1.4.2              
    [22] backports_1.2.1          assertthat_0.2.1         Matrix_1.3-2            
    [25] fastmap_1.1.0            cli_2.3.0                htmltools_0.5.1.1       
    [28] prettyunits_1.1.1        tools_4.0.4              gtable_0.3.0            
    [31] glue_1.4.2               GenomeInfoDbData_1.2.4   rappdirs_0.3.3          
    [34] doRNG_1.8.2              Rcpp_1.0.6               cellranger_1.1.0        
    [37] vctrs_0.3.6              rtracklayer_1.50.0       iterators_1.0.13        
    [40] xfun_0.21                globals_0.14.0           ps_1.5.0                
    [43] testthat_3.0.2           rvest_0.3.6              lifecycle_1.0.0         
    [46] rngtools_1.5             XML_3.99-0.5             zlibbioc_1.36.0         
    [49] scales_1.1.1             BSgenome_1.58.0          hms_1.0.0               
    [52] curl_4.3                 yaml_2.2.1               memoise_2.0.0           
    [55] biomaRt_2.46.3           RSQLite_2.2.3            stringi_1.5.3           
    [58] desc_1.2.0               foreach_1.5.1            GenomicFeatures_1.42.1  
    [61] pkgbuild_1.2.0           BiocParallel_1.24.1      rlang_0.4.10            
    [64] pkgconfig_2.0.3          bitops_1.0-6             evaluate_0.14           
    [67] lattice_0.20-41          GenomicAlignments_1.26.0 bit_4.0.4               
    [70] processx_3.4.5           tidyselect_1.1.0         parallelly_1.23.0       
    [73] magrittr_2.0.1           R6_2.5.0                 generics_0.1.0          
    [76] DelayedArray_0.16.1      DBI_1.1.1                pillar_1.4.7            
    [79] haven_2.3.1              withr_2.4.1              RCurl_1.98-1.2          
    [82] modelr_0.1.8             crayon_1.4.1             BiocFileCache_1.14.0    
    [85] doFuture_0.12.0          rmarkdown_2.7            progress_1.2.2          
    [88] grid_4.0.4               readxl_1.3.1             blob_1.2.1              
    [91] callr_3.5.1              reprex_1.0.0             digest_0.6.27           
    [94] openssl_1.4.3            munsell_0.5.0            askpass_1.1             
    [97] sessioninfo_1.1.1       

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-fisher1943inheritance" class="csl-entry">

Fisher, Ronald A, and K Mather. 1943. “The Inheritance of Style Length
in Lythrum Salicaria.” *Annals of Eugenics* 12 (1): 1–23.
<https://doi.org/10.1111/j.1469-1809.1943.tb02307.x>.

</div>

<div id="ref-gerard2021double" class="csl-entry">

Gerard, David. 2021. “Double Reduction Estimation and Hardy-Weinberg
Equilibrium Tests in Natural Autopolyploid Populations.” *Unpublished
Manuscript*.

</div>

<div id="ref-jiang2021computational" class="csl-entry">

Jiang, Libo, Xiangyu Ren, and Rongling Wu. 2021. “Computational
Characterization of Double Reduction in Autotetraploid Natural
Populations.” *The Plant Journal* n/a (n/a).
<https://doi.org/10.1111/tpj.15126>.

</div>

</div>
