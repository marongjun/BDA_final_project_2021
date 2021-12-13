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
