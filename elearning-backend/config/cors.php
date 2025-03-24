<?php

return [
    'paths' => ['api/*'], // Path yang diizinkan
    'allowed_methods' => ['*'], // Metode HTTP yang diizinkan
    'allowed_origins' => ['*'], // Izinkan semua domain (atau sesuaikan dengan domain Flutter Anda)
    'allowed_headers' => ['*'], // Izinkan semua header
    'exposed_headers' => [], // Header yang diekspos ke client
    'max_age' => 0, // Cache preflight request
    'supports_credentials' => true, // Izinkan credentials (cookies, auth headers)
];
