# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_service_install = tplroot ~ '.service.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

include:
  - {{ sls_config_file }}
  - {{ sls_package_install }}
  - {{ sls_service_install }}

gitea-service-running-service-running:
  service.running:
    - name: {{ gitea.service.name }}
    - enable: True
    - require:
      - sls: {{ sls_service_install }}
      - sls: {{ sls_package_install }}
    - watch:
      - sls: {{ sls_config_file }}
      # TODO: check_cmd: do something to make sure the service is listening on
      # the desired port

gitea-service-failed-journalctl:
  cmd.run:
    # TODO: For systems that don't use systemd?
    - name: journalctl -xe -u gitea.service | tail -50
    - onfail:
      - service: gitea-service-running-service-running

gitea-service-failed-doctor:
  cmd.run:
    # TODO: For systems that don't use systemd?
    - name: {{ gitea.install_dir }}/gitea doctor -c /etc/gitea/app.ini --log-file -
    - runas: {{ gitea.system_user }}
    - onfail:
      - service: gitea-service-running-service-running

gitea-service-failed-unit-file:
  cmd.run:
    # TODO: For systems that don't use systemd?
    - name: tail -50 /etc/systemd/system/gitea.service
    - onfail:
      - service: gitea-service-running-service-running
