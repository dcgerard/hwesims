library(tidyverse)
library(hwep)
library(latex2exp)

sdf <- readRDS(file = "output/intro/null_sims.RDS")

level <- 0.05

sdf %>%
  gather(p_naive, p_u, p_like, key = "method", value = "p-value") %>%
  unnest_longer(col = "p-value") %>%
  group_by(ploidy, alpha, af, method) %>%
  summarize(t1e = mean(`p-value` < level, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(alpha_val = case_when(ploidy == 4 ~ drbounds(4) * alpha,
                               ploidy == 6 ~ drbounds(6) * alpha,
                               ploidy == 8 ~ drbounds(8)[[1]] * alpha)) %>%
  mutate(method = recode(method,
                         "p_like" = "Likelihood",
                         "p_u" = "U-statistic",
                         "p_naive" = "Naive"),
         method = parse_factor(method, levels = c("Naive", "U-statistic", "Likelihood"))) %>%
  ggplot(aes(x = alpha_val, y = t1e, color = method)) +
  facet_grid(af ~ ploidy, scales = "free_x") +
  geom_point(size = 0.5) +
  geom_line() +
  theme_bw() +
  xlab(TeX("Double Reduction Rate, $\\alpha_1$")) +
  ylab("Type I Error") +
  scale_color_manual(values = c("#ED193A", "#004FA2", "#808080"), name = "Method") +
  geom_hline(yintercept = level, lty = 2, color = "#E08229") +
  ylim(0, 1) +
  theme(strip.background = element_rect(fill = "white")) ->
  pl

ggsave(filename = "./output/intro/t1e.pdf", plot = pl, width = 6, height = 4, family = "Times")
ggsave(filename = "./output/intro/t1e.png", plot = pl, width = 6, height = 4)
