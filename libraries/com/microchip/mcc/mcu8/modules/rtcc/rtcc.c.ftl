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
        Driver Version    :  2.02
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
    // Make sure to select the clock source for RTCC from config bits (default SOSC)


    // In order to be able to write the Write Enable(WREN) bit for RTCC you neet to enable EEPROM writing 
    // it is strongly recommended to disable interrupts during this code segment - see INTERRUPT_GlobalInterruptDisable() in interrupt manager.h if using interrupts
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    <#if isRtccWriteEnabled>
    // Set the RTCWREN bit
    __builtin_write_RTCWREN();
    <#else>
    // Clear the RTCWREN bit
    // WARNING: None of the registers can be set up if the RTCWREN bit is cleared. Make sure you enable it in MCC or directly into initializer code
    __builtin_clear_RTCWREN();
    </#if>
    ${rtccModuleEnableBit} = 0;

    if(!RTCCTimeInitialized())
    {
        // set RTCC time ${rtccDateAndTime}
        ${rtccConfigurationRegister} |= 0x3;       // Set RTCPTR0 and RTCPTR1 to start the sequence
        ${rtccValueWindowLowRegister} = ${timeYearValueLow};  // YEAR
        ${rtccValueWindowHighRegister} = ${timeYearValueHigh};
        ${rtccValueWindowLowRegister} = ${timeDayValue};   // DAY
        ${rtccValueWindowHighRegister} = ${timeMonthValue}; // MONTH
        ${rtccValueWindowLowRegister} = ${timeHoursValue};  // HOURS
        ${rtccValueWindowHighRegister} = ${timeWeekdaysValue};  // WEEKDAY
        ${rtccValueWindowLowRegister} = ${timeSecondsValue};   // SECONDS
        ${rtccValueWindowHighRegister} = ${timeMinutesValue};   // MINUTES
        rtccTimeInitialized = true;
    }

    <#if isRtccAlarmEnabled>
    // set Alarm time ${rtccAlarmDateAndTime}
    ${rtccAlarmEnableBit} = 0;
    ${rtccAlarmValueWindowPointerbits} = 2;
    ${rtccAlarmValueWindowLowRegister} = ${alarmDayValue}; // DAY
    ${rtccAlarmValueWindowHighRegister} = ${alarmMonthValue};   // MONTH
    ${rtccAlarmValueWindowLowRegister} = ${alarmHoursValue};    // HOURS
    ${rtccAlarmValueWindowHighRegister} = ${alarmWeekdaysValue};    // WEEKDAY
    ${rtccAlarmValueWindowLowRegister} = ${alarmSecondsValue}; // SECONDS
    ${rtccAlarmValueWindowHighRegister} = ${alarmMinutesValue}; // MINUTES

    <#list initAlarmRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    </#if>
    <#if isRtccEnabled>
    ${rtccClockOutputEnableBit} = 1; // Enable RTCC output
    </#if>
    <#list initClockOutputRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    <#list initCalibOutputRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    <#list initRptAlarmRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    // Enable RTCC, clear RTCWREN  
    <#if isRtccEnabled>
    ${rtccModuleEnableBit} = 1;
    </#if>
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_clear_RTCWREN();

    <#if useRtccInterrupt>
    //Enable RTCC interrupt
    ${rtccInterruptEnableBit} = 1;
    </#if>
}
</#list>

/**
 This function implements ${moduleNameUpperCase}_TimeReset.This function is used to
 used by application to reset the RTCC value and reinitialize RTCC value.
*/
void ${moduleNameUpperCase}_TimeReset()
{
    rtccTimeInitialized = false;
}

static bool RTCCTimeInitialized(void)
{
    return(rtccTimeInitialized);
}

/**
 This function implements ${moduleNameUpperCase}_TimeGet. It access the 
 registers of  ${moduleNameUpperCase} and writes to them the values provided 
 in the function argument currentTime
*/

bool ${moduleNameUpperCase}_TimeGet(struct tm *currentTime)
{
    uint8_t register_valueHigh;
    uint8_t register_valueLow;
    if(${rtccValueRegistersReadSynBit}){
        return false;
    }

    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
   // Set the RTCWREN bit
   __builtin_write_RTCWREN();

    ${rtccConfigurationRegister} |= 0x3;       // Set RTCPTR0 and RTCPTR1 to start the sequence
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};    // reading/writing the high byte will decrement the pointer value by 1
    currentTime->tm_year = ConvertBCDToHex(register_valueLow);
  //  RCFGCALbits.RTCPTR = 2;
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};
    currentTime->tm_mon = ConvertBCDToHex(register_valueHigh);
    currentTime->tm_mday = ConvertBCDToHex(register_valueLow);
  //  RCFGCALbits.RTCPTR = 1;
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};;
    currentTime->tm_wday = ConvertBCDToHex(register_valueHigh);
    currentTime->tm_hour = ConvertBCDToHex(register_valueLow);
  //  RCFGCALbits.RTCPTR = 0;
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};
    currentTime->tm_min = ConvertBCDToHex(register_valueHigh);
    currentTime->tm_sec = ConvertBCDToHex(register_valueLow);

    // Clear RTCWREN Bit
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_clear_RTCWREN();
    
    return true;
}

/**
 * This function sets the RTCC value and takes the input time in decimal format
*/

void ${moduleNameUpperCase}_TimeSet(struct tm *initialTime)
{
    // Set the RTCWREN bit
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_write_RTCWREN();

    ${rtccModuleEnableBit} = 0;
    
    <#if useRtccInterrupt>
    ${rtccInterruptOverFlowBit} = 0;
    ${rtccInterruptEnableBit} = 0;
    </#if>

    // set RTCC initial time
    ${rtccConfigurationRegister} |= 0x3;       // Set RTCPTR0 and RTCPTR1 to start the sequence
    ${rtccValueWindowLowRegister} =  ConvertHexToBCD((uint8_t)(initialTime->tm_year));                        // YEAR
    ${rtccValueWindowHighRegister} = 0x00;
    ${rtccValueWindowLowRegister} = ConvertHexToBCD((uint8_t)(initialTime->tm_mday));                         // DAY-1
    ${rtccValueWindowHighRegister} = ConvertHexToBCD((uint8_t)(initialTime->tm_mon));                          // Month-1
    ${rtccValueWindowLowRegister} = ConvertHexToBCD((uint8_t)(initialTime->tm_hour));                         // HOURS
    ${rtccValueWindowHighRegister} = ConvertHexToBCD((uint8_t)(initialTime->tm_wday));                         // WEEKDAY
    ${rtccValueWindowLowRegister} = ConvertHexToBCD((uint8_t)(initialTime->tm_sec));                          // SECONDS
    ${rtccValueWindowHighRegister} = ConvertHexToBCD((uint8_t)(initialTime->tm_min));                          // MINUTES
             
    // Enable RTCC, clear RTCWREN  
    
    ${rtccModuleEnableBit} = 1;
        
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_clear_RTCWREN();
    
    <#if useRtccInterrupt>
    ${rtccInterruptEnableBit} = 1;
    </#if>

}

/**
 This function reads the RTCC time and returns the date and time in BCD format
  */
bool ${moduleNameUpperCase}_BCDTimeGet(bcdTime_t *currentTime)
{
    uint8_t register_valueHigh;
    uint8_t register_valueLow;
    if(${rtccValueRegistersReadSynBit}){
        return false;
    }
    
    // Set the RTCWREN bit
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_write_RTCWREN();

    ${rtccConfigurationRegister} |= 0x3;       // Set RTCPTR0 and RTCPTR1 to start the sequence
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};
    currentTime->tm_year = register_valueLow;
    //  RCFGCALbits.RTCPTR = 2;
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};
    currentTime->tm_mon = register_valueHigh;
    currentTime->tm_mday = register_valueLow;
    //  RCFGCALbits.RTCPTR = 1;
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};;
    currentTime->tm_wday = register_valueHigh;
    currentTime->tm_hour = register_valueLow;
    //  RCFGCALbits.RTCPTR = 0;
    register_valueLow = ${rtccValueWindowLowRegister};
    register_valueHigh = ${rtccValueWindowHighRegister};
    currentTime->tm_min = register_valueHigh;
    currentTime->tm_sec = register_valueLow;

    // Clear RTCWREN Bit
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_clear_RTCWREN();

   return true;
}
/**
 This function takes the input date and time in BCD format and sets the RTCC
 */
void ${moduleNameUpperCase}_BCDTimeSet(bcdTime_t *initialTime)
{
    // Set the RTCWREN bit
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_write_RTCWREN();

    ${rtccModuleEnableBit} = 0; 

    ${rtccInterruptOverFlowBit} = 0;
    ${rtccInterruptEnableBit} = 0;

    // set RTCC initial time
	${rtccConfigurationRegister} |= 0x3;       // Set RTCPTR0 and RTCPTR1 to start the sequence
    ${rtccValueWindowLowRegister} =  (uint8_t)(initialTime->tm_year);                        // YEAR
    ${rtccValueWindowHighRegister} = 0x00;
    ${rtccValueWindowLowRegister} = (uint8_t)(initialTime->tm_mday);                         // DAY-1
    ${rtccValueWindowHighRegister} = (uint8_t)(initialTime->tm_mon);                          // Month-1
    ${rtccValueWindowLowRegister} = (uint8_t)(initialTime->tm_hour);                         // HOURS
    ${rtccValueWindowHighRegister} = (uint8_t)(initialTime->tm_wday);                         // WEEKDAY
    ${rtccValueWindowLowRegister} = (uint8_t)(initialTime->tm_sec);                          // SECONDS
    ${rtccValueWindowHighRegister} = (uint8_t)(initialTime->tm_min);                          // MINUTES
    
    // Enable RTCC, clear RTCWREN
    ${rtccModuleEnableBit} = 1;  
    ${dataEepromMemory2Register} = 0x55;
    ${dataEepromMemory2Register} = 0xAA;
    __builtin_clear_RTCWREN();

    ${rtccInterruptEnableBit} = 1;

}

uint8_t ConvertHexToBCD(uint8_t hexvalue)
{
    uint8_t bcdvalue;
    bcdvalue = (uint8_t)((hexvalue / 10) << 4);
    bcdvalue = (uint8_t)(bcdvalue | (hexvalue % 10));
    return (bcdvalue);
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
