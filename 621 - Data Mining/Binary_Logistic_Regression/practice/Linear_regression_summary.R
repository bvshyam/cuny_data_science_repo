library(glmnet)
library(ISLR)
names(Smarket)

summary(Hitters)
c = model.matrix((Sal))

Hitters= na.omit(Hitters)
library(leaps)

regfit.full = regsubsets(Salary ~.,data=Hitters,nvmax = 19)
reg.summary = summary(regfit.full)


names(reg.summary)


summary(Smarket)
smarket = Smarket

pairs(Smarket, col= smarket$Direction)
glm.fit = glm(Direction ~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,data = Smarket,family=binomial)

summary(glm.fit)

glm.probs = predict(glm.fit,type='response')
glm.probs[1:5]
glm.pred=ifelse(glm.probs >0.5,'Up','Down')
attach(smarket)
table(glm.pred,Direction)
mean(glm.pred==Direction)

train = Year <2005
train

##############

library(faraway)
data(gavote)


summary(gavote)
xtabs (~ atlanta + rural, gavote)
gavote$undercount <- (gavote$ballots-gavote$votes)/gavote$ballots
gavote$pergore <- gavote$gore/gavote$votes
lmod <- lm(undercount ~ pergore+perAA, gavote)

summary(lmod)



X = as.matrix(data.frame(1,gavote$pergore,gavote$perAA))
t(X)

y = as.matrix(data.frame(gavote$undercount))

# eT*-e -  Residual sum of squares
t(y-(X%*% lmod$coefficients)) %*% (y-(X%*% lmod$coefficients))
deviance (lmod)

# Beta
solve(t(X)%*%X)%*%(t(X)%*%y)
lmod$coefficients

# Simple error - Residuals
sum(y-(X%*%lmod$coefficients))
sum(residuals(lmod))

# Residual Standard error
sqrt (deviance (lmod) / df.residual (lmod))


# R2
lmodsum <- summary(lmod)
lmodsum$r.squared

# Interpretation

gavote$cpergore <- gavote$pergore -mean(gavote$pergore)

gavote$cperAA <- gavote$perAA - mean (gavote$perAA)
lmodi <- lm(undercount ~ cperAA+cpergore*rural+equip,
              gavote)


summary(lmodi)

anova(lmod,lmodi)

summary(lmod)

dropl(lmodi, test="F")

confint(lmodi)

plot (lmodi,which = 4)

gavote[cooks.distance(lmodi) > 0.1,]

halfnorm(influence(lmodi)$hat)

gavote[influence(lmodi)$hat>0.3,]

termplot(lmodi,partial=TRUE,terms=1)

#Robust least squares

library(MASS)
rlmodi <- rlm(undercount ~
                  cperAA+cpergore*rural+equip, gavote)

summary(rlmodi)

# Weighted least squares
wlmodi <- lm(undercount ~
               cperAA+cpergore*rural+equip,
             gavote, weights=ballots)

summary(wlmodi)


summary(lmodi)


#Polynomial

plmodi <- lm(undercount ~
               poly(cperAA,4)+cpergore*rural+equip, gavote)


summary(plmodi)

termplot(plmodi,partial=TRUE,terms=4)

library (splines)

blmodi <- lm(undercount ~ cperAA+bs (cpergore,
                                     4)+rural+equip, gavote)

summary(blmodi)

termplot(blmodi,partial=TRUE,terms=2)

# Variable selection
biglm <- lm(undercount ~ (equip+econ+rural+atlanta)^2+
              (equip+econ+rural+atlanta)* (perAA+pergore), gavote)

summary(biglm)


smallm <- step (biglm, trace=F)

summary(smallm)

finalm <- lm(undercount~equip + econ + perAA +
               equip:econ
             + equip:perAA, gavote)


library(leaps)
dropl(smallm,test="F")
pdf <- data.frame(econ=rep(levels(gavote$econ),5),
                  equip=rep(levels(gavote$equip),rep(3,5)),perAA=0.233)


pp <- predict (finalm, new=pdf)

xtabs(round(pp,3) ~ econ + equip, pdf)


pdf <-
  data.frame(econ=rep("middle",15),equip=rep(levels(gavote$equip),
                                             rep(3,5)),perAA=rep(c(.11,0.23,0.35),5))

pp <- predict(finalm, new=pdf)
propAA <- gl(3,1,15,labels=c("low","medium", "high"))
xtabs(round(pp,3) ~ propAA + equip, pdf)
