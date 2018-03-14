# Linear model

#================================================
# reading in the data & pre-processing
#================================================
urlSheatherData = "http://www.stat.tamu.edu/~sheather/book/docs/datasets/MichelinNY.csv"
dfSheather = as.data.frame(read.csv(urlSheatherData, header = TRUE))

# create the design matrices
vY = as.matrix(dfSheather['InMichelin'])
mX = as.matrix(dfSheather[c('Service','Decor', 'Food', 'Price')])

# add an intercept to the predictor variables
mX = cbind(1, mX)

# the number of variables and observations
iK = ncol(mX)
iN = nrow(mX)

#================================================
# compute the linear regression parameters as 
#   an optimal value
#================================================
# the residual sum of squares criterion function
fnRSS = function(vBeta, vY, mX) {
  return(sum((vY - mX %*% vBeta)^2))
}

# arbitrary starting values
vBeta0 = rep(0, ncol(mX))

# minimise the RSS function to get the parameter estimates
optimLinReg = optim(vBeta0, fnRSS,
                    mX = mX, vY = vY, method = 'BFGS', 
                    hessian=TRUE)

#================================================
# compare to the LM function
#================================================
linregSheather = lm(InMichelin ~ Service + Decor + Food + Price,
                    data = dfSheather)

print(cbind(coef(linregSheather), optimLinReg$par))


# Logistic

#================================================
# compute the logistic regression parameters as 
#   an optimal value
#================================================
# define the logistic transformation
logit = function(mX, vBeta) {
  return(exp(mX %*% vBeta)/(1+ exp(mX %*% vBeta)) )
}

# stable parametrisation of the log-likelihood function
# Note: The negative of the log-likelihood is being returned, since we will be
# /minimising/ the function.
logLikelihoodLogitStable = function(vBeta, mX, vY) {
  return(-sum(
    vY*(mX %*% vBeta - log(1+exp(mX %*% vBeta)))
    + (1-vY)*(-log(1 + exp(mX %*% vBeta)))
  ) 
  ) 
}

# initial set of parameters
vBeta0 = c(10, -0.1, -0.3, 0.001, 0.01) # arbitrary starting parameters

# minimise the (negative) log-likelihood to get the logit fit
optimLogit = optim(vBeta0, logLikelihoodLogitStable,
                   mX = mX, vY = vY, method = 'BFGS', 
                   hessian=TRUE)

#================================================
# test against the implementation in R
# NOTE glm uses IRWLS: 
# http://en.wikipedia.org/wiki/Iteratively_reweighted_least_squares
# rather than the BFGS algorithm that we have reported
#================================================
logitSheather = glm(InMichelin ~ Service + Decor + Food + Price,
                    data = dfSheather, 
                    family = binomial, x = TRUE)


print(cbind(coef(linregSheather), optimLinReg$par))

