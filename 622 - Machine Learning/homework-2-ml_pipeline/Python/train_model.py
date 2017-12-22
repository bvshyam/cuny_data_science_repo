
# This program will train the model and store the model in a pkl file.


import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.ensemble import RandomForestClassifier
#from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import scale,StandardScaler
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.preprocessing import FunctionTransformer
import pickle
import dill
import os


# Function to drop variables and impute text 

def impute_text(X):
    """This function is used in pipeline. It gets the input as dataframe and drops unwanted columns. It also fills the NaN of
    categorical or text columns with the frequently apearing text. Finally it converts text variables to numeric values.
    """
    # Drop unwanted columns
    titanic_dropped = X.drop(['PassengerId','Name','Ticket'],axis=1)
    # Create dummies and fill NaN
    titanic_dummies = pd.get_dummies(titanic_dropped[['Pclass','Sex','Embarked']].apply(lambda x: x.fillna(x.value_counts().index[0])))
    titanic_clear = pd.concat([X[['Cabin','Age','Fare']], titanic_dummies],axis=1)
    return(titanic_clear)


# Perform imputation function

def impute_num(X):
    """This function is used in pipleine. It is used to transform Age value to mean"""
    X.Age = X.Age.replace(np.nan,np.mean(X.Age))
    return(X)


# Adding different features

def cabin_feature(X):
    """This function is used in pipleine. Convert to Cabin text to 0 or 1. 0 if Cabin is Nan. Else 1"""
    X.Cabin = X.Cabin.apply(lambda x: 0 if x is np.nan else 1)
    return(X)


# Main function which loads the datasets and calls other functions


if __name__=="__main__":
    
    # Load Titanic Train data which was stored before
    try:
        titanic = pd.read_csv('../Data/train.csv',sep=",",)
        # Load Titanic Validation data(Hold out) which was stored before
        #titanic_test = pd.read_csv('../Data/test.csv',sep=",")
    except FileNotFoundError:
        print("File Not found error! Please check the directory!")
    except: 
        print("Error in file format")
    
    # Split the data between Train and test dataset. Have given a test size of 20% and Random state of 40
    X_train, X_test, y_train, y_test = train_test_split(titanic.drop(['Survived'], axis=1),                                         titanic['Survived'],test_size=0.2, random_state=40)
    
    print("Dataset split performed successfully")
    
    # Create function transformer functions
    impute_text_ft = FunctionTransformer(impute_text, validate=False)
    impute_num_ft = FunctionTransformer(impute_num, validate=False)
    cabin_feature_ft = FunctionTransformer(cabin_feature, validate=False)
    
    # Creating list of steps to build a pipeline
    steps = [('impute_text_nm',impute_text_ft),
         ('impute_num_nm',impute_num_ft),
         ('cabin_feature_nm',cabin_feature_ft),
         ('impute',Imputer()),
         ('clf',RandomForestClassifier()
         )]
    
    
    
    # List of parameters for the above steps. We can give various parameters depending on algorithm.
    parameters = {'clf__n_estimators':np.arange(20,25),'clf__max_depth':[1,2]}
    
    # Finally clreating a pipeline of all the steps
    pl = Pipeline(steps)
    print("Pipeline object created sucessfully")
    
    # Creating a Grid search object with Cross validation
    cv = GridSearchCV(pl, param_grid = parameters)
    
    try:
        # Fitting a model in training dataset
        cv.fit(X_train,y_train)
        print("Successfully trained the algorithm")
        # Predicting the test dataset
        y_pred = cv.predict(X_test)
        # Calculating the score of test dataset
        print("Score of test dataset: {}".format(cv.score(X_test,y_test)))
    except:
        print("Error while fitting and predicting model. Please check data and correct it!")

    
    export_df = X_test.copy()
    export_df['Survived'] = y_test
    
    if not os.path.exists('../generated_files'):
        os.makedirs('../generated_files')
    
    # Final test dataset Output is stored as a pickle
    with open("../generated_files/titanic_test.pkl",'wb') as output_file:
        pickle.dump(export_df,output_file)
    print("Test dataset file stored as Pickle!")
    
    with open("../generated_files/model.pkl",'wb') as model_file:
        dill.dump(cv,model_file)
    print("Model output file stored as Pickle!")
    
        

