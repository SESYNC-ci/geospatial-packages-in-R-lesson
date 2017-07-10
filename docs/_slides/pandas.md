---
---

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
