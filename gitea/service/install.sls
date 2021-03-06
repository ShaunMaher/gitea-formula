{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- set sls_package_user = tplroot ~ '.system-user' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{# TODO: conditional based on init system?? -#}
gitea-systemd-file:
  file.managed:
    - name: /etc/systemd/system/gitea.service
    - source: {{ files_switch(['gitea.service.jinja'],
                              lookup='gitea-config-file-file-managed'
                 )
              }}
    - require:
      - sls: {{ sls_package_install }}
    - template: jinja
    - context:
        tpldir: {{ tpldir }}

gitea-reload-systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: gitea-systemd-file

{{ gitea.logs_dir }}:
  file.directory:
    - user: {{ gitea.system_user }}
    - group: {{ gitea.system_user }}
    - recurse:
      - user
      - group
    - require:
      - sls: {{ sls_package_user }}

{{ gitea.repo_root_dir }}:
  file.directory:
    - user: {{ gitea.system_user }}
    - group: {{ gitea.system_user }}
    - recurse:
      - user
      - group
    - require:
      - sls: {{ sls_package_user }}

{{ gitea.data_dir }}:
  file.directory:
    - user: {{ gitea.system_user }}
    - group: {{ gitea.system_user }}
    - recurse:
      - user
      - group
    - require:
      - sls: {{ sls_package_user }}

{{ gitea.working_dir }}:
  file.directory:
    - user: {{ gitea.system_user }}
    - group: {{ gitea.system_user }}
    - recurse:
      - user
      - group
    - require:
      - sls: {{ sls_package_user }}
