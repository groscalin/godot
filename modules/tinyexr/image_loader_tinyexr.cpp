/*************************************************************************/
/*  image_loader_jpegd.cpp                                               */
/*************************************************************************/
/*                       This file is part of:                           */
/*                           GODOT ENGINE                                */
/*                    http://www.godotengine.org                         */
/*************************************************************************/
/* Copyright (c) 2007-2017 Juan Linietsky, Ariel Manzur.                 */
/* Copyright (c) 2014-2017 Godot Engine contributors (cf. AUTHORS.md)    */
/*                                                                       */
/* Permission is hereby granted, free of charge, to any person obtaining */
/* a copy of this software and associated documentation files (the       */
/* "Software"), to deal in the Software without restriction, including   */
/* without limitation the rights to use, copy, modify, merge, publish,   */
/* distribute, sublicense, and/or sell copies of the Software, and to    */
/* permit persons to whom the Software is furnished to do so, subject to */
/* the following conditions:                                             */
/*                                                                       */
/* The above copyright notice and this permission notice shall be        */
/* included in all copies or substantial portions of the Software.       */
/*                                                                       */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*/
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                */
/*************************************************************************/
#include "image_loader_tinyexr.h"

#include "os/os.h"
#include "print_string.h"

#include "thirdparty/tinyexr/tinyexr.h"

Error ImageLoaderTinyEXR::load_image(Ref<Image> p_image, FileAccess *f) {

	PoolVector<uint8_t> src_image;
	int src_image_len = f->get_len();
	ERR_FAIL_COND_V(src_image_len == 0, ERR_FILE_CORRUPT);
	src_image.resize(src_image_len);

	PoolVector<uint8_t>::Write w = src_image.write();

	f->get_buffer(&w[0], src_image_len);

	f->close();

	EXRVersion exr_version;
	EXRImage exr_image;
	EXRHeader exr_header;
	const char *err = NULL;

	InitEXRHeader(&exr_header);

	int ret = ParseEXRVersionFromMemory(&exr_version, w.ptr(), src_image_len);
	if (ret != TINYEXR_SUCCESS) {

		return ERR_FILE_CORRUPT;
	}

	ret = ParseEXRHeaderFromMemory(&exr_header, &exr_version, w.ptr(), src_image_len, &err);
	if (ret != TINYEXR_SUCCESS) {
		if (err) {
			ERR_PRINTS(String(err));
		}
		return ERR_FILE_CORRUPT;
	}

	InitEXRImage(&exr_image);
	ret = LoadEXRImageFromMemory(&exr_image, &exr_header, w.ptr(), src_image_len, &err);
	if (ret != TINYEXR_SUCCESS) {
		if (err) {
			ERR_PRINTS(String(err));
		}
		return ERR_FILE_CORRUPT;
	}

	// RGBA
	int idxR = -1;
	int idxG = -1;
	int idxB = -1;
	int idxA = -1;
	for (int c = 0; c < exr_header.num_channels; c++) {
		if (strcmp(exr_header.channels[c].name, "R") == 0) {
			idxR = c;
		} else if (strcmp(exr_header.channels[c].name, "G") == 0) {
			idxG = c;
		} else if (strcmp(exr_header.channels[c].name, "B") == 0) {
			idxB = c;
		} else if (strcmp(exr_header.channels[c].name, "A") == 0) {
			idxA = c;
		}
	}

	if (idxR == -1) {
		ERR_PRINT("R channel not found");
		// @todo { free exr_image }
		return ERR_FILE_CORRUPT;
	}

	if (idxG == -1) {
		ERR_PRINT("G channel not found\n")
		// @todo { free exr_image }
		return ERR_FILE_CORRUPT;
	}

	if (idxB == -1) {
		ERR_PRINT("B channel not found\n")
		// @todo { free exr_image }
		return ERR_FILE_CORRUPT;
	}

	PoolVector<uint8_t> imgdata;
	Image::Format format;

	if (idxA > 0) {

		imgdata.resize(exr_image.width * exr_image.height * 8); //RGBA16
		format = Image::FORMAT_RGBAH;
	} else {

		imgdata.resize(exr_image.width * exr_image.height * 6); //RGB16
		format = Image::FORMAT_RGBH;
	}

	{

		PoolVector<uint8_t>::Write wd = imgdata.write();
		uint16_t *iw = (uint16_t *)wd.ptr();

		// Assume `out_rgba` have enough memory allocated.
		for (int i = 0; i < exr_image.width * exr_image.height; i++) {

			*iw++ = Math::make_half_float(reinterpret_cast<float **>(exr_image.images)[idxR][i]);
			*iw++ = Math::make_half_float(reinterpret_cast<float **>(exr_image.images)[idxG][i]);
			*iw++ = Math::make_half_float(reinterpret_cast<float **>(exr_image.images)[idxB][i]);

			if (idxA > 0) {
				*iw++ = Math::make_half_float(reinterpret_cast<float **>(exr_image.images)[idxA][i]);
			}
		}
	}

	print_line("EXR w: " + itos(exr_image.width) + " h:" + itos(exr_image.height) + " format " + Image::get_format_name(format));
	p_image->create(exr_image.width, exr_image.height, false, format, imgdata);

	w = PoolVector<uint8_t>::Write();

	return OK;
}

void ImageLoaderTinyEXR::get_recognized_extensions(List<String> *p_extensions) const {

	p_extensions->push_back("exr");
}

ImageLoaderTinyEXR::ImageLoaderTinyEXR() {
}
