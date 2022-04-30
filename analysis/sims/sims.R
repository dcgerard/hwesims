library(hwep)
library(phwelike)
library(tidyr)

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

## Set up simulation parameters ----
paramdf <- expand.grid(ploidy = c(4, 6, 8),
                       nind = c(25, 100, 1000),
                       dr_ratio = c(0, 0.5, 1),
                       true_r = c(0.1, 0.25, 0.5),
                       niter = c(1, 2, 3, Inf))
maxploidy <- max(paramdf$ploidy)
maxibdr <- floor(maxploidy / 4)
nreps <- 1000 ## number of replications

## Filter out settings that are impossible for diploids ----
paramdf <- paramdf[!(paramdf$ploidy == 2 & paramdf$dr_ratio > 0), ]

## Add parameters to fill in ----
paramdf$seed <- rev(seq_len(nrow(paramdf)))
paramdf$simout <- vector(mode = "list", length = nrow(paramdf))
paramdf$true_alpha <- vector(mode = "list", length = nrow(paramdf))
paramdf$inferred_alpha <- NA_real_ ## only applicable to tetraploids
paramdf$q <- vector(mode = "list", length = nrow(paramdf))
paramdf$p <- vector(mode = "list", length = nrow(paramdf))

## Run simulations ----
for (i in seq_len(nrow(paramdf))) {
  cat(i, "\n")
  set.seed(paramdf$seed[[i]])
  ploidy <- paramdf$ploidy[[i]]
  ibdr <- floor(ploidy / 4)
  nind <- paramdf$nind[[i]]

  ## Assume ploidy > 2
  alpha <- hwep::drbounds(ploidy = ploidy) * paramdf$dr_ratio[[i]]
  paramdf$true_alpha[[i]] <- matrix(c(alpha, rep(NA_real_, times = maxibdr - ibdr)), nrow = 1)
  colnames(paramdf$true_alpha[[i]]) <- paste0("true_alpha", 1:maxibdr)

  r <- paramdf$true_r[[i]]
  niter <- paramdf$niter[[i]]

  freq <- hwep::hwefreq(r = r,
                        alpha = alpha,
                        ploidy = ploidy,
                        niter = niter,
                        more = TRUE)

  paramdf$p[[i]] <- matrix(c(freq$p, rep(NA_real_, times = maxploidy / 2 - ploidy / 2)), nrow = 1)
  colnames(paramdf$p[[i]]) <- paste0("p", 0:(maxploidy / 2))
  paramdf$q[[i]] <- matrix(c(freq$q, rep(NA_real_, times = maxploidy - ploidy)), nrow = 1)
  colnames(paramdf$q[[i]]) <- paste0("q", 0:maxploidy)

  if (ploidy == 4) {
    paramdf$inferred_alpha[[i]] <- hwep:::a_from_gam(p = freq$p)[["a"]]
  }

  ## Simulate counts ----
  nmat <- t(stats::rmultinom(n = nreps, size = nind, prob = freq$q))

  ## Fit hwep ----
  thresh_l <- max(paramdf$nind[[i]] * 0.01, 5)
  future::plan(future::multisession, workers = nc)
  hout <- hwep::hwefit(nmat = nmat, type = "ustat", thresh = thresh_l)
  future::plan(future::sequential)

  if(is.null(hout$alpha1)) {
    hout$alpha1 <- NA_real_
  }
  if (is.null(hout$alpha2)) {
    hout$alpha2 <- NA_real_
  }

  hkeep <- hout[, c("alpha1",
                    "alpha2",
                    "chisq_hwe",
                    "df_hwe",
                    "p_hwe")]

  ## No double reduction ----
  ndr_out <- hwefit(nmat = nmat,
                    type = "nodr")
  colnames(ndr_out) <- paste0(colnames(ndr_out), "_ndr")

  hkeep <- cbind(hkeep, ndr_out)

  ## Fit random mating ----
  future::plan(future::multisession, workers = nc)
  rmout <- hwefit(nmat = nmat, type = "rm")
  future::plan(future::sequential)

  rmkeep <- rmout[, c("chisq_rm",
                      "df_rm",
                      "p_rm")]

  hkeep <- cbind(hkeep, rmkeep)

  ## Fit likelihood approach ----
  thresh_l <- 5
  future::plan(future::multisession, workers = nc)
  lout <- hwefit(nmat = nmat, type = "mle", thresh = thresh_l)
  future::plan(future::sequential)
  lkeep <- lout[, c("alpha1",
                    "chisq_hwe",
                    "df_hwe",
                    "p_hwe")]
  names(lkeep) <- paste0(names(lkeep), "_ll")
  hkeep <- cbind(hkeep, lkeep)

  ## Fit Jiang et al (2021) ----
  if (ploidy == 4) {
    future::plan(future::multisession, workers = nc)
    jout <- phwelike::main_multi(nmat = nmat)
    future::plan(future::sequential)

    colnames(jout) <- paste0(colnames(jout), "_jiang")
    hkeep <- cbind(hkeep, jout)
  }

  paramdf$simout[[i]] <- hkeep
}

simdf <- tidyr::unnest(paramdf, cols = c(simout, true_alpha, p, q))

write.csv(x = simdf, file = "./output/sims/simdf.csv", row.names = FALSE)
