---
---

## Iteration

The data structures just discussed have multiple values. Subsetting is one way to get at them individually. The common case of getting at each one individually is called iterating.

Python formally declares a thing "iterable" if it can be used in an expression `for x in y`. where `y` is the iterable thing and `x` will label each element in turn.

===

## Declarations with Iterables

Packing the `for x in y` expression inside a sequence declaration is one way to build a sequence.


~~~python
letters = [x for x in 'abcde']
~~~
{:.text-document title="{{ site.handouts }}"}



~~~python
>>> letters
['a', 'b', 'c', 'd', 'e']
~~~
{:.output}



This way of declaring with `for` and `in` is called a "comprehension" in Python.

===

## Dictionary Comprehension

To declare a dictionary in this way, specify a `key:value` pair.


~~~python
>>> CAPS = {x:x.upper() for x in 'abcde'}
~~~
{:.output}



~~~python
>>> CAPS
{'e': 'E', 'd': 'D', 'b': 'B', 'a': 'A', 'c': 'C'}
~~~
{:.output}


