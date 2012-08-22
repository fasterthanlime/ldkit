
// libs deps
import Sprites, Display, UI
import deadlogger/Log
import structs/[ArrayList]

Pass: class {

    ui: UI
    name: String // for debug

    parent: This // can be null (for root pass)

    passes := ArrayList<This> new()
    sprites := ArrayList<Sprite> new()

    logger := static Log getLogger(This name)

    /*
     * Constructor
     */
    init: func (=ui, =name) {
        // not much here
    }

    reset: func {
        sprites each(|s| s free())
        sprites clear()
        passes clear()
    }

    addPass: func (pass: This) {
        passes add(pass)
        pass parent = this
    }

    addSprite: func (sprite: Sprite) {
        sprites add(sprite)
    }

    removeSprite: func (sprite: Sprite) {
        sprites remove(sprite)
    }

    draw: func {
        sprites each(|s| s draw(ui display))
        passes each(|p| p draw())
    }

    toString: func -> String { if (parent) {
            "%s / %s" format(parent toString(), name)
        } else {
            name
        }
    }

}


