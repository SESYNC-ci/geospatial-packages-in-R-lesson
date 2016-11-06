---
layout: default
style: /css/lesson.css
---

{% for sorted in site.slide_sorter %}
{% capture id %}/slides/{{ sorted }}{% endcapture %}
{% assign hslide = site.slides | where: "id", id | first %}

<a name="{{ id }}"></a>

{% assign vslides = hslide.content | split: "<p>===</p>" %}
{% for vslide in vslides %}
{{ vslide }}
{% endfor %}
  
{{ vslide.content }}

[Top of Section](#{{ id }})
{:.ToS}
  
---
  
{% endfor %}
