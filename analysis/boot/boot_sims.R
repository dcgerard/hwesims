#########################
## Bootstrap simulations
#########################

library(hwep)
library(tidyr)
library(dplyr)

# Number of threads to use for multithreaded computing. This must be
# specified in the command-line shell; e.g., to use 8 threads, run
# command
#
#  R CMD BATCH '--args nc=8' boot_sims.R
#
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  nc <- 1
} else {
  eval(parse(text = args[[1]]))
}
cat(nc, "\n")

paramdf <- expand.grid(ploidy = c(8),
                       nind = c(25),
                       dr_ratio = c(0, 0.5, 1),
                       true_r = c(0.1, 0.5),
                       niter = c(1, 3, Inf))
nreps <- 200

paramdf$bout <- vector(mode = "list", length = nrow(paramdf))
for (i in seq_len(nrow(paramdf))) {
  cat("i =", i, "\n")
  ## Set parameters
  ploidy <- paramdf$ploidy[[i]]
  nind <- paramdf$nind[[i]]
  alpha <- drbounds(ploidy = ploidy) * paramdf$dr_ratio[[i]]
  r <- paramdf$true_r[[i]]

  ## simulate
  freq <- hwep::hwefreq(r = r,
                        alpha = alpha,
                        ploidy = ploidy,
                        niter = paramdf$niter[[i]],
                        more = FALSE)

  nmat <- t(stats::rmultinom(n = nreps, size = nind, prob = freq))

  ## Fit bootstrap
  future::plan(future::multisession, workers = nc)
  hout <- hwep::hwefit(nmat = nmat, type = "boot")
  future::plan(future::sequential)

  paramdf$bout[[i]] <- matrix(hout$p_hwe, ncol = 1)
}

paramdf %>%
  unnest(cols = "bout") %>%
  mutate(pval = bout[, 1]) %>%
  select(-bout) ->
  paramlong

write.csv(x = paramlong,
          file = "./output/boot/boot_sims.csv",
          row.names = FALSE)
