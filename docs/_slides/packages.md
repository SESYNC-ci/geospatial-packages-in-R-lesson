---
---

## Python packages

So far we have only covered elements of the core Python language. However, most of
Python's useful tools for scientific programming can be found in contributed packages
that extend Python in every direction.

===

## PyPI

The [Python Package Index](https://pypi.python.org) is the online directory of contributed Python packages. Interaction with PyPI typically
take place outside of Python, using the command line utility `pip` or a GUI package manager.

The vast majority of Python packages can be installed with the command `pip install`. For example, to install the [pandas](){:.pylib} package:

```
pip install pandas
```
{:.input}

The packages for this lesson are already installed in SESYNC's "teaching-lab" Docker container.

===

To access the tools provided by a package, once it has been installed, use the `import` command. Their are several variations that
preciesly control the tools made available.

| Syntax                               | Result                                      |
|--------------------------------------+---------------------------------------------|
| `import pandas`                      | all modules are available following pandas. |
| `import pandas as pd`                | all modules are available following pd.     |
| `from pandas import DataFrame`       | the DataFrame module is available           |
| `from pandas import DataFrame as DF` | the label DF points to pandas.DataFrame     |
