/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

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
  Section: ADC Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine initializes the Initializes the ${moduleNameUpperCase}.
    This routine must be called before any other ${moduleNameUpperCase} routine is called.
    This routine should only be called once during system initialization.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment


  @Example
    <code>
    
    </code>
*/
void ${initializer}(void);

</#list>
/**
  @Summary
    Load the required 10bit Phase counter resolution 

  @Description
    Set the required resolution for the incoming signal

  @Preconditions
    None

  @Param
    Pass 10 bit Phase counter resolution 

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_ResolutionSet(uint16_t resolution);

/**
  @Summary
    Load required 15 bit missing pulse delay

  @Description
    In multiple pulse mode. set the expected missing pulses

  @Preconditions
    None

  @Param
    Pass 15 bit missing pulse delay

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_MissingPulseDelaySet(int16_t  missingPulse);

/**
  @Summary
    Load threshold period for error calculation 

  @Description
    Set the acceptable threshold point for the period

  @Preconditions
    None

  @Param
    Pass 16 bit set point

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_SetPointLoad(uint16_t thresholdPeriod);
        
/**
  @Summary
    Read measured period count

  @Description    
    Read the measured period count
 * 
  @Preconditions
    None

  @Param
    None

  @Returns
    Return 15 bit period count 

  @Example
    <code>
    
    </code>
*/
uint16_t ${moduleNameUpperCase}_PeriodGet(void);

/**
  @Summary
    Read measured phase count

  @Description    
    Read measured phase count

  @Preconditions
    None

  @Param
    None

  @Returns
    Return 10 bit Phase count

  @Example
    <code>
    
    </code>
*/
uint16_t ${moduleNameUpperCase}_PhaseGet(void);

/**
  @Summary
    Read error of the measured period value compared to the threshold setting (ATxPER - ATxSTP = ATxERR)

  @Description    
    Read calculated error from the difference of period with set point

  @Preconditions
    None

  @Param
    None

  @Returns
    Return 16 bit error count

  @Example
    <code>
    
    </code>
*/
int16_t ${moduleNameUpperCase}_SetPointErrorGet(void);

/**
  @Summary
    Returns comparison result of current period value with previous value.

  @Description    
    Compares with the previous value of period register and displays result as less than or greater than 	

  @Preconditions
    None

  @Param
    None

  @Returns
    true - The value currently in AT1PER is less than the previous value
    false - The value currently in AT1PER is greater than or equal to the previous value

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CheckPeriodValue(void);

/**
  @Summary
    Returns status after verifying ATxPER(period) and ATxPHS(phase) input cycles.

  @Description    
    Confirms weather result obtained in period and phase registers are valid of invalid

  @Preconditions
    None

  @Param
    None

  @Returns
    true - valid input cycles
    false - Invalid input cycles( not enough input cycles)

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsMeasurementValid(void);

/**
  @Summary
    Returns status of ATxPER(period counter).

  @Description    
    Confirms if the result obtained in period register is rolled over or not

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Counter rolled over one or more times during measurement
    false - Value shown by ATxPER is valid

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsPeriodCounterOverflowOccured(void);

/**
  @Summary
    Returns status of Phase interrupt flag bit (PHSIF ).

  @Description    
    Calculated phase count will be available in this register

  @Preconditions
    None

  @Param
    None

  @Returns
    true - phase count is available in register
    false - phase count is not available

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsPhaseCountAvailable(void);

/**
  @Summary
    Returns status of Missed Pulse interrupt flag bit (MSSIF ).

  @Description
    

  @Preconditions
    None

  @Param
    None

  @Returns
    true -  Missing pulse count is available
    false - Missing pulse count is not available

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsMissedPulseCountAvailable(void);

/**
  @Summary
    Returns status of Period interrupt flag bit (PERIF )

  @Description
     

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Period count available
    false - Period count not available

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsPeriodCountAvailable(void);

<#if isCapture1Mode>
/**
  @Summary
    Returns the captured value(ATxCCy) of ATxPHS when the captured input is signalled

  @Description
    This routine reads the 16 bit capture value.

  @Preconditions
    None

  @Param
    None

  @Returns
    Returns 16 bit captured value

  @Example
    <code>
    
    </code>
*/
uint16_t ${moduleNameUpperCase}_CC1_Capture_Read(void);

/**
  @Summary
    Returns the status of capture interrupt flag(CCxIF)

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Indicates data capture complete
    false - Indicates data capture is not complete

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CC1_IsCaptureDataReady(void);
</#if>

<#if isCompare1Mode>
/**
  @Summary
    Load count to ATxCCy register to compare with ATxPHS

  @Description
    This routine loads the 16 bit compare value.

  @Preconditions
    None

  @Param
    Pass in 16bit compare value

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_CC1_Compare_SetCount(uint16_t compareCount);

/**
  @Summary
    Returns the status of comparison between ATxCCy and ATxPHS register

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Indicates compare is complete
   false - Indicates compare is not complete
   
  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CC1_Compare_IsMatchOccured(void);
</#if>

<#if isCapture2Mode>
/**
  @Summary
    Returns the captured value(ATxCCy) of ATxPHS when the captured input is signalled

  @Description
    This routine reads the 16 bit capture value.

  @Preconditions
    None

  @Param
    None

  @Returns
    Returns 16 bit captured value

  @Example
    <code>
    
    </code>
*/
uint16_t ${moduleNameUpperCase}_CC2_Capture_Read(void);

/**
  @Summary
    Returns the status of capture interrupt flag(CCxIF)

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Indicates data capture complete
    false - Indicates data capture is not complete

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CC2_IsCaptureDataReady(void);
</#if>

<#if isCompare2Mode>
/**
  @Summary
    Load count to ATxCCy register to compare with ATxPHS

  @Description
    This routine loads the 16 bit compare value.

  @Preconditions
    None

  @Param
    Pass in 16bit compare value

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_CC2_Compare_SetCount(uint16_t compareCount);

/**
  @Summary
    Returns the status of comparison between ATxCCy and ATxPHS register

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Indicates compare is complete
   false - Indicates compare is not complete
   
  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CC2_Compare_IsMatchOccured(void);
</#if>

<#if isCapture3Mode>
/**
  @Summary
    Returns the captured value(ATxCCy) of ATxPHS when the captured input is signalled

  @Description
    This routine reads the 16 bit capture value.

  @Preconditions
    None

  @Param
    None

  @Returns
    Returns 16 bit captured value

  @Example
    <code>
    
    </code>
*/
uint16_t ${moduleNameUpperCase}_CC3_Capture_Read(void);

/**
  @Summary
    Returns the status of capture interrupt flag(CCxIF)

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Indicates data capture complete
    false - Indicates data capture is not complete

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CC3_IsCaptureDataReady(void);
</#if>

<#if isCompare3Mode>
/**
  @Summary
    Load count to ATxCCy register to compare with ATxPHS

  @Description
    This routine loads the 16 bit compare value.

  @Preconditions
    None

  @Param
    Pass in 16bit compare value

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_CC3_Compare_SetCount(uint16_t compareCount);

/**
  @Summary
    Returns the status of comparison between ATxCCy and ATxPHS register

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - Indicates compare is complete
   false - Indicates compare is not complete
   
  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CC3_Compare_IsMatchOccured(void);
</#if>

<#if useInterrupt>
/**
  @Summary
    Check which particular interrupt has occurred and call that function.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_${interruptFunctionName}(void);

<#if isPeriodInterruptEnabled>
/**
  @Summary	
    Clears Period interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_Period(void);
</#if>

<#if isPhaseInterruptEnabled>
/**
  @Summary	
    Clears Phase interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_Phase(void);
</#if>

<#if isMissingPulseInterruptEnabled>
/**
  @Summary	
    Clears Missing pulse delay interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_MissingPulseDelay(void);
</#if>

<#if cc1Interrupt>
/**
  @Summary	
    Clears Capture and Compare 1 interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_CC1(void);
</#if>

<#if cc2Interrupt>
/**
  @Summary	
    Clears Capture and Compare 2 interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_CC2(void);
</#if>

<#if cc3Interrupt>
/**
  @Summary	
    Clears Capture and Compare 3 interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_CC3(void);
</#if>
</#if>

#endif	/* AT1_H */
/**
 End of File
*/