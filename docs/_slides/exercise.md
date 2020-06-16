---
---

## Exercises

===

### Exercise 1

Produce a map of Maryland counties with the county that contains SESYNC colored in red.

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Use `st_buffer` to create a 5km buffer around the `state_md` border and plot it as a dotted line (`plot(..., lty = 'dotted')`) over the true state border. **Hint**: check the layer's units with `st_crs()` and express any distance in those units.

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

The function `cellStats` aggregates across an entire raster. Use it to figure out the proportion of `nlcd` pixels that are covered by deciduous forest (value = 41).

[View solution](#solution-3)
{:.notes}

===

## Solutions

===

### Solution 1



~~~r
> plot(counties_md$geometry)
> overlay	<- st_within(sesync, counties_md)
> counties_sesync <- counties_md[overlay[[1]], 'geometry']
> plot(counties_sesync, col = "red", add = TRUE)
> plot(sesync, col = 'green', pch = 20, add = TRUE)
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-1)
{:.notes}

===

## Solution 2



~~~r
> bubble_md <- st_buffer(state_md, 5000)
> plot(state_md)
> plot(bubble_md, lty = 'dotted', add = TRUE)
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-2)
{:.notes}

===

### Solution 3



~~~r
> cellStats(nlcd == 41, "mean")
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-3)
{:.notes}
