/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   GLL_Sentence.h
 */
#ifndef GLL_SENTENCE_H
#define GLL_SENTENCE_H

void GLL_SetSentence(char*);
bool GLL_Data_Ready(void);
void Free_GLL_Buffer(void);
void Parse_GLL_Sentence(void);
char* Get_GLL_Latitude (void);
char* Get_GLL_Lat_Direction (void);
char* Get_GLL_Longitude(void);
char* Get_GLL_Long_Direction (void);

#endif	/* GLL_SENTENCE_H */