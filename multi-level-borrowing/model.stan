



data {
    int<lower=1> n_groups;     // Number of groups
    int<lower=1> n;            // Total number of observations
    array[n] real x;           // Observations
    array[n] int<lower=1, upper=n_groups> group_index;   // observations -> group mapping
    real muprime_mu;                    // prior mean      for group mean
    real<lower=0> muprime_sigma;        // prior variance  for group mean
    real tau_mu;                        // prior mean      for group variance
    real<lower=0> tau_sigma;            // prior variance  for group variance
}

parameters {
    array[n_groups] real mu;
    array[n_groups] real<lower=0> sigma;
    real muprime;
    real<lower=0> tau;
}

model {
    
    vector[n] mu_vec;
    vector[n] sigma_vec;
    for (i in 1:n){
        mu_vec[i] = mu[group_index[i]];
        sigma_vec[i] = sigma[group_index[i]];
    }
    x ~ normal(mu_vec, sigma_vec);
    mu ~ normal(muprime, tau);
    muprime ~ normal(muprime_mu, muprime_sigma);
    tau ~ normal(tau_mu, tau_sigma);
}






