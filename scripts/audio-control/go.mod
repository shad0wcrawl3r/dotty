module github.com/shad0wcrawl3r/audio-control

go 1.23.3

// require github.com/godbus/dbus/v5 v5.1.0 // indirect
require github.com/shad0wcrawl3r/audio-control/pipewire v0.0.0

require (
	github.com/jawher/mow.cli v1.2.0 // indirect
	github.com/smfloris/pw-info v0.0.0-20220911201106-db3d5da12acc // indirect
)

replace github.com/shad0wcrawl3r/audio-control/pipewire => ./pipewire
