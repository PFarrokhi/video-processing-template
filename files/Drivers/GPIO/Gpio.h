#ifndef _GPIO_
#define _GPIO_

#define GPIO_OUTPUT_DIRECTION 0
#define GPIO_INPUT_DIRECTION 1

typedef struct
{
  volatile int* gpioBase;
  int channelQuantity;
} Gpio;

void gpio_init(Gpio* gpioPtr, volatile int* gpioBase, int channelQuantity);
void gpio_set_value(Gpio* gpioPtr, int channel, int valueMask);
int gpio_get_value(Gpio* gpioPtr, int channel);
void gpio_set_pin_value(Gpio* gpioPtr, int channel, int pin, int value);
int gpio_get_pin_value(Gpio* gpioPtr, int channel, int pin);
void gpio_set_direction(Gpio* gpioPtr, int channel, int direction_mask);
int gpio_get_direction(Gpio* gpioPtr, int channel);
void gpio_set_pin_direction(Gpio* gpioPtr, int channel, int pin, int direction);
int gpio_get_pin_direction(Gpio* gpioPtr, int channel, int pin);
void gpio_global_interrupt_enable(Gpio* gpioPtr);
void gpio_global_interrupt_disable(Gpio* gpioPtr);
void gpio_channel_interrupt_enable(Gpio* gpioPtr, int channel);
void gpio_channel_interrupt_disable(Gpio* gpioPtr, int channel);

#endif
