/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   GSV_Sentence.c
 */
#ifndef GSV_SENTENCE_H
#define GSV_SENTENCE_H

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
#include <stdbool.h>

void GSV_SetSentence1(char*);
void GSV_SetSentence2(char*);
void GSV_SetSentence3(char*);
void Parse_GSV_Sentences(void);
bool GSV_Data_Ready (void);
void Free_GSV_Buffer(void);
uint8_t Get_GSV_Num_Satellites (void);
char* Get_GSV_Sat_In_View (uint8_t);
void Parse_Satellite_Info (char*, uint8_t*, uint8_t *, uint16_t*, uint8_t*);

#endif	/* GSV_SENTENCE_H */