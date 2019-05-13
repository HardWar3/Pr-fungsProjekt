<?php

$etagen = "";
$raeume = "";
$plaetze = "";

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

$istPOSTraumIDundRaumViewVorhanden = isset( $_POST[ "raumID" ] ) && isset( $_POST[ "raumView" ] );

if ( $istPOSTraumIDundRaumViewVorhanden ) {

    $raumID = $conn->real_escape_string($_POST[ "raumID" ]);
    $raumView = $conn->real_escape_string($_POST[ "raumView" ]);

    $sql = "UPDATE raeume SET view = '$raumView' WHERE raumID = '$raumID'";

    $conn->query( $sql );

}

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
<?php echo "{\"etagen\":" . $result[0] . ",\"raeume\":" . $result[1] .",\"plaetze\":" . $result[2] . "}"?>
