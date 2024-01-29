#ifndef _I2C_PS_
#define _I2C_PS_

#include "xiicps.h"
#include "xil_types.h"

typedef struct
{
	u8 addr;
	u8 value;
} I2cPsSlaveRegister;

int i2c_ps_master_init(XIicPs* i2c, int deviceId, int clockFrequency);
int i2c_ps_write(XIicPs* i2c, int slaveId, u8 address,u8 data);
int i2c_ps_vector_write(XIicPs* i2c, int slaveId, const I2cPsSlaveRegister* regs);

#endif
