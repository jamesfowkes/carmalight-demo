#include "leds.h"

static String s_serial_buffer;

static void handle_command(String& command)
{
	if (command[0] == 'N')
	{
		led_set_ring_count(command[1] - '0');
	}
	else if (command[0] == 'R')
	{
		led_set_ring((enum rings)(command[1] - '0'));
	}
	else if (command[0] == 'C')
	{
		led_set_centre(command[1] == '1');
	}
}

static void serial_handler(char c, String& buffer)
{
	if (c == '\n')
	{
		handle_command(buffer);
		buffer = "";
	}
	else
	{
		buffer += c;
	}
}

void setup()
{
	led_setup();
	Serial.begin(115200);
}

void loop()
{

}

void serialEvent()
{
	while (Serial.available())
	{
		serial_handler(Serial.read(), s_serial_buffer);
	}
}
