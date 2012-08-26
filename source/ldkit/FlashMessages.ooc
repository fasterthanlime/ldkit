
import structs/[Stack]

import UI, Sprites, Math, Pass

FlashMessages: class {

    ui: UI

    messages := Stack<String> new()

    messageLength := 90
    counter := 0
     
    pass: Pass

    labelSprite: LabelSprite

    init: func (=ui) {
	pass = Pass new(ui, "flash")
	ui statusPass addPass(pass)

	pos := vec2(ui display getCenter() x, (ui display getHeight() - 40) as Float)

	rectSprite := RectSprite new(pos)
	rectSprite color set!(0, 0, 0)
	rectSprite alpha = 0.7
	rectSprite size set!(500, 80)
	pass addSprite(rectSprite)

        labelSprite = LabelSprite new(pos, "")
        labelSprite color set!(0.9, 0.9, 0.5)
        labelSprite fontSize = 30.0
        labelSprite centered = true
        counter = messageLength

        pass addSprite(labelSprite)
    }

    reset: func {
        counter = 0
        messages clear()
        hide()
    }

    show: func {
	pass enabled = true
    }

    hide: func {
	pass enabled = false
    }

    push: func (msg: String) {
        if (msg size > 0) {
            messages push(msg)
	    counter = messageLength - 10
        }
    }

    update: func {
        if (counter < messageLength) {
            counter += 1
        } else {
            if (!messages empty?()) {
                labelSprite setText(messages pop())
		show()
                counter = 0
            } else {
                hide()
            }
        }
    }

}


