#######################
## Same as sims_plots_qq.R but not on -log10 scale.
#######################

library(tidyverse)
library(ggthemes)
library(latex2exp)
library(hwep)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))

## Show distributional assumptions are met ----
simdf %>%
  filter(niter == Inf) %>%
  select(ploidy, nind, dr_ratio, r = true_r, p_hwe, df_hwe, p_hwe_ll) %>%
  group_by(ploidy, nind, dr_ratio, r) %>%
  ungroup() %>%
  mutate(r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy)) ->
  longdf

nind_unique <- unique(simdf$nind)
dr_unique <- unique(simdf$dr_ratio)
for (i in seq_along(nind_unique)) {
  for (j in seq_along(dr_unique)) {
    longdf %>%
      filter(nind == nind_unique[[i]], dr_ratio == dr_unique[[j]]) %>%
      filter(!is.na(p_hwe)) %>%
      group_by(ploidy, r) %>%
      arrange(p_hwe) %>%
      mutate(ts = as_tibble(ts_bands(n = n()))) %>%
      unnest(cols = "ts") %>%
      ggplot() +
      facet_grid(ploidy ~ r) +
      geom_point(mapping = aes(x = q, y = p_hwe)) +
      geom_ribbon(mapping = aes(x = q, ymin = lower, ymax = upper), fill = "blue", lty = 2, alpha = 1/10) +
      theme_bw() +
      geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
      scale_color_colorblind() +
      scale_x_continuous(name = "Theoretical Quantiles", limits = c(0, 1)) +
      scale_y_continuous(name = "Observed p-values", limits = c(0, 1)) +
      theme(strip.background = element_rect(fill = "white")) ->
      pl

    ggsave(filename = paste0("./output/sims/orig/orig_qq_nind",
                             nind_unique[[i]],
                             "_dr",
                             round(dr_unique[[j]] * 100),
                             ".pdf"),
           plot = pl, height = 5.5, width = 6, family = "Times")

    longdf %>%
      filter(nind == nind_unique[[i]], dr_ratio == dr_unique[[j]]) %>%
      filter(!is.na(p_hwe_ll)) %>%
      group_by(ploidy, r) %>%
      arrange(p_hwe_ll) %>%
      mutate(ts = as_tibble(ts_bands(n = n()))) %>%
      unnest(cols = "ts") %>%
      ggplot() +
      facet_grid(ploidy ~ r) +
      geom_point(mapping = aes(x = q, y = p_hwe_ll)) +
      geom_ribbon(mapping = aes(x = q, ymin = lower, ymax = upper), fill = "blue", lty = 2, alpha = 1/10) +
      theme_bw() +
      geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
      scale_color_colorblind() +
      scale_x_continuous(name = "Theoretical Quantiles", limits = c(0, 1)) +
      scale_y_continuous(name = "Observed p-values", limits = c(0, 1)) +
      theme(strip.background = element_rect(fill = "white")) ->
     pl

    ggsave(filename = paste0("./output/sims/orig/orig_qq_ll_nind",
                             nind_unique[[i]],
                             "_dr",
                             round(dr_unique[[j]] * 100),
                             ".pdf"),
           plot = pl, height = 5.5, width = 6, family = "Times")
  }
}
