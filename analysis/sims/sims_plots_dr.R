#############################
## Double Reduction estimates
#############################

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
         `U-stat` = alpha1,
         MLE = alpha1_ll,
         Jiang = alpha_jiang) %>%
  pivot_longer(cols = c("U-stat", "MLE", "Jiang"),
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
