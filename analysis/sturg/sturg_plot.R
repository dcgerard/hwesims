library(hwep)
library(tidyverse)
library(ggthemes)
library(scales)
library(GGally)

pdf <- read_csv("./output/sturg/pdf.csv")

pdf %>%
  gather(key = "method", value = "pvalue") %>%
  ggplot(aes(x = pvalue)) +
  geom_histogram(bins = 10, color = "black", fill = "white") +
  facet_wrap(.~method) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) ->
  pl

ggsave(filename = "./output/sturg/sturg_hist.pdf",
       plot = pl,
       width = 4,
       height = 4,
       family = "Times")

pdf %>%
  gather(key = "method", value = "pvalue") %>%
  filter(!is.na(pvalue)) %>%
  group_by(method) %>%
  arrange(pvalue) %>%
  mutate(theo = ppoints(n())) %>%
  ungroup() %>%
  mutate(theo_nl10 = -log10(theo),
         pvalue_nl10 = -log10(pvalue)) %>%
  ggplot(aes(x = theo_nl10, y = pvalue_nl10)) +
  geom_point() +
  facet_wrap(.~method) +
  geom_abline(slope = 1, intercept = 0, lty = 2, col = 2) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  xlab("Theoretical Quantiles") +
  ylab("Empirical Quantiles") +
  scale_x_continuous(name = "Theoretical Quantiles", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) +
  scale_y_continuous(name = "Observed p-values", breaks = 0:20, labels = 10^(-(0:20)), minor_breaks = NULL) ->
  pl

ggsave(filename = "./output/sturg/sturg_qq.pdf",
       plot = pl,
       width = 4,
       height = 4,
       family = "Times")

pdf %>%
  transmute(`No DR` = -log10(`No DR`),
            `U-stat` = -log10(`U-stat`),
            Likelihood = -log10(Likelihood),
            Boot = -log10(Boot)) %>%
    mutate(Boot = if_else(is.infinite(Boot), NA_real_, Boot)) ->
  nl10df

my_qq <- function(data, mapping, ...) {
  StatPpoint <- ggproto(
    "StatPpoint",
    Stat,
    compute_group = function(data, scales) {
      data.frame(y = sort(data$x, decreasing = TRUE),
                 x = -log10(ppoints(length(data$x))))
      },
    required_aes = c("x")
    )

  stat_ppoint <- function(mapping = NULL,
                          data = NULL,
                          geom = "point",
                          position = "identity",
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE, ...) {
    layer(
      stat = StatPpoint,
      data = data,
      mapping = mapping,
      geom = geom,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
    }

  ggplot(data = data, mapping = mapping) +
    stat_ppoint() +
    geom_abline(lty = 2, col = 1)
}

my_point <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) +
    geom_point(...) +
    geom_abline(intercept = 0, slope = 1, lty = 2, col = 1)
}

ggpairs(data = nl10df,
        lower = list(continuous = my_point),
        diag = list(continuous = my_qq),
        upper = list(continuous = "blank")) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(angle = 90,
                                   vjust = 0.5,
                                   hjust=1)) +
  scale_x_continuous(name = "Theoretical Quantiles",
                     breaks = 0:20,
                     labels = 10^(-(0:20)),
                     minor_breaks = NULL,
                     limits = c(0, 5.1)) +
  scale_y_continuous(name = "Observed p-values",
                     breaks = 0:20,
                     labels = 10^(-(0:20)),
                     minor_breaks = NULL,
                     limits = c(0, 5.1)) ->
  pl

ggsave(filename = "./output/sturg/pvalue_pairs.pdf",
       plot = pl,
       height = 6,
       width = 6,
       family = "Times")

## Count above/below 0.01
pdf %>%
  select(-`Random Mating`) %>%
  gather(-`No DR`, key = "method", value = "p-value") %>%
  group_by(method) %>%
  summarize(n_no_more = sum(`p-value` > 0.05 & `No DR` < 0.05, na.rm = TRUE),
            n_no_less = sum(`p-value` < 0.05 & `No DR` > 0.05, na.rm = TRUE))





