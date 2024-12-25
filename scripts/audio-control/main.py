from pydbus import SessionBus

# Connect to the session bus
bus = SessionBus()

# Get the WirePlumber object
wireplumber = bus.get(
    "org.freedesktop.portal.Desktop", "/org/freedesktop/portal/desktop"
)


# Function to get the default audio sink volume
def get_default_sink_volume():
    try:
        # Replace with the correct method to get volume
        volume = wireplumber.GetVolume("@DEFAULT_AUDIO_SINK@")
        print(f"Current volume: {volume}")
    except Exception as e:
        print(f"Error getting volume: {e}")


# Function to list all available audio sinks
def list_audio_sinks():
    try:
        # Replace with the correct method to list sinks
        sinks = wireplumber.ListAudioSinks()
        print("Available audio sinks:")
        for sink in sinks:
            print(f" - {sink}")
    except Exception as e:
        print(f"Error listing audio sinks: {e}")


# Main function to run the script
def main():
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == "list":
        list_audio_sinks()
    else:
        get_default_sink_volume()


if __name__ == "__main__":
    main()
