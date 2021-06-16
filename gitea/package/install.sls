# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

gitea-depends-installed:
  pkg.installed:
    - pkgs:
  {%- for package in gitea.depends.name %}
      - {{ package }}
  {% endfor %}

gitea-binary:
  file.managed:
    - name: {{ gitea.install_dir }}/gitea
    - source: {{ gitea.binary_url }}
{%- if gitea.binary_hash %}
    - source_hash: {{ gitea.binary_hash }}
{%- else %}
    - skip_verify: True
{%- endif %}
    - mode: 755
    - makedirs: True
