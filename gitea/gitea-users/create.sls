{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- for user in gitea.gitea_users %}
  {%- set extra_flags = "-c " ~ gitea.conf_dir ~ "/" ~ gitea.conf_file %}
  {%- set password_flags = "" %}
  {%- if gitea.gitea_users[user].is_admin %}
    {%- set extra_flags = extra_flags ~ " --admin" %}
  {%- endif %}
  {%- if gitea.gitea_users[user].must_change_password %}
    {%- set password_flags = password_flags ~ " --must-change-password" %}
  {%- endif %}
  {%- set unless_cmd = "sudo -H -u " ~ gitea.system_user ~ " " ~ gitea.install_dir ~ "/gitea" ~
     " admin user list " ~ extra_flags ~ " | grep '^[[:digit:]]*[[:space:]]*" ~ gitea.gitea_users[user].username ~ "[[:space:]]'" %}
  {%- set create_command = "sudo -H -u " ~ gitea.system_user ~ " " ~ gitea.install_dir ~ "/gitea" ~
     " admin user create --username " ~ gitea.gitea_users[user].username ~ " --email " ~ gitea.gitea_users[user].email ~ " --password " ~
     gitea.gitea_users[user].password ~ " " ~ extra_flags ~ " " ~ password_flags %}
create-gitea-user-{{ user }}:
  cmd.run:
    - name: {{ create_command }}
    - unless: {{ unless_cmd }}
{% endfor %}
