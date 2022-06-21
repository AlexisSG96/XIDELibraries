/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.10
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

// Provide C++ compatability
#ifdef	__cplusplus

extern "C" {

#endif

/**
 Section:  Macros definition
 */

#define  NORMAL  0
#define  REVERSE 1

<#if usingCRCInterrupt>
#define  CRC_BUFFER_SIZE 8
#define  CRC_IsBufferEmpty() (crcBufferRemaining == CRC_BUFFER_SIZE)

/**
 Section: Variables declaration
 */

extern volatile uint8_t crcBufferRemaining;

</#if>
/**
  Section: ${moduleNameUpperCase} APIs declaration
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase} module

  @Description
    This routine sets the polynomial and data width; data and seed shift;
    updates the polynomial and shifts the seed value.

    After the routine is called, the ${moduleNameUpperCase} module is ready to calculate the
    ${moduleNameUpperCase} of a data buffer.

    Polynomial:             ${PolynomialValueSetting}
    Polynomial Length - 1:  ${PolynomialLengthSetting}
    Data Length - 1:        ${DataLengthSetting}
    Data Shift:             ${SeedShiftDirectionSetting}
    Seed:                   ${SeedValueSetting}

  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    <code>
    uint16_t buffer [] = {0x55,0x66,0x77,0x88};
    uint16_t crcVal;
    uint16_t length = sizeof(buffer);
    uint16_t value = 0xff00;

    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    CRC_16BitDataWrite(value);

    while (CRC_IsBusy());

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Starts the CRC module

  @Description
    This routine sets the CRCGO bit of the CRCCON0 register to begin the shifting
    process.

    This routine must be called after the initialization of the CRC module.

  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    <code>
    uint16_t crcVal;

    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    // Write data
    CRC_8BitDataWrite(0x55)

    // Check CRC busy?
    while(CRC_IsBusy());

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
void ${moduleNameUpperCase}_Start(void);

<#if usingCRCInterrupt>
<#if isDataWidthGT8>
/**
  @Summary
    Write the data into software buffer.

  @Description
    This routine writes data into software buffer. This routine
    is used when the CRC interrupt is enabled.
    This routine must be called after the initialization of CRC.

  @Preconditions
    None.

  @Returns
    Returns '0' if software buffer is empty, otherwise returns the value '1'

  @Param
    data: 16-bit buffer data

  @Example
    <code>

    uint8_t buffer [] = {0x55,0x66,0x77,0x88};
    uint16_t i,crcVal;
    uint16_t length = sizeof(buffer)/2;

    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    // Write buffer data
    for(i=0;i<length;i++)
    {
        CRC_16BitBufferWrite(uint16_t(buffer[i]));
    }

    // check all data shifted into shifter
     While(!CRC_IsBufferEmpty());

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_16BitBufferWrite(uint16_t data);
<#else>
/**
  @Summary
    Write the data into software buffer.

  @Description
    This routine writes data into software buffer. This routine
    is used when the CRC interrupt is enabled.
    This routine must be called after the initialization of CRC.

  @Preconditions
    None.

  @Returns
    Returns '0' if software buffer is empty, otherwise returns the value '1'

  @Param
    data: 8bit buffer data

  @Example
    <code>
    uint8_t buffer [] = {0x55,0x66,0x77,0x88};
    uint16_t i,crcVal;
    uint16_t length = sizeof(buffer);

    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    // Write buffer data
    for(i=0;i<length;i++)
    {
        CRC_8BitBufferWrite(buffer[i]);
    }

    // check all data shifted into shifter
     While(!CRC_IsBufferEmpty());

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_8BitBufferWrite(uint8_t data);
</#if>
<#else>
<#if isDataWidthGT8>
/**
  @Summary
    Writes data into CRCDATH/L register pair.

  @Description
    This routine writes data into CRCDATH/L register pair.

  @Preconditions
    None.

  @Returns
    1 - if CRC data registers are not full
    0 - if CRC data registers are full

  @Param
    data:  crc input data

  @Example
     <code>
     uint16_t crcVal;

    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    bool retVal = CRC_16BitDataWrite(0x0055)

    // Check CRC busy?
    while(CRC_IsBusy());

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_16BitDataWrite(uint16_t data);
<#else>
/**
  @Summary
    Writes data into CRCDATL register pair.

  @Description
    This routine writes data into CRCDATL register pair.

  @Preconditions
    None.

  @Returns
    1 - if CRC data registers are not full
    0 - if CRC data registers are full

  @Param
    data:  crc input data

  @Example
     <code>
     uint16_t crcVal;

    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    // write 8-bit data
    bool retVal = CRC_8BitDataWrite(0x55)

    // Check CRC busy?
    while(CRC_IsBusy());

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_8BitDataWrite(uint8_t data);
</#if>
</#if>

/**
  @Summary
   Reads crc check value.

  @Description
    This routine reads and returns the normal or reverse value.

  @Preconditions
    None.

  @Returns
    None.

  @Param
   reverse: 0-NORMAL value, 1-REVERSE value
   xorValue: value which xored with CRC.

  @Example
     <code>
     uint8_t crcVal;
    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    // write 8-bit data
    CRC_8BitDataWrite(0x55)

    // Check CRC busy?
    while(CRC_IsBusy());

    // Read CRC check value
    crcVal = (uint8_t)CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
uint16_t ${moduleNameUpperCase}_CalculatedResultGet(bool reverse, uint16_t xorValue);

/**
  @Summary
    Reads the status of BUSY bit of CRCCON0 register.

  @Description
    This routine returns the status of the BUSY bit of CRCCON0 register to check
    CRC calculation is over or not.

  @Preconditions
    None.

  @Returns
    1 - CRC busy.
    0 - CRC not busy.

  @Param
    None.

  @Example
    <code>
    uint8_t crcVal;
    // Initialize the CRC module
    CRC_Initialize();

    // Start CRC
    CRC_Start();

    // write 8-bit data
    CRC_Write8bitData(0x55)

    // Check CRC busy?
    while(CRC_IsBusy());

    // Read calculated CRC
    crcVal = CRC_Read8bitResult();
    </code>
*/
bool ${moduleNameUpperCase}_IsBusy(void);

/**
  @Summary
    Starts the program memory scan

  @Description
    This routine starts the scanning process

  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    <code>
     uint16_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Sets SCAN address limit
    CRC_SCAN_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    CRC_SCAN_StartScanner();

    // Scan completed?
    while(CRC_SCAN_HasScanCompleted());

    // Stop Scanner
    CRC_SCAN_StopScanner();

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
void ${moduleNameUpperCase}_SCAN_StartScanner(void);

/**
  @Summary
    Stops the program memory scan

  @Description
    This routine Stops the scanning process

  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    <code>
     uint16_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Sets SCAN address limit
    CRC_SCAN_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    CRC_SCAN_StartScanner();

    // Scan completed?
    while(CRC_SCAN_HasScanCompleted());

    // Stop Scanner
    CRC_SCAN_StopScanner();

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
void ${moduleNameUpperCase}_SCAN_StopScanner(void);

/**
  @Summary
    Sets the memory address limit for scanning

  @Description
    This routine loads  address limits into the SCANLADRH/L and SCANHADRH/L register pairs.

  @Preconditions
    None.

  @Returns
    None.

  @Param
   startAddr: Starting address of memory block.
   endAddr:   Ending address of memory block.

  @Example
    <code>
     uint16_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Sets SCAN address limit
    CRC_SCAN_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    CRC_SCAN_StartScanner();

    // Scan completed?
    while(CRC_SCAN_HasScanCompleted());

    // Stop Scanner
    CRC_SCAN_StopScanner();

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
<#if isAddress32Bit>
void ${moduleNameUpperCase}_SCAN_SetAddressLimit(uint32_t startAddr, uint32_t endAddr);
<#else>
void ${moduleNameUpperCase}_SCAN_SetAddressLimit(uint16_t startAddr,uint16_t endAddr);
</#if>
<#if isSCANAddressInvalid>

/**
  @Summary
    Returns the status of INVALID bit of SCANCON0 register.

  @Description
    This routine checks the occurrence of invalid address in scanning process.

  @Preconditions
    None.

  @Returns
    1 - invalid address occurred.
    0 - invalid address not occurred.

  @Param
   None.

  @Example
    <code>
     uint16_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Sets SCAN address limit
    CRC_SCAN_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    CRC_SCAN_StartScanner();

    // Scan completed?
    while(!CRC_SCAN_HasScanCompleted())
    {
         if(CRC_SCAN_HasInvalidAddressOccured())
             break;
    }

    // Stop Scanner
    CRC_SCAN_StopScanner();
    </code>
*/
bool ${moduleNameUpperCase}_SCAN_HasInvalidAddressOccured(void);
</#if>

/**
  @Summary
    Returns the status of BUSY bit of SCANCON0 register.

  @Description
    This routine returns the status of BUSY bit of SCANCON0 register.

  @Preconditions
    None.

  @Returns
    0 - SCAN not yet started.
    1- SCAN is in progress.

  @Param
    None.

  @Example
    <code>
     uint16_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Wait if scanner is in progress.
    While(CRC_SCAN_IsScannerBusy()!=1);

    // Sets SCAN address limit
    CRC_SCAN_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    CRC_SCAN_StartScanner();

    // Scan completed?
    while(CRC_SCAN_HasScanCompleted());

    // Stop Scanner
    CRC_SCAN_StopScanner();

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_SCAN_IsScannerBusy(void);
<#if usingSCANInterrupt>
<#else>

/**
  @Summary
    Returns the status of the SCANIF interrupt flag.

  @Description
    This routine returns the status of the SCANIF interrupt flag.

  @Preconditions
    None.

  @Returns
    1 - Scan is complete.
    0 - Scan is not complete.

  @Param
    None.

  @Example
    <code>
     uint16_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Sets SCAN address limit
    CRC_SCAN_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    CRC_SCAN_StartScanner();

    // Scan completed?
    while(CRC_SCAN_HasScanCompleted());

    // Stop Scanner
    CRC_SCAN_StopScanner();

    // Read CRC check value
    crcVal = CRC_CalculatedResultGet(NORMAL,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_SCAN_HasScanCompleted(void);
</#if>

<#if usingCRCInterrupt>
<#if usingCRCVectoredInterrupt>
<#else>
/**
  @Summary
    CRC interrupt service routine.

  @Description
    This routine clears the interrupt flag and write the buffer data into CRCDATH/L
    register pair.

  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    None.
*/
void ${moduleNameUpperCase}_${interruptFunctionNameCRC}(void);
</#if>
</#if>

<#if usingSCANInterrupt>
<#if usingSCANVectoredInterrupt>
<#else>
/**
  @Summary
    SCAN interrupt service routine.

  @Description
   This routine clears the interrupt flag. User can write the code in ISR.

  @Preconditions
    None.

  @Returns
    None.

  @Param
   None.

  @Example
   None.
*/
void ${moduleNameUpperCase}_${interruptFunctionNameSCAN}(void);
</#if>
</#if>
        
#ifdef	__cplusplus
}
#endif

#endif	/* _CRC_H */
