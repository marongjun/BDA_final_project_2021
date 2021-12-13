//separate model without predictors
data {
  int<lower=0> J;       //number of teams
  int<lower=0> N;       //number of matches
  int<lower=0> y[J,N];  //number of yellow cards
}
parameters {
  real<lower=0> lambda[J];
}
model {
  for (j in 1:J){
    lambda[j] ~ chi_square(2);
    y[j,] ~ poisson(lambda[j]);
  }
}
generated quantities {
  int<lower=0> ypred[J];
  int y_rep[J,N];
  real log_lik[J,N];
  for (j in 1:J){
    ypred[j] = poisson_rng(lambda[j]);
    for (n in 1:N){
      y_rep[j,n] = poisson_rng(lambda[j]);
      log_lik[j,n] = poisson_lpmf(y[j,n] | lambda[j]);
    }
  }
}
