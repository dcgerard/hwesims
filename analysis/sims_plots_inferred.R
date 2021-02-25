##########################
## Inferred alpha plot
##########################

library(hwep)
library(tidyverse)
library(ggthemes)
library(latex2exp)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))

simdf %>%
  filter(ploidy == 4) %>%
  select(niter, dr_ratio, true_alpha.1, inferred_alpha) %>%
  distinct(dr_ratio, niter, .keep_all = TRUE) %>%
  mutate(niter = factor(niter),
         dr_ratio = factor(dr_ratio)) ->
  smalldf

upper_alpha <- drbounds(4)

smalldf %>%
  ggplot(aes(x = niter, y = inferred_alpha, color = dr_ratio, group = dr_ratio)) +
  geom_point() +
  stat_summary(fun = sum, geom = "line") +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  scale_color_colorblind() +
  geom_hline(yintercept = 0, lty = 2) +
  geom_hline(yintercept = upper_alpha, lty = 2) +
  ylab(TeX("Inferred $\\alpha$")) +
  xlab("Number of generations of random mating") +
  labs(color = "Double\nReduction\nRatio") ->
  pl

ggsave(filename = "./output/sims/inferred_alpha.pdf",
       plot = pl,
       height = 3,
       width = 4,
       family = "Times")
