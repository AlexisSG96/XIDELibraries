/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "stdint.h"
#include "math.h"
#include "mcc.h"
#include "${pinHeader}"
#include "drivers/${I2CFunctions["simpleheader"]}"
#include "TempLog.h"

/**
  Section: Macro Declarations
 */

#define TEMP_ADDRESS    0b1001000
#define EEPROM_ADDRESS  0b1010000

#define TEMP_REG            0x00
#define CONF_REG            0x01
#define TLOW_LIMIT_REG      0x02
#define THIGH_LIMIT_REG     0x03
#define SAVE_CONFIG         0x48
#define RELOAD_CONFIG       0xb8
#define DEC_INCREMENT_9BIT  0.5
#define DEC_INCREMENT_10BIT 0.25
#define DEC_INCREMENT_11BIT 0.125
#define DEC_INCREMENT_12BIT 0.0625

/**
  Section: Variable Definitions
 */

mode                m;
resolution          r;
fault_tolerance     ft;
alert_polarity      ap;
thermostat_mode     tm;
shutdown_mode       sm;

/**
  Section: Private function prototypes
 */

void setResolution(resolution r);
void setFaultTolerance(fault_tolerance ft);
void setAlertPolarity(alert_polarity ap);
void setThermostatMode(thermostat_mode tm);
void setShutdownMode(shutdown_mode sm);

void setUpperLimit(uint16_t upperlimit);
void setLowerLimit(uint16_t lowerlimit);

float convertToCelsius(uint16_t temperature, resolution r);
uint16_t convertToIntVal(float lim);

/**
  Section: Driver APIs
 */

void TempLog_Initialize(void){
    TempLog_setMode(${InitMode});
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
    setResolution(${InitReso});
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
    setFaultTolerance(${InitFT});
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
    setAlertPolarity(${InitAP});
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
    setThermostatMode(${InitTM});
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
    setShutdownMode(${InitSM});
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
}

float TempLog_readTemperature(resolution r){
    uint16_t Temperatureresult;
    float tempVal;
    setResolution(r);
    Temperatureresult = ${I2CFunctions["read2ByteRegister"]}(TEMP_ADDRESS,TEMP_REG);
    tempVal = convertToCelsius(Temperatureresult, r);
    return tempVal;
}

void TempLog_setMode(mode m){
    uint8_t config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    config = ((m << 7 & 0x80) | (config & 0x7F));
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,CONF_REG,config);
}

void setResolution(resolution r){
    uint8_t config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    config = ((r << 5 & 0x60) | (config & 0x9F));
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,CONF_REG,config);
}

void setFaultTolerance(fault_tolerance ft){
    uint8_t config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    config = ((ft << 3 & 0x18) | (config & 0xE7));
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,CONF_REG,config);
}

void setAlertPolarity(alert_polarity ap){
    uint8_t config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    config = ((ap << 2 & 0x04) | (config & 0xFB));
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,CONF_REG,config);
}

void setThermostatMode(thermostat_mode tm){
    uint8_t config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    config = ((tm << 1 & 0x02) | (config & 0xFD));
   ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,CONF_REG,config);
}

void setShutdownMode(shutdown_mode sm){
    uint8_t config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    config = ((sm & 0x01) | (config & 0xFE));
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,CONF_REG,config);
}

void TempLog_setLimit(float upper,float lower){
    uint16_t upLim;
    uint16_t downLim;
    upLim = convertToIntVal(upper);
    downLim = convertToIntVal(lower);
    setUpperLimit(upLim);
    <#if (isAVR == "true")>
	_delay_ms(200);
	<#else>
	__delay_ms(200);
	</#if>
    setLowerLimit(downLim);
}

void setUpperLimit(uint16_t temperature){
    uint8_t highbyte = temperature >> 8;
    uint8_t lowbyte = temperature;
    uint16_t upperlimit = ((lowbyte << 8) | highbyte);
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,THIGH_LIMIT_REG,upperlimit);
}

void setLowerLimit(uint16_t temperature){
    uint8_t highbyte = temperature >> 8;
    uint8_t lowbyte = temperature;
    uint16_t lowerlimit = ((lowbyte << 8) | highbyte);
    ${I2CFunctions["write2ByteRegister"]}(TEMP_ADDRESS,TLOW_LIMIT_REG,lowerlimit);
}

uint16_t TempLog_getAlert(void){
    <#if alertPinSettings.PORT?has_content>
    return ${alertPinSettings["getInputValue"]}
    <#else>
    // Please select an alert pin.
    return 0;
    </#if>
    
}

void TempLog_saveConfiguration(void){
    ${I2CFunctions["write1ByteRegister"]}(TEMP_ADDRESS,SAVE_CONFIG,0x00);
}

void TempLog_reloadConfiguration(void){
    ${I2CFunctions["write1ByteRegister"]}(TEMP_ADDRESS,RELOAD_CONFIG,0x00);
}

void TempLog_writeEEPROM(uint16_t address,uint8_t data){
    uint8_t address_highbyte = ((address & 0x03) >> 8);
    uint8_t address_lowbyte = address;
    uint8_t eeprom_address = (EEPROM_ADDRESS | address_highbyte);
    ${I2CFunctions["write1ByteRegister"]}(eeprom_address,address_lowbyte,data);
}

void TempLog_readEEPROM(uint16_t address){
    uint8_t address_msb = ((address & 0x03) >> 8);
    uint8_t address_lowbyte = address;
    uint8_t eeprom_address = (EEPROM_ADDRESS | address_msb);
    ${I2CFunctions["read1ByteRegister"]}(eeprom_address,address_lowbyte);
}

float convertToCelsius(uint16_t temperature, resolution r){
	uint8_t tempWhole;
	uint8_t tempDecimal;
	float convertedVal;
	tempWhole = temperature >> 8;
	tempDecimal = temperature;
	
	if(r == r_9bits){
		uint8_t r_9dec = tempDecimal >> 7;
		convertedVal = tempWhole + DEC_INCREMENT_9BIT*r_9dec;	
	}
	
	else if(r == r_10bits){
		uint8_t r_10dec = tempDecimal >> 6;
		convertedVal = tempWhole + DEC_INCREMENT_10BIT*r_10dec;
	}
	
	else if(r == r_11bits){
		uint8_t r_11dec = tempDecimal >> 5;
		convertedVal = tempWhole + DEC_INCREMENT_11BIT*r_11dec;
	}
	
	else if(r == r_12bits){
		uint8_t r_12dec = tempDecimal >> 4;
		convertedVal = tempWhole + DEC_INCREMENT_12BIT*r_12dec;
	}
	
	return convertedVal;
}

uint16_t convertToIntVal(float lim){
    uint32_t lim_int;   
    uint16_t limit_val;
    uint8_t lim_dec;
    uint8_t up = trunc(fabs(lim));
    uint8_t reso_config;
    resolution reso_val;
    uint8_t sign = 0;
    lim_int = fabs(lim)*10000;
    
    reso_config = ${I2CFunctions["read1ByteRegister"]}(TEMP_ADDRESS,CONF_REG);
    reso_val = (reso_config & 0x60) >> 5;
    
    if(lim < 0){
        sign = 0x80;
    }
    
    if(reso_val == r_9bits){
        uint16_t r_9u = (lim_int/1000) - up*10;
        lim_dec = r_9u/5;
        limit_val = ((sign << 8) | (up << 8) | (lim_dec << 7));
	}
	
	else if(reso_val == r_10bits){
		uint8_t r_10u = (lim_int/100) - up*100;
		lim_dec = r_10u/25;
        limit_val = ((sign << 8) | (up << 8) | (lim_dec << 6));
	}
	
	else if(reso_val == r_11bits){
		uint16_t r_11u = ((lim_int/10) - up*1000);
        lim_dec = r_11u/125;
        limit_val = ((sign << 8) | (up << 8) | (lim_dec << 5));
	}
	
	else if(reso_val == r_12bits){
		uint16_t r_12u = (lim_int - up*10000);
        lim_dec = r_12u/625;
        limit_val = ((sign << 8) | (up << 8) | (lim_dec << 4));
	}
    return limit_val;  
}