#include "CForHardware.h"

void write_with_mask(volatile int* address, int mask, int data)
{
  int last_value = *address;
  *address = ((last_value & ~mask) | (data & mask));
}

int read_with_mask(volatile int* address, int mask)
{
  int last_value = *address;
  return (last_value & mask);
}

void write_to_bit(volatile int* address, int pin, int data)
{
  int mask = (0x1 << pin);
  data = (data << pin);
  write_with_mask(address, mask, data);
}

int read_from_bit(volatile int* address, int pin)
{
  int mask = (0x1 << pin);
  int data = read_with_mask(address, mask);
  return (data >> pin);
}
