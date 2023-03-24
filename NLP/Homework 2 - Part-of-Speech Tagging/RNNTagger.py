import numpy as np
import tensorflow as tf
from keras.models import Sequential
from keras.layers import InputLayer, Activation
from keras.layers import Dense, LSTM, InputLayer, Bidirectional, TimeDistributed, Embedding
from keras.optimizers import Adam
from keras.utils import pad_sequences as pad

import os

def load_corpus(path):
    corpus = []
    for filename in os.listdir(path):
        with open(os.path.join(path, filename), 'r') as file:
            text = file.read()
            sentences = text.split('\n')
            for sentence in sentences:
                words = sentence.split()
                if len(words):
                    corpus.append([tuple(word.split('/')) for word in words])
    return corpus

# Load corpus
sentences = load_corpus('modified_brown')

# Create the dataset with train_X (words) and train_y (tag).
train_X, train_y = list(), list()
word2idx = {'PAD': 0, 'UNK': 1}
tag2idx = {'PAD': 0}

for sentence in sentences:
    word_keys = []
    tag_keys = []
    for word, tag in sentence:
        if word not in word2idx:
            word2idx[word] = len(word2idx)
        if tag not in tag2idx:
            tag2idx[tag] = len(tag2idx)
        word_keys.append(word2idx[word])
        tag_keys.append(tag2idx[tag])
    train_X.append(word_keys)
    train_y.append(tag_keys)



# Pad the sequences with 0s to the max length.
# Use MAX_LENGTH to record length of longest sequence
train_X = pad(train_X, padding='post')
train_y = pad(train_y, padding='post')
MAX_LENGTH = train_X.shape[1]



# Define the Keras model.
model = Sequential()
model.add(InputLayer(input_shape=(MAX_LENGTH, )))
model.add(Embedding(len(word2idx), 128))
model.add(Bidirectional(LSTM(256, return_sequences=True)))
model.add(TimeDistributed(Dense(len(tag2idx))))
model.add(Activation('softmax')) # More options: relu, sigmoid, tanh, softmax
model.compile(loss='categorical_crossentropy', optimizer=Adam(learning_rate=0.013))
print (model.summary())

# Trains the model.
# Fit the data into the Keras model, through 40 passes (epochs) using model.fit()
model.fit(train_X, tf.one_hot(train_y, len(tag2idx)), batch_size=128, epochs=40, validation_split=0.2)
    

# Test the model
test_sentences = [
        'the planet jupiter and its moons are in effect a mini solar system .'.split(),
        'computers process programs accurately .'.split()
    ]

# Convert words to their indexes
idx_sentences = []
for sentence in test_sentences:
    indexed_sentence = []
    for word in sentence:
        if word in word2idx:
            indexed_sentence.append(word2idx[word])
        else:
            indexed_sentence.append(word2idx['UNK'])
    idx_sentences.append(indexed_sentence)
# Add padding
idx_sentences = pad(idx_sentences, maxlen=MAX_LENGTH, padding='post')

# Predict
predictions = model.predict(idx_sentences)

# Convert tag indexes back to tags and print the sentence followed by it's tags
idx2tag = {v: k for k, v in tag2idx.items()}
for i, sentence in enumerate(predictions):
    # Print the sentence
    print('\n')
    for word in test_sentences[i]:
        print(word, end=' ')
    print()

    # Convert tag indexes to tags
    tags = []
    for tag_index in sentence:
        tags.append(idx2tag[np.argmax(tag_index)])

    # Remove the padding from the end of the sentence and then print
    while len(tags) > 0 and tags[-1] == 'PAD':
        tags.pop()
    for tag in tags:
        print(tag, end=' ')