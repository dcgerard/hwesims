###################
## Power of random mating
###################

library(tidyverse)
library(ggthemes)
library(latex2exp)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))

siglev <- 0.05 # significance level

simdf %>%
  select(ploidy, nind, dr_ratio, r = true_r, niter, pvalue = p_rm) %>%
  filter(!is.na(pvalue)) %>%
  mutate(reject = pvalue <= siglev) %>%
  group_by(ploidy, nind, dr_ratio, r, niter) %>%
  summarise(preject = mean(reject), x = sum(reject), n = n(), .groups = "keep") %>%
  ungroup() %>%
  mutate(niter = factor(niter),
         r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy),
         dr_ratio = factor(dr_ratio)) ->
  longdf

nind_unique <- unique(longdf$nind)

for (i in seq_along(nind_unique)) {
  longdf %>%
    filter(nind == nind_unique[[i]]) %>%
    ggplot(aes(x = niter, y = preject, color = dr_ratio, group = dr_ratio)) +
    facet_grid(ploidy ~ r) +
    geom_point() +
    stat_summary(fun = sum, geom = "line") +
    geom_hline(yintercept = siglev, lty = 2, col = 2) +
    theme_bw() +
    theme(strip.background = element_rect(fill = "white")) +
    scale_color_colorblind() +
    ylab("Type I Error") +
    xlab("Number of generations of random mating") +
    labs(color = "Double\nReduction\nRatio") ->
    pl

    ggsave(filename = paste0("./output/sims/rm_t1e", nind_unique[[i]], ".pdf"),
         plot = pl,
         height = 5,
         width = 6,
         family = "Times")
}
