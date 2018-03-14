#required packages
packages <- c("AppliedPredictiveModeling", "caret", "klaR", "MASS", "pROC","randomForest") 
#, "pastecs"

#see if we need to install any of them
installed_and_loaded <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
}

#excute function and display the loaded packages
data.frame(installed_and_loaded(packages))


set.seed(975)
simulatedTrain <- quadBoundaryFunc(500)
simulatedTest <- quadBoundaryFunc(1000)
head(simulatedTrain)


rfModel <- randomForest(class ~ X1 + X2,
                        data = simulatedTrain,
                        ntree = 2000)

qdaModel <- qda(class ~ X1 + X2, data = simulatedTrain)

qdaTrainPred <- predict(qdaModel, simulatedTrain)
names(qdaTrainPred)


qdaTestPred <- predict(qdaModel, simulatedTest)

simulatedTrain$QDAprob <- qdaTrainPred$posterior[,"Class1"]
simulatedTest$QDAprob <- qdaTestPred$posterior[,"Class1"]


rfTestPred <- predict(rfModel, simulatedTest, type ="prob")
head(rfTestPred)



simulatedTest$RFprob <- rfTestPred[,"Class1"]
simulatedTest$RFclass <- predict(rfModel, simulatedTest)


sensitivity(data = simulatedTest$RFclass,
            reference = simulatedTest$class,
            positive = "Class1")


specificity(data = simulatedTest$RFclass,
            reference = simulatedTest$class,
            negative = "Class2")

# Manual

dim(simulatedTest[simulatedTest$RFclass== simulatedTest$class & simulatedTest$class== 'Class1',])[1]/
dim(simulatedTest[simulatedTest$class== 'Class1',])[1]




dim(simulatedTest[simulatedTest$RFclass== simulatedTest$class & simulatedTest$class== 'Class2',])[1] /
dim(simulatedTest[simulatedTest$class== 'Class2',])[1]




posPredValue(data = simulatedTest$RFclass,
             reference = simulatedTest$class,
             positive = "Class1")



negPredValue(data = simulatedTest$RFclass,
             reference = simulatedTest$class,
             positive = "Class2")



posPredValue(data = simulatedTest$RFclass,
             reference = simulatedTest$class,
             positive = "Class1",
             prevalence = .46)



confusionMatrix(data = simulatedTest$RFclass,
                reference = simulatedTest$class,
                positive = "Class1")




# ROC
rocCurve <- roc(response = simulatedTest$class,
                predictor = simulatedTest$RFprob,
                ## This function assumes that the second
                  ## class is the event of interest, so we
                  ## reverse the labels.
                  levels = rev(levels(simulatedTest$class)))


auc(rocCurve)
ci.auc(rocCurve)
plot(rocCurve, legacy.axes = TRUE)


length(simulatedTest$class)

dim(simulatedTest[simulatedTest$class== 'Class2',])[1]

#Lift

labs <- c(RFprob = "Random Forest",QDAprob = "Quadratic Discriminant Analysis")
liftCurve <- lift(class ~ RFprob + QDAprob, data = simulatedTest,
                    labels = labs)
liftCurve


xyplot(liftCurve, auto.key = list(columns = 2,
                         lines = TRUE,
                         points = FALSE))



calCurve <- calibration(class ~ RFprob + QDAprob, data = simulatedTest)
calCurve


xyplot(calCurve, auto.key = list(columns = 2))

sigmoidalCal <- glm(relevel(class, ref = "Class2") ~ QDAprob,
                    data = simulatedTrain,
                    family = binomial)
coef(summary(sigmoidalCal))



