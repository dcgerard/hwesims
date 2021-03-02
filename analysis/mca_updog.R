######################
## Run updog on McAllister and Miller (2016) read-counts
######################

# Number of threads to use for multithreaded computing. This must be
# specified in the command-line shell; e.g., to use 8 threads, run
# command
#
#  R CMD BATCH '--args nc=8' mca_updog.R
#
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  nc <- 1
} else {
  eval(parse(text = args[[1]]))
}
cat(nc, "\n")


library(updog)
library(future)
refmat <- as.matrix(read.csv(file = "./output/mca/mca_refmat.csv", row.names = 1))
sizemat <- as.matrix(read.csv(file = "./output/mca/mca_sizemat.csv", row.names = 1))

plan(multisession, workers = nc)
mout <- multidog(refmat = refmat, sizemat = sizemat, ploidy = 6, nc = NA)
plan("sequential")

saveRDS(object = mout, file = "./output/mca/mca_updog.RDS")
