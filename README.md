
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reproduce the Analysis from Gerard (2023)

[![NSF-2132247](https://img.shields.io/badge/NSF-2132247-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=2132247)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5531872.svg)](https://doi.org/10.5281/zenodo.5531872)

This repo contains the scripts and instructions to reproduce the results
of Gerard (2023). This involves simulations and real data analyses using
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

    The `{hwep}` package contains the new methods from Gerard (2023),
    while the `{phwelike}` package contains the code written by Jiang,
    Ren, and Wu (2021) and placed in package form by me.

2.  Run `make` in the terminal.

## Other Files

- [alpha_tetra.nb](./analysis/alpha_tetra.nb) is a Mathematica notebook
  that solves for the double reduction parameter given the gamete
  genotype frequencies in a tetraploid population at equilibrium. The
  segregation probabilities come from Table 9 of Fisher and Mather
  (1943).
- [hex_equi.nb](./analysis/hex_equi.nb) is a Mathematica notebook that
  calculates gamete frequencies at equilibrium for hexaploids.
- [diploid.nb](./analysis/diploid.nb) is a Mathematica notebook that
  explores the U-statistic approach to testing for equilibrium in
  diploids.

## Session Information

    R version 4.3.0 (2023-04-21)
    Platform: x86_64-pc-linux-gnu (64-bit)
    Running under: Ubuntu 22.04.3 LTS

    Matrix products: default
    BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0

    locale:
     [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
     [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
     [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
     [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
     [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

    time zone: America/New_York
    tzcode source: system (glibc)

    attached base packages:
    [1] stats4    stats     graphics  grDevices utils     datasets  methods  
    [8] base     

    other attached packages:
     [1] GGally_2.1.2                ggpmisc_0.5.4-1            
     [3] ggpp_0.5.4                  updog_2.1.3                
     [5] future_1.33.0               VariantAnnotation_1.46.0   
     [7] Rsamtools_2.16.0            Biostrings_2.68.1          
     [9] XVector_0.40.0              SummarizedExperiment_1.30.2
    [11] Biobase_2.60.0              GenomicRanges_1.52.0       
    [13] GenomeInfoDb_1.36.2         IRanges_2.34.1             
    [15] S4Vectors_0.38.1            MatrixGenerics_1.12.3      
    [17] matrixStats_1.0.0           BiocGenerics_0.46.0        
    [19] BiocManager_1.30.22         phwelike_1.0.0             
    [21] hwep_2.0.2                  latex2exp_0.9.6            
    [23] ggthemes_4.2.4              lubridate_1.9.2            
    [25] forcats_1.0.0               stringr_1.5.0              
    [27] dplyr_1.1.3                 purrr_1.0.2                
    [29] readr_2.1.4                 tidyr_1.3.0                
    [31] tibble_3.2.1                ggplot2_3.4.3              
    [33] tidyverse_2.0.0             devtools_2.4.5             
    [35] usethis_2.2.2              

    loaded via a namespace (and not attached):
      [1] splines_4.3.0            later_1.3.1              BiocIO_1.10.0           
      [4] bitops_1.0-7             filelock_1.0.2           XML_3.99-0.14           
      [7] lifecycle_1.0.3          StanHeaders_2.26.27      globals_0.16.2          
     [10] processx_3.8.2           lattice_0.21-8           MASS_7.3-59             
     [13] magrittr_2.0.3           rmarkdown_2.24           yaml_2.3.7              
     [16] remotes_2.4.2.1          httpuv_1.6.11            doRNG_1.8.6             
     [19] sessioninfo_1.2.2        pkgbuild_1.4.2           DBI_1.1.3               
     [22] RColorBrewer_1.1-3       abind_1.4-5              pkgload_1.3.2.1         
     [25] zlibbioc_1.46.0          RCurl_1.98-1.12          rappdirs_0.3.3          
     [28] GenomeInfoDbData_1.2.10  inline_0.3.19            listenv_0.9.0           
     [31] MatrixModels_0.5-2       parallelly_1.36.0        codetools_0.2-19        
     [34] DelayedArray_0.26.7      xml2_1.3.5               tidyselect_1.2.0        
     [37] doFuture_1.0.0           BiocFileCache_2.8.0      GenomicAlignments_1.36.0
     [40] ellipsis_0.3.2           survival_3.5-5           iterators_1.0.14        
     [43] foreach_1.5.2            tools_4.3.0              progress_1.2.2          
     [46] Rcpp_1.0.11              glue_1.6.2               gridExtra_2.3           
     [49] xfun_0.40                loo_2.6.0                withr_2.5.0             
     [52] fastmap_1.1.1            fansi_1.0.4              SparseM_1.81            
     [55] callr_3.7.3              digest_0.6.33            timechange_0.2.0        
     [58] R6_2.5.1                 mime_0.12                colorspace_2.1-0        
     [61] biomaRt_2.56.1           RSQLite_2.3.1            utf8_1.2.3              
     [64] generics_0.1.3           rtracklayer_1.60.1       prettyunits_1.1.1       
     [67] httr_1.4.7               htmlwidgets_1.6.2        S4Arrays_1.0.6          
     [70] pkgconfig_2.0.3          gtable_0.3.4             blob_1.2.4              
     [73] htmltools_0.5.6          profvis_0.3.8            scales_1.2.1            
     [76] png_0.1-8                knitr_1.43               rstudioapi_0.15.0       
     [79] tzdb_0.4.0               rjson_0.2.21             curl_5.0.2              
     [82] cachem_1.0.8             parallel_4.3.0           miniUI_0.1.1.1          
     [85] AnnotationDbi_1.62.2     restfulr_0.0.15          reshape_0.8.9           
     [88] pillar_1.9.0             grid_4.3.0               vctrs_0.6.3             
     [91] urlchecker_1.0.1         promises_1.2.1           dbplyr_2.3.3            
     [94] xtable_1.8-4             evaluate_0.21            GenomicFeatures_1.52.2  
     [97] cli_3.6.1                compiler_4.3.0           rlang_1.1.1             
    [100] crayon_1.5.2             rngtools_1.5.2           rstantools_2.3.1.1      
    [103] future.apply_1.11.0      RcppArmadillo_0.12.6.3.0 ps_1.7.5                
    [106] plyr_1.8.8               fs_1.6.3                 stringi_1.7.12          
    [109] rstan_2.21.8             BiocParallel_1.34.2      assertthat_0.2.1        
    [112] munsell_0.5.0            quantreg_5.97            Matrix_1.6-1            
    [115] BSgenome_1.68.0          hms_1.1.3                bit64_4.0.5             
    [118] KEGGREST_1.40.0          shiny_1.7.5              memoise_2.0.1           
    [121] RcppParallel_5.1.7       bit_4.0.5                polynom_1.4-1           

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

<div id="ref-gerard2023double" class="csl-entry">

Gerard, David. 2023. “Double Reduction Estimation and Equilibrium Tests
in Natural Autopolyploid Populations.” *Biometrics* 79 (3): 2143–56.
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
