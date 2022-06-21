/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   VTG_Sentence.h
 */
#ifndef VTG_SENTENCE_H
#define VTG_SENTENCE_H

#ifdef __XC
#include <xc.h>
#endif

void Parse_VTG_Sentence(void);
void VTG_SetSentence(char*);
bool VTG_Data_Ready(void);
void Free_VTG_Buffer(void);
char* Get_VTG_True_Track(void);
char* Get_VTG_Mag_Track(void);
char* Get_VTG_Ground_Speed_Kts(void);
char* Get_VTG_Ground_Speed_Kms(void);

#endif	/* VTG_SENTENCE_H */