---
---

## SQLAlchemy

Working with databases from a high level programming language (Python or R) is usually a one way street: the language helps with complicated queries for pulling out data, but provides little assistance with pushing data back, especially for complicated modifications. SQLAlchemy lays the groundwork for bi-directional flow: Python objects become synchronized with database records.

After some upfront alignment between the Portal Mammals database in PostgreSQL and a Python environment, we'll be ready to go.


~~~python
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine

# Create the canvas for a map between Python objects and database records
Base = automap_base()

# Identify database, create the map from the schema, and prepare to create sessions
engine = create_engine('postgresql+pygresql://@localhost/portal')
Base.prepare(engine, reflect=True)
Session = sessionmaker(bind=engine)
~~~
{:.text-document title="{{ site.handouts }}"}



===

## Object Relational Mapper (ORM)

The ORM sets up a link between Python objects and records in a database. You could think of a table as defining
a class or data structure, in which each field corresponds to an attribute. Each record corresponds to an instance of the class.


~~~python
>>> Base.classes.keys()
['species', 'plots', 'animals']
~~~
{:.output}



The `Base` class contains a list of tables that `automap_base()` found in the PostgreSQL database.

===

Pull class definitions directly from the `Base` after it has been prepared.


~~~python
Plots = Base.classes['plots']
Animals = Base.classes['animals']
Species = Base.classes['species']
~~~
{:.text-document title="{{ site.handouts }}"}



===

Then create a new instance by calling the class "constructor" with values specified for each field.


~~~python
>>> plot = Plots(treatment='Control')
>>> plot.id
~~~
{:.output}



Note that `plot.id` is empty. We did not specify a value for `id` because we don't know what values would duplicate an existing primary key.

===

## Session

Connections to the database are made within a "session", as a safety protocol that protects against network disruptions and provides a `session.rollback()` method of aborting changes. After adding the new `plot` object to a session and commiting the change, the database and Python environments are synched.


~~~python
session = Session()
session.add(plot)
session.commit()
~~~
{:.text-document title="{{ site.handouts }}"}




~~~python
>>> plot.id
36
~~~
{:.output}



The RDBMS inserted a new record, incrementing the `id` value as designed, and reflected it back into the object `plot`.

===

## Relations

The full reach of the ORM extends into relationships between tables.

Let's pull a `species` record using the `session.query()` method.


~~~python
query = session.query(Species).filter_by(id='RO')
species = query.one()
~~~
{:.text-document title="{{ site.handouts }}"}



Not only do we have the species' attributes


~~~python
>>> species.id
'RO'
>>> species.genus
'Reithrodontomys'
~~~
{:.output}



... we have the list of every `animal` linked to this `species` by the many-to-one relationship dictated by the use of foreign keys.


~~~python
>>> species.animals_collection
[<sqlalchemy.ext.automap.animals object at 0x7f440cc3a390>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a400>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a4a8>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a588>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a630>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a710>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a7f0>, <sqlalchemy.ext.automap.animals object at 0x7f440cc3a898>]
~~~
{:.output}



===

## Update

With SQLAlchemy, you can programatically make complex updates to the data in Python, and then commit the state to the database in one transaction.

Suppose a surveyor mistakenly reversed the labels of two plots during a particular survey, and your job is to correct the database. Here are the two problematic plots.


~~~python
plot_a = session.query(Plots).filter_by(id=2).one()
plot_b = session.query(Plots).filter_by(id=12).one()
~~~
{:.text-document title="{{ site.handouts }}"}



===

Here are the animals *incorrectly* associated with each plot.


~~~python
query = session.query(Animals).filter_by(year=2002, month=1, day=12)
animals_a = query.filter(Animals.plots == plot_a).all()
animals_b = query.filter(Animals.plots == plot_b).all()
~~~
{:.text-document title="{{ site.handouts }}"}




~~~python
>>> animals_a[0].plots is plot_a
True
~~~
{:.output}



===

To swap the plots associated with all these animal records, assign the opposite plot to each `animal.plot` attribute.


~~~python
for animal in animals_a:
    animal.plot = plot_b
for animal in animals_b:
    animal.plot = plot_a
~~~
{:.text-document title="{{ site.handouts }}"}



===

Check your work ...


~~~python
>>> animals_a[0].plots is plot_b
False
~~~
{:.output}



and commit the result to the database.


~~~python
session.commit()
animals_a[0].plots is plot_b
~~~
{:.text-document title="{{ site.handouts }}"}



===

## Query

At any time, collect the result of a SQLAlchemy query into a data fram


~~~python
query = (session
    .query(Animals)
    .join(Species)
    .filter_by(taxa='Rodent')
    )
rodents = pd.read_sql(query.statement, engine)
~~~
{:.text-document title="{{ site.handouts }}"}




~~~python
>>> rodents.head()
   id  month  day  year  plot_id species_id sex  hindfoot_length  weight
0   2      7   16  1977        3         NL   M             33.0     NaN
1   3      7   16  1977        2         DM   F             37.0     NaN
2   4      7   16  1977        7         DM   M             36.0     NaN
3   5      7   16  1977        3         DM   M             35.0     NaN
4   6      7   16  1977        1         PF   M             14.0     NaN
~~~
{:.output}


