#include "garrapata.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Palette uses hardware values.
const u8 pal_main[16] = { 0x54, 0x44, 0x55, 0x5c, 0x4c, 0x56, 0x57, 0x5e, 0x40, 0x4e, 0x47, 0x52, 0x53, 0x4a, 0x43, 0x4b };

// Tile g_array: 8x32 pixels, 4x32 bytes.
const u8 g_array[4 * 32] = {
	0x03, 0xa3, 0x53, 0x03,
	0x03, 0xa3, 0x53, 0x03,
	0x03, 0x00, 0x00, 0x03,
	0x03, 0x00, 0x00, 0x03,
	0x02, 0x30, 0x30, 0x01,
	0x02, 0x30, 0x30, 0x01,
	0x10, 0x30, 0x30, 0x20,
	0x10, 0x30, 0x30, 0x20,
	0x10, 0x10, 0x20, 0x20,
	0x10, 0x10, 0x20, 0x20,
	0x51, 0xba, 0x75, 0x20,
	0x51, 0xba, 0x75, 0x20,
	0x02, 0xb2, 0x30, 0x01,
	0x02, 0xb2, 0x30, 0x01,
	0x51, 0x00, 0x00, 0x20,
	0x51, 0x00, 0x00, 0x20,
	0x00, 0xb2, 0x30, 0x00,
	0x00, 0xb2, 0x30, 0x00,
	0x51, 0x00, 0x00, 0x20,
	0x51, 0x00, 0x00, 0x20,
	0x00, 0xb2, 0x30, 0x00,
	0x00, 0xb2, 0x30, 0x00,
	0x51, 0x00, 0x00, 0x20,
	0x51, 0x00, 0x00, 0x20,
	0x00, 0xb2, 0x30, 0x00,
	0x00, 0xb2, 0x30, 0x00,
	0x51, 0x00, 0x00, 0x20,
	0x51, 0x00, 0x00, 0x20,
	0x51, 0xb2, 0x30, 0x20,
	0x51, 0xb2, 0x30, 0x20,
	0x02, 0x00, 0x00, 0x01,
	0x02, 0x00, 0x00, 0x01
};

