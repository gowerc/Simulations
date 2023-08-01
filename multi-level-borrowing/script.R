
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

n <- 100
sigma <- 3

mu <- c(
    -3,
    5, 3, 6, 7, 4, 3, 5, 6, 7,
    7, 5, 4, 5, 6, 3, 4, 4, 5
)

hold <- list()
for (i in seq_along(mu)) {
    hold[[i]] <- tibble(x = rnorm(n, mu[i], sigma), grp = i)
}
dat <- bind_rows(hold)
dat2 <- dat |> filter(grp %in% c(1, 2, 3))

get_mdat <- function(dat) {
    list(
        x = dat$x,
        group_index = dat$grp,
        n_groups = length(unique(dat$grp)),
        n = nrow(dat),
        muprime_mu = 5,
        muprime_sigma = 3,
        tau_mu = 0.5,
        tau_sigma = 5
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
    iter_warmup = 1000,
    iter_sampling = 2000,
)

fit2 <- mod$sample(
    data = mdat2,
    chains = 1,
    parallel_chains = 1,
    refresh = 500,
    iter_warmup = 1000,
    iter_sampling = 2000,
)


fit1$summary(c("mu", "muprime", "tau"))
fit2$summary(c("mu", "muprime", "tau"))



fit1$summary(c("mu")) |>
    select(mean_sample = mean) |>
    mutate(mean_real = mu) |>
    mutate(diff = mean_sample - mean_real) |>
    mutate(mean_overall = mean(mean_sample)) |>
    mutate(diff_overal = mean_sample - mean_overall)

 


