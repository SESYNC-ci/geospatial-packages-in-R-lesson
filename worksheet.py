# Data types and variables

i = 3

r = i + 1.5

s = 'three'

# Lists

lst = [r, s, 'another string']

## List subsetting

nlst = [1, 2, 3, [11, 12, 13]]


## Exercise 1

# Create a Python `list` containing a the letter "a", the integer 2 and
# the float 3.14. Now, assume you did not know the length of the list and
# extract the last two elements.

## List methods

i = lst.index('three')

lst.append(100)

## Exercise 2
# 
# Find and use the method for `lst` that arranges its
# elements in the opposite order.

## Lists are mutable

x = lst.append(200)

same_lst = lst
same_lst.append(300)

## Dictionaries

animals = {'Snowy':'dog', 'Garfield':'cat', 'Bugs':'rabbit'}

animals['Lassie'] = 'dog'

animals.update(
  Tweety='bird',
  Bob='sponge',
  )

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
for i in range(1, 5):
    j = i ** 2
    squares.append(j)
    
contacts = [
    {'name':'Alice', 'phone':'555-111-2222'},
    {'name':'Bob', 'phone':'555-333-4444'},
    ]

for c in contacts:
    if c['name'] == 'Alice':
        print(c['phone'])
    else:
        print(c['name'])

## Exercise 5
#
# Write a loop that prints all even numbers between 1 and 9 using the
# modulo operator (%) to check for evenness. If i is even, then i % 2
# returns 0, because % gives the remainder after division of the first
# number by the second.

## Function definition

def add_two(num):
    result = num + 2
    return result

def add_any(num, x=0):
    result = num + x
    return result

## Packages

## NumPy

import numpy as np
vect = np.array([5, 20, 12])

mat = np.array([[1, 2, 3], [4, 5, 6]])

## Pandas

import pandas as pd
surveys = pd.read_csv("data/surveys.csv")

surveys_dm = surveys.loc[surveys['species_id'] == 'DM', ]

surveys_dm = surveys.query('species_id == "DM"')

dm_stats = (
  surveys_dm
  .groupby('sex')
  ['hindfoot_length', 'weight']
  .mean()
  )

## Exercise 6
#
# The `count` method for DataFrames (e.g. `surveys.count()`) returns the
# number of rows in a data frame. Find out which month had the most
# observations recorded in `surveys`.

## Matplotlib

import matplotlib.pyplot as plt
ax = surveys_dm.plot('hindfoot_length', 'weight', kind = 'scatter')

surveys_dm.hist('weight')
plt.savefig('hist_weight.pdf')
