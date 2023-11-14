

### Only run if first time using cmdstanr
#
# install.packages(
#     "cmdstanr",
#     repos = c("https://mc-stan.org/r-packages/", getOption("repos"))
# )
# cmdstanr::install_cmdstan()
#
#


library(mvtnorm)
library(cmdstanr)
library(here)


as_vcov <- function(sd, cor) {
    x <- diag(rep(1, length(sd)))
    x[upper.tri(x)] <- cor
    x <- t(x)
    x[upper.tri(x)] <- cor
    res <- diag(sd) %*% x %*% diag(sd)
    res <- as.matrix(Matrix::nearPD(res)$mat)
    assertthat::assert_that(isSymmetric(res))
    dimnames(res) <- NULL
    return(res)
}

n <- 150
Sigma <- as_vcov(c(3, 5), 0.8)

samp <- rmvnorm(n, mean = c(12, 20), sigma = Sigma)

var(samp)
colMeans(samp)


stan_data <- list(
    x = samp[, 1],
    y = samp[, 2],
    n = n
)



file_indep <- here("correlated-variables", "model_indep.stan")
file_indep_bin <- here("correlated-variables", "bin", "model_indep")



mod <- cmdstan_model(
    stan_file = file_indep,
    exe_file = file_indep_bin
)

init_values <- function() {
    list(
        mu_x = 10,
        mu_y = 12,
        sigma_x = 4,
        sigma_y = 3
    )
}

fit1 <- mod$sample(
    data = stan_data,
    chains = 1,
    parallel_chains = 1,
    refresh = 200,
    iter_warmup = 1000,
    iter_sampling = 3000,
    init = init_values
)




file_corr <- here("correlated-variables", "model_corr.stan")
file_corr_bin <- here("correlated-variables", "bin", "model_corr")

mod <- cmdstan_model(
    stan_file = file_corr,
    exe_file = file_corr_bin
)

init_values <- function() {
    list(
        mu = c(5, 5),
        sigma = c(3, 3),
        rho = 0.1
    )
}

fit2 <- mod$sample(
    data = stan_data,
    chains = 1,
    parallel_chains = 1,
    refresh = 500,
    iter_warmup = 1000,
    iter_sampling = 3000,
    init = init_values
)





fit1
fit2


