data {
  int<lower=0> N;    // number of samples
  int<lower=0> D;    // number of dimensions
  int<lower=0> r;    // rank of partition matrix
  matrix[r, D] psi;    // partition matrix for ilr transform
  real g[N];         // gradient values
  int x[N, D];       // observed microbe abundances
}
parameters {
  // parameters required for linear regression on the species means
  vector[r] beta0;
  vector[r] beta1;
  matrix[N, r] x_; // ilr transformed abundances
}
transformed parameters{
  matrix[r, r] sigma; // covariance matrix for linear regression
  vector[r] sigmaD;
  for (i in 1:r){
    sigmaD[i] = 1;
  }
  for (i in 1:r){
    for (j in 1:r){
      sigma[i, j] = 0;
    }
  }
  sigma = diag_matrix(rep_vector(1.0, r));
}

model {

  // setting priors ...
  for (i in 1:r){
    beta0[i] ~ normal(0, 20); // super informed prior
    beta1[i] ~ normal(3, 5); // super informed prior
  }
  for (j in 1:N){
    x_[j] ~ multi_normal(g[j] * beta1 + beta0, sigma);
    // perform ilr inverse and multinomial sample
    x[j] ~ multinomial( softmax(to_vector( x_[j]*psi )) );
  }
}
