
import g4p_controls.*;
import processing.serial.*;

static final int X = 0;
static final int Y = 1;

static final int WINDOW_SIZE[] = {640, 800};
static final int LARGE_BUTTON_SIZE[] = {80, 40};
static final int SMALL_BUTTON_SIZE[] = {100, 20};

static final int WINDOW_CENTRE[] = {WINDOW_SIZE[X]/2, WINDOW_SIZE[Y]/2-50};

static final int BUTTONX[] = {
  20, 
  40 + LARGE_BUTTON_SIZE[X], 
  60 + LARGE_BUTTON_SIZE[X]*2, 
  80 + LARGE_BUTTON_SIZE[X]*3, 
  100 + LARGE_BUTTON_SIZE[X]*4,
  120 + LARGE_BUTTON_SIZE[X]*5
};
static final int BUTTONY = WINDOW_SIZE[Y] - 100;

static Serial arduino_port;
static Leds leds;

static GButton centre_button;
static GButton ring_buttons[] = new GButton[4];
static GButton number_buttons[] = new GButton[4];

static final int LED_OFF = #555555;
static final int LED_ON = #FFFFFF;

public void draw_leds(int ring, int nleds)
{
  int r = ring * 50;
  float theta = TWO_PI / nleds;
  
  for (int led = 0; led<nleds; led++)
  {
    float x = WINDOW_CENTRE[X] + (r * sin(theta*led));
    float y = WINDOW_CENTRE[Y] - (r * cos(theta*led));
    ellipse(x, y, 20, 20);
  }
}

public void draw_ring(Leds leds, int ring)
{
  fill(leds.ring == ring ? LED_ON : LED_OFF);
  draw_leds(ring, leds.nleds);
}

public void setup() {
  size(640, 800);
  centre_button = new GButton(this, BUTTONX[0], BUTTONY, LARGE_BUTTON_SIZE[X], LARGE_BUTTON_SIZE[Y], "Centre LED");
  ring_buttons[0] = new GButton(this, BUTTONX[1], BUTTONY, LARGE_BUTTON_SIZE[X], LARGE_BUTTON_SIZE[Y], "Rings Off");
  ring_buttons[1] = new GButton(this, BUTTONX[2], BUTTONY, LARGE_BUTTON_SIZE[X], LARGE_BUTTON_SIZE[Y], "Ring 1");
  ring_buttons[2] = new GButton(this, BUTTONX[3], BUTTONY, LARGE_BUTTON_SIZE[X], LARGE_BUTTON_SIZE[Y], "Ring 2");
  ring_buttons[3] = new GButton(this, BUTTONX[4], BUTTONY, LARGE_BUTTON_SIZE[X], LARGE_BUTTON_SIZE[Y], "Ring 3");
  number_buttons[0] = new GButton(this, BUTTONX[5], BUTTONY-30, SMALL_BUTTON_SIZE[X], SMALL_BUTTON_SIZE[Y], "3 LEDs");
  number_buttons[1] = new GButton(this, BUTTONX[5], BUTTONY-10, SMALL_BUTTON_SIZE[X], SMALL_BUTTON_SIZE[Y], "4 LEDs");
  number_buttons[2] = new GButton(this, BUTTONX[5], BUTTONY+10, SMALL_BUTTON_SIZE[X], SMALL_BUTTON_SIZE[Y], "5 LEDs");
  number_buttons[3] = new GButton(this, BUTTONX[5], BUTTONY+30, SMALL_BUTTON_SIZE[X], SMALL_BUTTON_SIZE[Y], "6 LEDs");
  arduino_port = new Serial(this, "/dev/ttyUSB0", 115200);
  leds = new Leds(arduino_port);
}

public void draw() {
  background(color(0, 0, 0));

  fill(leds.centre_led ? LED_ON : LED_OFF);
  ellipse(WINDOW_CENTRE[X], WINDOW_CENTRE[Y], 20, 20);

  for (int i=1; i<4; i++)
  {
    draw_ring(leds, i);
  }
}

void handleButtonEvents(GButton button, GEvent event)
{
  if (button == centre_button)
  {
    leds.centre_led_toggle(arduino_port);
  }

  for (int i=0; i<4; i++)
  {
    if (button == ring_buttons[i])
    {
      leds.set_ring(arduino_port, i);
    }
  }

  for (int i=0; i<4; i++)
  {
    if (button == number_buttons[i])
    {
      leds.set_nleds(arduino_port, 3+i);
    }
  }
}