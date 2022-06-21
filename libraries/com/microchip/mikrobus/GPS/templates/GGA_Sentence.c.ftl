/*
<#include "MicrochipDisclaimer.ftl">
*/

/*
 * File:   GGA_Sentence.c
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
static sentence_state_t  GGA_State;
static char  GGA_Sentence [75];
static char* GGA_Latitude;
static char* GGA_Lat_Direction;
static char* GGA_Longitude;
static char* GGA_Long_Direction;
static char* GGA_Fix_Time;
static char* GGA_Fix_Valid;
static char* GGA_Fix_Quality;
static char* GGA_Satellites_Tracked;
static char* GGA_Hdop;
static char* GGA_Altitude;
static char* GGA_Height;

//********************************************
// Functions
//********************************************
void GGA_SetSentence(char* passedData)
{
    strncpy(GGA_Sentence, passedData, sizeof(GGA_Sentence));
}
bool  GGA_Data_Ready(void)
{
    if (GGA_State == Valid)
        return true;
    else
        return false;
}
void Free_GGA_Buffer(void)
{
    GGA_State = Invalid;
    GGA_Latitude = NULL;
    GGA_Lat_Direction = NULL;
    GGA_Longitude = NULL;
    GGA_Long_Direction = NULL;
    GGA_Fix_Time = NULL;
    GGA_Fix_Valid = NULL;
    GGA_Fix_Quality = NULL;
    GGA_Satellites_Tracked = NULL;
    GGA_Hdop = NULL;
    GGA_Altitude = NULL;
    GGA_Height = NULL;
}
void Parse_GGA_Sentence(void)
{
    char* SID;
    SID = UTILITY_MyStrtok (GGA_Sentence, DELIMITERS);
    GGA_Fix_Time = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Latitude = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Lat_Direction = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Longitude = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Long_Direction = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Fix_Quality = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Satellites_Tracked = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Hdop = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Altitude = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_Height = UTILITY_MyStrtok (NULL, DELIMITERS);
    GGA_State = Valid;
}
char* Get_GGA_Fix_Time(void)
{
    return (GGA_Fix_Time);
}
char* Get_GGA_Latitude_Str(void)
{
    return (GGA_Latitude);
}
char* Get_GGA_Latitude_Direction(void)
{
    return (GGA_Lat_Direction);
}
double Get_GGA_Latitude(void)
{
    char    *Lat_Str;
    double  degrees;
    double  minutes;

    Lat_Str = Get_GGA_Latitude_Str();
    degrees = (*Lat_Str) - '0';
    
    ++Lat_Str;
    degrees *= 10;
    degrees += (*Lat_Str) - '0';
    
    ++Lat_Str;
    minutes = strtod (Lat_Str, NULL);
    degrees += minutes / 60.;
            
    if (*Get_GGA_Latitude_Direction() == 'S')
        degrees *= -1.0;

    return degrees;
}
char* Get_GGA_Longitude_Str(void)
{
    return (GGA_Longitude);
}
char* Get_GGA_Longitude_Direction(void)
{
    return (GGA_Long_Direction);
}
double Get_GGA_Longitude (void)
{
    char    *Long_Str;
    double  degrees;
    double  minutes;

    Long_Str = Get_GGA_Longitude_Str();
    degrees = (*Long_Str) - '0';
    
    ++Long_Str;
    degrees *= 10;
    degrees += (*Long_Str) - '0';
    
    ++Long_Str;
    degrees *= 10;
    degrees += (*Long_Str) - '0';
    
    ++Long_Str;
    minutes = strtod (Long_Str, NULL);
    degrees += minutes / 60.;
            
    if (*Get_GGA_Longitude_Direction() == 'W')
        degrees *= -1.0;

    return degrees;
}
char* Get_GGA_Fix_Quality (void)
{
    return (GGA_Latitude);
}
/**
 End of File
*/