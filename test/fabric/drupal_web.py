from fabric.api import env, run, task
from envassert import detect, file, group, package, port, process, service, \
    user


@task
def check():
    env.platform_family = detect.detect()

    assert package.installed("php5")
    assert package.installed("varnish")
    assert file.is_dir("/var/www/vhosts")
    assert port.is_listening(80)
    assert port.is_listening(8080)
    assert process.is_up("apache2")
    assert service.is_enabled("apache2")
