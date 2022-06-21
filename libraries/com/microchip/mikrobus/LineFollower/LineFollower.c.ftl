 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LineFollower.h"
#include "${pinHeader}"
#ifdef __XC
#include <xc.h>
#endif

bool getU1(void){
    return ${U1Port};
}

bool getU2(void){
    return ${U2Port};
}

bool getU3(void){
    return ${U3Port};
}

bool getU4(void){
    return ${U4Port};
}

bool getU5(void){
    return ${U5Port};
}
