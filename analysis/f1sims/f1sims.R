#################
## Code to run simulations evaluating F1 population ability to estimate
## Double reduction rate.
#################

library(hwep)
library(future)
library(foreach)
library(doFuture)
library(rngtools)
library(doRNG)

# Number of threads to use for multithreaded computing. This must be
# specified in the command-line shell; e.g., to use 8 threads, run
# command
#
#  R CMD BATCH '--args nc=8' f1sims.R
#
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  nc <- 1
} else {
  eval(parse(text = args[[1]]))
}
cat(nc, "\n")

## Set up simulation parameters ----
nreps <- 1
paramdf <- expand.grid(ploidy = c(4, 6, 8),
                       nind = c(25, 100, 1000),
                       dr_ratio = c(0, 0.5, 1),
                       seed = seq_len(nreps))

registerDoFuture()
registerDoRNG()
plan("multisession", workers = nc)

sout <- foreach(i = seq_len(nrow(paramdf)),
                .combine = rbind) %dopar% {
  set.seed(paramdf$seed[[i]])
  ploidy <- paramdf$ploidy[[i]]
  ibdr <- floor(ploidy / 4)
  nind <- paramdf$nind[[i]]

  ## Assume ploidy > 2
  alpha <- hwep::drbounds(ploidy = ploidy) * paramdf$dr_ratio[[i]]

  freq <- zygdist(alpha = alpha, G1 = 2, G2 = 2, ploidy = ploidy)

  ## Simulate counts ----
  nvec <- c(stats::rmultinom(n = 1, size = nind, prob = freq))

  ## Estimate dr
  fout <- f1dr(nvec = nvec, G1 = 2, G2 = 2)

  df <- data.frame(true_alpha1 = alpha[[1]],
                   true_alpha2 = NA_real_,
                   alpha1 = fout$alpha[[1]],
                   alpha2 = NA_real_)
  if (ibdr == 2) {
    df$true_alpha2 <- alpha[[2]]
    df$alpha2 <- fout$alpha[[2]]
  }
  df
}

plan("sequential")
paramdf <- cbind(paramdf, sout)

write.csv(x = paramdf, file = "./output/f1sims/f1simsout.csv", row.names = FALSE)
