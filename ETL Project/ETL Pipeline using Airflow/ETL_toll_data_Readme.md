# Scenario
You are a data engineer at a data analytics consulting company. You have been assigned to a project that aims to de-congest the national highways by analyzing the road traffic data from different toll plazas. Each highway is operated by a different toll operator with a different IT setup that uses different file formats. Your job is to collect data available in different formats and consolidate it into a single file.

# Objectives
- Extract data from a csv file
- Extract data from a tsv file
- Extract data from a fixed width file
- Transform the data
- Load the transformed data into the staging area

# 1 - Prepare the lab environment

- Start Apache Airflow.
- Download the dataset from the source to the destination mentioned below.
- Source : https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Final%20Assignment/tolldata.tgz
- Destination : /home/project/airflow/dags/finalassignment

# 2 - Create a DAG
## Task 1.1 - Define DAG arguments
>Current PATH: /home/project/airflow/dags/finalassignment/staging

Define the DAG arguments as per the following details:

| **Parameter**    | **Value**                      |
|------------------|--------------------------------|
| owner            | < You may use any dummy name>  |
| start_date       | today                          |
| email            | < You may use any dummy email> |
| email_on_failure | True                           |
| email_on_retry   | True                           |
| retries          | 1                              |
| retry_delay      | 5 minutes                      |

```
default_args = {
    'owner': 'Ega Wahyu',
    'start_date': days_ago(0),
    'email': ['ega@email.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}
```

## Task 1.2 - Define the DAG
Create a DAG as per the following details.
| **Parameter** | **Value**                                |
|---------------|------------------------------------------|
| DAG id        | ETL_toll_data                            |
| Schedule      | Daily once                               |
| default_args  | as you have defined in the previous step |
| description   | Apache Airflow Final Assignment          |

```
dag = DAG(
    'ETL_toll_data',
    schedule_interval=timedelta(days=1),
    default_args=default_args,
    description='Apache Airflow Final Assignment',
)
```

## Task 1.3 - Create a task to unzip data
Create a task named *unzip_data*.

Use the downloaded data from the url given in the first part of this assignment in exercise 1 and uncompress it into the destination directory.
```
unzip_data = BashOperator(
    task_id='unzip_data',
    bash_command='sudo tar -xvzf ../tolldata.tgz -C ..',
    dag=dag,
)
```

## Task 1.4 - Create a task to extract data from csv file
Create a task named *extract_data_from_csv*.

This task should extract the fields **Rowid**, **Timestamp**, **Anonymized Vehicle number**, and **Vehicle type** from the *vehicle-data.csv* file and save them into a file named *csv_data.csv*.

```
extract_data_from_csv = BashOperator(
    task_id='extract_data_from_csv',
    bash_command='sudo cut -f-4 -d"," ../vehicle-data.csv > csv_data.csv',
    dag=dag,
)
```

## Task 1.5 - Create a task to extract data from tsv file
Create a task named *extract_data_from_tsv*.

This task should extract the fields **Number of axles**, **Tollplaza id**, and **Tollplaza** code from the *tollplaza-data.tsv* file and save it into a file named *tsv_data.csv*.
```
extract_data_from_tsv = BashOperator(
    task_id='extract_data_from_tsv',
    bash_command='sudo cut -f5-7 -d$"\t" ../tollplaza-data.tsv > tsv_data.csv',
    dag=dag,
)
```

## Task 1.6 - Create a task to extract data from fixed width file
Create a task named *extract_data_from_fixed_width*.

This task should extract the fields Type of **Payment code**, and **Vehicle Code** from the fixed width file *payment-data.txt* and save it into a file named *fixed_width_data.csv*.

```
extract_data_from_fixed_width = BashOperator(
    task_id='extract_data_from_fixed_width',
    bash_command='awk "{print $(NF-1),$NF}" OFS="," ../payment-data.txt > fixed_width_data.csv',
    dag=dag,
)
```

## Task 1.7 - Create a task to consolidate data extracted from previous tasks

Create a task named *consolidate_data*.

This task should create a single csv file named *extracted_data.csv* by combining data from

- csv_data.csv
- tsv_data.csv
- fixed_width_data.csv
  
The final csv file should use the fields in the order given below:

**Rowid, Timestamp, Anonymized Vehicle number, Vehicle type, Number of axles, Tollplaza id, Tollplaza code, Type of Payment code, and Vehicle Code**

```
consolidate_data = BashOperator(
    task_id='consolidate_data',
    bash_command='sudo paste csv_data.csv tsv_data.csv fixed_width_data.csv > extracted_data.csv',
    dag=dag,
)
```

## Task 1.8 - Transform and load the data
Create a task named *transform_data*.

This task should transform the **vehicle_type** field in *extracted_data.csv* into capital letters and save it into a file named *transformed_data.csv* in the staging directory.

```
transform_data = BashOperator(
    task_id='transform_data',
    bash_command='awk "$5 = toupper($5)" < extracted_data.csv > transformed_data.csv',
    dag=dag,
)
```

## Task 1.9 - Define the task pipeline
Define the task pipeline as per the details given below:

| **Task**    | **Functionality**             |
|-------------|-------------------------------|
| First task  | unzip_data                    |
| Second task | extract_data_from_csv         |
| Third task  | extract_data_from_tsv         |
| Fourth task | extract_data_from_fixed_width |
| Fifth task  | consolidate_data              |
| Sixth task  | transform_data                |

```
unzip_data >> extract_data_from_csv >> extract_data_from_tsv >> extract_data_from_fixed_width >> consolidate_data >> transform_data
```

# 3 - Getting the DAG operational.
## Task 1.10 - Submit the DAG
```
sudo cp ETL_toll_data.py $AIRFLOW_HOME/dags
```
## Task 1.11 - Unpause the DAG
```
airflow dags unpause ETL_toll_data
```
## Task 1.12 - Monitor the DAG
```
airflow dags list
```
