import pymupdf
from flask import Flask
from flask_cors import CORS
from flask_restful import Resource, Api

import json
import base64

app = Flask(__name__)
CORS(app)
api = Api(app)

GET = 'GET'
POST = 'POST'
PUT = 'PUT'
DELETE = 'DELETE'
OK = 200

"""
Because Flutter has no good packages for PDFs, handle all logics in Python
and sent response via http requests.
"""





class GetPage(Resource):
    """
    Get a page of currently-open file.
    A page must be open beforehand.
    """
    def get(self):
        # TODO: accept page no and get rid of doc.
        doc = pymupdf.open("book_samples/scholar_text_only.pdf")
        pageDict = doc[1].get_textpage().extractDICT()
        pageImages: list = []

    

        # Extract images
        # Refer to https://pymupdf.readthedocs.io/en/latest/page.html#Page.get_image_info
        page_imgs = doc[1].get_images(full= True)
        for img in page_imgs:
            xref: int = img[0]
            smask: int = img[1]
            width: int = img[2]
            height: int = img[3]
            pbc: int = img[4]
            colSpace: str = img[5]
            altColSpace: str = img[6]
            name: str = img[7]
            filter: str = img[8]
            referencer: int = img[9]
            bbox = doc[8].get_image_bbox(img)
            
            imgDict = doc.extract_image(xref) # Dont use this
            ext: str = imgDict['ext']
            xres: int = imgDict['xres']
            yres: int = imgDict['yres']
            imgByte: bytes = imgDict['image']
            
            boundingBox = [
                bbox.tl.x,
                bbox.tl.y,
                bbox.br.x,
                bbox.br.y
            ]
            # Convert byte to encoded base64 to embed in json
            imgB64 = base64.b64encode(imgByte).decode()
            pageImages.append({
                'img': imgB64,
                'bbox': boundingBox
            })

        pageDict['imgs'] = pageImages
        return pageDict, OK


api.add_resource(GetPage, '/get')
#api.add_resource(GetPage, '/todo/<int:no>') # Actual ep to use


if __name__ == '__main__':
    app.run(debug=True)


