---
---

## Data structures

- tuple
- list
- set
- dictionary

## Lists

Python offers different types of objects to represent collections of values,
the most common being a *list*. It is created by listing multiple values or
variables, separated by commas and enclosed by square brackets.

```{python, term=False}
lst = [r, s, 'another string']
```
```{python}
lst
```

```{python}
type(lst)
```





===

## Subsetting with `[]`




You can retrieve individual elements of a list by their index; note that in 
Python, the first element has an index of 0.

```{python}
lst[0]
```

===

Negative indices are also possible: -1 is the last item in the list, 
-2 the second-to-last item, etc.

```{python}
lst[-1]
```

===

The syntax `list[i:j]` selects a sub-list starting with the element at index
`i` and ending with the element at index `j - 1`.

```{python}
lst[0:2]
```

===

A blank space before or after the ":" indicates the start or end of the list,
respectively. For example, the previous example could have been written 
`lst[:2]`.

A potentially useful trick to remember the list subsetting rules in Python is
to picture the indices as "dividers" between list elements.

```
 0     1         2                  3 
 | 4.5 | 'three' | 'another string' |
-3    -2        -1
```
{:.input}

Positive indices are written at the top and negative indices at the bottom. 
`list[i]` returns the element to the right of `i` whereas `list[i:j]` returns
elements between `i` and `j`.

===

Lists can be nested within other lists: in this case, multiple sets of brackets
might be necessary to access individual elements.

```{python, term=False}
nlst = [1, 2, 3, [11, 12, 13]]
```
```{python}
nlst[-1][0]
```

===

## Exercise 1

Create a Python list containing a the letter "a", the integer 2 and the float 3.14. Now, assume you did not know the length of the list and extract the last two elements.

===

## List methods

The Python language includes multiple functions defined just for lists. Any function "attached" to an
object by a `.` is known as a "method" of that object's type.

```{python, term=False}
i = lst.index('three')
```

===

The `index()` function is a method for the object of type `type(lst)`. All the objects methods
are easy to learn about.

```{python}
dir(lst)
```

===

The help documentaion is attached to the method, no matter what you have called the object.

```{python}
help(lst.append)
```

===

```{python, term=False}
lst.append(100)
```
```{python}
lst
```

===

## Exercise 2

Find and use the method for `lst` that arranges its elements in the opposite order.

===

Python is "object-oriented" in that everything beyond the basic data types (e.g. `int`, `str`, etc.) is called an object. It is equally if not more common to use functions that are methods of objects than to use functions that are independent of any object, although even "object-oriented" programming uses these regularly:

```{python}
len(lst)
```

The function `len` is not a method and accepts different classes of object as its argument.

```{python}
len('Hello, World!')
```

===

## Lists are mutable

Many objects in Python, including lists, are mutable, meaning they can change in place without needing to be relabled.

A common mistake for those coming to Python from R, is to write `lst = lst.append(100)`, which overwrites `lst` with the value `None`.

===

The `id()` function can help you keep track of your objects, and help you understand how the Python language works.

```{python}
id(None)
```

```{python}
x = lst.append(200)
id(x)
```

===

One thing about mutable objects that may trip you up, is that the same object can have multiple references.

```{python, term=False}
same_lst = lst
same_lst.append(300)
```
```{python}
lst
```

The variables `lst` and `same_lst` are both references to the same object, which Python stores internally as `id(lst)`
