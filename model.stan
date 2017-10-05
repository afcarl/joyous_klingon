data {
    int<lower=0> N;    // number of samples
    int<lower=0> D;    // number of dimensions
    real g[N];         // gradient values
    // int<lower=0> n[N]; // sampling depth
    matrix[D, N] x;    // observed microbe abundances
}

parameters {
    real mu[D];             // means for each species distribution
    real<lower=0> sigma[D]; // variance for each species distribution
    // parameters required for linear regression on the species means
    real alpha;
    real beta0;
    real beta1;
    real<lower=0> sigmaG;
}

transformed parameters{
    matrix[D, N] xmodel;        // microbe abundances
    matrix[D, N] eta;           // microbe logistic transformed
    matrix[D, N] m;             // microbe logistic transformed
}

model {
    // setting priors ...
    beta0 ~ normal(0, 10);
    beta1 ~ normal(0, 10);
    sigmaG ~ cauchy(0, 5);

    // fitting the actual model

    // generating the normal distributions for each species
    for (i in 1:D){
	sigma[i] ~ cauchy(0, 5);
	mu[i] ~ normal(beta0 + beta1 * g[i], sigmaG);
	// choosing a prior for sigma[i]

	// fit normal distribution for each species j
	for (j in 1:N){
	  x[i, j] ~ normal(exp( (mu[i]-g[j])^2 / 2 ), 1);
	}
    }

    // generating logistic normal via inverse clr
    //for (j in 1:N){
    //    eta[:, j] = softmax(x[:, j])
    //}

    // pull out multinomial samples
    //for (j in 1:N){
    //    m[:, j] = multinomial(eta[:, j], n[j])
    //}

}
