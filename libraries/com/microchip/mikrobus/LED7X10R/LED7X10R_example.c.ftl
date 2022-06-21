 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "mcc.h"
static uint8_t frame[7][2];


void LED7X10R_DrawRow(uint8_t row, uint16_t col){
    if(row == 1)
        row = 8;
    
    frame[row - 2][1] = col;
    frame[row - 2][col < 32] = col >> 5*(col > 31);
}

void LED7X10R_Display(void){
    LED7X10R_Write(frame);    
}

void LED7X10R_Freeze(uint8_t time){
    for(int i = 0; i < time; i++){
        LED7X10R_Display();
        <#if (isAVR == "true")>
		_delay_ms(1);
		<#else>
		__delay_ms(1);
		</#if>
    }
}

void LED7X10R_Example(void){
    LED7X10R_DrawRow(1,0x1D1);
    LED7X10R_DrawRow(2,0x9B);
    LED7X10R_DrawRow(3,0x95);
    LED7X10R_DrawRow(4,0x95);
    LED7X10R_DrawRow(5,0x91);
    LED7X10R_DrawRow(6,0x91);
    LED7X10R_DrawRow(7,0x1D1);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1CE);
    LED7X10R_DrawRow(2,0x224);
    LED7X10R_DrawRow(3,0x24);
    LED7X10R_DrawRow(4,0x24);
    LED7X10R_DrawRow(5,0x24);
    LED7X10R_DrawRow(6,0x224);
    LED7X10R_DrawRow(7,0x1CE);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1EE);
    LED7X10R_DrawRow(2,0x231);
    LED7X10R_DrawRow(3,0x221);
    LED7X10R_DrawRow(4,0x1E1);
    LED7X10R_DrawRow(5,0xA1);
    LED7X10R_DrawRow(6,0x131);
    LED7X10R_DrawRow(7,0x22E);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1CF);
    LED7X10R_DrawRow(2,0x231);
    LED7X10R_DrawRow(3,0x231);
    LED7X10R_DrawRow(4,0x22F);
    LED7X10R_DrawRow(5,0x225);
    LED7X10R_DrawRow(6,0x229);
    LED7X10R_DrawRow(7,0x1D1);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1CE);
    LED7X10R_DrawRow(2,0x231);
    LED7X10R_DrawRow(3,0x31);
    LED7X10R_DrawRow(4,0x31);
    LED7X10R_DrawRow(5,0x31);
    LED7X10R_DrawRow(6,0x231);
    LED7X10R_DrawRow(7,0x1CE);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x22E);
    LED7X10R_DrawRow(2,0x231);
    LED7X10R_DrawRow(3,0x221);
    LED7X10R_DrawRow(4,0x3E1);
    LED7X10R_DrawRow(5,0x221);
    LED7X10R_DrawRow(6,0x231);
    LED7X10R_DrawRow(7,0x22E);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1D1);
    LED7X10R_DrawRow(2,0x91);
    LED7X10R_DrawRow(3,0x91);
    LED7X10R_DrawRow(4,0x9F);
    LED7X10R_DrawRow(5,0x91);
    LED7X10R_DrawRow(6,0x91);
    LED7X10R_DrawRow(7,0x1D1);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1EE);
    LED7X10R_DrawRow(2,0x224);
    LED7X10R_DrawRow(3,0x224);
    LED7X10R_DrawRow(4,0x1E4);
    LED7X10R_DrawRow(5,0x24);
    LED7X10R_DrawRow(6,0x24);
    LED7X10R_DrawRow(7,0x2E);
    LED7X10R_Freeze(900);
    
    LED7X10R_DrawRow(1,0x1FE);
    LED7X10R_DrawRow(2,0x3B7);
    LED7X10R_DrawRow(3,0x327);
    LED7X10R_DrawRow(4,0x34B);
    LED7X10R_DrawRow(5,0x25B);
    LED7X10R_DrawRow(6,0x2F9);
    LED7X10R_DrawRow(7,0x1FE);
    LED7X10R_Freeze(2000);
}