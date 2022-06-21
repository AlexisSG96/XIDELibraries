/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   RMC_Sentence.h
 */
#ifndef RMC_SENTENCE_H
#define RMC_SENTENCE_H

#ifdef __XC
#include <xc.h>
#endif

void RMC_SetSentence(char*);
void Parse_RMC_Sentence(void);
bool RMC_Data_Ready(void);
void Free_RMC_Buffer(void);
char* Get_RMC_Date(void);
char* Get_RMC_Time(void);
char* Get_RMC_Fix_Status(void);
char* Get_RMC_Latitude_Str(void);
char* Get_RMC_Lat_Direction(void);
double Get_RMC_Latitude(void);
char* Get_RMC_Longitude_Str(void);
char* Get_RMC_Long_Direction(void);
double Get_RMC_Longitude(void);
char* Get_RMC_Speed(void);
char* Get_RMC_Track(void);
char* Get_RMC_Mag_Var(void);

#endif	/* RMC_SENTENCE_H */