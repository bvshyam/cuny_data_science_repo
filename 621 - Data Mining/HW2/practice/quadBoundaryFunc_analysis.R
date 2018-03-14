set.seed(975)
lgdf = quadBoundaryFunc(500)

lgdf %>%  select(c('X1','X2','class')) %>% write.csv("quadboundary.csv")

lgdf = lgdf %>%  mutate(class_num = if_else(class=='Class1', 1, 0, missing = NULL)) %>% 
  select(c('X1','X2','class_num'))



head(lgdf)

lm_model  = lm(class_num ~ X1 + X2, lgdf)
summary(lm_model)

1/(1+exp(-(predict(lm_model,head(lgdf)%>%select(c('X1','X2')) ))))


1/(1+ exp( 0.62341-(-0.20262* 2.4685709)-(0.04879*2.28742015)))

1/(1+ exp( 0.62341-(-0.20262* -0.188940698)-(0.04879*-1.639494552))) # 0.5927580
1/(1+ exp( 0.62341-(-0.20262* 0.348127897)-(0.04879*-0.067074343))) # 0.5648658


logistic_reg = glm(class_num ~ X1 + X2, lgdf,family = binomial)

predict(logistic_reg,head(lgdf)%>%select(c('X1','X2')),type='response')


qdaModel1 <- qda(class_num ~ X1 + X2, data = lgdf)



# logit
logistic_logit_reg = glm(class_num ~ X1 + X2, lgdf,family = binomial('logit'))

predict(qdaModel1, head(lgdf)%>%select(c('X1','X2')),type='response')
predict(logistic_reg,head(lgdf)%>%select(c('X1','X2')),type='response')
predict(logistic_logit_reg,head(lgdf)%>%select(c('X1','X2')))

predict(lm_model,head(lgdf)%>%select(c('X1','X2')))




(1/(1+exp(-(predict(lm_model,head(lgdf)%>%select(c('X1','X2')) )))))



#Manual


# create the design matrices
vY = as.matrix(lgdf['class_num'])
mX = as.matrix(lgdf[c('X1','X2')])

# add an intercept to the predictor variables
mX = cbind(1, mX)

# the number of variables and observations
iK = ncol(mX)
iN = nrow(mX)


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
vBeta0 = c(10, -0.1, -0.3) # arbitrary starting parameters

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

