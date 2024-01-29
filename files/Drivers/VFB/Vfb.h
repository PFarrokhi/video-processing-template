#ifndef _Vfb_
#define _Vfb_

#include <stdbool.h>
#include "Gpio.h"

typedef struct
{
    volatile int* vfbBase;
    bool haveExternalReset;
    Gpio* externalReset;
    int externalResetChannel;
    int externalResetPin;
} Vfb;

enum VfbVideoFormat
{
    vfbVideoFormatRGBX8 = 10,
    vfbVideoFormatYUVX8,
    vfbVideoFormatYUYV8,
    vfbVideoFormatRGBX10 = 15,
    vfbVideoFormatYUVX10,
    vfbVideoFormatY_UV8,
    vfbVideoFormatY_UV8_420 = 19,
    vfbVideoFormatRGB8,
    vfbVideoFormatYUV8,
    vfbVideoFormatY_UV10,
    vfbVideoFormatY_UV10_420,
    vfbVideoFormatY8,
    vfbVideoFormatY10
};

void vfb_init(Vfb* vfbPtr, volatile int* vfbBase);
void vfb_set_reset(Vfb* vfbPtr, Gpio* externalReset, int externalResetChannel, int externalResetPin);
void vfb_remove_reset(Vfb* vfbPtr);
void vfb_reset(Vfb* vfbPtr);
void vfb_start(Vfb* vfbPtr);
void vfb_stop(Vfb* vfbPtr);
bool vfb_is_done(Vfb* vfbPtr);
bool vfb_is_idle(Vfb* vfbPtr);
bool vfb_is_ready(Vfb* vfbPtr);
void vfb_autorestart_enable(Vfb* vfbPtr);
void vfb_autorestart_disable(Vfb* vfbPtr);
void vfb_global_interrupt_enable(Vfb* vfbPtr);
void vfb_global_interrupt_disable(Vfb* vfbPtr);
bool vfb_global_interrupt_is_enable(Vfb* vfbPtr);
void vfb_set_width(Vfb* vfbPtr, int data);
int vfb_get_width(Vfb* vfbPtr);
void vfb_set_height(Vfb* vfbPtr, int data);
int vfb_get_height(Vfb* vfbPtr);
void vfb_set_stride(Vfb* vfbPtr, int data);
int vfb_get_stride(Vfb* vfbPtr);
void vfb_set_video_format(Vfb* vfbPtr, int data);
int vfb_get_video_format(Vfb* vfbPtr);
void vfb_set_video_address(Vfb* vfbPtr, int data);
int vfb_get_video_address(Vfb* vfbPtr);

#endif
