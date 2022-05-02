library(hwep)

n <- c(5, 10, 37, 76, 72)
uout <- hweustat(nvec = n, thresh = 0)$p_hwe
uout
nout <- hwenodr(nvec = n)$p_hwe
nout
lout <- hwelike(nvec = n, thresh = 0)

qdr <- hwefreq(r = lout$r, alpha = lout$alpha, ploidy = 4, niter = Inf)
qnaive <- dbinom(x = 0:4, size = 4, prob = lout$r)

ntot <- sum(n)

(n - ntot * qnaive)^2 / (ntot * qnaive)
(n - ntot * qdr)^2 / (ntot * qdr)

n[[1]] <- n[[1]] - 2
hwenodr(nvec = n)$p_hwe
