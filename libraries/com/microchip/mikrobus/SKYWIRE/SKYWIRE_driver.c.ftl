/*
<#include "MicrochipDisclaimer.ftl">
*/
#include "mcc.h"
#include "SKYWIRE_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

/* Termination characters for GSM AT Commands*/
#define AT_CARRIARE_RETURN                   0x0D
#define AT_NEW_LINE                          0x0A
#define AT_CTRL_Z                            0x1A

static void SKYWIRE_PowerOn(void);
static void SKYWIRE_InitGsm(void);

/**
 * Mandatory pins to be interfaced with MCU:
 * Pin EN: MCP1826 low dropout regulator (Output from MCU)
 * Pin RESET: Reset control of the Nimbelink/Skywire module (Output from MCU)
 * Pin RX: Receive data from Nimbelink/Skywire module(Input to MCU)
 * Pin TX: Transmit data to Nimbelink/Skywire module(Output to MCU)
 */

 /**
 * @brief  This is an Initialization function for MCP1826 regulator
 *         and Nimbelink/Skywire module.
 * @param  None
 * @return None
 */
void SKYWIRE_Initialize()
{
    SKYWIRE_PowerOn();
    SKYWIRE_InitGsm();
}

/**
 * @brief Controls Enable pin of MCP1826 regulator.
 * @return None.
 * @param [in] state: Desired state of ENABLE pin.
 *             TRUE : Enables the module
 *             FALSE: Disables the module
 */
void SKYWIRE_PinSetEnable(bool state)
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
 * @brief Reset control pin of Nimbelink/Skywire module.
 * @return None.
 * @param [in] state: Desired state of RESET pin.
 *             TRUE : Reset the module
 *             FALSE: Clear reset of the module
 */
void SKYWIRE_PinSetReset(bool state)
{
    if(state == true)
    {
        ${resetPinSettings["LAT"]} = 1;
        <#if (isAVR == "true")>
		_delay_ms(100);
		<#else>
		__delay_ms(100);
		</#if>
        ${resetPinSettings["LAT"]} = 0;
    }
    else
    {
        ${resetPinSettings["LAT"]} = 0;
    } 
}

/**
 * @brief  Send the AT commands for Nimbelink/Skywire module.
 * @param  [in] cmd: Pointer to buffer which is contained AT command to be sent.
 * @return None
 */
void SKYWIRE_SendCmdString(const char *cmd)
{
//    Send the Commands using UART by appending \r and \n.
    while(*cmd)
    {
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(*cmd++);
    }
}
 
/**
 * @brief  Send the AT command for Nimbelink/Skywire module.
 * @param  [in] cmd: Command to be sent.
 * @return None
 */
void SKYWIRE_SendCmd(char cmd)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(cmd);
}    

/**
 * @brief  Send SMS using Nimbelink/Skywire module.
 * @param  [in] phoneNumber: Destination Phone number.
 * @param  [in] text: Text message to be sent.
 * @return None
 */
void SKYWIRE_SendSms(char *phoneNum, char *text)
{
//  send SMS implementation using GSM AT commands
    SKYWIRE_SendCmdString("AT+CMGS=\"");
    SKYWIRE_SendCmdString(phoneNum);
    SKYWIRE_SendCmdString("\"\n");
    SKYWIRE_SendCmdString(text);
    SKYWIRE_SendCmd(AT_CTRL_Z);
}

/**
 * @brief  This function is for Power On the regulator.
 * @param  None
 * @return None
 */
static void SKYWIRE_PowerOn(void)
{
    SKYWIRE_PinSetEnable(false);
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    SKYWIRE_PinSetEnable(true);
}

/**
 * @brief  This function is for intialize the GSM modem.
 * @param  None
 * @return None
 */
static void SKYWIRE_InitGsm(void)
{
//    Basic command required for GSM initialization.
    SKYWIRE_SendCmdString("AT\r\n");
    SKYWIRE_SendCmdString("ATE0\r\n");    
    SKYWIRE_SendCmdString( "AT+CSCS=\"GSM\"\r\n" );
    SKYWIRE_SendCmdString( "AT+CMGF=1\r\n" );
}