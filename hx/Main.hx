package;

import js.Browser;
import js.html.BodyElement;
import js.html.Element;
import pack.Etage;
import pack.Datenbank;

class Main {

    static var datenbankJson : JsonArray = null;

    static function main () : Void {

        var bodyDerPade : BodyElement = Browser.document.body;

        datenbankJson = untyped __js__( "datenbankJsonPage" );

        var db : Element = bodyDerPade.getElementsByTagName( "script" )[0];

        bodyDerPade.removeChild( db );

        Datenbank.setDatenbank( datenbankJson );

        Etage.initEtage();

    }

}
