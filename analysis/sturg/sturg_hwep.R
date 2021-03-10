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

library(hwep)
library(future)
library(tidyverse)
library(ggthemes)

nmat <- readRDS("./output/sturg/nmat_updog.RDS")

future::plan(multisession, workers = nc)
uout <- hwefit(nmat = nmat, type = "ustat")
future::plan("sequential")

future::plan(multisession, workers = nc)
lout <- hwefit(nmat = nmat, type = "mle")
future::plan("sequential")

future::plan(multisession, workers = nc)
nout <- hwefit(nmat = nmat, type = "nodr")
future::plan("sequential")

future::plan(multisession, workers = nc)
rout <- hwefit(nmat = nmat, type = "rm")
future::plan("sequential")

ks.test(rout$p_rm, y = qunif)
ks.test(uout$p_hwe, y = qunif)
ks.test(lout$p_hwe, y = qunif)
ks.test(nout$p_hwe, y = qunif)

pdf <- tibble(`Random Mating` = rout$p_rm, `U-stat` = uout$p_hwe, `Likelihood` = lout$p_hwe, `No DR` = nout$p_hwe)

pdf %>%
  gather(key = "method", value = "pvalue") %>%
  ggplot(aes(x = pvalue)) +
  geom_histogram(bins = 20, color = "black", fill = "white") +
  facet_wrap(.~method) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) ->
  pl

ggsave(filename = "./output/sturg/sturg_hist.pdf",
       plot = pl,
       width = 4,
       height = 4,
       family = "Times")

pdf %>%
  gather(key = "method", value = "pvalue") %>%
  filter(!is.na(pvalue)) %>%
  group_by(method) %>%
  arrange(pvalue) %>%
  mutate(theo = ppoints(n())) %>%
  ungroup() %>%
  ggplot(aes(x = theo, y = pvalue)) +
  geom_point() +
  facet_wrap(.~method) +
  geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  xlab("Theoretical Quantiles") +
  ylab("Empirical Quantiles") ->
  pl

ggsave(filename = "./output/sturg/sturg_qq.pdf",
       plot = pl,
       width = 4,
       height = 4,
       family = "Times")

# plot(pdf$`No DR`, pdf$`U-stat`)
# abline(0, 1)

## Try to explain the difference in p-values
weirdn <- which(nout$p_hwe < 0.06 & uout$p_hwe > 0.3)
nout$p_hwe[weirdn]
uout$p_hwe[weirdn]

rhat1 <- sum(nmat[weirdn, ][1,] * 0:4) / (sum(nmat[weirdn, ][1,]) * 4)
rhat2 <- sum(nmat[weirdn, ][2,] * 0:4) / (sum(nmat[weirdn, ][2,]) * 4)
th_1 <- hwefreq(alpha = uout$alpha1[weirdn[[1]]], r = rhat1, ploidy = 4) * sum(nmat[weirdn[[1]], ])
th_2 <- hwefreq(alpha = uout$alpha1[weirdn[[2]]], r = rhat2, ploidy = 4) * sum(nmat[weirdn[[2]], ])
en_1 <- dbinom(x = 0:4, size = 4, prob = rhat1) * sum(nmat[weirdn[[1]], ])
en_2 <- dbinom(x = 0:4, size = 4, prob = rhat2) * sum(nmat[weirdn[[2]], ])


cbind(th_1, th_2, en_1, en_2) %>%
  as_tibble() %>%
  mutate(dosage = 0:4) %>%
  gather(-dosage, key = "type_loc", value = "value") %>%
  separate(col = "type_loc", into = c("type", "loc")) %>%
  mutate(loc = recode(loc,
                      "1" = "Atr_60368-72",
                      "2" = "Atr_63101-44"),
         type = recode(type,
                       "th" = "With DR",
                       "en" = "No DR")) ->
  linedf


cbind(t(nmat[weirdn, ])) %>%
  as_tibble() %>%
  mutate(dosage = 0:4) %>%
  gather(-dosage, key = "loc", value = "n") ->
  coldf

ggplot() +
  geom_col(data = coldf, mapping = aes(x = dosage, y = n)) +
  geom_line(data = linedf, mapping = aes(x = dosage, y = value, color = type)) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  facet_wrap(.~loc) +
  xlab("Dosage") +
  ylab("n") +
  labs(color = "Type") +
  scale_color_colorblind() ->
  pl

ggsave(filename = "./output/sturg/sturg_weirdn.pdf",
       plot = pl,
       width = 5,
       height = 2,
       family = "Times")
