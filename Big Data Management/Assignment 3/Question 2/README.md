# Analyzing Social Networks using GraphX/GraphFrame
## Download Data
Download and extract the [SNAP ego-Twitter dataset](https://snap.stanford.edu/data/twitter.tar.gz).

## Run Queries
Run python with the following flags:

    python twitter_graph.py --graphframesPackageName <graphframesPackageName> --twitterDir <twitterDir> --userId <userId> --checkpoints <checkpoints>

### Parameters
| Parameter | Description | Example |
|---|---|---|
| `--graphframesPackageName` | The GraphFrames package to use (based on your PySpark version). | graphframes:graphframes:0.8.4-spark3.5-s_2.12 |
| `--twitterDir` | The directory that the Twitter dataset was extracted to. | twitter/ |
| `--userId` | The user ID to analyze. <br> Chosen from any filename in the twitterDir. <br> Some of the data may cause errors. <br> I think I resolved them but if there's an error, try a different ID. | 12831 |
| `--checkpoints` | The checkpoint directory for the SparkContext (required for Connected Components). | checkpoints/ |

## Output
Results can be found in the `part-*.csv` files of `output/`