#include "Vfb.h"
#include <unistd.h>
#include "Gpio.h"
#include "CForHardware.h"

#define TPG_REG_SIZE 52

enum VfbControlRegisters
{
  control,
  globalInterruptEnable,
  ipInterruptEnable,
  ipInterruptStatus,
  activeWidth,
  activeHeight = 6,
  activeStride = 8,
  videoFormat = 10,
  videoAddress = 12
};

enum VfbControlPins
{
  start,
  done,
  idle,
  ready,
  autorestart = 7
};

void vfb_init(Vfb* vfbPtr, volatile int* vfbBase)
{
  vfbPtr->vfbBase = vfbBase;
  vfb_remove_reset(vfbPtr);
}

void vfb_set_reset(Vfb* vfbPtr, Gpio* externalReset, int externalResetChannel, int externalResetPin)
{
  vfbPtr->externalReset = externalReset;
  vfbPtr->externalResetChannel = externalResetChannel;
  vfbPtr->externalResetPin = externalResetPin;
  vfbPtr->haveExternalReset = true;
  gpio_set_pin_direction(vfbPtr->externalReset, vfbPtr->externalResetChannel, vfbPtr->externalResetPin, GPIO_OUTPUT_DIRECTION);
  gpio_set_pin_value(vfbPtr->externalReset, vfbPtr->externalResetChannel, vfbPtr->externalResetPin, 1);
}

void vfb_remove_reset(Vfb* vfbPtr)
{
  vfbPtr->haveExternalReset = false;
}

void vfb_reset(Vfb* vfbPtr)
{
  if(vfbPtr->haveExternalReset)
  {
    gpio_set_pin_value(vfbPtr->externalReset, vfbPtr->externalResetChannel, vfbPtr->externalResetPin, 0);
    usleep(1);
    gpio_set_pin_value(vfbPtr->externalReset, vfbPtr->externalResetChannel, vfbPtr->externalResetPin, 1);
  }
  else
  {
	  vfb_autorestart_disable(vfbPtr);
  }
}

void vfb_start(Vfb* vfbPtr)
{
  write_to_bit(&vfbPtr->vfbBase[control], start, 1);
}

void vfb_stop(Vfb* vfbPtr)
{
  write_to_bit(&vfbPtr->vfbBase[control], start, 0);
}

_Bool vfb_is_done(Vfb* vfbPtr)
{
  return (read_from_bit(&vfbPtr->vfbBase[control], done));
}

_Bool vfb_is_idle(Vfb* vfbPtr)
{
  return (read_from_bit(&vfbPtr->vfbBase[control], idle));
}

_Bool vfb_is_ready(Vfb* vfbPtr)
{
  return (read_from_bit(&vfbPtr->vfbBase[control], ready));
}

void vfb_autorestart_enable(Vfb* vfbPtr)
{
  write_to_bit(&vfbPtr->vfbBase[control], autorestart, 1);
}

void vfb_autorestart_disable(Vfb* vfbPtr)
{
  write_to_bit(&vfbPtr->vfbBase[control], autorestart, 0);
}

void vfb_global_interrupt_enable(Vfb* vfbPtr)
{
  write_to_bit(&vfbPtr->vfbBase[globalInterruptEnable], 0, 1);
}

void vfb_global_interrupt_disable(Vfb* vfbPtr)
{
  write_to_bit(&vfbPtr->vfbBase[globalInterruptEnable], 0, 0);
}

_Bool vfb_global_interrupt_is_enable(Vfb* vfbPtr)
{
  return (read_from_bit(&vfbPtr->vfbBase[globalInterruptEnable], 0));
}

void vfb_set_width(Vfb* vfbPtr, int data)
{
  vfbPtr->vfbBase[activeWidth] = data;
}

int vfb_get_width(Vfb* vfbPtr)
{
  return vfbPtr->vfbBase[activeWidth];
}

void vfb_set_height(Vfb* vfbPtr, int data)
{
  vfbPtr->vfbBase[activeHeight] = data;
}

int vfb_get_height(Vfb* vfbPtr)
{
  return vfbPtr->vfbBase[activeHeight];
}

void vfb_set_stride(Vfb* vfbPtr, int data)
{
  vfbPtr->vfbBase[activeStride] = data;
}

int vfb_get_stride(Vfb* vfbPtr)
{
  return vfbPtr->vfbBase[activeStride];
}

void vfb_set_video_format(Vfb* vfbPtr, int data)
{
  vfbPtr->vfbBase[videoFormat] = data;
}

int vfb_get_video_format(Vfb* vfbPtr)
{
  return vfbPtr->vfbBase[videoFormat];
}

void vfb_set_video_address(Vfb* vfbPtr, int data)
{
  vfbPtr->vfbBase[videoAddress] = data;
}

int vfb_get_video_address(Vfb* vfbPtr)
{
  return vfbPtr->vfbBase[videoAddress];
}
