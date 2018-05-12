#include "reference.h"

class NotificationCenter : public Reference {
#if VERSION_MAJOR == 3
    GDCLASS(NotificationCenter, Reference);
#else
    OBJ_TYPE(NotificationCenter, Reference);
#endif

protected:
    static void _bind_methods();

public:
    void init();
    void scheduleLocal(const String& title, const String& msg, int intervalSec);
};
