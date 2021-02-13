
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reproduce the Analysis from Gerard (2021)

## Instructions

1.  Install the appropriate R packages

    ``` r
    install.packages(c("devtools",
                       "tidyverse",
                       "ggthemes",
                       "latex2exp"))
    devtools::install_github("dcgerard/hwep")
    devtools::install_github("dcgerard/phwelike")
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

## Session Information

    R version 4.0.3 (2020-10-10)
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
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    other attached packages:
     [1] phwelike_0.0.0.9000 hwep_0.0.0.9000     latex2exp_0.4.0    
     [4] ggthemes_4.2.4      forcats_0.5.1       stringr_1.4.0      
     [7] dplyr_1.0.4         purrr_0.3.4         readr_1.4.0        
    [10] tidyr_1.1.2         tibble_3.0.6        ggplot2_3.3.3      
    [13] tidyverse_1.3.0     devtools_2.3.2      usethis_2.0.1      

    loaded via a namespace (and not attached):
     [1] httr_1.4.2        pkgload_1.1.0     jsonlite_1.7.2    foreach_1.5.1    
     [5] modelr_0.1.8      assertthat_0.2.1  cellranger_1.1.0  yaml_2.2.1       
     [9] remotes_2.2.0     sessioninfo_1.1.1 globals_0.14.0    pillar_1.4.7     
    [13] backports_1.2.1   glue_1.4.2        digest_0.6.27     rvest_0.3.6      
    [17] colorspace_2.0-0  htmltools_0.5.1.1 pkgconfig_2.0.3   broom_0.7.4      
    [21] listenv_0.8.0     haven_2.3.1       scales_1.1.1      processx_3.4.5   
    [25] generics_0.1.0    ellipsis_0.3.1    cachem_1.0.3      withr_2.4.1      
    [29] cli_2.3.0         magrittr_2.0.1    crayon_1.4.1      readxl_1.3.1     
    [33] memoise_2.0.0     evaluate_0.14     ps_1.5.0          parallelly_1.23.0
    [37] fs_1.5.0          future_1.21.0     xml2_1.3.2        pkgbuild_1.2.0   
    [41] tools_4.0.3       prettyunits_1.1.1 hms_1.0.0         lifecycle_0.2.0  
    [45] munsell_0.5.0     reprex_1.0.0      callr_3.5.1       compiler_4.0.3   
    [49] rlang_0.4.10      grid_4.0.3        iterators_1.0.13  rstudioapi_0.13  
    [53] rmarkdown_2.6     testthat_3.0.1    gtable_0.3.0      codetools_0.2-18 
    [57] DBI_1.1.1         R6_2.5.0          lubridate_1.7.9.2 knitr_1.31       
    [61] doFuture_0.12.0   fastmap_1.1.0     rprojroot_2.0.2   desc_1.2.0       
    [65] stringi_1.5.3     parallel_4.0.3    Rcpp_1.0.6        vctrs_0.3.6      
    [69] dbplyr_2.1.0      tidyselect_1.1.0  xfun_0.21        

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
