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

# flag <- FALSE
# seed <- 113230
# while(!flag) {
#   seed <- seed + 1
#   set.seed(seed)
#   q <- hwefreq(r = 0.8, alpha = 0.15, ploidy = 4, niter = Inf)
#   n <- c(rmultinom(n = 1, size = 200, prob = q))
#
#   if (all(n >= 5)) {
#     uout <- hweustat(nvec = n, thresh = 0)$p_hwe
#     nout <- hwenodr(nvec = n)$p_hwe
#     lout <- hwelike(nvec = n, thresh = 0)
#
#     n2 <- n
#     n2[[1]] <- n2[[1]] - 2
#     nout2 <- hwenodr(nvec = n2)$p_hwe
#
#     if (nout < 0.05 & uout > 0.05 & nout2 > 0.05) {
#       flag <- TRUE
#     }
#   }
#
# }
