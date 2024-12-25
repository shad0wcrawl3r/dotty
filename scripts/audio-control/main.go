package main

/*
#cgo pkg-config: libpipewire-0.3
#include <pipewire/pipewire.h>
*/
import "C"

import (
	"fmt"
	"log"

	"github.com/shad0wcrawl3r/audio-control/pipewire"
	// "github.com/shad0wcrawl3r/audio-control/pipewire"
)

// func GetMainLoop() *C.struct_pw_main_loop {
// 	return C.pw_main_loop_new(nil)
// }

func Initialize() {
	C.pw_init(nil, nil)
	log.Println("PipeWire initialized")
}

func main() {
	Initialize()
	mainloop := pipewire.GetMainLoop()
	if mainloop == nil {
		log.Fatal("Failed to create Pipewire mainloop")
	}

	loop := pipewire.GetLoop(mainloop)
	if loop == nil {
		log.Fatal("Failed to create PipeWire loop from mainloop")
	}

	context := pipewire.NewContext(loop)
	if context == nil {
		log.Fatal("Failed to create Pipewire Context")
	}
	core := pipewire.ConnectToPipeWire(context)
	if core == nil {
		log.Fatal("Failed to Connect to PipeWire")
	}
	registry := pipewire.GetRegistry(core)
	if registry == nil {
		log.Fatal("Registry is nil")
	}
	pipewire.AddListenerToRegistry(registry, &pipewire.RegistryEvents{})

	// loop := C.pw_main_loop
	// context := C.pw_context_new(mainloop, nil, 0)
	// core = C.pw_context_connect(context, nil, 0)
	// registry = C.pw_core_get_registry(core, nil, 0)

	fmt.Println("Hello, world!")
}
