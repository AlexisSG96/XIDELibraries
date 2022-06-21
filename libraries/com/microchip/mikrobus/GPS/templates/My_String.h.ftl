/*
<#include "MicrochipDisclaimer.ftl">
*/
#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>

char* my_strtok(register char*, const char *);
uint8_t my_StrToHex (char string[]);