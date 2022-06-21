/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RELAY_H
#define	RELAY_H

#ifdef __XC
#include <xc.h>
#endif

void RELAY_RL1_Engage(void);
void RELAY_RL1_Disengage(void);
void RELAY_RL2_Engage(void);
void RELAY_RL2_Disengage(void);

#endif	/* RELAY_H */