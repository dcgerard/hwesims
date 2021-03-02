######################
## Fit hwep on McAllister and Miller (2016)
######################

library(hwep)
library(future)
nmat <- as.matrix(read.csv("./output/mca/mca_nmat.csv", row.names = 1))

plan(multisession, workers = 6)
hout <- hwefit(nmat = nmat, type = "ustat")
plan("sequential")

plan(multisession, workers = 6)
lout <- hwefit(nmat = nmat, type = "mle")
plan("sequential")

hist(lout$p_hwe)
hist(lout$alpha1)

plot(hout$p_hwe, lout$p_hwe)
abline(0, 1)
