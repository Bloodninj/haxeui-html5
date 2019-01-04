package haxe.ui.backend;
import haxe.ui.events.UIEvent;

@:allow(haxe.ui.backend.ScreenBase)
@:allow(haxe.ui.backend.ComponentBase)
class EventBase {
    private var _originalEvent:js.html.Event;
    
    public function new() {
    }
    
    public function cancel() {
        if (_originalEvent != null) {
            _originalEvent.preventDefault();
            _originalEvent.stopImmediatePropagation();
            _originalEvent.stopPropagation();                
        }
    }
    
    private function postClone(event:UIEvent) {
        event._originalEvent = this._originalEvent;
    }
}