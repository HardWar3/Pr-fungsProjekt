package pack;

import js.Browser;
import js.html.BodyElement;
import js.html.Element;

import pack.Etage;

class Menu {

    static var bodyDerPage : BodyElement = Browser.document.body;
    static var dieseEtage : String = "";

    public static function checkMenu () : Void {

        var istDieMenuleisteNichtExistent : Bool = ( bodyDerPage.getElementsByClassName( "menu" ).length == 0 );

        if ( istDieMenuleisteNichtExistent ) {

            addMenu();

        }

    }

    public static function addMenu () : Void {

        var menu : Element = Functions.createElemente( "div" );
        var login : Element = Functions.createElemente( "div" );
        var content : Element = Functions.createElemente( "div" );

        menu.setAttribute( "class", "menu" );
        login.setAttribute( "class", "login" );
        content.setAttribute( "class", "view" );


        menu.appendChild( login );
        menu.appendChild( content );
        bodyDerPage.appendChild( menu );

    }

    public static function zurueckZumHaubtMenu ( etage : String ) : Void {

        var istEtageEinString : Bool = ( untyped __typeof__( etage ) == 'string' );

        if ( istEtageEinString ) {

            var etage : Element = bodyDerPage.getElementsByClassName( etage )[0];
            
            var zurueckOption : Element = Functions.createElemente( "span" );

            zurueckOption.setAttribute( "class", "zurueckOption" );

            zurueckOption.innerHTML = "⮜";

            etage.appendChild( zurueckOption );

            zurueckOption.addEventListener( "click", function() {
                
                bodyDerPage.innerHTML = "";
                dieseEtage = "";

                Etage.initEtage();

            } );

        }

    }

}
