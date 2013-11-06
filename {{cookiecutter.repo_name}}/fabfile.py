from fabric.api import *
from fabric import colors
from fabtools.vagrant import vagrant

import os, hashlib

# Local paths
LOCAL_ROOT = os.path.dirname(os.path.realpath(__file__))

# Server paths
PROJECT_NAME = "{{ cookiecutter.repo_name }}"
PROJECT_PATH = "/vagrant/{{ cookiecutter.repo_name }}"

MANAGE_BIN = "/vagrant/{{ cookiecutter.repo_name }}/manage.py"
VENV_PATH = "/home/vagrant/env"
WHEEL_PATH = "/home/vagrant/wheel"
WHEEL_NAME = "wheel-requirements.tar.gz"

UWSGI_CONFIG = "/etc/uwsgi/apps-enabled/{{ cookiecutter.repo_name }}.ini"

def _md5_for_file(filename, block_size=2**20):
    filename = os.path.join(LOCAL_ROOT, filename)
    f = open(filename)
    md5 = hashlib.md5()
    while True:
        data = f.read(block_size)
        if not data:
            break
        md5.update(data)
    f.close()
    return md5.hexdigest()

@task
def manage_py(command):
    """ Runs a manage.py command on the server """
    run('{python} {manage} {command}'.format(python=VENV_PATH + "/bin/python",
                                             manage=MANAGE_BIN,
                                             command=command))

@task
def syncdb():
    """ Django syncdb command."""
    manage_py("syncdb --noinput")

@task
def migrate():
    """ Django South migrate command."""
    manage_py("migrate")

@task
def collectstatic():
    """ Run collectstatic command. """
    manage_py("collectstatic --noinput")

@task
def wheel():
    """ Create new wheel requirements file """
    # Get all the requirements
    print colors.green("Downloading and compiling requirements. This could take several minutes...")
    sudo('{pip} wheel --wheel-dir={wheel} -r {example}/requirements.txt'.format(pip=VENV_PATH + "/bin/pip",
                                                                                wheel=WHEEL_PATH + '/' + PROJECT_NAME,
                                                                                example=PROJECT_PATH),
         user="www-data",
         quiet=False)

    # Zip up
    print colors.green("Zipping all the requirements into one file...")
    with cd(WHEEL_PATH):
        sudo('tar czf {name} {project}/'.format(name=WHEEL_NAME,
                                                project=PROJECT_NAME),
             user="www-data",
             quiet=False)
        sudo('mv {name} /vagrant/'.format(name=WHEEL_NAME),
             quiet=False)

    # Create a MD5
    md5 = _md5_for_file(WHEEL_NAME)
    print colors.green('Upload the requirements and set the following MD5 in your pillar configuration: {md5}'.format(md5=md5))

@task
def updatestate():
    """ Call salt highstate to get latest state """
    sudo('salt-call state.highstate', quiet=False)

@task
def touchwsgi():
    """ Touch the uwsgi config in order to reload new code """
    sudo('touch {project_config}').format(project_config=UWSGI_CONFIG)

@task
def initialize():
    """ Initialise a new environment """
    syncdb()
    migrate()
    collectstatic()