<#assign settings = pcgConfiguration.configuration.settings>
<#assign data = pcgConfiguration.configuration.data>
<#assign moduleNameUpperCase = data.moduleName?upper_case>
<#assign moduleNameLowerCase = data.moduleName?lower_case>
<#assign instanceNumber = settings.instanceNumber>
<#assign moduleName = data.moduleName>
<#assign version = 0.5>
<#assign interruptTransmit = data.getInterrupt("UTXI")>
<#if settings.usesInterrupt("UTXI")>
	<#assign transmitInterrupt = settings.getInterrupt("UTXI")>
</#if>
<#assign interruptReceive = data.getInterrupt("URXI")>
<#if settings.usesInterrupt("URXI")>
	<#assign receiveInterrupt = settings.getInterrupt("URXI")>
</#if>
<#assign interruptError = data.getInterrupt("UERI")>
<#if settings.usesInterrupt("UERI")>
	<#assign errorInterrupt = settings.getInterrupt("UERI")>
</#if>
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
    Initializes the ${data.moduleGroup} instance : ${instanceNumber}

  @Description
    This routine initializes the ${data.moduleGroup} driver instance for : ${instanceNumber}
    index.
    This routine must be called before any other ${data.moduleGroup} routine is called.
    
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

<#if transmitInterrupt??>
void ${moduleNameUpperCase}_SetTxInterruptHandler(void* handler);
void ${moduleNameUpperCase}_Transmit_ISR(void);

<#else>
/**
  @Summary
    Maintains the driver's transmitter state machine in a polled manner

  @Description
    This routine is used to maintain the driver's internal transmitter state
    machine.This routine is called when the state of the transmitter needs to be
    maintained in a polled manner.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function in a polled loop.

  @Param
    None.

  @Returns
    None.

  @Example 
    Refer to ${moduleNameUpperCase}_Initialize() for an example
*/
void ${moduleNameUpperCase}_TasksTransmit ( void );

</#if>
<#if receiveInterrupt??>
void ${moduleNameUpperCase}_SetRxInterruptHandler(void* handler);
void ${moduleNameUpperCase}_Receive_ISR(void);

<#else>
/**
  @Summary
    Maintains the driver's receiver state machine in a polled manner.

  @Description
    This routine is used to maintain the driver's internal receiver state
    machine. This routine is called when the state of the receiver needs to be
    maintained in a polled manner.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function in a polled loop.

  @Param
    None.

  @Returns
    None.

  @Example 
    <code>
    uint8_t readBuffer[35];
    unsigned int size, numBytes = 0;
    unsigned int readbufferLen = sizeof(readBuffer);
    ${moduleNameUpperCase}__Initialize();
    
    while(numBytes < readbufferLen)        
    {   
        while(!${moduleNameUpperCase}_ReceiveBufferIsEmpty());
        numBytes += ${moduleNameUpperCase}_ReadBuffer ( readBuffer + numBytes , readbufferLen ) ;
        ${moduleNameUpperCase}_TasksReceive ( );
        status = ${moduleNameUpperCase}_TransferStatusGet ( ) ;
        if (status & ${moduleNameUpperCase}_TRANSFER_STATUS_RX_FULL)
        {
            //continue other operation
        }
    }
    </code>
*/
void ${moduleNameUpperCase}_TasksReceive ( void );

</#if>
<#if !errorInterrupt?? >
/**
  @Summary
    Maintains the driver's error-handling state machine in a polled manner.

  @Description
    This routine is used to maintain the driver's internal error-handling state
    machine.This routine is called when the state of the errors needs to be
    maintained in a polled manner.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function in a polled loop.

  @Param
    None.

  @Returns
    None.

  @Example
    <code>
    while (true)
    {
        ${moduleNameUpperCase}_TasksError ();

        // Do other tasks
    }
    </code>
*/
void ${moduleNameUpperCase}_TasksError ( void );

</#if>






/*******************************************************************************

  !!! Deprecated API and types !!!
  !!! These functions will not be supported in future releases !!!

*******************************************************************************/

/**
  @Summary
    Returns the size of the receive buffer

  @Description
    This routine returns the size of the receive buffer.

  @Param
    None.

  @Returns
    Size of receive buffer.
    
  @Example 
    <code>
    uint8_t readBuffer[5];
    uint8_t size, numBytes = 0;
    unsigned int readbufferLen = sizeof(readBuffer);
    ${moduleNameUpperCase}__Initialize();
    
    while(size < readbufferLen)
	{
	    ${moduleNameUpperCase}_TasksReceive ( );
	    size = ${moduleNameUpperCase}_is_rx_ready();
	}
    numBytes = ${moduleNameUpperCase}_ReadBuffer ( readBuffer , readbufferLen ) ;
    </code>
 
*/
uint8_t __attribute__((deprecated)) ${moduleNameUpperCase}_is_rx_ready(void);

/**
  @Summary
    Returns the size of the transmit buffer

  @Description
    This routine returns the size of the transmit buffer.

 @Param
    None.
 
 @Returns
    Size of transmit buffer.

 @Example
    Refer to ${moduleNameUpperCase}_Initialize(); for example.
*/
uint8_t __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_ready(void);

/**
  @Summary
    Returns the status of the TRMT bit

  @Description
    This routine returns if the transmit shift register is full or not.

 @Param
    None.
 
 @Returns
    True if the transmit TXREG is empty
    False if the transmit is in progress

 @Example
 
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_done(void);

/** ${data.moduleName} Driver Transfer Flags

  @Summary
    Specifies the status of the receive or transmit

  @Description
    This type specifies the status of the receive or transmit operation.
    More than one of these values may be OR'd together to create a complete
    status value.  To test a value of this type, the bit of interest must be
    AND'ed with value and checked to see if the result is non-zero.
*/

typedef enum
{
    /* Indicates that the core driver buffer is full */
    ${moduleNameUpperCase}_TRANSFER_STATUS_RX_FULL = (1 << 0) ,
    /* Indicates that at least one byte of Data has been received */
    ${moduleNameUpperCase}_TRANSFER_STATUS_RX_DATA_PRESENT = (1 << 1) ,
    /* Indicates that the core driver receiver buffer is empty */
    ${moduleNameUpperCase}_TRANSFER_STATUS_RX_EMPTY = (1 << 2) ,
    /* Indicates that the core driver transmitter buffer is full */
    ${moduleNameUpperCase}_TRANSFER_STATUS_TX_FULL = (1 << 3) ,
    /* Indicates that the core driver transmitter buffer is empty */
    ${moduleNameUpperCase}_TRANSFER_STATUS_TX_EMPTY = (1 << 4) 
} ${moduleNameUpperCase}_TRANSFER_STATUS;

/**
  @Summary
    Returns the number of bytes read by the ${data.moduleName} peripheral

  @Description
    This routine returns the number of bytes read by the Peripheral and fills the
    application read buffer with the read data.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function

  @Param
    buffer       - Buffer into which the data read from the ${data.moduleName}

  @Param
    numbytes     - Total number of bytes that need to be read from the ${data.moduleName}
                   (must be equal to or less than the size of the buffer)

  @Returns
    Number of bytes actually copied into the caller's buffer or -1 if there
    is an error.

  @Example
    <code>
    char                     myBuffer[MY_BUFFER_SIZE];
    unsigned int             numBytes;
    ${moduleNameUpperCase}_TRANSFER_STATUS status ;

    // Pre-initialize myBuffer with MY_BUFFER_SIZE bytes of valid data.

    numBytes = 0;
    while( numBytes < MY_BUFFER_SIZE);
    {
        status = ${moduleNameUpperCase}_TransferStatusGet ( ) ;
        if (status & ${moduleNameUpperCase}_TRANSFER_STATUS_RX_FULL)
        {
            numBytes += ${moduleNameUpperCase}_ReadBuffer( myBuffer + numBytes, MY_BUFFER_SIZE - numBytes )  ;
            if(numBytes < readbufferLen)
            {
                continue;
            }
            else
            {
                break;
            }
        }
        else
        {
            continue;
        }

        // Do something else...
    }
    </code>
*/
unsigned int __attribute__((deprecated)) ${moduleNameUpperCase}_ReadBuffer( uint8_t *buffer ,  unsigned int numbytes);

/**
  @Summary
    Returns the number of bytes written into the internal buffer

  @Description
    This API transfers the data from application buffer to internal buffer and 
    returns the number of bytes added in that queue

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function

  @Example
    <code>
    char                     myBuffer[MY_BUFFER_SIZE];
    unsigned int             numBytes;
    ${moduleNameUpperCase}_TRANSFER_STATUS status ;

    // Pre-initialize myBuffer with MY_BUFFER_SIZE bytes of valid data.

    numBytes = 0;
    while( numBytes < MY_BUFFER_SIZE);
    {
        status = ${moduleNameUpperCase}_TransferStatusGet ( ) ;
        if (status & ${moduleNameUpperCase}_TRANSFER_STATUS_TX_EMPTY)
        {
            numBytes += ${moduleNameUpperCase}_WriteBuffer ( myBuffer + numBytes, MY_BUFFER_SIZE - numBytes )  ;
            if(numBytes < writebufferLen)
            {
                continue;
            }
            else
            {
                break;
            }
        }
        else
        {
            continue;
        }

        // Do something else...
    }
    </code>
*/
unsigned int __attribute__((deprecated)) ${moduleNameUpperCase}_WriteBuffer( uint8_t *buffer , unsigned int numbytes );

/**
  @Summary
    Returns the transmitter and receiver transfer status

  @Description
    This returns the transmitter and receiver transfer status.The returned status 
    may contain a value with more than one of the bits
    specified in the ${moduleNameUpperCase}_TRANSFER_STATUS enumeration set.  
    The caller should perform an "AND" with the bit of interest and verify if the
    result is non-zero (as shown in the example) to verify the desired status
    bit.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should have been called 
    before calling this function

  @Param
    None.

  @Returns
    A ${moduleNameUpperCase}_TRANSFER_STATUS value describing the current status 
    of the transfer.

  @Example
    Refer to ${moduleNameUpperCase}_ReadBuffer and ${moduleNameUpperCase}_WriteBuffer for example

*/
${moduleNameUpperCase}_TRANSFER_STATUS __attribute__((deprecated)) ${moduleNameUpperCase}_TransferStatusGet (void );

/**
  @Summary
    Returns the character in the read sequence at the offset provided, without
    extracting it

  @Description
    This routine returns the character in the read sequence at the offset provided,
    without extracting it
 
  @Param
    None.
    
  @Example 
    <code>
    uint8_t readBuffer[5];
    unsigned int data, numBytes = 0;
    unsigned int readbufferLen = sizeof(readBuffer);
    ${moduleNameUpperCase}_Initialize();
    
    while(numBytes < readbufferLen)        
    {   
        ${moduleNameUpperCase}_TasksReceive ( );
        //Check for data at a particular place in the buffer
        data = ${moduleNameUpperCase}_Peek(3);
        if(data == 5)
        {
            //discard all other data if byte that is wanted is received.    
            //continue other operation
            numBytes += ${moduleNameUpperCase}_ReadBuffer ( readBuffer + numBytes , readbufferLen ) ;
        }
        else
        {
            break;
        }
    }
    </code>
 
*/
uint8_t __attribute__((deprecated)) ${moduleNameUpperCase}_Peek(uint16_t offset);

/**
  @Summary
    Returns the status of the receive buffer

  @Description
    This routine returns if the receive buffer is empty or not.

  @Param
    None.
 
  @Returns
    True if the receive buffer is empty
    False if the receive buffer is not empty
    
  @Example
    <code>
    char                     myBuffer[MY_BUFFER_SIZE];
    unsigned int             numBytes;
    ${moduleNameUpperCase}_TRANSFER_STATUS status ;

    // Pre-initialize myBuffer with MY_BUFFER_SIZE bytes of valid data.

    numBytes = 0;
    while( numBytes < MY_BUFFER_SIZE);
    {
        status = ${moduleNameUpperCase}_TransferStatusGet ( ) ;
        if (!${moduleNameUpperCase}_ReceiveBufferIsEmpty())
        {
            numBytes += ${moduleNameUpperCase}_ReadBuffer( myBuffer + numBytes, MY_BUFFER_SIZE - numBytes )  ;
            if(numBytes < readbufferLen)
            {
                continue;
            }
            else
            {
                break;
            }
        }
        else
        {
            continue;
        }

        // Do something else...
    }
    </code>
 
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_ReceiveBufferIsEmpty (void);

/**
  @Summary
    Returns the status of the transmit buffer

  @Description
    This routine returns if the transmit buffer is full or not.

 @Param
    None.
 
 @Returns
    True if the transmit buffer is full
    False if the transmit buffer is not full

 @Example
    Refer to ${moduleNameUpperCase}_Initialize() for example.
 
*/
bool __attribute__((deprecated)) ${moduleNameUpperCase}_TransmitBufferIsFull (void);

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


#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
    
#endif  // _${moduleNameUpperCase}_H

