#include "i2c_pl.h"
#include "xparameters.h"
#include "sleep.h"
#include "xstatus.h"
#include "xil_printf.h"

int i2c_pl_master_init(XIic* i2c, int device_id, int clockFrequency)
{
	int status;
	XIic_Config *configPtr;

	/*
	 * Initialize the IIC driver so that it is ready to use.
	 */
	configPtr = XIic_LookupConfig(device_id);
	if (configPtr == NULL) {
		return XST_FAILURE;
	}

	status = XIic_CfgInitialize(i2c, configPtr, configPtr->BaseAddress);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	return XST_SUCCESS;
}

int i2c_pl_write(XIic* i2c, int slaveId, u8 address, u8 data)
{
	int status;
	u8 writeBuffer[1 + 1];
	u8 readBuffer[1];

	status = XIic_SetAddress(i2c, XII_ADDR_TO_SEND_TYPE, slaveId);
	if (status != XST_SUCCESS) {
		xil_printf("couldn't set address\r\n", status);
		return XST_FAILURE;
	}

	status = XIic_Start(i2c);
	if (status != XST_SUCCESS) {
		xil_printf("couldn't start1\r\n", status);
		return XST_FAILURE;
	}

	writeBuffer[0] = address;
	writeBuffer[1] = data;

	TransmitComplete = 1;
	i2c->Stats.TxErrors = 0;

	/*
	 * Start the IIC device.
	 */
	status = XIic_Start(i2c);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Send the Data.
	 */
	status = XIic_MasterSend(i2c, writeBuffer, 2);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the transmission is completed.
	 */
	while ((TransmitComplete) || (XIic_IsIicBusy(i2c) == TRUE)) {
		/*
		 * This condition is required to be checked in the case where we
		 * are writing two consecutive buffers of data to the EEPROM.
		 * The EEPROM takes about 2 milliseconds time to update the data
		 * internally after a STOP has been sent on the bus.
		 * A NACK will be generated in the case of a second write before
		 * the EEPROM updates the data internally resulting in a
		 * Transmission Error.
		 */
//		xil_printf("retry! %d\r\n", TransmitComplete);
		if (i2c->Stats.TxErrors != 0) {


			/*
			 * Enable the IIC device.
			 */
			status = XIic_Start(i2c);
			if (status != XST_SUCCESS) {
				return XST_FAILURE;
			}


			if (!XIic_IsIicBusy(i2c)) {
				/*
				 * Send the Data.
				 */
				status = XIic_MasterSend(i2c, writeBuffer, 2);
				if (status == XST_SUCCESS) {
					i2c->Stats.TxErrors = 0;
				}
				else {
				}
			}
		}
	}

	/*
	 * Stop the IIC device.
	 */
	status = XIic_Stop(i2c);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int i2c_pl_vector_write(XIic* i2c, int slaveId, const I2cPlSlaveRegister* regs)
{
	int status;

	for(int i = 0; regs[i].addr!=0xff; i++)
	{
		status = i2c_pl_write(i2c, slaveId, regs[i].addr,regs[i].value);
		if(status != XST_SUCCESS)
		{
			xil_printf("couldn't write to i2c with address 0x%x, data 0x%x\r\n", regs[i].addr, regs[i].value);
			return XST_FAILURE;
		}
	}

	return 0;
}
