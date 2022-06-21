<#assign settings = pcgConfiguration.configuration.settings>
<#assign data = pcgConfiguration.configuration.data>
<#assign moduleNameLowerCase = data.moduleName?lower_case>
<#assign moduleNameUpperCase = data.moduleName?upper_case>
<#assign version = "2.00">
/**
  ${data.moduleName} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${data.moduleName} driver using ${pcgConfiguration.productName}

  @Description
    This header file provides APIs for driver for ${data.moduleName}.
    Generation Information :
        Product Revision  :  ${pcgConfiguration.productName} - ${pcgConfiguration.productVersion}
        Device            :  ${pcgConfiguration.selectedDevice}
    The generated drivers are tested against the following:
        Compiler          :  ${pcgConfiguration.compiler}
        MPLAB             :  ${pcgConfiguration.tool}
*/

${pcgConfiguration.disclaimer}

#ifndef _${moduleNameUpperCase}_H
#define _${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: ${data.moduleName} Driver Routines
*/
<#list settings.initializers as initializer>
/**
  @Summary
    Initializes the ${data.moduleGroup}

  @Description
    This routine initializes the ${data.moduleGroup} module.
    This routine must be called before any other ${data.moduleGroup} routine 
    is called.
    
  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Comment
    ${initializer.comment}
*/
void ${moduleNameUpperCase}_${initializer.customName}(void);
</#list>

/**
  @Summary
    Read a byte of data from the ${data.moduleName}

  @Description
    This routine reads a byte of data from the ${data.moduleName}.  It will
    block until a byte of data is available.  If you do not wish to block, call 
    the ${moduleNameUpperCase}_IsTxReady() function to check to see if there is
    data available to read first.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function. 

  @Param
    None.

  @Returns
    A data byte received by the driver.
*/
uint8_t ${moduleNameUpperCase}_Read(void);

/**
  @Summary
    Writes a byte of data to the ${data.moduleName}

  @Description
    This routine writes a byte of data to the ${data.moduleName}. This function
    will block if this transmit buffer is currently full until the transmit 
    buffer becomes available.  If you do not wish to block, call the
    ${moduleNameUpperCase}_IsTxReady() function to check on the transmit
    availability.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    before calling this function.

  @Param
    byte - data to be written
*/
void ${moduleNameUpperCase}_Write(uint8_t byte);

/**
  @Description
    Indicates of there is data available to read.

  @Returns
    true if byte can be read.
    false if byte can't be read right now.
*/
bool ${moduleNameUpperCase}_IsRxReady(void);

/**
  @Description
    Indicates if a byte can be written.
 
 @Returns
    true if byte can be written.
    false if byte can't be written right now.
*/
bool ${moduleNameUpperCase}_IsTxReady(void);

/**
  @Description
    Indicates if all bytes have been transferred.
 
 @Returns
    true if all bytes transfered.
    false if there is still data pending to transfer.
*/
bool ${moduleNameUpperCase}_IsTxDone(void);







/*******************************************************************************

  !!! Deprecated API and types !!!
  !!! These functions will not be supported in future releases !!!

*******************************************************************************/

/**
  @Description
    Indicates of there is data available to read.

  @Returns
    true if byte can be read.
    false if byte can't be read right now.
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_rx_ready(void);

/**
  @Description
    Indicates if a byte can be written.
 
 @Returns
    true if byte can be written.
    false if byte can't be written right now.
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_ready(void);

/**
  @Description
    Indicates if all bytes have been transferred.
 
 @Returns
    true if all bytes transfered.
    false if there is still data pending to transfer.
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_done(void);

/** ${data.moduleName} Driver Hardware Flags

  @Summary
    Specifies the status of the hardware receive or transmit

  @Description
    This type specifies the status of the hardware receive or transmit.
    More than one of these values may be OR'd together to create a complete
    status value.  To test a value of this type, the bit of interest must be
    AND'ed with value and checked to see if the result is non-zero.
*/
typedef enum
{
    /* Indicates that Receive buffer has data, at least one more character can be read */
    ${moduleNameUpperCase}_RX_DATA_AVAILABLE = (1 << 0),
    /* Indicates that Receive buffer has overflowed */
    ${moduleNameUpperCase}_RX_OVERRUN_ERROR = (1 << 1),
    /* Indicates that Framing error has been detected for the current character */
    ${moduleNameUpperCase}_FRAMING_ERROR = (1 << 2),
    /* Indicates that Parity error has been detected for the current character */
    ${moduleNameUpperCase}_PARITY_ERROR = (1 << 3),
    /* Indicates that Receiver is Idle */
    ${moduleNameUpperCase}_RECEIVER_IDLE = (1 << 4),
    /* Indicates that the last transmission has completed */
    ${moduleNameUpperCase}_TX_COMPLETE = (1 << 8),
    /* Indicates that Transmit buffer is full */
    ${moduleNameUpperCase}_TX_FULL = (1 << 9) 
}${moduleNameUpperCase}_STATUS;

/**
  @Summary
    Returns the transmitter and receiver status

  @Description
    This returns the transmitter and receiver status. The returned status may 
    contain a value with more than one of the bits
    specified in the ${moduleNameUpperCase}_STATUS enumeration set.  
    The caller should perform an "AND" with the bit of interest and verify if the
    result is non-zero (as shown in the example) to verify the desired status
    bit.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function

  @Param
    None.

  @Returns
    A ${moduleNameUpperCase}_STATUS value describing the current status 
    of the transfer.

  @Example
    <code>
        while(!(${moduleNameUpperCase}_StatusGet & ${moduleNameUpperCase}_TX_COMPLETE ))
        {
           // Wait for the tranmission to complete
        }
    </code>
*/
${moduleNameUpperCase}_STATUS __attribute__((deprecated)) ${moduleNameUpperCase}_StatusGet (void );

/**
  @Summary
    Indicates if data is ready for reading

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called 
    before calling this function

  @Returns
    true - data available to read.
    false - no data available
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_DataReady(void); 

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  // _${moduleNameUpperCase}_H

