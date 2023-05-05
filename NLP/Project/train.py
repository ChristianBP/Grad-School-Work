import tensorflow as tf
import tensorflow_hub as hub
import tensorflow_text
import numpy as np
import os
from keras.models import Sequential
from keras.layers import InputLayer, Activation
from keras.layers import Dense, LSTM, InputLayer, GlobalAveragePooling1D, Bidirectional, TimeDistributed, Embedding
from keras.optimizers import Adam

import data_helpers
import utils

import matplotlib.pyplot as plt

from sklearn.metrics import accuracy_score, confusion_matrix, precision_recall_fscore_support

# x_text is the sentences; cleaned, tokenized, and in list form
# y is the labels; one hot encoded
x_text, y, max_sentence_length = data_helpers.load_data_and_labels('SemEval2010_task8_all_data/SemEval2010_task8_training/TRAIN_FILE.TXT', True)

# Build vocabulary
# Example: x_text[3] = "A misty <e1>ridge</e1> uprises from the <e2>surge</e2>."
# ['a misty ridge uprises from the surge <UNK> <UNK> ... <UNK>']
# =>
# [27 39 40 41 42  1 43  0  0 ... 0]
# dimension = max_sentence_length

# tokenizer = tf.keras.preprocessing.text.Tokenizer(num_words=max_sentence_length)
# # Selects keys to all tokens in text
# tokenizer.fit_on_texts(x_text)
# # Converts the text into key form
# x = tokenizer.texts_to_sequences(x_text)
# x = tf.keras.preprocessing.sequence.pad_sequences(x, maxlen=max_sentence_length)

# print("Text Vocabulary Size: {:d}".format(len(tokenizer.word_index) + 1))
# print("x shape = {0}".format(x.shape))
# print("y shape = {0}".format(y.shape))
# print("")

# Randomly shuffle data to split into train and test(dev)
# Result is the tokenized sentences shuffled
np.random.seed(10)
shuffle_indices = np.random.permutation(np.arange(len(y)))
x_shuffled = x_text[shuffle_indices]
y_shuffled = y[shuffle_indices]

# Split train/test set
# TODO: This is very crude, should use cross-validation
dev_sample_percentage = 0.1
dev_sample_index = -1 * int(dev_sample_percentage * float(len(y)))
x_train, x_dev = x_shuffled[:dev_sample_index], x_shuffled[dev_sample_index:]
y_train, y_dev = y_shuffled[:dev_sample_index], y_shuffled[dev_sample_index:]
print("Train/Dev split: {:d}/{:d}\n".format(len(y_train), len(y_dev)))

# Define the Keras model.

# model = Sequential()
# model.add(InputLayer(input_shape=(x_train.shape[1], )))
# model.add(Embedding(len(tokenizer.word_index) + 1, 128))
# model.add(Bidirectional(LSTM(256, return_sequences=True)))
# model.add(TimeDistributed(Dense(y_train.shape[1])))
# model.add(GlobalAveragePooling1D())
# model.add(Activation('softmax')) # More options: relu, sigmoid, tanh, softmax

bert_preprocess_model = hub.KerasLayer('https://tfhub.dev/tensorflow/bert_en_uncased_preprocess/3')
bert_model = hub.KerasLayer('https://tfhub.dev/tensorflow/small_bert/bert_en_uncased_L-4_H-512_A-8/1')
test_text = ['nice movie indeed', 'I love python programming']

text_input = tf.keras.layers.Input(shape=(), dtype=tf.string, name='text')
preprocessed_text = bert_preprocess_model(text_input)
outputs = bert_model(preprocessed_text)

l = Bidirectional(LSTM(256, return_sequences=True))(outputs['sequence_output'])
l = TimeDistributed(Dense(y_train.shape[1]))(l)
l = GlobalAveragePooling1D()(l)
l = Activation('softmax')(l)

model = tf.keras.Model(inputs=[text_input], outputs=[l])

model.compile(loss='categorical_crossentropy', optimizer=Adam(learning_rate=3e-5), metrics=['accuracy', tf.keras.metrics.Recall(), tf.keras.metrics.Precision()])

# Trains the model.
# Fit the data into the Keras model, through 40 passes (epochs) using model.fit()
history = model.fit(x_train, y_train, batch_size=64, epochs=20, validation_data=(x_dev, y_dev))

x_test, y_test, _ = data_helpers.load_data_and_labels('SemEval2010_task8_all_data/SemEval2010_task8_testing_keys/TEST_FILE_FULL.TXT', False)
# x_test = tokenizer.texts_to_sequences(x_test)
# x_test = tf.keras.preprocessing.sequence.pad_sequences(x_test, maxlen=max_sentence_length)

# Predict
predictions = model.predict(x_test)
truths = np.argmax(y_test, axis=1)
predicted_labels = np.argmax(predictions, axis=1)

prediction_path = os.path.join("", "predictions.txt")
truth_path = os.path.join("", "ground_truths.txt")

with open(prediction_path, 'w') as prediction_file:
    for i, category in enumerate(predicted_labels):
        prediction_file.write("{}\t{}\n".format(i, utils.label2class[category]))

with open(truth_path, 'w') as truth_file:
    for i, category in enumerate(predicted_labels):
        truth_file.write("{}\t{}\n".format(i, utils.label2class[truths[i]]))

print("Train/Dev split: {:d}/{:d}\n".format(len(y_train), len(y_dev)))

print (model.summary())

# Weighted Averages
accuracy = accuracy_score(truths, predicted_labels)
precision, recall, f1, _ = precision_recall_fscore_support(truths, predicted_labels, zero_division=0, average='weighted')
cm = confusion_matrix(truths, predicted_labels)

print()
print("Overall accuracy: ", accuracy)
print("Overall precision: ", precision)
print("Overall recall: ", recall)
print("Overall F1: ", f1)

_, _, _, support = precision_recall_fscore_support(truths, predicted_labels, zero_division=0)
print("Support: ", support)
print("Confusion matrix: ")
print(cm)

# Macro Averages
precision, recall, f1, _ = precision_recall_fscore_support(truths, predicted_labels, zero_division=0, average='macro')

print("Macro-average precision: ", precision)
print("Macro-average recall: ", recall)
print("Macro-average F1-score: ", f1)

# plot the training loss graph
plt.plot(history.history['loss'])
plt.title('Model training loss')
plt.ylabel('Loss')
plt.xlabel('Epoch')
plt.show()