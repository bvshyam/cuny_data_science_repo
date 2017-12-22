## DATA622 HW #5
- Assigned on October 25, 2017
- Due on November 15, 2017 11:59 PM EST
- 15 points possible, worth 15% of your final grade

### Instructions:

Read the following:
- [Apache Spark Python 101](https://www.datacamp.com/community/tutorials/apache-spark-python)
- [Apache Spark for Machine Learning](https://www.datacamp.com/community/tutorials/apache-spark-tutorial-machine-learning)

Optional Readings:
- [Paper on RDD](https://www.usenix.org/system/files/conference/nsdi12/nsdi12-final138.pdf)
- [Advanced Analytics with Spark: Patterns for Learning from Data at Scale, 2nd Edition](https://www.amazon.com/_/dp/1491972955), Chapters 1 - 2

Additional Resources:
- [Good intro resource on PySpark](https://annefou.github.io/pyspark/slides/spark/#1)
- [Spark The Definitive Guide](https://github.com/databricks/Spark-The-Definitive-Guide)
- [Google Cloud Dataproc, Spark on GCP](https://codelabs.developers.google.com/codelabs/cloud-dataproc-starter/)


### Critical Thinking (8 points total)

1. (2 points) How is the current Spark's framework different from MapReduce?  What are the tradeoffs of better performance speed in Spark?

Below are some difference between current spark framework and MapReduce.

    1. MapReduce runs on disks. For each transformations it is stored on disk. Spark on other hand stores data and transformations in RDD format. 
    2. If the data gets lost, it can be easily reproduced in spark. If data is lost on MapReduce, then all the process needs to be executed again to store back in disks.
    3. Spark leverages in-memory and disks. If it cannot fit all the data in in-memory, then it spills it over to disk. MapReduce has only disk based operations.
    4. Spark can run with or without Hadoop framework and it can run locally. MapReduce requires a hadoop instance to execute the jobs.
 
Tradeoffs:

    1. Spark is to 10 to 100x times faster than MapReduce.
    2. For better performance in spark, we need good memory. Although it can run in available memory, it provides good performance on when the cluster has huge memory.
 
 
2. (2 points) Explain the difference between Spark RDD and Spark DataFrame/Datasets.

Spark RDD:
    
    1. This is core building blocks of Spark. Dataframes and Datasets uses RDD under the hood.
    2. RDD is lazily evaluated. It is exposed to lambda functions.
    3. RDD can be easily cached if the same set of data needs to be recomputed.
    4. It provides Type-safety. 
    5. It is developer friendly. But it is difficult to use commercially in BI tools. Does not have any SQL syntax.
    6. It just works as per code. It does not evaluate the performance of queries and tune it. So it suffers from performance limitations. 
    7. Serializations is expensive when data grows. 
    
Spark DataFrames:

    1. Dataframes are like tables in database or like pandas dataframes.
    2. Dataframes is an abstraction which gives a schema view of data.
    3. Dataframes are also lazy triggered. 
    4. Performance is improved compared to RDD using Custom memory management and optimized execution plans.
    5. Optimized execution plans provide intelligent set of rules to improve performance.
    6. It can be queried and used using familier SQL syntax or using expression builder. And can be accessed by BI tools using SQL syntax.
    7. On the downside, it is lack of type safety. Referring attribute by string names means no compile time safety. So things can fail in runtime.

Spark Datasets:

    1. Datasets is an extension to Dataframe API and provides RDD functionalities.
    2. It provides compile time safety like RDD and performance boosting features of Dataframe(like catalyst optimiser).
    3. It also provides additional featues called as encoders.
    4. As it contains the best of RDD and Dataframe, this API will be used in near future of spark.

3. (1 point) Explain the difference between SparkML and Mahout.  

SparkML:

    1.SparkML is the machine learning framework and libraries where are build on top of Spark.
    2. Performance of SparkML is lot faster than Mahout implementation on a distributed systems.
    3. SparkML uses RDD under the hood for all machine learning exectuions.
 
Mahout:
    
    1. This library was the intial version of machine learning framework using MapReduce on hadoop.
    2. Library was scalable in distributed system except the performance was very slow compared to SparkML.
    3. Current version of Mahout samsara provides an option to run the ML jobs against spark. So the performance is faster. 
    4. Although ML jobs can run on spark, the community of Mahout is not growing like SparkML(From online forums and activity).

4. (1 point) Explain the difference between Spark.mllib and Spark.ml.

Spark.mllib:

    1. This is the original implementation of ML libraries using Spark RDDs.
    2. It is old and has more features. These features will be migrated to spark.ml
    
Spark.ml:

    1. This is the latest version of ML libraries using spark dataframes.
    2. It has new ML pipeline features and easier to construct.
    3. All the Spark.mllib will be migrated to Spark.ml in future.

4. (2 points) Explain the tradeoffs between using Scala vs PySpark.

Below are some tradeoffs:

    1. Scala is atleast 5-10 times faster than python. Because spark is build on top of Scala.
    2. Scala supports powerful concurrency. Python does not support true multithreading.
    3. Scala is statically typed langague. Python is dynamically typed langugae.
    4. Scala lacks visualizations and libraries for data transformation. Python has several libraries for ML and NLP.
    5. Python has less learning curve than scala.
    

### Applied (7 points total)

Submit your Jupyter Notebook from following along with the code along in [Apache Spark for Machine Learning](https://www.datacamp.com/community/tutorials/apache-spark-tutorial-machine-learning)
