/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "mcc.h" // Needed for _XTAL_FREQ
#include "drivers/${I2CFunctions["simpleheader"]}"
#include "EXPAND2.h"

#define I2C_ADDRESS     0x20

typedef enum {
    IO_DIRA = 0x00,IO_POLA = 0x02,INT_ENA = 0x04,nINT_EDGEA = 0x06,INT_CONA = 0x08,IO_CONA = 0x0A,PULL_UPA = 0x0C,INT_FLAGA = 0x0E,INT_CAPA = 0x10,GPIOA = 0x12,OLATA = 0x14, // GPIOA
    IO_DIRB = 0x01,IO_POLB = 0x03,INT_ENB = 0x05,nINT_EDGEB = 0x07,INT_CONB = 0x09,IO_CONB = 0x0B,PULL_UPB = 0x0D,INT_FLAGB = 0x0F,INT_CAPB = 0x11,GPIOB = 0x13,OLATB = 0x15 // GPIOB   
}EXPAND2_GPIO_t;

static void EXPAND2_SetRegister(EXPAND2_GPIO_t reg, uint8_t value);
static uint8_t EXPAND2_ReadRegister(EXPAND2_GPIO_t reg);

void EXPAND2_Initialize(void){
    ${resetPinSettings["LAT"]} = 0;
    <#if (isAVR == "true")>
	_delay_us(10);
	<#else>
	__delay_us(10);
	</#if>
    ${resetPinSettings["LAT"]} = 1;
    <#if (isAVR == "true")>
	_delay_us(10);
	<#else>
	__delay_us(10);
	</#if>

    //Initialize PortA
    EXPAND2_SetRegister(IO_CONA, 0x60); 
    EXPAND2_SetRegister(OLATA, 0x00);
    
    //Initialize PortB
    EXPAND2_SetRegister(IO_CONB, 0x60);
    EXPAND2_SetRegister(OLATB, 0x00);
}

void EXPAND2_SetDirectionGPIOA(uint8_t dir) {
    EXPAND2_SetRegister(IO_DIRA, dir);
}

void EXPAND2_SetDirectionGPIOB(uint8_t dir) {
    EXPAND2_SetRegister(IO_DIRB, dir);
}

void EXPAND2_SetGPIOA(uint8_t value){
    EXPAND2_SetRegister(OLATA, value);
}

void EXPAND2_SetGPIOB(uint8_t value){
    EXPAND2_SetRegister(OLATB, value);
}

uint8_t EXPAND2_ReadGPIOA(void){
    return EXPAND2_ReadRegister(GPIOA);
}

uint8_t EXPAND2_ReadGPIOB(void){
    return EXPAND2_ReadRegister(GPIOB);
}

static void EXPAND2_SetRegister(EXPAND2_GPIO_t reg, uint8_t value){
    ${I2CFunctions["write1ByteRegister"]}(I2C_ADDRESS, reg, value);
}

static uint8_t EXPAND2_ReadRegister(EXPAND2_GPIO_t reg){
    return ${I2CFunctions["read1ByteRegister"]}(I2C_ADDRESS, reg);
}
