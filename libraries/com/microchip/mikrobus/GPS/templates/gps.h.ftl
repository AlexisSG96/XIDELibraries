/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef GPS_H
#define	GPS_H
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "My_String.h"
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

<#if (NEMA_GPGGA == "Enabled")>
#include "GGA_Sentence.h"
</#if>
<#if (NEMA_GPGLL == "Enabled")>
#include "GLL_Sentence.h"
</#if>
<#if (NEMA_GPGSA == "Enabled")>
#include "GSA_Sentence.h"
</#if>
<#if (NEMA_GPGSV == "Enabled")>
#include "GSV_Sentence.h"
</#if>
<#if (NEMA_GPRMC == "Enabled")>
#include "RMC_Sentence.h"
</#if>
<#if (NEMA_GPTXT == "Enabled")>
#include "TXT_Sentence.h"
</#if>
<#if (NEMA_GPVTG == "Enabled")>
#include "VTG_Sentence.h"
</#if>

//#include "debug_uart.h"

#define  DELIMITERS  "*,\n\x00"

<#if (NEMA_GPGGA == "Enabled")>
extern char  GGA_Sentence [];
void Parse_GGA_Sentence();
</#if>
<#if (NEMA_GPGSA == "Enabled")>
extern char  GSA_Sentence [];
void Parse_GSA_Sentence();
</#if>
<#if (NEMA_GPGSV == "Enabled")>
extern char    GSV1_Sentence [];
extern char    GSV2_Sentence [];
extern char    GSV3_Sentence [];
extern char    GSV4_Sentence [];
</#if>
<#if (NEMA_GPRMC == "Enabled")>
extern char  RMC_Sentence [];
</#if>

<#if (GPS_CLICK_NAME == "GPS_3")>
void GPS_3_Initialize ()
</#if>
<#if (GPS_CLICK_NAME == "GPS_Nano")>
void GPS_Nano_Initialize(void);
</#if>
<#if (NEMA_GPGSV == "Enabled")>
void Parse_GSV_Sentences(void);
</#if>
<#if (NEMA_GPRMC == "Enabled")>
void Parse_RMC_Sentence(void);
</#if>
<#if (NEMA_GPVTG == "Enabled")>
void Parse_VTG_Sentence (void);
</#if>

void Collect_NEMA_Data (void);


typedef enum sentence_State {Invalid, Valid} sentence_state_t;


#endif	/* GPS_H */

