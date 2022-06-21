 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef BTA_H
#define	BTA_H

#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

struct BTA_Status {
    char BTAddr[13];
    char BTAddrC[13];
    char name[26];
    uint8_t authen;
    char cod[7];
    uint8_t discMask;
    uint8_t connMask;
    char pin[17];
    uint16_t audioConfig;
    char audioRoute[21];
    uint8_t codecsEnabled;
    char codecActive[21];
    uint16_t extendedFeatures;
};

const char aokStr[] = "AOK";

void BTA_Initialize(void);

void BTA_Reboot(void);
void BTA_RestoreFactoryDefaults(void);

bool BTA_GetConfig(struct BTA_Status * status);

bool BTA_SetName(const char * name);
bool BTA_SetCOD(const char * COD);
bool BTA_SetExtendedFeatures(uint16_t features);
bool BTA_SetAuthentication(uint8_t authentication);
bool BTA_SetDiscoveryMask(uint8_t mask);
bool BTA_SetConnectionMask(uint8_t mask);
bool BTA_DisconnectMask(uint8_t mask);
bool BTA_SetPin(const char * pin);
bool BTA_SetDiscoverable(bool discoverable);
bool BTA_ClearPaired(void);

bool BTA_SetRouting(uint8_t A2DP, uint8_t bits, uint8_t samples);
bool BTA_SetMicGain(uint8_t micA, uint8_t micB);
bool BTA_SetSpeakerGain(uint8_t gain);
bool BTA_SetToneGain(uint8_t gain);

bool BTA_IncreaseVolume(void);
bool BTA_DecreaseVolume(void);
bool BTA_NextTrack(void);
bool BTA_PreviousTrack(void);
bool BTA_PausePlay(void);

bool BTA_CallNumber(const char * number);
bool BTA_Redial(void);
bool BTA_AttemptReconnect(void);
bool BTA_AcceptCall(void);
bool BTA_RejectCall(void);
bool BTA_TerminateHeldCalls(void);
bool BTA_TerminateActiveCalls(void);
bool BTA_PutOnHold(void);
bool BTA_AddHoldToActive(void);
bool BTA_ConnectCallsAndDisconnect(void);
bool BTA_TransferActiveCall(uint8_t target);
bool BTA_ActivateVoiceCommand(void);
bool BTA_SetMute(bool mute);

#endif
