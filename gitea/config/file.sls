# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- set sls_package_user = tplroot ~ '.user' %}
{%- from tplroot ~ "/map.jinja" import gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}
  - {{ sls_package_user }}

gitea-config-file-file-managed:
  file.managed:
    - name: {{ gitea.conf_file }}
    - source: {{ files_switch(['app.ini.jinja'],
                              lookup='gitea-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: {{ gitea.user }}
    - group: {{ gitea.user }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        gitea: {{ gitea | json }}
    - require_in:
      - service: gitea-service
    - watch_in:
      - module: gitea-restart
