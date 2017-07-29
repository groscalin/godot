#ifndef COLOR_PANEL_H
#define COLOR_PANEL_H

#include "scene/gui/control.h"
class ColorPanel : public Control {

	OBJ_TYPE(ColorPanel, Control);

protected:
	void _notification(int p_what);

public:
	ColorPanel();
	~ColorPanel();
};

#endif
