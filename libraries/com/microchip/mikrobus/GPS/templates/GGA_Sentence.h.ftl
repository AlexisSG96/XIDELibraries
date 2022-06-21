/*
<#include "MicrochipDisclaimer.ftl">
*/

/*
 * File:   GGA_Sentence.h
 */
#ifndef GGA_SENTENCE_H
#define GGA_SENTENCE_H

void GGA_SetSentence(char*);
void Parse_GGA_Sentence(void);
bool GGA_Data_Ready(void);
void Free_GGA_Buffer(void);
char* Get_GGA_Fix_Time(void);
char* Get_GGA_Latitude_Str(void);
char* Get_GGA_Latitude_Direction(void);
double Get_GGA_Latitude(void);
char* Get_GGA_Longitude_Str(void);
char* Get_GGA_Longitude_Direction(void);
double Get_GGA_Longitude(void);
char* Get_GGA_Fix_Quality(void);

#endif	/* GGA_SENTENCE_H */