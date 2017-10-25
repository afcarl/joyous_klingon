// seems to work : very low variance.
data {
  int<lower=0> N;    // number of samples
  int<lower=0> D;    // number of dimensions
  int<lower=0> r;    // rank of partition matrix
  matrix[D-1, D] psi;// partition matrix for ilr transform
  real g[N];         // gradient values
  int x[N, D];       // observed microbe abundances
}
parameters {
  // parameters required for linear regression on the species means
  vector[D-1] beta0;
  vector[D-1] beta1;
  matrix[N, D-1] x_; // ilr transformed abundances
  // https://github.com/stan-dev/stan/issues/662
  vector<lower=0>[r] sigma;
  matrix[D-1, r] W; // factor for covariance matrix
}
transformed parameters{
  cov_matrix[D-1] Sigma;
  matrix[D-1, D-1] I;
  I = diag_matrix(rep_vector(1.0, D-1));
  Sigma = W * W' + 0.001*I;
}

model {
  // setting priors ...
  for (i in 1:r){
    beta0[i] ~ normal(0, 20); // weakly informed prior
    beta1[i] ~ normal(0, 20); // weakly informed prior
  }

  for (i in 1:D-1){
    for (j in 1:r){
      W[i, j] ~ normal(0, 1);
    }
  }

  # now for the actual calculation
  for (j in 1:N){
    x_[j] ~ multi_normal(g[j] * beta1 + beta0, Sigma);
    // perform ilr inverse and multinomial sample
    x[j] ~ multinomial( softmax(to_vector( x_[j] * psi )) );
  }

}
