include:
  - nginx

{{ cookiecutter.repo_name }}-nginx-conf:
  file.managed:
    - name: /etc/nginx/sites-available/{{ cookiecutter.repo_name }}.conf
    - source: salt://{{ cookiecutter.repo_name }}/nginx.conf
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 755
    - require:
      - pkg: nginx

# Symlink and thus enable the virtual host
{{ cookiecutter.repo_name }}-enable-nginx:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ cookiecutter.repo_name }}.conf
    - target: /etc/nginx/sites-available/{{ cookiecutter.repo_name }}.conf
    - force: false
    - require:
      - file: {{ cookiecutter.repo_name }}-nginx-conf