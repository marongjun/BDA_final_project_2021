//hierarchical model with predictor - home/away
data {
  int<lower=0> N;       //number of matches
  int<lower=0> J;       //number of teams
  vector[N] h[J];       //home = 1, away = 0
  int<lower=0> y[J,N];  //number of yellow cards
}
parameters {
  real alpha[J];
  real beta[J];
}
transformed parameters {
  real lambda[J];
  for (j in 1:J)
    for (n in 1:N)
      lambda[j] = exp(h[j,n] * beta[j] + alpha[j]);
}
model {
  alpha ~ normal(0,1);
  beta ~ normal(0,1);
  for (j in 1:J) {
    y[j,] ~ poisson(lambda[j]);
  }
}
