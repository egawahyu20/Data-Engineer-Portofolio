# Scenario
You are a data engineer at a data analytics consulting company. Your company prides itself in being able to efficiently handle data in any format on any database on any platform. Analysts in your office need to work with data on different databases, and data in different formats. While they are good at analyzing data, they count on you to be able to move data from external sources into various databases, move data from one type of database to another, and be able to run basic queries on various databases.

# Objectives
- replicate a Cloudant database.
- create indexes on a Cloudant database.
- query data in a Cloudant database.
- import data into a MongoDB database.
- query data in a MongoDB database.
- export data from MongoDB.
- import data into a Cassandra database.
- query data in a Cassandra database.

# 1 - Getting the environment ready
## 1.1 - Cloudant database
We need the **couchimport** and **couchexport** tools to move data in and out of the Cloudant database.
```
npm install -g couchimport
```
Verify that the tool got installed, by running the below command on the terminal.
```
couchimport --version
```
Before going ahead set the environment varible CLOUDANTURL to your actual cloudant url from your service credentials.
```
export CLOUDANTURL="URL_HERE"
```
## 1.2 - mongodb database
We  need the **mongoimport** and **mongoexport** tools to move data in and out of the mongodb database.
```
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.3.1.tgz
tar -xf mongodb-database-tools-ubuntu1804-x86_64-100.3.1.tgz
export PATH=$PATH:/home/project/mongodb-database-tools-ubuntu1804-x86_64-100.3.1/bin
echo "done"
```
Verify that the tools got installed, by running the below command on the terminal.

```
mongoimport --version
```
## 1.3 - Export the json into Cloudant Database
* Download [movies.json](Assets/movie.json)
* Create a Non-patitioned database named movies in Cloudant.
* Export the data of the *movie.json* file into Cloudant database **movies**
  ``` 
  curl -XPOST $CLOUDANTURL/movies/_bulk_docs -Hcontent-type:application/json -d @movie.json 
  ```

# 2 - Working with a Cloudant database
You can open [Cloudant](Cloudant.md) to see some cloudant task such as Replicate, Create Index, Write Query and Export using Cloudant API.

# 3 - Working with a MongoDB database
You can open [MongoDB](MongoDB.md) to see some MongoDB task such as Import, Create Index, Write Query, Aggregate and Export.

# 4 - Working with a Cassandra database
