{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- set sls_package_user = tplroot ~ '.user' %}
{%- from tplroot ~ "/map.jinja" import gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{# TODO: conditional based on init system?? -#}
gitea-systemd-file:
  file.managed:
    - name: /etc/systemd/system/gitea.service
    - source: {{ files_switch(['gitea.service.jinja'],
                              lookup='gitea-config-file-file-managed'
                 )
              }}
    - template: jinja
