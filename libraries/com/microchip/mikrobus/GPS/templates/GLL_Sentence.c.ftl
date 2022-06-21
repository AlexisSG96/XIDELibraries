/*
<#include "MicrochipDisclaimer.ftl">
*/

/*
 * File:   GSV_Sentence.c
 * Author: C08156
 *
 * Created on September 30, 2016, 2:19 PM
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
<#if (GPS_CLICK_NAME == "GPS_Nano")>
#include "NANOGPS_driver.h"
<#elseif (GPS_CLICK_NAME == "GPS_3")>
#include "GPS3_driver.h"
</#if>
#include "UTILITY_MyString.h"

//********************************************
// Local (Static) Variables
//********************************************
static sentence_state_t  GLL_State = Invalid;
static char  GLL_Sentence [50];
static char* GLL_Latitude;
static char* GLL_Lat_Direction;
static char* GLL_Longitude;
static char* GLL_Long_Direction;

//********************************************
// Functions
//********************************************
void GLL_SetSentence(char* passedData)
{
    strncpy(GLL_Sentence, passedData, sizeof(GLL_Sentence));
}
bool GLL_Data_Ready(void)
{
    if (GLL_State == Valid)
        return true;
    else
        return false;
}
void Free_GLL_Buffer(void)
{
    GLL_State = Invalid;
    GLL_Latitude       = NULL;
    GLL_Lat_Direction  = NULL;
    GLL_Longitude      = NULL;
    GLL_Long_Direction = NULL;
}
void Parse_GLL_Sentence(void)
{
    char* Nil;   
    Nil = UTILITY_MyStrtok (GLL_Sentence, DELIMITERS);
    GLL_Latitude = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    GLL_Lat_Direction = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    GLL_Longitude = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    GLL_Long_Direction = UTILITY_MyStrtok (NULL, DELIMITERS);
}
char* Get_GLL_Latitude(void)
{
    return GLL_Latitude;
}
char* Get_GLL_Lat_Direction(void)
{
    return GLL_Lat_Direction;
}
char* Get_GLL_Longitude(void)
{
    return GLL_Longitude;
}
char* Get_GLL_Long_Direction(void)
{
    return GLL_Long_Direction;
}
/**
 End of File
*/