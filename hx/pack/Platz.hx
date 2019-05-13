package pack;

import js.Browser;
import js.html.BodyElement;
import js.html.Element;
import js.html.HTMLCollection;

import pack.Tisch;
import pack.Datenbank;

class Platz {

    static var bodyDerPage : BodyElement = Browser.document.body;

    public static function getIndexFromPlaetze_DB ( platzID : Int ) : Int {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var platzID : Int = platzID + 1;

        var returnIndex : Int = null; 

        for ( index in 0...datenbank.plaetze.length ) {

            var istPlatzIDDieSelbleWiePlaetze_DBID : Bool = datenbank.plaetze[ index ].platzID == platzID;

            if ( istPlatzIDDieSelbleWiePlaetze_DBID ) {

                returnIndex = index;

            }

        }

        return returnIndex;

    }

    public static function getPlaetzeArray ( raumNummer : Int ) : Array<Int> {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var raumNummer : Int = raumNummer + 1;
        
        var plaetzeArray : Array<Int> = [];

        for ( index in 0...datenbank.plaetze.length ) {

            var raumID : Int = datenbank.plaetze[index].raumID;
            var platzID : Int = datenbank.plaetze[index].platzID;

            var checkObRaumGleicheIDBesitzt : Bool = raumID == raumNummer;

            if ( checkObRaumGleicheIDBesitzt ) {

                plaetzeArray.push( platzID - 1 );

            }

        }

        return plaetzeArray;

    }

    public static function zeigDenPlatz ( platzNummer : Int ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var platzNummer : Int = platzNummer;

        var contentView : HTMLCollection = bodyDerPage.getElementsByClassName( "view" );

        contentView[0].innerHTML = "";

        var teilnehmerNameView : Element = Functions.createElemente( "div" );
        var teilnehmerDatumVonView : Element = Functions.createElemente( "div" );
        var teilnehmerDatumBisView : Element = Functions.createElemente( "div" );
        var teilnehmerKommentarView : Element = Functions.createElemente( "div" );

        var teilnehmerNameHead : Element = Functions.createElemente( "h2" );
        var teilnehmerDatumVonHead : Element = Functions.createElemente( "h2" );
        var teilnehmerDatumBisHead : Element = Functions.createElemente( "h2" );
        var teilnehmerKommentarHead : Element = Functions.createElemente( "h2" );

        var teilnehmerNameText : Element = Functions.createElemente( "p" );
        var teilnehmerDatumVonText : Element = Functions.createElemente( "p" );
        var teilnehmerDatumBisText : Element = Functions.createElemente( "p" );
        var teilnehmerKommentarText : Element = Functions.createElemente( "p" );

        var textTeilnehmerName : String = datenbank.plaetze[ platzNummer ].teilnehmerName;
        var textTeilNehmerDatumVon : String = datenbank.plaetze[ platzNummer ].datumVon;
        var textTeilNehmerDatumBis : String = datenbank.plaetze[ platzNummer ].datumBis;
        var textTeilnehmerKommentar : String = datenbank.plaetze[ platzNummer ].kommentar;

        teilnehmerNameView.setAttribute( "class", "teilnehmerName" );
        teilnehmerDatumVonView.setAttribute( "class", "teilnehmerDatumVon" );
        teilnehmerDatumBisView.setAttribute( "class", "teilnehmerDatumBis" );
        teilnehmerKommentarView.setAttribute( "class", "teilnehmerKommentar" );

        teilnehmerNameHead.innerHTML = "Teilnehmer " + "( Tisch : " + datenbank.plaetze[ platzNummer ].platzNummer + " )";
        teilnehmerDatumVonHead.innerHTML = "Datum von";
        teilnehmerDatumBisHead.innerHTML = "Datum bis";
        teilnehmerKommentarHead.innerHTML = "Kommentar";

        teilnehmerNameText.innerHTML = textTeilnehmerName;
        teilnehmerDatumVonText.innerHTML = textTeilNehmerDatumVon;
        teilnehmerDatumBisText.innerHTML = textTeilNehmerDatumBis;
        teilnehmerKommentarText.innerHTML = textTeilnehmerKommentar;

        teilnehmerNameView.appendChild( teilnehmerNameHead );
        teilnehmerDatumVonView.appendChild( teilnehmerDatumVonHead );
        teilnehmerDatumBisView.appendChild( teilnehmerDatumBisHead );
        teilnehmerKommentarView.appendChild( teilnehmerKommentarHead );

        teilnehmerNameView.appendChild( teilnehmerNameText );
        teilnehmerDatumVonView.appendChild( teilnehmerDatumVonText );
        teilnehmerDatumBisView.appendChild( teilnehmerDatumBisText );
        teilnehmerKommentarView.appendChild( teilnehmerKommentarText );

        contentView[0].appendChild( teilnehmerNameView );
        contentView[0].appendChild( teilnehmerDatumVonView );
        contentView[0].appendChild( teilnehmerDatumBisView );
        contentView[0].appendChild( teilnehmerKommentarView );

    }

    public static function getPlatzAnzahl ( raumID : Int ) : Int {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var anzahlDerRaeume : Int = 0;
        var raumID : Int = raumID;

        for ( index in 0...datenbank.plaetze.length ) {

            var istDasDerSelbeRaum : Bool = raumID == datenbank.plaetze[index].raumID;

            if ( istDasDerSelbeRaum ) {

                anzahlDerRaeume++;

            }

        }

        return anzahlDerRaeume;

    }

    public static function getPlatzBelegung ( raumIndex : Int ) : Array<Int> {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var raumIndex : Int = raumIndex;

        var vollBelegung : Int = 0;
        var gelbBelegung : Int = 0;

        for ( index in 0...datenbank.plaetze.length ) {

            var istDasDerSelbeRaum : Bool = raumIndex == datenbank.plaetze[index].raumID;

            if ( istDasDerSelbeRaum ) {


                var platzDatumVon : String = datenbank.plaetze[index].datumVon;
                var platzDatumBis : String = datenbank.plaetze[index].datumBis;

                var platzFarbe : String = Tisch.getTischFarbe( platzDatumVon, platzDatumBis );

                var istDiePlatzFarbeGelb : Bool = platzFarbe == 'yellow';
                var istDiePlatzFarbeRot : Bool = platzFarbe == 'red';

                if ( istDiePlatzFarbeGelb ) {

                    vollBelegung++;
                    gelbBelegung++;

                } else if ( istDiePlatzFarbeRot ) {

                    vollBelegung++;

                }

            }

        }

        return [ vollBelegung, gelbBelegung ];

    }

}
