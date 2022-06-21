 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "RTC6_example.h"
#include "RTC6.h"
#include <stdio.h>
#include <string.h>
#include <time.h>
#include "mcc.h"

void rtc6_example(void) {
    volatile time_t getTime, setTime;

    struct tm *tm_t;

    char buffer[80];

    memset(tm_t, 0, sizeof (tm_t));

    /*** Variable Initializations ***/
    setTime = 1503870020; //Time in Seconds
    getTime = 0; //Time in Seconds   
    while (1) {
        /** Example to Set Time to RTCC */
        rtc6_SetTime(setTime);
        <#if (isAVR == "true")>
		_delay_ms(20);
		<#else>
		__delay_ms(20);
		</#if>

        while (1) {
            /** Example to Get Time from RTCC */
            getTime = rtc6_GetTime();
            tm_t = localtime(&getTime);
            printf("%04d-%02d-%02d %02d:%02d:%02d\n", tm_t->tm_year+1900, tm_t->tm_mon+1, tm_t->tm_mday, tm_t->tm_hour, tm_t->tm_min, tm_t->tm_sec);
            <#if (isAVR == "true")>
			_delay_ms(1000);
			<#else>
			__delay_ms(1000);
			</#if>
        }
    }

}
