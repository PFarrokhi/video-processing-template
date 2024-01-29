#ifndef _C_FOR_HARDWARE_
#define _C_FOR_HARDWARE_

void write_with_mask(volatile int* address, int mask, int data);
int read_with_mask(volatile int* address, int mask);
void write_to_bit(volatile int* address, int pin, int data);
int read_from_bit(volatile int* address, int pin);

#endif
