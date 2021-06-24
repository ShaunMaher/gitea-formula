{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- for user in gitea.gitea_users %}
  {%- set extra_flags = "-c " ~ gitea.conf_dir ~ "/" ~ gitea.conf_file %}
  {%- set password_flags = "" %}
  {%- if user.is_admin %}
    {%- set extra_flags = extra_flags ~ " --admin" %}
  {%- endif %}
  {%- if user.must_change_password %}
    {%- set password_flags = password_flags ~ " --must-change-password" %}
  {%- endif %}
create-gitea-user-{{ user.username }}:
  cmd.run:
    - name: sudo -H -u {{ gitea.system_user }} {{ gitea.install_dir }}/gitea admin user create --username {{ user.username }} --email {{ user.email }} --password {{ user.password }} {{ extra_flags }} {{ password_flags }}
    - unless: sudo -H -u {{ gitea.system_user }} {{ gitea.install_dir }}/gitea admin user list {{ extra_flags}} | grep "^[[:digit:]]*[[:space:]]*{{ user.username }}[[:space:]]"
{% endfor %}
