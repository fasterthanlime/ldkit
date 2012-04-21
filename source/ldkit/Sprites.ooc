
/*
 * A sprite is, in the large sense, anything that can be drawn onto a display.
 */

use cairo
import cairo/Cairo

import Math, Display

Sprite: class {

    pos := vec2(0.0, 0.0)
    offset := vec2(0.0, 0.0)
    scale := vec2(1.0, 1.0)
    color := vec3(1.0, 0.0, 0.0)

    alpha := 1.0
    visible := true

    init: func (pos: Vec2) {
        this pos set!(pos)
    }

    draw: func (display: Display) {
        if (!visible) return

        cr := display cairoContext

        cr save()
        cr translate(pos x + offset x, pos y + offset y)
        cr scale(scale x, scale y)
        cr setSourceRGBA(color x, color y, color z, alpha)

        paint(cr)
        cr restore()
    }

    /*
     * This is the function you want to overload
     * when you have custom sprites
     */
    paint: func (cr: Context) {
        cr setLineWidth(3)

        cr moveTo(0, 0)
        cr lineTo(0, 50)
        cr relLineTo(50, 0)
        cr closePath()
        cr stroke()
    }

    /*
     * Free resources
     */
    free: func {
        // nothing to do here, but for text sprites etc., might be useful
    }

}



