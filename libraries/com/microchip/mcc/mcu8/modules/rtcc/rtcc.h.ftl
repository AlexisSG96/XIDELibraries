/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.02
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H


/**
 Section: Included Files
*/


#define __builtin_write_RTCWREN() ${rtccValueRegistersWriteEnablebit} = 1
#define __builtin_clear_RTCWREN() ${rtccValueRegistersWriteEnablebit} = 0

#include <stdbool.h>
#include <stdint.h>
#include <time.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
 Section: types
*/
typedef struct tm bcdTime_t;

/**
 Section: Interface Routines
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes and enables ${moduleNameUpperCase} peripheral

  @Description
    This function sets a time in the ${moduleNameUpperCase} and enables 
    ${moduleNameUpperCase} for operation. It will also configure the Alarm settings.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Example
    <code>
    struct tm currentTime;

    ${initializer}();

    while(!${moduleNameUpperCase}_TimeGet(&currentTime))
    {
        // Do something
    }
    </code>
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Returns the current time from the ${moduleNameUpperCase} peripheral

  @Description
    This function returns the current time from the ${moduleNameUpperCase} peripheral. This
    function uses the C library type struct tm parameter.

  @Preconditions
    None

  @Param
    currentTime - This the parameter which gets filled in by the function. The
    values are set by reading the hardware peripheral

  @Returns
    Whether the data is available or not, true if the data is available.
    false if the data is not available.

  @Example
    <code>
    struct tm currentTime;

    while(!${moduleNameUpperCase}_TimeGet(&currentTime))
    {
        // Do something
    }
    </code>
*/

bool ${moduleNameUpperCase}_TimeGet(struct tm *currentTime);


/**
  @Summary
    Sets the initial time for the ${moduleNameUpperCase} peripheral

  @Description
    This function sets the initial time for the ${moduleNameUpperCase} peripheral. This
    function uses the C library type struct tm parameter.

  @Preconditions
    None

  @Param
    initialTime - This parameter sets the values.

  @Returns
    None

  @Example
    <code>
    struct tm initialTime;

    ${moduleNameUpperCase}_TimeSet(&initialTime);
    </code>
*/

void ${moduleNameUpperCase}_TimeSet(struct tm *initialTime);
/**
  @Summary
    Returns the current time from the ${moduleNameUpperCase} peripheral

  @Description
    This function returns the current time from the ${moduleNameUpperCase} peripheral. This
    function uses the C library type struct tm parameter.

  @Preconditions
    None

  @Param
    currentTime - This the parameter which gets filled in by the function. The
    values are set by reading the hardware peripheral

  @Returns
    Whether the data is available or not, true if the data is available.
    false if the data is not available.

  @Example
    <code>
    bcdTime_t currentTime;

    while(!${moduleNameUpperCase}_BCDTimeGet(&currentTime))
    {
        // Do something
    }
    </code>
*/

bool ${moduleNameUpperCase}_BCDTimeGet(bcdTime_t *currentTime);

/**
  @Summary
    Sets the initial time for the ${moduleNameUpperCase} peripheral in BCD format

  @Description
    This function sets the initial time for the ${moduleNameUpperCase} peripheral. This
    the time value in BCD format

  @Preconditions
    None

  @Param
    initialTime - This parameter takes the input value in BCD format

  @Returns
    None

  @Example
    <code>
    bcdTime_t initialTime;

    ${moduleNameUpperCase}_BCDTimeSet(&initialTime);
    </code>
*/
void ${moduleNameUpperCase}_BCDTimeSet(bcdTime_t *initialTime);

/**
  @Summary
    This function indicates whether to reset the RTCC value or not on  system restart.

  @Description
    This function indicates whether to reset the RTCC value or not on  system restart.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Example
    <code>
    ${moduleNameUpperCase}_TimeReset();
    </code>
*/
void ${moduleNameUpperCase}_TimeReset(void);

/**
  @Summary
    This function converts a hex value to bcd format
  @Description
    This function converts a hex value to bcd format


  @Preconditions
    None

  @Param
    uint8_t hexvalue

  @Returns
    None

  @Example
    <code>
	bcdTime_t bcdvalue;
	struct tm hexvalue;
	
	bcdvalue = ConvertHexToBCD(hexvalue)
    </code>
*/
uint8_t ConvertHexToBCD(uint8_t hexvalue);

/**
  @Summary
    This function converts a bcd format value to a hex value
  @Description
    This function converts a bcd format value to a hex value


  @Preconditions
    None

  @Param
    uint8_t bcdvalue

  @Returns
    None

  @Example
    <code>
	bcdTime_t bcdvalue;
	struct tm hexvalue;
	
	hexvalue = ConvertHexToBCD(bcdvalue)
    </code>
*/
uint8_t ConvertBCDToHex(uint8_t bcdvalue);

/**
  @Summary
    This function converts struct tm time to unix time
  @Description
    This function receives a tm input and returns the corresponding unix time represented in seconds since 00:00:00 on Jan1. 1970


  @Preconditions
    None

  @Param
    struct tm * tmTime

  @Returns
    None

  @Example
    <code>
	time_t unixTime;
	struct tm tmTime;
	
	unixTime = ConvertDateTimeToUnixTime(&tmTime)
    </code>
*/
time_t ConvertDateTimeToUnixTime(struct tm *tmTime);

/**
  @Summary
    This function converts unix time to struct tm type
  @Description
    This function receives a unix time input (32 bits time in seconds) and returns the corresponding tm time


  @Preconditions
    None

  @Param
    time_t * unixTime

  @Returns
    None

  @Example
    <code>
	time_t unixTime;
	struct tm tmTime;
	
	*tmTime = ConvertUnixTimeToDateTime(&unixTime)
    </code>
*/
struct tm *ConvertUnixTimeToDateTime(time_t *unixTime);

<#if useRtccInterrupt>
/** Function:
  void ${moduleNameUpperCase}_ISR(void)

  Summary:
    Interrupt Service Routine for the RTCC Peripheral

  Description:
    This is the interrupt service routine for the RTCC peripheral. Add in code if 
    required in the ISR. 
*/
void ${moduleNameUpperCase}_ISR(void);
<#else>
/* Function:
    bool ${moduleNameUpperCase}_Task(void)

  Summary:
    Status function which returns the RTCC interrupt flag status

  Description:
    This is the status function for the RTCC peripheral. 
*/
bool ${moduleNameUpperCase}_Task(void);
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H

/**
 End of File
*/
