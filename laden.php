<?php

function con(){

    $host = 'localhost';
    $user = 'root';
    $pass = '';
    $db = 'raumsystem';

    $conn = new mysqli( $host, $user, $pass, $db ) or die( "connect failed: %s\n". $conn -> error );
    
    return $conn;

}

function closeCon( $conn ){

    $conn->close();

}

$conn = con();

$etagenQuery = $conn->query( "SELECT * FROM etagen" );
$raeumeQuery = $conn->query( "SELECT * FROM raeume" );
$plaetzeQuery = $conn->query( "SELECT * FROM plaetze" );

$etagenResult = mysqli_fetch_all( $etagenQuery, MYSQLI_ASSOC );
$raeumeResult = mysqli_fetch_all( $raeumeQuery, MYSQLI_ASSOC );
$plaetzeResult = mysqli_fetch_all( $plaetzeQuery, MYSQLI_ASSOC );

$result = array();

$result[0] = json_encode( $etagenResult );
$result[1] = json_encode( $raeumeResult );
$result[2] = json_encode( $plaetzeResult );

closeCon( $conn );

?>
<?php echo "{\"etagen\":" . $result[0] . ",\"raeume\":" . $result[1] . ",\"plaetze\":" . $result[2] . "}"?>
