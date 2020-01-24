package pack;

import js.Browser;
import js.html.Element;
import js.Syntax;
import pack.Raum;
import pack.Menu;
import pack.Datenbank;

class Etage {

    static var bodyDerPage : Element = Browser.document.body;

    static var nameDerEtage : String = "";

    static function createEtage () : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        // var raeumeAnzahl : Int = anzahlDerRaeume;
        var etageName : String = nameDerEtage;
        var etage : Element = Functions.createElemente ( "Div" );

        var istEsEtage_1 : Bool = datenbank.etagen[0].etagen_ID == etageName;
        var istEsEtage_3 : Bool = datenbank.etagen[1].etagen_ID == etageName;

        var etagenIndex : Int = null;

        // var plaetzeAnzahl : Int = null;
        // var gelbRotPlaetze : Int = null;
        // var rotPlaetze : Int = null;

        if ( istEsEtage_1 ){

            etagenIndex = 1;

        } else if ( istEsEtage_3 ){

            etagenIndex = 2;

        }

        var istEtageNameEinString : Bool = ( Syntax.typeof( etageName ) == 'string' );

        if ( istEtageNameEinString ) {

            etage.setAttribute( "class", etageName );

            bodyDerPage.appendChild( etage );

        }

        var istRaeumeAnzahlEineNumber : Bool = ( untyped __typeof__( raeume_DB ) != 'null' );

        if ( istRaeumeAnzahlEineNumber ) {

            
            // for ( var index = 0; index < raeumeAnzahl; index++ ) {
            for ( index in 0...datenbank.raeume.length ) {

                var binIchEtage1 : Bool = etagenIndex == datenbank.raeume[index].etagenID;

                if ( istEsEtage_1 && binIchEtage1 ) {

                    var raum : Element = Functions.createElemente ( "div" );
                    var raumText : Element = Functions.createElemente ( "h1" );
                    var raumBelegung : Element = Functions.createElemente ( "p" );

                    var raumName : String = datenbank.raeume[index].raumName;

                    // funktion für anzahl der räume 
                    var platzAnzahl : Int = Platz.getPlatzAnzahl( datenbank.raeume[index].raumID );

                    var darfRaumZeigen : Bool = datenbank.raeume[index].view == 1;

                    if ( darfRaumZeigen ) {

                    var belegtePlaetze : Array<Int> = Platz.getPlatzBelegung( index + 1 );

                    raumBelegung.innerHTML = "" + belegtePlaetze[0] + "(" + belegtePlaetze[1] + ") / " + platzAnzahl;

                    }

                    raumText.innerHTML = raumName;

                    raum.appendChild( raumText );

                    raum.appendChild( raumBelegung );

                    raum.setAttribute( "class", 'raum' + ( index + 1 ) + ' ' + 'raum' );

                    etage.appendChild( raum );
                    
                } else if ( istEsEtage_3 && binIchEtage1 ) {

                    var raum : Element = Functions.createElemente ( "div" );
                    var raumText : Element = Functions.createElemente ( "h1" );
                    var raumBelegung : Element = Functions.createElemente ( "p" );

                    var raumName : String = datenbank.raeume[index].raumName;

                    // funktion für anzahl der räume 
                    var platzAnzahl : Int = Platz.getPlatzAnzahl( datenbank.raeume[index].raumID );

                    var darfRaumZeigen : Bool = datenbank.raeume[index].view == 1;

                    if ( darfRaumZeigen ) {

                    var belegtePlaetze : Array<Int> = Platz.getPlatzBelegung( index );

                    trace( belegtePlaetze );

                    raumBelegung.innerHTML = "" + belegtePlaetze[0] + "(" + belegtePlaetze[1] + ") / " + platzAnzahl;

                    }

                    raumText.innerHTML = raumName;

                    raum.appendChild( raumText );

                    raum.appendChild( raumBelegung );

                    raum.setAttribute( "class", 'raum' + ( index - 7 ) + ' ' + 'raum' );

                    etage.appendChild( raum );

                }


            }

        }

        Raum.raumAddEvents( etageName );

        Menu.zurueckZumHaubtMenu( etageName );

    }

    public static function initEtage () : Void {

        trace( Datenbank.getDatenbank() );

        etagenErstellen();

    }

    public static function etagenErstellen () : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var istImBodyKeineEtagen : Bool = ( bodyDerPage.getElementsByClassName( "etagen" ).length == 0 );
        var hatDieseEtageEineLaenge : Bool = ( nameDerEtage.length > 0 );

        Menu.checkMenu();

        if ( istImBodyKeineEtagen && !hatDieseEtageEineLaenge ) {

            var etagen : Element = Functions.createElemente ( "div" );

            bodyDerPage.appendChild(etagen);
            
            var etage_1 : Element = Functions.createElemente ( "div" );
            var etage_3 : Element = Functions.createElemente ( "div" );
            
            var etage_1Name : Element = Functions.createElemente ( "h1" );
            var etage_3Name : Element = Functions.createElemente ( "h1" );

            trace( datenbank.etagen );

            etage_1Name.innerHTML = datenbank.etagen[0].etagenName;
            etage_3Name.innerHTML = datenbank.etagen[1].etagenName;

            etagen.appendChild( etage_1 );
            etagen.appendChild( etage_3 ); 
            
            etagen.setAttribute( "class", "etagen" );
            etage_1.setAttribute( "class", "etage_1" );
            etage_3.setAttribute( "class", "etage_3" );

            etage_1.appendChild( etage_1Name );
            etage_3.appendChild( etage_3Name );

            etage_1.addEventListener( "click", function(){

                Browser.console.log( "ich bin etage1" );
                nameDerEtage = "etage_1";
                inhaltDerEtage();

            } );

            etage_3.addEventListener( "click", function(){

                Browser.console.log( "ich bin etage3" );
                nameDerEtage = "etage_3";
                inhaltDerEtage();

            } );

        }

    }

    static function inhaltDerEtage() : Void {

        var etagen : Element = ( bodyDerPage.getElementsByClassName( "etagen" )[0] );

        var etagenLength : Int = bodyDerPage.getElementsByClassName( "etagen" ).length;
        
        var istEtagenLengthUngleichZero : Bool = etagenLength != 0;

        if ( istEtagenLengthUngleichZero ) {

            bodyDerPage.removeChild( etagen );

        } else {

            var etageElement : Element = cast ( bodyDerPage.childNodes[3], Element );

            bodyDerPage.removeChild( etageElement );

        }


        createEtage();

        var istEtagenNamenGleichEtageDrei : Bool = nameDerEtage == "etage_3";     

        if ( istEtagenNamenGleichEtageDrei ) {


            Raum.erstelleSpecialRaum();
            nameDerEtage = "";

        } else {

            nameDerEtage = "";

        }

    }

    public static function refreshEtage ( etage : String ) : Void {

        trace( "ich bin " + etage );
        nameDerEtage = etage;
        inhaltDerEtage();

    }

}