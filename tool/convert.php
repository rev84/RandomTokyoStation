<?php

define('X_MIN', 138.912872);
define('X_MAX', 139.924301);
define('Y_MIN', 35.124134);
define('Y_MAX', 35.911590);

$buf = file_get_contents(dirname(__FILE__).'/station20160401free.csv');

$results = explode("\n", $buf);
array_shift($results);
$stations = [];

foreach ($results as $r) {
  $rArray = explode(',', $r);

  $code = $rArray[1];
  $pref = $rArray[6];
  $name = $rArray[2];
  $x    = floatval($rArray[9]);
  $y    = floatval($rArray[10]);

  if ($x < X_MIN) continue;
  if (X_MAX < $x) continue;
  if ($y < Y_MIN) continue;
  if (Y_MAX < $y) continue;

  $stations[$code] = [
    'name' => $name,
    'x'    => ($x - X_MIN) / (X_MAX - X_MIN),
    'y'    => 1 - (($y - Y_MIN) / (Y_MAX - Y_MIN)),
  ];
}

$stasJson = 'var STATIONS = '.json_encode(array_values($stations), JSON_UNESCAPED_UNICODE).';';

file_put_contents(dirname(__FILE__).'/../js/stations.js', $stasJson);
