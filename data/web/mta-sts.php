<?php
require_once 'inc/prerequisites.inc.php';

if (empty($mailcow_hostname)) {
  exit();
}
header('Content-Type: text/plain');
?>
version: STSv1
mode: enforce
mx: <?=$mailcow_hostname."\n";?>
max_age: 86400
