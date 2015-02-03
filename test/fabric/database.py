from fabric.api import env, task
from envassert import detect, file, package, port, process, service
from hot.utils.test import get_artifacts, http_check


@task
def mysql():
    env.platform_family = detect.detect()

    if env.platform_family == 'debian':
        mysql_package = 'mysql-server-5.5'
        mysql_process = 'mysql'
        holland_package = 'holland'
    elif env.platform_family == 'rhel':
        mysql_package = 'mysql-server'
        mysql_process = 'mysqld'
        holland_package = 'holland'
    else:
        raise ValueError('OS ' + env.platform_family +
                         ' unknown, update tests.')

    packages = [holland_package, mysql_package]
    for pkg in packages:
        assert package.installed(pkg), ('package ' + pkg + 'not found')

    assert port.is_listening(3306), '3306 not listening'

    root_my_cnf = "/root/.my.cnf"
    assert file.exists(root_my_cnf), 'root my.cnf does not exist'
    assert file.mode_is(root_my_cnf, 600), \
        'permissions are wrong on root my.cnf'
    assert file.owner_is(root_my_cnf, "root"), 'owner is wrong on root my.cnf'
    assert process.is_up(mysql_process), 'mysql is not running'
    assert service.is_enabled(mysql_process), 'mysql is not enabled'


@task
def artifacts():
    env.platform_family = detect.detect()
    get_artifacts()
