# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_service_install = tplroot ~ '.service.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

include:
  - {{ sls_config_file }}
  - {{ sls_service_install }}

gitea-service-running-service-running:
  service.running:
    - name: {{ gitea.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
      # TODO: check_cmd: do something to make sure the service is listening on
      # the desired port

gitea-service-running-service-failed:
  cmd.run:
    # TODO: For systems that don't use systemd?
    - name: systemctl status gitea.service
    - onfail:
      - service: gitea-service-running-service-running
