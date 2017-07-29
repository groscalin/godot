#ifndef COLOR_BUTTON_H
#define COLOR_BUTTON_H

#include "scene/gui/button.h"
/**
	@author amugana
*/
class ColorButton : public Button {

	OBJ_TYPE(ColorButton, Button);

protected:
	virtual void draw() const;

public:
	ColorButton(const String &p_text = String());
	~ColorButton();
};

#endif
