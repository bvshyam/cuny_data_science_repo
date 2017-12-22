from flask import Flask, render_template, request
from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer
from keras.models import load_model
from keras.layers import GRU, Input, Dense, TimeDistributed, SimpleRNN, LSTM
from keras.models import Model
from keras.models import Sequential
from keras.layers import Activation
from keras.optimizers import Adam
from keras.losses import sparse_categorical_crossentropy
from keras.callbacks import ModelCheckpoint
from keras.layers import Dropout
from keras.layers import Dropout, Bidirectional, RepeatVector
from keras.layers.embeddings import Embedding
import collections
import pandas as pd
import nltk

from keras.preprocessing.text import Tokenizer,text_to_word_sequence
import numpy as np
from keras.preprocessing.sequence import pad_sequences
from keras.models import load_model
from autocorrect import spell
from scipy.spatial import distance
import time

#loaded_model = load_model('saved_models/final_rnn_model6.hdf5')
model = load_model('./saved_models/resume_chatbot_save_3000.hdf5')

que = ''
last_query  = ' '
last_last_query = ''
text = ' '
last_text = ''
name_of_computer = 'Jammy AI'
name =''


df = pd.read_csv('./data/final_qa_data.csv',sep=',')

question_sentences = df.Question.values
answer_sentences = df.Answer.values
def preprocess_cleaning(texts):
    
    text_cleaned = []
           
    text_cleaned = [' '.join(nltk.tokenize.word_tokenize(word.lower(),preserve_line=True)) for word in texts]
        
        
        
    return text_cleaned

question_sentences = preprocess_cleaning(question_sentences)
answer_sentences = preprocess_cleaning(answer_sentences)

def tokenize(x):
    """
    Tokenize x
    param x: List of sentences/strings to be tokenized
    return: Tuple of (tokenized x data, tokenizer used to tokenize x)
    """
    # convert to nltk tokenizer to preserve the symbols and tokenize
    x = [' '.join(nltk.tokenize.word_tokenize(word.lower(),preserve_line=True)) for word in x]

    #Use tokenizer from Keras
    tokenizer = Tokenizer(num_words=None, filters="", lower=True, split=" ")
    tokenizer.fit_on_texts(x)
    return tokenizer.texts_to_sequences(x), tokenizer

def pad(x, length=None):
    """
    Pad x
    param x: List of sequences.
    param length: Length to pad the sequence to.  If None, use length of longest sequence in x.
    return: Padded numpy array of sequences
    """
    if length==None:
        maxLenX = 0
        for sequence in x:
            if len(sequence) > maxLenX:
                maxLenX = len(sequence)
        
        padded = pad_sequences(sequences=x,maxlen=maxLenX, dtype='int32', padding='post', truncating='post', value=0)

    else:
        padded = pad_sequences(sequences=x,maxlen=length, dtype='int32', padding='post', truncating='post', value=0)
    return padded

def preprocess(x, y):
    """
    Preprocess x and y
    :param x: Feature List of sentences
    :param y: Feature output List of sentences
    :return: Tuple of (Preprocessed x, Preprocessed y, x tokenizer, y tokenizer)
    """
    preprocess_x, x_tk = tokenize(x)
    preprocess_y, y_tk = tokenize(y)

    preprocess_x = pad(preprocess_x)
    preprocess_y = pad(preprocess_y)
    
    print(preprocess_y.shape)
    
    # Keras's sparse_categorical_crossentropy function requires the labels to be in 3 dimensions
    preprocess_y = preprocess_y.reshape(*preprocess_y.shape, 1)

    return preprocess_x, preprocess_y, x_tk, y_tk

 
x, y, x_tk, y_tk =    preprocess(question_sentences, answer_sentences)

# Open files to save the conversation for further training:

name = time.strftime("%Y%m%d-%H%M%S")
qf = open('./session_data/'+name+'.txt', 'w')

def similar_word(unknown_word_dim):
    """
    To find the similar if a typed word is not available in questions vocab. 
    Here we are finding the nearest word using euclidean distance 
    and perform the approximate word  which is similar to it.
    :param unknown_word_dim: unknown word entered in the text
    """
    all_distance = []

    for known_word in encoder_embedding_matrix:
        all_distance.append(distance.euclidean(unknown_word_dim,known_word))
    
    #Get the minimum distance using argsort
    return(unknown_helper_list[np.array(all_distance).argsort()[:1][0]])

def preprocess_test(raw_word, question_tokenizer):
    """
    Preprocess the text which is entered by user. We need to remove and clean 
    the text before we predict the answer.
    :param raw_word: Raw sentence entered by the user.
    :param question_tokenizer: Question tokenizer for vocab
    """
    
    # Cleaning the text
    l1 = ['won’t','won\'t','wouldn’t','wouldn\'t','’m', '’re', '’ve', '’ll', '’s','’d', 'n’t', '\'m', '\'re', '\'ve', '\'ll', '\'s', '\'d', 'can\'t', 'n\'t', 'B: ', 'A: ', ',', ';', '.', '?', '!', ':', '. ?', ',   .', '. ,', 'EOS', 'BOS', 'eos', 'bos']
    l2 = ['will not','will not','would not','would not',' am', ' are', ' have', ' will', ' is', ' had', ' not', ' am', ' are', ' have', ' will', ' is', ' had', 'can not', ' not', '', '', ' ,', ' ;', ' .', ' ?', ' !', ' :', '? ', '.', ',', '', '', '', '']

    raw_word = raw_word.lower()

    for j, term in enumerate(l1):
        raw_word = raw_word.replace(term,l2[j])
       
    for j in range(30):
        raw_word = raw_word.replace('. .', '')
        raw_word = raw_word.replace('.  .', '')
        raw_word = raw_word.replace('..', '')
        raw_word = raw_word.replace('...', '')
        
    for j in range(5):
        raw_word = raw_word.replace('  ', ' ')
 
    #Spell checker and call similar words function

    final_corrected_words  = []
    
    for text in nltk.tokenize.word_tokenize(raw_word.lower(),preserve_line=True):
        text = text.lower()
        #Spell checker changes the symbols. So passing only strings.
        if text not in '!"#$%&()*+,-./:;<=>?@[\\]^_`{|}~\t\n':
            #Spell checker
            text = spell(text).lower()
            
            # Finding unknown similar words from the vocab
            if text not in question_tokenizer.word_index.keys():
                
                try:
                    final_corrected_words.append(similar_word(embeddings_index[text]))
                except:
                    final_corrected_words.append('?')
            else:
                final_corrected_words.append(text)
        else:
           
            if text not in question_tokenizer.word_index.keys():
                final_corrected_words.append(similar_word(embeddings_index[text]))
            else:
                final_corrected_words.append(text)
            
    #print(' '.join(final_corrected_words))
    return ' '.join(final_corrected_words)


app = Flask(__name__)

#english_bot = ChatBot("Chatterbot", storage_adapter="chatterbot.storage.SQLStorageAdapter")

#english_bot.set_trainer(ChatterBotCorpusTrainer)
#english_bot.train("chatterbot.corpus.english")


@app.route("/")
def home():
    return render_template("index.html")

@app.route("/get")
#def get_bot_response():
#    userText = request.args.get('msg')
#    return str(english_bot.get_response(userText))

def final_predictions():
    """
    Gets predictions using the final model
    :param x: Preprocessed English data
    :param y: Preprocessed French data
    :param x_tk: Questions tokenizer
    :param y_tk: Answers tokenizer
    """
    
    ## Create a answer dictionary
    y_id_to_word = {value: key for key, value in y_tk.word_index.items()}
    y_id_to_word[0] = '<PAD>'
    

    #print('Chatbot: Hi ! please type your name.\n')
    #name = input('user: ')
    name = request.args.get('msg')
    #print('Chatbot: hi , ' + name +' ! My name is ' + name_of_computer + '.\n') 
    #name =''
    
    while(True):
        
        # que = input()

        if name =='':

        	return str("Thank you.")

        elif name !='' :
        	que = request.args.get('msg')
        
        qf.write("Question typed:" + que + '\n')
        
        if que =='exit':
        	str_final = "I'm out,It was nice talking to you "+name+". Stay connected via linked in https://www.linkedin.com/in/shyam-viswanathan-62145b16/"
        	return str(str_final)

        else:
            #Preprocess the text
            que = preprocess_test(que,x_tk)
            #print(que)
        sentence =que
        
        qf.write("Question interpreted:" + que + '\n')
        
        #sentence = [x_tk.word_index[word] for word in text_to_word_sequence(sentence,filters='')]
        
        sentence = [x_tk.word_index[word] for word in nltk.tokenize.word_tokenize(sentence.lower())]
        
        #Convert to padded sequence
        sentence = pad_sequences([sentence], maxlen=x.shape[-1], padding='post')
        sentences = np.array([sentence[0], x[0]])
        
        #print(sentences.shape)
        
        tmp_sentences = pad(sentences, y.shape[1])
        tmp_sentences = tmp_sentences.reshape((-1, y.shape[-2]))

        #print(tmp_sentences)
        predictions = model.predict(tmp_sentences, len(tmp_sentences))

        #print('Sample 1:')
        prediction_text = ' '.join([y_id_to_word[np.argmax(x)] for x in predictions[0]]).replace('<PAD>','')
        
        qf.write("Answer by bot:" + prediction_text + '\n')
        #print(prediction_text+'\n')
        return str(prediction_text)

    qf.close()

#final_predictions(loaded_model,preproc_question_sentences, preproc_answer_sentences, question_tokenizer, answer_tokenizer)


if __name__ == "__main__":
    app.run()
