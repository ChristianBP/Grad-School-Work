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