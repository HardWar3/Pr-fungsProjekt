package pack;

import js.Browser;
import js.html.BodyElement;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.XMLHttpRequest;

import pack.Datenbank;

class Tisch {

    static var bodyDerPage : BodyElement = Browser.document.body;

    static var submitAction = null;
    static var submitBool : Bool = false;

    public static function getTische ( raumNummer : Int, raumStruktur : Element ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var darfDerRaumGeZeigtWerden : Bool = datenbank.raeume[raumNummer].view == 1;

        if ( darfDerRaumGeZeigtWerden ) {

            var anzahlDerTischeImRaum : Array<Int> = Platz.getPlaetzeArray( raumNummer );   
            var tuer : Element = Functions.createElemente( "div" );
            
            tuer.setAttribute( "class", "tuer" );

            tuer.style.top = datenbank.raeume[raumNummer].tuerPositionTop + "px";
            tuer.style.left = datenbank.raeume[raumNummer].tuerPositionLeft + "px";

            raumStruktur.appendChild( tuer );

            // for(var index = 0; index < anzahlDerTischeImRaum; index++ ){
            for ( index in 0...anzahlDerTischeImRaum.length ) {

                var tisch : Element = Functions.createElemente( "div" );

                var platzIndex : Int = Platz.getIndexFromPlaetze_DB( anzahlDerTischeImRaum[ index ] );

                var platzNummer : String = "" + datenbank.plaetze[ platzIndex ].platzNummer;

                var datumVon : String = datenbank.plaetze[ platzIndex ].datumVon;
                var datumBis : String = datenbank.plaetze[ platzIndex ].datumBis;

                var textPlatzNummer : Element = Functions.createElemente( "p" );
                var textPlatzName : Element = Functions.createElemente( "p" );
                var textDatumVon : Element = Functions.createElemente( "p" );

                textPlatzNummer.innerHTML = platzNummer;
                textPlatzName.innerHTML = datenbank.plaetze[ platzIndex ].teilnehmerName;
                textDatumVon.innerHTML = datenbank.plaetze[ platzIndex ].datumVon;

                tisch.appendChild( textPlatzNummer );
                tisch.appendChild( textPlatzName );
                tisch.appendChild( textDatumVon );

                tisch.setAttribute( "class", "tisch" );

                tisch.style.top = datenbank.plaetze[ platzIndex ].positionTop + "px";
                tisch.style.left = datenbank.plaetze[ platzIndex ].positionLeft + "px" ;

                tisch.style.backgroundColor = Tisch.getTischFarbe( datumVon, datumBis );

                raumStruktur.appendChild( tisch );

                var etagenNummer : Int = 0;

                tisch.addEventListener( "click", function () {

                    Platz.zeigDenPlatz( platzIndex );
                    Tisch.erstelleTischEditButton( platzIndex );

                    var istSubmitActionNichtNull : Bool = untyped __typeof__( submitAction )  != null;

                    if ( istSubmitActionNichtNull && submitBool ) {

                        submitAction();

                    }

                } );

            }

        }
            

    }

    public static function getTischFarbe ( datumVon : String, datumBis : String ) : String {

        var jahrVon : Int = Std.parseInt( datumVon.substring( 6 ) );
        var monatVon : Int = Std.parseInt( datumVon.substring( 3, 5 ) );
        var tagVon : Int = Std.parseInt( datumVon.substring( 0, 2 ) );

        var jahrBis : Int = Std.parseInt( datumBis.substring( 6 ) );
        var monatBis : Int = Std.parseInt( datumBis.substring( 3, 5 ) );
        var tagBis : Int = Std.parseInt( datumBis.substring( 0, 2 ) );

        var jahrHeute : Int = Date.now().getFullYear();
        var monatHeute : Int = Date.now().getMonth()+1;
        var tagHeute : Int = Date.now().getDate();

        var timeHeute = DateTools.makeUtc( jahrHeute, monatHeute, tagHeute, 0, 0, 0 );
        var timeVon = DateTools.makeUtc( jahrVon, monatVon, tagVon, 0, 0, 0 );
        var timeBis = DateTools.makeUtc( jahrBis, monatBis, tagBis, 0, 0, 0 );

        if ( timeHeute >= timeVon ) {

            if ( timeHeute <= timeBis ) {

                // trace( "RED" );
                return "red";

            } else {

                // trace ( "GREEN" );
                return "green";

            }

        } else {

            // trace( "GELB" );
            return "yellow";

        }

    }

    public static function erstelleTischEditButton ( platzNummer : Int ) : Void {

        var platzNummer : Int = platzNummer;

        var login : Element = bodyDerPage.getElementsByClassName( "login" )[0];

        var tisch : HTMLCollection = login.getElementsByClassName( "tischButton" );

        var istEinTischVorhanden : Bool = tisch.length >= 1;

        var tischButton : Element = Functions.createElemente( "button" );
        var textButton : Element = Functions.createElemente( "h2" );

        textButton.innerHTML = "Tisch Edit";

        trace( istEinTischVorhanden );

        if ( istEinTischVorhanden ) {

            login.removeChild( tisch[0] );

            tischButton.appendChild( textButton );

            tischButton.setAttribute( "class", "tischButton" );

            login.appendChild( tischButton );

            tischButton.addEventListener( "click", function () {

                zeigeSettingsVonTischEditButton( platzNummer );
                tischButton.setAttribute( "disabled", "disabled" );

            } );

        } else {

            tischButton.appendChild( textButton );

            tischButton.setAttribute( "class", "tischButton" );

            login.appendChild( tischButton );

            tischButton.addEventListener( "click", function () {

                zeigeSettingsVonTischEditButton( platzNummer );
                tischButton.setAttribute( "disabled", "disabled" );


            } );

        }

    }

    public static function zeigeSettingsVonTischEditButton ( platzNummer : Int ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var platzNummer : Int = platzNummer;

        var view : Element = bodyDerPage.getElementsByClassName("view")[0];

        var formView : Element = Functions.createElemente( "form" );

        formView.innerHTML = view.innerHTML;
        view.innerHTML = "";

        view.appendChild( formView );

        formView.setAttribute( "class", "formView" );
        formView.setAttribute( "method", "POST" );
        formView.setAttribute( "target", "_self" );

        var teilnehmerName : Element = view.getElementsByClassName( "teilnehmerName" )[0];
        var teilnehmerDatumVon  : Element = view.getElementsByClassName( "teilnehmerDatumVon" )[0];
        var teilnehmerDatumBis : Element = view.getElementsByClassName( "teilnehmerDatumBis" )[0];
        var teilnhemerKommentar : Element = view.getElementsByClassName(  "teilnehmerKommentar")[0];

        var teilnehmerRange : Element = Functions.createElemente( "div" );
        teilnehmerRange.setAttribute( "class", "teilnehmerRange" );

        var teilnehmerSubmit : Element = Functions.createElemente( "div" );
        teilnehmerSubmit.setAttribute( "class", "teilnehmerSubmit" );

        var loeschenNameP : Element = teilnehmerName.getElementsByTagName( "p" )[0];
        var loeschenDatumVonP : Element = teilnehmerDatumVon.getElementsByTagName( "p" )[0];
        var loeschenDatumBisP : Element = teilnehmerDatumBis.getElementsByTagName( "p" )[0];
        var loeschenKommentarP : Element = teilnhemerKommentar.getElementsByTagName( "p" )[0];

        var inputName : Element = Functions.createElemente( "input" );
        var inputDatumVonTage : Element = Functions.createElemente( "input" );
        var inputDatumVonMonate : Element = Functions.createElemente( "input" );
        var inputDatumVonJahre : Element = Functions.createElemente( "input" );
        var inputDatumBisTage : Element = Functions.createElemente( "input" );
        var inputDatumBisMonate : Element = Functions.createElemente( "input" );
        var inputDatumBisJahre : Element = Functions.createElemente( "input" );
        var inputKommentar : Element = Functions.createElemente( "input" );

        var inputRangeTopHead : Element = Functions.createElemente( "h2" );
        inputRangeTopHead.innerHTML = "Position Top";
        var inputRangeTop : Element = Functions.createElemente( "input" );
        var rangeTop : String = datenbank.plaetze[platzNummer].positionTop;

        var inputRangeLeftHead : Element = Functions.createElemente( "h2" );
        inputRangeLeftHead.innerHTML = "Position Left";
        var inputRangeLeft : Element = Functions.createElemente( "input" );
        var rangeLeft : String = datenbank.plaetze[platzNummer].positionLeft;

        var inputSubmit : Element = Functions.createElemente( "input" );
        
        var inputPlatzID : Element = Functions.createElemente( "input" );

        var loeschenDatumVonPText : String = loeschenDatumVonP.innerText;
        var loeschenDatumBisPText : String = loeschenDatumBisP.innerText;

        var inputDatumVonJahreValue : String = loeschenDatumVonPText.substring( 6 );
        var inputDatumVonMonateValue : String = loeschenDatumVonPText.substring( 3, 5 );
        var inputDatumVonTageValue : String = loeschenDatumVonPText.substring( 0, 2 );
        var inputDatumBisJahreValue : String = loeschenDatumBisPText.substring( 6 );
        var inputDatumBisMonateValue : String = loeschenDatumBisPText.substring( 3, 5 );
        var inputDatumBisTageValue : String = loeschenDatumBisPText.substring( 0, 2 );

        var maxJahr : String = "" + (Date.now().getFullYear()+6);

        inputName.setAttribute( "type", "text" );
        inputName.setAttribute( "name", "teilnehmerName" );
        inputName.setAttribute( "maxlength", "45" );
        inputName.setAttribute( "minlength", "3" );
        inputName.setAttribute( "value", loeschenNameP.innerText );

        inputDatumVonTage.setAttribute( "type", "number" );
        inputDatumVonTage.setAttribute( "name", "teilnehmerDatumVonTag" );
        inputDatumVonTage.setAttribute( "max", "31" );
        inputDatumVonTage.setAttribute( "min", "1" );
        inputDatumVonTage.setAttribute( "value", inputDatumVonTageValue );

        inputDatumVonMonate.setAttribute( "type", "number" );
        inputDatumVonMonate.setAttribute( "name", "teilnehmerDatumVonMonate" );
        inputDatumVonMonate.setAttribute( "max", "12" );
        inputDatumVonMonate.setAttribute( "min", "1" );
        inputDatumVonMonate.setAttribute( "value", inputDatumVonMonateValue );

        inputDatumVonJahre.setAttribute( "type", "number" );
        inputDatumVonJahre.setAttribute( "name", "teilnehmerDatumVonJahre" );
        inputDatumVonJahre.setAttribute( "max", maxJahr );
        inputDatumVonJahre.setAttribute( "min", "1970" );
        inputDatumVonJahre.setAttribute( "value", inputDatumVonJahreValue );

        inputDatumBisTage.setAttribute( "type", "number" );
        inputDatumBisTage.setAttribute( "name", "teilnehmerDatumBisTage" );
        inputDatumBisTage.setAttribute( "max", "31" );
        inputDatumBisTage.setAttribute( "min", "1" );
        inputDatumBisTage.setAttribute( "value", inputDatumBisTageValue );

        inputDatumBisMonate.setAttribute( "type", "number" );
        inputDatumBisMonate.setAttribute( "name", "teilnehmerDatumBisMonate" );
        inputDatumBisMonate.setAttribute( "max", "12" );
        inputDatumBisMonate.setAttribute( "min", "1" );
        inputDatumBisMonate.setAttribute( "value", inputDatumBisMonateValue );

        inputDatumBisJahre.setAttribute( "type", "number" );
        inputDatumBisJahre.setAttribute( "name", "teilnehmerDatumBisJahre" );
        inputDatumBisJahre.setAttribute( "max", maxJahr );
        inputDatumBisJahre.setAttribute( "min", "1970" );
        inputDatumBisJahre.setAttribute( "value", inputDatumBisJahreValue );

        inputKommentar.setAttribute( "type", "text" );
        inputKommentar.setAttribute( "name", "teilnehmerKommentar" );
        // inputKommentar.innerHTML = loeschenKommentarP.innerText;
        inputKommentar.setAttribute( "max", "1000" );
        inputKommentar.setAttribute( "min", "1" );
        inputKommentar.setAttribute( "value", loeschenKommentarP.innerText );

        var inputKommentarEventInputText : String = inputKommentar.getAttribute( "value" );

        // inputKommentar.setAttribute( "rows", "3" );
        // inputKommentar.setAttribute( "cols", "24" );

        inputRangeTop.setAttribute( "type", "range" );
        inputRangeTop.setAttribute( "name", "teilnehmerRangeTop" );
        inputRangeTop.setAttribute( "max", "744" );
        inputRangeTop.setAttribute( "min", "0" );
        inputRangeTop.setAttribute( "value", rangeTop );

        inputRangeLeft.setAttribute( "type", "range" );
        inputRangeLeft.setAttribute( "name", "teilnehmerRangeLeft" );
        inputRangeLeft.setAttribute( "max", "1204" );
        inputRangeLeft.setAttribute( "min", "0" );
        inputRangeLeft.setAttribute( "value", rangeLeft );

        inputSubmit.setAttribute( "type", "submit" );
        // inputSubmit.setAttribute( "name", "teilnehmerSubmit" );

        inputPlatzID.setAttribute( "type", "hidden" );
        inputPlatzID.setAttribute( "name", "teilnehmerPlatzID" );
        inputPlatzID.setAttribute( "value", "" + ( datenbank.plaetze[ platzNummer ].platzID ));

        formView.appendChild( teilnehmerRange );
        formView.appendChild( teilnehmerSubmit );
        formView.appendChild( inputPlatzID );

        teilnehmerName.appendChild( inputName );
        teilnehmerDatumVon.appendChild( inputDatumVonTage );
        teilnehmerDatumVon.appendChild( inputDatumVonMonate );
        teilnehmerDatumVon.appendChild( inputDatumVonJahre );
        teilnehmerDatumBis.appendChild( inputDatumBisTage );
        teilnehmerDatumBis.appendChild( inputDatumBisMonate );
        teilnehmerDatumBis.appendChild( inputDatumBisJahre );
        teilnhemerKommentar.appendChild( inputKommentar );
        teilnehmerRange.appendChild( inputRangeTopHead );
        teilnehmerRange.appendChild( inputRangeTop );
        teilnehmerRange.appendChild( inputRangeLeftHead );
        teilnehmerRange.appendChild( inputRangeLeft );
        teilnehmerSubmit.appendChild( inputSubmit );

        teilnehmerName.removeChild( loeschenNameP );
        teilnehmerDatumVon.removeChild( loeschenDatumVonP );
        teilnehmerDatumBis.removeChild( loeschenDatumBisP );
        teilnhemerKommentar.removeChild( loeschenKommentarP );

        inputRangeLeft.addEventListener( "input", function ( event ) {

            var inputRangeLeftValue : Int = event.target.value;

            tischChangePositionLeft( platzNummer, inputRangeLeftValue );

        } );

        inputRangeTop.addEventListener( "input", function ( event ) {

            var inputRangeTopValue : Int = event.target.value;

            tischChangePositionTop( platzNummer, inputRangeTopValue );

        } );

        formView.addEventListener( "submit", function ( event ) {

            event.preventDefault();

        } );

        inputKommentar.addEventListener( "input", function ( event ) {

            inputKommentarEventInputText = event.target.value;

        } );

        var submitFunction = function () {

            return {
                var valueName : String = Reflect.field( inputName, "value" );
                var valueDatumVonJahre : String = Reflect.field( inputDatumVonJahre, "value" );
                var valueDatumVonMonate : String = Reflect.field( inputDatumVonMonate, "value" );
                var valueDatumVonTage : String = Reflect.field( inputDatumVonTage, "value" );
                var valueDatumBisJahre : String = Reflect.field( inputDatumBisJahre, "value" );
                var valueDatumBisMonate : String = Reflect.field( inputDatumBisMonate, "value" );
                var valueDatumBisTage : String = Reflect.field( inputDatumBisTage, "value" );
                var valueKommentar : String = Reflect.field( inputKommentar, "value" );
                var valueRangeTop : String = Reflect.field( inputRangeTop, "value" );
                var valueRangeLeft : String = Reflect.field( inputRangeLeft, "value" );
                var valuePlatzID : String = Reflect.field( inputPlatzID, "value" );

                var speichernDannLaden : XMLHttpRequest = new XMLHttpRequest();

                speichernDannLaden.open( "POST", "speicherndannladen.php" , true );
                speichernDannLaden.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                speichernDannLaden.send( "teilnehmerName=" + valueName + "&" + "teilnehmerDatumVonTag=" +  valueDatumVonTage + "&" + "teilnehmerDatumVonMonate=" + valueDatumVonMonate + "&" + "teilnehmerDatumVonJahre=" + valueDatumVonJahre + "&" + "teilnehmerDatumBisTage=" + valueDatumBisTage + "&" + "teilnehmerDatumBisMonate=" + valueDatumBisMonate + "&" + "teilnehmerDatumBisJahre=" + valueDatumBisJahre + "&" + "teilnehmerKommentar=" + valueKommentar + "&" + "teilnehmerRangeTop=" + valueRangeTop + "&" + "teilnehmerRangeLeft=" + valueRangeLeft + "&" + "teilnehmerPlatzID=" + valuePlatzID );

                speichernDannLaden.onreadystatechange = function () {

                    if ( speichernDannLaden.readyState == 4 && speichernDannLaden.status == 200 ) {

                        // entfernung von externen speiervorgängen ausserhalb der db

                        var responseDatenbankJson : JsonArray = haxe.Json.parse( speichernDannLaden.responseText );

                        datenbank = Datenbank.setgetDatenbank( responseDatenbankJson );


                        var etagen_Name : String = "";
                        var raum_IndexID : Int = cast( (datenbank.plaetze[platzNummer].raumID)-1 ,Int);

                        for ( index in 0...datenbank.etagen.length ) {

                            var istDasDieGleicheEtage : Bool = datenbank.etagen[index].etagenID == datenbank.raeume[raum_IndexID].etagenID;

                            if ( istDasDieGleicheEtage ) {

                                etagen_Name = datenbank.etagen[index].etagen_ID;

                            }

                        }

                        var zeigeRaum : Element = bodyDerPage.getElementsByClassName( "zeigeRaum" )[0];

                        var etagenInhalt : Element = bodyDerPage.getElementsByClassName( etagen_Name )[0];

                        etagenInhalt.removeChild( zeigeRaum );                            

                        Raum.raumAnzeigen(etagen_Name,raum_IndexID);

                    }

                }
            }

        }

        submitAction = submitFunction;
        submitBool = true;

        inputSubmit.addEventListener( "click", function ( event ) {

            submitFunction();

        } );

    }

    public static function tischChangePositionLeft ( platzNummer : Int, inputValue : Int ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var platzNummer : Int = platzNummer;
        var inputValue : Int = inputValue;

        var raum : Element = bodyDerPage.getElementsByClassName( "imRaum" )[0];
        var tische : HTMLCollection = raum.getElementsByClassName( "tisch" );

        var platzNummerID : String = datenbank.plaetze[ platzNummer ].platzNummer;

        for ( index in 0...tische.length ) {

            var tisch : Element = tische[index];
            var tischFirstElement : Element = tisch.firstElementChild;
            var tischText : String = tischFirstElement.innerText;

            var istPlatzNummerIDDieGleicheWieTischText : Bool = tischText == platzNummerID;

            if ( istPlatzNummerIDDieGleicheWieTischText ) {

                tisch.style.left = "" + inputValue + "px";

            }

        }

    }

    public static function tischChangePositionTop ( platzNummer : Int, inputValue : Int ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var platzNummer : Int = platzNummer;
        var inputValue : Int = inputValue;

        var raum : Element = bodyDerPage.getElementsByClassName( "imRaum" )[0];
        var tische : HTMLCollection = raum.getElementsByClassName( "tisch" );

        var platzNummerID : String = datenbank.plaetze[ platzNummer ].platzNummer;

        for ( index in 0...tische.length ) {

            var tisch : Element = tische[index];
            var tischFirstElement : Element = tisch.firstElementChild;
            var tischText : String = tischFirstElement.innerText;

            var istPlatzNummerIDDieGleicheWieTischText : Bool = tischText == platzNummerID;

            if ( istPlatzNummerIDDieGleicheWieTischText ) {

                tisch.style.top = "" + inputValue + "px";


            }

        }

    }

}
