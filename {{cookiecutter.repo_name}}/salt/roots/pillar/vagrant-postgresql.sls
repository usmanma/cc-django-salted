postgresql:
  db: {{ cookiecutter.repo_name }}_db
  user: {{ cookiecutter.repo_name }}_user
  password: {{ cookiecutter.repo_name }}_password
  createdb: True
