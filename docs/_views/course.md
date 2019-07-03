---
layout: course
style: css/static.css
---

# {{ site.data.lesson.title }}
{:style="text-transform: none;"}

{% if site.data.lesson.subtitle %}
## {{ site.data.lesson.subtitle }}
{:style="text-transform: none;"}
{% endif %}

Lesson {{ site.data.lesson.lesson }} with *{{ site.data.lesson.instructor }}*

<nav id="ToC" markdown="1">
{% for sorted in site.data.lesson.sorter %}{% capture id %}/slides/{{ sorted }}{% endcapture %}{% assign hslide = site.slides | where: "id", id | first %}
- [{{ hslide.excerpt | strip_html | strip }}](#{{ id }}){% endfor %}
</nav>

{% for sorted in site.data.lesson.sorter %}{% capture id %}/slides/{{ sorted }}{% endcapture %}{% assign hslide = site.slides | where: "id", id | first %}
---
<a name="{{ id }}"></a>
{% assign vslides = hslide.content | split: "<p>===</p>" %}
{% for vslide in vslides %}
{{ vslide }}
{% endfor %}
[Top of Section](#{{ id }})
{:.ToS}

{% endfor %}
