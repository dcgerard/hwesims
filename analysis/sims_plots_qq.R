#######################
## Plot results of sims.R
#######################

library(tidyverse)
library(ggthemes)
library(latex2exp)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))

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
    geom_line() +
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
# binom_ci <- function(x, n) {
#   outdf <- data.frame(matrix(c(binom.test(x = x, n = n)$conf.int), nrow = 1))
#   names(outdf) <- c("lower", "upper")
#   outdf
# }
#
# simdf %>%
#   filter(niter == Inf) %>%
#   select(ploidy, nind, dr_ratio, r = true_r, with_dr = p_hwe, no_dr = p_hwe_ndr) %>%
#   pivot_longer(cols = c("with_dr", "no_dr"),
#                names_to = "method",
#                values_to = "pvalue") %>%
#   group_by(ploidy, nind, dr_ratio, r, method) %>%
#   arrange(pvalue) %>%
#   mutate(order = row_number(),
#          tot = n(),
#          fpr = order / tot) %>%
#   ungroup() %>%
#   rowwise() %>%
#   filter(pvalue < 0.05) %>%
#   mutate(ci = list(binom_ci(order, tot))) %>%
#   unnest(cols = "ci") %>%
#   mutate(r = paste0("r = ", r),
#          ploidy = paste0("K = ", ploidy)) ->
#   longdf
#
# nind_unique <- unique(longdf$nind)
# method_unique <- unique(longdf$method)
#
# for (i in seq_along(nind_unique)) {
#   for (j in seq_along(method_unique)) {
#     longdf %>%
#       filter(nind == nind_unique[[i]],
#              method == method_unique[[j]]) %>%
#       mutate(dr_ratio = factor(dr_ratio)) %>%
#       filter(pvalue <= 0.05) %>%
#       ggplot(aes(x = pvalue, y = fpr, color = dr_ratio)) +
#       geom_line() +
#       facet_grid(ploidy ~ r) +
#       xlab("Significance Level") +
#       ylab("False Positive Rate") +
#       geom_abline(slope = 1, intercept = 0, lty = 2) +
#       theme_bw() +
#       theme(strip.background = element_rect(fill = "white")) +
#       scale_color_colorblind() +
#       geom_ribbon(aes(ymin = lower, ymax = upper, fill = dr_ratio),
#                   color = NA_real_,
#                   alpha = 1/6) +
#       scale_fill_colorblind() +
#       labs(fill  = "Double\nReduction\nRatio") +
#       labs(color = "Double\nReduction\nRatio") ->
#       pl
#     pl
#
#     ggsave(filename = paste0("./output/sims/qq_05_method_",
#                              method_unique[[j]],
#                              "_ind_",
#                              nind_unique[[i]],
#                              ".pdf"),
#            plot = pl, height = 6, width = 6, family = "Times")
#
#   }
# }



