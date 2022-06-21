/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   RMC_Sentence.c
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdlib.h>
#include <stdbool.h>
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
static sentence_state_t  RMC_State;
static char  RMC_Sentence [75];
static char* RMC_Time;
static char* RMC_Fix_Status;
static char* RMC_Latitude;
static char* RMC_Lat_Direction;
static char* RMC_Longitude;
static char* RMC_Long_Direction;
static char* RMC_Speed;
static char* RMC_Track;
static char* RMC_Date;
static char* RMC_Mag_Var;

//********************************************
// Functions
//********************************************
void RMC_SetSentence(char* passedData)
{
    strncpy(RMC_Sentence, passedData, sizeof(RMC_Sentence));
}
bool RMC_Data_Ready (void)
{
    if (RMC_State == Valid)
        return true;
    else
        return false;
}
void Free_RMC_Buffer(void)
{
    RMC_State = Invalid;
    RMC_Time = NULL;
    RMC_Fix_Status = NULL;
    RMC_Latitude = NULL;
    RMC_Lat_Direction = NULL;
    RMC_Longitude = NULL;
    RMC_Long_Direction = NULL;
    RMC_Speed = NULL;
    RMC_Track = NULL;
    RMC_Date = NULL;
    RMC_Mag_Var = NULL;
}
void Parse_RMC_Sentence(void)
{
    RMC_Time           = UTILITY_MyStrtok (RMC_Sentence, DELIMITERS);
    RMC_Time           = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Fix_Status     = UTILITY_MyStrtok (NULL,DELIMITERS);
    RMC_Latitude       = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Lat_Direction  = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Longitude      = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Long_Direction = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Speed          = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Track          = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_Date           = UTILITY_MyStrtok (NULL, ",\n");
    RMC_Mag_Var        = UTILITY_MyStrtok (NULL, DELIMITERS);
    RMC_State = Valid;
}
char* Get_RMC_Date (void)
{
    return  (RMC_Date);
}
char* Get_RMC_Time (void)
{
    return  (RMC_Time);
}
char* Get_RMC_Fix_Status (void)
{
    return  (RMC_Fix_Status);
}
char* Get_RMC_Latitude_Str (void)
{
    return  (RMC_Latitude);
}
char* Get_RMC_Lat_Direction (void)
{
    return  (RMC_Lat_Direction);
}
double Get_RMC_Latitude (void)
{
    char    *Lat_Str;
    double  degrees;
    double  minutes;

    Lat_Str = Get_RMC_Latitude_Str();
    degrees = (*Lat_Str) - '0';
    
    ++Lat_Str;
    degrees *= 10;
    degrees += (*Lat_Str) - '0';
    
    ++Lat_Str;
    minutes = strtod (Lat_Str, NULL);
    degrees += minutes / 60.;
            
    if (*Get_RMC_Lat_Direction() == 'S')
    {
        degrees *= -1.0;
    }
    return degrees;
}
char* Get_RMC_Longitude_Str (void)
{
    return  (RMC_Longitude);
}
char* Get_RMC_Long_Direction (void)
{
    return  (RMC_Long_Direction);
}
double Get_RMC_Longitude (void)
{
    char    *Long_Str;
    double  degrees;
    double  minutes;

    Long_Str = Get_RMC_Longitude_Str();
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
            
    if (*Get_RMC_Long_Direction() == 'W')
    {
        degrees *= -1.0;
    }
    return degrees;
}
char* Get_RMC_Speed (void)
{
    return  (RMC_Speed);
}
char* Get_RMC_Track (void)
{
    return  (RMC_Track);
}
char* Get_RMC_Mag_Var (void)
{
    return  (RMC_Mag_Var);
}
/**
 End of File
*/