/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ${moduleNameUpperCase}_H
#define	${moduleNameUpperCase}_H

#include "swuart_internal.h"
<#if (redirectStdio=="enabled")>
#include <stdio.h>
</#if>

// Macro Declarations
#define ${moduleNameUpperCase}_DataReady  (${moduleNameLowerCase}RxCount)

// Global Variables
extern volatile uint8_t ${moduleNameLowerCase}TxBufferRemaining;
extern volatile uint8_t ${moduleNameLowerCase}RxCount;

// Initialization and Control Function Prototypes
void ${moduleNameUpperCase}_Initialize (void);
bool ${moduleNameUpperCase}_is_tx_ready(void);
bool ${moduleNameUpperCase}_is_rx_ready(void);
bool ${moduleNameUpperCase}_is_tx_done(void);
uint8_t ${moduleNameUpperCase}_Read (void);
void ${moduleNameUpperCase}_Write (uint8_t txdata);

#endif	/* ${moduleNameUpperCase}_H */
