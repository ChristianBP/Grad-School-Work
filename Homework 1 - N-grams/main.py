import sys

from collections import defaultdict

def train_bigram_model(text):
    # Always start the bigram count with a value of 0 if
    # we aren't smoothing and 1 if we are smoothing
    model = defaultdict(lambda: defaultdict(lambda: 0))
    unigram_set = set(['<start>', '<end>'])

    sentences = text.split('\n')
    for sentence in sentences:
        # Adding start and end tokens to each sentence
        words = ('<start> ' + sentence + ' <end>').split()
        # Start and end tokens are already added to the unigram set
        unigram_set.update(words[1:-1])

        for i in range(len(words)-1):
            first_word = words[i]
            second_word = words[i+1]
            # If the bigram count doesn't exist, then it will be created by the model's lambda and then 1 will be added
            model[first_word][second_word] += 1

    return model, unigram_set

def bigram_counts_or_probabilities(text, smoothing, model, unigram_set, print_probability):
    words = ('<start> ' + text + ' <end>').split()
    word_set = sorted(set(words))
    col_width = max(len(word) for word in word_set) + 1

    # Print the column labels
    print((' ' * col_width) + ''.join(word.ljust(col_width) for word in word_set))

    # Print the rows
    for first_word in word_set:
        # Start with the row label
        row = [first_word.ljust(col_width)]
        for second_word in word_set:
            if first_word in model:
                bigram_count = model[first_word][second_word] if second_word in model[first_word] else 0

                # If the word isn't in the model, the count is 0 even if we're smoothing
                if smoothing:
                    bigram_count += 1

                # If we're printing the probability instead, then we divide
                # the bigram count by the total occurences of the first word in the model
                if print_probability:
                    unigram_count = sum(model[first_word][x] for x in model[first_word])
                    if smoothing:
                        unigram_count += len(unigram_set)
                    bigram_count = 0 if unigram_count == 0 else bigram_count / unigram_count
            else:
                bigram_count = 0

            # Print 4 decimals for the probability but strip off the trailing 0's
            # and the . for numbers like 1.0000 or 23.0000
            row.append(f'{bigram_count:.4f}'.rstrip('0').rstrip('.').ljust(col_width))
        print(''.join(row))
    print()

def total_probability(text, smoothing, model, unigram_set):
    words = ('<start> ' + text + ' <end>').split()
    probability = 1
    for i in range(len(words)-1):
        first_word = words[i]
        second_word = words[i+1]
        unigram_count = sum(model[first_word][x] for x in model[first_word])
        if smoothing:
            unigram_count += len(unigram_set)

        if first_word in model and second_word in model[first_word]:
            bigram_count = model[first_word][second_word]
        else:
            bigram_count = 0

        # If the word isn't in the model, the count is 0 even if we're smoothing
        if first_word in model and smoothing:
            bigram_count += 1

        probability *= 1 if unigram_count == 0 else bigram_count / unigram_count
    return probability

with open(sys.argv[1], 'r') as file:
    text = file.read()

# If argv[2] is 1 then smoothing should be True
smoothing = sys.argv[2] == '1'
model, unigram_set = train_bigram_model(text)

test_sentence_1 = 'mark antony shall say i am not well , and for thy humor , i will stay at home .'
test_sentence_2 = 'talke not of standing . publius good cheere , there is no harme intended to your person , nor to no roman else : so tell them publius zotato'

print('\nBigram counts for sentence 1:')
bigram_counts_or_probabilities(test_sentence_1, smoothing, model, unigram_set, False)
print('\nBigram probabilities for sentence 1:')
bigram_counts_or_probabilities(test_sentence_1, smoothing, model, unigram_set, True)
print('Total probability for sentence 1: ' + str(total_probability(test_sentence_1, smoothing, model, unigram_set)))

print('-' * 150)

print('\nBigram counts for sentence 2:')
bigram_counts_or_probabilities(test_sentence_2, smoothing, model, unigram_set, False)
print('\nBigram probabilities for sentence 2:')
bigram_counts_or_probabilities(test_sentence_2, smoothing, model, unigram_set, True)
if 'zotato' in model:
    print("zotato2")
print('Total probability for sentence 2: ' + str(total_probability(test_sentence_2, smoothing, model, unigram_set)))
if 'zotato' in model:
    print("zotato3")