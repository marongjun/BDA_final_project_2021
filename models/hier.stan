// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> nt; //number of teams
  int<lower=0> ng; //number of games
  int<lower=0> ht[ng]; //home team index
  int<lower=0> at[ng]; //away team index
  int<lower=0> y1[ng]; //yellow card home team
  int<lower=0> y2[ng]; //yellow card away team
}

parameters {
  real home; //home advantage
  vector[nt] att; // ability of getting yellow cards as attack team 
  vector[nt] def; //ability of getting yellow cards as defend team of
  //hyper parameters
  real mu_att;
  real<lower=0> tau_att;
  real mu_def;
  real<lower=0> tau_def;
}

transformed parameters {
  vector[ng] theta1; // probability of getting yellow cards as home team
  vector[ng] theta2; //probability of getting yellow cards as away team

  theta1 = exp(att[ht] - def[at]);
  theta2 = exp(att[at] - def[ht]);

}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
//hyper priors
mu_att ~ normal(0,0.1);
tau_att ~ normal(0,1);
mu_def ~ normal(0,0.1);
tau_def ~ normal(0,1);

//priors
att ~ normal(mu_att, tau_att);
def ~ normal(mu_def, tau_def);


//likelihood
    y1 ~ poisson(theta1);
    y2 ~ poisson(theta2);
}

generated quantities {
//generate predictions
  int<lower=0> y_home[ng]; //yellow card home team
  int<lower=0> y_away[ng]; //yellow card away team
  real log_like_home[ng];
  real log_like_away[ng];
  for (i in 1:ng){
    y_home[i] = poisson_rng(theta1[i]);
    y_away[i] = poisson_rng(theta2[i]);
  }  
  for (i in 1:ng){
    log_like_home[i] = poisson_lpmf(y_home[i] | theta1[i]);
    log_like_away[i] = poisson_lpmf(y_away[i] | theta2[i]);
  }
}
