from argparse import ArgumentParser
from pyspark.sql import SparkSession

# Parse arguments
parser = ArgumentParser()
parser.add_argument("--graphframesPackageName", help="Graphframes package name", required=True)
parser.add_argument("--twitterDir", help="Twitter directory", required=True)
parser.add_argument("--userId", type=int, help="User ID", required=True)
parser.add_argument("--checkpoints", help="Checkpoints directory", required=True)
args = parser.parse_args()

graphframesPackageName = args.graphframesPackageName
twitterDir = args.twitterDir
userId = args.userId
checkpoints = args.checkpoints

# Create Spark session with GraphFrames
spark = SparkSession.builder \
    .appName("Q2_Graphframes") \
    .config("spark.jars.packages", graphframesPackageName) \
    .config("spark.sql.caseSensitive", "true") \
    .getOrCreate()

from graphframes import GraphFrame

# Load feature names
featnames = spark.read.csv(f'{twitterDir}/{userId}.featnames', sep=" ", schema="id INT, reference STRING")

# Create schema for vertex properties with feature names as column names
references = featnames.collect()
feat_schema = "id INT" + "".join([f', `{references[i].reference.replace(".", "_")}` INT' for i in range(0, len(references))])

# Load vertices
v = spark.read.csv(f'{twitterDir}/{userId}.feat', sep=" ", schema=feat_schema)

# Load edges
e = spark.read.csv(f'{twitterDir}/{userId}.edges', sep=" ")
e = e.withColumnRenamed("_c0", "src").withColumnRenamed("_c1", "dst")

# Create GraphFrame
g = GraphFrame(v, e)


# 2.3.a
# Out Degrees
outDegrees = g.outDegrees.sort("outDegree", ascending=False).limit(5)

outDegrees.write \
    .mode("overwrite") \
    .option("header", True) \
    .csv("output")


# 2.3.b
# In Degrees
inDegrees = g.inDegrees.sort("inDegree", ascending=False).limit(5)

inDegrees.write \
    .mode("append") \
    .option("header", True) \
    .csv("output")


# 2.3.c
# Page Rank
pageRank = g.pageRank(resetProbability=0.15, maxIter=10)
pageRank = pageRank.vertices.select("id", "pagerank").sort("pagerank", ascending=False).limit(5)

pageRank.write \
    .mode("append") \
    .option("header", True) \
    .csv("output")


# 2.3.d
# Connected Components
spark.sparkContext.setCheckpointDir(checkpoints)

connectedComponents = g.connectedComponents()
connectedComponents = connectedComponents.groupBy("component").count().sort("count", ascending=False).limit(5)

connectedComponents.write \
    .mode("append") \
    .option("header", True) \
    .csv("output")


# 2.3.e
# Triangle Counts
triangleCount = g.triangleCount()
triangleCount = triangleCount.select("id", "count").withColumnRenamed("count", "triangleCount").sort("triangleCount", ascending=False).limit(5)

triangleCount.write \
    .mode("append") \
    .option("header", True) \
    .csv("output")