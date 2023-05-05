import pandas as pd
import nltk
import re
import tensorflow as tf

import utils

def clean_str(text):
    text = text.lower()
    # Clean the text
    text = re.sub(r"[^A-Za-z0-9^,!.\/'+-=]", " ", text)
    text = re.sub(r"what's", "what is ", text)
    text = re.sub(r"that's", "that is ", text)
    text = re.sub(r"there's", "there is ", text)
    text = re.sub(r"it's", "it is ", text)
    text = re.sub(r"\'s", " ", text)
    text = re.sub(r"\'ve", " have ", text)
    text = re.sub(r"can't", "can not ", text)
    text = re.sub(r"n't", " not ", text)
    text = re.sub(r"i'm", "i am ", text)
    text = re.sub(r"\'re", " are ", text)
    text = re.sub(r"\'d", " would ", text)
    text = re.sub(r"\'ll", " will ", text)
    text = re.sub(r",", " ", text)
    text = re.sub(r"\.", " ", text)
    text = re.sub(r"!", " ! ", text)
    text = re.sub(r"\/", " ", text)
    text = re.sub(r"\^", " ^ ", text)
    text = re.sub(r"\+", " + ", text)
    text = re.sub(r"\-", " - ", text)
    text = re.sub(r"\=", " = ", text)
    text = re.sub(r"'", " ", text)
    text = re.sub(r"(\d+)(k)", r"\g<1>000", text)
    text = re.sub(r":", " : ", text)
    text = re.sub(r" e g ", " eg ", text)
    text = re.sub(r" b g ", " bg ", text)
    text = re.sub(r" u s ", " american ", text)
    text = re.sub(r"\0s", "0", text)
    text = re.sub(r" 9 11 ", "911", text)
    text = re.sub(r"e - mail", "email", text)
    text = re.sub(r"j k", "jk", text)
    text = re.sub(r"\s{2,}", " ", text)

    return text.strip()


def load_data_and_labels(path, is_training):
    data = []
    lines = [line.strip() for line in open(path)]
    max_sentence_length = 0
    for idx in range(0, len(lines), 4):
        id = lines[idx].split("\t")[0]
        relation = lines[idx + 1]

        sentence = lines[idx].split("\t")[1][1:-1]
        sentence = sentence.replace('<e1>', ' _e11_ ')
        sentence = sentence.replace('</e1>', ' _e12_ ')
        sentence = sentence.replace('<e2>', ' _e21_ ')
        sentence = sentence.replace('</e2>', ' _e22_ ')

        sentence = clean_str(sentence)
        tokens = nltk.word_tokenize(sentence)
        if max_sentence_length < len(tokens):
            max_sentence_length = len(tokens)
        sentence = " ".join(tokens)

        data.append([id, sentence, relation])

    print('Loading sentences from:')
    print(path)
    print("Max sentence length = {}\n".format(max_sentence_length))

    df = pd.DataFrame(data=data, columns=["id", "sentence", "relation"])
    df['label'] = [utils.class2label[r] for r in df['relation']]

    # Adjust Sampling
    if(is_training):
        df_other = df[df['label'] == 0]
        df_classified = df[df['label'] != 0]
        # Downsample
        # df_other_downsampled = df_other.sample(df_classified.shape[0])
        # df = pd.concat([df_classified, df_other_downsampled])
        # Upsample
        df_classified_upsampled = df_classified.sample(df_other.shape[0], replace=True)
        df = pd.concat([df_classified_upsampled, df_other])

        # Upsample and Downsample
        # drop(0) excludes Other from the max sample size so we can downsample it
        # max_sample_size = df['label'].value_counts().drop(0).max()
        # df_separated = [ df[df['label'] == l] for l in utils.label2class.keys()]
        # df = pd.concat([sample.sample(max_sample_size, replace=True) for sample in df_separated])


    # Input Data Statistics
    df['relation'] = [utils.label2class[l] for l in df['label']]
    print('Label Distribution (Support)')
    print(df['relation'].value_counts())

    # Text Data
    x_text = df['sentence'].to_numpy()


    # Label Data
    y = df['label']
    y = tf.keras.utils.to_categorical(y)

    return x_text, y, max_sentence_length