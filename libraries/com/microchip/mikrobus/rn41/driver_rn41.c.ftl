/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "${pinHeader}"
#include "device_config.h"
#include "bluetooth.h"
#include "drivers/${UARTFunctions["uartheader"]}"


#define BT_BufferSize 32
typedef enum { NO_RESPONSE, OK } BT_Responses_t;
static uint8_t BT_ResponseIndex = 0;
static char  BT_ResponseBuffer [BT_BufferSize]= {0};
bool BT_IsMessage = 0;

// Command mode functions

bool inCmd = false;

void BT_EnterCommand(void) {
    uint8_t i;
    for (i = 0; i < 3; i++) {
       ${UARTFunctions["functionName"]}[${uart_configuration}].Write('$');
    }
    while((BT_CheckResponse(cmdStr) == NO_RESPONSE));
    inCmd = true;
}

void BT_ExitCommand(void) {
    uint8_t i;
    for (i = 0; i < 3; i++) {

        ${UARTFunctions["functionName"]}[${uart_configuration}].Write('-');
    }
    inCmd = false;
}

// Data commands

char BT_ReadByte(void) {
    
    uint8_t retVal;
    
    BT_IsMessage = 0;
    retVal = BT_ResponseBuffer[0];
    BT_ClearReceivedMessage();

    return retVal;
}

void BT_SendData(const char * data, size_t length) {
    if (inCmd) {
        BT_ExitCommand();
    }

    uint8_t i;
    for (i = 0; i < length; i++) {
       ${UARTFunctions["functionName"]}[${uart_configuration}].Write(data[i]);
    }
}

void BT_SendByte(uint8_t byte) {
    
    uart[BlueTooth].Write(byte);
}

// Private data functions

void BT_SendCmd(const char * cmd, size_t length, const char * chkString) {
    if (!inCmd) {
        BT_EnterCommand();
    }

    uint8_t i;
    for (i = 0; i < length - 1; i++) {
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(cmd[i]);
    }
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\n');

    while((BT_CheckResponse(chkString) == NO_RESPONSE));
}

void BT_SendCmdAok(const char * cmd, size_t length) {

    BT_SendCmd(cmd, length, aokStr);
}

void BT_SendBoolCmd(char specifier, bool enable) {

    char cmd[] = "SX,0";

    sprintf(cmd, "S%c,%01d", specifier, enable);

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_Send4BitCmd(char specifier, uint8_t value) {
    if (value > 0xF) {

        return;
    }

    char cmd[] = "SX,0";

    sprintf(cmd, "S%c,%01X", specifier, value);

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_SendChar(char specifier, char character) {

    char cmd[] = "SX,Y";

    sprintf(cmd, "S%c,%c", specifier, character);

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_Send8BitDecCmd(char specifier, uint8_t value) {

    char cmd[] = "SX,000";

    sprintf(cmd, "S%c,%03u", specifier, value);

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_Send16BitCmd(char specifier, uint16_t value) {

    char cmd[] = "SX,0000";

    sprintf(cmd, "S%c,%04X", specifier, value);

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_Reboot(void) {

    char cmd[] = "R,1";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, softRebootStr);
    <#if (isAVR == "true")>
	_delay_ms(750);
	<#else>
	__delay_ms(750);
	</#if>
    inCmd = false;
}

// Setter functions

void BT_Enable7BitData(bool enable) {

    BT_SendBoolCmd('7', enable);
}

void BT_SetAuthentication(uint8_t authentication) {

    BT_Send4BitCmd('A', authentication);
}

void BT_SetBreak(uint8_t breakVal) {

    BT_Send4BitCmd('B', breakVal);
}

void BT_SetServiceClass(uint16_t class) {

    BT_Send16BitCmd('C', class);
}

void BT_SetDeviceClass(uint16_t class) {

    BT_Send16BitCmd('D', class);
}

void BT_SetUUID(const char * UUID) {
    char cmd[] = "SE,12345678901234567890123456789012345678";

    uint8_t i;
    for (i = 0; i < 38; i++) {

        cmd[i + 3] = UUID[i];
    }

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_UseDefaultUUID(void) {

    BT_SendChar('E', 'S');
}

void BT_UseiPhoneUUID(void) {

    BT_SendChar('E', 'I');
}

void BT_UseCustomUUID(void) {

    BT_SendChar('E', 'C');
}

void BT_RestoreFactoryDefaults(void) {

    Bluetooth_HwReset_LAT = 0;
    <#if (isAVR == "true")>
	_delay_ms(50);
	<#else>
	__delay_ms(50);
	</#if>
    Bluetooth_HwReset_LAT = 1;
    <#if (isAVR == "true")>
	_delay_ms(750);
	<#else>
	__delay_ms(750);
	</#if>
    inCmd = false;
    BT_Send4BitCmd('F', 1);
    BT_Reboot();
}

void BT_SetHidFlag(uint16_t flag) {

    BT_Send16BitCmd('H', flag);
}

void BT_SetInquiryScanWindow(uint16_t window) {

    BT_Send16BitCmd('I', window);
}

void BT_SetPageScanWindow(uint16_t window) {

    BT_Send16BitCmd('J', window);
}

void BT_SetParity(char parity) {

    BT_SendChar('L', parity);
}

void BT_SetMode(uint8_t mode) {

    BT_Send4BitCmd('M', mode);
}

void BT_SetName(const char * name, size_t length) {
    if (length > 20) {
        length = 20;
    }

    char cmd[] = "SN,12345678901234567890";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 3] = name[i];
    }

    length += 4;
    BT_SendCmdAok(cmd, length);
}

void BT_SetStatusString(const char * name, size_t length) {
    if (length > 8) {
        length = 8;
    }

    char cmd[] = "SO,12345678";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 3] = name[i];
    }

    length += 4;
    BT_SendCmdAok(cmd, length);
}

void BT_SetPinCode(const char * code, size_t length) {
    if (length > 20) {
        length = 20;
    }

    char cmd[] = "SP,12345678901234567890";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 3] = code[i];
    }

    length += 4;
    BT_SendCmdAok(cmd, length);
}

void BT_SetSpecialConfig(uint16_t config) {

    BT_Send8BitDecCmd('Q', config);
}

void BT_SetRemote(const char * remote) {
    char cmd[] = "SR,123456789012";

    uint8_t i;
    for (i = 0; i < 12; i++) {

        cmd[i + 3] = remote[i];
    }

    size_t length = sizeof (cmd);
    BT_SendCmdAok(cmd, length);
}

void BT_EraseRemote(void) {

    BT_SendChar('R', 'Z');
}

void BT_UseLastObservedRemote(void) {

    BT_SendChar('R', 'I');
}

void BT_SetRemoteConfigTimer(uint8_t timer) {

    BT_Send8BitDecCmd('T', timer);
}

void BT_SetLowPowerSniff(uint16_t time) {

    BT_Send16BitCmd('W', time);
}

void BT_EnableBonding(bool enable) {

    BT_SendBoolCmd('X', enable);
}

void BT_SetPower(uint16_t power) {

    BT_Send16BitCmd('Y', power);
}

void BT_SetProfile(uint8_t profile) {

    BT_Send4BitCmd('~', profile);
}

void BT_SetSerializedName(const char * name, size_t length) {
    if (length > 15) {
        length = 15;
    }

    char cmd[] = "S-,123456789012345";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 3] = name[i];
    }

    length += 4;
    BT_SendCmdAok(cmd, length);
}

void BT_EnableRoleSwitch(bool enable) {

    BT_SendBoolCmd('?', enable);
}

void BT_SetLowerPowerTimer(uint8_t onTime, uint8_t offTime) {

    uint16_t combined = (offTime << 8) | onTime;
    BT_Send16BitCmd('|', combined);
}

void BT_GetSettings(void) {

    char cmd[] = "D";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetExtendedSettings(void) {

    char cmd[] = "E";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetAddr(void) {

    char cmd[] = "GB";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetConnectedAddr(void) {

    char cmd[] = "GF";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetConnectionStatus(void) {

    char cmd[] = "GK";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetRemoteAddr(void) {
    char cmd[] = "GR";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_InquiryScan(uint8_t time, const char * COD) {
    if (time > 48) {
        time = 48;
    }

    char cmd[] = "I,xx,123456";
    sprintf(cmd, "I,%02d,123456", time);

    uint8_t i;
    for (i = 0; i < 6; i++) {

        cmd[i + 5] = COD[i];
    }

    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_PairingDevicesScan(void) {
    char cmd[] = "IQ";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_KillConnection(void) {
    char cmd[] = "K";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetLinkQuality(void) {
    char cmd[] = "L";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}

void BT_GetRemoteModemStatus(void) {
    char cmd[] = "M";
    size_t length = sizeof (cmd);
    BT_SendCmd(cmd, length, nullStr);
}



//*********************************************************
//          ISR Call back Function
//*********************************************************
static void BT_CaptureReceivedMessage() {
    
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    BT_IsMessage = 1;
    uint8_t readByte = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if ( (readByte != '\0') && (BT_ResponseIndex < BT_BufferSize) )
        BT_ResponseBuffer[BT_ResponseIndex++] = readByte;    
}

//*********************************************************
//          Other Functions
//*********************************************************

void BT_Setup(const char *name) {
    
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(BT_CaptureReceivedMessage);
    BT_Reset_Module();
    BT_EnterCommand();
    BT_blockingWait(40);
    BT_SetMode(0);
    BT_blockingWait(40);
    BT_SetPinCode("00000", 5);
    BT_blockingWait(40);
    BT_SetSerializedName(name, strlen(name));
    BT_blockingWait(40);
    BT_Reboot();
    BT_blockingWait(40);
    BT_EnterCommand();
    BT_blockingWait(40);
    BT_ExitCommand();
    BT_blockingWait(40);
    BT_ClearReceivedMessage();
}

void BT_Reset_Module(void) {
    
    Bluetooth_HwReset_LAT = 0;                //Reset
    BT_blockingWait(1);
    Bluetooth_HwReset_LAT = 1;
    BT_blockingWait(50);
}

void BT_ClearReceivedMessage(void) {
    
    BT_ResponseIndex = 0;
    for (uint8_t position = 0; position < BT_BufferSize; position++)
        BT_ResponseBuffer[position] = 0;
}

uint8_t BT_CheckResponse(const char *response) {
    
    uint8_t ret = 0;
    if (strstr((const char *)BT_ResponseBuffer, response))
        ret = 1;
    return ret;
}

void BT_blockingWait(uint16_t limit) {
    
    for (uint16_t counter = 0; counter < limit; counter++)
        <#if (isAVR == "true")>
		_delay_ms(15);
		<#else>
		__delay_ms(15);
		</#if>
}
