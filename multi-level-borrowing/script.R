
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

n <- 600
n_group <- 9
sigma <- 3

mu_group <- rnorm(n_group, 12, 2)
mu_group[1] <- 2

dat <- tibble(
    id = sprintf("pt%05i", 1:n),
    group = sample(1:n_group, size = n, replace = TRUE),
    mu = mu_group[group],
    x = rnorm(n, mu, sigma)
)

get_mdat <- function(dat) {
    list(
        x = dat$x,
        group_index = dat$group,
        n_groups = n_group,
        n = n,
        muprime_mu = 10,
        muprime_sigma = 10,
        tau_mu = 5,
        tau_sigma = 5
    )
}

mdat <- get_mdat(dat)


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
    iter_warmup = 1000,
    iter_sampling = 2000,
)


fit1$summary(c("mu", "muprime", "tau"))

obvs_means <- dat |>
    group_by(group) |>
    summarise(obvs_group_mean = mean(x))

fit1$summary(c("mu")) |>
    select(mean_sample = mean) |>
    mutate(group = 1:n_group) |>
    left_join(obvs_means, by = "group") |>
    mutate(mean_real = mu_group) |>
    mutate(diff = mean_sample - mean_real) |>
    mutate(global_mean = mean(dat$x)) |>
    mutate(diff_overal = mean_sample - global_mean)

 


