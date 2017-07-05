---
---

## Python packages for scientific computing

So far we have only covered elements of the base Python language. However, most of
Python's useful tools for scientific programming can be found in packages that extend
its base functionalities. 

===

## NumPy

Because Python lists are meant to contain elements of any data type, they are not
so useful as numeric vectors. In particular, the `+` and `*` operations do not
perform numerical calculations when applied to lists, rather, they respectively 
concatenate and duplicate list elements.


~~~python
>>> [1, 2] + [3, 4]
[1, 2, 3, 4]

~~~
{:.output}




~~~python
>>> [5, 6] * 2
[5, 6, 5, 6]

~~~
{:.output}




===

The **NumPy** package and its `array` type provide a solution to define vectors,
matrices and higher-dimension arrays.


~~~python
import numpy as np
vect = np.array([5, 20, 12])
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> vect
array([ 5, 20, 12])

~~~
{:.output}



The first line of this code, `import numpy as np`, gives Python access to functions
from the `numpy` package, using the `package.function` syntax. To save time typing 
package names, Python programmers often define short aliases for them, such as `np` 
here. This allows us to write `np.array` instead of `numpy.array` on the following 
line.
{:.notes}

===

The definition of the array itself looks much like a Python list, and array
subsetting follows the same conventions as list subsetting. The main difference is
for multidimensional arrays, where the indices in each dimensions can be 
separated by commas within one set of brackets. As an example, we create a 2 x 3
matrix and selected the first two columns.


~~~python
mat = np.array([[1, 2, 3], [4, 5, 6]])
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> mat[:, 0:2]
array([[1, 2],
       [4, 5]])

~~~
{:.output}



===

The initial ":" (with no indices) is interpreted as "select all rows".

Arithmetic operators and basic mathematical functions (e.g. exp, sqrt) are
applied element-wise to NumPy arrays.


~~~python
>>> vect + np.array([1, 2, 3])
array([ 6, 22, 15])

~~~
{:.output}



===


~~~python
>>> vect * 2
array([10, 40, 24])

~~~
{:.output}




~~~python
>>> mat * vect
array([[  5,  40,  36],
       [ 20, 100,  72]])

~~~
{:.output}



===

In the last example, `vect` was multipled element-wise to each row of `mat`. To 
multiply a matrix and a vector (or two matrices, or two vectors in a dot-product), 
use the NumPy `dot` function.


~~~python
>>> np.dot(mat, vect)
array([ 81, 192])

~~~
{:.output}



===

## Pandas

If you have used the statistical programming language R, you are familiar with
*data frames*, two-dimensional data structures where each column can hold a 
different type of data, as in a spreadsheet.

The data analysis library **pandas** provides a data frame object type for
Python, along with functions to subset, filter reshape and aggregate data
stored in data frames.

===

After importing pandas, we call its `read_csv` function to load the Portal 
surveys data from the file `surveys.csv`.


~~~python
import pandas as pd
surveys = pd.read_csv("data/surveys.csv")
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> surveys.head()
   record_id  month  day  year  plot_id species_id sex
hindfoot_length  \
0          1      7   16  1977        2         NL   M
32.0
1          2      7   16  1977        3         NL   M
33.0
2          3      7   16  1977        2         DM   F
37.0
3          4      7   16  1977        7         DM   M
36.0
4          5      7   16  1977        3         DM   M
35.0

   weight
0     NaN
1     NaN
2     NaN
3     NaN
4     NaN

~~~
{:.output}



The `head(n=5)` method of a data frame returns its first `n` rows.

===

There are many ways to slice a Pandas DataFrame.
To select a subset of rows and/or columns by name, use the `loc` attribute and `[` for indexing.


~~~python
>>> surveys.loc[:, ['plot_id', 'species_id']]
       plot_id species_id
0            2         NL
1            3         NL
2            2         DM
3            7         DM
4            3         DM
5            1         PF
6            2         PE
7            1         DM
8            1         DM
9            6         PF
10           5         DS
11           7         DM
12           3         DM
13           8         DM
14           6         DM
15           4         DM
16           3         DS
17           2         PP
18           4         PF
19          11         DS
20          14         DM
21          15         NL
22          13         DM
23          13         SH
24           9         DM
25          15         DM
26          15         DM
27          11         DM
28          11         PP
29          10         DS
...        ...        ...
35519        9         SF
35520        9         DM
35521        9         DM
35522        9         DM
35523        9         PB
35524        9         OL
35525        8         OT
35526       13         DO
35527       13         US
35528       13         PB
35529       13         OT
35530       13         PB
35531       14         DM
35532       14         DM
35533       14         DM
35534       14         DM
35535       14         DM
35536       14         DM
35537       15         PB
35538       15         SF
35539       15         PB
35540       15         PB
35541       15         PB
35542       15         PB
35543       15         US
35544       15         AH
35545       15         AH
35546       10         RM
35547        7         DO
35548        5        NaN

[35549 rows x 2 columns]

~~~
{:.output}

===

As with lists, `:` by itself indicates all the rows (or columns). Unlike lists, the `loc` attribute returns both endpoints of a slice.


~~~python
>>> surveys.loc[2:4, 'plot_id':'sex']
   plot_id species_id sex
2        2         DM   F
3        7         DM   M
4        3         DM   M

~~~
{:.output}



===

Use the `iloc` attribute of a DataFrame to get rows and/or columns by position, which behaves identically to list indexing.


~~~python
>>> surveys.iloc[2:4, 4:6]
   plot_id species_id
2        2         DM
3        7         DM

~~~
{:.output}



===

The default indexing for a DataFrame, without using the `loc` or `iloc` attributes, is by column name.


~~~python
>>> surveys[['hindfoot_length', 'weight']].describe()
       hindfoot_length        weight
count     31438.000000  32283.000000
mean         29.287932     42.672428
std           9.564759     36.631259
min           2.000000      4.000000
25%          21.000000     20.000000
50%          32.000000     37.000000
75%          36.000000     48.000000
max          70.000000    280.000000

~~~
{:.output}



===

The `loc` attribute also allows logical indexing, i.e. the use of a boolean array of appropriate length for the selected dimension.

The subset of `surveys` where the species is "DM" is extracted into a new data frame.


~~~python
surveys_dm = surveys.loc[surveys['species_id'] == 'DM', ]
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> surveys_dm.head()
   record_id  month  day  year  plot_id species_id sex
hindfoot_length  \
2          3      7   16  1977        2         DM   F
37.0
3          4      7   16  1977        7         DM   M
36.0
4          5      7   16  1977        3         DM   M
35.0
7          8      7   16  1977        1         DM   M
37.0
8          9      7   16  1977        1         DM   F
34.0

   weight
2     NaN
3     NaN
4     NaN
7     NaN
8     NaN

~~~
{:.output}



===

The `query()` method accepts an expression that may reference columns, increasing the readability of the same operation


~~~python
surveys_dm = surveys.query('species_id == "DM"')
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> surveys_dm.head()
   record_id  month  day  year  plot_id species_id sex
hindfoot_length  \
2          3      7   16  1977        2         DM   F
37.0
3          4      7   16  1977        7         DM   M
36.0
4          5      7   16  1977        3         DM   M
35.0
7          8      7   16  1977        1         DM   M
37.0
8          9      7   16  1977        1         DM   F
34.0

   weight
2     NaN
3     NaN
4     NaN
7     NaN
8     NaN

~~~
{:.output}



===

Aggregation of records in a DataFrame by value of a given variable is performed with the `groupby()` method. The resulting "grouped" DataFrame has additional methods (like `mean()`) that summarize each group, producing a DataFrame with one record for each group.


~~~python
dm_stats = (
  surveys_dm
  .groupby('sex')
  ['hindfoot_length', 'weight']
  .mean()
  )
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> dm_stats
     hindfoot_length     weight
sex
F          35.712692  41.609685
M          36.188229  44.353134

~~~
{:.output}



===

## Exercise 6

The `count` method for DataFrames (e.g. `surveys.count()`) returns the number of rows
in a data frame. Find out which month had the most observations recorded
in `surveys`.

===

## Matplotlib

The **matplotlib** package and its **pyplot** module is the workhorse for all
Python vizualizations. Many objects have their own methods to create
plots using **matplotlib**, including Pandas DataFrames.

The **pyplot** module controls the creation, management and export of plots produced
by other objects or by direct calls to the family of `pyplot.plot()` functions.

===

The DataFrame `plot()` method creates a scatterplot, here for the `weight` versus the `hindfoot_length` for records in the `surveys_dm` data.


~~~python
import matplotlib.pyplot as plt
ax = surveys_dm.plot('hindfoot_length', 'weight', kind = 'scatter')
~~~
{:.text-document title="worksheet.py"}

![]({{ site.baseurl }}/images/packages_scatter_1.png)

The `ax` object holds the plot description, and depending on the IDE and operating system the plot may or may not appear. If it does not,  the `plt.show()` function displays the active figure on screen.
{:.notes}

===

Besides `scatter`, the `plot` method supports other kinds of plots such
as bar and line graphs. To create the histogram of one variable from the data
frame, you may use a different method, `hist`.


~~~python
ax = surveys_dm.hist('weight')
plt.savefig('hist_weight.pdf')
~~~
{:.text-document title="worksheet.py"}

![]({{ site.baseurl }}/images/packages_hist_1.png)
