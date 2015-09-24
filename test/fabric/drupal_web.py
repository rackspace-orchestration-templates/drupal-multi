import re
from fabric.api import env, run, task, hide
from envassert import detect, file, package, port, process, service
from hot.utils.test import get_artifacts, http_check


def drupal_is_responding():
    with hide('running', 'stdout'):
        site = "http://localhost:8080/"
        homepage = run("wget --quiet --output-document - %s" % site)
    if re.search('Welcome to Drupal7', homepage):
        return True
    else:
        return False


@task
def check():
    env.platform_family = detect.detect()

    assert file.is_dir("/var/www/vhosts"), '/var/www/vhosts is wrong'
    assert port.is_listening(80), 'port 80 not listening'
    assert port.is_listening(8080), 'port 8080 not listening'
    assert package.installed("varnish"), 'varnish not installed'
    assert drupal_is_responding(), 'Drupal did not respond as expected.'

    apache_process = 'apache2'
    php_package = 'php5'

    if env.platform_family == 'debian':
        apache_process = 'apache2'
        php_package = 'php5'
    elif env.platform_family == 'rhel':
        apache_process = 'httpd'
        php_package = 'php'
    else:
        raise ValueError('OS ' + env.platform_family +
                         ' unknown, update tests.')

    assert package.installed(php_package), 'php not installed'
    assert process.is_up(apache_process), 'apache is not running'
    assert service.is_enabled(apache_process), 'apache is not enabled'


@task
def artifacts():
    env.platform_family = detect.detect()
    get_artifacts()
