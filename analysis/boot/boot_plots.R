##############################
## Plot results of bootstrap simulations
##############################
library(tidyverse)
library(hwep)

bs <- read_csv("./output/boot/boot_sims.csv")

## qqplots
bs %>%
  filter(niter == Inf) %>%
  group_by(dr_ratio, true_r) %>%
  arrange(pval) %>%
  mutate(ts = as_tibble(ts_bands(n = n()))) %>%
  unnest(cols = "ts") %>%
  ungroup() %>%
  mutate(lower_nl10 = -log10(lower),
         upper_nl10 = -log10(upper),
         theo_nl10 = -log10(q),
         p_hwe_nl10 = -log10(pval)) %>%
  ggplot() +
  facet_grid(dr_ratio ~ true_r) +
  geom_point(mapping = aes(x = theo_nl10, y = p_hwe_nl10)) +
  geom_ribbon(mapping = aes(x = theo_nl10, ymin = lower_nl10, ymax = upper_nl10), fill = "blue", lty = 2, alpha = 1/10) +
  theme_bw() +
  geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
  scale_x_continuous(name = "Theoretical Quantiles", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
  scale_y_continuous(name = "Observed p-values", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
  theme(strip.background = element_rect(fill = "white")) ->
  pl

ggsave(filename = "./output/boot/boot_qq.pdf",
       plot = pl,
       height = 6,
       width = 6,
       family = "Times")
