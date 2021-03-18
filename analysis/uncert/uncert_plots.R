library(tidyverse)

udf <- read_csv("./output/uncert/uncert_sims.csv")

udf %>%
  gather(-seed, -niter, key = "method", value = "P-value") %>%
  mutate(method = recode(method,
                         "boot" = "Bootstrap",
                         "like" = "Likelihood",
                         "nodr" = "No DR",
                         "rm" = "Random Mating",
                         "ustat" = "U-stat"),
         niter = paste0("# Generations = ", niter)) %>%
  ggplot(aes(x = `P-value`)) +
  geom_histogram(bins = 10) +
  facet_grid(niter ~ method, scales = "free_y") +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white")) ->
  pl

ggsave(filename = "./output/uncert/uncert_hist.pdf",
       plot = pl,
       height = 3,
       width = 6.5,
       family = "Times")
