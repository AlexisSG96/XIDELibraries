 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LineFollower.h"
#include <stdio.h>

void LineFollower_example(void) {
    bool u1_now = getU1();
    bool u2_now = getU2();
    bool u3_now = getU3();
    bool u4_now = getU4();
    bool u5_now = getU5();
    
    if(u5_now && !u4_now && !u3_now && !u2_now && !u1_now){
        printf("Soft Right \n\r");
    }
    else if(u5_now && u4_now && !u3_now && !u2_now && !u1_now){
        printf("Medium Right \n\r");    
    }
    else if(u5_now && u4_now && u3_now && !u2_now && !u1_now){
        printf("Hard Right \n\r");
    }
    else if(!u5_now && !u4_now && u3_now && u2_now && u1_now){
        printf("Hard Left \n\r");
    }
    else if(!u5_now && !u4_now && !u3_now && u2_now && u1_now){
        printf("Medium Left \n\r");
    }
    else if(!u5_now && !u4_now && !u3_now && !u2_now && u1_now){
        printf("Soft Left \n\r");
    }
    else if(u5_now && (u2_now || u3_now) && !u1_now){
        printf("Hard Right \n\r");
    }
    else if(!u5_now && (u4_now || u3_now) && u1_now){    
        printf("Hard Left \n\r");
    }
    else{
        printf("Straight \n\r");
    }
}



