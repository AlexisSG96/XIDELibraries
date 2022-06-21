 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef FAN3_H
#define	FAN3_H

typedef enum
{
    Off = 0,
    Speed1,
    Speed2,
    Speed3,
    Speed4,
    Speed5,
    Speed6,
    Speed7          
} FAN_SPEED;

 void Fan3_Initialize(void);
 void Fan3_SetFanSpeed(FAN_SPEED newSpeed);	

#endif // FAN3_H