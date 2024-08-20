import pymupdf
from flask import Flask
from flask_cors import CORS
from flask_restful import Resource, Api

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





# Temp backend to develop frontend
class GetPage(Resource):
    def get(self):
        doc = pymupdf.open("book_samples/novel_text_only.pdf")
        return doc[7].get_textpage().extractDICT(), OK


api.add_resource(GetPage, '/get')
#api.add_resource(GetPage, '/todo/<int:no>') # Actual ep to use


if __name__ == '__main__':
    app.run(debug=True)


