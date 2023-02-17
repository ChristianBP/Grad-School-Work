# Steps to run this program:
1) The training corpus is stored in `training_corpus.txt`
2) To execute the program run `py main.py training_corpus.txt <smoothing>` where <smoothing> is 'True' or 'False' depending on whether you want smoothing to be applied to the model
3) The output will be tables of the bigram counts and probabilities of these sentences:
- mark antony shall say i am not well , and for thy humor , i will stay at home .
- talke not of standing . publius good cheere , there is no harme intended to your person , nor to no roman else : so tell them publius
Followed by the probability of each sentence in their entirety.