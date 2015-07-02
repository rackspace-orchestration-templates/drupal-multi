from fabric.api import env, task
from envassert import detect, file, package, port, process, service
from hot.utils.test import get_artifacts, http_check


@task
def check():
    env.platform_family = detect.detect()

    site = "http://localhost/"
    string = "Welcome to Drupal7"
    apache_process = 'apache2'
    php_package = 'php5'

    assert file.is_dir("/var/www/vhosts"), '/var/www/vhosts is wrong'
    assert port.is_listening(80), 'port 80 not listening'
    assert port.is_listening(8080), 'port 8080 not listening'
    assert package.installed("varnish"), 'varnish not installed'
    assert package.installed(php_package), 'php not installed'
    assert process.is_up(apache_process), 'apache is not running'
    assert service.is_enabled(apache_process), 'apache is not enabled'
    assert http_check(site, string), 'Drupal did not respond as expected.'


@task
def artifacts():
    env.platform_family = detect.detect()
    get_artifacts()
