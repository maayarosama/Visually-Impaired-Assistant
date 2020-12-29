from PIL import Image
import pytesseract
from gtts import gTTS
import os

img = Image.open("sample1.jpg")
#tessdata_dir_config = r'--tessdata-dir "C:\Program Files (x86)\Tesseract-OCR\tessdata"'

text = pytesseract.image_to_string(img, lang = 'eng')
#text=pytesseract.image_to_string(img, lang='spa', config=tessdata_dir_config)
print ('Text_Found: ',text)

language="en"
if len(text)>0:
    output= gTTS(text=text, lang=language, slow=False)
    output.save("output.mp3")
    os.system("start output.mp3")