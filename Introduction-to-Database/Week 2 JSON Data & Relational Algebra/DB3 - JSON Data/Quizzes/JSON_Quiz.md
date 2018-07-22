JSON Quiz 
===============

Question 1
--------------------
Which of the following is NOT a valid JSON object? 

```json
{ "name": "Smiley",
  "age": 20,
  "phone": "888-123-4567",
  "email": "smiley@xyz.com",
  "happy": "true" }
```
```json
{ "name": "Smiley",
  "age": "20",
  "phone": "888-123-4567",
  "email": "smiley@xyz.com",
  "happy": true }
```
```json
{ "name": "Smiley",
  "age": 20,
  "phone": "888-123-4567", 
  "email": "smiley@xyz.com",
  "happy": true }
```
```json
{ "name": "Smiley",
  "age": 20,
  "phone": null,
  "email": null,
  "happy": true }
```

**Answer:** 
```json
{ "name": "Smiley",
  "age": 20,
  "phone": "888-123-4567", 
  "email": "smiley@xyz.com",
  "happy": true }
```
**Explanation:** 
In JSON objects, all labels (property names) must be quoted, and all label-value pairs must be separated by commas. Values in label-value pairs can be numbers, quoted strings, true, false, null, objects, or arrays. Objects and arrays may be empty.


Question 2
------------------------
Which of the following is NOT a valid JSON array? 

```json
[ 1, 2, "dog", "cat", true, false, [],
  {"pet":"dog", "fun":true} ]
```
```json
[ {1}, {2}, {"dog"}, {"cat"}, {true}, {false},
  [1, "dog", null], {"pet":"dog", "fun":true} ]
```
```json
[ {"numbers":[1, 2]}, {"pets":["dog", "cat"]},
  {"booleans":[true, false]}, [1, "dog", null],
  {"pet":"dog", "fun":true} ]
```
```json
[ [1, 2], ["dog", "cat"], [true, false], [1, "dog", null],
  {"pet":"dog", "fun":true} ]
```

**Answer:** 
```json
[ {1}, {2}, {"dog"}, {"cat"}, {true}, {false},
  [1, "dog", null], {"pet":"dog", "fun":true} ]
```
**Another possible mistake:**
```json
[ 1, 2, dog, cat, true, false, [1, "dog", null],
  {"pet":"dog", "fun":true} ] 
```
**Explanation:** 
JSON objects are surrounded by curly braces {} and are written in key/value pairs. Keys must be strings, and values must be a valid JSON data type (string, number, object, array, boolean or null). Keys and values are separated by a colon. Each key/value pair is separated by a comma, e.g., {"pet":"dog"}. In this case, {1} is invalid since the key is missing.

Here, dog and cat must be in quotes. A JSON array is a comma-separated, [] enclosed list of JSON values. Values can be numbers, quoted strings, true, false, null, objects, or arrays. Objects and arrays may be empty. Objects must be a set of label-value pairs.


Question 3
--------------------
Consider the following JSON Schema specification: 
```json
{
  "type": "object",
  "properties":
    { "ItemID": { "type":"string", "pattern":"Item*" },
      "ItemName": { "type":"string" },
      "Price": { "type":"integer", "minimum":10, "maximum":100 },
      "Sellers": { "type":"array", "maxItems":3,
                   "items": { "type":"string" }},
      "Ratings": { "type":"array",
                   "items":
                      { "type": "object",
                        "properties": {"Rater":
                                       {"type": "string", "optional": true},
                                       "Score":
                                       {"type": "integer", "minimum":1,
                                        "maxiumum":5}}}},
      "AvgRating": { "type":"number", "optional":true },
      "FreeShipping": {"type":"boolean" }
    }
}
```
Select, from the choices below, the JSON data that is valid according to the JSON Schema specification above. 

```json
{ "ItemID": "Item123",
  "ItemName": "desk",
  "Price": 50,
  "Sellers": ["Amy","Ben"],
  "Ratings": [{"Rater":"Amy", "Score":5}, {"Score":1},
              {"Rater":"Carl", "Score":4}],
  "AvgRating": 3.33,
  "FreeShipping": "yes" }
```
```json
{ "ItemID": "Item123",
  "ItemName": "desk",
  "Price": 50,
  "Sellers": [ ],
  "Ratings": [{"Rater":"Amy", "Score":5}, {"Score":1},
              {"Rater":"Carl", "Score":4}],
  "AvgRating": 3.33,
  "FreeShipping": true }
```
```json
{ "ItemID": "Item123",
  "ItemName": "desk",
  "Price": 50,
  "Sellers": ["Amy","Ben"],
  "Ratings": [{"Rater":"Amy", "Score":5}, {"Score":0},
              {"Rater":"Carl", "Score":4}],
  "AvgRating": 3.33,
  "FreeShipping": true }
```
```json
{ "ItemID": "Item123",
  "ItemName": "desk",
  "Price": 50,
  "Sellers": ["Amy","Ben"],
  "Ratings": {"Rater":"Amy", "Score":5},
  "AvgRating": 3.33,
  "FreeShipping": true }
```

**Answer:** 
```json
{ "ItemID": "Item123",
  "ItemName": "desk",
  "Price": 50,
  "Sellers": [ ],
  "Ratings": [{"Rater":"Amy", "Score":5}, {"Score":1},
              {"Rater":"Carl", "Score":4}],
  "AvgRating": 3.33,
  "FreeShipping": true }
```
**Explanation:** 
JSON data that is valid according to the JSON Schema specification must have: 
* an itemID that is a string beginning with "Item"; 
* a Price that is an integer between 10 and 100; 
* an array of between 0 and 3 Sellers; 
* an array of 0 or more Ratings, each of which is either a Rater-Score pair, or just a Score, where scores are integers between 1 and 5; 
* a FreeShipping designation of either true or false. (yes or no is unacceptable. AvgShipping, a real number, is optional.)


Question 4
------------------------
Consider the following JSON data: 
```json
{ "A": [1,1,2,2], "B": {"C":3, "D":4}, "E":[5,6,true], "F": {"G": [null,7]} }
```
Which of the following could NOT be included as part of a JSON Schema specification that is satisfied by the JSON data above? Assume that every letter ("A", "B", "C", ...) appears in the JSON Schema specification exactly once. 

```json
"A": {"type":"array", "maxItems":10, 
      "items":{"type":"integer"}}
```
```json
"B": {"type":"object", "additionalProperties":false,
      "properties": {"C": {"type":"integer"}}}
```
```json
"C": {"type":"integer"}
```
```json
"B": {"type":"object",
      "properties": {"C": {"type":["integer","null"]},
                     "D": {"type":["integer","null"]}}}
```

**Answer:**
```json
"B": {"type":"object", "additionalProperties":false,
      "properties": {"C": {"type":"integer"}}}
```
**Explanation:**
The following JSON Schema specification is valid for the given data: 
```json
{ "type": "object",
  "properties": {
    "A": {"type":"array", "minItems":4,
          "maxItems":4, "items":{"type":"integer"}},
    "B": {"type":"object",
          "properties": {"C": {"type":"integer"}, "D": {"type":"integer"}}},
    "E": {"type":"array", "items": {"type":["integer","boolean"]}},
    "F": {"type":"object",
          "properties": {"G": {"type":"array",
                               "items": {"type":["null","integer"]}}}}
  }
}
```
Changing the minimum and/or maximum number of items in "A" is valid as long as four items are permitted. Alternative types may be added (e.g., replacing "integer" with ["integer","string"]) without violating validity. 