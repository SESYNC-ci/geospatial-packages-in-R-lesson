---
---

## Function definition

We already saw examples of a few built-in functions, such as `type()` and `len()`.
New functions are defined as a block of code starting with a `def` keyword and (optionally) finishing with a `return`.


~~~python
def add_two(x):
    result = x + 2
    return result
~~~
{:.text-document title="{{ site.handouts }}"}



~~~python
>>> add_two(10)
12
~~~
{:.output}



===

The `def` keyword is followed by the function name, its arguments enclosed in
parentheses (separated by commas if there are more than one), and a colon.

The `return` statement is needed to make the function provide output.
The lack of a `return`, or `return` followed by nothing, causes the function to return the value `None`.

After it is defined, the function is invoked using its name and specifying the
arguments in parentheses, in the same order as in its definition.

===

## Default arguments

A default value can be "assigned" during function definition.


~~~python
def add_any(x, y=0):
    result = x + y
    return result
~~~
{:.text-document title="{{ site.handouts }}"}



Then the function can be called without that argument:


~~~python
>>> add_any(10)
10
~~~
{:.output}



... as well as with an argument that will override the default:


~~~python
>>> add_any(10, 5)
15
~~~
{:.output}



===

## Exercise 5

Create a function that takes a list as an argument and returns
its first and last elements as a new list.

===

## Methods

The period is a special character in Python that accesses an object's attributes and methods. In either the Jupyter Notebook or Console, typing an object's name followed by `.` and then pressing the `TAB` key brings up suggestions.


~~~python
>>> squares.index(4)
1
~~~
{:.output}



We call this `index()` function a method of lists (recall that `squares` is of type `'list'`). A useful feature of having methods attached to objects is that we can dial up help on a method as it applies to a particular type.


~~~python
>>> help(squares.index)
Help on built-in function index:

index(...) method of builtins.list instance
    L.index(value, [start, [stop]]) -> integer -- return first index of value.
    Raises ValueError if the value is not present.

~~~
{:.output}



A major differnce between Python and R has to do with the process for making functions behave differently for different objects. In Python, a function is attached to an object as a "method", while in R a "dispatcher" examines the attributes of a function call's arguments and chooses a the particular function to use.
{:.notes}

===

## A dictionary method

The `update()` method allows you to extend a dictionary with another dictionary of `key:value` pairs, while simultaneously overwriting values for existing keys.


~~~python
toons.update({
  'Tweety':'bird',
  'Bob':'sponge',
  'Bugs':'rabbit',
  })
~~~
{:.text-document title="{{ site.handouts }}"}


===

Question
: How many `key:value` pairs are there now in toons?

Answer
: {:.fragment} Five. The key `'Bugs'` is only inserted once.

===

Note a couple "Pythonic" style choices of the above:

1. Leave no space around the `:` when declaring `key:value` pairs
1. Trailing null arguments are syntactically correct, even advantageous
1. White space can be used to improve readiability; indentation within `()` is meaningless
