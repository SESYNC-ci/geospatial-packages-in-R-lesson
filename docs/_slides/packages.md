---
---

## Python packages for scientific computing

So far we have only covered elements of the base Python language. However, most of
Python's useful tools for scientific programming can be found in packages that extend
its base functionalities. 

===

### NumPy

Because Python lists are meant to contain elements of any data type, they are not
so useful as numeric vectors. In particular, the `+` and `*` operations do not
perform numerical calculations when applied to lists, rather, they respectively 
concatenate and duplicate list elements.


~~~python
>>> add_list = [1, 2] + [3, 4]
>>> mult_list = [5, 6] * 2
>>> print(add_list, mult_list)
[1, 2, 3, 4] [5, 6, 5, 6]

~~~
{:.term}



===

The **NumPy** package and its `array` type provide a solution to define vectors,
matrices and higher-dimension arrays.


~~~python
>>> import numpy as np
>>> vect = np.array([5, 20, 12])
>>> vect
array([ 5, 20, 12])

~~~
{:.term}



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
>>> mat = np.array([[1, 2, 3], [4, 5, 6]])
>>> mat[:, 0:2]
array([[1, 2],
       [4, 5]])

~~~
{:.term}



===

The initial ":" (with no indices) is interpreted as "select all rows".

Arithmetic operators and basic mathematical functions (e.g. exp, sqrt) are
applied element-wise to NumPy arrays.


~~~python
>>> vect + np.array([1, 2, 3])
array([ 6, 22, 15])

~~~
{:.term}



===


~~~python
>>> vect * 2
array([10, 40, 24])

~~~
{:.term}




~~~python
>>> mat * vect
array([[  5,  40,  36],
       [ 20, 100,  72]])

~~~
{:.term}



===

In the last example, `vect` was multipled element-wise to each row of `mat`. To 
multiply a matrix and a vector (or two matrices, or two vectors in a dot-product), 
use the `dot` method.


~~~python
>>> mat.dot(vect)   # Alternate syntax is np.dot(mat, vect)
array([ 81, 192])

~~~
{:.term}



===

### Pandas

If you have used the statistical programming language R, you are familiar with
*data frames*, two-dimensional data structures where each column can hold a 
different type of data, as in a spreadsheet.

The data analysis library **pandas** provides a data frame object type for
Python, along with functions to subset, filter reshape and aggregate data
stored in data frames.

===

After importing pandas, we call its `read_csv` function to load the Portal 
surveys data from the file *surveys.csv*.


~~~python
>>> import pandas as pd
>>> surveys = pd.read_csv("data/surveys.csv")
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
{:.term}



===

By default, the `head` method of a data frame shows its first five rows.
To select a subset of rows and columns from the data frame, we can use
the `loc` method, specifying a range of row indices and a list of 
column names. Note that unlike the usual way we specify number ranges in
Python, the end of the range (row 3) is *included* here.


~~~python
>>> surveys.loc[1:3, ['plot_id', 'species_id']]
   plot_id species_id
1        3         NL
2        2         DM
3        7         DM

~~~
{:.term}



===

We can also select a whole column by writing its name in square brackets. Here,
we select the *weight* column and call the `describe` method to get summary
statistics for that column.


~~~python
>>> surveys['weight'].describe()
/usr/local/lib/python3.5/site-
packages/numpy/lib/function_base.py:3834: RuntimeWarning: Invalid
value encountered in percentile
  RuntimeWarning)
count    32283.000000
mean        42.672428
std         36.631259
min          4.000000
25%               NaN
50%               NaN
75%               NaN
max        280.000000
Name: weight, dtype: float64

~~~
{:.term}



===

The `loc` method can also filter rows, if we specify a logical condition in
place of the row indices. For example, here is how we could get the subset of
*surveys* where the species is "DM", and save it in a new data frame. Note 
that when we don't specify any column names after the comma, all columns are
kept.


~~~python
>>> surveys_dm = surveys.loc[surveys['species_id'] == 'DM', ]

~~~
{:.term}



===

Another useful feature of pandas is the `groupby` method, which defines
groups of rows based on their values for a given variable. After grouping
a data frame, we can use statistical methods (like `mean`) to get summary
statistics by group.


~~~python
>>> surveys_group = surveys_dm.groupby('sex')
>>> surveys_group['hindfoot_length', 'weight'].mean()
     hindfoot_length     weight
sex
F          35.712692  41.609685
M          36.188229  44.353134

~~~
{:.term}



===

**Exercise**: Knowing that the `count` method (e.g. `surveys.count()`) returns the number of rows in a data frame, find which month had the most observations recorded
in *surveys*.

===

### matplotlib / pyplot

To complete this lesson, we will draw plots of our data using the 
**matplotlib** package and more specifically its **pyplot** subpackage.
The pandas package works particularly well with pyplot, since it defines
plotting methods that work specifically for data frames. 

===

In the following, we import pyplot, then call the `plot` method to create
a scatterplot of *weight* against *hindfoot_length* from the *surveys_dm*
data. The `plt.show()` function opens a new window showing the active plot.


~~~python
>>> import matplotlib.pyplot as plt
>>> surveys_dm.plot('hindfoot_length', 'weight', kind = 'scatter')
<matplotlib.axes._subplots.AxesSubplot object at 0x10bfe5128>
>>> plt.show()

~~~
{:.term}

![]({{ site.baseurl }}/images/packages_figure13_1.png)\


===

Besides `scatter`, the `plot` method supports other kinds of plots such
as bar and line graphs. To create the histogram of one variable from the data
frame, you may use a different method, `hist`.


~~~python
>>> plt.close() # close the current plot to start a new one
>>> surveys_dm.hist('weight')
array([[<matplotlib.axes._subplots.AxesSubplot object at
0x10c0022b0>]], dtype=object)
>>> plt.show()

~~~
{:.term}

![]({{ site.baseurl }}/images/packages_figure14_1.png)\

