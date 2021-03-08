######################
## Fit hwep on Shirasawa data
######################

# Number of threads to use for multithreaded computing. This must be
# specified in the command-line shell; e.g., to use 8 threads, run
# command
#
#  R CMD BATCH '--args nc=8' shir_hwep.R
#
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  nc <- 1
} else {
  eval(parse(text = args[[1]]))
}
cat(nc, "\n")

library(hwep)
library(updog)
library(future)
library(tidyverse)
nmat <- as.matrix(read.csv("./output/shir/shir_nmat.csv", row.names = 1))

plan(multisession, workers = nc)
hout <- hwefit(nmat = nmat, type = "ustat", thresh = 0)
plan("sequential")

plan(multisession, workers = nc)
lout <- hwefit(nmat = nmat, type = "mle", thresh = 0)
plan("sequential")

plan(multisession, workers = nc)
dout <- hwefit(nmat = nmat, type = "nodr")
plan("sequential")

plan(multisession, workers = nc)
rout <- hwefit(nmat = round(nmat), type = "rm")
plan("sequential")

tibble(MLE = lout$p_hwe, `U-stat` = hout$p_hwe, `No DR` = dout$p_hwe) %>%
  gather(key = "Method", value = "P-value") %>%
  ggplot(aes(x = Method, y = `P-value`)) +
  geom_boxplot(outlier.size = 0.1) +
  theme_bw() ->
  pl

ggsave(filename = "./output/shir/shir_pbox.pdf",
       plot = pl,
       height = 2,
       width = 3,
       family = "Times")

## Compare random mating genotype estimates to hypergeometric ----

rout$locus <- rownames(nmat)
mout <- readRDS("./output/shir/shir_updog.RDS")
snpdf <- mout$snpdf


gamdf <- data.frame(
  rbind(
  stats::dhyper(x = 0:3, m = 1, n = 6 - 1, k = 3),
  stats::dhyper(x = 0:3, m = 2, n = 6 - 2, k = 3),
  stats::dhyper(x = 0:3, m = 3, n = 6 - 3, k = 3),
  stats::dhyper(x = 0:3, m = 4, n = 6 - 4, k = 3),
  stats::dhyper(x = 0:3, m = 5, n = 6 - 5, k = 3)
  )
)
names(gamdf) <- c("hg_0", "hg_1", "hg_2", "hg_3")
gamdf$pgeno <- 1:5

snpdf %>%
  select(snp, pgeno) %>%
  left_join(gamdf, by = "pgeno") %>%
  filter(snp %in% rownames(nmat)) %>%
  left_join(rout, by = c("snp" = "locus")) %>%
  select(-chisq_rm, -df_rm, -p_rm) %>%
  gather(starts_with("hg_"), starts_with("p."), key = "method_dosage", value = "prop") %>%
  separate(col = "method_dosage", into = c("method", "dosage")) %>%
  spread(key = method, value = prop) %>%
  mutate(dosage = paste0("dosage = ", dosage)) ->
  rmdf

ggplot(rmdf, aes(x = hg, y = p)) +
  facet_wrap(. ~ dosage) +
  geom_point() +
  theme_bw() +
  geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
  xlab("Hypergeometric Gamete Probability") +
  ylab("Estimated Gamete Probability") +
  theme(strip.background = element_rect(fill = "white")) ->
  pl

ggsave(filename = "./output/shir/shir_gamprob.pdf",
       plot = pl,
       height = 4,
       width = 4,
       family = "Times")

ggplot(rout, aes(x = p_rm)) +
  geom_histogram(bins = 30, color = "black", fill = "white") +
  theme_bw() +
  xlab("P-value") ->
  pl

ggsave(filename = "./output/shir/shir_rmhist.pdf",
       plot = pl,
       height = 2,
       width = 3,
       family = "Times")
