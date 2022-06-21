/*
<#include "MicrochipDisclaimer.ftl">
*/
#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include <stdint.h>
#include "My_String.h"

/* my_strtok */
/* The standard strtok skips over leading terminating characters.  This does 
 * not work parsing NEMA sentences.  There is no whitespace.  Starting on a 
 * terminating character indicates an omitted field.  Instead of skipping past
 * omitted fields, this version instead returns a null string. 
 */

//char *  my_strtok (register char * s1, register char * s2)
char*  my_strtok (register char * s1, const char * s2)
{
	static char *	sp;

	if(!s1)
		s1 = sp;
	if(!s1)
		return NULL;
    if (((*s1) == 0x00) || ((*s1) == ','))
    {
		*sp++ = 0;
        return (NULL);
    }
    //	s1 += strspn(s1, s2);	/* DON'T skip leading delimiters */
	if(!*s1)
		return sp = NULL;
	sp = s1 + strcspn(s1, s2);
	if(*sp)
		*sp++ = 0;
	else
		sp = 0;
	return s1;
}
    

uint8_t my_StrToHex (char string[])
{
    uint8_t  hex, ch;
            
    ch = string [0];
    if (ch <= '9')
        hex = ch - '0';
    else
        hex = (ch - 'A')+10;
    hex <<= 4;
    ch = string [1];
    if (ch <= '9')
        hex += ch - '0';
    else
        hex += (ch - 'A')+10;
    return hex;
}
/**
 End of File
*/