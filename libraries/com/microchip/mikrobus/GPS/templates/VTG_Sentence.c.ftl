/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   GSV_Sentence.c
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
// Local (static) Variables 
//********************************************
static sentence_state_t  VTG_State = Invalid;
static char  VTG_Sentence [60];
static char* VTG_True_Track;
static char* VTG_Mag_Track;
static char* VTG_Ground_Speed_Kts;
static char* VTG_Ground_Speed_Kms;

//********************************************
// Local (static) Variables 
//********************************************
void VTG_SetSentence(char* passedData)
{
    strncpy(VTG_Sentence, passedData, sizeof(VTG_Sentence));
}
bool VTG_Data_Ready (void)
{
    if (VTG_State == Valid)
        return true;
    else
        return false;
}
void Free_VTG_Buffer(void)
{
    VTG_State = Invalid;
    VTG_True_Track = NULL;
    VTG_Mag_Track  = NULL;
    VTG_Ground_Speed_Kts = NULL;
    VTG_Ground_Speed_Kms = NULL;
}
void Parse_VTG_Sentence(void)
{
    char * Nil;   

    Nil = UTILITY_MyStrtok (VTG_Sentence, DELIMITERS);
    VTG_True_Track = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    VTG_Mag_Track = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    VTG_Ground_Speed_Kts = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    VTG_Ground_Speed_Kms = UTILITY_MyStrtok (NULL, DELIMITERS);
    VTG_State = Valid;
}
char* Get_VTG_True_Track (void)
{
    return VTG_True_Track;
}
char* Get_VTG_Mag_Track (void)
{
    return VTG_Mag_Track;
}
char* Get_VTG_Ground_Speed_Kts (void)
{
    return VTG_Ground_Speed_Kts;
}
char* Get_VTG_Ground_Speed_Kms (void)
{
    return VTG_Ground_Speed_Kms;
}
/**
 End of File
*/