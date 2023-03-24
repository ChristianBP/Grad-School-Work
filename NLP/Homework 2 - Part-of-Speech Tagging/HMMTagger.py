from collections import defaultdict
from load_corpus import *

class HMMTagger():

    def __init__(self):
        self.initial_tag_probs = {}
        self.transition_probs = defaultdict(lambda: {})
        self.emission_probs = defaultdict(lambda: {})

        self.word_set = {'UNK'}
        self.tag_set = set()

    def initialize_probabilities(self, sentences):
        initial_tag_counts = defaultdict(lambda: 0)

        transition_counts = defaultdict(lambda: defaultdict(lambda: 0))
        emission_counts = defaultdict(lambda: defaultdict(lambda: 0))

        for sentence in sentences:
            for word in sentence:
                self.word_set.update({word[0].lower()})
                self.tag_set.update({word[1]})

            # First tag from the sentence
            initial_word, initial_tag = sentence[0]
            initial_tag_counts[initial_tag] +=1
            emission_counts[initial_tag][initial_word.lower()] += 1

            for i in range(len(sentence)-1):
                first_tag = sentence[i][1]
                second_word, second_tag = sentence[i+1]
                transition_counts[first_tag][second_tag] += 1
                emission_counts[second_tag][second_word.lower()] += 1

        # Add one for every tag in the vocabulary
        total_initial_tags = len(self.tag_set)
        total_initial_tags += sum(initial_tag_counts.values())

        # Initial tag probabilities
        for tag in initial_tag_counts:
            # The + 1 to the count is for smoothing
            self.initial_tag_probs[tag] = (initial_tag_counts[tag] + 1) / total_initial_tags

        for first_tag in self.tag_set:
            # Number of times the first tag appears
            transition_tag_count = 0
            if first_tag in transition_counts:
                transition_tag_count += sum(transition_counts[first_tag].values())

            # Transition Probabilities
            for second_tag in self.tag_set:
                self.transition_probs[first_tag][second_tag] = transition_counts[first_tag][second_tag] / transition_tag_count

            # Need to do smoothing for emission probabilities in case we run into unknown words
            emission_tag_count = len(self.tag_set)
            if first_tag in emission_counts:
                emission_tag_count += sum(emission_counts[first_tag].values())

            # Emission Probabilities
            for word in self.word_set:
                self.emission_probs[first_tag][word] = (emission_counts[first_tag][word] + 1) / emission_tag_count


    def viterbi_decode(self, sentence):
        words = [word.lower() for word in sentence.split()]
        tag_list = list(self.tag_set)
        dp_table = [{}]

        for tag in tag_list:
            emission_prob = self.emission_probs[tag][words[0]] if words[0] in self.emission_probs[tag] else self.emission_probs[tag]['UNK']

            dp_table[0][tag] = {
                'prob': self.initial_tag_probs[tag] * emission_prob,
                'prev': None
            }

        for i in range(1, len(words)):
            dp_table.append({})
            word = words[i] if words[i] in self.word_set else 'UNK'

            for current_tag in tag_list:
                max_prob = dp_table[i-1][tag_list[0]]['prob'] * self.transition_probs[tag_list[0]][current_tag] * self.emission_probs[current_tag][word]
                prev = tag_list[0]

                for prev_tag in tag_list[1:]:
                    transition_prob = dp_table[i-1][prev_tag]['prob'] * self.transition_probs[prev_tag][current_tag] * self.emission_probs[current_tag][word]
                    if transition_prob > max_prob:
                        max_prob = transition_prob
                        prev = prev_tag
                dp_table[i][current_tag] = {'prob': max_prob, 'prev': prev}

        last_tag = None
        max_prob = 0
        # Find the tag from the last row with the highest probability
        for tag, values in dp_table[-1].items():
            if values['prob'] > max_prob:
                max_prob = values['prob']
                last_tag = tag

        optimal_tags = [last_tag]
        # Follow the previous tags all the way back
        for state in dp_table[-1:0:-1]:
            last_tag = state[last_tag]['prev']
            optimal_tags.insert(0, last_tag)

        return ' '.join(optimal_tags)


if __name__ == "__main__":
    # Initialize the tagger class
    tagger = HMMTagger()

    # Read a corpus and learn from it
    folder_name = 'modified_brown' #input("Input path: ")
    corpus = load_corpus(folder_name)
    tagger.initialize_probabilities(corpus)

    # Test
    test_sentences = [
        'the planet jupiter and its moons are in effect a mini solar system .',
        'computers process programs accurately .'
    ]
    
    print('These are the sentences followed by the tags with the highest probability:')
    for sentence in test_sentences:
        print()
        print(sentence)
        result = tagger.viterbi_decode(sentence)
        print(result)