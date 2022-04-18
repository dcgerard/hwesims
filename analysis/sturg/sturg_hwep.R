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

library(hwep)
library(future)
library(tidyverse)
library(ggthemes)

nmat <- readRDS("./output/sturg/nmat_updog.RDS")

future::plan(multisession, workers = nc)
uout <- hwefit(nmat = nmat, type = "ustat")
future::plan("sequential")

future::plan(multisession, workers = nc)
lout <- hwefit(nmat = nmat, type = "mle", thresh = 1)
future::plan("sequential")

future::plan(multisession, workers = nc)
nout <- hwefit(nmat = nmat, type = "nodr")
future::plan("sequential")

future::plan(multisession, workers = nc)
rout <- hwefit(nmat = nmat, type = "rm")
future::plan("sequential")

future::plan(multisession, workers = nc)
bout <- hwefit(nmat = nmat, type = "boot", nboot = 10000)
future::plan("sequential")

ks.test(bout$p_hwe, y = qunif)
ks.test(rout$p_rm, y = qunif)
ks.test(uout$p_hwe, y = qunif)
ks.test(lout$p_hwe, y = qunif)
ks.test(nout$p_hwe, y = qunif)

pdf <- tibble(`Random Mating` = rout$p_rm,
              `U-stat` = uout$p_hwe,
              `Likelihood` = lout$p_hwe,
              `No DR` = nout$p_hwe,
              Boot = bout$p_hwe)

write_csv(x = pdf, file = "./output/sturg/pdf.csv")
