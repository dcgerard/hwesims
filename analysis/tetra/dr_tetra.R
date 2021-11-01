###################
## Plot double reduction parameter on unit simplex
###################

library(tidyverse)
library(ggthemes)

#' Get double reduction and allele frequency given gamete frequency
#' in tetraploids assuming HWE.
#'
#' @param p0 The gamete probability of 0.
#' @param p1 The gamete probability of 1.
#' @param p2 The gamete probability of 2.
#'
#' @return A matrix. The first column contains the double reduction
#'     parameters, the second column contains the allele frequencies.
#'
#' @author David Gerard
#'
#' @examples
#' p <- runif(3)
#' p <- p / sum(p)
#' get_alpha_r(p[[1]], p[[2]], p[[3]])
get_alpha_r <- function(p0, p1, p2) {
  stopifnot(abs(p0 + p1 + p2 - 1) < 10^-6)
  alpha <- ((p2 - p0)^2 - (1 - 2 * p1)) / ((p2 - p0)^2 - (1 + p1))
  r <- (p1 + 2 * p2) / 2
  alpha[alpha < 0] <- NA_real_
  return(cbind(alpha = alpha,
               r = r,
               denom = (p2 - p0)^2 - (1 + p1),
               num = (p2 - p0)^2 - (1 - 2 * p1)))
}



## Make a grid on the unit simplex ----
simdf <- expand.grid(x = seq(-1, 1, length = 1000), y = seq(0, 1, length = 1000))
simdf$p0 <- (1 - simdf$x - simdf$y) / 2
simdf$p1 <- simdf$y
simdf$p2 <- 1 - simdf$p1 - simdf$p0
simdf <- cbind(simdf, get_alpha_r(p0 = simdf$p0, p1 = simdf$p1, p2 = simdf$p2))
simdf %>%
  filter(p0 >= 0, p0 <= 1, p1 >= 0, p1 <= 1, p2 >= 0, p2 <= 1) ->
  simdf

simdf %>%
  filter(!is.nan(alpha)) %>%
  mutate(alpha = ifelse(alpha < 0 | alpha > 1/6, NA, alpha)) ->
  simdf

## Get alpha = 0
nodr_df <- data.frame(r = seq(0, 1, length = 100))
nodr_df$p0 <- nodr_df$r^2
nodr_df$p1 <- 2 * nodr_df$r * (1 - nodr_df$r)
nodr_df$p2 <- (1 - nodr_df$r)^2
nodr_df$x <- nodr_df$p2 - nodr_df$p0
nodr_df$y <- nodr_df$p1

## Plot isometric simplex
nudge <- 0.1
ggplot() +
  geom_polygon(mapping = aes(x = x, y = y),
               data = data.frame(x = c(-1, 0, 1, -1),
                                 y = c(0, 1, 0, 0)),
               fill = "grey90") +
  geom_contour_filled(data = simdf, mapping = aes(x = x, y = y, z = alpha), bins = 3) +
  theme_void() +
  annotate(geom = "text",
           x = c(-1 - nudge, 0, 1 + nudge),
           y = c(0, 1 + 0.03, 0),
           label = c("(1,0,0)", "(0,1,0)", "(0,0,1)")) +
  annotate(geom = "text",
           x = c(0, 0),
           y = c(0.2, 0.7),
           label = c(expression(alpha>1/6),
                     expression(alpha<0))) +
  geom_line(data = nodr_df, aes(x = x, y = y), lwd = 1, lty = 2) +
  labs(fill = expression(alpha)) ->
  pl

ggsave(filename = "./output/tetra/iso_dr.pdf",
       plot = pl,
       width = 6,
       height = 3.3,
       family = "Times")

## Grey-scale version
ggplot() +
  geom_polygon(mapping = aes(x = x, y = y),
               data = data.frame(x = c(-1, 0, 1, -1),
                                 y = c(0, 1, 0, 0)),
               fill = "white",
               color = "black") +
  geom_contour_filled(data = simdf, mapping = aes(x = x, y = y, z = alpha), bins = 3) +
  theme_void() +
  annotate(geom = "text",
           x = c(-1 - nudge, 0, 1 + nudge),
           y = c(0, 1 + 0.03, 0),
           label = c("(1,0,0)", "(0,1,0)", "(0,0,1)")) +
  annotate(geom = "text",
           x = c(0, 0),
           y = c(0.2, 0.7),
           label = c(expression(alpha>1/6),
                     expression(alpha<0))) +
  geom_line(data = nodr_df, aes(x = x, y = y), lwd = 2, lty = 2) +
  scale_fill_grey(start = 0.25, end = 0.75) +
  labs(fill = expression(alpha)) ->
  pl

ggsave(filename = "./output/tetra/iso_dr_bw.pdf",
       plot = pl,
       width = 6,
       height = 3.3,
       family = "Times")
