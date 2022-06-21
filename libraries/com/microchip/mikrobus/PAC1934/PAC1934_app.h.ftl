/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _PAC1934_CLICK_H
#define _PAC1934_CLICK_H

/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: Macro Declarations
 */

#define BUS_ID          1
#define CH1             1
#define CH2             2
#define CH3             3
#define CH4             4

#define RSENSE          4000 //uOhm
#define PAC1934_ADDRESS 0x10
/**
  Section: PAC1934 Click Driver APIs
 */
void PAC1934_ClickInit(void);
void PAC1934_ClickEnable(void);
void PAC1934_ClickDisable(void);
bool PAC1934_ClickALT(void);

#endif // _PAC1934_CLICK_H