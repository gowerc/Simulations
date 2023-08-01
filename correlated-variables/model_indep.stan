

data {
    int<lower=1> n;
    vector[n] x;
    vector[n] y;
}


parameters {
    real mu_x;
    real mu_y;
    real<lower=0> sigma_x;
    real<lower=0> sigma_y;
}


model {
    target += normal_lpdf(x | mu_x, sigma_x);
    target += normal_lpdf(y | mu_y, sigma_y);
}
