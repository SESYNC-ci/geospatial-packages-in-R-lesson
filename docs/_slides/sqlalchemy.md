---
---

## SQLAlchemy

The


~~~python
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine

# Create a "base" of the ORM that can infer the database schema
Base = automap_base()

# Connect to a database and read the database schema
engine = create_engine('postgresql+pygresql://@localhost/portal')
Base.prepare(engine, reflect=True)
~~~
{:.text-document title="worksheet.py"}

~~~~{.python}
<class 'ModuleNotFoundError'>
No module named 'pgdb'
~~~~~~~~~~~~~




~~~python
>>> Base.classes.keys()
[]

~~~
{:.output}



===

## Object Relational Mapper (ORM)


~~~python
Plots = Base.classes['species']
Animals = Base.classes['animals']
~~~
{:.text-document title="worksheet.py"}

~~~~{.python}
<class 'KeyError'>
'species'
~~~~~~~~~~~~~




~~~python
>>> new_animal = Animals(genus='Ursus', species='major')
Traceback (most recent call last):
  File "< chunk 4 named None >", line 1, in <module>
NameError: name 'Animals' is not defined
>>> type(new_animal)
Traceback (most recent call last):
  File "< chunk 4 named None >", line 1, in <module>
NameError: name 'new_animal' is not defined

~~~
{:.output}



===

## Session


~~~python
Session = sessionmaker(bind=engine)
~~~
{:.text-document title="worksheet.py"}

~~~~{.python}
<class 'NameError'>
name 'engine' is not defined
~~~~~~~~~~~~~



===
