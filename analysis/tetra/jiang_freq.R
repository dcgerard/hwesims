###################
## Generate table of different allele frequencies by Jiang et al (2020) -----
###################

library(phwelike)
library(hwep)
library(tidyverse)

#' Function taken from Jiang et al's github page
#' https://github.com/LiboJiang/DoubleReduction
#'
#' @param alpha The double reduction parameter
#' @param r The allele frequency
jiangfreq <- function(alpha, r) {
    p <- r
    pAA <- p^2
    pAa <- 2 * p * (1 - p)
    paa <- (1 - p)^2
    a <- alpha
    QAA <- pAA^2 + (3/4 * a + 1/2 * (1 - a)) * (2 * pAA * pAa) +
        (1/2 * a + 1/6 * (1 - a)) * (2 * pAA * paa + pAa^2) +
        1/4 * a * (2 * pAa * paa)
    QAa <- 1/2 * (1 - a) * (2 * pAA * pAa) + 2/3 * (1 - a) *
        (2 * pAA * paa + pAa^2) + 1/2 * (1 - a) * (2 * pAa *
        paa)
    Qaa <- 1/4 * a * (2 * pAA * pAa) + (1/2 * a + 1/6 * (1 -
        a)) * (2 * pAA * paa + pAa^2) + (3/4 * a + 1/2 * (1 -
        a)) * (2 * pAa * paa) + paa^2
    QAAAA <- QAA^2
    QAAAa <- 2 * QAA * QAa
    QAAaa <- 2 * QAA * Qaa + QAa^2
    QAaaa <- 2 * QAa * Qaa
    Qaaaa <- Qaa^2
    pf <- (c(QAAAA, QAAAa, QAAaa, QAaaa, Qaaaa))
    return(rev(pf))
}

rseq <- seq(0, 1, length = 100)
alphaseq <- seq(0, drbounds(ploidy = 4), length = 3)
pardf <- expand.grid(r = rseq, alpha = alphaseq)
pardf$theo <- vector(mode = "list", length = nrow(pardf))
pardf$jiang <- vector(mode = "list", length = nrow(pardf))
for (i in seq_len(nrow(pardf))) {
  pardf$theo[[i]] <- matrix(hwefreq(alpha = pardf$alpha[[i]], r = pardf$r[[i]], ploidy = 4), nrow = 1)
  colnames(pardf$theo[[i]]) <- paste0("th_", 0:4)
  pardf$theo[[i]] <- as.data.frame(pardf$theo[[i]])
  pardf$jiang[[i]] <- matrix(jiangfreq(alpha = pardf$alpha[[i]], r = pardf$r[[i]]), nrow = 1)
  colnames(pardf$jiang[[i]]) <- paste0("ji_", 0:4)
  pardf$jiang[[i]] <- as.data.frame(pardf$jiang[[i]])
}

widedf <- unnest(data = pardf, cols = c("theo", "jiang"))

widedf %>%
  mutate(alpha = as.character(round(alpha, digits = 3)),
         alpha = recode(alpha,
                        "0" = "alpha==0",
                        "0.083" = "alpha==1/12",
                        "0.167" = "alpha==1/6")) %>%
  transmute(r = r,
            alpha = alpha,
            d0 = th_0 - ji_0,
            d1 = th_1 - ji_1,
            d2 = th_2 - ji_2,
            d3 = th_3 - ji_3,
            d4 = th_4 - ji_4) %>%
  gather(d0:d4, key = "dosage", value = "diff") %>%
  mutate(dosage = recode(dosage,
                         "d0" = "textstyle(dosage) == 0",
                         "d1" = "textstyle(dosage) == 1",
                         "d2" = "textstyle(dosage) == 2",
                         "d3" = "textstyle(dosage) == 3",
                         "d4" = "textstyle(dosage) == 4")) %>%
  ggplot(aes(x = r, y = diff)) +
  facet_grid(dosage ~ alpha, labeller = label_parsed) +
  geom_hline(yintercept = 0, lty = 2, col = 2) +
  geom_line() +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  xlab("Allele frequency") +
  ylab("Difference") ->
  pl

ggsave(filename = "./output/tetra/jiang_diff.pdf",
       plot = pl,
       height = 7,
       width = 6,
       family = "Times")
