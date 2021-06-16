{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_service_install = tplroot ~ '.service.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

gitea-restart:
  module.wait:
    - name: service.restart
    - m_name: gitea
    - require:
      - service: gitea-service-running-service-running
    - watch:
#      - file: gitea-binary
      - file: gitea-systemd-file
