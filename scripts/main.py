import google.generativeai as genai
import cv2
import json
import typing_extensions as typing

import pytesseract
from pytesseract import Output

from PIL import Image

from key import *
class Response(typing.TypedDict):
    segment: str



custom_oem_psm_config = r'--tessdata-dir tessdata'


img = cv2.imread('j2.png')
d = pytesseract.image_to_data(img, output_type=Output.DICT, lang='jpn_vert')
print(d)
n_boxes = len(d['level'])
for i in range(n_boxes):
    if(float(d['conf'][i]) < 80):
        continue 

    (x, y, w, h) = (d['left'][i], d['top'][i], d['width'][i], d['height'][i])
    cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 1)

while True:
    cv2.imshow('img', img)
    cv2.waitKey(100)



# reader = ocr.Reader([ 'en'])
# result = reader.readtext('t2.png', detail=0, paragraph= True)
# boxes, free = reader.detect('t2.png')


# print('\n\n\n')

# result:list
# print(result)
# print('\n\n\n')

# result_combined = ''.join(result)


# print('\n\n\n')

# json_res = json.dumps(result, ensure_ascii=False).encode('utf8')
# json_res = json_res.decode()

# prompt = 'Translate the text to Korean. Output segments representing each sentence. Treat bullet points as a separate sentence.'
# genai.configure(api_key= KEY)
# model = genai.GenerativeModel('gemini-1.5-flash', generation_config={
#     'response_mime_type': 'application/json',
#     'response_schema': list[Response]
# })

# response = model.generate_content([result_combined, prompt])

# print(response.text)

# response_json = json.loads(response.text)
# #print(response_json)


# for res in response_json:
#     #print('\n\n\n')
#     print(res)


# img = cv.imread('t2.png')

# if img is None:
#     print('No image read')
#     exit(0)
# processed_boxes = list()
# for box in boxes[0]:
#     print('\n\n\n')
#     #print(box)
#     xmin = box[0]
#     xmax = box[1]
#     ymin = box[2]
#     ymax = box[3]

#     processed_boxes.append((xmin, ymin))
#     img = cv.rectangle(img, (xmin, ymin), (xmax, ymax), color=(255, 0, 0), thickness= 3)

# for i in range(len(response_json)):
#     txt = response_json[i]['segment']
#     t = processed_boxes[i]

#     img = cv.putText(img, txt, org=(t[0], t[1] + 10), fontFace=cv.FONT_HERSHEY_COMPLEX_SMALL, fontScale=0.3, color=(0, 0, 255))

# while True:
    
#     cv.imshow('output', img)
#     cv.waitKey(100)