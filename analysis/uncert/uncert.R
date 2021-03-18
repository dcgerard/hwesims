##############################
## Small simulation study demonstrating bootstrap usage of uncertainty
##############################

library(hwep)
library(updog)
library(tidyr)
library(dplyr)

nind <- 1000
nreps <- 100
ploidy <- 6
true_r <- 0.5
alpha <- drbounds(ploidy = ploidy) / 2

od <- 0.01
bias <- 1
seq <- 0.01
size <- 30
sizevec <- rep(size, length.out = nind)

niter_seq <- c(2, Inf)

simdf <- expand.grid(seed = seq_len(nreps), niter = niter_seq)
simdf$ustat <- NA_real_
simdf$like <- NA_real_
simdf$nodr <- NA_real_
simdf$rm <- NA_real_
simdf$boot <- NA_real_

for (i in seq_len(nrow(simdf))) {
  cat("i = ", i, "\n")
  set.seed(simdf$seed[[i]])
  niter <- simdf$niter[[i]]
  freq <- hwefreq(r = true_r, alpha = alpha, ploidy = ploidy, niter = niter)
  nvec <- c(rmultinom(n = 1, size = nind, prob = freq))
  genovec <- unlist(mapply(FUN = rep, x = 0:ploidy, length.out = nvec))
  stopifnot(length(genovec) == nind)
  refvec <- rflexdog(sizevec = sizevec,
                     geno = genovec,
                     ploidy = ploidy,
                     seq = seq,
                     bias = bias,
                     od = od)
  upout <- flexdog(refvec = refvec,
                  sizevec = sizevec,
                  ploidy = ploidy,
                  model = "norm",
                  bias_init = 1,
                  update_bias = FALSE,
                  update_seq = FALSE,
                  update_od = FALSE,
                  verbose = FALSE)

  ## estimated n and posterior matrix
  ## nest_mode <- as.vector(table(c(upout$geno, 0:ploidy)) - 1)
  nest <- round(colSums(upout$postmat))
  postmat <- upout$postmat

  ## bootstrap method
  bout <- hweboot(n = postmat)

  ## ustat method
  uout <- hweustat(nvec = nest)

  ## likelihood method
  lout <- hwelike(nvec = nest)

  ## no dr method
  nout <- hwenodr(nvec = nest)

  ## random mating method
  rout <- rmlike(nvec = nest)

  simdf$ustat[[i]] <- uout$p_hwe
  simdf$like[[i]] <- lout$p_hwe
  simdf$nodr[[i]] <- nout$p_hwe
  simdf$rm[[i]] <- rout$p_rm
  simdf$boot[[i]] <- bout$p_hwe

  cat(" ustat =", simdf$ustat[[i]], "\n",
      "like  =", simdf$like[[i]], "\n",
      "nodr  =", simdf$nodr[[i]], "\n",
      "rm    =", simdf$rm[[i]], "\n",
      "boot  =", simdf$boot[[i]], "\n\n")
}

write.csv(x = simdf, file = "output/uncert/uncert_sims.csv", row.names = FALSE)

