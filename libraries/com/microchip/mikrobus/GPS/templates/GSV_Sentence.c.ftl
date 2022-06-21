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
// Local (Static) Variables
//********************************************
static uint8_t  GSV_Num_Satellites;
static sentence_state_t  GSV_State = Invalid;
static char GSV1_Sentence [74];
static char GSV2_Sentence [74];
static char GSV3_Sentence [74];

//********************************************
// Functions
//********************************************
void GSV_SetSentence1(char* passedData)
{
    strncpy(GSV1_Sentence, passedData, sizeof(GSV1_Sentence));
}
void GSV_SetSentence2(char* passedData)
{
    strncpy(GSV2_Sentence, passedData, sizeof(GSV2_Sentence));
}
void GSV_SetSentence3(char* passedData)
{
    strncpy(GSV3_Sentence, passedData, sizeof(GSV3_Sentence));
}
bool GSV_Data_Ready(void)
{
    if (GSV_State == Valid)
        return true;
    else
        return false;
}
void Free_GSV_Buffer(void)
{
    GSV_State = Invalid;
}
void Parse_GSV_Sentences(void)
{
    char * Nil;   
    Nil = UTILITY_MyStrtok ((GSV1_Sentence+4), DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    GSV_Num_Satellites = atoi (Nil);
    GSV_State = Valid;
}
uint8_t Get_GSV_Num_Satellites(void)
{
    return (GSV_Num_Satellites);
}
char* Get_GSV_Sat_In_View (uint8_t  index)
{
    char *  Sat_Data;
    uint8_t  fields;
    
    uint8_t  GSV_Sentence_num;   //  there could be up to 4 GSV sentences.
    
    if (index > GSV_Num_Satellites)
        return NULL;
    GSV_Sentence_num = index / 4;
    if (GSV_Sentence_num == 0)
        Sat_Data = &(GSV1_Sentence[6]);
    else if (GSV_Sentence_num == 1)
        Sat_Data = &(GSV2_Sentence[6]);
    else if (GSV_Sentence_num == 2)
        Sat_Data = &(GSV3_Sentence[6]);
    else if (GSV_Sentence_num == 3)
        Sat_Data = NULL;   // don't have space for 4th GSV sentence

    if (Sat_Data != NULL)
    {
        fields = 4*(index % 4) + 3;
        while (fields > 0)
        {
            if (((*Sat_Data) == 0x00)
             || ((*Sat_Data) == ','))
            {
                -- fields;
            }
            ++Sat_Data;
        }
    }
    return (Sat_Data);
}
void Parse_Satellite_Info (char * in, uint8_t  *sat_num, uint8_t *azimuth, uint16_t  *heading,  uint8_t  *snr)
{
    char  * Nil;
    
    if ((in == NULL) || (*in == '*'))
    {
        *sat_num = NULL;
        *azimuth = NULL;
        *heading = NULL;
        *snr     = NULL;
    }
    else
    {
        Nil = UTILITY_MyStrtok (in, DELIMITERS);
        *sat_num = atoi (Nil);
        Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
        *azimuth = atoi (Nil);
        Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
        *heading = atoi (Nil);
        Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
        *snr = atoi (Nil);
    }
}
/**
 End of File
*/