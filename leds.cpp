#include <Arduino.h>

#include "leds.h"

static const int OUTER_RING_PIN = 2;
static const int MIDDLE_RING_PIN = 3;
static const int INNER_RING_PIN = 4;

static const int TLC5928_DATA = 5;
static const int TLC5928_CLK = 6;
static const int TLC5928_LAT = 7;

static const uint16_t LED_CENTRE = (1 << 0);

static const uint16_t LED_RING_BITMAPS[] = {
	0b0001000100010,
	0b0010010010010,
	0b0100101001010,
	0b1001010100110
};

static uint16_t s_bitmap = 0;
static bool s_centre_on = false;

static void latch()
{
	digitalWrite(TLC5928_LAT, LOW);
	digitalWrite(TLC5928_LAT, HIGH);
	digitalWrite(TLC5928_LAT, LOW);
}

static void led_update(uint16_t bitmap)
{
	uint8_t upper = (bitmap & 0xFF00) >> 8;
	uint8_t lower = (bitmap & 0x00FF);

	digitalWrite(TLC5928_CLK, LOW);
	digitalWrite(TLC5928_LAT, LOW);
	shiftOut(TLC5928_DATA, TLC5928_CLK, MSBFIRST, upper);
	shiftOut(TLC5928_DATA, TLC5928_CLK, MSBFIRST, lower);

	latch();
}

void led_setup()
{
	digitalWrite(OUTER_RING_PIN, HIGH);
	digitalWrite(MIDDLE_RING_PIN, HIGH);
	digitalWrite(INNER_RING_PIN, HIGH);

	pinMode(OUTER_RING_PIN, OUTPUT);
	pinMode(MIDDLE_RING_PIN, OUTPUT);
	pinMode(INNER_RING_PIN, OUTPUT);

	pinMode(TLC5928_DATA, OUTPUT);
	pinMode(TLC5928_CLK, OUTPUT);
	pinMode(TLC5928_LAT, OUTPUT);

	led_all_off();
}

void led_set_ring(enum rings ring)
{
	digitalWrite(OUTER_RING_PIN, HIGH);
	digitalWrite(MIDDLE_RING_PIN, HIGH);
	digitalWrite(INNER_RING_PIN, HIGH);

	switch(ring)
	{
	case OUTER_RING:
		digitalWrite(OUTER_RING_PIN, LOW);
		break;
	case MIDDLE_RING:
		digitalWrite(MIDDLE_RING_PIN, LOW);
		break;
	case INNER_RING:
		digitalWrite(INNER_RING_PIN, LOW);
		break;
	case NO_RING:
	default:
		break;
	}
}

void led_set_ring_count(uint8_t count)
{
	if ((count >=3) && (count <= 6))
	{
		s_bitmap = LED_RING_BITMAPS[count-3];
		s_bitmap |= s_centre_on ? 1 : 0; 
		led_update(s_bitmap);
	}
}

void led_set_centre(bool on)
{
	s_centre_on = on;
	if (on)
	{
		s_bitmap |= LED_CENTRE;
	}
	else
	{
		s_bitmap &= ~(LED_CENTRE);
	}
	led_update(s_bitmap);
}

void led_all_off()
{
	s_bitmap = 0;
	led_update(s_bitmap);
}
