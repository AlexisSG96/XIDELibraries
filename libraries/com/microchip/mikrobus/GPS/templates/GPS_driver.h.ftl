/*
<#include "MicrochipDisclaimer.ftl">
*/
<#if (GPS_CLICK_NAME == "GPS_Nano")>
/*
 * File:   NANOGPS_driver.h
 */
#ifndef DRIVER_NANOGPS_H
#define	DRIVER_NANOGPS_H
<#elseif (GPS_CLICK_NAME == "GPS_3")>
/*
 * File:   GPS3_driver.h
 */
#ifndef DRIVER_GPS3_H
#define	DRIVER_GPS3_H
</#if>

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

//********************************************
// (Global) Define used for GPS_Sentences
//********************************************
#define  DELIMITERS  "*,\n\x00"
//********************************************
// Typedef used for GPS_Sentences State
//********************************************
typedef enum sentence_State {Invalid, Valid} sentence_state_t;

<#if (GPS_CLICK_NAME == "GPS_Nano")>
void NANOGPS_StartUp(void);
uint8_t NANOGPS_SendNemaString (char*);
void NANOGPS_CollectNemaData (void);
<#elseif (GPS_CLICK_NAME == "GPS_3")>
void GPS3_StartUp(void);
uint8_t GPS3_SendNemaString (char*);
void GPS3_CollectNemaData (void);
</#if>

<#if (GPS_CLICK_NAME == "GPS_Nano")>
#endif	/* DRIVER_NANOGPS_H */
<#elseif (GPS_CLICK_NAME == "GPS_3")>
#endif	/* DRIVER_GPS3_H */
</#if>