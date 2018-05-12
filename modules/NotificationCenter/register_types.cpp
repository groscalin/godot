#include <version_generated.gen.h>

#if VERSION_MAJOR == 3
#include <core/class_db.h>
#include <core/engine.h>
#else
#include "object_type_db.h"
#include "core/globals.h"
#endif

#include "register_types.h"
#include "ios/NotificationCenter.h"

void register_NotificationCenter_types() {
#if VERSION_MAJOR == 3
    Engine::get_singleton()->add_singleton(Engine::Singleton("NotificationCenter", memnew(NotificationCenter)));
#else
    Globals::get_singleton()->add_singleton(Globals::Singleton("NotificationCenter", memnew(NotificationCenter)));
#endif
}

void unregister_NotificationCenter_types() {
}
