base:
  '*':
    - requirements.essential
    - ssh
  '{{ cookiecutter.repo_name|replace("_", "-") }}.local':
    - {{ cookiecutter.repo_name }}.requirements
    - {{ cookiecutter.repo_name }}.nginx
    - {{ cookiecutter.repo_name }}.share
    - {{ cookiecutter.repo_name }}.venv
    - {{ cookiecutter.repo_name }}.uwsgi
    - {{ cookiecutter.repo_name }}.postgresql
