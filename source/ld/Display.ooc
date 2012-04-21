
use gobject, cairo, sdl, deadlogger

// libs deps
import deadlogger/Log
import cairo/[Cairo] 
import structs/[ArrayList]
import zombieconfig
import sdl/[Sdl, Event, Video]
import gobject

Display: class {

    screen, sdlSurface: SdlSurface*
    cairoSurface: ImageSurface
    cairoContext: Context

    logger := static Log getLogger(This name)

    init: func (width: Int, height: Int, fullScreen: Bool, title: String) {
        g_type_init() // needed for librsvg to work
        
        logger info("Initializing SDL...")
        SDL init(SDL_INIT_EVERYTHING) // SHUT... DOWN... EVERYTHING! (Madagascar in Pandemic 2)

        flags := SDL_HWSURFACE
        if(fullScreen) {
            flags |= SDL_FULLSCREEN
        }

        screen = SDLVideo setMode(width, height, 32, flags)
        SDLVideo wmSetCaption(title, null)

        sdlSurface = SDLVideo createRgbSurface(SDL_HWSURFACE, width, height, 32,
            0x00FF0000, 0x0000FF00, 0x000000FF, 0)

        cairoSurface = ImageSurface new(sdlSurface@ pixels, CairoFormat RGB24,
            sdlSurface@ w, sdlSurface@ h, sdlSurface@ pitch)

        cairoContext = Context new(cairoSurface)

    }

}
