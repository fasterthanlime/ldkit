
import structs/[Stack]

import UI, Sprites, Math

FlashMessages: class {

    ui: UI

    messages := Stack<String> new()

    messageLength := 90
    counter := 0

    labelSprite: LabelSprite

    init: func (=ui) {
        labelSprite = LabelSprite new(vec2(ui display getCenter() x, (ui display getHeight() - 40) as Float), "")
        labelSprite color set!(0.9, 0.9, 0.5)
        labelSprite fontSize = 30.0
        labelSprite centered = true
        counter = messageLength

        ui statusPass addSprite(labelSprite)
    }

    reset: func {
        counter = 0
        messages clear()
        hide()
    }

    hide: func {
        labelSprite setText("")
    }

    push: func (msg: String) {
        if (msg size > 0) {
            messages push(msg)
        }
    }

    update: func {
        if (counter < messageLength) {
            counter += 1
        } else {
            if (!messages empty?()) {
                labelSprite setText(messages pop())
                counter = 0
            } else {
                hide()
            }
        }
    }

}


