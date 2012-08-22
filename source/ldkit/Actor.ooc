
Actor: class {

    init: func {}

    update: func (delta: Float) {
	"Override Actor#update! (delta = %.2f)" printfln(delta)
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

