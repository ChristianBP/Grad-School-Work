# Setup
## Install Python Packages
`pip install kafka-python praw pyspark spacy`  
`pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.7.1/en_core_web_sm-3.7.1-py3-none-any.whl`

### Check the Scala version of PySpark
`pyspark --version`

## Install Kafka
[Download a Kafka instance](https://kafka.apache.org/downloads) that has a matching Scala version  
Extract the directory from the file you downloaded and run the following from the new directory:

### Start Zookeeper and Kafka
`bin/zookeeper-server-start.sh config/zookeeper.properties`  
`bin/kafka-server-start.sh config/server.properties`

### Create Topics
`bin/kafka-topics.sh --create --topic post_titles --bootstrap-server localhost:9092`  
`bin/kafka-topics.sh --create --topic post_titles_ents --bootstrap-server localhost:9092`

### List Topics
Make sure the topics were created  
`bin/kafka-topics.sh --bootstrap-server localhost:9092  --list`

## Install Elasticsearch and Kibana
Follow the instructions [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-stack-security.html) up to step 5.\
Skip step 3 and follow the interactive mode instructions in step 5.

### Add a Policy
Once you've opened up Kibana in your browser:
1. In the search bar, find the **Custom Kafka Logs** integration
2. Click **Add Custom Kafka Logs**
3. For **Hosts**, enter `localhost:9092`
4. For **Topics**, enter `post_titles_ents`
5. For **Group ID**, enter `post_titles_ents`
6. Click **Save and continue**
7. Click **Add Elastic Agent later**

## Create an Elastic Agent
1. In the Agents column of your new Integration policy, select **Add agent**
2. Select **Run standalone**
3. Scroll to the bottom and execute all of the commands except `elastic-agent install`
    - For some reason, my download URL had `/downloads/downloads` which I had to trim down to `/downloads` for it to work.
4. Scroll back up to the top and click **Create API Key**
5. Click **Copy to clipboard**
6. Inside the elastic-agent directory from step 3, open elastic-agent.yml, clear it's contents, and replace it with the string you copied to your clipboard.
7. Now run `sudo ./elastic-agent install`
    - For the questions, answer:
        - Yes to run as a service
        - no to enroll this Agent into Fleet

## Create a Reddit App to Interface with the Reddit API
Create a reddit account or login on an existing one.  
Go to https://www.reddit.com/prefs/apps  
Click **are you a developer? create an app...**  
Name the app, select script, and set redirect uri to http://localhost:8080  
Click **create app**  
Find the string labeled **personal use script** under your app name. This is your client id.  
Find the string labeled secret. This will be your client secret.  
Save these values for later.  

# Start the Scripts
Start both of these python scripts in separate terminals with the following flags:

    python "Subreddit Producer.py" --subreddit <subreddit> --client_id <client_id> --client_secret <client_secret> --bootstrap_servers <bootstrap_servers>
    python "Count Named Entities.py" --kafkaJarName <kafkaJarName> --checkpointLocation <checkpointLocation> --bootstrap_servers <bootstrap_servers>

### Parameters
| Parameter | Description | Default | Example |
|---|---|---|---|
| subreddit | The subreddit to read | all | books |
| client_id | Reddit Client ID |  |  |
| client_secret | Reddit Client Secret |  |  |
| bootstrap_servers | Kafka Host Address | localhost:9092 | localhost:9092 |
| kafkaJarName | The jar that matches your Kafka, Scala, and Spark versions |  | org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.3 |
| checkpointLocation | Folder to store checkpoint data in | checkpoints | checkpoints |

# View the Results
## Add an Ingest Pipeline
1. In Kibana, select the three bar menu in the top left
2. Scroll to the bottom and click **Management**
3. Click **Ingest Pipelines**
4. Click **Create pipeline** &rarr; **New pipeline**
5. In Name, put `logs-kafka_log.generic@custom`
6. Click **Add a processor**
    - Select the JSON processor
    - In Field, put `message`
    - Set **Add to root** to true
    - Set **Ignore failures for this processor** to true
    - Click **Add processor**
7. Click **Create pipeline**

## Create Dataview
1. Scroll to the bottom of the menu on the left and, under Kibana, click Data Views
2. Click **Create data view**
    - In Name, put `Post Title ENTs`
    - In **Index pattern**, put `logs-kafka_log.generic-*`
    - Click **Save data view to Kibana**

## Visualize Data
1. In Kibana, select the three bar menu in the top left.
2. Under Analytics, select Dashboards
3. Click **Create dashboard**
4. Click **Create visualization**
5. In the top left, switch the Data View to `Post Title ENTs`
6. Use 'Search field names' to find `named_entity` and drag it out into the visualization area.
7. On the right, click **Top 5 values of named_entity**
    - Set **Number of values** to 10
    - Click **Advanced** and uncheck **Group remaining values as "Other"**
    - Click Close
8. On the right, click **Count of records**
    - For the Field, select `named_entity_count`
    - For the function, select `Maximum`
9. Adjust the timeframe in the top right as desired.

# Uninstall everything
### Elastic Agent
`sudo /usr/bin/elastic-agent uninstall`  
Remove the directory extracted in [Create an Elastic Agent](#create-an-elastic-agent)

### Elasticsearch, Kafka, and Kibana
Shut down the servers and delete the directories extracted in [Install Kafka](#install-kafka) and [Install Elasticsearch and Kibana](#install-elasticsearch-and-kibana)

### Python Packages
`pip uninstall kafka-python`  
`pip uninstall praw`  
`pip uninstall pyspark`  
`pip uninstall spacy`  
`pip uninstall en-core-web-sm`