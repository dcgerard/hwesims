#######################
## Plot results of sims.R
#######################

library(tidyverse)
library(ggthemes)
library(latex2exp)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))

## Estimate for alpha given HWE ----
simdf  %>%
  filter(niter == Inf) %>%
  select(ploidy,
         nind,
         dr_ratio,
         r = true_r,
         alpha1 = true_alpha.1,
         Gerard = alpha1,
         Jiang = alpha_jiang) %>%
  pivot_longer(cols = c("Gerard", "Jiang"),
               names_to = "method",
               values_to = "alphahat") %>%
  filter(!is.na(alphahat)) %>%
  mutate(r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy)) ->
  dflong

dr_ratio_vec <- unique(dflong$dr_ratio)

for (i in seq_along(dr_ratio_vec)) {

  ## Generate hline dataset
  dflong %>%
    filter(dr_ratio == dr_ratio_vec[[i]]) %>%
    distinct(ploidy, nind, r, alpha1, method) ->
    dfhline

  ## Make plot
  dflong %>%
    filter(dr_ratio == dr_ratio_vec[[i]]) %>%
    mutate(nind = factor(nind)) %>%
    ggplot(aes(x = nind, y = alphahat, color = method)) +
    geom_boxplot(outlier.size = 0.2) +
    facet_grid(ploidy ~ r, scales = "free_y") +
    theme_bw() +
    theme(strip.background = element_rect(fill = "white")) +
    scale_color_colorblind() +
    geom_hline(data = dfhline, aes(yintercept = alpha1), lty = 2, col = 2) +
    xlab("n") +
    ylab(TeX("$\\hat{\\alpha}$")) ->
    pl

    ggsave(filename = paste0("./output/sims/alphahat_dr",
                             dr_ratio_vec[[i]] * 100,
                             ".pdf"),
           plot = pl, height = 6, width = 6, family = "Times")
}


## Show distributional assumptions are met ----
simdf %>%
  filter(niter == Inf) %>%
  select(ploidy, nind, dr_ratio, r = true_r, p_hwe, df_hwe) %>%
  group_by(ploidy, nind, dr_ratio, r) %>%
  arrange(p_hwe) %>%
  mutate(theo = qunif(p = ppoints(n()))) %>% ## theoretical chi-square values
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
    geom_point() +
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
}

## Look at FPR -----
simdf %>%
  filter(niter == Inf) %>%
  select(ploidy, nind, dr_ratio, r = true_r, with_dr = p_hwe, no_dr = p_hwe_ndr) %>%
  pivot_longer(cols = c("with_dr", "no_dr"),
               names_to = "method",
               values_to = "pvalue") %>%
  group_by(ploidy, nind, dr_ratio, r, method) %>%
  arrange(pvalue) %>%
  mutate(fpr = row_number() / n()) %>%
  ungroup() %>%
  filter(r > 0.05) %>%
  mutate(r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy)) ->
  longdf

longdf %>%
  filter(nind == 1000, method == "with_dr") %>%
  mutate(dr_ratio = factor(dr_ratio)) %>%
  filter(pvalue <= 0.05) %>%
  ggplot(aes(x = pvalue, y = fpr, color = dr_ratio)) +
  geom_line() +
  facet_grid(ploidy ~ r) +
  xlab("Significance Level") +
  ylab("False Positive Rate") +
  geom_abline(slope = 1, intercept = 0, lty = 2) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white"))





