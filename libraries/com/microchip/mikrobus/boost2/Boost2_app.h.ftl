/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BOOST2_H
#define	BOOST2_H

#ifdef __XC
#include <xc.h>
#endif 

#define BOOST2_enable()     ${enPin["LAT"]} = 1
#define BOOST2_disable()    ${enPin["LAT"]} = 0
#define BOOST2_getPowerGoodCondition()  ${pgPin["PORT"]}

#endif	/* BOOST2_H */
