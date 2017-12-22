
# This program validates the model and predicts the future outcomes on test dataset


from sklearn.metrics import classification_report, roc_curve, roc_auc_score
from sklearn.metrics import confusion_matrix
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import scale,StandardScaler
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.preprocessing import FunctionTransformer
import pickle
import dill
import os



# Function which validates the test dataset:


def validation_report(titanic_test,model):
    
    """This function scores the test dataset and validates it. It also predicts for score(orginal titanic test) dataset"""
    y_test_pred = model.predict(titanic_test)
    y_test = titanic_test.Survived
    
    with open("../Output/classification_report.txt",'w') as write_file:
        
        # Score of Test dataset
        write_file.write("\n\nScore of the model using Test dataset: {}".format(model.score(titanic_test.drop(['Survived'],axis=1),titanic_test.Survived)))
        
        # Confusion Matrix for test dataset
        write_file.write("\n\nConfusion Matrix of Test dataset:\n {0}".format(confusion_matrix(y_test,y_test_pred)))
        
        # Classification Report
        write_file.write("\n\nClassification Matrix of Test dataset:\n {0}".format(classification_report(y_test,y_test_pred)))
        
    # Score of Test dataset
    print("\nScore of the model using Test dataset: {}".format(model.score(titanic_test.drop(['Survived'],axis=1),titanic_test.Survived)))
    
    # Confusion Matrix for test dataset
    print("\nConfusion Matrix of Test dataset:\n {0}".format(confusion_matrix(y_test,y_test_pred)))
    
    # Classification Report
    print("\nClassification Matrix of Test dataset:\n {0}".format(classification_report(y_test,y_test_pred)))
    
    y_pred_prob = model.predict_proba(titanic_test.drop(['Survived'],axis=1))[:,1]
    
    # ROC Curve
    fpr, tpr, thresholds = roc_curve(y_test,y_pred_prob)
    
    # Below code works only in ipython. Uncomment to use in ipython
    #plt.plot(fpr, tpr, label = "ROC Classification")
    #plt.plot([0,1],[0,1],'k--')
    #plt.xlabel("False Positive Rate")
    #plt.ylabel("True Positive Rate")
    #plt.title('Classification ROC Curve')
    #plt.savefig('../Output/ROC_Curve.png')
    #plt.show()    
    
    # Area Under the Curve
    print("\nArea Under the Curve:{0}".format(roc_auc_score(y_test,y_pred_prob)))
    
    


# Kaggle submission


def export_output(y_score_pred):
    
    """This funcion creates the final Output CSV which needs to be submitted to Kaggle competition"""
    final_output = pd.DataFrame(titanic_score.iloc[:,0])
    final_output['Survived'] = y_score_pred
    final_output.to_csv('../Data/kaggle_submission.csv',index_label=False,index=False)
    print("Output file for Kaggle submission stored as CSV!")


# Main function which calls other functions.


if __name__ =="__main__":
    
    # Load Titanic Validation data(Hold out) which was stored before
    try:
        with open("../generated_files/titanic_test.pkl",'rb') as read_file:
            titanic_test = pickle.load(read_file)
        
        with open("../generated_files/model.pkl",'rb') as read_file:
            model = dill.load(read_file)
        
        titanic_score = pd.read_csv('../Data/test.csv',sep=",")
    except: 
        print("Error in file format")
    
    print("Below is the model wich is created:\n\n {}".format(model))
    
    if not os.path.exists('../Output'):
        os.makedirs('../Output')
    
    validation_report(titanic_test, model)
        
    y_score_pred = model.predict(titanic_score)
    
    #Export as CSV
    export_output(y_score_pred)

