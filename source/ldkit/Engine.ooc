
import UI, Timing, Actor

import structs/[ArrayList]
import sdl/Core

use zombieconfig
import zombieconfig

Engine: class {

    ui: UI

    actors := ArrayList<Actor> new()

    FPS := 30.0 // let's target 30FPS

    slomo := false

    init: func(config: ZombieConfig) {
        ui = UI new(this, config)
    }

    run: func {
        ticks: Int
        delta := 1000.0 / FPS // try 30FPS

        // main loop
        while (true) {
            ticks = LTime getTicks()

	    // two physics simulation
	    updateActors(delta * 0.5)

	    if (!slomo) {
		updateActors(delta * 0.5)
	    }
            ui update()

            // teleport ourselves in the future when the next frame is due
            roadToFuture := ticks + delta - LTime getTicks()
            if(roadToFuture > 0) {
                LTime delay(roadToFuture)
            }
        }
    }

    updateActors: func (realDelta: Float) {
	iter := actors iterator()
	while (iter hasNext?()) {
	    actor := iter next()
	    if (actor update(realDelta)) {
		iter remove()
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


