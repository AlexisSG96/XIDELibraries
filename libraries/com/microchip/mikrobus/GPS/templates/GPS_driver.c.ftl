/*
<#include "MicrochipDisclaimer.ftl">
*/
<#if (GPS_CLICK_NAME == "GPS_Nano")>
/*
 * File:   NANOGPS_driver.c
 */
<#elseif (GPS_CLICK_NAME == "GPS_3")>
/*
 * File:   GPS3_driver.c
 */
</#if>
#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include "mcc.h"
<#if (GPS_CLICK_NAME == "GPS_Nano")>
#include "NANOGPS_driver.h"
<#elseif (GPS_CLICK_NAME == "GPS_3")>
#include "GPS3_driver.h"
</#if>
<#if (NEMA_GPGGA == "enabled")>
#include "GGA_Sentence.h"
</#if>
<#if (NEMA_GPGLL == "enabled")>
#include "GLL_Sentence.h"
</#if>
<#if (NEMA_GPGSA == "enabled")>
#include "GSA_Sentence.h"
</#if>
<#if (NEMA_GPGSV == "enabled")>
#include "GSV_Sentence.h"
</#if>
<#if (NEMA_GPRMC == "enabled")>
#include "RMC_Sentence.h"
</#if>
<#if (NEMA_GPTXT == "enabled")>
#include "TXT_Sentence.h"
</#if>
<#if (NEMA_GPVTG == "enabled")>
#include "VTG_Sentence.h"
</#if>
#include "UTILITY_MyString.h"

//*********************************************************
//          Local (Static) Variables
//*********************************************************
static char Sentence [90];
static uint8_t Sen_index = 0;
static bool Summing = false;
static uint8_t checksum;
static uint8_t lcs;
static char* Sentence_ID;

//*********************************************************
//          Accessible Driver Functions
//*********************************************************
<#if (GPS_CLICK_NAME == "GPS_3")>
void GPS3_StartUp(void)
{   // WAKEUP signal will be issued when ON_OFF signal goes high
    ${resetPin_TRIS} = 0;
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${resetPin_LAT} = 1;
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
}
</#if>
<#if (GPS_CLICK_NAME == "GPS_Nano")>
void NANOGPS_StartUp(void)
{   // WAKEUP signal will be issued when ON_OFF signal goes high
    ${resetPin_LAT} = 0;
    ${resetPin_TRIS} = 0;
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${resetPin_TRIS} = 1;   // float high 
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${resetPin_TRIS} = 0; 
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    
    ${wakeUpPin_LAT} = 0;
    ${wakeUpPin_TRIS} = 0;
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${wakeUpPin_LAT} = 1;
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${wakeUpPin_LAT} = 0;
    ${wakeUpPin_TRIS} = 1;
}
</#if>
<#if (GPS_CLICK_NAME == "GPS_Nano")>
uint8_t NANOGPS_SendNemaString (char* string)
<#elseif (GPS_CLICK_NAME == "GPS_3")>
uint8_t GPS3_SendNemaString (char* string)
</#if>
{
    uint8_t  nemaCheckSum;
    uint8_t  digit;
    
    uart[${uart_configuration}].Write('$');
    nemaCheckSum = 0;
    while (*string != 0x00)
    {
        nemaCheckSum ^= *string;
        uart[${uart_configuration}].Write(*string);
        ++string;
    }
    uart[${uart_configuration}].Write('*');
    digit = (nemaCheckSum / 0x10);        
    if (digit > 9)
        digit += 'A';
    else
        digit += '0';
    
    uart[${uart_configuration}].Write(digit);
    digit = (nemaCheckSum % 0x10);        
    if (digit > 9)
        digit += 'A';
    else
        digit += '0';
    uart[${uart_configuration}].Write(digit);
    return nemaCheckSum;
}
<#if (GPS_CLICK_NAME == "GPS_Nano")>
void NANOGPS_CollectNemaData (void)
<#elseif (GPS_CLICK_NAME == "GPS_3")>
void GPS3_CollectNemaData (void)
</#if>
{
    char  ch;

    if (uart[${uart_configuration}].DataReady() > 0)  // makes function non-blocking
    {
        ch = uart[${uart_configuration}].Read();
        Sentence [Sen_index++] =  ch;
        
        if (ch == '*')
        {
            Summing = false;
        }
        if (Summing == true)
        {
            checksum ^= ch;
        }
        if (ch == '$')
        {
            Sen_index = 0;
            checksum = 0;
            Summing = true;
        }
        if (ch == '\n')
        {
            lcs = UTILITY_MyStrToHex (&(Sentence [Sen_index - 4]));
            Sentence_ID = UTILITY_MyStrtok (Sentence, ",$*\00");
            if (lcs == checksum)
            {
<#if (NEMA_GPGGA == "enabled")>
                if (strcmp(Sentence_ID, "GPGGA") == 0)
                {
                    Sentence [5] = ',';
                    GGA_SetSentence(Sentence);
                    Parse_GGA_Sentence();
                }
</#if>
<#if (NEMA_GPGLL == "enabled")>
                if (strcmp(Sentence_ID, "GPGLL") == 0)
                {
                    Sentence [5] = ',';
                    GLL_SetSentence(Sentence);
                }
</#if>
<#if (NEMA_GPGSA == "enabled")>
                if (strcmp(Sentence_ID, "GPGSA") == 0)
                {
                    Sentence [5] = ',';
                    GSA_SetSentence(Sentence);
                    Parse_GSA_Sentence();
                }
</#if>
<#if (NEMA_GPGSV == "enabled")>
                if (strcmp(Sentence_ID, "GPGSV") == 0)
                {
                    Sentence [5] = ',';
                    if (Sentence[8] == '1')
                    {
                        GSV_SetSentence1(Sentence);
                    }
                    else if (Sentence[8] == '2')
                    {
                        GSV_SetSentence2(Sentence);
                    }
                    else if (Sentence[8] == '3')
                    {
                        GSV_SetSentence3(Sentence);
                    }
                    if (Sentence [8] == Sentence [6])
                    {
                        Parse_GSV_Sentences();
                    }
                }
</#if>
<#if (NEMA_GPRMC == "enabled")>
                if (strcmp(Sentence_ID, "GPRMC") == 0)
                {
                    Sentence [5] = ',';
                    RMC_SetSentence(Sentence);
                    Parse_RMC_Sentence();
                }
</#if>
<#if (NEMA_GPTXT == "enabled")>
                if (strcmp(Sentence_ID, "GPTXT") == 0)
                {
                    Sentence [5] = ',';
                    TXT_SetSentence(Sentence);
                }
</#if>
<#if (NEMA_GPVTG == "enabled")>
                if (strcmp(Sentence_ID, "GPVTG") == 0)
                {
                    Sentence [5] = ',';
                    Parse_VTG_Sentence();
                }
</#if>
            }
        }
    }
}
/**
 End of File
*/