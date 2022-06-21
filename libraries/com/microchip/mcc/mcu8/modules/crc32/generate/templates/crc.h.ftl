/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

#include <stdint.h>
#include <stdbool.h>

/**
  @Summary
    Initializes the ${moduleNameUpperCase}.

  @Description
    This function initializes the ${moduleNameUpperCase} Registers.
    This function must be called before any other ${moduleNameUpperCase} function is called.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment
   
   
  @Example
    <code>
    uint32_t buffer [] = {0x55,0x66,0x77,0x88};
    uint32_t crcVal;
    uint32_t length = sizeof(buffer);
    uint32_t value = 0xff00;

    // Initialize the CRC module
    ${moduleNameUpperCase}_Initialize();

    // Start CRC
    ${moduleNameUpperCase}_StartCrc();

    ${moduleNameUpperCase}_WriteData(value);

    while (${moduleNameUpperCase}_IsCrcBusy());

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
void ${moduleNameUpperCase}_Initialize(void);

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
    uint32_t crcVal;

    // Initialize the CRC module
    ${moduleNameUpperCase}_Initialize();

    // Start CRC
    ${moduleNameUpperCase}_StartCrc();

    // Write data
    ${moduleNameUpperCase}_WriteData(0x55)

    // Check CRC busy?
    while(${moduleNameUpperCase}_IsCrcBusy());

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
inline void ${moduleNameUpperCase}_StartCrc(void);

/**
  @Summary
    Writes data into CRCDATL register pair.

  @Description
    This routine writes data into CRCDATHL register pair.

  @Preconditions
    None.

  @Returns
    1 - if CRC data registers are not full
    0 - if CRC data registers are full

  @Param
    data:  crc input data

  @Example
    <code>
    uint32_t crcVal;

    // Initialize the ${moduleNameUpperCase} module
    ${moduleNameUpperCase}_Initialize();

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartCrc();

    // write 8-bit data
    bool retVal = ${moduleNameUpperCase}_WriteData(0x55);

    // Check CRC busy?
    while(${moduleNameUpperCase}_IsCrcBusy());

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_WriteData(uint32_t data);

/**
  @Summary
   Reads crc check value.

  @Description
    This routine reads and returns the Normal or reverse value.

  @Preconditions
    None.

  @Returns
    None.

  @Param
   reverse: false - Normal value, true - Reverse value
   xorValue: value which xored with CRC.

  @Example
     <code>
    uint32_t crcVal;
    // Initialize the CRC module
    ${moduleNameUpperCase}_Initialize();

    // Start CRC
    ${moduleNameUpperCase}_StartCrc();

    // write 8-bit data
    ${moduleNameUpperCase}_WriteData(0x55)

    // Check CRC busy?
    while(${moduleNameUpperCase}_IsCrcBusy());

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
uint32_t ${moduleNameUpperCase}_GetCalculatedResult(bool reverse, uint32_t xorValue);

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
    uint32_t crcVal;
    // Initialize the CRC module
    ${moduleNameUpperCase}_Initialize();

    // Start CRC
    ${moduleNameUpperCase}_StartCrc();

    // write 8-bit data
    ${moduleNameUpperCase}_WriteData(0x55)

    // Check CRC busy?
    while(${moduleNameUpperCase}_IsCrcBusy());

    // Read calculated CRC
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult();
    </code>
*/
inline bool ${moduleNameUpperCase}_IsCrcBusy(void);

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
     uint32_t crcVal;
    // Initialize the CRC SCAN module
    ${moduleNameUpperCase}_Initialize();

    // Sets SCAN address limit
    ${moduleNameUpperCase}_SetScannerAddressLimit(0x0000,0x07FF);

    // Start Scanner
    ${moduleNameUpperCase}_StartScanner();

    // Scan completed?
    while(${moduleNameUpperCase}_IsCrcBusy() ||  ${moduleNameUpperCase}_IsScannerBusy());

    // Stop Scanner
    ${moduleNameUpperCase}_StopScanner();

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_CalculatedResultGet(false,0x00);
    </code>
*/
inline void ${moduleNameUpperCase}_StartScanner(void);

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
     uint32_t crcVal;
    // Initialize the CRC SCAN module
    CRC_Initialize();

    // Sets SCAN address limit
    ${moduleNameUpperCase}_SetScannerAddressLimit(0x0000,0x07FF);

    // Start Scanner
    ${moduleNameUpperCase}_StartScanner();

    // Scan completed?
    while(${moduleNameUpperCase}_IsCrcBusy() ||  ${moduleNameUpperCase}_IsScannerBusy());

    // Stop Scanner
    ${moduleNameUpperCase}_StopScanner();

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_CalculatedResultGet(false,0x00);
    </code>
*/
inline void ${moduleNameUpperCase}_StopScanner(void);

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
     uint32_t crcVal;
    // Initialize the CRC SCAN module
    ${moduleNameUpperCase}_Initialize();

    // Sets SCAN address limit
    ${moduleNameUpperCase}_SetScannerAddressLimit(0x0000,0x07FF);

    // Start Scanner
    ${moduleNameUpperCase}_StartScanner();

    // Scan completed?
    while(${moduleNameUpperCase}_IsCrcBusy() ||  ${moduleNameUpperCase}_IsScannerBusy());

    // Stop Scanner
    ${moduleNameUpperCase}_StopScanner();

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_CalculatedResultGet(false,0x00);
    </code>
*/
void ${moduleNameUpperCase}_SetScannerAddressLimit(uint24_t startAddr, uint24_t endAddr);

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
     uint32_t crcVal;
    // Initialize the CRC SCAN module
    ${moduleNameUpperCase}_Initialize();

    // Wait if scanner is in progress.
    While(${moduleNameUpperCase}_IsScannerBusy()!=1);

    // Sets SCAN address limit
    ${moduleNameUpperCase}_SetAddressLimit(0x0000,0x07FF);

    // Start Scanner
    ${moduleNameUpperCase}_StartScanner();

    // Scan completed?
    while(${moduleNameUpperCase}_IsCrcBusy() ||  ${moduleNameUpperCase}_IsScannerBusy());

    // Stop Scanner
    ${moduleNameUpperCase}_StopScanner();

    // Read CRC check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
inline bool ${moduleNameUpperCase}_IsScannerBusy(void);

<#if enableCrcInterrupt>
/**
  @Summary
    Check the software buffer is empty.

  @Description
    This routine checks software buffer is empry for not.
  @Preconditions
    None.

  @Returns
    Returns true if software buffer is empty, otherwise returns the value false

  @Param
    data: 32bits  buffer data

  @Example
    <code>
    uint32_t buffer [] = {0x55,0x66,0x77,0x88};
    uint32_t i,crcVal;
    uint32_t length = sizeof(buffer);

    // Initialize the ${moduleNameUpperCase} module
    ${moduleNameUpperCase}_Initialize();

    // Start CRC
    ${moduleNameUpperCase}_StartCrc();

    // Write buffer data
    for(i=0;i<length;i++)
    {
        ${moduleNameUpperCase}_WriteBuffer(buffer[i]);
    }

    // check all data shifted into shifter
     while(${moduleNameUpperCase}_IsCrcBusy() && !${moduleNameUpperCase}_IsBufferEmpty());

    // Read ${moduleNameUpperCase} check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
bool CRC_IsBufferEmpty(void);

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
    uint32_t buffer [] = {0x55,0x66,0x77,0x88};
    uint32_t i,crcVal;
    uint32_t length = sizeof(buffer);

    // Initialize the ${moduleNameUpperCase} module
    ${moduleNameUpperCase}_Initialize();

    // Start CRC
    ${moduleNameUpperCase}_StartCrc();

    // Write buffer data
    for(i=0;i<length;i++)
    {
        ${moduleNameUpperCase}_WriteBuffer(buffer[i]);
    }

    // check all data shifted into shifter
     while(${moduleNameUpperCase}_IsCrcBusy() && !${moduleNameUpperCase}_IsBufferEmpty());

    // Read ${moduleNameUpperCase} check value
    crcVal = ${moduleNameUpperCase}_GetCalculatedResult(false,0x00);
    </code>
*/
bool ${moduleNameUpperCase}_WriteBuffer(uint32_t data);
<#if !isVectoredInterrupt>

/**
  @Summary
    CRC  Interrupt Service Routine

  @Description
    CRC Interrupt Service Routine is called by the Interrupt Manager.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
 */
void ${moduleNameUpperCase}_CrcIsr(void);
</#if>

/**
  @Summary
    Set ${moduleNameUpperCase} Interrupt Handler

  @Description
    This sets the function to be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this.

  @Param
    Address of function to be set

  @Returns
    None
*/
void ${moduleNameUpperCase}_SetCrcInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Default ${moduleNameUpperCase} Interrupt Handler

  @Description
    This is the default Interrupt Handler function

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_DefaultCrcInterruptHandler(void);
</#if>
<#if enableScannerInterrupt>
<#if !isVectoredInterrupt>

/**
  @Summary
    CRC  Interrupt Service Routine

  @Description
    CRC Scanner Interrupt Service Routine is called by the Interrupt Manager.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
 */
void ${moduleNameUpperCase}_ScannerIsr(void);
</#if>

/**
  @Summary
    Set ${moduleNameUpperCase} Scanner Interrupt Handler

  @Description
    This sets the function to be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} Scanner module with interrupt before calling this.

  @Param
    Address of function to be set

  @Returns
    None
*/
void ${moduleNameUpperCase}_SetScannerInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Default ${moduleNameUpperCase} Scanner Interrupt Handler

  @Description
    This is the default Interrupt Handler function

  @Preconditions
    Initialize  the ${moduleNameUpperCase} Scanner module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_DefaultScannerInterruptHandler(void);
</#if>

#endif //${moduleNameUpperCase}_H