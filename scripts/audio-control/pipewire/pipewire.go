package pipewire

/*
#cgo pkg-config: libpipewire-0.3
#include <pipewire/pipewire.h>
*/
import "C"
import "log"

func GetMainLoop() *C.struct_pw_main_loop {
	mainloop := C.pw_main_loop_new(nil)
	return mainloop
}

func GetLoop(mainloop interface{}) *C.struct_pw_loop {
	loop, ok := mainloop.(*C.struct_pw_main_loop)
	if !ok {
		log.Fatal("Type Asseetion for mainloop failed")
	}
	final := C.pw_main_loop_get_loop(loop)
	return final
}

func NewContext(subloop interface{}) *C.struct_pw_context {
	loop, ok := subloop.(*C.struct_pw_loop)
	if !ok {
		log.Fatal("Type Assertion Failed for loop")
	}
	context := C.pw_context_new(loop, nil, 0)
	return context
}

func ConnectToPipeWire(context interface{}) *C.struct_pw_core {
	ctx, ok := context.(*C.struct_pw_context)
	if !ok {
		log.Fatal("Type Assertion Failed for Context")
	}
	core := C.pw_context_connect(ctx, nil, 0)
	return core
}

func GetRegistry(core interface{}) *C.struct_pw_registry {
	core_new, ok := core.(*C.struct_pw_core)
	if !ok {
		log.Fatal("Type Assertion Failed for Context")
	}
	registry := C.pw_core_get_registry(core_new, 3, 0)
	return registry
}

type RegistryEvents struct {
	Global func(*C.struct_pw_registry, *C.struct_pw_global)
}

func AddListenerToRegistry(registry interface{}, events *RegistryEvents) {
	reg, ok := registry.(*C.struct_pw_registry)
	if !ok {
		log.Fatal("Type Assertion Failed for Registry")
	}
	_ = reg
	var _ C.struct_pw_registry_listener
	var _ C.struct_pw_registry_events

	// var registryListener C.struct_pw_registry_listener
	// var registryEvents C.struct_pw_registry_events
	// if events != nil {
	// 	if events.Global != nil {
	// 		registryEvents.global = C.PW_GLOBAL_ADDED_FUNC(C.globalAddedCallback)
	// 	}
	// }
	//
	// C.pw_registry_add_listener(registry, &registryListener, &registryEvents, nil)
}
