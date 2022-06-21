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
        Driver Version    :  2.1.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdbool.h>
#include <stdint.h>
<#if useStdio>
#include <stdio.h>
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif


/**
  Section: Macro Declarations
*/

#define ${moduleNameUpperCase}_DataReady  (${functionAPI["DataReady"]}())

/**
  Section: Data Type Definitions
*/

typedef union {
    struct {
        unsigned perr : 1;
        unsigned ferr : 1;
        unsigned oerr : 1;
        unsigned reserved : 5;
    };
    uint8_t status;
}${moduleNameLowerCase}_status_t;

<#if usesInterrupt>
/**
 Section: Global variables
 */
extern volatile uint8_t ${moduleNameLowerCase}TxBufferRemaining;
extern volatile uint8_t ${moduleNameLowerCase}RxCount;
</#if>

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#if usesInterruptTXI>
void (*${moduleNameUpperCase}_${defaultInterruptTransmitHandlerFunctionName})(void);
</#if>
<#if usesInterruptRCI>
void (*${moduleNameUpperCase}_${defaultInterruptReceiveHandlerFunctionName})(void);
</#if>

<#list initializers as initializer>
/**
  @Summary
    Initialization routine that takes inputs from the ${moduleNameUpperCase} GUI.

  @Description
    This routine initializes the ${moduleNameUpperCase} driver.
    This routine must be called before any other ${moduleNameUpperCase} routine is called.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment
    
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Checks if the ${moduleNameUpperCase} transmitter is ready to transmit data

  @Description
    This routine checks if ${moduleNameUpperCase} transmitter is ready 
    to accept and transmit data byte

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    before calling this function.
    ${moduleNameUpperCase} transmitter should be enabled before calling 
    this function

  @Param
    None

  @Returns
    Status of ${moduleNameUpperCase} transmitter
    TRUE: ${moduleNameUpperCase} transmitter is ready
    FALSE: ${moduleNameUpperCase} transmitter is not ready
    
  @Example
    <code>
    void main(void)
    {
        volatile uint8_t rxData;
        
        // Initialize the device
        SYSTEM_Initialize();
        
        while(1)
        {
            // Logic to echo received data
            if(${functionAPI["DataReady"]}())
            {
                rxData = UART1_Read();
                if(${functionAPI["TransmitReady"]}())
                {
                    ${moduleNameUpperCase}Write(rxData);
                }
            }
        }
    }
    </code>
*/
bool ${functionAPI["TransmitReady"]}(void);

/**
  @Summary
    Checks if the ${moduleNameUpperCase} receiver ready for reading

  @Description
    This routine checks if ${moduleNameUpperCase} receiver has received data 
    and ready to be read

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should be called
    before calling this function
    ${moduleNameUpperCase} receiver should be enabled before calling this 
    function

  @Param
    None

  @Returns
    Status of ${moduleNameUpperCase} receiver
    TRUE: ${moduleNameUpperCase} receiver is ready for reading
    FALSE: ${moduleNameUpperCase} receiver is not ready for reading
    
  @Example
    <code>
    void main(void)
    {
        volatile uint8_t rxData;
        
        // Initialize the device
        SYSTEM_Initialize();
        
        while(1)
        {
            // Logic to echo received data
            if(${functionAPI["DataReady"]}())
            {
                rxData = UART1_Read();
                if(${functionAPI["TransmitReady"]}())
                {
                    ${functionAPI["Write"]}(rxData);
                }
            }
        }
    }
    </code>
*/
bool ${functionAPI["DataReady"]}(void);

/**
  @Summary
    Checks if ${moduleNameUpperCase} data is transmitted

  @Description
    This function return the status of transmit shift register

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should be called
    before calling this function
    ${moduleNameUpperCase} transmitter should be enabled and ${functionAPI["Write"]}
    should be called before calling this function

  @Param
    None

  @Returns
    Status of ${moduleNameUpperCase} receiver
    TRUE: Data completely shifted out if the USART shift register
    FALSE: Data is not completely shifted out of the shift register
    
  @Example
    <code>
    void main(void)
    {
        volatile uint8_t rxData;
        
        // Initialize the device
        SYSTEM_Initialize();
        
        while(1)
        {
            if(${functionAPI["TransmitReady"]}())
            {
				LED_0_SetHigh();
                ${moduleNameUpperCase}Write(rxData);
            }
			if(${functionAPI["TransmitDone"]}()
            {
                LED_0_SetLow();
            }
        }
    }
    </code>
*/
bool ${functionAPI["TransmitDone"]}(void);

/**
  @Summary
    Gets the error status of the last read byte.

  @Description
    This routine gets the error status of the last read byte.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    before calling this function. The returned value is only
    updated after a read is called.

  @Param
    None

  @Returns
    the status of the last read byte

  @Example
	<code>
    void main(void)
    {
        volatile uint8_t rxData;
        volatile ${moduleNameLowerCase}_status_t rxStatus;
        
        // Initialize the device
        SYSTEM_Initialize();
        
        // Enable the Global Interrupts
        INTERRUPT_GlobalInterruptEnable();
        
        while(1)
        {
            // Logic to echo received data
            if(${functionAPI["DataReady"]}())
            {
                rxData = ${functionAPI["Read"]}();
                rxStatus = ${functionAPI["getLastStatus"]}();
                if(rxStatus.ferr){
                    LED_0_SetHigh();
                }
            }
        }
    }
    </code>
 */
${moduleNameLowerCase}_status_t ${functionAPI["getLastStatus"]}(void);

/**
  @Summary
    Read a byte of data from the ${moduleNameUpperCase}.

  @Description
    This routine reads a byte of data from the ${moduleNameUpperCase}.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    before calling this function. The transfer status should be checked to see
    if the receiver is not empty before calling this function.

  @Param
    None

  @Returns
    A data byte received by the driver.
*/
uint8_t ${functionAPI["Read"]}(void);

 /**
  @Summary
    Writes a byte of data to the ${moduleNameUpperCase}.

  @Description
    This routine writes a byte of data to the ${moduleNameUpperCase}.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    before calling this function. The transfer status should be checked to see
    if transmitter is not busy before calling this function.

  @Param
    txData  - Data byte to write to the ${moduleNameUpperCase}

  @Returns
    None
*/
void ${functionAPI["Write"]}(uint8_t txData);

<#if usesInterruptTXI>
/**
  @Summary
    Maintains the driver's transmitter state machine and implements its ISR.

  @Description
    This routine is used to maintain the driver's internal transmitter state
    machine.This interrupt service routine is called when the state of the
    transmitter needs to be maintained in a non polled manner.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    for the ISR to execute correctly.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_${interruptTransmitFunctionName}(void);
</#if>

<#if usesInterruptRCI>
/**
  @Summary
    Maintains the driver's receiver state machine and implements its ISR

  @Description
    This routine is used to maintain the driver's internal receiver state
    machine.This interrupt service routine is called when the state of the
    receiver needs to be maintained in a non polled manner.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    for the ISR to execute correctly.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_${interruptReceiveFunctionName}(void);

/**
  @Summary
    Maintains the driver's receiver state machine

  @Description
    This routine is called by the receive state routine and is used to maintain 
    the driver's internal receiver state machine. It should be called by a custom
    ISR to maintain normal behavior

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    for the ISR to execute correctly.

  @Param
    None

  @Returns
    None
*/
void ${functionAPI["rxDataHandler"]}(void);
</#if>

/**
  @Summary
    Set ${moduleNameUpperCase} Framing Error Handler

  @Description
    This API sets the function to be called upon ${moduleNameUpperCase} framing error

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this API

  @Param
    Address of function to be set as framing error handler

  @Returns
    None
*/
void ${functionAPI["setFramingErrorHandler"]}(void (* interruptHandler)(void));

/**
  @Summary
    Set ${moduleNameUpperCase} Overrun Error Handler

  @Description
    This API sets the function to be called upon ${moduleNameUpperCase} overrun error

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module before calling this API

  @Param
    Address of function to be set as overrun error handler

  @Returns
    None
*/
void ${functionAPI["setOverrunErrorHandler"]}(void (* interruptHandler)(void));

/**
  @Summary
    Set ${moduleNameUpperCase} Error Handler

  @Description
    This API sets the function to be called upon ${moduleNameUpperCase} error

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module before calling this API

  @Param
    Address of function to be set as error handler

  @Returns
    None
*/
void ${functionAPI["setErrorHandler"]}(void (* interruptHandler)(void));

<#if usesInterruptTXI>
/**
  @Summary
    Sets the transmit handler function to be called by the interrupt service

  @Description
    Calling this function will set a new custom function that will be 
    called when the transmit interrupt needs servicing.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    for the ISR to execute correctly.

  @Param
    A pointer to the new function

  @Returns
    None
*/
void ${moduleNameUpperCase}_SetTxInterruptHandler(void (* interruptHandler)(void));
</#if>

<#if usesInterruptRCI>
/**
  @Summary
    Sets the receive handler function to be called by the interrupt service

  @Description
    Calling this function will set a new custom function that will be 
    called when the receive interrupt needs servicing.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
    for the ISR to execute correctly.

  @Param
    A pointer to the new function

  @Returns
    None
*/
void ${moduleNameUpperCase}_SetRxInterruptHandler(void (* interruptHandler)(void));
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  // ${moduleNameUpperCase}_H
/**
 End of File
*/
