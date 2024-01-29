#include "i2c_ps.h"
#include "xparameters.h"
#include "sleep.h"
#include "xstatus.h"
#include "xil_printf.h"

int i2c_ps_master_init(XIicPs* i2c, int deviceId, int clockFrequency)
{
	int status;
	XIicPs_Config *configPtr;	/* Pointer to configuration data */

	configPtr = XIicPs_LookupConfig(deviceId);
	if (configPtr == NULL) {
		xil_printf("i2c device not found\r\n");
		return XST_FAILURE;
	}

	status = XIicPs_CfgInitialize(i2c, configPtr, configPtr->BaseAddress);
	if (status != XST_SUCCESS) {
		xil_printf("i2c device not config\r\n");
		return XST_FAILURE;
	}

	XIicPs_SetSClk(i2c, clockFrequency);

	return XST_SUCCESS;
}

int i2c_ps_write(XIicPs* i2c, int slaveId, u8 address, u8 data)
{
	int status;
	u8 writeBuffer[1 + 1];
	u8 readBuffer[1];


	writeBuffer[0] = address;
	writeBuffer[1] = data;

	status = XIicPs_MasterSendPolled(i2c, writeBuffer, 2, slaveId);
	if (status != XST_SUCCESS) {
		xil_printf("failed in 3phase write with error %d\r\n", status);
		return XST_FAILURE;
	}

	while (XIicPs_BusIsBusy(i2c));

	usleep(2500);

	writeBuffer[0] = address;

	status = XIicPs_MasterSendPolled(i2c, writeBuffer, 1, slaveId);
	if (status != XST_SUCCESS) {
		xil_printf("failed in 2phase write with error %d\r\n", status);
		return XST_FAILURE;
	}

	while (XIicPs_BusIsBusy(i2c));

	usleep(2500);

	status = XIicPs_MasterRecvPolled(i2c, readBuffer, 1, slaveId);
	if (status != XST_SUCCESS) {
		xil_printf("failed in 2phase read with error %d\r\n", status);
		return XST_FAILURE;
	}
	while (XIicPs_BusIsBusy(i2c));

	//xil_printf("0x%02x=0x%02x\r\n",a,readBuffer[0]);

	return 0;
}

int i2c_ps_vector_write(XIicPs* i2c, int slaveId, const I2cPsSlaveRegister* regs)
{
	int status;

	for(int i = 0; regs[i].addr!=0xff; i++)
	{
		status = i2c_ps_write(i2c, slaveId, regs[i].addr,regs[i].value);
		if(status != XST_SUCCESS)
		{
			xil_printf("couldn't write to i2c with address 0x%x, data 0x%x\r\n", regs[i].addr, regs[i].value);
			return XST_FAILURE;
		}
	}

	return 0;
}
