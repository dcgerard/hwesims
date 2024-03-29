##################
## Plots for power and type I error control
##################

library(tidyverse)
library(ggthemes)
library(latex2exp)
simdf <- read_csv("./output/sims/simdf.csv",
                  col_types = cols(.default = col_double()))
bdf <- read_csv("./output/boot/boot_sims.csv")

#' Confidence interval from binom.test()
#'
#' @param x A vector of successes.
#' @param n A vector of total counts.
#' @param clev The confidence level.
#'
#' @return A data frame of two columns, \code{lower} and \code{upper}. The
#'    Bounds on the confidence interval.
#'
#' @examples
#' binom_ci(c(1, 2), c(3, 4))
#'
#' @author David Gerard
binom_ci <- function(x, n, clev = 0.95) {
  stopifnot(length(x) == length(n))
  m <- length(x)
  outdf <- data.frame(lower = rep(NA_real_, m), upper = rep(NA_real_, m))
  for (i in seq_len(m)) {
    ci <- c(binom.test(x = x[[i]], n = n[[i]], conf.level = clev)$conf.int)
    outdf$lower[[i]] <- ci[[1]]
    outdf$upper[[i]] <- ci[[2]]
  }
  return(outdf)
}

siglev <- 0.05 # significance level

simdf %>%
  select(ploidy, nind, dr_ratio, r = true_r, niter, `U-stat` = p_hwe, MLE = p_hwe_ll, `No DR` = p_hwe_ndr) %>%
  pivot_longer(cols = c("U-stat", "MLE", "No DR"), names_to = "method", values_to = "pvalue") %>%
  filter(!is.na(pvalue)) %>%
  mutate(reject = pvalue <= siglev) %>%
  group_by(ploidy, nind, dr_ratio, r, niter, method) %>%
  summarise(preject = mean(reject), x = sum(reject), n = n(), .groups = "keep") %>%
  ungroup() %>%
  mutate(niter = factor(niter),
         r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy),
         dr_ratio = factor(dr_ratio)) %>%
  mutate(ci = binom_ci(x = x, n = n, clev = 0.95)) %>%
  mutate(lower = ci$lower, upper = ci$upper) %>%
  select(-ci) ->
  longdf

bdf %>%
  select(ploidy, nind, dr_ratio, r = true_r, niter, pvalue = pval) %>%
  mutate(method = "Boot",
         reject = pvalue < siglev) %>%
  group_by(ploidy, nind, dr_ratio, r, niter, method) %>%
  summarise(preject = mean(reject), x = sum(reject), n = n(), .groups = "keep") %>%
  ungroup() %>%
  mutate(niter = factor(niter),
         r = paste0("r = ", r),
         ploidy = paste0("K = ", ploidy),
         dr_ratio = factor(dr_ratio)) %>%
  mutate(ci = binom_ci(x = x, n = n, clev = 0.95)) %>%
  mutate(lower = ci$lower, upper = ci$upper) %>%
  select(-ci) ->
  longbdf

longdf <- bind_rows(longdf, longbdf)

nind_unique <- unique(longdf$nind)
for (i in seq_along(nind_unique)) {
  longdf %>%
    filter(nind == nind_unique[[i]], method %in% c("U-stat", "MLE", "Boot")) %>%
    ggplot(aes(x = niter,
               y = preject,
               color = dr_ratio,
               lty = method,
               group = interaction(dr_ratio, method))) +
    facet_grid(ploidy ~ r) +
    geom_point() +
    stat_summary(fun = sum, geom = "line") +
    geom_hline(yintercept = siglev, lty = 2, col = 2) +
    theme_bw() +
    theme(strip.background = element_rect(fill = "white")) +
    scale_color_colorblind() +
    ylim(0, 1) +
    ylab("Power") +
    xlab("Number of generations of random mating") +
    labs(color = "Double\nReduction\nRatio",
         lty = "Method") ->
    pl

  ggsave(filename = paste0("./output/sims/power", nind_unique[[i]], ".pdf"),
         plot = pl,
         height = 5,
         width = 6,
         family = "Times")

  longdf %>%
    filter(niter == "Inf", nind == nind_unique[[i]]) %>%
    ggplot(aes(x = dr_ratio, y = preject, color = method, group = method)) +
    facet_grid(ploidy ~ r) +
    geom_point(size = 0) +
    stat_summary(fun = sum, geom = "line") +
    geom_segment(aes(x = dr_ratio, xend = dr_ratio, y = lower, yend = upper)) +
    geom_hline(yintercept = siglev, lty = 2, col = 2) +
    theme_bw() +
    theme(strip.background = element_rect(fill = "white")) +
    scale_color_colorblind() +
    ylab("Type I Error") +
    xlab("Double Reduction Ratio") +
    labs(color = "Method") ->
    pl

  ggsave(filename = paste0("./output/sims/t1e", nind_unique[[i]], ".pdf"),
         plot = pl,
         height = 5,
         width = 6,
         family = "Times")
}
