
### Only run if first time using cmdstanr
#
# install.packages(
#     "cmdstanr",
#     repos = c("https://mc-stan.org/r-packages/", getOption("repos"))
# )
# cmdstanr::install_cmdstan()
#
#


library(dplyr)
library(cmdstanr)
library(here)


dat <- bind_rows(
    tibble(x = rnorm(50, -20, 3),  grp = 1),
    tibble(x = rnorm(250, 3, 1),  grp = 2),
    tibble(x = rnorm(250, 5, 3),  grp = 3),
    tibble(x = rnorm(250, -2, 1), grp = 4),
    tibble(x = rnorm(250, 7, 3),  grp = 5),
    tibble(x = rnorm(250, -5, 2), grp = 6),
)

dat2 <- dat |> filter(grp %in% c(1, 2, 3))

get_mdat <- function(dat) {
    list(
        x = dat$x,
        group_index = dat$grp,
        n_groups = length(unique(dat$grp)),
        n = nrow(dat),
        muprime_mu = 0,
        muprime_sigma = 10,
        tau_mu = 1,
        tau_sigma = 1
    )
}

mdat <- get_mdat(dat)
mdat2 <- get_mdat(dat2)


file_binary <- here("multi-level-borrowing", "bin", "model")
file_model <- here("multi-level-borrowing", "model.stan")

mod <- cmdstan_model(
    stan_file = file_model,
    exe_file = file_binary
)

fit1 <- mod$sample(
    data = mdat,
    chains = 1,
    parallel_chains = 1,
    refresh = 500,
    iter_warmup = NULL,
    iter_sampling = NULL,
)

fit2 <- mod$sample(
    data = mdat2,
    chains = 1,
    parallel_chains = 1,
    refresh = 500,
    iter_warmup = NULL,
    iter_sampling = NULL,
)


fit1$summary(c("mu", "muprime", "tau"))
fit2$summary(c("mu", "muprime", "tau"))


#   variable   mean median     sd    mad     q5    q95  rhat ess_bulk ess_tail
#   <chr>     <num>  <num>  <num>  <num>  <num>  <num> <num>    <num>    <num>
# 1 mu[1]    -19.6  -19.6  0.478  0.458  -20.4  -18.8  1.01     2078.     693.
# 2 mu[2]      2.99   2.99 0.0604 0.0580   2.89   3.09 0.999    2081.     684.
# 3 mu[3]      5.12   5.11 0.183  0.190    4.83   5.42 0.999    2389.     699.
# 4 mu[4]     -2.05  -2.05 0.0651 0.0644  -2.16  -1.94 0.999    3000      508.
# 5 mu[5]      7.02   7.02 0.180  0.165    6.73   7.31 1.00     2637.     694.
# 6 mu[6]     -4.94  -4.94 0.129  0.132   -5.15  -4.73 1.00     2226.     640.
# 7 muprime   -1.88  -1.95 2.03   2.04    -5.13   1.44 0.999    2224.     728.
# 8 tau        4.75   4.72 0.507  0.494    3.97   5.63 1.00     1919.     699.


# # A tibble: 5 × 10
#   variable   mean median     sd    mad     q5     q95  rhat ess_bulk ess_tail
#   <chr>     <num>  <num>  <num>  <num>  <num>   <num> <num>    <num>    <num>
# 1 mu[1]    -19.6  -19.6  0.481  0.479  -20.4  -18.9   1.00     1299.     686.
# 2 mu[2]      2.99   2.99 0.0602 0.0577   2.89   3.09  0.999    1222.     771.
# 3 mu[3]      5.11   5.11 0.201  0.201    4.78   5.45  1.00     1656.     642.
# 4 muprime   -3.63  -3.64 2.36   2.38    -7.38   0.272 0.999    1215.     641.
# 5 tau        4.63   4.60 0.563  0.575    3.77   5.60  1.00     1491.     771.









