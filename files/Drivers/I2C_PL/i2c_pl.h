#ifndef _I2C_PL_
#define _I2C_PL_

#include "xiic.h"
#include "xil_types.h"

volatile u8 TransmitComplete;	/* Flag to check completion of Transmission */
volatile u8 ReceiveComplete;	/* Flag to check completion of Reception */

typedef struct
{
	u8 addr;
	u8 value;
} I2cPlSlaveRegister;

int i2c_pl_master_init(XIic* i2c, int deviceId, int clockFrequency);
int i2c_pl_write(XIic* i2c, int slaveId, u8 address,u8 data);
int i2c_pl_vector_write(XIic* i2c, int slaveId, const I2cPlSlaveRegister* regs);

#endif
