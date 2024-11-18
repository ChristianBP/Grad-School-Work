from argparse import ArgumentParser
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

import spacy

# Parse arguments
parser = ArgumentParser()
parser.add_argument("--kafkaJarName", help="Kafka JAR name", required=True)
parser.add_argument("--bootstrap_servers", help="Bootstrap Servers", default="localhost:9092")
parser.add_argument("--checkpointLocation", help="Checkpoint Location", default="checkpoints")
args = parser.parse_args()

kafkaJarName = args.kafkaJarName
bootstrap_servers = args.bootstrap_servers
checkpointLocation = args.checkpointLocation

# Create a Spark session
spark = SparkSession\
    .builder\
    .master("local")\
    .appName("Reddit NER")\
    .config('spark.jars.packages', kafkaJarName) \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

# Read Post Titles from Kafka
lines = spark\
    .readStream\
    .format("kafka")\
    .option("kafka.bootstrap.servers", bootstrap_servers)\
    .option("subscribe", "post_titles")\
    .load()\
    .selectExpr("CAST(value AS STRING)")

# Use spacy to find ENTs for each line
nlp = spacy.load("en_core_web_sm", exclude=["tok2vec", "tagger", "parser", "attribute_ruler", "lemmatizer"])
def get_ents(text):
    doc = nlp(text)
    return [ent.text for ent in doc.ents]

get_ents_udf = udf(get_ents, ArrayType(StringType()))
ents = lines.withColumn("ent", explode(get_ents_udf("value")))
ent_counts = ents.groupBy("ent").count()

ent_json = ent_counts.selectExpr("ent as named_entity", "count as named_entity_count")

# Write counts to Kafka
query = ent_json\
    .selectExpr("to_json(struct(*)) AS value")\
    .writeStream\
    .outputMode("update")\
    .format("kafka")\
    .option("kafka.bootstrap.servers", bootstrap_servers)\
    .option("topic", "post_titles_ents")\
    .option("checkpointLocation", checkpointLocation)\
    .start()

query.awaitTermination()