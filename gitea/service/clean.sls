# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

gitea-service-clean-service-dead:
  service.dead:
    - name: {{ gitea.service.name }}
    - enable: False
