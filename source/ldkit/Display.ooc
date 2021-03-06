
use gobject, cairo, sdl, deadlogger

// libs deps
import deadlogger/Log
import cairo/[Cairo] 
import structs/[ArrayList]
import zombieconfig
import sdl/[Core, Event]
import gobject

import ldkit/Math

Display: class {

    screen, sdlSurface: SdlSurface*
    cairoSurface: CairoImageSurface
    cairoContext: CairoContext

    width, height: Int

    logger := static Log getLogger(This name)

    init: func (=width, =height, fullScreen: Bool, title: String) {
        g_type_init() // needed for librsvg to work
        
        logger info("Initializing SDL...")
        SDL init(SDL_INIT_EVERYTHING) // SHUT... DOWN... EVERYTHING! (Madagascar in Pandemic 2)

        flags := SDL_HWSURFACE
        if(fullScreen) {
            flags |= SDL_FULLSCREEN
        }

        screen = SDL setMode(width, height, 32, flags)
        SDL wmSetCaption(title, null)

        sdlSurface = SDL createRgbSurface(SDL_HWSURFACE, width, height, 32,
            0x00FF0000, 0x0000FF00, 0x000000FF, 0)

        cairoSurface = CairoImageSurface new(sdlSurface@ pixels, CairoFormat RGB24,
            sdlSurface@ w, sdlSurface@ h, sdlSurface@ pitch)

        cairoContext = CairoContext new(cairoSurface)
    }

    hideCursor: func {
        SDL showCursor(false) 
    }

    getWidth: func -> Int {
        width
    }

    getHeight: func -> Int {
        height
    }

    getCenter: func -> Vec2 {
        vec2(width / 2, height / 2)
    }

    clear: func {
        cr := cairoContext

        cr setSourceRGB(0, 0, 0)
        cr paint()
    }

    blit: func {
        SDL blitSurface(sdlSurface, null, screen, null)
        SDL flip(screen)
    }

}
