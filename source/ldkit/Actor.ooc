
Actor: class {

    init: func {}

    update: func (delta: Float) {
	"Override %s#update! (delta = %.2f)" printfln(class name, delta)
    }

    destroy: func {
	"Override %s#destroy!" printfln(class name)
    }

}

ActorClosure: class extends Actor {

    f: Func (Float)

    init: func (=f) {

    }

    update: func (delta: Float) {
	f(delta)
    }

}

