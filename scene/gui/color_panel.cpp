#include "color_panel.h"
//#include "print_string.h"

void ColorPanel::_notification(int p_what) {

	if (p_what == NOTIFICATION_DRAW) {

		RID ci = get_canvas_item();
		Ref<StyleBox> style = get_stylebox("panel");
		style->draw_colored(ci, Rect2(Point2(), get_size()), get_color("color"));
	}
}

ColorPanel::ColorPanel() {
	set_stop_mouse(true);
}

ColorPanel::~ColorPanel() {
}
