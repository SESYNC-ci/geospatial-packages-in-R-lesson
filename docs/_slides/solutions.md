---
---

## Exercise solutions

===

### Solution 1


~~~r
plot(counties_md)
frederick <- counties_md[counties_md$NAME == "Frederick", ]
plot(frederick, add = TRUE, col = "red")
~~~
{:.input}

[Return](#exercise-1)
{:.notes}

===

### Solution 2


~~~r
buffer <- gBuffer(state_md, width = 5000)
plot(state_md)
plot(buffer, lty = "dotted", add = TRUE)
~~~
{:.input}

[Return](#exercise-2)
{:.notes}

===

### Solution 3


~~~r
cellStats(nlcd == 41, "mean")
~~~
{:.input}

[Return](#exercise-3)
{:.notes}
