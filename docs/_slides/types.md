---
---

## Data types and variables

As most programming languages, Python supports basic data types for integers
(`int`), real numbers (`float`), character strings (`str`) and logical 
True/False values (`bool`).

The type of a variable is automatically set when a value is assigned to it,
 using the `=` operator. It can be queried with the built-in `type()`
 function.
 

~~~python
i = 3
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> type(i)
<type 'int'>

~~~
{:.output}



===

Python supports the usual arithmetic operators:


| `+`  | addition       |
| `-`  | subtraction    |
| `*`  | multiplication |
| `/`  | division       |
| `**` | exponent       |
| `%`  | modulus        |
| `//` | floor division |

===

The comparison operators are symbols, while logicals are plain english:

| `==`       | equal                             |
| `!=`       | non-equal                         |
| `>`, `<`   | greater, lesser                   |
| `>=`, `<=` | greater or equal, lesser or equal |
| `and`      | logical and                       |
| `or`       | logical or                        |
| `not`      | logical negation                  |
| `in`       | logical membership                |

===

Both `int` and `float` values can be mixed within an expression; the result is a `float`.


~~~python
r = i + 1.5
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> print r, 'is of', type(r)
4.5 is of <type 'float'>

~~~
{:.output}



===

In the code above, we introduced the `print` statement, which prints the output
of multiple Python expressions on the same line, separated by spaces. 
Note that quoted character strings (here, 'is of') are printed as is. 

Let's define a new string variable.


~~~python
s = 'three'
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> type(s)
<type 'str'>

~~~
{:.output}



===

In Python, the same operator can perform different functions based on the
data types of the operands. See what happens if you "add" two character
strings.


~~~python
>>> s + ' four'
'three four'

~~~
{:.output}


