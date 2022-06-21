/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.1.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>
#include "can_types.h"

<#if txFifoList?has_content>
// Transmit FIFO's Custom Name
<#list txFifoList as fifo>
#define ${fifo.customName} ${fifo.name}
</#list>

typedef enum 
{
    <#list txFifoList as fifo>
    ${fifo.name} = ${fifo.fifoNum}<#if fifo?has_next>,</#if>
    </#list>
} ${moduleNameUpperCase}_TX_FIFO_CHANNELS;
</#if>

<#if CANRXI_ENABLE.value == "enabled">
typedef enum
{
    <#list rxFifoList as fifo>
    ${fifo.name} = ${fifo.fifoNum}<#if fifo?has_next>,</#if>
    </#list>
} ${moduleNameUpperCase}_RX_FIFO_CHANNELS;
</#if>

/**
  Section: CAN Module APIs
*/

/**
  @Summary
    Initialization routine that takes inputs from the CAN GUI.

  @Description
    This routine initializes the CAN module.
    This routine must be called before any other CAN routine is called.
    This routine should only be called once during system initialization.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Example
    <code>
    void main(void)
    {
        SYSTEM_Initialize();
   
        while (1)
        {
            //User Application code
        }      
    }
    </code> 
*/
void ${moduleNameUpperCase}_Initialize(void);

/**
  @Summary
    Set the CAN operation mode.

  @Description
    This function sets the CAN operation mode.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should be called before calling this function.
 
  @Param
    reqestMode - CAN operation mode

  @Returns
    CAN_OP_MODE_REQUEST_SUCCESS - Requested Operation mode set successfully
    CAN_OP_MODE_REQUEST_FAIL - Requested Operation mode set failure. Set configuration 
                               mode before setting CAN normal or debug operation mode.
    CAN_OP_MODE_SYS_ERROR_OCCURED - System error occurred while setting Operation mode.

  @Example
    <code>
    void main(void)
    {
        SYSTEM_Initialize();

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                //User Application code
            }
        }

        while (1)
        {
        }
    }
    </code> 
*/
CAN_OP_MODE_STATUS ${moduleNameUpperCase}_OperationModeSet(const CAN_OP_MODES reqestMode);

/**
  @Summary
    Get the CAN operation mode.

  @Description
    This function gets the CAN operation mode.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should be called before calling this function. 
 
  @Param
    None

  @Returns
    Return the present CAN operation mode. 

  @Example
    <code>
    void main(void)
    {        
        SYSTEM_Initialize();
            
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                //User Application code
            }
        }
    
        while (1)
        {      
        }
    }
    </code> 
*/
CAN_OP_MODES ${moduleNameUpperCase}_OperationModeGet(void);

<#if rxFifoList?has_content>
/**
  @Summary
    Reads the message object from CAN receive FIFO.

  @Description
    This routine reads a message object from the CAN receive FIFO.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should be called before calling this function. 
    The ${moduleNameUpperCase}_ReceivedMessageCountGet() function should be checked to see if the receiver
    is not empty before calling this function.

  @Param
    rxCanMsg    - pointer to the message object

  @Returns
    true        - Receive successful
    false       - Receive failure

  @Example
    <code>
    void main(void) 
    {
        CAN_MSG_OBJ msg;
     
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(${moduleNameUpperCase}_ReceivedMessageCountGet() > 0) 
                    {
                        if(true == ${moduleNameUpperCase}_Receive(&msg))
                        {
                            break;
                        }
                    }
                }
            }
        }

        while (1);
    }
    </code>
*/
bool ${moduleNameUpperCase}_Receive(CAN_MSG_OBJ *rxCanMsg);
<#if CANRXI_ENABLE.value == "enabled">

/**
  @Summary
    Reads the message object from the specified CAN receive FIFO.

  @Description
    This routine reads a message object from the specified CAN receive FIFO.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should be called before calling this function. 

  @Param
    fifoChannel - CAN RX FIFO channel
    rxCanMsg    - pointer to the message object

  @Returns
    true        - Receive successful
    false       - Receive failure

  @Example
    <code>
    volatile CAN_MSG_OBJ gMsg;
    
    void CustomFIFO1Handler(void)
    {
        ${moduleNameUpperCase}_ReceiveFrom(FIFO1, &gMsg));
    }

    void main(void)
    {
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetFIFO1FullHandler(&CustomFIFO1Handler);
        
        INTERRUPT_GlobalInterruptEnable();

        while(1);
    }
    </code>
*/
bool ${moduleNameUpperCase}_ReceiveFrom(const ${moduleNameUpperCase}_RX_FIFO_CHANNELS fifoChannel, CAN_MSG_OBJ *rxCanMsg);
</#if>
</#if>

<#if txFifoList?has_content>
/**
  @Summary
    Writes a message object to the CAN TX FIFO.

  @Description
    This routine writes a message object to the CAN TX FIFO.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function. 
    The transfer status should be checked to see if transmitter is not full 
    before calling this function.

  @Param
    fifoChannel - CAN TX priority FIFO selection
    txCanMsg     - pointer to the message object

  @Returns
    CAN Transmit message status.
    CAN_TX_MSG_REQUEST_SUCCESS - Transmit message object successfully placed into transmit FIFO
    CAN_TX_MSG_REQUEST_DLC_EXCEED_ERROR - Transmit message object DLC size is more than transmit FIFO configured DLC size
    CAN_TX_MSG_REQUEST_BRS_ERROR - Transmit FIFO configured has Non BRS mode and CAN TX Message object has BRS enabled
    CAN_TX_MSG_REQUEST_FIFO_FULL - Transmit FIFO Full

  @Example
    <code>
    #define CAN_TX_BUFF  "TEMPERATURE SENSOR ON"
    
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[32] = CAN_TX_BUFF;
        
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_32;
                msg.data = data;
            
                if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                {
                    ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                }
            }
        }

        while(1);
    }
    </code>
*/
CAN_TX_MSG_REQUEST_STATUS ${moduleNameUpperCase}_Transmit(const ${moduleNameUpperCase}_TX_FIFO_CHANNELS fifoChannel, CAN_MSG_OBJ *txCanMsg);
</#if>

/**
  @Summary
    Checks whether the transmitter is in bus off state.

  @Description
    This routine checks whether the transmitter is in bus off state.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    None

  @Returns
    true    - Transmitter in Bus Off state
    false   - Transmitter not in Bus Off state

  @Example
    <code>
    #define CAN_TX_BUFF  "TEMPERATURE SENSOR ON"

    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[32] = CAN_TX_BUFF;
        
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_32;
                msg.data = data;
            
                if(${moduleNameUpperCase}_IsBusOff() == false)
                {
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsBusOff(void);

/**
  @Summary
    Checks whether the transmitter is in the error passive state.

  @Description
    This routine checks whether the transmitter is in the error passive state.
    If Transmitter error counter is above 127, then the transmitter error passive 
    state is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    None

  @Returns
    true    - Transmitter in Error Passive state
    false   - Transmitter not in Error Passive state

  @Example
    <code>
    #define CAN_TX_BUFF  "TEMPERATURE SENSOR ON"

    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[32] = CAN_TX_BUFF;
        
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_32;
                msg.data = data;
            
                if(${moduleNameUpperCase}_IsTxErrorPassive() == false)
                {
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsTxErrorPassive(void);

/**
  @Summary
    Checks whether the transmitter is in the error warning state.

  @Description
    This routine checks whether the transmitter is in the error warning state.
    If Transmitter error counter is above 95 to below 128, then transmitter error 
    warning state is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called 
    before calling this function.

  @Param
    None

  @Returns
    true    - Transmitter in Error warning state
    false   - Transmitter not in Error warning state

  @Example
    <code>
    #define CAN_TX_BUFF  "TEMPERATURE SENSOR ON"

    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[32] = CAN_TX_BUFF;
        
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_32;
                msg.data = data;
            
                if(${moduleNameUpperCase}_IsTxErrorWarning() == false)
                {
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsTxErrorWarning(void);

/**
  @Summary
    Checks whether the transmitter is in the error active state.

  @Description
    This routine checks whether the transmitter is in the error active state.
    If Transmitter error counter is above 0 to below 128, then transmitter error 
    active state is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called 
    before calling this function.

  @Param
    None

  @Returns
    true    - Transmitter in Error active state
    false   - Transmitter not in Error active state

  @Example
    <code>
    #define CAN_TX_BUFF  "TEMPERATURE SENSOR ON"

    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[32] = CAN_TX_BUFF;
        
        SYSTEM_Initialize();

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_32;
                msg.data = data;
            
                if(${moduleNameUpperCase}_IsTxErrorActive() == false)
                {
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsTxErrorActive(void);

/**
  @Summary
    Checks whether the Receiver is in the error passive state.

  @Description
    This routine checks whether the receive is in the error passive state.
    If Receiver error counter is above 127, then receiver error passive 
    state is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    None

  @Returns
    true    - Receiver in Error passive state
    false   - Receiver not in Error passive state

  @Example
    <code>
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(${moduleNameUpperCase}_IsRxErrorPassive() == false)
                    {
                        if(${moduleNameUpperCase}_ReceivedMessageCountGet() > 0) 
                        {
                            ${moduleNameUpperCase}_Receive(&msg);
                        }
                    }
                }
            }
        }
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsRxErrorPassive(void);

/**
  @Summary
    Checks whether the Receiver is in the error warning state.

  @Description
    This routine checks whether the receive is in the error warning state.
    If Receiver error counter is above 95 to below 128, then receiver error warning 
    state is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    None

  @Returns
    true    - Receiver in Error warning state
    false   - Receiver not in Error warning state

  @Example
    <code>
    void main(void) 
    {
        CAN_MSG_OBJ msg;
     
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(${moduleNameUpperCase}_IsRxErrorWarning() == false)
                    {
                        if(${moduleNameUpperCase}_ReceivedMessageCountGet() > 0) 
                        {
                            ${moduleNameUpperCase}_Receive(&msg);
                        }
                    }
                }
            }
        }
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsRxErrorWarning(void);

/**
  @Summary
    Checks whether the Receiver is in the error active state.

  @Description
    This routine checks whether the receive is in the error active state.
    If Receiver error counter is above 0 to below 128, then receiver error active 
    state is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    None

  @Returns
    true    - Receiver in Error active state
    false   - Receiver not in Error active state

  @Example
    <code>
    void main(void) 
    {
        CAN_MSG_OBJ msg;
     
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(${moduleNameUpperCase}_IsRxErrorActive() == false)
                    {
                        if(${moduleNameUpperCase}_ReceivedMessageCountGet() > 0) 
                        {
                            ${moduleNameUpperCase}_Receive(&msg);
                        }
                    }
                }
            }
        }
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsRxErrorActive(void);

/**
  @Summary
    Puts CAN module in sleep mode.

  @Description
    This routine puts CAN module in sleep mode.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    void main(void) 
    {     
        SYSTEM_Initialize();
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                ${moduleNameUpperCase}_Sleep();
                
                if(CAN_DISABLE_MODE == ${moduleNameUpperCase}_OperationModeGet())
                {
                    Sleep(); //Call sleep instruction
                    ${CINTL.name}bits.WAKIF = 0; // Clear Wake-Up interrupt flag
                    
                    // Recover to Normal mode
                    if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE))
                    {
                        if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
                        {
                            //User Application code                            
                        }
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_Sleep(void);

<#if txFifoList?has_content>
/**
  @Summary
    CAN transmitter FIFO status.

  @Description
    This returns the CAN transmitter FIFO status.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
    fifoChannel - CAN TX priority FIFO selection

  @Returns
    CAN Transmit FIFO status.
    CAN_TX_FIFO_FULL         - CAN Transmit FIFO is full
    CAN_TX_FIFO_AVAILABLE     - CAN Transmit FIFO message space is available

  @Example
    <code>
    #define CAN_TX_BUFF  "TEMPERATURE SENSOR ON"
    
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[32] = CAN_TX_BUFF;
        
        SYSTEM_Initialize();

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {    
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_32;
                msg.data = data;
            
                if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                {
                    ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                }
            }
        }
        
        while(1);
    }
    </code>
*/
CAN_TX_FIFO_STATUS ${moduleNameUpperCase}_TransmitFIFOStatusGet(const ${moduleNameUpperCase}_TX_FIFO_CHANNELS fifoChannel);
</#if>

<#if rxFifoList?has_content>
/**
  @Summary
    CAN RX FIFO number of messages that are received.

  @Description
    This returns the number of messages that are received.

  @Preconditions
    ${moduleNameUpperCase}_Initialize function should be called before calling this function.

  @Param
     None

  @Returns
    Number of message received.

  @Example
    <code>
    void main(void) 
    {
        CAN_MSG_OBJ msg;
     
        SYSTEM_Initialize();

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(${moduleNameUpperCase}_ReceivedMessageCountGet() > 0) 
                    {
                        ${moduleNameUpperCase}_Receive(&msg);
                    }
                }
            }
        }
    }
    </code>
*/
uint8_t ${moduleNameUpperCase}_ReceivedMessageCountGet(void);
</#if>

<#if CANI_ENABLE.value == "enabled">
/**
  @Summary
    Sets the invalid message interrupt handler.

  @Description
    This routine sets the invalid message interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    //Note: Example code here is not based on MCC UI configuration, 
    //      this is a sample code to demonstrate CAN transmit APIs usage.
    
    volatile bool gInvalidMsgOccurred = false;
    
    void ${moduleNameUpperCase}_InvalidMessage(void)
    {
        gInvalidMsgOccurred = true;
        //CAN Invalid Message application code
    }
 
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[8] = {0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48};
        
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetInvalidMessageInterruptHandler(&${moduleNameUpperCase}_InvalidMessage);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {    
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_8;
                msg.data = data;

                while(1)
                {            
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                    
                    if(gInvalidMsgOccurred == true)
                    {
                        break;
                    }
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetInvalidMessageInterruptHandler(void (*handler)(void));

/**
  @Summary
    Sets the CAN bus wake-Up activity interrupt handler.

  @Description
    This routine sets the CAN bus wake-Up activity interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    volatile bool gBusWakeUpOccurred = false;
    
    void ${moduleNameUpperCase}_BusWakeUpActivity(void)
    {
        gBusWakeUpOccurred = true;
        //CAN Bus WakeUp activity application code
    }
 
    void main(void) 
    {
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetBusWakeUpActivityInterruptHandler(&${moduleNameUpperCase}_BusWakeUpActivity);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                ${moduleNameUpperCase}_Sleep();
                            
                //Check ${moduleNameUpperCase} module is in CAN_DISABLE_MODE
                if(CAN_DISABLE_MODE == ${moduleNameUpperCase}_OperationModeGet())
                {
                    Sleep(); //Call sleep instruction
                    
                    while(1) 
                    {
                        if(gBusWakeUpOccurred == true)
                        {
                            break;
                        }                        
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetBusWakeUpActivityInterruptHandler(void (*handler)(void));

/**
  @Summary
    Sets the CAN bus error interrupt handler.

  @Description
    This routine sets the CAN bus error interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    //Note: Example code here is not based on MCC UI configuration, 
    //      this is a sample code to demonstrate CAN transmit APIs usage.
    
    volatile bool gBusErrorOccurred = false;
    
    void ${moduleNameUpperCase}_BusError(void)
    {
        gBusErrorOccurred = true;
        //CAN Bus Error application code
    }
 
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[8] = {0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48};
        
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetBusErrorInterruptHandler(&${moduleNameUpperCase}_BusError);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {    
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_8;
                msg.data = data;

                while(1)
                {            
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                    
                    if(gBusErrorOccurred == true)
                    {
                        break;
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetBusErrorInterruptHandler(void (*handler)(void));

/**
  @Summary
    Sets the CAN mode change interrupt handler.

  @Description
    This routine sets the CAN mode change interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    volatile bool gModeChangeOccurred = false;
    
    void ${moduleNameUpperCase}_ModeChange(void)
    {
        gModeChangeOccurred = true;
        //CAN Mode Change application code
    }
 
    void main(void) 
    {
        CAN_MSG_OBJ msg;
     
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetModeChangeInterruptHandler(&${moduleNameUpperCase}_ModeChange);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);
        
        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(gModeChangeOccurred == true)
                    {
                        break;
                    }                    
                }
            }
        }

        while (1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetModeChangeInterruptHandler(void (*handler)(void));

/**
  @Summary
    Sets the CAN system error interrupt handler.

  @Description
    This routine sets the CAN system error interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    //Note: Example code here is not based on MCC UI configuration, 
    //      this is a sample code to demonstrate CAN transmit APIs usage.
    
    volatile bool gSystemOccurred = false;
    
    void ${moduleNameUpperCase}_SystemError(void)
    {
        gSystemOccurred = true;
        //CAN System Error application code
    }
 
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[8] = {0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48};
        
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetSystemErrorInterruptHandler(&${moduleNameUpperCase}_SystemError);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {    
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_8;
                msg.data = data;

                while(1)
                {            
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                    
                    if(gSystemOccurred == true)
                    {
                        break;
                    }
                }
                
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetSystemErrorInterruptHandler(void (*handler)(void));

/**
  @Summary
    Sets the CAN transmit attempt interrupt handler.

  @Description
    This routine sets the CAN transmit attempt interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    //Note: Example code here is not based on MCC UI configuration, 
    //      this is a sample code to demonstrate CAN transmit APIs usage.
    
    volatile bool gTxAttemptOccurred = false;
    
    void ${moduleNameUpperCase}_TxAttempt(void)
    {
        gTxAttemptOccurred = true;
        //CAN Transmit Attempt application code
    }
 
    void main(void) 
    {
        CAN_MSG_OBJ msg;
        uint8_t data[8] = {0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48};
        
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetTxAttemptInterruptHandler(&${moduleNameUpperCase}_TxAttempt);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {    
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                msg.msgId = 0x1FFFF;
                msg.field.formatType = CAN_FD_FORMAT;
                msg.field.brs = CAN_NON_BRS_MODE;
                msg.field.frameType = CAN_FRAME_DATA;
                msg.field.idType = CAN_FRAME_EXT;
                msg.field.dlc = DLC_8;
                msg.data = data;

                while(1)
                {                               
                    if(CAN_TX_FIFO_AVAILABLE == (${moduleNameUpperCase}_TransmitFIFOStatusGet(${moduleNameUpperCase}_TX_FIFO1) & CAN_TX_FIFO_AVAILABLE))
                    {
                        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &msg);
                    }
                    
                    if(gTxAttemptOccurred == true)
                    {
                        break;
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetTxAttemptInterruptHandler(void (*handler)(void));

/**
  @Summary
    Sets the CAN receive overflow interrupt handler.

  @Description
    This routine sets the CAN receive overflow interrupt handler.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example 
    <code>
    volatile bool gRxOverFlowOccurred = false;
    
    void ${moduleNameUpperCase}_RxBufferOverFlow(void)
    {
        gRxOverFlowOccurred = true;
        //CAN Receive Buffer OverFlow application code
    }
 
    void main(void) 
    {    
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_SetRxBufferOverFlowInterruptHandler(&${moduleNameUpperCase}_RxBufferOverFlow);
        ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE);

        if(CAN_CONFIGURATION_MODE == ${moduleNameUpperCase}_OperationModeGet())
        {    
            if(CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(${operatingMode}))
            {
                while(1) 
                {
                    if(gRxOverFlowOccurred == true)
                    {
                        gRxOverFlowOccurred = false;
                        // User Application code
                        break;
                        
                    }
                }
            }
        }
        
        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_SetRxBufferOverFlowInterruptHandler(void (*handler)(void));

</#if>
<#list rxFifoList as fifo>
/**
  @Summary
    Sets the ${fifo.interruptSelection} interrupt handler.

  @Description
    This routine sets the ${fifo.interruptSelection} interrupt handler for ${fifo.name}.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example
    <code>
    volatile CAN_MSG_OBJ gMsg;
    
    void Custom${fifo.name}Handler(void)
    {
        ${moduleNameUpperCase}_ReceiveFrom(${fifo.name}, &gMsg);
    }

    void main(void)
    {
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_${fifo.setInterruptHandler}(&Custom${fifo.name}Handler);
        
        INTERRUPT_GlobalInterruptEnable();

        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_${fifo.setInterruptHandler}(void (*handler)(void));

</#list>
<#list txFifoList as fifo>
/**
  @Summary
    Sets the ${fifo.interruptSelection} interrupt handler.

  @Description
    This routine sets the ${fifo.interruptSelection} interrupt handler for ${fifo.name}.

  @Param
    Address of the callback routine.

  @Returns
    None
 
  @Example
    <code>
    volatile CAN_MSG_OBJ gMsg;
    
    void Custom${fifo.name}Handler(void)
    {
        ${moduleNameUpperCase}_Transmit(${moduleNameUpperCase}_TX_FIFO1, &gMsg);
    }

    void main(void)
    {
        uint8_t data[8] = {0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48};
        gMsg.msgId = 0x1FFFF;
        gMsg.field.formatType = CAN_FD_FORMAT;
        gMsg.field.brs = CAN_NON_BRS_MODE;
        gMsg.field.frameType = CAN_FRAME_DATA;
        gMsg.field.idType = CAN_FRAME_EXT;
        gMsg.field.dlc = DLC_8;
        gMsg.data = data;
        
        SYSTEM_Initialize();
        ${moduleNameUpperCase}_${fifo.setInterruptHandler}(&Custom${fifo.name}Handler);
        
        INTERRUPT_GlobalInterruptEnable();

        while(1);
    }
    </code>
*/
void ${moduleNameUpperCase}_${fifo.setInterruptHandler}(void (*handler)(void));

</#list>

<#if !isVectoredInterrupt>
<#if CANI_ENABLE.value == "enabled">
void ${moduleNameUpperCase}_${CANI_ISR}(void);
</#if>
<#if CANRXI_ENABLE.value == "enabled">
void ${moduleNameUpperCase}_${CANRXI_ISR}(void);
</#if>
<#if CANTXI_ENABLE.value == "enabled">
void ${moduleNameUpperCase}_${CANTXI_ISR}(void);
</#if>
</#if>

#endif  //${moduleNameUpperCase}_H
