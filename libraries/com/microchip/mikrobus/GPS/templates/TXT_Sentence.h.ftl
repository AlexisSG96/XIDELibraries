/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   TXT_Sentence.h
 */
#ifndef TXT_SENTENCE_H
#define TXT_SENTENCE_H

#ifdef __XC
#include <xc.h>
#endif

void TXT_SetSentence(char*);
bool  TXT_Data_Ready(void);
void  Free_TXT_Buffer(void);
char* Get_TXT_nMesages(void);
char* Get_TXT_Message(void);
char* Get_TXT_Severity(void);
char* Get_TXT_Text(void);

#endif	/* TXT_SENTENCE_H */