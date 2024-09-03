"""
Collection of functions that return word definition for various languages.
Each makes request to online dictionary API and wraps the data in a dictionary
compatible for our purpose. Raises NoDefinition exception if definition cannot be found.

Return form:
{
    word:                   str     # Word to find the definition for
    reading:                str     # For foreign languages. How it's read/spelt.
    meanings:                       # List of definitions
    [
        {
            type:           str     # Type of the definition (e.g verb, noun)
            definitions:
            [
                definition: str     # Definition of the word
                example:    str     # Example 
            ]
        }

    ]
}

TODO: Integrate Tatoeba to get example sentences if the source doesn't provide one.
https://tatoeba.org/en/
"""
import requests


class NoDefinition(Exception):
    def __init__(self, word):
        self.word = word
        super().__init__(f'Could not find the definition for {word}')


def English(word: str):
    """
    Uses
    https://dictionaryapi.dev

    https://api.dictionaryapi.dev/api/v2/entries/en/<word>
    """
    res = requests.get(f'https://api.dictionaryapi.dev/api/v2/entries/en/{word}')
    print(res.status_code)

    if res.status_code != 200:
        raise NoDefinition(word= word)
    
    js = res.json()[0]
        
    ret = { 'word': word, 'meanings': list() }

    for meaning in js['meanings']:
        ret_meaning = {
            'type': meaning['partOfSpeech'],
            'definitions':  [ 
                                {   
                                    'definition':   definition['definition'], 
                                    'example':      definition['example'] if 'example' in definition else ''
                                }   for definition in meaning['definitions'] 
                            ]
        }
        
        ret['meanings'].append(ret_meaning)

    return ret

def Japanese(word: str):
    """
    Uses
    http://beta.jisho.org/api/v1/search/words

    Example query:
    http://beta.jisho.org/api/v1/search/words?keyword=house

    TODO: Integrate tateoba to get example sentences
    """
    res = requests.get('http://beta.jisho.org/api/v1/search/words',params= {'keyword': word})
    js = res.json()['data']

    # Jisho returns empty array if content was not found.
    # Check if so and get the first element (which is likely the word defnition)
    if len(js) == 0:
        raise NoDefinition(word= word)
    
    js = js[0]
    reading = js['japanese'][0]

    ret = { 'word': js['slug'], 'reading': reading['reading'], 'meanings': list() }

    for meaning in js['senses']:
        ret_meaning = {
            'type': '; '.join(meaning['parts_of_speech']),   # TODO: Consider changing structure
            'definitions': [
                {
                    'definition': '; '.join(meaning['english_definitions']),
                    'example': ''   # TODO
                }   
            ] 
        }

        ret['meanings'].append(ret_meaning)

    print(ret)
    return ret
    






    
    


