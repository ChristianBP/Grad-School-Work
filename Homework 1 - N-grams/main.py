import sys
import re

from collections import defaultdict

def train_bigram_model(text, smoothing):
    # Using a default dict with a lambda returning 1 means every bigram 
    # starts with a value of 1 which is exactly what we want for smoothing
    model = defaultdict(lambda: defaultdict(lambda: 1)) if smoothing else defaultdict(dict)

    sentences = text.split('\n')
    for sentence in sentences:
        # Adding start and end tokens to each sentence
        words = ('<start> ' + sentence + ' <end>').split()
        for i in range(len(words)-1):
            first_word = words[i]
            second_word = words[i+1]

            # If we're using smoothing, we don't want to set the bigram value to 1,
            # we want the lambda to generate a 1 and then add 1 to that
            # If we aren't using smoothing, and the second word isn't in
            # the first word's bigram dict, then we need to initialize it to 1
            if not smoothing and second_word not in model[first_word]:
                model[first_word][second_word] = 1
            else:
                model[first_word][second_word] += 1
    return model

def bigram_counts(text, model):
    words = ('<start> ' + text + ' <end>').split()
    for i in range(len(words)-1):
        first_word = words[i]
        second_word = words[i+1]
        if first_word in model and second_word in model[first_word]:
            print(f'{first_word} {second_word}: {model[first_word][second_word]}')
        else:
            print(f'{first_word} {second_word}: 0')



with open(sys.argv[1], 'r') as file:
    text = file.read()

model = train_bigram_model(text, sys.argv[2] == 'True')

test_sentence_1 = 'mark antony shall say i am not well , and for thy humor , i will stay at home .'
test_sentence_2 = 'talke not of standing . publius good cheere , there is no harme intended to your person , nor to no roman else : so tell them publius'
print('Bigram counts for test sentence 1:')
bigram_counts(test_sentence_1, model)
print()
print('Bigram counts for test sentence 2:')
bigram_counts(test_sentence_2, model)