import json
import numpy as np
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader

from nltk_utilities import tokenize, stem, bag_of_words

with open('intents.json', 'r') as f:
    intents = json.load(f)

#All patterns of words
all_words = []

#All tags
tags = []

#Combination of words and tags
xy = []

for intent in intents['intents']:
    tag = intent['tag']
    tags.append(tag)

    for pattern in intent['patterns']:
        w = tokenize(pattern)
        # Extend used because we want strings in the w array 
        # Append used for simple string  
        all_words.extend(w)

        #tuple () used for combination of corresponding tag and pattern
        xy.append((w, tag))

ignore_words = ['?', '!', '.', ',']

all_words = [stem(w) for w in all_words if w not in ignore_words]

#sort array and only use unique words (set)

all_words = sorted(set(all_words))
tags = sorted(set(tags))

X_train = []
Y_train = []

#unpack tuple because its in key-value pairs in xy
for (pattern_sentence, tag) in xy:
    bag = bag_of_words(pattern_sentence, all_words)
    X_train.append(bag)

    label = tags.index(tag)
    
    #indexes for each tag
    #CrossEntropyLoss does not need hot encoded vector
    Y_train.append(label)  

#Convert X an Y train to numpy array
X_train = np.array(X_train)
Y_train = np.array(Y_train)

class ChatDataSet(Dataset):
    def __init__(self):
        self.n_samples = len(X_train)
        self.x_data = X_train
        self.y_data = Y_train

    def __getitem__(self, index):
        return self.x_data[index], self.y_data[index]
    
    def __len__(self):
        return self.n_samples

# Hyperparameters
batch_size = 8
    
dataset = ChatDataSet()
training_loader = DataLoader(dataset=dataset, batch_size= batch_size, shuffle= True, num_workers=2)
