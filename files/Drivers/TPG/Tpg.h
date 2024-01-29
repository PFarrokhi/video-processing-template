#ifndef _TPG_
#define _TPG_

#include <stdbool.h>
#include "Gpio.h"

typedef struct
{
  volatile int* tpgBase;
  bool haveExternalReset;
  Gpio* externalReset;
  int externalResetChannel;
  int externalResetPin;
} Tpg;

enum TpgBackgrounds
{
  tpgBackgroundsHorizantalRamp = 1,
  tpgBackgroundsVerticalRamp,
  tpgBackgroundsTemporalRamp,
  tpgBackgroundsSolidRed,
  tpgBackgroundsSolidGreen,
  tpgBackgroundsSolidBlue,
  tpgBackgroundsSolidBlack,
  tpgBackgroundsSolidWhite,
  tpgBackgroundsColorBars,
  tpgBackgroundsCheckerBoard = 15,
};

enum TpgColorMasks
{
  tpgColorMasksNoMask,
  tpgColorMasksRedMask,
  tpgColorMasksGreenMask,
  tpgColorMasksBlueMask
};

enum TpgColorFormat
{
  tpgColorFormatRGB,
  tpgColorFormatYUV444,
  tpgColorFormatYUV422,
  tpgColorFormatYUV420
};

void tpg_init(Tpg* tpgPtr, volatile int* tpgBase);
void tpg_set_reset(Tpg* tpgPtr, Gpio* externalReset, int externalResetChannel, int externalResetPin);
void tpg_remove_reset(Tpg* tpgPtr);
void tpg_reset(Tpg* tpgPtr);
void tpg_start(Tpg* tpgPtr);
void tpg_stop(Tpg* tpgPtr);
bool tpg_is_done(Tpg* tpgPtr);
bool tpg_is_idle(Tpg* tpgPtr);
bool tpg_is_ready(Tpg* tpgPtr);
void tpg_autorestart_enable(Tpg* tpgPtr);
void tpg_autorestart_disable(Tpg* tpgPtr);
void tpg_global_interrupt_enable(Tpg* tpgPtr);
void tpg_global_interrupt_disable(Tpg* tpgPtr);
bool tpg_global_interrupt_is_enable(Tpg* tpgPtr);
void tpg_set_height(Tpg* tpgPtr, int data);
int tpg_get_height(Tpg* tpgPtr);
void tpg_set_width(Tpg* tpgPtr, int data);
int tpg_get_width(Tpg* tpgPtr);
void tpg_set_background_pattern_id(Tpg* tpgPtr, int data);
int tpg_get_background_pattern_id(Tpg* tpgPtr);
void tpg_set_mask_id(Tpg* tpgPtr, int data);
int tpg_get_mask_id(Tpg* tpgPtr);
void tpg_set_motion_speed(Tpg* tpgPtr, int data);
int tpg_get_motion_speed(Tpg* tpgPtr);
void tpg_set_color_format(Tpg* tpgPtr, int data);
int tpg_get_color_format(Tpg* tpgPtr);

#endif
