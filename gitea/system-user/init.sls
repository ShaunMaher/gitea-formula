# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

gitea-user:
  user.present:
    - name: {{ gitea.system_user }}
    - home: {{ gitea.home_dir }}
    - createhome: True
    - shell: /bin/bash
    - system: True

{{ gitea.home_dir }}:
  file.directory:
    - user: {{ gitea.system_user }}
    - group: {{ gitea.system_user }}
    - recurse:
      - user
      - group
