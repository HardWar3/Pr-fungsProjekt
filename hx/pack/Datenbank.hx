package pack;

import js.Browser;
import js.html.XMLHttpRequest;

//Datentype später in eine eigeneDatei machen

typedef JsonArray = {

    var etagen : Array<EtagenProperties>;
    var raeume : Array<RaeumeProperties>;
    var plaetze : Array<PlaetzeProperties>;

}

typedef EtagenProperties = {

    var etagenID : Int;
    var etagenName : String;
    var etagen_ID : String;

}

typedef RaeumeProperties = {

    var raumID : Int;
    var raumName : String;
    var view : Int;
    var tuerPositionLeft : String;
    var tuerPositionTop : String;
    var etagenID : Int;

}

typedef PlaetzeProperties = {

    var platzID : Int;
    var platzNummer : String;
    var teilnehmerName : String;
    var datumVon : String;
    var datumBis : String;
    var positionLeft : String;
    var positionTop : String;
    var kommentar : String;
    var raumID : Int;

}

class Datenbank {

    static var responseDatenbankJson : JsonArray = null;

    public static function initDatenbank () : Void {

        var laden = new XMLHttpRequest();

        laden.open( "POST", "laden.php" , true );
        laden.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        laden.send( "" );

        laden.onreadystatechange = function () {

            if ( laden.readyState == 4 && laden.status == 200 ) {

                responseDatenbankJson = haxe.Json.parse( laden.responseText );

            }

        }


    }

    public static function setDatenbank ( datenbank : JsonArray ) : Void {

        responseDatenbankJson = datenbank;

    }   

    public static function getDatenbank () : JsonArray {

        return responseDatenbankJson;

    }

    public static function setgetDatenbank ( datenbank : JsonArray ) : JsonArray {

        responseDatenbankJson = datenbank;

        return responseDatenbankJson;

    }

}
