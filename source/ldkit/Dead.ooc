
use deadlogger
import deadlogger/[Log, Handler, Formatter, Filter, Logger]

Dead: class {

    initialized := static false
    console: static StdoutHandler

    logger: static func (name: String) -> Logger {
	if (!initialized) {
	    console = StdoutHandler new()
	    console setFormatter(ColoredFormatter new(NiceFormatter new()))
	    Log root attachHandler(console)
	    initialized = true
	}

	Log getLogger("main")
    }

}

