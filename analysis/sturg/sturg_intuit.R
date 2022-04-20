library(tidyverse)
library(ggthemes)
library(hwep)
library(latex2exp)
library(ggpmisc)

## Look at one locus in particular
nsturg <- readRDS("./output/sturg/nmat_updog.RDS")
sturgdf <- read_csv("./output/sturg/pdf.csv")

## Example count ----------------------------
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

## Biggest differences -----------------------
uout <- hwefit(nmat = nsturg, type = "ustat", thresh = 0)
nout <- hwefit(nmat = nsturg, type = "nodr", thresh = 0)
lout <- hwefit(nmat = nsturg, type = "mle", thresh = 0)

nsturg %>%
  as_tibble(rownames = "locus") %>%
  mutate(rhat = (0 * `0` + 1 * `1` + 2 * `2` + 3 * `3` + 4 * `4`) / (`0` + `1` + `2` + `3` + `4`) / 4) %>%
  .$rhat ->
  rhat

tibble(ustat = uout$p_hwe,
       like = lout$p_hwe,
       naive = nout$p_hwe,
       r = lout$r,
       alpha = uout$alpha1) ->
  pdf

pdf$n <- vector(mode = "list", length = nrow(pdf))
pdf$nfreq <- vector(mode = "list", length = nrow(pdf))
pdf$drfreq <- vector(mode = "list", length = nrow(pdf))
pdf$chisq_naive <- vector(mode = "list", length = nrow(pdf))
pdf$chisq_dr <- vector(mode = "list", length = nrow(pdf))

ploidy <- 4
for (i in seq_len(nrow(pdf))) {
  pdf$n[[i]] <- nsturg[i, ]
  pdf$nfreq[[i]] <- dbinom(x = 0:ploidy, size = ploidy, prob = pdf$r[[i]])
  pdf$drfreq[[i]] <- hwefreq(r = pdf$r[[i]], alpha = pdf$alpha[[i]], ploidy = ploidy, niter = Inf)

  obs <- pdf$n[[i]]

  ex <- sum(obs) * pdf$nfreq[[i]]
  pdf$chisq_naive[[i]] <- (obs - ex)^2 / ex

  ex <- sum(obs) * pdf$drfreq[[i]]
  pdf$chisq_dr[[i]] <- (obs - ex)^2 / ex
}


pdf %>%
  filter(naive < 0.05) %>%
  mutate(diff = ustat - naive) %>%
  arrange(desc(diff)) ->
  pdf_sub



pdf_sub %>%
  slice(1:15) %>%
  mutate(y = map_chr(n, ~paste0("(", paste(., collapse = ", "), ")")),
         y = parse_factor(y)) %>%
  select(ustat, naive, chisq_dr, chisq_naive, y) %>%
  gather(chisq_dr, chisq_naive, key = "Method", value = "chisq") %>%
  mutate(Method = recode(Method,
                         "chisq_dr" = "U-stat",
                         "chisq_naive" = "Naive")) %>%
  unnest_longer(chisq) %>%
  mutate(chisq_id = paste0("k = ", chisq_id),
         ustat = round(ustat, digits = 2),
         naive = round(naive, digits = 2)) %>%
  ggplot(aes(x = y, y = chisq, color = Method)) +
  facet_wrap(.~chisq_id) +
  geom_point(size = 1) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 6),
        strip.background = element_rect(fill = "white")) +
  scale_color_colorblind() +
  ylab(TeX("$\\frac{(y_{k} - \\hat{q}_{k}n)^2}{\\hat{q}_{k}n}$")) ->
  pl

ggsave(filename = "./output/sturg/chisq_stats.pdf",
       plot = pl,
       height = 4,
       width = 6,
       family = "Times")

pdf_sub %>%
  slice(1:15) %>%
  mutate(y = map_chr(n, ~paste0("(", paste(., collapse = ", "), ")")),
         y = parse_factor(y),
         Naive = round(naive, digits = 2),
         `U-stat` = round(ustat, digits = 2)) %>%
  select(y, Naive, `U-stat`) ->
  mytable
ggplot() +
  theme_void() +
  annotate(geom = "table",
           x = 0, y = 0,
           label = list(mytable)) ->
  pltab
ggsave(filename = "./output/sturg/chisq_tab.pdf", plot = pltab, height = 4, width = 4, family = "Times")


i <- 5
pdf_sub$n[[i]]
round(pdf_sub$chisq_naive[[i]], digits = 2)
round(pdf_sub$chisq_dr[[i]], digits = 2)

## Explore general properties
# nind <- 19
# nrep <- 10000
# ploidy <- 4
# q1 <- hwep::hwefreq(r = 0.5, alpha = 0, ploidy = ploidy, niter = Inf)
# q2 <- hwep::hwefreq(r = 0.5, alpha = drbounds(ploidy), ploidy = ploidy, niter = Inf)
#
# rdiv <- function(n, size, prob1, prob2) {
#   stopifnot(length(prob1) == length(prob2))
#   ploidy <- length(prob1) - 1
#   outmat <- matrix(NA_real_, ncol = ploidy + 1, nrow = n)
#   for (i in seq_len(n)) {
#     isone <- sample(c(TRUE, FALSE), size = 1)
#     if (isone) {
#       outmat[i, ] <- c(stats::rmultinom(n = 1, size = size, prob = prob1))
#     } else {
#       outmat[i, ] <- c(stats::rmultinom(n = 1, size = size, prob = prob2))
#     }
#   }
#   return(outmat)
# }
#
# n1 <- t(stats::rmultinom(n = nrep, size = nind, prob = q1))
# n2 <- rdiv(n = nrep, size = nind, prob1 = q1, prob2 = q2)
#
# colnames(n1) <- 0:ploidy
# colnames(n2) <- 0:ploidy
#
# as_tibble(n1) %>%
#   mutate(Distribution = "Binomial") ->
#   n1df
#
# as_tibble(n2) %>%
#   mutate(Distribution = "Mixture") ->
#   n2df
#
# bind_rows(n1df, n2df) %>%
#   gather(-Distribution, key = "Genotype", value = "Count") %>%
#   count(Distribution, Genotype, Count) %>%
#   group_by(Distribution, Genotype) %>%
#   mutate(freq = n / sum(n)) %>%
#   ggplot(aes(x = Count, y = freq, fill = Distribution)) +
#   geom_col(position = "dodge") +
#   facet_wrap(.~Genotype) +
#   theme_bw() +
#   theme(strip.background = element_rect(fill = "white")) +
#   scale_fill_colorblind() +
#   ylab("Pr(Genotype)") +
#   xlab("Genotype")
