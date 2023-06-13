<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = getenv('MOODLE_DATABASE_TYPE');
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('MOODLE_DATABASE_HOST');
$CFG->dbname    = getenv('MOODLE_DATABASE_NAME');
$CFG->dbuser    = getenv('MOODLE_DATABASE_USER');
$CFG->dbpass    = getenv('MOODLE_DATABASE_PASSWORD');
$CFG->prefix    = getenv('MOODLE_DB_PREFIX');
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => getenv('MOODLE_DATABASE_PORT'),
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

$CFG->wwwroot   = getenv('MOODLE_URL');
$CFG->dataroot  = getenv('MOODLE_DATA_ROOT');
$CFG->directorypermissions = getenv('MOODLE_DIR_PERM');
$CFG->tempdir   = '/var/docker/moodle';
$CFG->cachedir  = $CFG->tempdir.'/cache';
$CFG->localcachedir = $CFG->tempdir.'/localcache';

$CFG->admin     = 'admin';
$CFG->lang      = getenv('MOODLE_LANG');
if(filter_var(getenv('MOODLE_REVERSEPROXY'),FILTER_VALIDATE_BOOLEAN)){
  $CFG->reverseproxy = true;
}
if(filter_var(getenv('MOODLE_SSLPROXY'),FILTER_VALIDATE_BOOLEAN)){
  $CFG->sslproxy = true;
}

$CFG->xsendfile = 'X-Accel-Redirect';
$CFG->xsendfilealiases = array(
    '/dataroot/' => $CFG->dataroot
);


require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!