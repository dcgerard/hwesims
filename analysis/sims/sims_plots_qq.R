#######################
## Plot results of sims.R
#######################

library(tidyverse)
library(ggthemes)
library(latex2exp)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))

## Show distributional assumptions are met ----
simdf %>%
  filter(niter == Inf) %>%
  select(ploidy, nind, dr_ratio, r = true_r, p_hwe, df_hwe, p_hwe_ll) %>%
  group_by(ploidy, nind, dr_ratio, r) %>%
  mutate(theo = rank(p_hwe, na.last = "keep") / sum(!is.na(p_hwe)),
         theo_ll = rank(p_hwe_ll, na.last = "keep") / sum(!is.na(p_hwe_ll))) %>%
  ungroup() %>%
  mutate(r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy)) ->
  longdf

nind_unique <- unique(simdf$nind)
for (i in seq_along(nind_unique)) {
  longdf %>%
    filter(nind == nind_unique[[i]]) %>%
    mutate(dr_ratio = factor(dr_ratio)) %>%
    ggplot(aes(x = theo, y = p_hwe, color = dr_ratio)) +
    facet_grid(ploidy ~ r) +
    geom_line() +
    theme_bw() +
    geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
    scale_color_colorblind() +
    theme(strip.background = element_rect(fill = "white")) +
    xlab("Theoretical Quantiles") +
    ylab("Empirical Quantiles") +
    labs(color = "Double\nReduction\nRatio") ->
    pl

  ggsave(filename = paste0("./output/sims/qq_nind",
                           nind_unique[[i]],
                           ".pdf"),
         plot = pl, height = 5.5, width = 6, family = "Times")

  longdf %>%
    filter(nind == nind_unique[[i]]) %>%
    mutate(dr_ratio = factor(dr_ratio)) %>%
    ggplot(aes(x = theo_ll, y = p_hwe_ll, color = dr_ratio)) +
    facet_grid(ploidy ~ r) +
    geom_line() +
    theme_bw() +
    geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
    scale_color_colorblind() +
    theme(strip.background = element_rect(fill = "white")) +
    xlab("Theoretical Quantiles") +
    ylab("Empirical Quantiles") +
    labs(color = "Double\nReduction\nRatio") ->
    pl

  ggsave(filename = paste0("./output/sims/qq_ll_nind",
                           nind_unique[[i]],
                           ".pdf"),
         plot = pl, height = 5.5, width = 6, family = "Times")
}
