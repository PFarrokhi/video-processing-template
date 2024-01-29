#include "sii9022_init.h"
#include "xstatus.h"
#include "xil_io.h"
#include "sleep.h"

#define DEVICE_ID 0x3b

static const I2cPlSlaveRegister sii9022_init_regs[] = {

	{0x1e, 0x00}, /* Power up */
	{0x08, 0x70}, /* input bus/pixel: full pixel wide (24bit), rising edge */

	{0x09, 0x00}, /* Set input format to RGB */
	{0x0a, 0x00}, /* Set output format to RGB */

	{0x60, 0x04},
	{0x3c, 0x01},

	{0x1a, 0x11},

	/* set mode */

	/* set input clock frequency * 100 in MHz */
	{0x00, 0xd8}, /* set input clock frequency LSB */
	{0x01, 0x09}, /* set input clock frequency MSB */

	/* set input frame rate * 100 in fps */
	{0x02, 0x70}, /* set input frame rate LSB */
	{0x03, 0x17}, /* set input frame rate MSB */

	/* set horizontal frame size */
	{0x04, 0x20}, /* set horizontal frame size LSB */
	{0x05, 0x03}, /* set horizontal frame size MSB */

	/* set vertical frame size */
	{0x06, 0x0d}, /* set vertical frame size LSB */
	{0x07, 0x02}, /* set vertical frame size MSB */

	{0x08, 0x70}, /* input bus/pixel: full pixel wide (24bit), rising edge */
	{0x1a, 0x01},

	{0xff, 0xff}, /*over */
};


int sii9022_init(XIic* i2c)
{
	/* ------------------------------------------------------------ */
	/*					sii9022 hardware reset   					*/
	/* ------------------------------------------------------------ */
	Xil_Out32(0xE000A000 + 0x244,0x00080000);
	Xil_Out32(0xE000A000 + 0x248,0x00080000);
	Xil_Out32(0xE000A000 + 0xC,0xFFF70008);
	usleep(2500);

	int status;

	status = i2c_pl_write(i2c, DEVICE_ID, 0xc7,0x00);//software reset
	if(status != XST_SUCCESS)
	{
		xil_printf("couldn't reset hdmi\r\n");
		return XST_FAILURE;
	}

	status = i2c_pl_vector_write(i2c, DEVICE_ID, sii9022_init_regs);
	if(status != XST_SUCCESS)
	{
		xil_printf("couldn't config hdmi\r\n");
		return XST_FAILURE;
	}

	return 0;
}
