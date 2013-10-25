base:
  '{{ cookiecutter.repo_name|replace("_", "-") }}.local':
    - vagrant-django
    - vagrant-wheel
    - vagrant-wheel
    - vagrant-uwsgi
    - vagrant-postgresql