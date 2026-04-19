<?php
// Compatibilidad con variables locales (DB_*) y App Platform (DATABASE_*)
$db_host = env_var('DB_HOST', env_var('DATABASE_HOST'));
$db_user = env_var('DB_USER', env_var('DATABASE_USERNAME'));
$db_pass = env_var('DB_PASS', env_var('DATABASE_PASSWORD'));
$db_name = env_var('DB_NAME', env_var('DATABASE_NAME'));
$db_port = (int) env_var('DB_PORT', env_var('DATABASE_PORT', '3306'));

// Fallback para plataformas que exponen una URL unica de conexion
$database_url = env_var('DATABASE_URL');
if (($db_host === '' || $db_user === '' || $db_name === '') && $database_url !== '') {
    $parts = parse_url($database_url);
    if (is_array($parts)) {
        $db_host = $db_host !== '' ? $db_host : ($parts['host'] ?? '');
        $db_user = $db_user !== '' ? $db_user : ($parts['user'] ?? '');
        $db_pass = $db_pass !== '' ? $db_pass : ($parts['pass'] ?? '');
        $db_name = $db_name !== '' ? $db_name : ltrim($parts['path'] ?? '', '/');
        $db_port = isset($parts['port']) ? (int) $parts['port'] : $db_port;
    }
}

$db = null;

if ($db_host === '' || $db_user === '' || $db_name === '') {
    error_log('DB config missing. Required: DB_HOST/DB_USER/DB_NAME or DATABASE_HOST/DATABASE_USERNAME/DATABASE_NAME or DATABASE_URL');
    return;
}

mysqli_report(MYSQLI_REPORT_OFF);
$db = mysqli_init();
if ($db === false) {
    error_log('DB init failed: mysqli_init returned false');
    $db = null;
    return;
}

mysqli_options($db, MYSQLI_OPT_CONNECT_TIMEOUT, 5);

$connected = @mysqli_real_connect(
    $db,
    $db_host,
    $db_user,
    $db_pass,
    $db_name,
    $db_port
);

if (!$connected) {
    error_log('DB connection failed: ' . mysqli_connect_error());
    $db = null;
}
