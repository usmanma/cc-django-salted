{% raw %}include:
  - nginx

# Create the Python Virtual environment
{{ pillar['django']['virtualenv'] }}:
  virtualenv.managed:
    - no_site_packages: True
    - distribute: True
    - user: {{ pillar['django']['user'] }}
    - requirements: {{ pillar['django']['requirements'] }}
    - require:
      - pkg: python-virtualenv
      - pkg: python-dev
      - pkg: postgresql-server-dev-9.1
      - pkg: libxml2-dev
      - pkg: libxslt1-dev
      - pkg: libjpeg62-dev

sync-db:
  cmd.wait:
    - name: {{ pillar['django']['virtualenv'] }}/bin/python {{ pillar['django']['path'] }}/manage.py syncdb --noinput && {{ pillar['django']['virtualenv'] }}/bin/python {{ pillar['django']['path'] }}/manage.py migrate
    - require:
      - virtualenv: {{ pillar['django']['virtualenv'] }}
{% endraw %}