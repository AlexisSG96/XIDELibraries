/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   TXT_Sentence.c
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
static sentence_state_t  TXT_State;
static char   TXT_Sentence [36];
static char* TXT_nMessages;
static char* TXT_Message_Num;
static char* TXT_Severity;
static char* TXT_Text;

//********************************************
// Functions
//********************************************
void TXT_SetSentence(char* passedData)
{
    strncpy(TXT_Sentence, passedData, sizeof(TXT_Sentence));
}
bool TXT_Data_Ready (void)
{
    if (TXT_State == Valid)
        return true;
    else
        return false;
}
void Free_TXT_Buffer(void)
{
    TXT_State = Invalid;
    TXT_nMessages   = NULL;
    TXT_Message_Num = NULL;
    TXT_Severity    = NULL;
    TXT_Text        = NULL;
}
void Parse_TXT_Sentence(void)
{
    char * Nil;   

    Nil = UTILITY_MyStrtok (TXT_Sentence, DELIMITERS);
    Nil = UTILITY_MyStrtok (TXT_Sentence, DELIMITERS);
    TXT_nMessages = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    TXT_Message_Num = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    TXT_Severity = UTILITY_MyStrtok (NULL, DELIMITERS);
    Nil = UTILITY_MyStrtok (NULL, DELIMITERS);
    TXT_Text = UTILITY_MyStrtok (NULL, DELIMITERS);
}
char* Get_TXT_nMesages (void)
{
    return TXT_nMessages;
}
char* Get_TXT_Message_Num (void)
{
    return TXT_Message_Num;
}
char* Get_TXT_Severity (void)
{
    return TXT_Severity;
}
char* Get_TXT_Text (void)
{
    return TXT_Text;
}
/**
 End of File
*/