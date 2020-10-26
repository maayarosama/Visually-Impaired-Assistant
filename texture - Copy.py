import cv2
import numpy as np
import pandas as pd
import argparse
import os
import glob
import speech_recognition as sr
import pyaudio
import mahotas as mt
from sklearn.svm import LinearSVC
from sklearn.metrics import accuracy_score
from gtts import gTTS
import os
import time

def getColorName(R,G,B):
    minimum = 10000
    for i in range(len(csv)):
        d = abs(R- int(csv.loc[i,"R"])) + abs(G- int(csv.loc[i,"G"]))+ abs(B- int(csv.loc[i,"B"]))
        if(d<=minimum):
            minimum = d
            cname = csv.loc[i,"color_name"]
    return cname

def draw_function(event, x,y,flags,param):
    if event == cv2.EVENT_LBUTTONDBLCLK:
        global b,g,r,xpos,ypos, clicked
        clicked = True
        xpos = x
        ypos = y
        b,g,r = img[y,x]
        b = int(b)
        g = int(g)
        r = int(r)


myText="For color detetction please say colours, and For patterns detetction please say texture"

language="en"

output= gTTS(text=myText, lang=language, slow=False)

output.save("output.mp3")
os.system("start output.mp3")

time.sleep(6)

# function to extract haralick textures from an image
def extract_features(image):
    # calculate haralick texture features for 4 types of adjacency
	textures = mt.features.haralick(image)

	# take the mean of it and return it
	ht_mean  = textures.mean(axis=0)
	return ht_mean

#Speech Recognition API    
r=sr.Recognizer()

with sr.Microphone() as source:
    r.adjust_for_ambient_noise(source)

    print("say sth")

    audio=r.listen(source)
    try:
        word= r.recognize_google(audio)
        print ("you said "+ word)
        if (word=="hi"):
            # load the training dataset
            train_path  = "dataset/train"
            train_names = os.listdir(train_path)
            # empty list to hold feature vectors and train labels
            train_features = []
            train_labels   = []

            # loop over the training dataset
            print ("[STATUS] Started extracting haralick textures..")
            for train_name in train_names:
                cur_path = train_path + "/" + train_name
                cur_label = train_name
                i = 1
                for file in glob.glob(cur_path + "/*.png"):
                    print ("Processing Image - {} in {}".format(i, cur_label))
                    # read the training image
                    image = cv2.imread(file)
                    # convert the image to grayscale
                    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                    # extract haralick texture from the image
                    features = extract_features(gray)
                    # append the feature vector and label
                    train_features.append(features)
                    train_labels.append(cur_label)

                    # show loop update
                    i +=1

            # have a look at the size of our feature vector and labels
            print ("Training features: {}".format(np.array(train_features).shape))
            print ("Training labels: {}".format(np.array(train_labels).shape))


            # create the classifier
            print ("[STATUS] Creating the classifier..")
            clf_svm = LinearSVC(random_state=9)

            # fit the training data and labels
            print ("[STATUS] Fitting data/label to model..")
            clf_svm.fit(train_features, train_labels)

            # loop over the test images
            test_path = "dataset/test"
            for file in glob.glob(test_path + "/*.png"):
                # read the input image
                image = cv2.imread(file)
                #################

                # convert to grayscale
                gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

                # extract haralick texture from the image
                features = extract_features(gray)

                # evaluate the model and predict label
                prediction = clf_svm.predict(features.reshape(1, -1))[0]
                

                # show the label and TTS
                output= gTTS(text=prediction, lang=language, slow=False)
                output.save("texture_output.mp3")
                os.system("start texture_output.mp3")

                
                cv2.putText(image, prediction, (20,30), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0,255,255), 3)
                print ("Prediction - {}".format(prediction))

                # display the output image
                cv2.imshow("Test_Image", image)
                cv2.waitKey(0)
                
    
        elif(word=="colours"):
            img = cv2.imread("colored-2.jpg")
            clicked = False
            r = g = b = xpos = ypos = 0
            
            
            index=["color","color_name","hex","R","G","B"]
            csv = pd.read_csv('colors.csv', names=index, header=None)
            cv2.namedWindow('image')
            cv2.setMouseCallback('image',draw_function)
            while(1):
                cv2.imshow("image",img)
                if (clicked):
                    cv2.rectangle(img,(20,20), (750,60), (b,g,r), -1)
                    text = getColorName(r,g,b) + ' R='+ str(r) +  ' G='+ str(g) +  ' B='+ str(b)
                    cv2.putText(img, text,(20,30),2,0.8,(255,255,255),2,cv2.LINE_AA)
                    output= gTTS(text=text, lang=language, slow=False)
                    output.save("color1_output.mp3")
                    os.system("start color1_output.mp3")
                    if(r+g+b>=600):
                        output= gTTS(text=text, lang=language, slow=False)
                        output.save("color_output.mp3")
                        os.system("start color_output.mp3")
                        cv2.putText(img, text,(20,30),2,0.8,(0,0,0),2,cv2.LINE_AA)
                    clicked=False
                if cv2.waitKey(20) & 0xFF ==27:
                    break
            cv2.waitKey(0)
            


            

 
		            
        else:
            print("you are wrong")

    except Exception as e:
        print("Error: " +str(e))