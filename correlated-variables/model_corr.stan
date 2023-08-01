


data {
    int<lower=1> n;
    vector[n] x;
    vector[n] y;
}


parameters {
    vector[2] mu;
    vector<lower=0>[2] sigma;
    real<lower=0, upper=1> rho;
}

transformed parameters {
    cov_matrix[2] Sigma = diag_matrix(sigma^2);
    Sigma[1,2] = rho * sigma[1] * sigma[2];
    Sigma[2,1] = Sigma[1,2];
}


model {
    vector[2] obs;
    for (i in 1:n) {
        obs[1] = x[i];
        obs[2] = y[i];
        target += multi_normal_lpdf(obs | mu, Sigma);
    }
}




