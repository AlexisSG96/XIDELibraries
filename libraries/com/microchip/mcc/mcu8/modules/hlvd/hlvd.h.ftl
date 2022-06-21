/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using PIC10 / PIC12 / PIC16 / PIC18 MCUs 

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  PIC10 / PIC12 / PIC16 / PIC18 MCUs - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${filePrefix}${moduleNameUpperCase}_H
#define ${filePrefix}${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif

/**
  Section: Enum Declarations
*/

/** ${moduleNameUpperCase} Trip points
 
 @Summary 
   This defines trip point values.
 
 @Description
   This defines trip point values.

 */
typedef enum
{
    <#list tripPoints as tripPoint>
    ${tripPoint.name} =  ${tripPoint.value}<#if tripPoint_has_next>,</#if> ${tripPoint.comment}
    </#list>
}${moduleNameUpperCase}_TRIP_POINTS;

/** ${moduleNameUpperCase} voltage direction
 
 @Summary 
   This defines voltage direction.
 
 @Description
   This defines voltage direction.

 */
typedef enum
{
   BELOW_TRIP_POINT  = 0,
   EXCEED_TRIP_POINT = 1
}${moduleNameUpperCase}_TRIP_DIRECTION;

/**
  Section: ${moduleNameUpperCase} Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine initializes the Initializes the ${moduleNameUpperCase}.
    This routine must be called before any other ${moduleGroup} routine is called.
    This routine should only be called once during system initialization.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Example
    <code>
    bool gAppShutdown = false;
    {
      //initialize the module
      ${functionPrefix}${moduleNameUpperCase}_${initializer}();
      //check if reference voltage is stable 
      while(!${functionPrefix}${moduleNameUpperCase}_IsReferenceVoltageStable());
      while(1)
      {
         //Polling
         ${functionPrefix}${moduleNameUpperCase}_Tasks();
      }
    }
    void ${functionPrefix}${moduleNameUpperCase}_TripDetectionCallback(void)
    {
       //process application code here
       gAppShutdown = true; 
    }   
    </code> 
*/
void ${functionPrefix}${moduleNameUpperCase}_${initializer}(void);
</#list>

/**
  @Summary
    This function enables the HLVD peripheral.

  @Description
    This function enables the HLVD peripheral.

  @Preconditions
    ${functionPrefix}${moduleNameUpperCase}_Initialize Is_${functionPrefix}${moduleNameUpperCase}_Ref_Voltage_Stable
   function should be called first.

  @Param
    None

  @Returns
    None.

  @Example
  <code>
      ${functionPrefix}${moduleNameUpperCase}_Disable();
      //Set the trip points and voltage direction
      ${functionPrefix}${moduleNameUpperCase}_TripPointSetup(EXCEED_TRIP_POINT,
        ${moduleNameUpperCase}_TRIP_POINT_1);
      //Enable the module
      ${functionPrefix}${moduleNameUpperCase}_Enable();
      //check if reference voltage is stable 
      while(!${functionPrefix}${moduleNameUpperCase}_IsReferenceVoltageStable());
      while(1)
      {
         
      }
    void ${functionPrefix}${moduleNameUpperCase}_TripDetectionCallback(void)
    {
       //process application code here      
    }
   </code>     
 */
void ${functionPrefix}${moduleNameUpperCase}_Enable(void);

/**
  @Summary
    This function disables the HLVD peripheral.

  @Description
    This function disables the HLVD peripheral.

  @Preconditions
    ${functionPrefix}${moduleNameUpperCase}_Initialize and
    ${functionPrefix}${moduleNameUpperCase}_IsReferenceVoltageStable
    function should be called first.

  @Param
    None

  @Returns
    None.

  @Example
   Refer the ${functionPrefix}${moduleNameUpperCase}_Enable code example
*/
void ${functionPrefix}${moduleNameUpperCase}_Disable(void);

/**
  @Summary
    This function returns the status of internal reference voltage.

  @Description
    This function returns the status of internal reference voltage.

  @Preconditions
    ${functionPrefix}${moduleNameUpperCase}_Initialize function should be called first

  @Param
    None

  @Returns
    bool - true - internal reference voltage is stable
           false - internal reference voltage is unstable

  @Example
  Refer the ${functionPrefix}${moduleNameUpperCase}_Enable code example
*/
bool ${functionPrefix}${moduleNameUpperCase}_IsReferenceVoltageStable(void);

<#if BGVSTSetting??>
/**
  @Summary
    This function returns the status of band gap voltage.

  @Description
    This function returns the status of band gap voltage.

  @Preconditions
    ${functionPrefix}${moduleNameUpperCase}_Initialize function should be called first

  @Param
    None

  @Returns
    bool - true - Band gap voltage is stable
           false - Band gap voltage is unstable

  @Example
  Refer the ${functionPrefix}${moduleNameUpperCase}_Enable code example
*/
bool ${functionPrefix}${moduleNameUpperCase}_IsBandGapVoltageStable(void);
</#if>

/**
  @Summary
    This function sets the voltage trip direction and trip value

  @Description
    This function sets the voltage trip direction and trip value

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Example
   Refer the ${functionPrefix}${moduleNameUpperCase}_Enable code example
*/
void ${functionPrefix}${moduleNameUpperCase}_TripPointSetup(HLVD_TRIP_DIRECTION direction,
        HLVD_TRIP_POINTS trip_points);

<#if useInterrupt>
/**
  @Summary
    Implements ISR

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${interruptFunction}(void);

</#if>

<#if !useInterrupt>
/**
  @Summary
  This is a HLVD task function. This routine is used to poll the HLVD
  interrupt flag bit.

  @Description
    This is a polling function. Interrupt flag is monitored periodicaly
   to check the voltage exceeds or drops below the reference voltage.
   If VDIR bit is set then LVDIF flag is set if voltage exceeds reference voltage.
   If VDIR bit is clear then LVDIF flag is set if voltage drops below the
   reference voltage.

  @Returns
    None

  @Param
    None
*/
void ${functionPrefix}${moduleNameUpperCase}_Tasks( void );
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility
}
#endif

#endif	//${filePrefix}${moduleNameUpperCase}_H
/**
 End of File
*/

