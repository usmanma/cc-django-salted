django:
  path: /vagrant/{{ cookiecutter.repo_name }}
  settings: config.settings
  virtualenv: /home/vagrant/env
  user: vagrant
  group: vagrant
  requirements: salt://{{ cookiecutter.repo_name }}/requirements.txt
