library(tidyverse)
library(ggthemes)
library(latex2exp)

f1df <- read_csv("./output/f1sims/f1simsout.csv")
hwdf <- read_csv("./output/sims/simdf.csv")

f1df %>%
  select(ploidy, nind, dr_ratio, true_alpha1) %>%
  distinct() ->
  dr_df

hwdf %>%
  filter(true_r == 0.5, niter == Inf) %>%
  select(ploidy, nind, dr_ratio, alpha1, alpha1_ll) %>%
  gather(alpha1, alpha1_ll, key = "type", value = "alpha") %>%
  mutate(type = recode(type, "alpha1" = "HWE\nU-statistic", "alpha1_ll" = "HWE\nLikelihood")) ->
  hwclean

f1df %>%
  select(-alpha2, -true_alpha2, -seed, -true_alpha1)  %>%
  rename(alpha = alpha1) %>%
  mutate(type = "F1 Likelihood") %>%
  bind_rows(hwclean) ->
  df

df %>%
  mutate(nind = factor(nind)) %>%
  ggplot(aes(x = nind, y = alpha, col = type)) +
  facet_grid(ploidy ~ dr_ratio, scales = "free_y") +
  geom_boxplot(outlier.size = 0.2) +
  scale_color_colorblind(name = "Method") +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  geom_hline(data = dr_df, mapping = aes(yintercept = true_alpha1), lty = 2, col = 2) +
  xlab("Sample Size") +
  ylab("Double Reduction Rate") ->
  pl

ggsave(filename = "./output/f1sims/f1_dr_box.pdf", plot = pl, height = 6, width = 6, family = "Times")

## mse
df %>%
  left_join(dr_df) %>%
  group_by(ploidy, nind, dr_ratio, type) %>%
  summarise(mse100 = mean((alpha - true_alpha1)^2)*100) %>%
  ungroup() %>%
  spread(key = type, value = mse100) %>%
  mutate(`HWE\nLikelihood` = `HWE\nLikelihood` / `F1 Likelihood`,
         `HWE\nU-statistic` = `HWE\nU-statistic` / `F1 Likelihood`) %>%
  select(-`F1 Likelihood`) %>%
  gather(`HWE\nLikelihood`, `HWE\nU-statistic`, key = "type", value = "mseratio") %>%
  ggplot(aes(x = nind, y = mseratio, color = type)) +
  facet_grid(ploidy ~ dr_ratio) +
  geom_line() +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  scale_color_colorblind(name = "Method") +
  scale_x_log10(name = "Sample Size", breaks = c(25, 100, 1000)) +
  geom_hline(yintercept = 1, lty = 2, col = 2) +
  ylab("MSE Ratio") ->
  pl

ggsave(filename = "./output/f1sims/f1_mse.pdf", plot = pl, height = 6, width = 6, family = "Times")
