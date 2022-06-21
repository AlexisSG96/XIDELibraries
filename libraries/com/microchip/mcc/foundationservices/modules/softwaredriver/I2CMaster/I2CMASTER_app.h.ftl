/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef I2C_MASTER_H
#define	I2C_MASTER_H

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include "${i2cMasterFunctions["typeheader"]}"

// These functions are the I2C API

i2c_error_t ${i2cMasterFunctions["open"]}(i2c_address_t address);
void        ${i2cMasterFunctions["setAddress"]}(i2c_address_t address);
i2c_error_t ${i2cMasterFunctions["close"]}(void);
i2c_error_t ${i2cMasterFunctions["masterOperation"]}(bool read);
i2c_error_t ${i2cMasterFunctions["masterWrite"]}(void); // to be depreciated
i2c_error_t ${i2cMasterFunctions["masterRead"]}(void);  // to be depreciated

void ${i2cMasterFunctions["setTimeOut"]}(uint8_t to);
void ${i2cMasterFunctions["setBuffer"]}(void *buffer, size_t bufferSize);

// Event Callback functions.
void ${i2cMasterFunctions["setDataCompleteCallback"]}(i2c_callback cb, void *p);
void ${i2cMasterFunctions["setWriteCollisionCallback"]}(i2c_callback cb, void *p);
void ${i2cMasterFunctions["setAddressNACKCallback"]}(i2c_callback cb, void *p);
void ${i2cMasterFunctions["setDataNACKCallback"]}(i2c_callback cb, void *p);
void ${i2cMasterFunctions["setTimeOutCallback"]}(i2c_callback cb, void *p);

// Interrupt Stuff : only needed when building the Interrupt driven driver
void ${i2cMasterFunctions["masterISR"]}(void);
void ${i2cMasterFunctions["busCollisionISR"]}(void);

#endif	/* I2C_MASTER_H */

