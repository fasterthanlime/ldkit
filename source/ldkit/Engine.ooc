
import UI, Timing

import structs/[ArrayList]

use zombieconfig
import zombieconfig

Engine: class {

    ui: UI

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

            // teleport ourselves in the future when the next frame is due
            roadToFuture := ticks + delta - LTime getTicks()
            if(roadToFuture > 0) {
                LTime delay(roadToFuture)
            }
        }
    }

}


