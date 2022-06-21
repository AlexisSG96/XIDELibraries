/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   GSA_Sentence.c
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
<#if (GPS_CLICK_NAME == "GPS_Nano")>
#include "NANOGPS_driver.h"
<#elseif (GPS_CLICK_NAME == "GPS_3")>
#include "GPS3_driver.h"
</#if>
#include "UTILITY_MyString.h"

//********************************************
// Local (Static) Variables
//********************************************
static sentence_state_t  GSA_State = Invalid;
static char  GSA_Sentence [90];
static char* GSA_Fix_Status;
static char* GSA_Fix_Satellites;
static char* Satellites [12];
static char* GSA_Fix_Satellites;
static char* GSA_Pdop;
static char* GSA_Fix_Satellites;
static char* GSA_Hdop;
static char* GSA_Fix_Satellites;
static char* GSA_Vdop;

//********************************************
// Functions
//********************************************
void GSA_SetSentence(char* passedData)
{
    strncpy(GSA_Sentence, passedData, sizeof(GSA_Sentence));
}
bool GSA_Data_Ready (void)
{
    if (GSA_State == Valid)
        return true;
    else
        return false;
}
void Free_GSA_Buffer(void)
{
    GSA_State = Invalid;
    GSA_Fix_Status = NULL;
    GSA_Fix_Satellites = NULL;
}
void Parse_GSA_Sentence(void)
{
    char * SID;
    SID = UTILITY_MyStrtok (GSA_Sentence, DELIMITERS);
    GSA_Fix_Status = UTILITY_MyStrtok (NULL, DELIMITERS);
    GSA_Fix_Status = UTILITY_MyStrtok (NULL, DELIMITERS);
    for (uint8_t i=0; i < 12; i++)
        Satellites [i] = UTILITY_MyStrtok (NULL, DELIMITERS);
    GSA_Pdop = UTILITY_MyStrtok (NULL, DELIMITERS);
    GSA_Hdop = UTILITY_MyStrtok (NULL, DELIMITERS);
    GSA_Vdop = UTILITY_MyStrtok (NULL, DELIMITERS);
    GSA_State = Valid;
}
char* Get_GSA_Fix_Status (void)
{
    return (GSA_Fix_Status);
}
char* Get_GSA_Satellites_Tracked (void)
{
    return (GSA_Fix_Satellites);
}
char* Get_GSA_Satellite (uint8_t  sat_index)
{
    return (Satellites [sat_index]);
}
char* Get_GSA_Pdop(void)
{
    return (GSA_Pdop);
}
char* Get_GSA_Hdop (void)
{
    return (GSA_Hdop);
}
char* Get_GSA_Vdop (void)
{
    return (GSA_Vdop);
}
/**
 End of File
*/
