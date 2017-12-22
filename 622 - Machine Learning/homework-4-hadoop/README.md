## DATA622 HW #4
- Assigned on October 11, 2017
- Due on October 25, 2017 11:59 PM EST
- 15 points possible, worth 15% of your final grade

### Instructions:

Use the two resources below to complete both the critical thinking and applied parts of this assignment.

1. Listen to all the lectures in Udacity's [Intro to Hadoop and Mapreduce](https://www.udacity.com/course/intro-to-hadoop-and-mapreduce--ud617) course.  

2. Read [Hadoop A Definitive Guide Edition 4]( http://javaarm.com/file/apache/Hadoop/books/Hadoop-The.Definitive.Guide_4.edition_a_Tom.White_April-2015.pdf), Part I Chapters 1 - 3.

### Critical Thinking (10 points total)

Submit your answers by modifying this README.md file.

1. (1 points) What is Hadoop 1's single point of failure and why is this critical?  How is this alleviated in Hadoop 2?

Hadoop 1's single point of failure is NameNode. It is also called as master node. It is critical in a hadoop environment because of following points in first version.
    a. It stores the metadata about files and blocks on worker nodes.
    b. It manages all the worker node resources.
    c. It also keeps track of all the replica of all the files in worker nodes.

In Hadoop 1.x version, NameNode is a single point of failure. It means, if the NameNode goes down, the entire system will be inaccessible. Because there is no other server which keeps track of worker nodes. In Hadoop 2.x+ versions, there is a secondary or backup NameNode. If the primary NameNode goes down, the secondary server will pickup the task of managing worker nodes.

2. (2 points) What happens when a data node fails?

Data node stores all the data via blocks. There are series of steps are followed if data node fails in hadoop 2.

    a. As a first step it is notified to the Resource manager or Yarn. And then it is notified to NameNode with the block report.
    b. NameNode waits for certain amount of time and the data node is marked as dead.
    c. As the system is underreplicated, it begins replicating the blocks on the dead data node to other data nodes. It is done using other datanodes which as the replica of failed data node.
    d. Until there is a heartbeat from dead data node, the NameNode will not replicate or communicate the failed data node.

3. (1 point) What is a daemon?  Describe the role task trackers and job trackers play in the Hadoop environment.

On a high-level daemon is a just a program which is running on all the nodes. It performs different functions in the cluster. Datanode daemons are managed by name node daemons. 

Job tracker generally runs on name node or any other node which receives the status of task tracker jobs. It monitors all the individual task tracker jobs and submits the overall status of the job back to the client. It is responsible for the the map reduce execution. If it fails, system will not be able to execute map reduce tasks.

Task Tracker runs on data nodes and the jobs executed in data nodes are tracked by task trackers. Task tracker will be assigned to mapper and reducer tasks to execute by job tracker. Overall status is submitted to job tracker from each data node. If one tasks tracker fails in data node, it uses another task tracker from another data node.

4. (1 point) Why is Cloudera's VM considered pseudo distributed computing?  How is it different from a true Hadoop cluster computing?

Currenly used Cloudera's VM is considered as psedo distributed computing because all the nodes and dameons are created within one single machine or server. An ideal production cluster will contain several different servers which performs distributed processing/computing instead of one single server. Jobs are executed parallelly to complete a particular task. Final output is a combination of the output from all the data nodes.

5. (1 point) What is Hadoop streaming? What is the Hadoop Ecosystem?

Hadoop streaming allows to create the mapper/reducer code in other languages than Java. When the hadoop streaming mapper script is executed, each mapper task will launch the script as separate process. As the mapper task runs, it converts its inputs into lines and feed the lines as standard input. Mapper collects the line oriented outputs and converts to key/value pair as the output of mapper. Similarly reducer is run which has the data input from mapper standard output key/value pairs.

Hadoop ecosystem is a collection of different tools used for job execution. It contains of name nodes, data nodes, yarn, oozie, pig, hive, impala, spark, zookeeper, etc. All these tools are used to run hadoop jobs in an effecient manner by utilizing all the resources on a fault tolerant way.

6. (1 point) During a reducer job, why do we need to know the current key, current value, previous key, and cumulative value, but NOT the previous value?

In the reducer job, we need to calculate the final value of each store/product/key. To create a final summary, we need the cumulative value of that particular key and the previous key to see if it is same or different key. If it is same as the current key, we can add the current value to the previous cumulative value. As long as we maintain the cumulative value, we dont need previous value of all the keys.

Eg:
key1 - 10
key2 - 20
key1 - 30
key1 - 40

If we maintain key1 cumulative value, we dont need to maintain all the values of the same key.

7. (3 points) A large international company wants to use Hadoop MapReduce to calculate the # of sales by location by day.  The logs data has one entry per location per day per sale.  Describe how MapReduce will work in this scenario, using key words like: intermediate records, shuffle and sort, mappers, reducers, sort, key/value, task tracker, job tracker.  

Below are the steps to be followed.

    a. As a first step, the logs data needs to be transferred to HDFS file system using -put command.
    b. As part of the mapper task, the program should be created to clean the log files and fetch the mandatory columns like date, location, sale and amount.
    c. Once the mapper program is created, the reducer program has to be created depending on business needs.
        Sales summary for each location per day.
        Summary for each sale item across all the stores in a day.
        Summary of all the sales on one single day.
    d. Once the business logic is selected for reducer program, the key and summary value is calcuated in the program.
    e. Validation of these mapper/reducer program will be performed locally using a small dataset.
    f. Once tested, hadoop streaming job is called. Below is the sample call
    
    hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.6.0-mr1-cdh5.7.0.jar -mapper mapper.py -reducer reducer.py -file mapper.py -file reducer.py -input myinput -output output2
    
    g. Above command starts a hadoop streaming job. All the mapper task will launch in the data nodes. Job tracker will create a job for this task. This task will be shuffled and assigned to task tracker.
    h. Task tracker executes the tasks in data nodes and submits the final status to job tracker. Job tracker consolidates the all the results of mapper task.
    i. In the meantime, job tracker creates another job for reduce task. The data from mapper in format of key/value is sorted and fed to reducer program via hadoop streaming.
    j. Status of the reducer task is finally communicated by job tracker. Results of the reducer is stored in HDFS.
    


### Applied (5 points total)

Submit the mapper.py and reducer.py and the output file (.csv or .txt) for the first question in lesson 6 for Udacity.  (The one labelled "Quiz: Sales per Category")  Instructions for how to get set up is inside the Udacity lectures.  
