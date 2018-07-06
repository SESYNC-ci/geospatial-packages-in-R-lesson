---
layout: default
style: /css/static.css
---

# {{ site.title }}
{:style="text-transform: none;"}

{% if site.subtitle %}
## {{ site.subtitle }}
{:style="text-transform: none;"}
{% endif %}

{% if site.handouts %}
> Handouts for this lesson need to be saved on your computer. [Download]({{ site.github.releases_url }}/download/{{ site.tag }}/handouts.zip) and unzip this material into the directory (a.k.a. folder) where you plan to work.
{% endif %}

<nav id="ToC" markdown="1">
{% for sorted in site.slide_sorter %}{% capture id %}/slides/{{ sorted }}{% endcapture %}{% assign hslide = site.slides | where: "id", id | first %}
- [{{ hslide.excerpt | strip_html | strip }}](#{{ id }}){% endfor %}
</nav>

{% for sorted in site.slide_sorter %}{% capture id %}/slides/{{ sorted }}{% endcapture %}{% assign hslide = site.slides | where: "id", id | first %}
---
<a name="{{ id }}"></a>
{% assign vslides = hslide.content | split: "<p>===</p>" %}
{% for vslide in vslides %}
{{ vslide }}
{% endfor %}
[Top of Section](#{{ id }})
{:.ToS}

{% endfor %}
