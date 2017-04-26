# Data types and variables

i = 3

r = i + 1.5

s = ...

# Lists

lst = ...

## List subsetting

... = [1, ...]


## Exercise 1

# Create a Python `list` containing a the letter "a", the integer 2 and
# the float 3.14. Now, assume you did not know the length of the list and
# extract the last two elements.

## List methods

i = ...

...append(100)

## Exercise 2
# 
# Find and use the method for `lst` that arranges its
# elements in the opposite order.

## Lists are mutable

x = lst.append(200)

... = lst
...

## Dictionaries

animals = {..., 'Garfield':'cat', 'Bugs':'rabbit'}

animals[...] = 'dog'

animals.update(...)

animals.update({
  3.14:'pie',
  u'\U0001F98A':'Mr. Fox',
  })

## Exercise 3
#
# Based on what we have learned so far about lists and dictionaries, think up a
# data structure suitable for an address book. Using what you come up with,
# store the contact information (i.e. the name and email address) of three or
# four (hypothetical) persons as a variable `addr`.

## Loops and conditionals

squares = []
...
    ...
    squares...
    
contacts = [
    {'name':'Alice', 'phone':'555-111-2222'},
    {'name':'Bob', 'phone':'555-333-4444'},
    ]

for ...
    if ...
        print(c['phone'])
    ...
        print(c['name'])

## Exercise 5
#
# Write a loop that prints all even numbers between 1 and 9 using the
# modulo operator (%) to check for evenness. If i is even, then i % 2
# returns 0, because % gives the remainder after division of the first
# number by the second.

## Function definition

def add_two(num):
    ...
    ...

...
    result = num + x
    return result

## Packages

## NumPy

import numpy as np
...

...

## Pandas

...
surveys = pd.read_csv("data/surveys.csv")

surveys_dm = ...[surveys['species_id'] == 'DM', ]

surveys_dm = ...

dm_stats = (
  ...
  ...
  ['hindfoot_length', 'weight']
  ...
  )

## Exercise 6
#
# The `count` method for DataFrames (e.g. `surveys.count()`) returns the
# number of rows in a data frame. Find out which month had the most
# observations recorded in `surveys`.

## Matplotlib

...
ax = surveys_dm.plot(...)

surveys_dm.hist('weight')
...
