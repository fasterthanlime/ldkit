
import UI, Timing, Actor

import structs/[ArrayList]
import sdl/Sdl

use zombieconfig
import zombieconfig

Engine: class {

    ui: UI

    actors := ArrayList<Actor> new()

    FPS := 30.0 // let's target 30FPS

    init: func(config: ZombieConfig) {
        ui = UI new(this, config)
    }

    run: func {
        ticks: Int
        delta := 1000.0 / 30.0 // try 30FPS

        // main loop
        while (true) {
            ticks = LTime getTicks()

            ui update()
	    actors each(|a| a update(delta))

            // teleport ourselves in the future when the next frame is due
            roadToFuture := ticks + delta - LTime getTicks()
            if(roadToFuture > 0) {
                LTime delay(roadToFuture)
            }
        }
    }

    add: func (actor: Actor) {
	actors add(actor)
    }

    remove: func (actor: Actor) {
	actors remove(actor)
    }

    onTick: func (f: Func (Float)) {
	actors add(ActorClosure new(f))
    }

    quit: func {
	SDL quit()
	exit(0)
    }

}


