{% raw %}
include:
  - postgresql

{% endraw %}{{ cookiecutter.repo_name }}{% raw %}-postgres-user:
  postgres_user.present:
    - name: {{ pillar['postgresql']['user'] }}
    - createdb: {{ pillar['postgresql']['createdb'] }}
    - password: {{ pillar['postgresql']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql

{% endraw %}{{ cookiecutter.repo_name }}{% raw %}-postgres-db:
  postgres_database.present:
    - name: {{ pillar['postgresql']['db'] }}
    - encoding: UTF8
    - lc_ctype: en_GB.UTF8
    - lc_collate: en_GB.UTF8
    - template: template0
    - owner: {{ pillar['postgresql']['user'] }}
    - runas: postgres
    - require:
        - postgres_user: {% endraw %}{{ cookiecutter.repo_name }}{% raw %}-postgres-user
{% endraw %}