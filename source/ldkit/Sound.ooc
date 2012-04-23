use    openal, alut, vorbis, deadlogger
import openal, alut, vorbis, os/Time, io/File, structs/[ArrayList, HashMap], deadlogger/Log

SourceState: enum {
    STOPPED
    PLAYING
}

Source: class {
    
    boombox: Boombox
    sample: Sample
    autofree: Bool
    loop := false

    state := SourceState PLAYING

    state: ALint // state of the sound source
        
    sourceID: ALuint // OpenAL sound source ID
    
    init: func (=boombox, =sample, =autofree) {
        alGenSources(1, sourceID&)

        alSourceQueueBuffers(sourceID, sample bufferIDs size, sample bufferIDs toArray())

        alSource3f(sourceID, AL_POSITION, 0.0, 0.0, 0.0)
    }

    getState: func -> SourceState {
        // Query the state of the souce
        als: ALuint
        alGetSourcei(sourceID, AL_SOURCE_STATE, als&)
        match als {
            case AL_STOPPED => SourceState STOPPED
            case            => SourceState PLAYING
            // TODO: handle other cases?
        }
    }

    update: func {
        if(getState() == SourceState STOPPED) {
            if(autofree) {
                "Freeing source %d, because already stopped" printfln(sourceID)
                boombox freeSource(this)
            } else if (loop) {
                "Looping source %d" printfln(sourceID)
                play()
            }
        }
    }

    play: func {
        //"Playing source %d" printfln(sourceID)
        alSourcePlay(sourceID)
    }

    free: func {
        alDeleteSources(1, sourceID&)
    }

}

TINY_BUFFER_SIZE := 4096

// a sound loaded from a file
Sample: class {
    bufferIDs := ArrayList<ALuint> new()
    format: ALformat
    freq: ALsizei
     
    path: String

    // loads the sample
    init: func (=path) {
        if (path endsWith?(".ogg")) {
            loadOgg(path)
        } else {
            Exception new("Cannot load %s file, unknown format (only OGG is supported)" format(path)) throw()
        }

    }

    // This function loads a .ogg file into a memory buffer and returns
    // the format and frequency.
    loadOgg: func (fileName: String) {
        endian := 0 // 0 for little endian, 1 for big endian
        
        // Open for binary reading
        f := fopen(fileName, "rb")
        if (!f) {
            Exception new("Cannot open %s for reading..." format(fileName)) throw()
        }

        oggFile: OggFile

        // Try opening the given file
        if (ov_open(f, oggFile&, null, 0) != 0) {
            Exception new("Error opening %s for decoding..." format(fileName)) throw()
        }

        // Get some information about the OGG file
        pInfo := ov_info(oggFile&, -1)

        // Check the number of channels... always use 16-bit samples
        format = (pInfo@ channels == 1) ?
            ALformat mono16 :
            ALformat stereo16

        // The frequency of the sampling rate
        freq = pInfo@ rate

        buffer: Char* = gc_malloc(TINY_BUFFER_SIZE)
        bufferID: ALuint

        bitStream: Int
        totalSize := 0
        while (true) {
            bytes := ov_read(oggFile&, buffer, TINY_BUFFER_SIZE, endian, 2, 1, bitStream&)
            totalSize += bytes

            match {
                case bytes > 0 =>
                    // create a new buffer
                    alGenBuffers(1, bufferID&)
                    bufferIDs add(bufferID)
                    alBufferData(bufferID, format, buffer, bytes, freq)
                case bytes < 0 =>
                    // something wrong happened
                    ov_clear(oggFile&)
                    Exception new("Error decoding %s..." format(fileName)) throw()
                case =>
                    // end of file!
                    break
            }
        }

        // Clean up!
        gc_free(buffer)
        ov_clear(oggFile&)
    }

    free: func {
        alDeleteBuffers(bufferIDs size, bufferIDs toArray())
    }

}

// a sound system :D
Boombox: class {
    
    logger := static Log getLogger("boombox")
    cache := HashMap<String, Sample> new()
    sources := ArrayList<Source> new()

    init: func {
        // Initialize the OpenAL library
        argc := 1
        arg := "establichment" as Char*

        alutInit(argc&, arg&)

        alListener3f(AL_POSITION, 0.0, 0.0, 0.0)
        logger info("Sound system initialized")
    }

    load: func (path: String) -> Sample {
        aPath := File new(path) getAbsolutePath()
        if (cache contains?(aPath)) {
            cache get(aPath)
        } else {
            logger info("Loading audio file... %s" format(path))
            s := Sample new(aPath)
            cache put(aPath, s)
            s
        }
    }

    update: func {
        i := 0
        while (i < sources size) {
            // weird way to iterate because we remove sources
            sources[i] update()
            i += 1
        }
    }

    loop: func (s: Sample) -> Source {
        src := Source new(this, s, false)
        sources add(src)
        src loop = true
        src play()
        src
    }

    play: func (s: Sample) -> Source {
        src := Source new(this, s, true)
        sources add(src)
        src play()
        src
    }
    
    freeSource: func (src: Source) {
        src free()
        sources remove(src)
    }

    destroy: func {
        // Clean up the OpenAL library
        alutExit()
    }

}

