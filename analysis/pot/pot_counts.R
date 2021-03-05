library(readxl)
library(stringr)
pot <- read_xlsx(path = "./data/pot/s2.xlsx", skip = 1, .name_repair = "minimal")
pot <- pot[!duplicated(names(pot))]

for (i in 4:ncol(pot)) {
  pot[[i]] <- str_count(pot[[i]], "A")
}

get_nvec <- function(x) {
  table(c(x, 0:4)) - 1
}

nmat <- t(apply(as.matrix(pot[4:ncol(pot)]), 1, get_nvec))

i <- sample(x = 1:nrow(nmat), size = 1)
plot(nmat[i, ], type = "l")
