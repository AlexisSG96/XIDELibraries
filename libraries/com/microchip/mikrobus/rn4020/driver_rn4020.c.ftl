/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "mcc.h"
#include "BLE2_driver.h"
#include <string.h>
#include "drivers/${UARTFunctions["uartheader"]}"

void BLE2_EnterCommand_Mode(void)
{
    ${cmdMldpPinSettings["setOutputLevelHigh"]}
    ${DELAYFunctions.delayMs}(20);
    ${cmdMldpPinSettings["setOutputLevelLow"]}
    ${DELAYFunctions.delayMs}(20);
}
void BLE2_ExitCommand_Mode(void)
{
    ${cmdMldpPinSettings["setOutputLevelHigh"]}
}
void BLE2_EnterMicrochipLowEnergyDataProfile_Mode(void)
{
    ${cmdMldpPinSettings["setOutputLevelLow"]}
}

void BLE2_DeepSleepModule(void)
{
    ${wakePinSettings["setOutputLevelLow"]}
}
void BLE2_WakeModule(void)
{
    ${wakePinSettings["setOutputLevelHigh"]}
}

bool BLE2_isConnected(void)
{
    return ${connPinSettings["getInputValue"]};
}

void BLE2_SendString(const char* command)
{
    BLE2_SendBuffer((uint8_t *)command, strlen(command));
}
void BLE2_SendBuffer(uint8_t *buffer, uint8_t length)
{
    while(length--)
        BLE2_SendByte(*buffer++);
}
void BLE2_SendByte(uint8_t byte)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(byte);
}