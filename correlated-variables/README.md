


The idea here was to look at the effect of exclude correlation parameters from a Bayesian model

In particular assume that $X,Y$ comes from a multivariate normal distribution e.g.

$$
X, Y \sim N_2(\mu, \Sigma)
$$

Does excluding the correlation term and modelling them as independent variables have any effect on our estimates of $\mu$ & $\sigma$ ?

Initial findings (with no missing data) indicate there is no effect. In fact excluding the correlation term means sampling is much faster as we can vectorise the Lpdf contribution. Only value of including the correlation term appears to be if we want to draw inference on the correlation term (e.g. have credible intervals for it)






