use    openal, alut, vorbis
import openal, alut, vorbis, os/Time

BUFFER_SIZE := 16_777_216       // 16 MB buffer

// This function loads a .ogg file into a memory buffer and returns
// the format and frequency.
loadOgg: func (fileName: String, buffer: Buffer, format: ALformat@, freq: ALsizei@) {
    
    endian := 0 // 0 for little endian, 1 for big endian
    array := Octet[BUFFER_SIZE] new() // Local fixed size array
    
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

    // Keep reading until all is read
    bitStream: Int
    while (true) {
        // Read up to a buffer's worth of decoded sound data
        bytes := ov_read(oggFile&, array data, BUFFER_SIZE, endian, 2, 1, bitStream&)

        match {
            case bytes > 0 =>
                // append to buffer
                buffer append(array data, bytes)
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
    ov_clear(oggFile&)
    
}

main: func (argc: Int, argv: Char**) {
    state: ALint                      // state of the sound source
    bufferID, sourceID: ALuint        // OpenAL sound buffer ID and sound souce ID
    format: ALformat                  // sound data format
    freq: ALsizei                     // frequency of the sound file
    buffer := Buffer new(BUFFER_SIZE) // The sound buffer data from file

    // Make sure there is a file name
    if (argc < 2) {
        "Syntax: %s file.ogg" format(argv[0]) println()
        return -1
    }

    // Initialize the OpenAL library
    alutInit(argc&, argv)

    // Create sound buffer and source
    alGenBuffers(1, bufferID&)
    alGenSources(1, sourceID&)

    // Set the source and listener to the same location
    alListener3f(AL_POSITION, 0.0, 0.0, 0.0)
    alSource3f(sourceID, AL_POSITION, 0.0, 0.0, 0.0)

    // Load the OGG file into memory
    loadOgg(argv[1] as String, buffer, format&, freq&)

    // Upload sound data to buffer
    alBufferData(bufferID, format, buffer data, buffer size as ALsizei, freq)

    // Attach sound buffer to source
    alSourcei(sourceID, AL_BUFFER, bufferID)

    // Finally, play the sound!!!
    alSourcePlay(sourceID)

    // This is a busy wait loop but should be good enough for example purpose
    while(true) {
        // Query the state of the souce
        alGetSourcei(sourceID, AL_SOURCE_STATE, state&)
        if(state == AL_STOPPED) break
        
        // Sleep a while
        Time sleepMilli(200)
    }

    // Clean up sound buffer and source
    alDeleteBuffers(1, bufferID&)
    alDeleteSources(1, sourceID&)

    // Clean up the OpenAL library
    alutExit()

    0
}
