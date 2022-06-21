/*
<#include "MicrochipDisclaimer.ftl">
*/
#include "mcc.h"
#include "IrDA2_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

static void IrDA2_SetDataMode(void);
static void IrDA2_SetConfigMode(void);

/**
 * Mandatory pins to be interfaced with MCU:
 * Pin ENABLE: enable the IrDA2 (Output from MCU)
 * Pin RESET: Reset control of the IrDA2 module (Output from MCU)
 * Pin MODE: Select data or Configuration mode (Output from MCU)
 * Pin RX: Receive data from IrDA2 module(Input to MCU)
 * Pin TX: Transmit data to IrDA2 module(Output to MCU)
 */

 /**
 * @brief  This is an Initialization function for IrDA2 click.
 * @param  None
 * @return None
 */
void IrDA2_Initialize()
{
    IrDA2_SetEnableState(true);
    <#if (isAVR == "true")>
    _delay_ms(150);
    <#else>
    __delay_ms(150);
    </#if>
    IrDA2_SetnResetState(true);
    IrDA2_SetnResetState(false);
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    IrDA2_SetDataMode();
}

/**
 * @brief Controls Enable pin of IrDA2 module.
 * @return None.
 * @param [in] state: Desired state of ENABLE pin.
 *             TRUE : Enables the module
 *             FALSE: Disables the module
 */
void IrDA2_SetEnableState(bool state)
{
    if(state == true)
    {
        ${enablePinSettings["LAT"]} = 1;
    }
    else
    {
        ${enablePinSettings["LAT"]} = 0;
    }    
}

/**
 * @brief Reset control pin of IrDA2 module.
 * @return None.
 * @param [in] state: Desired state of RESET pin.
 *             TRUE : Reset the module
 *             FALSE: Clear reset of the module
 */
void IrDA2_SetnResetState(bool state)
{
    if(state == true)
    {
        ${resetPinSettings["LAT"]} = 0;
    }
    else
    {
        ${resetPinSettings["LAT"]} = 1;
    } 
}

/**
 * @brief  Send the data using IrDA2 module.
 * @param  [in] data: data to be sent.
 * @return None
 */
void IrDA2_SendData(const uint8_t data)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(data);
}

/**
 * @brief  Receive the data from IrDA2 module.
 * @param  None
 * @return [Out]: Received data from IrDA2
 */
uint8_t IrDA2_ReceiveData(void)
{
    return (${UARTFunctions["functionName"]}[${uart_configuration}].Read());
}

/**
 * @brief  This function is used to configure baudrate to IrDA2 module.
 * @param  IrDA2_BaudRate_t: Different Baudrate configuration
 * @return None
 */
void IrDA2_ConfigBaudRate(IrDA2_BaudRate_t baudRate)
{
    // Initial communications at 9600 baud rate
    IrDA2_SetConfigMode();                // Enter command mode
    if(baudRate == BAUDRATE_19200)
    {
        IrDA2_SendData(0x8B);
    }
    else if(baudRate == BAUDRATE_38400)
    {
        IrDA2_SendData(0x85);
    }
    else if(baudRate == BAUDRATE_57600)
    {
        IrDA2_SendData(0x83);
    }
    else if(baudRate == BAUDRATE_115200)
    {
        IrDA2_SendData(0x81);
    }
    else
    {
        // Default 9600 baud rate set for safe communication
        IrDA2_SendData(0x87);
    }
    IrDA2_ReceiveData();                  // Read echo
    IrDA2_SendData(0x11);                 // Change to the baud rate above
    IrDA2_ReceiveData();                  // Read echo
    IrDA2_SetDataMode();                  // Enter data mode
    // User must change the system UART baud rate accordingly
}

/**
 * @brief  This function is used for set IrDA2 click to data TX and RX mode
 * @param  None
 * @return None
 */
static void IrDA2_SetDataMode(void)
{
    ${modePinSettings["LAT"]} = 1;
}

/**
 * @brief  This function is used for set IrDA2 click to Config mode
 * @param  None
 * @return None
 */
static void IrDA2_SetConfigMode(void)
{
    ${modePinSettings["LAT"]} = 0;
}