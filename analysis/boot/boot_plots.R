##############################
## Plot results of bootstrap simulations
##############################
library(tidyverse)

bs <- read_csv("./output/boot/boot_sims.csv")

## qqplots
bs %>%
  filter(niter == Inf) %>%
  group_by(dr_ratio, true_r) %>%
  arrange(pval) %>%
  mutate(theo = ppoints(n())) %>%
  ungroup() %>%
  mutate(true_r = paste0("r = ", true_r),
         dr_ratio = paste0("DR Ratio = ", dr_ratio)) %>%
  ggplot(aes(x = theo, y = pval)) +
  geom_point() +
  facet_grid(dr_ratio ~ true_r) +
  geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  xlab("Theoretical Quantiles") +
  ylab("Empirical Quantiles") ->
  pl

ggsave(filename = "./output/boot/boot_qq.pdf",
       plot = pl,
       height = 6,
       width = 6,
       family = "Times")
