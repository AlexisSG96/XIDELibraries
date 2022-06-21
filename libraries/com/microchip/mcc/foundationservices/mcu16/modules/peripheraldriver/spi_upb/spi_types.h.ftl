/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ${moduleNameUpperCase}_TYPES_H
#define	${moduleNameUpperCase}_TYPES_H

/* SPI interfaces */
typedef enum { 
<#list spiConfgurationNames?keys as config>
    ${spiConfgurationNames[config]["configName"]}<#if config?has_next>,</#if>
</#list>
} ${moduleNameLowerCase}_modes;

#endif	/* ${moduleNameUpperCase}_TYPES_H */
