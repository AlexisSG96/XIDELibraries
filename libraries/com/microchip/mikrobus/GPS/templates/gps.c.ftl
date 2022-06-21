/*
<#include "MicrochipDisclaimer.ftl">
*/


#include "mcc.h"
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include "gps.h"
//#include "debug_uart.h"
#include "My_String.h"
#include "drivers/uart.h"

uint8_t Sen_index = 0;
char Sentence [90];
char* Sentence_ID;

<#if (NEMA_GPGGA == "Enabled")>
extern sentence_state_t GGA_State;
extern char GGA_Sentence [];
</#if>

<#if (NEMA_GPGLL == "Enabled")>
extern  char  GLL_Sentence [];
extern  sentence_state_t  GLL_State;
</#if>

<#if (NEMA_GPGSA == "Enabled")>
extern  sentence_state_t  GSA_State;
char  GSA_Sentence [];
</#if>

<#if (NEMA_GPGSV == "Enabled")>
extern  sentence_state_t  GSV_State;
extern  char  GSV1_Sentence [];
extern  char  GSV2_Sentence [];
extern  char  GSV3_Sentence [];
//extern  char  GSV4_Sentence [];
</#if>
        
<#if (NEMA_GPRMC == "Enabled")>
extern  sentence_state_t  RMC_State;
extern  char  RMC_Sentence [];
</#if>
        
<#if (NEMA_GPTXT == "Enabled")>
extern  sentence_state_t  TXT_State;
extern  char  TXT_Sentence [];
</#if>

<#if (NEMA_GPVTG == "Enabled")>
extern  sentence_state_t  VTG_State;
extern  char  VTG_Sentence [];
</#if>

<#if (GPS_CLICK_NAME == "GPS_3")>
void GPS_3_Initialize ()
{
  // WAKEUP signal will be issued when ON_OFF signal goes high
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
void GPS_Nano_Initialize ()
{
    // Init_UART ();  // debug uart

    
  // WAKEUP signal will be issued when ON_OFF signal goes high
    ${resetPin_TRIS} = 0;           // Make Reset Pin Output
    ${resetPin_LAT} = 0;            // Drive Reset Pin low
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${resetPin_TRIS} = 1;           // Allow Pin to Float as Input
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${resetPin_TRIS} = 0;           // Return to Output; Drive Low
          
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>

    ${onOffPin_TRIS} = 0;           // Make Pwr Pin Output   
    ${onOffPin_LAT} = 0;            // Drive Low
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${onOffPin_LAT} = 1;             // Drive High
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    ${onOffPin_LAT} = 0;             // Return Low
    ${onOffPin_TRIS} = 1;    // Allow Pin to Float
}
</#if>

bool Summing = false;

uint8_t   checksum;
uint8_t   lcs;
char  ch;

#define ESC   0x1B

    
void Collect_NEMA_Data(void)
{
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
            lcs = my_StrToHex (&(Sentence [Sen_index - 4]));
            Sentence_ID = my_strtok (Sentence, ",$*\00");
            if (lcs == checksum)
            {
<#if (NEMA_GPGGA == "Enabled")>
                if (strcmp(Sentence_ID, "GPGGA") == 0)
                {
                    Sentence [5] = ',';
                    strcpy (GGA_Sentence, Sentence);
                        Parse_GGA_Sentence();
                        GGA_State = Valid;
                }
</#if>
<#if (NEMA_GPGLL == "Enabled")>
                if (strcmp(Sentence_ID, "GPGLL") == 0)
                {
                    Sentence [5] = ',';
                    strcpy (GLL_Sentence, Sentence);
                }
</#if>
<#if (NEMA_GPGSA == "Enabled")>
                if (strcmp(Sentence_ID, "GPGSA") == 0)
                {
                    Sentence [5] = ',';
                    strcpy (GSA_Sentence, Sentence);
                        Parse_GSA_Sentence();
                        GSA_State = Valid;
                }
</#if>
<#if (NEMA_GPGSV == "Enabled")>
                if (strcmp(Sentence_ID, "GPGSV") == 0)
                {
                    Sentence [5] = ',';
                        if (Sentence[8] == '1')
                            strcpy (GSV1_Sentence, Sentence);
                        else if (Sentence[8] == '2')
                            strcpy (GSV2_Sentence, Sentence);
                        else if (Sentence[8] == '3')
                            strcpy (GSV3_Sentence, Sentence);
//                        else if (Sentence[8] == '4')
//                            strcpy (GSV4_Sentence, Sentence);
                        if (Sentence [8] == Sentence [6])
                        {
                            Parse_GSV_Sentences();
                            GSV_State = Valid;
                        }
                }
</#if>
<#if (NEMA_GPRMC == "Enabled")>
                if (strcmp(Sentence_ID, "GPRMC") == 0)
                {
                    Sentence [5] = ',';
                    strcpy (RMC_Sentence, Sentence);
                    Parse_RMC_Sentence();
                    RMC_State = Valid;
                }
</#if>
<#if (NEMA_GPTXT == "Enabled")>
                if (strcmp(Sentence_ID, "GPTXT") == 0)
                {
                    Sentence [5] = ',';
                    strcpy (TXT_Sentence, Sentence);
                }
</#if>
<#if (NEMA_GPVTG == "Enabled")>
                if (strcmp(Sentence_ID, "GPVTG") == 0)
                {
                    Sentence [5] = ',';
                    strcpy (VTG_Sentence, Sentence);
                    Parse_VTG_Sentence();
                    VTG_State = Valid;
                }
</#if>
            }
        }
    }
}
