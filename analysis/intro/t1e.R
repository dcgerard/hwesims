library(hwep)
library(phwelike)
library(future)
library(tibble)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  nc <- 1
} else {
  eval(parse(text = args[[1]]))
}
cat(nc, "\n")

## Set up parameters
nind <- 1000
itermax <- 10000
sout <- expand.grid(ploidy = c(4, 6, 8),
                    alpha = seq(0, 1, length.out = 20),
                    af = c(0.1, 0.5))
sout$p_naive <- vector(mode = "list", length = nrow(sout))
sout$p_u <- vector(mode = "list", length = nrow(sout))
sout$p_like <- vector(mode = "list", length = nrow(sout))
sout <- as_tibble(sout)

for (rind in seq_len(nrow(sout))) {
  alpha <- sout$alpha[[rind]] * drbounds(ploidy = sout$ploidy[[rind]])
  gprob <- hwefreq(r = sout$af[[rind]],
                   alpha = alpha,
                   ploidy = sout$ploidy[[rind]],
                   niter = Inf)
  nmat <- t(stats::rmultinom(n = itermax, size = nind, prob = gprob))

  future::plan(future::multisession, workers = nc)
  sout$p_u[[rind]] <- hwefit(nmat = nmat, type = "ustat")$p_hwe
  future::plan("sequential")

  future::plan(future::multisession, workers = nc)
  sout$p_like[[rind]] <- hwefit(nmat = nmat, type = "mle")$p_hwe
  future::plan("sequential")

  future::plan(future::multisession, workers = nc)
  sout$p_naive[[rind]] <- hwefit(nmat = nmat, type = "nodr")$p_hwe
  future::plan("sequential")
}

saveRDS(object = sout, file = "./output/intro/null_sims.RDS")
