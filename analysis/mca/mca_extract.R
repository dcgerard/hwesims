#############################
## Extract read-counts from McAllister data
############################

library(VariantAnnotation)
library(stringr)
mca <- readVcf("./data/mca/mca_small.vcf")
anodf <- read.csv("./data/mca/McAllister_Miller_Locality_Ploidy_Info.csv")

#' @param x the output of geno(vcf)$AD
#' @param type Either the ref or alt alleles
get_counts <- function(x, type = c("ref", "alt")) {
  type <- match.arg(type)
  if (length(x) == 0) {
    return(NA_real_)
  }

  stopifnot(length(x) == 2)

  if (type == "ref") {
    return(x[[1]])
  } else {
    return(x[[2]])
  }
}

## Extract ref and alt mats -----
AD <- geno(mca)$AD
refmat <- sapply(AD, get_counts, type = "ref")
dim(refmat) <- dim(AD)
colnames(refmat) <- colnames(AD)
rownames(refmat) <- rownames(AD)

altmat <- sapply(AD, get_counts, type = "alt")
dim(altmat) <- dim(AD)
colnames(altmat) <- colnames(AD)
rownames(altmat) <- rownames(AD)

## Get sizemat and sanity check that same as DP ----
sizemat <- altmat + refmat
DP <- geno(mca)$DP
stopifnot(all(sizemat == DP, na.rm = TRUE))

## Filter out individuals with missing data and only keep hexaploids ----
ind_keep <- colMeans(is.na(sizemat)) < 0.5
hex_ind <- anodf$Individual[anodf$Ploidy.Level == 6]
hex_keep <- sapply(str_split(colnames(refmat), pattern = ":"), function(x) x[[1]]) %in% hex_ind

refmat <- refmat[, ind_keep & hex_keep]
altmat <- altmat[, ind_keep & hex_keep]

## write to file ----
write.csv(x = refmat, file = "./output/mca/mca_refmat.csv")
write.csv(x = sizemat, file = "./output/mca/mca_sizemat.csv")
