## DATA622 HW #3
- Assigned on September 27, 2017
- Due on October 11, 2017 11:59 PM EST
- 15 points possible, worth 15% of your final grade

### Instructions:
1. Get set up with free academic credits on both Google Cloud Platform (GCP) and Amazon Web Services (AWS).  Instructions has been sent in 2 separate emails to your CUNY inbox.

2. Research the products that AWS and GCP offer for storage, computing and analytics.  A few good starting points are:
    - [GCP product list](https://cloud.google.com/products/)
    - [AWS product list](https://aws.amazon.com/products)
    - [GCP quick-start tutorials](https://codelabs.developers.google.com/codelabs)
    - [AWS quick-start tutorials](https://aws.amazon.com/getting-started/tutorials/)
    - [Mapping GCP to AWS products Azure](https://stackify.com/microsoft-azure-vs-amazon-web-services-vs-google-compute-comparison/)
    - [Evaluating GCP against AWS](http://blog.armory.io/choosing-between-aws-gcp-and-azure/)


3. Design 2 different ways of migrating homework 2's outputs to *GCP*.  Evaluate the strength and weakness of each method using the Agile Data Science framework.

4. Design 2 different ways of migrating homework 2's outputs to *AWS*.  Evaluate the strength and weakness of each method using the Agile Data Science framework.

### Critical Thinking (8 points total)

- Fill out the critical thinking section by modifying this README.md file.
- If you want to illustrate using diagrams, check out [draw.io](https://www.draw.io/), which has a nice integration with github.

**AWS General**
AWS Pre-steps:

	1. Need an AWS account
	2. Need to create a new keypair(ssh keys). AWS will create a public keypair.
	3. Converting public ssh keys to private ssh keys using putty.

Strengths:

	1. AWS security features are high. It provides the keys and we can connect only with those keys. If we miss the keypair public key, it cannot be downloaded again. New key pair has to be downloaded and assigned to the servers.
	2. AWS web interface is very easy to navigate and understand. 


**AWS Method 1** (2 points)

Title: Run using AWS Datapipeline and EMR

Description: In this method, we will be using AWS datapipeline for the complete process. Below are the steps.

	1. Creating a AWS datapipeline and setting up all the required permissions via IAM and to store logs in S3 objects.
	2. To make this method complex, we are going to assume that the data is streaming data. So to collect the stream of input data we can use AWS Kinesis with the combination of AWS EMR.
	3. Once the data is acquired from the streaming data source, we can store it in S3 bucket.
	4. As this is a data pipeline, we can remove any unused computing resources. In this scenario AWS EMR can be removed after usage.
	5. As part of this pipeline, we can create an EC2 instance and execute the code train_data.py module. This will get the data from S3 bucket and train the model. Output is again stored in S3 bucket. Created EC2 instance has all the python setup which is required to execute the code.
	6. Finally the same or new EC2 instance can be used to run the score-data.py module. This will test using train data and score the model. It also performs any future prediction in new data. So when the new data is released, only this module can be executed and results can be obtained.


Strengths:

	1. Datapipeline is structured. So it is easy to figure out the failure and issue.
	2. We can rerun from one particular module instead of running the whole pipeline.
	3. AWS provides option to stop or terminate the instances after usage. This saves huge amount of money in after executing usage. We don’t need to pay for the instance after usage. 
	4. As this is a fully automated pipeline, there is no manual work involved. It can be scheduled weekly or monthly depending on business needs.

Weakness:

	1. AWS Kinesis currently has a limit of 5 reads per second for one shards. Scalability has some latency compared to apache kafka.
	2. Setting up a datapipeline has little learning curve. It involves various other parts of AWS and ability to write/read the logs in S3 bucket if it fails.
	3. Data pipeline UI is not so intuitive and user friendly to use.

**AWS Method 2** (2 points)
Title: Run using AWS Codepipeline

Description: In this method, we will be using AWS codepipeline for the complete build and execute process. Below are the steps for setup.

	1. Creating a AWS codepipeline and setting up all the required permissions via IAM and to store logs in S3 objects.
	2. Codepipeline fetches the code from Github or from any other repository. For example, lets assume all the code are present in Github. Select the repository and branch in that github account.
	3. Need to select the provider for code build and deployment. No build or deployment option can be used for testing.
	4. Need to review the roles and create the code pipeline. Once we create a pipeline, we can an interface to build the pipeline in UI.
	5. Codepipeline also provides options to run the code AWS Lambda functions. This can be a quick way to write the necessary code and call that particular function directly.
	6. Output data and model is stored in the S3 object. So it can be retrieve in future.
	7. Similarly we can execute other code using lambda functions and generate the score for the training dataset. 

Strengths:

	1. Although codepipeline is actually to test the code and run builds, we can use it to invoke function codes inside the build.
	2. This executes on server less architecture. So there is no need to create EC2 instances for any sort of execution.
	3. AWS lambda free tier includes 1M free requests. These free requests can be u These free requests can be utilized to execute the code completely.

Weakness:

	1. Codepipeline is integrated with code build process. So build or deployment process is mandatory. So we need to setup any build or deployment process around it.
	2. While executing lambda function, we need to convert the entire code into one single function or call different function from one function. It might not be possible at all the times.


**GCP Method 1** (2 points)

Title: Run everything on cloud

Description: In this method, we create a complete environment on cloud. Below are the steps

	1. Create a GCP compute instance. Instance can be according to the needs of the project. For this project we can choose t2.smaller t2.medium size instance.
	2. It would be best to use Ubuntu or any other linux based distribution.
	3. Once the instance is created according to needs, we can login into the system using the console provided by GCP in chrome browser.
	4. Next step is to install software's and write the code. We can perform these software installations directly or install docker and get the required images instantly.
	5. In this step will proceed with docker. Install docker on the ubuntu pc. There are lot of readily available data science images available in online. One such instance is in the link https://hub.docker.com/r/dataquestio/python3-starter/
	6. After creating a container, we can update the required packages in that server.
	7. Once we start the ipython environment in that docker container, we can access the jupyter notebook from any pc. 
	8. We can write the code from scratch or import from github and run it from the python terminal or from ipython environment.
	9. All the code, input data and output data is stored in the container. Performing the complete operations in cloud container and getting the results out of it.
	10. Docker container can also be replaced with anaconda environment. It also contains many pre-installed packages.

Strengths:

	1. By running the code from the container setup in GCP compute instance, we can create new containers and run multiple containers inside one single server. New projects can be created in different container if we need to segregate the environment.
	2. This is an quick and fast method to run the existing code from github. It eliminates all the setup hassle. 

Weakness:

	1. If the server or container got crashed, all the persisted data from that container is gone. There will be no self-healing(It happened lot of times when I tried to setup in smaller CPU instance).
	2. It is not a production like automated system. We need to manually execute or schedule the code to run it.
	3. It is not using streaming data from the systems. There is no external pipeline involved in this process except internal python pipeline.

**GCP Method 2** (2 points)

Title: Run GCP cloud datalab and neural net model in Tensorflow

Description: In this method, we utilize the datalab and ML engine in GCP to run a tensorflow based model on different datasets. Below are the steps to perform it.

	1. As a first step, we need to create an GCP project for executing python code on datalab platform. 
	2. Once we create a project, we can follow list of steps in link to create a VM which runs a docker image. It contains most of the packages which is required for data science activities.
	3. In the datalab environment, we can run the code to fetch the input data and store it in the datalab. All the files are stored in container.
	4. We can also run the different files like pull_data.py, train_data.py and score_data.py from the docker shell. 
	5. For more advanced production like neural network execution, we can generate a pb file of the tensorflow model  and store it in GCP storage bucket.
	6. GCP provides ML engine to run tensorflow algorithm on production scale. PB model file which was generated is used in ML engine.
	7. Jobs can be scheduled for that model and we can predict any future data using that model. 

Strengths:

	1. We can quickly deploy tensorflow models in production environment. 
	2. We can use the power of neural network to perform the classification. 

Weakness:

	1. Only tensorflow models can be deployed. The extension of the file format has to be .pb or .pbtxt. Other models cannot be deployed.
	2. There is no workflow to refresh the model. It has to be manually performed and uploaded into GCP ML Engine.
	3. Tensorflow models are not always excellent at prediction.




### Applied (7 points total)

Choose one of the methods described above, and implement it using your work from homework 2.  Submit screenshots in the *screenshot* folder on this repo to document the completion of your process.
