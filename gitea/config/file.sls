# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- set sls_package_user = tplroot ~ '.system-user' %}
{%- set sls_package_service = tplroot ~ '.service' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}
  - {{ sls_package_user }}
  - {{ sls_package_service }}.running
  - {{ sls_package_service }}.restart

gitea-config-file-file-managed:
  file.managed:
    - name: {{ gitea.conf_dir }}/{{ gitea.conf_file }}
    - source: {{ files_switch(['app.ini.jinja'],
                              lookup='gitea-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: {{ gitea.system_user }}
    - group: {{ gitea.system_user }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        gitea: {{ gitea | json }}
        tpldir: {{ tpldir }}
    - require_in:
      - service: gitea-service-running-service-running
    - watch_in:
      - module: gitea-restart
