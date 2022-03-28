#######################
## Plot results of sims.R
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
      mutate(lower_nl10 = -log10(lower),
             upper_nl10 = -log10(upper),
             theo_nl10 = -log10(q),
             p_hwe_nl10 = -log10(p_hwe)) %>%
      ggplot() +
      facet_grid(ploidy ~ r) +
      geom_point(mapping = aes(x = theo_nl10, y = p_hwe_nl10)) +
      geom_ribbon(mapping = aes(x = theo_nl10, ymin = lower_nl10, ymax = upper_nl10), fill = "blue", lty = 2, alpha = 1/10) +
      theme_bw() +
      geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
      scale_color_colorblind() +
      scale_x_continuous(name = "Theoretical Quantiles", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
      scale_y_continuous(name = "Observed p-values", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
      theme(strip.background = element_rect(fill = "white")) ->
      pl

    ggsave(filename = paste0("./output/sims/qq_nind",
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
      mutate(lower_nl10 = -log10(lower),
             upper_nl10 = -log10(upper),
             theo_nl10 = -log10(q),
             p_hwe_nl10 = -log10(p_hwe_ll)) %>%
      ggplot() +
      facet_grid(ploidy ~ r) +
      geom_point(mapping = aes(x = theo_nl10, y = p_hwe_nl10)) +
      geom_ribbon(mapping = aes(x = theo_nl10, ymin = lower_nl10, ymax = upper_nl10), fill = "blue", lty = 2, alpha = 1/10) +
      theme_bw() +
      geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
      scale_color_colorblind() +
      scale_x_continuous(name = "Theoretical Quantiles", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
      scale_y_continuous(name = "Observed p-values", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
      theme(strip.background = element_rect(fill = "white")) ->
      pl

    ggsave(filename = paste0("./output/sims/qq_ll_nind",
                             nind_unique[[i]],
                             "_dr",
                             round(dr_unique[[j]] * 100),
                             ".pdf"),
           plot = pl, height = 5.5, width = 6, family = "Times")
  }
}
