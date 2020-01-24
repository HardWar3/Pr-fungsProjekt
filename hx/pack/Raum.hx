package pack;

import js.Browser;
import js.html.Element;
import js.html.HTMLCollection;
import js.html.XMLHttpRequest;

import pack.Tisch;
import pack.Datenbank;

class Raum {

    static var bodyDerPage : Element = Browser.document.body;

    public static function erstelleSpecialRaum () : Void {

        var etage : Element = bodyDerPage.getElementsByClassName( "etage_3" )[0];

        var specialRaum : Element = etage.getElementsByClassName( "raum2" )[0];

        var specialRaumDiv : Element = Functions.createElemente( "div" );

        specialRaumDiv.setAttribute( "class", "raum2_2" );

        specialRaum.insertBefore( specialRaumDiv, specialRaum.firstChild );

    }

    public static function nachDemSpeichernRaumAEndernungAnzeigen ( responseDatenbankJson : JsonArray, raumIndexID : Int ) : Void {

        var responseDatenbankJson : JsonArray = responseDatenbankJson;

        raumSettingsZeigen( raumIndexID );

        var login : Element = bodyDerPage.getElementsByClassName( "login" )[0];

        var tischButton : Element = login.getElementsByClassName( "tischButton" )[0];

        var wennTischButtonNichtNullIst : Bool = tischButton != null;

        if ( wennTischButtonNichtNullIst ) {

            login.removeChild( tischButton );

        }

        var etagenNamen : String = "";
        
        for ( index in 0...responseDatenbankJson.etagen.length ) {

            var istDasDieGleicheEtage : Bool = responseDatenbankJson.etagen[index].etagenID == responseDatenbankJson.raeume[raumIndexID].etagenID;

            if ( istDasDieGleicheEtage ) {

                etagenNamen = responseDatenbankJson.etagen[index].etagen_ID;

            }

        }

        var zeigeRaum : Element = bodyDerPage.getElementsByClassName( "zeigeRaum" )[0];

        var etagenInhalt : Element = bodyDerPage.getElementsByClassName( etagenNamen )[0];

        etagenInhalt.removeChild( zeigeRaum );                            

        raumAnzeigen(etagenNamen,raumIndexID);

    }

    public static function raumSettingsZeigen ( raumIndexID : Int ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var raumIndexID : Int = raumIndexID;

        var view : Element = bodyDerPage.getElementsByClassName( "view" )[0];

        view.innerHTML = "";

        var raumForm : Element = Functions.createElemente( "div" );

        var raumName : Element = Functions.createElemente( "div" );
        var raumSichtbarkeit : Element = Functions.createElemente( "div" );
        var raumSubmit : Element = Functions.createElemente( "div" );

        raumForm.setAttribute( "class", "formView" );
        // raumForm.setAttribute( "method", "DELETE" );
        raumName.setAttribute( "class", "raumName" );
        raumSichtbarkeit.setAttribute( "class", "raumSichtbarkeit" );
        raumSubmit.setAttribute( "class", "raumSubmit" );

        var raumNameHead : Element = Functions.createElemente( "h2" );
        var raumSichtbarkeitHead : Element = Functions.createElemente( "h2" );
        
        var raumNameText : Element = Functions.createElemente( "p" );

        var raumSichtbarkeitInPut : Element = Functions.createElemente( "input" );
        var raumSubmitButton : Element = Functions.createElemente( "input" );
        var raumInputID : Element = Functions.createElemente( "input" );
        var raumInputView : Element = Functions.createElemente( "input" );

        var raumSichtbarkeitLabel : Element = Functions.createElemente( "label" );

        raumNameHead.innerHTML = "Raum Name";
        raumNameText.innerHTML = datenbank.raeume[raumIndexID].raumName;

        raumName.appendChild( raumNameHead );
        raumName.appendChild( raumNameText );

        raumSichtbarkeitHead.innerHTML = "Sichbarkeit des Raumes";
        raumSichtbarkeitInPut.setAttribute( "type", "checkbox" );
        raumSichtbarkeitInPut.setAttribute( "name", "view" );
        raumSichtbarkeitInPut.setAttribute( "id", "raumSichtbarkeitInput" );

        raumSichtbarkeitLabel.setAttribute( "for", "raumSichtbarkeitInput" );
        raumSichtbarkeitLabel.innerHTML = "🗹 Sichtbar / ☐ nicht Sichtbar";

        var istRaumSichtbar : Bool = datenbank.raeume[ raumIndexID ].view == 1;

        if ( istRaumSichtbar ) {

            raumSichtbarkeitInPut.setAttribute( "checked", "checked");

        } else {

            raumSichtbarkeitInPut.removeAttribute( "checked" );

        }

        raumSichtbarkeit.appendChild( raumSichtbarkeitHead );
        raumSichtbarkeit.appendChild( raumSichtbarkeitInPut );
        raumSichtbarkeit.appendChild( raumSichtbarkeitLabel );

        raumSubmitButton.setAttribute( "type", "submit" );

        raumInputID.setAttribute( "type", "hidden" );
        raumInputID.setAttribute( "name", "raumID" );
        raumInputID.setAttribute( "value", "" + (raumIndexID + 1) );

        raumInputView.setAttribute( "type", "hidden" );
        raumInputView.setAttribute( "name", "raumView" );
        raumInputView.setAttribute( "value", cast ( datenbank.raeume[ raumIndexID ].view, String) );

        raumSubmit.appendChild( raumSubmitButton );

        view.appendChild( raumForm );


        raumSubmitButton.addEventListener( "click", function () {

            var raumSpeichernUndLaden : XMLHttpRequest = new XMLHttpRequest();
            var raumID = raumInputID.getAttribute( "value" );
            var raumView = raumInputView.getAttribute( "value" );

            raumSpeichernUndLaden.open( "POST", "raumSpeichernUndLaden.php" , true );
            raumSpeichernUndLaden.setRequestHeader( "Content-type", "application/x-www-form-urlencoded" );
            raumSpeichernUndLaden.send( "raumID=" + raumID + "&" + "raumView=" + raumView );

            raumSpeichernUndLaden.onreadystatechange = function () {

                if ( raumSpeichernUndLaden.readyState == 4 && raumSpeichernUndLaden.status == 200 ) {

                    datenbank = haxe.Json.parse( raumSpeichernUndLaden.responseText );

                    Datenbank.setDatenbank( datenbank );

                }

                var etageElement : Element = cast ( bodyDerPage.childNodes[3], Element );

                Etage.refreshEtage( etageElement.className );

            }

        } );

        var tischPanel : Element = Functions.createElemente( "div" );
        var tischMinusButton : Element = Functions.createElemente( "div" );
        var tischPlusButton : Element = Functions.createElemente( "div" );
        var tischViewPanel : Element = Functions.createElemente( "div" );

        var tischPanelText : Element = Functions.createElemente( "h2" );

        var tischViewPanelText : Element = Functions.createElemente( "h1" );
        var tischMinusButtonText : Element = Functions.createElemente( "h1" );
        var tischPlusButtonText : Element = Functions.createElemente( "h1" );

        var plaetzeArray : Array<Dynamic> = Platz.getPlaetzeArray( raumIndexID );

        tischPanel.setAttribute( "class", "tischPanel" );
        tischMinusButton.setAttribute( "class", "tischMinusButton" );
        tischPlusButton.setAttribute( "class", "tischPlusButton" );
        tischViewPanel.setAttribute( "class", "tischViewPanel" );

        tischPanelText.innerHTML = "In Raum Tisch anzahl";
        tischViewPanelText.innerHTML = "" + plaetzeArray.length;
        tischMinusButtonText.innerHTML = "-1";
        tischPlusButtonText.innerHTML = "+1";

        tischViewPanel.appendChild( tischViewPanelText );
        tischMinusButton.appendChild(  tischMinusButtonText );
        tischPlusButton.appendChild( tischPlusButtonText );

        tischPanel.appendChild( tischPanelText );
        tischPanel.appendChild( tischMinusButton );
        tischPanel.appendChild( tischViewPanel );
        tischPanel.appendChild( tischPlusButton );

        tischMinusButton.addEventListener( "click", function () {

            var dbIndex : Int = 0;
            var loeschenUndLaden : XMLHttpRequest = new XMLHttpRequest();
            var platzNummer = plaetzeArray.length;
            var raumID = ( raumIndexID + 1 );

            loeschenUndLaden.open( "POST", "loeschenUndLaden.php" , true );
            loeschenUndLaden.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            loeschenUndLaden.send( "teilnehmerPlatzNummer=" + platzNummer + "&" + "teilnehmerRaumID=" + raumID);   

            loeschenUndLaden.onreadystatechange = function () {

                if ( loeschenUndLaden.readyState == 4 && loeschenUndLaden.status == 200 ) {

                    datenbank = haxe.Json.parse( loeschenUndLaden.responseText );

                    Datenbank.setDatenbank( datenbank );

                }

                nachDemSpeichernRaumAEndernungAnzeigen( datenbank, raumIndexID );

            }

        } );

        tischPlusButton.addEventListener( "click", function () {

            var dbIndex : Int = 0;
            var keineLuecke : Bool = true;
            var erstellenUndLaden : XMLHttpRequest = new XMLHttpRequest();
            var platzNummer = ( plaetzeArray.length+1 );
            var raumID = ( raumIndexID + 1 );

            for ( index in 0...datenbank.plaetze.length  ) {

                dbIndex = index + 1;
                var platzID : Int = datenbank.plaetze[index].platzID;

                var istDieIDInDerDatenbankFrei : Bool = ( dbIndex - platzID ) <= (-1);

                if ( istDieIDInDerDatenbankFrei ) {

                    keineLuecke = false;

                    erstellenUndLaden.open( "POST", "erstellenUndLaden.php" , true );
                    erstellenUndLaden.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    erstellenUndLaden.send( "teilnehmerName=" + "Peter" + "&" + "teilnehmerDatumVonTag=" +  "01" + "&" + "teilnehmerDatumVonMonate=" + "01" + "&" + "teilnehmerDatumVonJahre=" + "2017" + "&" + "teilnehmerDatumBisTage=" + "01" + "&" + "teilnehmerDatumBisMonate=" + "01" + "&" + "teilnehmerDatumBisJahre=" + "2018" + "&" + "teilnehmerKommentar=" + "test" + "&" + "teilnehmerRangeTop=" + "744" + "&" + "teilnehmerRangeLeft=" + "0" + "&" + "teilnehmerPlatzID=" + dbIndex + "&" + "teilnehmerPlatzNummer=" + platzNummer + "&" + "teilnehmerRaumID=" + raumID);   

                    erstellenUndLaden.onreadystatechange = function () {

                        if ( erstellenUndLaden.readyState == 4 && erstellenUndLaden.status == 200 ) {

                            datenbank = haxe.Json.parse( erstellenUndLaden.responseText );

                            Datenbank.setDatenbank( datenbank );

                        }

                        nachDemSpeichernRaumAEndernungAnzeigen( datenbank, raumIndexID );

                    }

                    if ( true ) break;

                }

            }

            if ( keineLuecke ) {

                erstellenUndLaden.open( "POST", "erstellenUndLaden.php" , true );
                erstellenUndLaden.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                erstellenUndLaden.send( "teilnehmerName=" + "Peter" + "&" + "teilnehmerDatumVonTag=" +  "01" + "&" + "teilnehmerDatumVonMonate=" + "01" + "&" + "teilnehmerDatumVonJahre=" + "2017" + "&" + "teilnehmerDatumBisTage=" + "01" + "&" + "teilnehmerDatumBisMonate=" + "01" + "&" + "teilnehmerDatumBisJahre=" + "2018" + "&" + "teilnehmerKommentar=" + "test" + "&" + "teilnehmerRangeTop=" + "744" + "&" + "teilnehmerRangeLeft=" + "0" + "&" + "teilnehmerPlatzID=" + (dbIndex+1) + "&" + "teilnehmerPlatzNummer=" + platzNummer + "&" + "teilnehmerRaumID=" + raumID);

                erstellenUndLaden.onreadystatechange = function () {

                    if ( erstellenUndLaden.readyState == 4 && erstellenUndLaden.status == 200 ) {

                        datenbank = haxe.Json.parse( erstellenUndLaden.responseText );

                        Datenbank.setDatenbank( datenbank );

                    }

                    nachDemSpeichernRaumAEndernungAnzeigen( datenbank, raumIndexID );

                }

            }

        } );

        raumForm.appendChild( raumName );
        raumForm.appendChild( raumSichtbarkeit );
        raumForm.appendChild( tischPanel );
        raumForm.appendChild( raumSubmit );
        raumForm.appendChild( raumInputID );
        raumForm.appendChild( raumInputView );

        raumSichtbarkeitInPut.addEventListener( "input", function( event ){

            var raumSichtbarkeitChecked : Bool = event.target.checked;

            if ( raumSichtbarkeitChecked ) {

                raumInputView.setAttribute( "value", "1" );

            } else {

                raumInputView.setAttribute( "value", "0" );

            }

        } );

    }

    public static function raumAnzeigen ( etagenNamen : String, raumNummer : Int ) : Void {

        var datenbank : JsonArray = Datenbank.getDatenbank();

        var etagenInhalt : Element = bodyDerPage.getElementsByClassName( etagenNamen )[0];

        var raumNummer : Int = raumNummer;

        var darfRaumZeigen : Bool = datenbank.raeume[raumNummer].view == 1;

        var raum : Element = Functions.createElemente( "div" );
        var raumStruktur : Element = Functions.createElemente( "div" );
        var schliesseFenster : Element = Functions.createElemente( "span" );

        var sollRaumGezeigtWerden : Bool = false;

        schliesseFenster.innerHTML = "x";

        raum.setAttribute( "class", "zeigeRaum" );
        raumStruktur.setAttribute( "class", "imRaum" );
        schliesseFenster.setAttribute( "class", "schliesseFenster" );

        Browser.window.requestAnimationFrame( function( time ){

            Browser.console.log( raumStruktur.offsetWidth );

        } );


        var istdasEtage1 : Bool = etagenNamen == "etage_1";
        var istdasEtage3 : Bool = etagenNamen == "etage_3";

        if ( istdasEtage1 ) {

            Tisch.getTische( raumNummer, raumStruktur );
            
        } else if ( istdasEtage3 ) {

            Tisch.getTische( raumNummer, raumStruktur );

        }
        
        if ( darfRaumZeigen ) {

            etagenInhalt.appendChild( raum );
            raum.appendChild( raumStruktur );
            raum.appendChild( schliesseFenster );

            schliesseFenster.addEventListener( "click", function() {

                var resetView : HTMLCollection = bodyDerPage.getElementsByClassName( "view" );
                var login : HTMLCollection = bodyDerPage.getElementsByClassName( "login" );

                var istResetViewNichtNull : Bool = resetView.length <= 1;
                var istLoginNichtNull : Bool = login.length <= 1;

                if ( istResetViewNichtNull ) {

                    resetView[0].innerHTML = "";

                }
                
                if ( istLoginNichtNull ) {

                    login[0].innerHTML = "";

                }

                etagenInhalt.removeChild(raum);
                
            } );

        }

    }

    public static function erstelleRaumEditButton ( raumIndexID : Int ) : Void {

        var raumIndexID : Int = raumIndexID;
        var login : Element = bodyDerPage.getElementsByClassName( "login" )[0];

        var raumButton : Element = Functions.createElemente( "button" );
        var textButton : Element = Functions.createElemente( "h2" );

        login.innerHTML = "";

        textButton.innerHTML = "Raum Edit";

        raumButton.appendChild( textButton );

        raumButton.setAttribute( "class", "raumButton" );

        login.appendChild( raumButton );

        raumButton.addEventListener( "click", function () {

            Raum.raumSettingsZeigen( raumIndexID );

            var tischButton : Element = login.getElementsByClassName( "tischButton" )[0];

            var wennTischButtonNichtNullIst : Bool = tischButton != null;

            if ( wennTischButtonNichtNullIst ) {

                login.removeChild( tischButton );

            }


        } );

    }

    public static function raumAddEvents ( etagenNamen : String ) : Void {

        var etage : HTMLCollection = bodyDerPage.getElementsByClassName( etagenNamen );

        var hatEtageEinenInhalt : Bool = etage.length > 0;

        if ( hatEtageEinenInhalt ) {

            var datenbank : JsonArray = Datenbank.getDatenbank();

            var etagenInhalt : Element = etage[0];
            var raeumeInDerEtage : HTMLCollection = etagenInhalt.getElementsByClassName( "raum" );

            for ( index in 0...raeumeInDerEtage.length ) {

                raeumeInDerEtage[index].addEventListener( "click",  function() {

                    var raumName : String = raeumeInDerEtage[index].getElementsByTagName('h1')[0].innerHTML;

                    for ( index in 0...datenbank.raeume.length ) {

                        var istDasDerGleicheRaum : Bool = datenbank.raeume[index].raumName == raumName;

                        if ( istDasDerGleicheRaum ) {

                            var raumArrayIndex : Int = datenbank.raeume[index].raumID;

                            raumAnzeigen( etagenNamen, raumArrayIndex -1 );

                            erstelleRaumEditButton( raumArrayIndex -1 );

                        }

                    }

                    Browser.console.log( "ich bin raum " + (index + 1) );

                } );

            }

        }

    }

}