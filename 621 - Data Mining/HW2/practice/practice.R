library(faraway)
data (longley)
g <- lm (Employed ~ GNP + Population, longley)
summary (g, cor=T)

cor (residuals (g) [-1], residuals (g) [-16])

x <- model.matrix (g)
Sigma <- diag (16)
Sigma <- 0.31041^abs(row(Sigma)–col(Sigma))
Sigi <- solve (Sigma)



g_lm = glm (Employed ~ GNP + Population,data= longley)
summary(g_lm)


library (nlme)
g <- gls (Employed ~ GNP + Population,data=longley)
summary (g)
intervals(g)

data(corrosion)
plot(loss ~ Fe, corrosion, xlab="nlron content",ylab="Weight loss")

g <- lm (loss ~ Fe, corrosion);
summary (g)
factor (corrosion$Fe)

ga <- lm (loss ~ Fe, factor(corrosion))
points (corrosion$Fe, fitted (ga), pch=18)


gp <- lm (loss ~ Fe+I (Fe^2)+I (Fe^3)+I (Fe^4)+I (Fe^5)+
             I (Fe^6), corrosion)

plot (loss ~ Fe, data=corrosion, ylim=c (60, 130) )
points(corrosion$Fe,fitted(gp),pch=18)
grid <- seq(0, 2, len=50)
lines (grid, predict (gp, data.frame (Fe=grid)))




data(star)
plot (light ~ temp, star)
gsl <- lm (light ~ temp, star)
abline (coef (gsl) )
gs2 <- rlm (light ~ temp, star)
abline (coef (gs2), lty=2)
gs3 <- ltsreg (light ~ temp, star, nsamp="exact")
abline (coef (gs3), lty=5)

library(MASS)

# generate some data
set.seed(1)
n <- 100
x <- runif(n, 1, 5)
y <- x^3 + rnorm(n)

# run a linear model
m <- lm(y ~ x)

# run the box-cox transformation
bc <- boxcox(y ~ x)
summary(bc)


data(savings)
g <- lm (sr ~ pop15+pop75+dpi+ddpi,savings)
boxcox(g,plotit=T)
boxcox (g, plotit=T, lambda=seq (0.5, 1.5, by=0.1))

hist(log(savings$sr))

data (gala)
g <- lm (Species ~ Area + Elevation + Nearest + Scruz + Adjacent, gala)
boxcox (g, plotit=T)
boxcox (g, lambda=seq (0.0, 1.0, by=0.05), plotit=T)

hist((gala$Species)^(1/3))




g1 <- lm (sr ~ pop15, savings, subset=(pop15 < 35) )


g2 <- lm (sr ~ pop15, savings, subset=(pop15 > 35))



plot (sr ~ pop15,savings,xlab="Pop'n under 15",ylab="Savings Rate")
abline (v=35, lty=5)
segments (20, g1$coef [1] +g1$coef[2]*20,35,g1$coef [1] +g1$coef [2] *35)

segments (48, g2$coef [1] +g2$coef[2]*48,35,
            g2$coef [1] +g2$coef [2] * 35)


summary(g1)
summary(g2)

Ihs <- function (x) ifelse(x < 35, 35-x, 0)
rhs <- function (x) ifelse(x < 35, 0, x-35)
gb <- lm (sr ~ Ihs (pop15) + rhs(pop15), savings)
x <- seq(20, 48, by=1)
py <- gb$coef[1]+gb$coef[2]*Ihs(x)+gb$coef[3]*rhs(x)
lines (x, py, lty=2)



summary (lm (sr ~ ddpi, savings) )

summary (lm (sr ~ ddpi+I (ddpi^2)+I (ddpi^3), savings))


summary (lm (sr ~ ddpi+I (ddpi^2)+I (ddpi^3)+I (ddpi^4), savings))
summary (lm (sr ~ poly(ddpi,4), savings))


funky <- function (x) sin (2*pi*x^3) ^3
x <- seq (0, 1, by=0.01)
y <- funky (x) + 0.1*rnorm (101)
matplot (x, cbind (y, funky (x)), type="pl", ylab="y",
           pch=18, lty=1)


g4 <- lm (y ~ poly(x,4))
g12 <- lm (y ~ poly(x,12))
matplot (x, cbind(y, g4$fit, g12$fit) , type="pll",ylab="y", pch=18,lty=c (1,2))



library (splines)
knots <- c (0, 0, 0, 0, 0.2, 0.4, 0.5, 0.6, 0.7, 0.8, 0.85, 0.9, 1, 1, 1, 1)
bx <- splineDesign (knots, x)
gs <- lm (y ~ bx)
matplot (x, bx, type="l")
matplot (x, cbind (y, gs$fit),type="pl",ylab="y", pch=18, lty=1)



data(state)

statedata <- data.frame (state.x77, row.names=state.abb)

g <- lm (Life.Exp ~ . , data=statedata)

summary(g)

g <- update(g, .~.-Area-Illiteracy-Income-Population)
summary(g)

summary(lm(Life.Exp ~ Illiteracy+Murder+Frost, statedata))


g <- lm (Life.Exp ~ ., data=statedata)
step (g)


library(leaps)
b<- regsubsets(Life.Exp~.,data=statedata)
(rs <- summary (b))





# Outliers and influence
h <- lm.influence (g) $hat

rev(sort(h))





b<- regsubsets (Life.Exp~., data=statedata,subset=(state.abb!="AK"))

rs <-summary(b)
rs$which [which.max (rs$adjr),]

rev(sort(h))
rev(sort(cooks.distance(g)))
plot (2:8, rs$adjr2, xlab="No. of Parameters",
      ylab="Adjusted R-square")

stripchart (data.frame (scale (statedata)), vertical=TRUE,method="jitter")



# Transformed 

b<- regsubsets (Life.Exp~ log(Population)+Income+Illiteracy+
                   Murder+HS.Grad+Frost+log(Area), statedata)
rs <- summary (b)
rs$which [which.max (rs$adjr), ]



# PCA transfomred 

data (meatspec)

meatspec
model1 <- lm (fat ~ ., meatspec[1:172,])
summary(model1)


rmse <- function (x, y) sqrt (mean((x-y)^2) )
rmse(model1$fit, meatspec[1:172,])


rmse(predict (model1, meatspec [173:215,]), meatspec$fat[173:215] )

mode12 <- step (model1)
rmse (predict (mode12, meatspec [173:215,]),meatspec$fat[173:215] )


# PCA model
library (mva)

meatpca <- prcomp(meatspec[1:172, -101])
round (meatpca$sdev, 3)
meatpca$rotation

matplot (1:100, meatpca$rotation [,c(1,13)] , type="l",
         xlab="Frequency", ylab="")


plot(model1$coef[-1],
     ylab="Coefficient")

# Only 4 variables
mode13 <- lm (fat ~ meatpca$x [,1:4], meatspec [1:172,])
rmse(mode13$fit, meatspec$fat [1:172])


svb <- meatpca$rot [,1:4] %*% mode13$coef [-1]
plot (svb, ylab="Coefficient")

plot(meatpca$sdev[1:10],type="l",ylab="SD of PC",
     xlab="PC number")

library(pls)

pcr_model =pcr(fat ~ ., data =meatspec)

R2(pcr_model)



mm <- apply (meatspec[1:172, -101], 2, mean)
tx <- as.matrix (sweep (meatspec [173:215, -101], 2, mm))


trainx <- as.matrix (sweep (meatspec [1:172,-101] , 2, mm))

pcrg <- pcr(trainx,meatspec$fat[1:172] ,1:50, validation="CV", grpsize=10)

#Partial least squares



# Ridge regression


library (MASS)
yc <- meatspec$fat[1:172]-mean(meatspec$fat[1:172])
gridge <- lm.ridge (yc ~ trainx, lambda =seq(0,5e-8,1e-9))

matplot (gridge$lambda, t(gridge$coef), type="l",lty=1,
           xlab=expression (lambda), ylab=expression (hat (beta)))


select (gridge)
abline (v=18e-8)

which.min (gridge$GCV)
ypredg <- scale (trainx, center=FALSE,scale=gridge$scales) %*% gridge$coef [, 19] + mean(meatspec$fat[1:172])
rmse(ypredg,meatspec$fat[1:172])


data (eco)

plot (income ~ usborn, data=eco, xlab="Proportion US born",
      ylab="Mean Annual Income")


g <- lm (income ~ usborn, eco)
summary (g)


plot (income ~ usborn, data=eco, xlab="Proportion US born",
      ylab="Mean Annual Income", xlim=c (0, 1), ylim=c(15000,
                                                       70000), xaxs="i")
abline (coef (g) )
library(PerformanceAnalytics)

data (chredlin)

chredlin_1 = chredlin %>% select(-c(7))

chart.Correlation(chredlin_1,histogram=TRUE,pch=111)
plot(fire ~ race ,chredlin_1 )
abline(coef(lm(fire ~ race,data=chredlin_1) ))
plot(race ~ fire,chredlin_1 )

summary(lm(theft ~ race,data=chredlin_1) )

cor(chredlin_1$fire,chredlin_1$race)


plot (involact ~ race, chredlin)
abline (lm (involact ~ race, chredlin))
plot (fire ~ race, chredlin)
abline (lm (fire ~ race, chredlin))


g <- lm (involact ~ race + fire + theft + age + log(income),chredlin)
summary (g)


plot(g)

plot(g,which=c(4))

plot(fitted(g), residuals(g), xlab='Fitted', ylab='residuals')

abline(h=0)

qqnorm (residuals (g))
qqline (residuals (g))


gi <- influence (g)
qqnorml (gi$coef [,4])
halfnorm (cooks.distance (g))

gi$coef [c(6,24),4]

range (rstudent (g))

g <- lm (involact ~ race + fire + theft + age + log
          (income), chredlin, subset=-c(6, 24))

summary (g)

prplot (g, 1)
prplot (g, 2)

chreduc <- matplot (x, cbind (y, gs$fit), type="pl",ylab="y", pch=18, lty=l)


b<- regsubsets (involact ~ race + fire + theft + age + log
                 (income), force.in=1, data=chredlin)
(rs <- summary (b))


g <- lm (involact ~ race + fire + theft + age, chredlin,
          subset= -c(6,24))
summary (g)


galt <- lm (involact ~ race+fire+log (income), chredlin,
             subset= -c(6, 24))
summary (galt)




#### Missing values
data (chmiss)

chmiss

g <- lm (involact ~ .,chmiss)
summary(g)


cmeans <- apply (chmiss, 2, mean, na.rm=T)




gr <- lm (race ~ fire+theft+age+income, chmiss)

chmiss [is.na (chmiss$race) , ]
predict(gr,chmiss[is.na(chmiss$race),])

# Logit

logit <- function (x) log (x/(l-x))
ilogit <- function (x) exp (x)/(1+exp (x))

gr <- lm (logit (race/100) ~ fire+theft+age+income,chmiss)

ilogit (predict (gr, chmiss [is.na (chmiss$race), ] ))*100

logit (chmiss$race/100)


chmiss$race


# PLS
library(pls)

trainx <- as.matrix (sweep (meatspec [1:172, -101], 2, mm))

plsg <- pls(trainx,meatspec$fat[1:172] ,1:50, validation="CV",grpsize=10)

plot (plsg$training$B[ , , 4], ylab="Coefficient"

plot (plsg$validat$RMS, ylab="CV RMS", xlab="No. of components")


