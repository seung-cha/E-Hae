"""
Collection of functions that return word definition for various languages.
Each makes request to online dictionary API and wraps the data in a dictionary
compatible for our purpose. Raises NoDefinition exception if definition cannot be found.

Return form:
{
    word:                   str     # Word to find the definition for
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
"""
import requests

class NoDefinition(Exception):
    def __init__(self, word, message):
        self.word = word
        super().__init__(f'Could not find the definition for {word}')


def English(word: str):
    """
    English dictionary. Uses
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


    


