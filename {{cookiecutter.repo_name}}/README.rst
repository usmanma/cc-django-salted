{{cookiecutter.project_name}}
==============================

{{cookiecutter.description}}


:LICENSE: BSD

Deployment
------------

:TODO: Write deployment guide

Issues
------

* Salt fails to pip install requirements into virtual environment initially. 
    This can be resolved by asking salt to update the state a second time::
        
        fab vagrant updatestate

* Some code changes result in odd behaviour as Django requires a restart. To do
    this, issue the following::
        
        fab vagrant touchwsgi
    
    This "touch"es the uwsgi configuration causing uwsgi emperor to restart the
    workers.