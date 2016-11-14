---
---

## Dictionaries

Lists are useful when you need to access elements by their position in a
sequence. In contrast, *dictionaries* make it easy to find values based on unique
identifiers called *keys*.

A dictionary is defined as a list of `key:value` pairs enclosed by curly
brackets. Individual values are accessed using square brackets, as for lists,
except that keys are used as the indices.


~~~python
>>> animals = {'Snowy':'dog', 'Garfield':'cat', 'Bugs':'rabbit'}
>>> animals['Bugs']
'rabbit'

~~~
{:.term}



===

To add an element to the dictionary, we "select" a new key and assign 
it a value.


~~~python
>>> animals['Lassie'] = 'dog'
>>> animals
{'Snowy': 'dog', 'Garfield': 'cat', 'Lassie': 'dog', 'Bugs': 'rabbit'}

~~~
{:.term}



===

Note that the keys of a dictionary must be unique. Assigning a value to an 
existing key would overwrite its previously associated value. As you can also
see from the example above, the order in which Python returns dictionary elements
is arbitrary.

===

**Question**: Based on what we have learned so far, how could you represent a
contact list in Python, i.e. a list of individuals with their names, phone 
numbers, email addresses, etc.?
