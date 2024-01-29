#include "Gpio.h"
#include <stdio.h>
#include "CForHardware.h"

#define CHANNELS_OFFSET 2

enum GpioControlRegisters
{
  channelData,
  channelDirection,
  globalInterruptEnable = 71,
  ipInterruptEnable = 74,
  ipInterruptStatus = 76
};

void gpio_init(Gpio* gpioPtr, volatile int* gpioBase, int channelQuantity)
{
  gpioPtr->gpioBase = gpioBase;
  gpioPtr->channelQuantity = channelQuantity;
}

void gpio_set_value(Gpio* gpioPtr, int channel, int valueMask)
{
  if(channel < gpioPtr->channelQuantity)
  {
    gpioPtr->gpioBase[channelData + (CHANNELS_OFFSET * channel)] = valueMask;
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

int gpio_get_value(Gpio* gpioPtr, int channel)
{
  if(channel < gpioPtr->channelQuantity)
  {
    return (gpioPtr->gpioBase[channelData + (CHANNELS_OFFSET * channel)]);
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

void gpio_set_pin_value(Gpio* gpioPtr, int channel, int pin, int value)
{
  if(channel < gpioPtr->channelQuantity)
  {
    write_to_bit(&gpioPtr->gpioBase[channelData + (CHANNELS_OFFSET * channel)], pin, value);
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

int gpio_get_pin_value(Gpio* gpioPtr, int channel, int pin)
{
  if(channel < gpioPtr->channelQuantity)
  {
    return read_from_bit(&gpioPtr->gpioBase[channelData + (CHANNELS_OFFSET * channel)], pin);
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

void gpio_set_direction(Gpio* gpioPtr, int channel, int directionMask)
{
  if(channel < gpioPtr->channelQuantity)
  {
    gpioPtr->gpioBase[channelDirection + (CHANNELS_OFFSET * channel)] = directionMask;
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

int gpio_get_direction(Gpio* gpioPtr, int channel)
{
  if(channel < gpioPtr->channelQuantity)
  {
    return (gpioPtr->gpioBase[channelDirection + (CHANNELS_OFFSET * channel)]);
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

void gpio_set_pin_direction(Gpio* gpioPtr, int channel, int pin, int direction)
{
  if(channel < gpioPtr->channelQuantity)
  {
    write_to_bit(&gpioPtr->gpioBase[channelDirection + (CHANNELS_OFFSET * channel)], pin, direction);
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

int gpio_get_pin_direction(Gpio* gpioPtr, int channel, int pin)
{
  if(channel < gpioPtr->channelQuantity)
  {
    return read_from_bit(&gpioPtr->gpioBase[channelDirection + (CHANNELS_OFFSET * channel)], pin);
  }
  else
  {
    printf("ERROR: Invalid channel: %d\r\n", channel);
  }
}

void gpio_global_interrupt_enable(Gpio* gpioPtr)
{
  write_to_bit(&gpioPtr->gpioBase[globalInterruptEnable], 31, 1);
}

void gpio_global_interrupt_disable(Gpio* gpioPtr)
{
  write_to_bit(&gpioPtr->gpioBase[globalInterruptEnable], 31, 0);
}

void gpio_channel_interrupt_enable(Gpio* gpioPtr, int channel)
{
  write_to_bit(&gpioPtr->gpioBase[globalInterruptEnable], channel, 1);
}

void gpio_channel_interrupt_disable(Gpio* gpioPtr, int channel)
{
  write_to_bit(&gpioPtr->gpioBase[globalInterruptEnable], channel, 0);
}
