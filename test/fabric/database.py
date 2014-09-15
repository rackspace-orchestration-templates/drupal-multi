from fabric.api import env, task
from envassert import detect, file, package, port, process, service


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
        assert package.installed(pkg)

    assert port.is_listening(3306)
    assert process.is_up("mysqld")

    root_my_cnf = "/root/.my.cnf"
    assert file.exists(root_my_cnf)
    assert file.mode_is(root_my_cnf, 600)
    assert file.owner_is(root_my_cnf, "root")
    assert process.is_up(mysql_process)
    assert service.is_enabled(mysql_process)
