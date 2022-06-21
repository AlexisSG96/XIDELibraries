/**
  ${moduleNameUpperCase} Generated Driver  File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.10
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

/**
 Section: Included Files
*/
#include <xc.h>
#include "${moduleNameLowerCase}.h"

/**
* Section: Function Prototype
*/
static bool rtccTimeInitialized = false;
static bool RTCCTimeInitialized(void);

/**
* Section: Driver Interface Function Definitions
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // Enable write operation on RTCC timer registers
    __builtin_write_RTCWREN();

    // Disable RTCC
    ${rtccModuleEnableBit} = 0;

    if(!RTCCTimeInitialized())
    {
       // set RTCC time ${rtccDateAndTime}
        ${rtccYearRegister}     = ${timeYearValue};   // year
        ${rtccMonthRegister}    = ${timeMonthValue};    // month 
        ${rtccWeekdayRegister}  = ${timeWeekdayValue};    // weekday 
        ${rtccDayRegister}      = ${timeDayValue};    // day
        ${rtccHoursRegister}    = ${timeHoursValue};    // hours 
        ${rtccMinutesRegister}  = ${timeMinutesValue};    // minutes 
        ${rtccSecondsRegister}  = ${timeSecondsValue};    // seconds 
        rtccTimeInitialized = true;
    }
    
    // Configure RTCC clock source
    // 0 - SOSC, 1 - MFINTOSC, 2 - 50Hz Powerline, 3 - 60Hz Powerline
    ${rtccClockSourceSelectionBits} = ${rtccClockSourceValue};
    
    <#if isRtccAlarmEnabled>
    // set Alarm time ${rtccAlarmDateAndTime}
    ${rtccAlarmEnableBit} = 0;
    <#list initRptAlarmRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    
    ${alarmMonthRegister}  = ${alarmMonthValue};  // month 
    ${alarmWeekdayRegister}   = ${alarmWeekdayValue}; // weekday 
    ${alarmDayRegister}  = ${alarmDayValue};  // day
    ${alarmHoursRegister}   = ${alarmHoursValue}; // hours 
    ${alarmMinutesRegister}  = ${alarmMinutesValue};  // minutes 
    ${alarmSecondsRegister}  = ${alarmSecondsValue};  // seconds 

    // Re-enable the alarm
    ${rtccAlarmEnableBit} = 1;
    
    <#list initAlarmCtlRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    </#if> 
    
    <#list initCalibOutputRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    
    <#if isRtccEnabled>
    // Enable RTCC
    ${rtccModuleEnableBit} = 1;
    while(!${rtccModuleEnableBit});

    </#if>
    // Disable write operations on RTCC timer registers
    __builtin_clear_RTCWREN();

    <#if useRtccInterrupt>
    // Clear the RTCC interrupt flag
    ${rtccInterruptOverFlowBit} = 0;

    // Enable RTCC interrupt
    ${rtccInterruptEnableBit} = 1;
    </#if>
}
</#list>


/**
 This function implements ${moduleNameUpperCase}_TimeGet. It access the 
 registers of  ${moduleNameUpperCase} and writes to them the values provided 
 in a tm structure. 
*/
bool ${moduleNameUpperCase}_TimeGet(struct tm *currentTime) 
{
    if(${rtccValueRegistersReadSynBit}) return false;

    //get year 
    currentTime->tm_year    = ConcatInt(20, GetDecimalValue(${rtccYearRegister}));
    //get month
    currentTime->tm_mon     = GetDecimalValue(${rtccMonthRegister});
    // get weekday
    currentTime->tm_wday    = GetDecimalValue(${rtccWeekdayRegister});
    //get day
    currentTime->tm_mday    = GetDecimalValue(${rtccDayRegister});
    //get hour
    currentTime->tm_hour    = GetDecimalValue(${rtccHoursRegister});
    //get minutes
    currentTime->tm_min     = GetDecimalValue(${rtccMinutesRegister});
    //get seconds
    currentTime->tm_sec     = GetDecimalValue(${rtccSecondsRegister});    

    return true;
}

void ${moduleNameUpperCase}_TimeSet(struct tm *initialTime) 
{
    <#if useRtccInterrupt>
    ${rtccInterruptOverFlowBit} = 0;
    ${rtccInterruptEnableBit} = 0;

    </#if>
    __builtin_write_RTCWREN();
    ${rtccModuleEnableBit} = 0;

    //set year
    ${rtccYearRegister} = GetHexValue(initialTime->tm_year);
    //set month
    ${rtccMonthRegister} = GetHexValue(initialTime->tm_mon);
    //set weekday
    ${rtccWeekdayRegister} = GetHexValue(initialTime->tm_wday); 
    //set day
    ${rtccDayRegister} = GetHexValue(initialTime->tm_mday);     
    //set hours
    ${rtccHoursRegister} = GetHexValue(initialTime->tm_hour); 
    //set minutes
    ${rtccMinutesRegister} = GetHexValue(initialTime->tm_min); 
    //set seconds
    ${rtccSecondsRegister} = GetHexValue(initialTime->tm_sec);       

    ${rtccModuleEnableBit} = 1;
    while(!${rtccModuleEnableBit});
    __builtin_clear_RTCWREN();

    <#if useRtccInterrupt>
    ${rtccInterruptOverFlowBit} = 1;
    ${rtccInterruptEnableBit} = 1;
    </#if>
}

void RTCC_Enable(void)
{
    __builtin_write_RTCWREN();
    
    ${rtccModuleEnableBit} = 1;
    while(!${rtccModuleEnableBit});
    
    __builtin_clear_RTCWREN();
}

bool ${moduleNameUpperCase}_AlarmTimeGet(struct tm *alarmTime) 
{
   if(${rtccValueRegistersReadSynBit}) return false;

    //get month
    alarmTime->tm_mon     = GetDecimalValue(${alarmMonthRegister});  
    //get weekday
    alarmTime->tm_wday    = GetDecimalValue(${alarmWeekdayRegister});  
    //get day
    alarmTime->tm_mday    =  GetDecimalValue(${alarmDayRegister});;
    //get hour
    alarmTime->tm_hour    = GetDecimalValue(${alarmHoursRegister});  
    //get minutes
    alarmTime->tm_min     = GetDecimalValue(${alarmMinutesRegister}); 
    //get seconds
    alarmTime->tm_sec     = GetDecimalValue(${alarmSecondsRegister}); 

    return true;
}

void ${moduleNameUpperCase}_AlarmTimeSet(struct tm *alarmTime) 
{
    ${rtccAlarmEnableBit} = 0;

    //set month
    ${alarmMonthRegister} = GetHexValue(alarmTime->tm_mon);
    //set weekday
    ${alarmWeekdayRegister} = GetHexValue(alarmTime->tm_wday); 
    //set day
    ${alarmDayRegister} = GetHexValue(alarmTime->tm_mday);     
    //set hours
    ${alarmHoursRegister} = GetHexValue(alarmTime->tm_hour); 
    //set minutes
    ${alarmMinutesRegister} = GetHexValue(alarmTime->tm_min); 
    //set seconds
    ${alarmSecondsRegister} = GetHexValue(alarmTime->tm_sec);

    ${rtccAlarmEnableBit} = 1;
}

/**
 This function implements ${moduleNameUpperCase}_TimeReset.This function is used to
 used by application to reset the RTCC value and reinitialize RTCC value.
*/
void ${moduleNameUpperCase}_TimeReset()
{
    rtccTimeInitialized = false;
}

/**
  This function returns the value of the rtccTimeInitialized vaiable.
*/
static bool RTCCTimeInitialized(void)
{
    return(rtccTimeInitialized);
}

uint8_t ConvertHexToBCD(uint8_t hexvalue)
{
    uint8_t bcdvalue;
    bcdvalue = (uint8_t)((hexvalue / 10) << 4);
    bcdvalue = (uint8_t)(bcdvalue | (hexvalue % 10));
    return bcdvalue;
}

uint8_t ConvertBCDToHex(uint8_t bcdvalue)
{
    uint8_t hexvalue;
    hexvalue = (uint8_t)((((bcdvalue & 0xF0) >> 4)* 10) + (bcdvalue & 0x0F));
    return hexvalue;
}

time_t ConvertDateTimeToUnixTime(struct tm *tmTime)
{
    return mktime(tmTime);
}

struct tm *ConvertUnixTimeToDateTime(time_t *unixTime)
{
    return gmtime(unixTime);
}

uint8_t GetDecimalValue(uint8_t hex_value) 
{
    uint8_t prefix_value = (uint8_t)(((hex_value & 0xf0) >> 4));
    uint8_t sufix_value  = (uint8_t)(hex_value & 0x0f);
    uint8_t int1 = ConvertHexToBCD(prefix_value);
    uint8_t int2 = ConvertHexToBCD(sufix_value);
    
    uint8_t result = (uint8_t)(ConcatInt(int1, int2 ));
    
    return result;
}

uint8_t GetHexValue(int value)
{
    uint8_t low     = ConvertBCDToHex(GetLastDigit(value));
    uint8_t high    = ConvertBCDToHex(GetLastDigit(value/10));
    
    return ((uint8_t)(((high & 0x0f) << 4) | low));
}

int ConcatInt(uint8_t uint1, uint8_t uint2)
{
    uint8_t temp         = 1;

    if(uint2 == 0) 
    {
        if(uint1 == 20) //if the result is about the year
        {
            temp = 100;
        } 
        else
        {
          temp = 10;
        }
    }

    while(temp <= uint2) {
        temp *= 10;
    }
    
    return uint1*temp + uint2;
}

uint8_t GetLastDigit(int int_value) 
{
    uint8_t result  =  (uint8_t)(int_value % 10);
    int_value      /= 10;
    
    return result;
}

<#if useRtccInterrupt>
void ${moduleNameUpperCase}_ISR(void)
{
    /* TODO : Add interrupt handling code */
    ${rtccInterruptOverFlowBit} = 0;
}
<#else>
bool ${moduleNameUpperCase}_Task(void)
{
    bool status;
    status = ${rtccInterruptOverFlowBit};
    if( ${rtccInterruptOverFlowBit})
    {
       ${rtccInterruptOverFlowBit} = 0;
    }
    return status;
}
</#if>

/**
 End of File
*/
