pragma Singleton
import Quickshell

Singleton {
    property var current: null

    function show(card) {
        if (current && current !== card)
            current.close();
        current = card;
    }

    function hide(card) {
        if (current === card)
            current = null;
    }
}
