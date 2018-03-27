library(faraway)
data(orings)
orings


plot (damage/6 ~ temp, orings, xlim=c(25,85), ylim =
        c(0,1),
      xlab="Temperature", ylab="Prob of damage")


lmod <- lm(damage/6 ~ temp, orings)
abline(lmod)

# LOgit
logitmod <- glm(cbind(damage,6-damage) ~ temp,
                family=binomial, orings)

summary(logitmod)

cbind(orings$damage,6-orings$damage) 



plot (damage/6 ~ temp, orings, xlim=c(25,85),
      ylim=c(0,1),
      xlab="Temperature", ylab="Prob of damage")
x <- seq(25,85,1)
lines(x,ilogit(11.6630-0.2162*x))

#probit

probitmod <- glm(cbind(damage,6-damage) ~ temp,
                 family=binomial(link=probit), orings)


lines(x, pnorm(5.5915-0.1058*x), lty=2)

ilogit (11.6630-0.2162*31)
pnorm(5.5915-0.1058*31)

pchisq(deviance(logitmod),
       df.residual(logitmod),lower=FALSE)

summary(logitmod)
confint(logitmod)


# New data
data(babyfood)
xtabs(disease/(disease+nondisease)~sex+food,
      babyfood)

mdl <- glm(cbind(disease, nondisease) ~ sex+food,
           family=binomial,
           babyfood)


summary(mdl)


drop1(mdl,test="Chi")

exp(confint(mdl))
exp(-0.173)

babyfood[c(1,3),]


data (bliss)
bliss
modl <- glm(cbind(dead, alive) ~ conc,
            family=binomial, data=bliss)

modp <- glm(cbind(dead, alive) ~ conc,
            family=binomial(link=probit),
            data=bliss)

modc <- glm(cbind(dead, alive) ~ conc,
            family=binomial(link=cloglog),
            data=bliss)

summary(modp)
fitted(modl)
coef(modl)

coef(modl)[1]+coef(modl)[2]*bliss$conc

ilogit (modl$lin)


exp(modl$lin)/(1+exp(modl$lin))

cbind(fitted(modl),fitted(modp),fitted(modc))


x <- seq(-2,8,0.2)
pl <- ilogit(modl$coef[1]+modl$coef[2]*x)
pp <- pnorm(modp$coef[1]+modp$coef[2]*x)
pc <- 1-exp(-exp((modc$coef[1]+modc$coef[2]*x)))
plot(x,pl,type="l",ylab="Probability",xlab="Dose")
lines(x,pp,lty=2)
lines(x,pc,lty=5)




matplot(x,cbind(pp/pl,(1-pp)/(1-pl)),type="l",xlab="Dose",ylab="Ratio")
matplot(x,cbind(pc/pl,(1-pc)/(1-pl)),type="l",xlab="Dose",ylab="Ratio")


# Estimation problems

data(data(hormone))

plot(estrogen ~
       androgen,data=hormone,pch=as.character(orientation))

modl <- glm(orientation ~ estrogen + androgen,
            hormone, family=binomial)


summary(modl)

abline(-84.5/90.2,100.9/90.2)
abline(-3.65/3.586,4.074/3.586,lty=2)


library(brlr)
modb <- brlr(orientation ~ estrogen + androgen,
               hormone,
               family=binomial)
summary(modb)


modl <- glm(cbind(dead,alive) ~ conc,
            family=binomial, data=bliss)
sum(residuals(modl,type="pearson")^2)

(1-exp((modl$dev-modl$null)/150))/(1-exp(-modl$null/150))



modl <- glm(cbind(dead, alive) ~ conc,
            family=binomial,data=bliss)
lmodsum <- summary(modl)


x0 <- c(1, 2.5)
eta0 <- sum(x0*coef(modl))
ilogit(eta0)


(cm <- lmodsum$cov.unscaled)


lmodsum$cov.scaled


se <- sqrt(t(x0) %*% cm %*% x0)


predict(modl,newdata=data.frame(conc=2.5),se=T)


library(MASS)
dose.p(lmod,p=c(0.5,0.9))


data(troutegg)
ftable(xtabs(cbind(survive,total)~location+period,troutegg))


bmod <- glm(cbind(survive,total-survive) ~
              location+period,
            family=binomial,troutegg)
bmod

halfnorm(residuals(bmod))

elogits <-  log((troutegg$survive+0.5)/(troutegg$total-troutegg$
                                survive+0.5))

with(troutegg,interaction.plot(period,location,elogits))



sum(bliss$dead) + sum(bliss$alive)
