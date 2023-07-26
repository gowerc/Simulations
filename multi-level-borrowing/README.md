
This fits the model:

$$
\begin{align*}
y_{ij} &\sim N(\mu_j, \sigma) \\
\mu_j &\sim N(\mu', \tau) \\
\mu' &\sim N(a, b) \\
\tau &\sim N(c, d)
\end{align*}
$$

E.g. observations $y_{ij}$ share a common mean $\mu_j$ which are drawn from a parent distribution. The correlation between the $\mu_j$ can in theory be controlled by priors placed onto the $\mu'$ and $\tau$ parameters (e.g. tweaking a,b,c,d).

This is meant to represent "borrowing" between arms as talked about in this textbook [here](https://bayesball.github.io/BOOK/bayesian-hierarchical-modeling.html)


Having said that there doesn't appear to be any "borrowing" instead unless we place extreme priors on $\tau$ (which causes lots of sampling issues)it appears all this achieves is just estimating the population parameters with no change in estimates or confidence intervals of the individual $\mu_j$

Raised question about this on StackOverflow [here](https://stats.stackexchange.com/questions/622288/in-bayesian-modelling-how-to-interpret-hierarchical-hyperparameters-with-regards?noredirect=1#comment1158480_622288) though this currently has no answers :(.


