import sys
from functions import train_bigram_model, print_bigram_counts_or_probabilities, sentence_probability

with open(sys.argv[1], 'r') as file:
    text = file.read()

# If argv[2] is 1 then smoothing should be True
smoothing = sys.argv[2] == '1'
model, unigram_set = train_bigram_model(text)

test_sentences = [
    'mark antony shall say i am not well , and for thy humor , i will stay at home .',
    'talke not of standing . publius good cheere , there is no harme intended to your person , nor to no roman else : so tell them publius'
]

for i, sentence in enumerate(test_sentences):
    print(f'\nBigram counts for sentence {i+1}:')
    print_bigram_counts_or_probabilities(sentence, smoothing, model, unigram_set, False)

    print(f'\nBigram probabilities for sentence {i+1}:')
    print_bigram_counts_or_probabilities(sentence, smoothing, model, unigram_set, True)

    print(f'Total probability for sentence {i+1}:\n  {sentence_probability(sentence, smoothing, model, unigram_set)}')
    print('-' * 33)