---
layout: instructor
style: slideshow.css
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

{% for sorted in site.data.lesson.sorter %}
{% if sorted == "exercise" %}{% break %}{% endif %}
{% capture id %}/slides/{{ sorted }}{% endcapture %}
{% assign hslide = site.slides | where: "id", id | first %}
<section>
  {% assign vslides = hslide.content | split: "<p>===</p>" %}
  {% for vslide in vslides %}
  <section{% if hslide.background %}
    data-background="{{ hslide.background | relative_url }}"{% endif %}{% if hslide.class %}
    class="{{ hslide.class }}"{% endif %}>
    {{ vslide }}
  </section>
  {% endfor %}
</section>
{% endfor %}
