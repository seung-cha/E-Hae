import pymupdf
from flask import Flask, request
from flask_cors import CORS
from flask_restful import Resource, Api

import json
import base64
import hashlib

import Dictionary

app = Flask(__name__)
CORS(app)
api = Api(app)

GET = 'GET'
POST = 'POST'
PUT = 'PUT'
DELETE = 'DELETE'
OK = 200
BAD_REQ = 404

"""
Because Flutter has no good packages for PDFs, handle all logics in Python
and sent response via http requests.
"""

openFiles = {}

class OpenFile(Resource):
    """
    /open

    Open PDF (or epub) file, storing it in a dictionary.
    Send the file's metadata as response.

    Request form:
    {
        path:       str                         # Path to a pdf file, relative to where the app.py is executed.
    }

    Response form:
    {
        id:         str                         # digits represented in string, to avoid overflow problem in Dart.
        width:      int                         # width of the first page, usually sufficient as dimensions are the same for most books.
        height:     int                         # height of the first page.
        pageCount:  int                         # total number of pages
        toc:        list(lvl, title, page)      # nested lvl, title, destination page (1 based indexing).

        More info: https://pymupdf.readthedocs.io/en/latest/document.html#Document.get_toc 
    }

    """
    def post(self):
        path = request.args['path']
        h = hashlib.shake_128(path.encode()).hexdigest(8)
        width = 0
        height = 0

        # Just return hash if file is already open
        if h not in openFiles:
            openFiles[h] = pymupdf.open(path)
  
        doc: pymupdf.Document = openFiles[h]
        media = doc[0].mediabox
        
        width = media.width
        height = media.height

        toc = doc.get_toc()

        return {'id': h, 'width': width, 'height': height, 'pageCount': doc.page_count, 'toc': toc}, OK

api.add_resource(OpenFile, '/open')

class GetPage(Resource):
    """
    /getPage

    Get a page of currently-open file.
    A page must be open beforehand.

    Request form (params):
    {
        id:         str                         # digits represented in string, to avoid overflow problem in Dart.
        pageNo:     int                         # Page to load, assume it is valid.
    }

    Response form: https://pymupdf.readthedocs.io/en/latest/page.html#Page.get_image_info

    """
    def get(self):
        id = request.args['id']
        pageNo = int(request.args['no'])
        doc: pymupdf.Document = openFiles[id]

        pageDict = doc[pageNo].get_textpage().extractDICT()
        pageImages: list = []

        # Extract images
        # Refer to https://pymupdf.readthedocs.io/en/latest/page.html#Page.get_image_info
        page_imgs = doc[pageNo].get_images(full= True)

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
            bbox = doc[pageNo].get_image_bbox(img)
            
            imgDict = doc.extract_image(xref) # Dont use this
            ext: str = imgDict['ext']
            xres: int = imgDict['xres']
            yres: int = imgDict['yres']
            imgByte: bytes = imgDict['image']
            
            boundingBox = [
                bbox.tl.x,
                bbox.tl.y,
                bbox.br.x,
                bbox.br.y,
                bbox.width,
                bbox.height
            ]
            # Convert byte to encoded base64 to embed in json
            imgB64 = base64.b64encode(imgByte).decode()
            pageImages.append({
                'img': imgB64,
                'bbox': boundingBox
            })

        pageDict['imgs'] = pageImages
        return pageDict, OK

api.add_resource(GetPage, '/getPage')

class GetDefinition(Resource):
    """
    /definition

    Get the definition of requested word

    Request form (params):
    {
        word:       str                     # word to get the definition for
        lang:       str                     # language of the word    
    }

    supported lang: [en]

    Response form: See dictionary.py
    {
        error:      str                     # Error str if definition could not be found
    }
    """

    def get(self):
        word = request.args['word']
        lang = request.args['lang']

        try:
            res = OK
            match lang:
                case 'en':
                    definition = Dictionary.English(word)
                case '_':
                    definition = {'error': 'language not supported'}
                    res = BAD_REQ    

            return definition, res
        except Dictionary.NoDefinition as err:
            return { 'error': str(err) }, BAD_REQ
        
api.add_resource(GetDefinition, '/definition')


if __name__ == '__main__':
    app.run(debug=True)


