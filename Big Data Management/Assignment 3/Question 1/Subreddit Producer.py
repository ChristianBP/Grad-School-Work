from argparse import ArgumentParser
from kafka import KafkaProducer

import praw

# Parse arguments
parser = ArgumentParser()
parser.add_argument("--subreddit", help="Subreddit", default="all")
parser.add_argument("--client_id", help="Client ID", required=True)
parser.add_argument("--client_secret", help="Client Secret", required=True)
parser.add_argument("--bootstrap_servers", help="Bootstrap Servers", default="localhost:9092")
args = parser.parse_args()

subreddit = args.subreddit
client_id = args.client_id
client_secret = args.client_secret
bootstrap_servers = args.bootstrap_servers
user_agent = "bdm_assignment_3_spark_streaming:v1"

# Open Reddit stream
reddit = praw.Reddit(
    client_id=client_id,
    client_secret=client_secret,
    user_agent=user_agent,
)

# Open Kafka producer
producer = KafkaProducer(bootstrap_servers=bootstrap_servers)

# Send post titles to Kafka
for submission in reddit.subreddit(subreddit).stream.submissions():
    producer.send('post_titles', submission.title.encode('utf-8'))