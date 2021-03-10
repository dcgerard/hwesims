################
## Demonstrate evolution of gametic frequencies in a tetraploid
################
library(hwep)
library(ggplot2)
library(latex2exp)
library(stringr)

#' Derive gametic frequencies given zygote frequencies
#'
#' @param q The zygote frequencies
#' @param alpha The rate of double reduction
#'
#' @author David Gerard
pgam_gzyg <- function(q, alpha) {
  ploidy <- length(q) - 1
  stopifnot(ploidy %% 2 == 0)
  pgamete <- rep(0, ploidy / 2 + 1)
  for (i in 0:ploidy) {
    pgamete <- pgamete + dgamete(x = 0:(ploidy/2),
                                 alpha = alpha,
                                 G = i,
                                 ploidy = ploidy,
                                 log_p = FALSE) * q[[i + 1]]
  }
  return(pgamete)

}

#' update zygote frequencies given gamete frequencies
#'
#' @param p the gamete frequencies
#'
#' @author David Gerard
pzyg_ggam <- function(p) {
  convolve(p, rev(p), type = "open")
}

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
  return(cbind(alpha = alpha,
               r = r))
}

itermax <- 5
simdf <- data.frame(iter = seq_len(itermax))
simdf$p0 <- NA_real_
simdf$p1 <- NA_real_
simdf$p2 <- NA_real_
simdf$alpha <- NA_real_
simdf$r <- NA_real_

alpha <- 1/6
p <- hwep::dgamete(x = 0:2, alpha = 1/6, G = 2, ploidy = 4)
q <- pzyg_ggam(p = p)
for (i in seq_len(itermax)) {
  ar <- get_alpha_r(p0 = p[[1]], p1 = p[[2]], p2 = p[[3]])
  simdf$p0[[i]] <- p[[1]]
  simdf$p1[[i]] <- p[[2]]
  simdf$p2[[i]] <- p[[3]]
  simdf$alpha[[i]] <- ar[[1]]
  simdf$r[[i]] <- ar[[2]]
  p <- pgam_gzyg(q = q, alpha = alpha)
  q <- pzyg_ggam(p = p)
}

simdf$p <- paste0("(",
                  format(simdf$p0, digits = 2),
                  ",",
                  format(simdf$p1, digits = 2),
                  ",",
                  format(simdf$p2, digits = 2),
                  ")")

simdf$p <- str_replace_all(simdf$p, "0\\.", "\\.")

simdf$hjust <- c(-0.15, rep(1.05, 4))
ggplot(simdf, aes(x = iter, y = alpha, label = p, hjust = hjust)) +
  geom_line() +
  geom_point() +
  geom_text(angle = 90) +
  scale_x_continuous(breaks = seq_len(itermax)) +
  theme_bw() +
  geom_hline(yintercept = 1/6, lty = 2, col = 2) +
  ylab(TeX("Inferred $\\alpha$")) +
  xlab("Generation") ->
  pl

ggsave(filename = "./output/tetra/s1_iterate.pdf",
       plot = pl,
       height = 3,
       width = 6,
       family = "Times")
