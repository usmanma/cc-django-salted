include:
  - uwsgi

{{ cookiecutter.repo_name }}-uwsgi:
  file.managed:
    - name: /etc/uwsgi/apps-available/{{ cookiecutter.repo_name }}.ini
    - source: salt://{{ cookiecutter.repo_name }}/uwsgi.ini
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 755
    - require:
      - pip: uwsgi

enable-uwsgi-app:
  file.symlink:
    - name: /etc/uwsgi/apps-enabled/{{ cookiecutter.repo_name }}.ini
    - target: /etc/uwsgi/apps-available/{{ cookiecutter.repo_name }}.ini
    - force: false
    - require:
      - file: {{ cookiecutter.repo_name }}-uwsgi
      - file: /etc/uwsgi/apps-enabled