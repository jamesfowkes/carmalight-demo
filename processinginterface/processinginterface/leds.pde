import processing.serial.*;

public class Leds
{  
  boolean centre_led;
  int ring;
  int nleds;
  
  Leds(Serial port)
  {
    delay(1500);
    this.set_nleds(port, 3);
    this.set_ring(port, 0);
    centre_led = false;
  }
  
  void centre_led_toggle(Serial port)
  {
    this.centre_led = !this.centre_led;
    port.write(this.centre_led ? "C1\n" : "C0\n");
  }
  
  void set_ring(Serial port, int ring)
  {
    StringBuilder sb = new StringBuilder();
    sb.append("R");
    sb.append(ring);
    sb.append("\n");
    this.ring = ring;
    port.write(sb.toString());
  }
  
  void set_nleds(Serial port, int n)
  {
    StringBuilder sb = new StringBuilder();
    sb.append("N");
    sb.append(n);
    sb.append("\n");
    this.nleds = n;
    port.write(sb.toString());
  }
  
};