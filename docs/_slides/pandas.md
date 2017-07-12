---
---

## Pandas

If you have used the statistical programming language R, you are familiar with
"data frames", two-dimensional data structures where each column can hold a 
different type of data, as in a spreadsheet.

The data analysis library [pandas](){:.pylib} provides a data frame object type for
Python, along with functions to subset, filter reshape and aggregate data
stored in data frames.

===

After importing [pandas](){:.pylib}, we call its `read_csv` function to load the Portal 
animals data from the file `animals.csv`.


~~~python
import pandas as pd
animals = pd.read_csv("data/animals.csv")
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> animals.dtypes
id                   int64
month                int64
day                  int64
year                 int64
plot_id              int64
species_id          object
sex                 object
hindfoot_length    float64
weight             float64
dtype: object
~~~
{:.output}



===

There are many ways to slice a `DataFrame`. To select a subset of rows and/or columns by name, use the `loc` attribute and `[` for indexing.


~~~python
animals.loc[:, ['plot_id', 'species_id']]
~~~
{:.text-document title="worksheet.py"}



===

As with lists, `:` by itself indicates all the rows (or columns). Unlike lists, the `loc` attribute returns both endpoints of a slice.


~~~python
>>> animals.loc[2:4, 'plot_id':'sex']
   plot_id species_id sex
2        7         DM   M
3        3         DM   M
4        1         PF   M
~~~
{:.output}



===

Use the `iloc` attribute of a DataFrame to get rows and/or columns by position, which behaves identically to list indexing.


~~~python
>>> animals.iloc[2:4, 4:6]
   plot_id species_id
2        7         DM
3        3         DM
~~~
{:.output}



===

The default indexing for a DataFrame, without using the `loc` or `iloc` attributes, is by column name.


~~~python
animals[['hindfoot_length', 'weight']].describe()
~~~
{:.text-document title="worksheet.py"}



===

The `loc` attribute also allows logical indexing, i.e. the use of a boolean array of appropriate length for the selected dimension.

The subset of `animals` where the species is "DM" is extracted into a new data frame.


~~~python
animals_dm = animals.loc[animals['species_id'] == 'DM', ]
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> animals_dm.head()
   id  month  day  year  plot_id species_id sex  hindfoot_length  weight
1   3      7   16  1977        2         DM   F             37.0     NaN
2   4      7   16  1977        7         DM   M             36.0     NaN
3   5      7   16  1977        3         DM   M             35.0     NaN
6   8      7   16  1977        1         DM   M             37.0     NaN
7   9      7   16  1977        1         DM   F             34.0     NaN
~~~
{:.output}



<!--
===

The `query()` method accepts an expression that may reference columns, increasing the readability of the same operation


~~~python
animals_dm = animals.query('species_id == "DM"')
~~~
{:.text-document title="worksheet.py"}



~~~python
>>> animals_dm.head()
   id  month  day  year  plot_id species_id sex  hindfoot_length  weight
1   3      7   16  1977        2         DM   F             37.0     NaN
2   4      7   16  1977        7         DM   M             36.0     NaN
3   5      7   16  1977        3         DM   M             35.0     NaN
6   8      7   16  1977        1         DM   M             37.0     NaN
7   9      7   16  1977        1         DM   F             34.0     NaN
~~~
{:.output}


-->

===

Aggregation of records in a DataFrame by value of a given variable is performed with the `groupby()` method. The resulting "grouped" DataFrame has additional methods (like `mean()`) that summarize each group, producing a DataFrame with one record for each group.


~~~python
dm_stats = (
  animals_dm
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

The `count` method for DataFrames (e.g. `animals.count()`) returns the number of rows
in a data frame. Find out which month had the most observations recorded
in `animals` using `groupby()` and `count()`.
