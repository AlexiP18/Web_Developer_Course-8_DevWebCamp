<?php
// Compatibilidad con variables locales (DB_*) y App Platform (DATABASE_*)
$db_host = env_var('DB_HOST', env_var('DATABASE_HOST'));
$db_user = env_var('DB_USER', env_var('DATABASE_USERNAME'));
$db_pass = env_var('DB_PASS', env_var('DATABASE_PASSWORD'));
$db_name = env_var('DB_NAME', env_var('DATABASE_NAME'));
$db_port = (int) env_var('DB_PORT', env_var('DATABASE_PORT', '3306'));

if ($db_host === '' || $db_user === '' || $db_name === '') {
    error_log('DB config missing. Required: DB_HOST/DB_USER/DB_NAME or DATABASE_HOST/DATABASE_USERNAME/DATABASE_NAME');
    http_response_code(500);
    echo 'Error interno de configuracion de base de datos.';
    exit;
}

$db = mysqli_connect(
    $db_host,
    $db_user,
    $db_pass,
    $db_name,
    $db_port
);

if (!$db) {
    error_log('DB connection failed: ' . mysqli_connect_error());
    http_response_code(500);
    echo 'Error interno de base de datos.';
    exit;
}
