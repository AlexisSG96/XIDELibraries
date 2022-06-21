/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RFID_DRIVER_H
#define	RFID_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

// Response Code Flag Interpretation
typedef union
{
    uint8_t flagsBitMap;
    struct {
        unsigned int flagsNotUsedLowBits     :2;
        unsigned int flagReadDataReady       :1;
        unsigned int flagSendDataReady       :1;
        unsigned int flagsNotUsedHighBits    :4;
    };  
}CR95HF_Flagbits_t;

// CR95HF Commands Definition
#define    RFID_DUMMY_EXCHANGE         0x00
#define    RFID_IDN                    0x01
#define    RFID_PROTOCOL_SELECT        0x02
#define    RFID_SEND_RECV              0x04
#define    RFID_IDLE                   0x07
#define    RFID_RDREG                  0x08
#define    RFID_WRREG                  0x09
#define    RFID_BAUDRATE               0x0A
#define    RFID_ECHO                   0x55

<#if (RFid_SSI1PinKey != "") || (RFid_SSI0PinKey != "") || (RFid_INTIPinKey != "")>
void RFID_SpiStartUpSequence (void);
</#if>
<#if (RFid_INTIPinKey != "")>
void RFID_ToggleIntI(void);
</#if>
<#if (RFid_INTOPinKey != "")>
bool RFID_GetIntO(void);
</#if>
void RFID_SendCommand(uint8_t, uint8_t, uint8_t*);
void RFID_SoftwareReset(void);
uint8_t RFID_ReadCommand(uint8_t*);
CR95HF_Flagbits_t RFID_PollCR95HF(void);
void RFID_BlockingReadReadyPollingSoftware(void);
void RFID_BlockingReadReadyPollingHardware(void);
bool RFID_IsReadReadyHardwarePollingNonBlocking(void);
bool RFID_IsReadReadySoftwarePollingNonBlocking(void);

#endif	/* RFID_DRIVER_H */