/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "EXAMPLE_WiFi3.h"
#include "mcc.h"
#include "WiFi3_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"
#include "${pinHeader}"
#include <stdio.h>
#include <ctype.h>
#include <string.h>

//*********************************************************
//          Example Type Defines
//*********************************************************

typedef enum {
    OK,
    ERROR,
    NO_CHANGE,
    FAIL,
    READY,
    UNKNOWN,
    SEND_OK,
} wifi3_GenericResponses_t;

enum StateTable {
    NULL_STATE,
    FRAG_O,
    FRAG_E,
    FRAG_ER,
    FRAG_ERR,
    FRAG_ERRO,
    FRAG_n,
    FRAG_no,
    FRAG_no_,
    FRAG_no_c,
    FRAG_no_ch,
    FRAG_no_cha,
    FRAG_no_chan,
    FRAG_no_chang,
    FRAG_F,
    FRAG_FA,
    FRAG_FAI,
    FRAG_A,
    FRAG_AT,
    FRAG_ATp,
    FRAG_ATpC,
    FRAG_ATpCI,
    FRAG_ATpCIF,
    FRAG_ATpCIFS,
    FRAG_ATpCIFSR,
    BUILD_IP,
    FRAG_r,
    FRAG_re,
    FRAG_rea,
    FRAG_read,
    FRAG_p,
    FRAG_pI,
    FRAG_pIP,
    WAIT_FOR_DATA,
    READ_DATA_LENGTH,
    READ_DATA,
    FRAG_S,
    FRAG_SE,
    FRAG_SEN,
    FRAG_SEND,
    FRAG_SEND_,
    FRAG_SEND_O,
    WAIT_CARRIAGE_RETURN,
    WAIT_NEW_LINE
};
//*********************************************************
//          Local Prototype Functions
//*********************************************************
static void EXAMPLE_Init(void);
static void EXAMPLE_Configure(void);
static void EXAMPLE_blockingWait(uint16_t);
static wifi3_GenericResponses_t EXAMPLE_GetCaptureReceivedMessage(void);
//*********************************************************
//          RX Buffer Variables
//*********************************************************
static char wifi3ReceiveData[WIFI3_MAX_PACKET_SIZE] = {0};
uint8_t wifi3LastSender;
//*********************************************************
//          Local Variables
//*********************************************************
static uint8_t wifi3ReceiveDataIndex = 0;
static char wifi3IpAddress[16] = {0};
static bool wifi3DataReady = false;
static bool wifi3ResponseReady = false;
static wifi3_GenericResponses_t wifi3ResponseId = UNKNOWN;
static wifi3_GenericResponses_t wifi3Response = UNKNOWN;
//*********************************************************
//          Unique Application Variables
//*********************************************************
// Change following information to match your network settings
static const char *SSID = "A&Y";
static const char *password = "H@cker101";
static const char *port = "1337";

//*********************************************************
//          Accessible Example Functions
//*********************************************************

void EXAMPLE_startupWiFi3(void) // Call After System Init; Above while(1) Loop in Main.c
{
    EXAMPLE_Init();
    EXAMPLE_Configure();
}

char* EXAMPLE_runningWiFi3(void) // Call within while(1) loop in Main.c         
{
    if (wifi3DataReady) {
        wifi3DataReady = false;
        return wifi3ReceiveData;
    } else
        return 0;
}

void EXAMPLE_CaptureReceivedMessage(void) // Call in ISR EUSART RX after EUSART_Receive_ISR() 
{

    static uint8_t responseState = NULL_STATE;
    char readCharacter = 0x00;
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    readCharacter = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    // Process reception through state machine
    switch (responseState) {
        case NULL_STATE:
        {
            wifi3Response = NULL_STATE; // Clear response
            if (readCharacter == 'O')
                responseState = FRAG_O;
            if (readCharacter == 'E')
                responseState = FRAG_E;
            if (readCharacter == 'n')
                responseState = FRAG_n;
            if (readCharacter == 'F')
                responseState = FRAG_F;
            if (readCharacter == 'A')
                responseState = FRAG_A;
            if (readCharacter == 'r')
                responseState = FRAG_r;
            if (readCharacter == '+')
                responseState = FRAG_p;
            if (readCharacter == 'S')
                responseState = FRAG_S;
            break;
        }
        case FRAG_O:
        {
            if (readCharacter == 'K') {
                wifi3Response = OK;
                responseState = WAIT_CARRIAGE_RETURN;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_E:
        {
            if (readCharacter == 'R')
                responseState = FRAG_ER;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ER:
        {
            if (readCharacter == 'R')
                responseState = FRAG_ERR;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ERR:
        {
            if (readCharacter == 'O')
                responseState = FRAG_ERRO;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ERRO:
        {
            if (readCharacter == 'R') {
                wifi3Response = ERROR;
                responseState = WAIT_CARRIAGE_RETURN;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_n:
        {
            if (readCharacter == 'o')
                responseState = FRAG_no;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no:
        {
            if (readCharacter == ' ')
                responseState = FRAG_no_;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no_:
        {
            if (readCharacter == 'c')
                responseState = FRAG_no_c;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no_c:
        {
            if (readCharacter == 'h')
                responseState = FRAG_no_ch;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no_ch:
        {
            if (readCharacter == 'a')
                responseState = FRAG_no_cha;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no_cha:
        {
            if (readCharacter == 'n')
                responseState = FRAG_no_chan;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no_chan:
        {
            if (readCharacter == 'g')
                responseState = FRAG_no_chang;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_no_chang:
        {
            if (readCharacter == 'e') {
                wifi3Response = NO_CHANGE;
                responseState = WAIT_CARRIAGE_RETURN;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_F:
        {
            if (readCharacter == 'A')
                responseState = FRAG_FA;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_FA:
        {
            if (readCharacter == 'I')
                responseState = FRAG_FAI;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_FAI:
        {
            if (readCharacter == 'L') {
                wifi3Response = FAIL;
                responseState = WAIT_CARRIAGE_RETURN;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_A:
        {
            if (readCharacter == 'T')
                responseState = FRAG_AT;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_AT:
        {
            if (readCharacter == '+')
                responseState = FRAG_ATp;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ATp:
        {
            if (readCharacter == 'C')
                responseState = FRAG_ATpC;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ATpC:
        {
            if (readCharacter == 'I')
                responseState = FRAG_ATpCI;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ATpCI:
        {
            if (readCharacter == 'F')
                responseState = FRAG_ATpCIF;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ATpCIF:
        {
            if (readCharacter == 'S')
                responseState = FRAG_ATpCIFS;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ATpCIFS:
        {
            if (readCharacter == 'R')
                responseState = FRAG_ATpCIFSR;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_ATpCIFSR:
        {
            if (readCharacter == 10) {
                responseState = BUILD_IP;
                wifi3ReceiveDataIndex = 0;
            } else if (readCharacter == 13) {
                // Do Nothing...
            } else
                responseState = NULL_STATE;
            break;
        }
        case BUILD_IP:
        {
            if (readCharacter == 13) {
                responseState = WAIT_NEW_LINE;
                wifi3Response = OK;
            } else {
                wifi3IpAddress[wifi3ReceiveDataIndex] = readCharacter; // Build IP address
                wifi3ReceiveDataIndex++;
            }
            break;
        }
        case FRAG_r:
        {
            if (readCharacter == 'e')
                responseState = FRAG_re;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_re:
        {
            if (readCharacter == 'a')
                responseState = FRAG_rea;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_rea:
        {
            if (readCharacter == 'd')
                responseState = FRAG_read;
            else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_read:
        {
            if (readCharacter == 'y') {
                wifi3Response = READY;
                responseState = WAIT_CARRIAGE_RETURN;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_p:
        {
            if (readCharacter == 'I') {
                responseState = FRAG_pI;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_pI:
        {
            if (readCharacter == 'P') {
                responseState = FRAG_pIP;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_pIP:
        {
            if (readCharacter == 'D') {
                wifi3ReceiveDataIndex = 0;
                responseState = WAIT_FOR_DATA;
            } else
                responseState = NULL_STATE;
            break;
        }
        case WAIT_FOR_DATA:
        { // Wait for data
            if (wifi3ReceiveDataIndex == 1 && isdigit(readCharacter)) { // Get channel being sent on
                wifi3LastSender = readCharacter - '0';
            }
            if (readCharacter == ',')
                wifi3ReceiveDataIndex++;
            if (wifi3ReceiveDataIndex == 2) {
                responseState = READ_DATA_LENGTH;
                wifi3ReceiveDataIndex = 0;
            }
            break;
        }
        case READ_DATA_LENGTH:
        { // Read data length
            if (readCharacter == ':') {
                responseState = READ_DATA;
            } else {
                // Do Nothing....
            }
            break;
        }
        case READ_DATA:
        {
            if (readCharacter == '\r') {
                if (wifi3ReceiveDataIndex > 0) {
                    wifi3ReceiveData[wifi3ReceiveDataIndex] = 0;
                    wifi3DataReady = true;
                }
                wifi3ReceiveDataIndex = 0;
                responseState = NULL_STATE;
            } else {
                wifi3ReceiveData[wifi3ReceiveDataIndex] = readCharacter; // Get Data
                wifi3ReceiveDataIndex++;
                if (wifi3ReceiveDataIndex == WIFI3_MAX_PACKET_SIZE - 1) {
                    wifi3ReceiveData[wifi3ReceiveDataIndex] = 0;
                    wifi3ReceiveDataIndex = 0;
                    wifi3DataReady = true;
                    responseState = NULL_STATE;
                }
            }
            break;
        }
        case WAIT_CARRIAGE_RETURN:
        {
            if (readCharacter == 13)
                responseState = WAIT_NEW_LINE;
            else
                responseState = NULL_STATE;
            break;
        }
        case WAIT_NEW_LINE:
        {
            if (readCharacter == 10) {
                wifi3ResponseReady = true;
                wifi3ResponseId = wifi3Response;
            }
            responseState = NULL_STATE;
            break;
        }
        case FRAG_S:
        {
            if (readCharacter == 'E') {
                responseState = FRAG_SE;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_SE:
        {
            if (readCharacter == 'N') {
                responseState = FRAG_SEN;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_SEN:
        {
            if (readCharacter == 'D') {
                responseState = FRAG_SEND;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_SEND:
        {
            if (readCharacter == ' ') {
                responseState = FRAG_SEND_;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_SEND_:
        {
            if (readCharacter == 'O') {
                responseState = FRAG_SEND_O;
            } else
                responseState = NULL_STATE;
            break;
        }
        case FRAG_SEND_O:
        {
            if (readCharacter == 'K') {
                wifi3Response = SEND_OK;
                responseState = WAIT_CARRIAGE_RETURN;
            } else
                responseState = NULL_STATE;
            break;
        }
        default:
        {
            responseState = NULL_STATE;
            break;
        }
    }
}
//*********************************************************
//          Local Used Example Functions
//*********************************************************

static void EXAMPLE_Init(void) {
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(EXAMPLE_CaptureReceivedMessage);
    WiFi3_SetPowerDown(true);
    EXAMPLE_blockingWait(500); //  Delay 5 Sec
}

static void EXAMPLE_Configure(void) {
    do {
        WiFi3_SendString("AT+RST\r\n");
        EXAMPLE_blockingWait(100);
    } while (EXAMPLE_GetCaptureReceivedMessage() != READY);
    EXAMPLE_blockingWait(100);

    do {
        WiFi3_SendString("AT+CWMODE=1\r\n");
        EXAMPLE_blockingWait(100);
    } while (EXAMPLE_GetCaptureReceivedMessage() != OK);
    EXAMPLE_blockingWait(100);

    do {
        WiFi3_SendString("AT+CIPMUX=1\r\n");
        EXAMPLE_blockingWait(100);
    } while (EXAMPLE_GetCaptureReceivedMessage() != OK);
    EXAMPLE_blockingWait(100);


    do {
        //AT+CIPSERVER=<mode>,<port><CR><LF>
        WiFi3_SendString("AT+CIPSERVER=1,");
        WiFi3_SendString(port);
        WiFi3_SendString("\r\n");
        EXAMPLE_blockingWait(100);
    } while (EXAMPLE_GetCaptureReceivedMessage() != OK);
    EXAMPLE_blockingWait(100);

    do {
        //AT+CWJAP="SSID","password" <CR><LF>
        WiFi3_SendString("AT+CWJAP=");
        WiFi3_SendString("\"");
        WiFi3_SendString(SSID); // SSID
        WiFi3_SendString("\"");
        WiFi3_SendString(",");
        WiFi3_SendString("\"");
        WiFi3_SendString(password); // Password
        WiFi3_SendString("\"");
        WiFi3_SendString("\r\n");
        EXAMPLE_blockingWait(100);
    } while (EXAMPLE_GetCaptureReceivedMessage() != OK);
    EXAMPLE_blockingWait(100);

    do {
        WiFi3_SendString("AT+CIFSR\r\n");
        EXAMPLE_blockingWait(100);
    } while (EXAMPLE_GetCaptureReceivedMessage() != OK);
    EXAMPLE_blockingWait(100);

}

static void EXAMPLE_blockingWait(uint16_t length) {
    for (uint16_t counter = 0; counter < length; counter++)
        <#if (isAVR == "true")>
		_delay_ms(10);
		<#else>
		__delay_ms(10);
		</#if>
}

void EXAMPLE_transmitWiFi3(uint8_t channel, uint8_t length, char* string) {
    char msg[18];
    sprintf(msg, "AT+CIPSEND=%d,%d\r\n", channel, length);
    WiFi3_SendString(msg);
    <#if (isAVR == "true")>
	_delay_ms(10);
	<#else>
	__delay_ms(10);
	</#if>
    WiFi3_SendString(string);
    while (wifi3Response != SEND_OK) {

    }
}

static wifi3_GenericResponses_t EXAMPLE_GetCaptureReceivedMessage(void) {
    if (wifi3ResponseReady) {
        wifi3ResponseReady = false;
        return wifi3ResponseId;
    } else
        return 0;
}
/**
 End of File
 */

void EXAMPLE_fullWiFi3(){
    EXAMPLE_startupWiFi3();

    while (1) {
        char *ReceivedData = EXAMPLE_runningWiFi3();
        for (int i = 0; ReceivedData[i]; i++) {
            ReceivedData[i] = tolower(ReceivedData[i]);
        }

        if (ReceivedData) {\
            if (!strcmp(ReceivedData, "please")) {
                EXAMPLE_transmitWiFi3(wifi3LastSender, 19, "Was that so hard?\r\n");
            } else {
                EXAMPLE_transmitWiFi3(wifi3LastSender, 42, "Ah ah ah, you didn't say the magic word.\r\n");
            }
        }

    }

}