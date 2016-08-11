library("datapkg")
library("dplyr")
library("poweRlaw")
library("reshape2")

file_loc <- "~/Dropbox/R/SAA_R_Demo_2016/data/Tache_biface_count.csv"
dat <- read.csv(file_loc ,stringsAsFactors = FALSE, skip = 1, header = TRUE)

dat <- select(dat, num_caches, bifaces) %>%
  mutate_each(funs(as.numeric), c(num_caches, bifaces)) %>%
  mutate(per_cache = bifaces / num_caches) %>%
  mutate(per_cache = round(per_cache,1))

hist(dat$per_cache, breaks = 10)

pc_pl <- conpl$new(dat$per_cache)
est_pl <- estimate_xmin(pc_pl)
pc_pl$setXmin(est_pl)
plot(pc_pl)
lines(pc_pl, col=2, lwd=2)

pc_ln = conlnorm$new(dat$per_cache)
est_ln = estimate_xmin(pc_ln)
pc_ln$setXmin(est_ln)
lines(pc_ln, col=3, lwd=2)

pc_ex <-conexp$new(dat$per_cache)
est_ex = estimate_xmin(pc_ex)
pc_ex$setXmin(est_ex)
lines(pc_ex, col=5, lwd=2)

pc_pl_bs = bootstrap(pc_pl, no_of_sims=5000, threads=2)
plot(pc_pl_bs)
hist(pc_pl_bs$bootstraps$xmin, breaks = 30)
quantile(pc_pl_bs$bootstraps$xmin)

pc_p = bootstrap_p(pc_pl, no_of_sims=5000, threads=2)
plot(pc_p)
hist(pc_p$bootstraps$gof)

pc_ln$setXmin(pc_pl$getXmin())
est = estimate_pars(pc_ln)
pc_ln$setPars(est)
comp = compare_distributions(pc_pl, pc_ln)



