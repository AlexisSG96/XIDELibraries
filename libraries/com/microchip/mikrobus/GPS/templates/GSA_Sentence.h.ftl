/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   GSA_Sentence.h
 */
#ifndef GSA_SENTENCE_H
#define GSA_SENTENCE_H

#include <stdint.h>
#include <stdbool.h>

void GSA_SetSentence(char*);
void Parse_GSA_Sentence(void);
bool GSA_Data_Ready(void);
void Free_GSA_Buffer(void);
char* Get_GSA_Satellites_Tracked(void);
char* Get_GSA_Satellite (uint8_t);
char* Get_GSA_Fix_Status(void);
char* Get_GSA_Hdop(void);
char* Get_GSA_Pdop(void);
char* Get_GSA_Vdop(void);

#endif	/* GSA_SENTENCE_H */