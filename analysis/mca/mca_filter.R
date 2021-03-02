##############################
## Filter MCA SNPs
##############################

library(VariantAnnotation)

## Filter function ----
filter_fun <- function(x) {
  if (nrow(x) == 0) {
    return(NULL)
  }

  nsamp <- ncol(x)
  AD <- geno(x)$AD
  NS <- info(x)$NS
  DP <- info(x)$DP
  AF <- info(x)$AF
  l_miss <- NS > nsamp / 2 ## no more than 50% missing data per site
  l_depth <- DP / NS > 10 ## At least average depth of 10
  l_bi <- sapply(AF, length) == 1 ## Biallelic SNPs
  l_aflow <- sapply(AF >= 0.1, function(y) y[[1]])
  l_afhigh <- sapply(AF <= 0.9, function(y) y[[1]])

  return(l_miss & l_depth & l_bi & l_aflow & l_afhigh)
}

## Read in data ----
fl <-"./data/mca/McAllister.Miller.all.mergedRefGuidedSNPs.vcf.gz"
indexTabix(file = fl, format = "vcf")
tbfl <- TabixFile(file = fl, yieldSize = 10000)
filters <- FilterRules(list(filter_fun))

## Filter ----
filterVcf(file = tbfl,
          genome = "na",
          destination = "./data/mca/mca_small.vcf",
          filters = filters,
          verbose = TRUE)
