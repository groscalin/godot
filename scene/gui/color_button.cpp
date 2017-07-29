#include "color_button.h"
//#include "print_string.h"
#include "servers/visual_server.h"
#include "translation.h"

void ColorButton::draw() const {
    RID ci = get_canvas_item();
    Size2 size = get_size();
    Color fnt_color = get_color("font_color");
    Color sb_color = get_color("stylebox_color");

    //print_line(get_text()+": "+itos(is_flat())+" hover "+itos(get_draw_mode()));

    switch (get_draw_mode()) {

        case DRAW_HOVER: 
        case DRAW_NORMAL: {
            if (!flat)
                get_stylebox("normal")->draw_colored(ci, Rect2(Point2(0, 0), size), sb_color);
        } break;
        case DRAW_PRESSED: {
            sb_color.r = MAX(sb_color.r - 0.2f, 0);
            sb_color.g = MAX(sb_color.g - 0.2f, 0);
            sb_color.b = MAX(sb_color.b - 0.2f, 0);

            fnt_color.r = MAX(fnt_color.r - 0.2f, 0);
            fnt_color.g = MAX(fnt_color.g - 0.2f, 0);
            fnt_color.b = MAX(fnt_color.b - 0.2f, 0);

            get_stylebox("pressed")->draw_colored(ci, Rect2(Point2(0, 0), size), sb_color);

        } break;
        case DRAW_DISABLED: {
            fnt_color = sb_color = Color::hex(0x0000001e);
            get_stylebox("disabled")->draw_colored(ci, Rect2(Point2(0, 0), size), sb_color);

        } break;
    }
/*
    if (has_focus()) {

        Ref<StyleBox> style = get_stylebox("focus");
        style->draw(ci, Rect2(Point2(), size));
    }
*/
    Ref<StyleBox> style = get_stylebox("normal");
    Ref<Font> font = get_font("font");
    Ref<Texture> _icon;
    if (icon.is_null() && has_icon("icon"))
        _icon = Control::get_icon("icon");
    else
        _icon = icon;

    Point2 icon_ofs = (!_icon.is_null()) ? Point2(_icon->get_width() + get_constant("hseparation"), 0) : Point2();
    int text_clip = size.width - style->get_minimum_size().width - icon_ofs.width;
    Point2 text_ofs = (size - style->get_minimum_size() - icon_ofs - font->get_string_size(text)) / 2.0;
    text_ofs.y = (size.y - font->get_height()) / 2.0;

    Point2 margin = style->get_offset();
    if (style->is_type("StyleBoxTexture")) {
        StyleBoxTexture* styletex = style->cast_to<StyleBoxTexture>();
        margin = Point2(styletex->get_expand_margin_size(MARGIN_LEFT), styletex->get_expand_margin_size(MARGIN_TOP));
    }

    switch (align) {
        case ALIGN_LEFT: {
            text_ofs.x = style->get_margin(MARGIN_LEFT) + icon_ofs.x;
            text_ofs.y += margin.y;
        } break;
        case ALIGN_CENTER: {
            if (text_ofs.x < 0)
                text_ofs.x = 0;
            text_ofs += icon_ofs;
            text_ofs += margin;
        } break;
        case ALIGN_RIGHT: {
            text_ofs.x = size.x - style->get_margin(MARGIN_RIGHT) - font->get_string_size(text).x;
            text_ofs.y += margin.y;
        } break;
    }

    text_ofs.y += font->get_ascent();
    font->draw(ci, text_ofs.floor(), text, fnt_color, clip_text ? text_clip : -1);
    if (!_icon.is_null()) {

        int valign = size.height - style->get_minimum_size().y;

        _icon->draw(ci, style->get_offset() + Point2(0, Math::floor((valign - _icon->get_height()) / 2.0)), is_disabled() ? Color(1, 1, 1, 0.4) : Color(1, 1, 1));
    }
}

ColorButton::ColorButton(const String &p_text) {
}

ColorButton::~ColorButton() {
}
