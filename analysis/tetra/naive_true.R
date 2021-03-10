######################
## Compare naive frequencies to true frequencies
######################

library(hwep)
library(tidyverse)

rseq <- seq(0, 1, length = 100)
dr_ratio <- c(1)
ploidyseq <- c(4, 6, 8)
pardf <- expand.grid(r = rseq, dr_ratio = dr_ratio, ploidy = ploidyseq)
pardf$theo <- vector(mode = "list", length = nrow(pardf))
pardf$naive <- vector(mode = "list", length = nrow(pardf))
pardf$alpha <- vector(mode = "list", length = nrow(pardf))
for (i in seq_len(nrow(pardf))) {
  pardf$alpha[[i]] <- drbounds(ploidy = pardf$ploidy[[i]]) * pardf$dr_ratio[[i]]
  pardf$theo[[i]] <- matrix(hwefreq(alpha = pardf$alpha[[i]], r = pardf$r[[i]], ploidy = pardf$ploidy[[i]]), nrow = 1)
  colnames(pardf$theo[[i]]) <- paste0("th_", 0:pardf$ploidy[[i]])
  pardf$theo[[i]] <- as.data.frame(pardf$theo[[i]])
  pardf$naive[[i]] <- matrix(dbinom(x = 0:pardf$ploidy[[i]], size = pardf$ploidy[[i]], prob = pardf$r[[i]]), nrow = 1)
  colnames(pardf$naive[[i]]) <- paste0("na_", 0:pardf$ploidy[[i]])
  pardf$naive[[i]] <- as.data.frame(pardf$naive[[i]])
}


pardf %>%
  unnest(cols = c("theo", "naive")) %>%
  transmute(r = r,
            ploidy = ploidy,
            d0 = th_0 - na_0,
            d1 = th_1 - na_1,
            d2 = th_2 - na_2,
            d3 = th_3 - na_3,
            d4 = th_4 - na_4,
            d5 = th_5 - na_5,
            d6 = th_6 - na_6,
            d7 = th_7 - na_7,
            d8 = th_8 - na_8) %>%
  gather(d0:d8, key = "dosage", value = "diff") %>%
  mutate(dosage = recode(dosage,
                         "d0" = "textstyle(dosage) == 0",
                         "d1" = "textstyle(dosage) == 1",
                         "d2" = "textstyle(dosage) == 2",
                         "d3" = "textstyle(dosage) == 3",
                         "d4" = "textstyle(dosage) == 4",
                         "d5" = "textstyle(dosage) == 5",
                         "d6" = "textstyle(dosage) == 6",
                         "d7" = "textstyle(dosage) == 7",
                         "d8" = "textstyle(dosage) == 8"),
         ploidy = paste0("textstyle(ploidy) == ", ploidy)) %>%
  ggplot(aes(x = r, y = diff)) +
  facet_grid(dosage ~ ploidy, labeller = label_parsed) +
  geom_hline(yintercept = 0, lty = 2, col = 2) +
  geom_line() +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) +
  xlab("Allele frequency") +
  ylab("Difference") ->
  pl

ggsave(filename = "./output/tetra/naive_diff.pdf",
       plot = pl,
       height = 7,
       width = 6,
       family = "Times")
