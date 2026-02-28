<?php
$phpVersion = phpversion();
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Apache + PHP is working</title>
</head>
<body>
    <h1>Apache + PHP is working</h1>
    <p>This page is rendered by PHP.</p>
    <p>PHP version: <?php echo htmlspecialchars($phpVersion, ENT_QUOTES, 'UTF-8'); ?></p>
</body>
</html>
