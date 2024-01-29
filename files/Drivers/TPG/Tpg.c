#include "Tpg.h"
#include <unistd.h>
#include "Gpio.h"
#include "CForHardware.h"

#define TPG_REG_SIZE 52

enum TpgControlRegisters
{
  control,
  globalInterruptEnable,
  activeHeight = 4,
  activeWidth = 6,
  backgroundPatternId = 8,
  maskId = 12,
  motionSpeed = 14,
  colorFormat = 16
};

enum TpgControlPins
{
  start,
  done,
  idle,
  ready,
  autorestart = 7
};

void tpg_init(Tpg* tpgPtr, volatile int* tpgBase)
{
  tpgPtr->tpgBase = tpgBase;
  tpg_remove_reset(tpgPtr);
}

void tpg_set_reset(Tpg* tpgPtr, Gpio* externalReset, int externalResetChannel, int externalResetPin)
{
  tpgPtr->externalReset = externalReset;
  tpgPtr->externalResetChannel = externalResetChannel;
  tpgPtr->externalResetPin = externalResetPin;
  tpgPtr->haveExternalReset = true;
  gpio_set_pin_direction(tpgPtr->externalReset, tpgPtr->externalResetChannel, tpgPtr->externalResetPin, GPIO_OUTPUT_DIRECTION);
  gpio_set_pin_value(tpgPtr->externalReset, tpgPtr->externalResetChannel, tpgPtr->externalResetPin, 1);
}

void tpg_remove_reset(Tpg* tpgPtr)
{
  tpgPtr->haveExternalReset = false;
}

void tpg_reset(Tpg* tpgPtr)
{
  if(tpgPtr->haveExternalReset)
  {
    gpio_set_pin_value(tpgPtr->externalReset, tpgPtr->externalResetChannel, tpgPtr->externalResetPin, 0);
    usleep(1);
    gpio_set_pin_value(tpgPtr->externalReset, tpgPtr->externalResetChannel, tpgPtr->externalResetPin, 1);
  }
  else
  {
    for(int registerOffset = 0; registerOffset < TPG_REG_SIZE; registerOffset++)
    {
      tpgPtr->tpgBase[registerOffset] = 0;
    }
  }
}

void tpg_start(Tpg* tpgPtr)
{
  write_to_bit(&tpgPtr->tpgBase[control], start, 1);
}

void tpg_stop(Tpg* tpgPtr)
{
  write_to_bit(&tpgPtr->tpgBase[control], start, 0);
}

_Bool tpg_is_done(Tpg* tpgPtr)
{
  return (read_from_bit(&tpgPtr->tpgBase[control], done));
}

_Bool tpg_is_idle(Tpg* tpgPtr)
{
  return (read_from_bit(&tpgPtr->tpgBase[control], idle));
}

_Bool tpg_is_ready(Tpg* tpgPtr)
{
  return (read_from_bit(&tpgPtr->tpgBase[control], ready));
}

void tpg_autorestart_enable(Tpg* tpgPtr)
{
  write_to_bit(&tpgPtr->tpgBase[control], autorestart, 1);
}

void tpg_autorestart_disable(Tpg* tpgPtr)
{
  write_to_bit(&tpgPtr->tpgBase[control], autorestart, 0);
}

void tpg_global_interrupt_enable(Tpg* tpgPtr)
{
  write_to_bit(&tpgPtr->tpgBase[globalInterruptEnable], 0, 1);
}

void tpg_global_interrupt_disable(Tpg* tpgPtr)
{
  write_to_bit(&tpgPtr->tpgBase[globalInterruptEnable], 0, 0);
}

_Bool tpg_global_interrupt_is_enable(Tpg* tpgPtr)
{
  return (read_from_bit(&tpgPtr->tpgBase[globalInterruptEnable], 0));
}

void tpg_set_height(Tpg* tpgPtr, int data)
{
  tpgPtr->tpgBase[activeHeight] = data;
}

int tpg_get_height(Tpg* tpgPtr)
{
  return tpgPtr->tpgBase[activeHeight];
}

void tpg_set_width(Tpg* tpgPtr, int data)
{
  tpgPtr->tpgBase[activeWidth] = data;
}

int tpg_get_width(Tpg* tpgPtr)
{
  return tpgPtr->tpgBase[activeWidth];
}

void tpg_set_background_pattern_id(Tpg* tpgPtr, int data)
{
  tpgPtr->tpgBase[backgroundPatternId] = data;
}

int tpg_get_background_pattern_id(Tpg* tpgPtr)
{
  return tpgPtr->tpgBase[backgroundPatternId];
}

void tpg_set_mask_id(Tpg* tpgPtr, int data)
{
  tpgPtr->tpgBase[maskId] = data;
}

int tpg_get_mask_id(Tpg* tpgPtr)
{
  return tpgPtr->tpgBase[maskId];
}

void tpg_set_motion_speed(Tpg* tpgPtr, int data)
{
  tpgPtr->tpgBase[motionSpeed] = data;
}

int tpg_get_motion_speed(Tpg* tpgPtr)
{
  return tpgPtr->tpgBase[motionSpeed];
}

void tpg_set_color_format(Tpg* tpgPtr, int data)
{
  tpgPtr->tpgBase[colorFormat] = data;
}

int tpg_get_color_format(Tpg* tpgPtr)
{
  return tpgPtr->tpgBase[colorFormat];
}
