#ifndef _LEDS_H_
#define _LEDS_H_

enum rings
{
	NO_RING,
	INNER_RING,
	MIDDLE_RING,
	OUTER_RING
};

void led_setup();
void led_set_centre(bool on);
void led_set_ring(enum rings ring);
void led_set_ring_count(uint8_t count);
void led_all_off();

#endif
