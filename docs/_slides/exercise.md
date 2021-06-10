---
---

## Exercises

===

### Exercise 1

Produce a map of Maryland counties with the county that contains SESYNC colored in red, using either `plot()` or `ggplot()`. **Hint**: use `st_filter()` to find the county that contains SESYNC.

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Use `st_buffer()` to create a 5km buffer around the `state_md` border and plot it as a dotted line over the true state border. Use either `plot(..., lty = 'dotted')` or `ggplot()` with `geom_sf(..., linetype = 'dotted')`. **Hint**: check the layer's units with `st_crs()` and express any distance in those units.

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

The function `map` from the [purrr](){:.rlib} package aggregates across an entire raster. Use it to figure out the proportion of `nlcd` pixels that are covered by deciduous forest (value = `'Deciduous Forest'`). **Hint**: use `==` to make a raster where only deciduous forest cells are `TRUE`, then use `map` to apply the function `mean` to that raster.

[View solution](#solution-3)
{:.notes}

===

## Solutions

===

### Solution 1



~~~r
> counties_sesync <- st_filter(counties_md, sesync)
~~~
{:title="Console" .no-eval .input}


Solution with `plot()`:



~~~r
> plot(st_geometry(counties_md))
> plot(counties_sesync, col = 'red', add = TRUE)
> plot(sesync, col = 'green', pch = 20, add = TRUE)
~~~
{:title="Console" .no-eval .input}


Solution with `ggplot()`:



~~~r
> ggplot() +
+   geom_sf(data = counties_md, fill = NA) +
+   geom_sf(data = counties_sesync, fill = 'red') +
+   geom_sf(data = sesync, color = 'green')
~~~
{:title="Console" .no-eval .input}



[Return](#exercise-1)
{:.notes}

===

## Solution 2



~~~r
> bubble_md <- st_buffer(state_md, 5000)
~~~
{:title="Console" .no-eval .input}


Solution with `plot()`



~~~r
> plot(state_md)
> plot(bubble_md, lty = 'dotted', add = TRUE)
~~~
{:title="Console" .no-eval .input}


Solution with `ggplot()`



~~~r
> ggplot() +
+   geom_sf(data = st_geometry(state_md)) +
+   geom_sf(data = bubble_md, linetype = 'dotted', fill = NA)
~~~
{:title="Console" .no-eval .input}



[Return](#exercise-2)
{:.notes}

===

### Solution 3



~~~r
> library(purrr)
> map(nlcd == 'Deciduous Forest', mean)
~~~
{:title="Console" .no-eval .input}


[Return](#exercise-3)
{:.notes}
