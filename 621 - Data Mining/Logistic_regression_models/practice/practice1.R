

library(caret)
library(glmnet)
set.seed(849)
training <- twoClassSim(50, linearVars = 2)
set.seed(849)
testing <- twoClassSim(500, linearVars = 2)
trainX <- training[, -ncol(training)]
testX <- testing[, -ncol(testing)]
trainY <- as.factor(training$Class)

# Using glmnet to directly perform CV
set.seed(849)
cvob1=cv.glmnet(x=as.matrix(trainX),y=trainY,family="binomial",alpha=1, type.measure="auc", nfolds = 3,lambda = seq(0.001,0.1,by = 0.001),standardize=FALSE)

cbind(cvob1$lambda,cvob1$cvm)

# best parameter
cvob1$lambda.mi

# best coefficient
coef(cvob1, s = "lambda.min")


# Using caret to perform CV
cctrl1 <- trainControl(method="cv", number=3, returnResamp="all",classProbs=TRUE,summaryFunction=twoClassSummary)
set.seed(849)
test_class_cv_model <- (x=trainX, trainY, method = "glmnet", trControl = cctrl1,metric = "ROC",
                             tuneGrid = expand.grid(alpha = 1,lambda = seq(0.001,0.1,by = 0.001)))


test_class_cv_model 

# best parameter
test_class_cv_model$bestTune

# best coefficient
coef(test_class_cv_model$finalModel, test_class_cv_model$bestTune$lambda)







```{r}
objControl <- trainControl(method='cv', number=5,classProbs = TRUE)

#objModel <- caret::train(x=train[,predictorsNames], y=factor(train[,outcomeName]), metric='ROC', method='glmnet',   trControl=objControl)

test_class_cv_model <- train(train[,predictorsNames], as.factor(make.names(train[,outcomeName])), method = "glmnet", trControl = objControl)


predictions <- predict(object=test_class_cv_model, test[,predictorsNames])

auc <- roc(make.names(test[,outcomeName]), unclass(predictions))
print(auc$auc)

```


# Function for printing confusion matrix
confusion_analysis <- function(actual, predicted){
  # Threshold value is 0.5, positive class is 1
  print(confusionMatrix(data = predicted,
                        reference = actual,
                        positive = "1"))
  
  rocCurve <- roc(response = actual, predictor = as.integer(predicted),levels=c(1,0))
  
  print(rocCurve)
  
  plot(y = rocCurve$sensitivities, ylab = "Sensitivity", x = 1 - rocCurve$specificities, xlab = "1 - Specificity",
       main = "ROC Curve", col = "red")
}


confusion_analysis(test[,outcomeName],predict_glmnet)






summary_analysis <- function(test,model){
  print(summary(model))
  print("Confusion Matrix:")
  confusion_analysis(test,model)
}


summary_analysis(test,model_11_backward)


confusion_analysis(test,model_11_backward)






### Imputation


# AGE with NA
df[is.na(df$AGE),]

#KNN Imputation
df$AGE <- kNN(df,variable='AGE',k=5)$AGE

#kNN(df,variable='AGE',k=5)$AGE[1043]
#kNN(df,variable='AGE',k=5)$AGE[1315]
#kNN(df,variable='AGE',k=5)$AGE[2971]
#kNN(df,variable='AGE',k=5)$AGE[3460]
#kNN(df,variable='AGE',k=5)$AGE[4156]

df[is.na(df$YOJ),]$YOJ

df$YOJ <- kNN(df,variable='YOJ',k=5)$YOJ
#kNN(df,variable='YOJ',k=5)$YOJ[7]
#kNN(df,variable='YOJ',k=5)$YOJ[8]

#kNN(df,variable='YOJ',k=5)$YOJ
#mean(df[!is.na(df$YOJ),]$YOJ)



# One method we can use is if it is student, then home value will be 0

mean(df[!is.na(df$HOME_VAL),]$HOME_VAL)
median(df[!is.na(df$HOME_VAL),]$HOME_VAL)
df[is.na(df$HOME_VAL) & df$JOB=='Student',]

df[is.na(df$HOME_VAL) & df$INCOME==0,]

unique(df[is.na(df$HOME_VAL),]$JOB)

summary(df)

df$INCOME





#mean(df[is.na(df$CAR_AGE),]$CAR_AGE)


df[is.na(df$CAR_AGE),]$CAR_AGE <- mean(df[!is.na(df$CAR_AGE),]$CAR_AGE)







```{r}
#regsubsets(TARGET_FLAG~., data=df_dummy,really.big=TRUE )



model_11_transformed_dummies = glm(TARGET_FLAG ~ .-TARGET_AMT-`JOB_Home Maker`-YOJ-INCOME-AGE-RED_CAR_no-CLM_FREQ-SEX_z_F-JOB_Student, df_transformed_dummies, family=binomial(link = 'logit'))

plot(model_11_transformed_dummies)

plot(model_11_transformed_dummies,which = c(4))

summary(step(model_11_transformed_dummies,direction = 'backward'))
summary(back_step)


model_10_base = glm(TARGET_FLAG ~ .-TARGET_AMT, df_dummy, family=binomial(link = 'logit'))


#back_step <- step(model_10_base,direction = 'backward')
summary(back_step)

#plot(model_10_base)
```




x <- floor(exp(rnorm(200000 * 1.3)))
cuts <- bins(x, target.bins = 10, minpts = 2000)
cuts$breaks <- bins.getvals(cuts)
cuts$binct


cuts







```{r}
#Creating dummies

create_dummies <- function(df_corrected, sel_cols){
  
  df_dummy <- dummy_cols(df_corrected,select_columns = sel_cols,remove_first_dummy = TRUE)
  
  return(df_dummy[,!(names(df_dummy) %in% sel_cols)])
  
}

df_dummy <- create_dummies(df_corrected,sel_cols = c('PARENT1','MSTATUS',
                                                     'EDUCATION',
                                                     'JOB','SEX',
                                                     'CAR_USE',
                                                     'CAR_TYPE',
                                                     'RED_CAR',
                                                     'REVOKED',
                                                     'URBANICITY')
)



#Add back the predicted variables

#df_dummy <-cbind(df_dummy,TARGET_FLAG=df_original$TARGET_FLAG,TARGET_AMT=df_original$TARGET_AMT)
#head(df_dummy)



```








### Correlation Charts

#### TARGET_FLAG Plots

As a next step we will draw some correlation matrix and analyze individual charts. As the dataset has many variables, we will spilt it into different plots. 

```{r error=FALSE}
# Charts for Target_Flage

#for(i in seq(1,40,by=5)){
#chart.Correlation(cbind(df_dummy[,c(i:(i+5))], TARGET_FLAG = #df_dummy[,c('TARGET_FLAG')]),histogram=TRUE,pch=19)
#}



```


Above plots suggests that there are some room for improvemnt by performing binning. 



```{r}
#TARGET_AMT charts

#for(i in seq(1,40,by=5)){
#print(i)
#chart.Correlation(cbind(df_dummy[,c(i:(i+5))], TARGET_AMT = #df_dummy[,c('TARGET_AMT')]),histogram=TRUE,pch=19)
#}


```


