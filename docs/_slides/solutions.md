---
---

## Solutions

===

## Solution 1




~~~r
> plot(counties_md$geometry)
> overlay	<- st_within(sesync, counties_md)
> counties_sesync <- counties_md[overlay[[1]], 'geometry']
> plot(counties_sesync, col = "red", add = TRUE)
> plot(sesync, col = 'green', pch = 20, add = TRUE)
~~~
{:.input title="Console"}


[Return](#exercise-1)
{:.notes}

===

## Solution 2



~~~r
> bubble_md <- st_buffer(state_md, 5000)
> plot(state_md)
> plot(bubble_md, lty = 'dotted', add = TRUE)
~~~
{:.input title="Console"}


[Return](#exercise-2)
{:.notes}

===

## Solution 3



~~~r
> cellStats(nlcd == 41, "mean")
~~~
{:.input title="Console"}


[Return](#exercise-3)
{:.notes}
