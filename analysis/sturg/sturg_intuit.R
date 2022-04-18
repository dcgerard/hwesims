library(tidyverse)
library(ggthemes)
library(hwep)

## Look at one locus in particular
nsturg <- readRDS("./output/sturg/nmat_updog.RDS")
sturgdf <- read_csv("./output/sturg/pdf.csv")
which_i <- which(sturgdf$`No DR` < 0.05 & sturgdf$`U-stat` > 0.2)
nsturg[which_i[[3]], ]
nweird <- c(1, 0, 3, 4, 11)
nweird
uout <- hweustat(nvec = nweird, thresh = 0)
nout <- hwenodr(nvec = nweird)
rhat <- sum(nweird * 0:4) / sum(nweird) / 4
q_binom <- stats::dbinom(x = 0:4, size = 4, prob = rhat)
q_binom
q_dr <- hwep::hwefreq(r = rhat, alpha = uout$alpha, ploidy = 4, niter = Inf)
q_dr
chh <- (q_binom * sum(nweird) - nweird)^2 / (q_binom * sum(nweird))
chh
chu <- (q_dr * sum(nweird) - nweird)^2 / (q_dr * sum(nweird))
chu

hwenodr(nvec = c(0, 0, 3, 4, 11))

## Explore general properties
nind <- 19
nrep <- 10000
ploidy <- 4
q1 <- hwep::hwefreq(r = 0.5, alpha = 0, ploidy = ploidy, niter = Inf)
q2 <- hwep::hwefreq(r = 0.5, alpha = drbounds(ploidy), ploidy = ploidy, niter = Inf)

rdiv <- function(n, size, prob1, prob2) {
  stopifnot(length(prob1) == length(prob2))
  ploidy <- length(prob1) - 1
  outmat <- matrix(NA_real_, ncol = ploidy + 1, nrow = n)
  for (i in seq_len(n)) {
    isone <- sample(c(TRUE, FALSE), size = 1)
    if (isone) {
      outmat[i, ] <- c(stats::rmultinom(n = 1, size = size, prob = prob1))
    } else {
      outmat[i, ] <- c(stats::rmultinom(n = 1, size = size, prob = prob2))
    }
  }
  return(outmat)
}

n1 <- t(stats::rmultinom(n = nrep, size = nind, prob = q1))
n2 <- rdiv(n = nrep, size = nind, prob1 = q1, prob2 = q2)

colnames(n1) <- 0:ploidy
colnames(n2) <- 0:ploidy

as_tibble(n1) %>%
  mutate(Distribution = "Binomial") ->
  n1df

as_tibble(n2) %>%
  mutate(Distribution = "Mixture") ->
  n2df

bind_rows(n1df, n2df) %>%
  gather(-Distribution, key = "Genotype", value = "Count") %>%
  count(Distribution, Genotype, Count) %>%
  group_by(Distribution, Genotype) %>%
  mutate(freq = n / sum(n)) %>%
  ggplot(aes(x = Count, y = freq, fill = Distribution)) +
  geom_col(position = "dodge") +
  facet_wrap(.~Genotype) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  scale_fill_colorblind() +
  ylab("Pr(Genotype)") +
  xlab("Genotype")
