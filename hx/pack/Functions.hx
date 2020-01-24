package pack;

import js.Browser;
import js.html.Element;
import js.Syntax;

class Functions {

    public static function createElemente ( elementName : String ) : Element {
            
        var istELementNameEinString : Bool = ( Syntax.typeof( elementName ) == 'string');

        if ( istELementNameEinString ){
        
            var element : Element = Browser.document.createElement( elementName );
        
            return element;
        
        }

        return null;

    }   


}