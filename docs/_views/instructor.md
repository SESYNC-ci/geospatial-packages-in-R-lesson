---
layout: instructor
style: css/slideshow.css
reveal: https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.5.0
reveal-theme: /css/theme/sky.css
---

<section markdown="1">

# {{ site.data.lesson.title }}
{:style="text-transform: none;"}

{% if site.data.lesson.subtitle %}
## {{ site.data.lesson.subtitle }}
{:style="text-transform: none;"}
{% endif %}

Lesson {{ site.data.lesson.lesson }} with *{{ site.data.lesson.instructor }}*
{:style="text-align: center;"}

</section>

{% include section.html %}
