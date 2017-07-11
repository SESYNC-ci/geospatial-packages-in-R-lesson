---
---

## Variables

Variable assignment attaches the label left of an `=` to the return value of the expression on its right.


~~~python
a = 'xyz'
~~~
{:.text-document title="worksheet.py"}



Colloquially, you might say the new variable `a` equals `'xyz'`, but Python makes it easy to "go deeper". There can be only one string `'xyz'`, so the Python interpreter makes `a` into another label for the same `'xyz'`, which we can verify by `id()`.

===

The "in-memory" location of `a` returned by `id()` ...


~~~python
>>> id(a)
139730616193464

~~~
{:.output}



... is equal to that of `xyz` itself:


~~~python
>>> id('xyz')
139730616193464

~~~
{:.output}



The idiom to test this "sameness" is typical of the Python language: it uses plain English when words will suffice.


~~~python
>>> a is 'xyz'
True

~~~
{:.output}



===

## Equal but not the Same

The `id()` function helps demonstrate that "equal" is not the "same".


~~~python
>>> b = [1, 2, 3]
>>> id(b)
139730449437064

~~~
{:.output}



The "in-memory" location of the list labeled `b` isn't the same as a list generated on-the-fly:


~~~python
>>> id([1, 2, 3])
139730449437384

~~~
{:.output}



Even though `b == [1, 2, 3]` returns `True`, these are not the same object:


~~~python
>>> b is [1, 2, 3]
False

~~~
{:.output}



===

## Side-effects

The reason to be aware of what `b` **is** has to do with "side-effects", an import part of Python programming. A side-effect occurs when an expression generates some ripples other than its return value. And side-effects don't change the label, they effect what the label is assigned to (i.e. what it **is**).


~~~python
>>> b.pop()
3

~~~
{:.output}




~~~python
>>> b
[1, 2]

~~~
{:.output}



===

Question
: Re-check the "in-memory" location---is it the same `b`?

Answer
: Yes! The list got shorter but it is the same list.
{:.fragment}

===

Side-effects trip up Python programmers when an object has multiple labels, which is not so unusual:


~~~python
>>> c = b
>>> b.pop()
2
>>> c
[1]

~~~
{:.output}



The assignment to `c` does not create a new list, so the side-effect of popping off the tail of `b` ripples into `c`.

A common mistake for those coming to Python from R, is to write `b = b.append(4)`, which overwrites `b` with the value `None` that happens to be returned by the `list.append()` function.
{:.notes}

===

Not every object is mutable; for example, the `a` assigned earlier is not.


~~~python
>>> x = a
>>> a.upper()
'XYZ'

~~~
{:.output}




~~~python
>>> x
'xyz'

~~~
{:.output}



The string 'xyz' hasn't changed---it's immutable. So it is also a safe guess that there has been no side-effect:


~~~python
>>> a
'xyz'

~~~
{:.output}


