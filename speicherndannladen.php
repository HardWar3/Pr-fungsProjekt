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

$istPOSTTeilnehmerNameUndTeilnehmerVonUndTeilnehmerBisUndTeilnehmerKommentarUndTeilnehmerRangeTopUndTeilnehmerRangeLeftUndTeilnehmerPlatzIDVorhanden = isset( $_POST[ "teilnehmerName" ] ) && isset( $_POST[ "teilnehmerDatumVonTag" ] ) && isset( $_POST[ "teilnehmerDatumVonMonate" ] ) && isset( $_POST[ "teilnehmerDatumVonJahre" ] ) && isset( $_POST[ "teilnehmerDatumBisTage" ] ) && isset( $_POST[ "teilnehmerDatumBisMonate" ] ) && isset( $_POST[ "teilnehmerDatumBisJahre" ] ) && isset( $_POST[ "teilnehmerKommentar" ] ) && isset( $_POST[ "teilnehmerRangeTop" ] ) && isset( $_POST[ "teilnehmerRangeLeft" ] ) && isset( $_POST[ "teilnehmerPlatzID" ] );

if ( $istPOSTTeilnehmerNameUndTeilnehmerVonUndTeilnehmerBisUndTeilnehmerKommentarUndTeilnehmerRangeTopUndTeilnehmerRangeLeftUndTeilnehmerPlatzIDVorhanden ) {

    $teilnehmerName = $conn->real_escape_string($_POST[ "teilnehmerName" ]);
    $teilnehmerVon = $conn->real_escape_string($_POST[ "teilnehmerDatumVonTag" ] . "." . $_POST[ "teilnehmerDatumVonMonate" ] . "." . $_POST[ "teilnehmerDatumVonJahre" ]);
    $teilnehmerBis = $conn->real_escape_string($_POST[ "teilnehmerDatumBisTage" ] . "." . $_POST[ "teilnehmerDatumBisMonate" ] . "." . $_POST[ "teilnehmerDatumBisJahre" ]);
    $teilnehmerKommentar = $conn->real_escape_string($_POST[ "teilnehmerKommentar" ]);
    $teilnehmerRangeTop = $conn->real_escape_string($_POST[ "teilnehmerRangeTop" ]);
    $teilnehmerRangeLeft = $conn->real_escape_string($_POST[ "teilnehmerRangeLeft" ]);
    $teilnehmerPlatzID = $conn->real_escape_string($_POST[ "teilnehmerPlatzID" ]);

    $sql = "UPDATE plaetze SET teilnehmerName = '$teilnehmerName', datumVon = '$teilnehmerVon', datumBis = '$teilnehmerBis', kommentar = '$teilnehmerKommentar', positionTop = '$teilnehmerRangeTop', positionLeft = '$teilnehmerRangeLeft' WHERE platzID = '$teilnehmerPlatzID'";

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
