# Number of threads to use for multithreaded computing. This must be
# specified in the command-line shell; e.g., to use 8 threads, run
# command
#
#  R CMD BATCH '--args nc=8' sims.R
#
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  nc <- 1
} else {
  eval(parse(text = args[[1]]))
}
cat(nc, "\n")

library(tidyverse)
library(updog)
library(future)

sturg <- read_tsv(file = "./data/sturg/knowPloidySturgeon_for_DG.txt")

sturg %>%
  filter(relDepth == 1, truePloid == "4N") ->
  sturg_oct

sturg %>%
  filter(relDepth == 1, truePloid == "6N") ->
  sturg_do

sturg_oct %>%
  pivot_wider(id_cols = "Locus", names_from = "Ind", values_from = "A") ->
  refdf

sturg_oct %>%
  pivot_wider(id_cols = "Locus", names_from = "Ind", values_from = "B") ->
  altdf

refmat <- as.matrix(refdf[-1])
rownames(refmat) <- refdf$Locus

altmat <- as.matrix(altdf[-1])
rownames(altmat) <- altdf$Locus

sizemat <- refmat + altmat

future::plan(multisession, workers = nc)
uout <- multidog(refmat = refmat, sizemat = sizemat, ploidy = 4)
future::plan("sequential")

genomat <- format_multidog(x = uout, varname = "geno")

get_nvec <- function(x, ploidy) {
  table(c(x, 0:ploidy)) - 1
}

nmat <- t(apply(genomat, 1, get_nvec, ploidy = 4))

####################
## Use their genotyping
####################
sturg_oct %>%
  mutate(dosage = str_count(g, "A")) %>%
  pivot_wider(id_cols = Locus, names_from = Ind, values_from = dosage) %>%
  select(-Locus) %>%
  as.matrix() %>%
  apply(MARGIN = 1, FUN = get_nvec, ploidy = 4) %>%
  t() ->
  nmat2

## Write everything
saveRDS(object = nmat, file = "./output/sturg/nmat_updog.RDS")
saveRDS(object = nmat, file = "./output/sturg/nmat_delo.RDS")
saveRDS(object = uout, file = "./output/sturg/sturg_updog.RDS")
