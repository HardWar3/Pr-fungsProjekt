package pack;

import js.Browser;
import js.html.Element;

class Functions {

    public static function createElemente ( elementName : String ) : Element {
            
        var istELementNameEinString : Bool = ( untyped __typeof__( elementName ) == 'string');

        if ( istELementNameEinString ){
        
            var element : Element = Browser.document.createElement( elementName );
        
            return element;
        
        }

        return null;

    }   


}
