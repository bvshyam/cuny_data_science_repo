## DATA622 HW #2
- Assigned on September 13, 2017
- Due on September 27, 2017 11:59 PM EST
- 15 points possible, worth 15% of your final grade


### Required Reading
Please come to class prepared to discuss.
- Read Chapter 5 of the Deep Learning Book
- Read Chapter 1 of the Agile Data Science 2.0 textbook


### Data Pipeline using Python (13 points total)

Build a data pipeline in Python that downloads data using the urls given below, trains a random forest model on the training dataset using sklearn and scores the model on the test dataset.

#### Scoring Rubric
The homework will be scored based on code efficiency (hint: use functions, not stream of consciousness coding), code cleaniless, code reproducibility, and critical thinking (hint: commenting lets me know what you are thinking!)  

#### Instructions:
tl;dr: Submit the following 5 items on github.  
- ReadMe.md (see "Critical Thinking")
- requirements.txt
- pull_data.py
- train_model.py
- score_model.py

More details:

- <b> requirements.txt </b> (1 point)

This file documents all dependencies needed on top of the existing packages in the Docker Dataquest image from HW1.  When called upon using <i> pip install -r requirements.txt </i>, this will install all python packages needed to run the .py files.  (hint: use pip freeze to generate the .txt file)

- <b> pull_data.py </b> (5 points)

When this is called using <i> python pull_data.py </i> in the command line, this will go to the 2 Kaggle urls provided below, authenticate using your own Kaggle sign on, pull the two datasets, and save as .csv files in the current local directory.  The authentication login details (aka secrets) need to be in a hidden folder (hint: use .gitignore).  There must be a data check step to ensure the data has been pulled correctly and clear commenting and documentation for each step inside the .py file.

    Training dataset url: https://www.kaggle.com/c/titanic/download/train.csv
    Scoring dataset url: https://www.kaggle.com/c/titanic/download/test.csv

- <b> train_model.py </b> (5 points)

When this is called using <i> python train_model.py </i> in the command line, this will take in the training dataset csv, perform the necessary data cleaning and imputation, and fit a classification model to the dependent Y.  There must be data check steps and clear commenting for each step inside the .py file.  The output for running this file is the random forest model saved as a .pkl file in the local directory.  Remember that the thought process and decision for why you chose the final model must be clearly documented in this section.  

- <b> eda.ipynb </b> (0 points)

[Optional] This supplements the commenting inside train_model.py.  This is the place to provide scratch work and plots to convince me why you did certain data imputations and manipulations inside the train_model.py file.

- <b> score_model.py </b> (2 points)

When this is called using <i> python score_model.py </i> in the command line, this will ingest the .pkl random forest file and apply the model to the locally saved scoring dataset csv.  There must be data check steps and clear commenting for each step inside the .py file.  The output for running this file is a csv file with the predicted score, as well as a png or text file output that contains the model accuracy report (e.g. sklearn's classification report or any other way of model evaluation).  


### Critical Thinking (2 points total)

Modify this ReadMe file to answer the following questions directly in place.

1. If I had to join another data source with the training and testing/scoring datasets, what additional data validation steps would I need for the join? (0.5 points)

<b>Answer</b> To join another data source, below are some additional steps which needs to be considered.
a. Need to find a common feature to join the another dataset with the current training and test dataset. One option to perform join is via pandas module. Also there are different types of join. Need to select the join statergy appropriately.
b. Need to validate if there are NaN or NA's in those new features.
c. If there is NA or NaN, for numerical variable, need to find the suitable statergy for updating it (Eg, Mean, median, etc). For text based categorical variable, need to update the most suitable entry or update the most frequently appearing text in it.
d. Convert all the categorical type variables to numeric and add as new columns.
e. Alter any text based columns to numeric features. Or remove the text based columns.
f. Perform Train and Test split on it. Fit the model and validate the dataset.


2. What are some things that could go wrong with our current pipeline that we are not able to address?  For your reference, read [this](https://snowplowanalytics.com/blog/2016/01/07/we-need-to-talk-about-bad-data-architecting-data-pipelines-for-data-quality/) for inspiration. (0.5 points)

<b>Answer</b> Below are some things which can go wrong with current pipeline.
a. Inaccurate imputation: Currently we are performing imputation using mean in Age and most frequent in categorical variables. This might be wrong imputation. Actual data might be different than the current one.
b. Dataset not in proper format: If the dataset is not in the correct format or if the labels does not match the current name, then the pipeline will fail.
c. Currently we have handled the missing data. If the dataset contains some foreign characters, different language characters or binary code the pipeline will fail.
d. If the recording is wrong in the dataset, then the pipeline will not detect that sort of errors.

3. How would you build things differently if this dataset was 1 trillion rows? (0.5 points)

<b>Answer</b> Below are some changes I would have made if it contains 1 trillion rows

a. I would have created a generator function or use chunk size to process the 1 trillion rows.
b. Once the small size is extracted, I would fit the model and do that recurivly until there is no rows left behind.
c. Perform cross validation with random small datasets and fit the model.
d. From the environment pespective, currently I am using Google cloud with 2 CPU to execute this code. I would expand the processing power and storage capacity in the cloud pc to perform operations on 1 trillion rows. By doing that it will be lot faster to fit model and predict the output.


4. How would you build things differently if the testing/scoring dataset was refreshed on a daily frequency? (0.5 points)

<b>Answer</b> Below are some thoughts if testing/scoring dataset was refreshed on daily basis.

a. I would have created a generator function or use chunk size to process to get the new data.
b. Once the new data is cleansed, then the models needs to updated by adding the previous data. Because data behavious may change overtime. But fitting the model on daily basis will cause overfitting. So we might schedule the model refresh on weekly or monthly basis depends on business needs and score.
c. Once the new data model is fit on periodic interval, it is used to test/score the model on daily basis. If the score is less than a threshold level, then the model is retrained to get better output.


