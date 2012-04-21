
use sdl

import sdl/Sdl

LTime: class {

    // the number of 'ticks' since the application start-up
    getTicks: static func -> Int {
        Sdl getTicks()
    } 

    // sleep for 'delta' ticks
    delay: static func (delta: UInt32) {
        Sdl delay(delta)
    }

}
