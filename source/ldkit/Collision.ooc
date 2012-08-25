
import Math

// A box - pos is the top-left corner
// Y+ is down, X+ is right
Box: class {

    pos: Vec2
    width, height: Int

    init: func (=pos, =width, =height) {
    }

    collide: func (other: Box) -> Bang {
        x1 := pos x
        y1 := pos y
        minx1 := x1
        maxx1 := x1 + width
        miny1 := y1
        maxy1 := y1 + height

        x2 := other pos x
        y2 := other pos y
        minx2 := x2
        maxx2 := x2 + other width
        miny2 := y2
        maxy2 := y2 + other height

        // rule out quick cases first
        if (maxx1 <= minx2) return null
        if (maxx2 <= minx1) return null
        if (maxy1 <= miny2) return null
        if (maxy2 <= miny1) return null
    
        bangs := false
        b := Bang new()
        b depth = 10000000000.0

	if (x1 < x2 && maxx1 > minx2) {
	    depth := maxx1 - minx2
	    if (depth < b depth) {
		bangs = true
		b depth = depth
		(b dir x, b dir y) = (-1,  0)
	    }
	}

	if (x2 < x1 && maxx2 > minx1) {
	    depth := maxx2 - minx1
	    if (depth < b depth) {
		bangs = true
		b depth = depth
		(b dir x, b dir y) = ( 1,  0)
	    }
	}

	if (y1 < y2 && maxy1 > miny2) {
	    depth := maxy1 - miny2
	    if (depth < b depth) {
		bangs = true
		b depth = depth
		(b dir x, b dir y) = ( 0, -1)
	    }
	}

	if (y2 < y1 && maxy2 > miny1) {
	    depth := maxy2 - miny1
	    if (depth < b depth) {
		bangs = true
		b depth = depth
		(b dir x, b dir y) = ( 0,  1)
	    }
	}

        bangs ? b : null
    }

}

Bang: class {

    pos := vec2(0, 0)
    dir := vec2(0, 1) // unit vector
    depth := 0.0 // might be negative
    other: Box

    toString: func -> String {
	"bang: pos %s, dir %s, depth %.2f" format(pos _, dir _, depth)
    }

    _: String { get {
	toString()
    }}

}


