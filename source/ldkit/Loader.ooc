
// libs deps
import text/json, text/json/Parser // yup, we have a pure ooc reader!
import structs/[ArrayList, HashBag, Bag]
import io/FileReader

import ldkit/Math

/**
 * Helpers to load stuff from JSON
 */

Loader: class {

    readJSON: func (path: String) -> HashBag {
        JSON parse(FileReader new(path), HashBag)
    }

    ifContains?: func <T> (bag: HashBag, key: String, T: Class, f: Func (T)) {
        if (bag contains?(key)) {
            f(bag get(key, T))
        }
    }

    readVec2: func (hb: HashBag, key: String) -> Vec2 {
        bag := hb get(key, Bag)
        x := bag get(0, Number) value toFloat()
        y := bag get(1, Number) value toFloat()
        vec2(x, y)
    }

    readFloat: func (hb: HashBag, key: String) -> Float {
        hb get(key, Number) value toFloat()
    }

}

