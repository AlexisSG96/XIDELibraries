 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "BTA.h"
#include "drivers/uart.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "mcc.h"

// Data commands

void BTA_Initialize(void) {
    BluetoothAudio_PWR_LAT = 1;
    BluetoothAudio_nCMD_LAT = 0;
    BluetoothAudio_RST_LAT = 0;
    <#if (isAVR == "true")>
	_delay_ms(2000);
	<#else>
	__delay_ms(2000);
	</#if>
    BluetoothAudio_PWR_LAT = 0;
}

static bool BTA_IsMessage(void) {
    return ${UARTFunctions["functionName"]}[${uart_configuration}].DataReady();
}

static char BTA_ReadByte(void) {
    while (!BTA_IsMessage()) {
        NOP();
    }

    return ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
}

static void BTA_ClearBuffer(void) {
    while (BTA_IsMessage()) {
        BTA_ReadByte();
    }
}

static void BTA_SendData(const char * data, size_t length) {
    uint8_t i;
    for (i = 0; i < length; i++) {
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(data[i]);
    }
}

static bool BTA_CheckRecv(const char * chkString) {
    size_t length = strlen(chkString);
    size_t i = 0;

    while (i < length) {
        if (BTA_IsMessage()) {
            if (${UARTFunctions["functionName"]}[${uart_configuration}].Read() == chkString[i]) {
                i++;
            } else {
                return false;
            }
        }
    }

    return true;

}

static bool BTA_SendCmd(const char * cmd, const char * chkString) {
    size_t length = strlen(cmd);
    size_t i;
    for (i = 0; i < length; i++) {
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(cmd[i]);
    }
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');

    if (chkString[0] != '\0') {

        return BTA_CheckRecv(chkString);
    }
    
    return true;

}

static bool BTA_SendCmdAok(const char * cmd) {
    return BTA_SendCmd(cmd, aokStr);
}

bool BTA_SetRouting(uint8_t A2DP, uint8_t bits, uint8_t samples) {
    char cmd[] = "S|,1234";
    sprintf(cmd, "S|,%02d%d%d", A2DP, bits, samples);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetName(const char * name) {
    size_t length = strlen(name);
    if (length > 20) {
        length = 20;
    }

    char cmd[] = "SN,12345678901234567890";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 3] = name[i];
    }

    if (length != 20) {
        cmd[i + 4] = '\0';
    }

    return BTA_SendCmdAok(cmd);
}

bool BTA_SetCOD(const char * COD) {
    char cmd[] = "SC,123456";

    uint8_t i;
    for (i = 0; i < 6; i++) {

        cmd[i + 3] = COD[i];
    }

    return BTA_SendCmdAok(cmd);
}

bool BTA_SetExtendedFeatures(uint16_t features) {
    char cmd[] = "S%,1234";
    sprintf(cmd, "S%%,%04X", features);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetAuthentication(uint8_t authentication) {
    char cmd[] = "SA,1";
    sprintf(cmd, "SA,%d", authentication);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetDiscoveryMask(uint8_t mask) {
    char cmd[] = "SD,12";
    sprintf(cmd, "SD,%02X", mask);
    return BTA_SendCmdAok(cmd);
}

void BTA_Reboot(void) {
    char cmd[] = "R,1";
    BTA_SendCmd(cmd, "");
    <#if (isAVR == "true")>
	_delay_ms(750);
	<#else>
	__delay_ms(750);
	</#if>
}

void BTA_RestoreFactoryDefaults(void) {
    BTA_SendCmdAok("SF,1");
    <#if (isAVR == "true")>
	_delay_ms(20);
	<#else>
	__delay_ms(20);
	</#if>
    BTA_Reboot();
}

bool BTA_SetConnectionMask(uint8_t mask) {
    char cmd[] = "SK,12";
    sprintf(cmd, "SK,%02X", mask);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetMicGain(uint8_t micA, uint8_t micB) {
    char cmd[] = "SM,12341212";
    sprintf(cmd, "SM,0000%02X%02X", micA, micB);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetPin(const char * pin) {
    size_t length = strlen(pin);
    if (length > 20) {
        length = 20;
    }

    char cmd[] = "SP,12345678901234567890";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 3] = pin[i];
    }

    if (length != 20) {
        cmd[i + 4] = '\0';
    }

    return BTA_SendCmdAok(cmd);
}

bool BTA_SetSpeakerGain(uint8_t gain) {
    char cmd[] = "SS,02";
    sprintf(cmd, "SS,0%X", gain);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetToneGain(uint8_t gain) {
    char cmd[] = "ST,12";
    sprintf(cmd, "ST,%02X", gain);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetDiscoverable(bool discoverable) {
    char cmd[] = "@,0";
    sprintf(cmd, "@,%d", discoverable);
    return BTA_SendCmdAok(cmd);
}

bool BTA_CallNumber(const char * number) {
    size_t length = strlen(number);
    if (length > 25) {
        length = 25;
    }

    char cmd[] = "A,1234567890123456789012345";

    uint8_t i;
    for (i = 0; i < length; i++) {

        cmd[i + 2] = number[i];
    }

    if (length != 25) {
        cmd[i + 3] = '\0';
    }

    return BTA_SendCmdAok(cmd);
}

bool BTA_Redial(void) {
    return BTA_SendCmdAok("AR");
}

bool BTA_IncreaseVolume(void) {
    return BTA_SendCmdAok("AV+");
}

bool BTA_DecreaseVolume(void) {
    return BTA_SendCmdAok("AV-");
}

bool BTA_NextTrack(void) {
    return BTA_SendCmdAok("AT+");
}

bool BTA_PreviousTrack(void) {
    return BTA_SendCmdAok("AT-");
}

bool BTA_PausePlay(void) {
    return BTA_SendCmdAok("AP");
}

bool BTA_AttemptReconnect(void) {
    return BTA_SendCmdAok("B");
}

bool BTA_AcceptCall(void) {
    return BTA_SendCmdAok("C");
}

bool BTA_RejectCall(void) {
    return BTA_SendCmdAok("E");
}

bool BTA_TerminateHeldCalls(void) {
    return BTA_SendCmdAok("F");
}

bool BTA_TerminateActiveCalls(void) {
    return BTA_SendCmdAok("J");
}

bool BTA_PutOnHold(void) {
    return BTA_SendCmdAok("L");
}

bool BTA_AddHoldToActive(void) {
    return BTA_SendCmdAok("N");
}

bool BTA_ConnectCallsAndDisconnect(void) {
    return BTA_SendCmdAok("O");
}

bool BTA_TransferActiveCall(uint8_t target) {
    char cmd[] = "X,1";
    sprintf(cmd, "X,%d", target);
    return BTA_SendCmdAok(cmd);
}

bool BTA_ActivateVoiceCommand(void) {
    return BTA_SendCmdAok("P");
}

bool BTA_DisconnectMask(uint8_t mask) {
    char cmd[] = "K,12";
    sprintf(cmd, "K,%02X", mask);
    return BTA_SendCmdAok(cmd);
}

bool BTA_SetMute(bool mute) {
    char cmd[] = "M,1";
    sprintf(cmd, "M,%d", mute);
    return BTA_SendCmdAok(cmd);
}

bool BTA_ClearPaired(void) {
    return BTA_SendCmdAok("U");
}

static bool BTA_GetFixedLength(const char * header, char * target, uint8_t length) {
    uint8_t i;
    if (!BTA_CheckRecv(header)) {
        return false;
    }
    for (i = 0; i < length; i++) {
        target[i] = BTA_ReadByte();
    }
    target[i+1] = '\0';
    while (BTA_ReadByte() != '\n');
    return true;
}

static bool BTA_GetVariableLength(const char * header, char * target, uint8_t length) {
    uint8_t i;
    if (!BTA_CheckRecv(header)) {
        return false;
    }
    for (i = 0; i < length; i++) {
        char inBuffer = BTA_ReadByte();
        if (inBuffer == '\r') {
            target[i] = '\0';
            break;
        }
        target[i] = inBuffer;
    }
    target[i+1] = '\0';
    while (BTA_ReadByte() != '\n');
    return true;
}

static bool BTA_Get1Byte(const char * header, uint8_t * target) {
    char holder[2];
    uint8_t i;
    if (!BTA_CheckRecv(header)) {
        return false;
    }
    for (i = 0; i < 2; i++) {
        holder[i] = BTA_ReadByte();
    }
    *target = (uint8_t) strtol(holder, NULL, 16);
    while (BTA_ReadByte() != '\n');
    return true;
}

static bool BTA_Get2Byte(const char * header, uint16_t * target) {
    char holder[4];
    uint8_t i;
    if (!BTA_CheckRecv(header)) {
        return false;
    }
    for (i = 0; i < 4; i++) {
        holder[i] = BTA_ReadByte();
    }
    *target = (uint16_t) strtol(holder, NULL, 16);
    while (BTA_ReadByte() != '\n');
    return true;
}

bool BTA_GetConfig(struct BTA_Status * status) {
    // Send command
    if (!BTA_SendCmd("D", "*** Settings ***\r\n")) {
        return false;
    }

    // Module addr
    if (!BTA_GetFixedLength("BTA=", status->BTAddr, 12)) {
        return false;
    }

    // Remote addr
    if (!BTA_GetFixedLength("BTAC=", status->BTAddrC, 12)) {
        return false;
    }

    // Name
    if (!BTA_GetVariableLength("BTName=", status->name, 25)) {
        return false;
    }

    // Authen
    if (!BTA_CheckRecv("Authen=")) {
        return false;
    }
    status->authen = (BTA_ReadByte() - '0');
    while (BTA_ReadByte() != '\n');

    // COD
    if (!BTA_GetFixedLength("COD=", status->cod, 6)) {
        return false;
    }

    // Disc mask
    if (!BTA_Get1Byte("DiscoveryMask=", &(status->discMask))) {
        return false;
    }

    // Conn mask
    if (!BTA_Get1Byte("ConnectionMask=", &(status->connMask))) {
        return false;
    }

    // Pin Code
    if (!BTA_GetVariableLength("PinCode=", status->pin, 16)) {
        return false;
    }

    // Audio config
    if (!BTA_Get2Byte("AudioConfig=", &(status->audioConfig))) {
        return false;
    }

    // Route
    if (!BTA_GetVariableLength("AudioRoute=", status->audioRoute, 20)) {
        return false;
    }

    // Codecs enabled
    if (!BTA_Get1Byte("CodecsEnabled=", &(status->codecsEnabled))) {
        return false;
    }

    // Active codec
    if (!BTA_GetVariableLength("AudioCodec=", status->codecActive, 20)) {
        return false;
    }

    // Extended Features
    if (!BTA_Get2Byte("ExtFeatures=", &(status->extendedFeatures))) {
        return false;
    }

    return true;

}
