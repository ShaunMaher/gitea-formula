# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

gitea-user:
  user.absent:
    - name: {{ gitea.user }}
