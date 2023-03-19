from collections import defaultdict

def train_bigram_model(text):
    # Always start the bigram count with a value of 0
    model = defaultdict(lambda: defaultdict(lambda: 0))
    unigram_set = set(['<start>', '<end>'])

    sentences = text.split('\n')
    for sentence in sentences:
        # Add start and end tokens to each sentence and split the words on any white space
        words = ('<start> ' + sentence + ' <end>').split()
        # Start and end tokens are already added to the unigram set so just add everything in the middle
        unigram_set.update(words[1:-1])

        for i in range(len(words)-1):
            first_word = words[i]
            second_word = words[i+1]
            # If the bigram count doesn't exist, then it will be created by the model's lambda and then 1 will be added
            model[first_word][second_word] += 1

    return model, unigram_set

def print_bigram_counts_or_probabilities(sentence, smoothing, model, unigram_set, print_probability):
    words = ('<start> ' + sentence + ' <end>').split()
    word_set = sorted(set(words))

    col_width = max(len(word) for word in word_set) + 1
    print('-' * (len(word_set)+1) * col_width)
    # Print the column labels
    print((' ' * col_width) + ''.join(word.ljust(col_width) for word in word_set))

    # Print the rows
    for first_word in word_set:
        # Start with the row label
        row = [first_word.ljust(col_width)]
        for second_word in word_set:
            bigram_count = 0
            unigram_count = 0

            # Get the bigram and unigram counts from the model if they exist
            if first_word in model:
                unigram_count += sum(x for x in model[first_word].values())
                if second_word in model[first_word]:
                    bigram_count = model[first_word][second_word]
            elif smoothing:
                unigram_count += 1

            if smoothing:
                bigram_count += 1
                unigram_count += len(unigram_set)

            if print_probability and bigram_count != 0:
                bigram_count /= unigram_count

            # Print 4 decimals for the probability but strip off the trailing 0's
            # and the . for numbers like 1.0000 or 23.0000
            row.append(f'{bigram_count:.4f}'.rstrip('0').rstrip('.').ljust(col_width))
        print(''.join(row))
    print('-' * (len(word_set)+1) * col_width)

def sentence_probability(sentence, smoothing, model, unigram_set):
    words = ('<start> ' + sentence + ' <end>').split()
    sentence_probability = 1

    for i in range(len(words)-1):
        first_word = words[i]
        second_word = words[i+1]
        bigram_count = 0
        unigram_count = 0

        # Get the bigram and unigram counts from the model if they exist
        if first_word in model:
            unigram_count = sum(model[first_word][x] for x in model[first_word])
            if second_word in model[first_word]:
                bigram_count = model[first_word][second_word]

        if smoothing:
            bigram_count += 1
            unigram_count += len(unigram_set)

        # If there is ever a bigram count of 0 then the whole sentence has a probability of 0%
        if bigram_count == 0:
            return 0
        
        sentence_probability *= bigram_count / unigram_count
    return sentence_probability

