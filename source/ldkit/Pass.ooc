
// libs deps
import Sprites, Display, UI
import deadlogger/Log
import structs/[ArrayList]

Pass: class {

    ui: UI
    name: String // for debug

    enabled: Bool { get set }

    parent: This // can be null (for root pass)

    passes := ArrayList<This> new()
    sprites := ArrayList<Sprite> new()

    logger := static Log getLogger(This name)

    /*
     * Constructor
     */
    init: func (=ui, =name) {
	enabled = true
    }

    reset: func {
	for (s in sprites) s free()
        sprites clear()
	for (p in passes) p parent = null
        passes clear()
    }

    addPass: func (pass: This) {
        passes add(pass)
        pass parent = this
    }

    removePass: func (pass: This) {
	passes remove(pass)
	pass parent = null
    }

    addSprite: func (sprite: Sprite) {
        sprites add(sprite)
    }

    removeSprite: func (sprite: Sprite) {
        sprites remove(sprite)
    }

    draw: func {
	if (enabled) {
	    for (s in sprites) s draw(ui display)
	    for (p in passes) p draw()
	}
    }

    toString: func -> String { if (parent) {
            "%s / %s" format(parent toString(), name)
        } else {
            name
        }
    }

}


