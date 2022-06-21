/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
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
  Section: Macros
*/

/**
 *  Loads data from DAC buffer onto the DAC output
 */
#define ${moduleNameUpperCase}_DoubleBufferLatch() \
<#if dacBufferLoadRegisterExists>
    (${dacDoubleBufferLoadbit} = 1)
<#else>
    ((void) 0) /* This device does not have a double buffer */
</#if>

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    <#list initRegisters as data >
    // ${data.comment}
    ${data.name} = ${data.value};
    </#list>
    //Loading DAC${instanceNumber} double buffer data to latch.
    ${moduleNameUpperCase}_DoubleBufferLatch();
}
</#list>


void ${moduleNameUpperCase}_Load16bitInputData(uint16_t input16BitData)
{
    //DAC input reference range should be 16bit.
    //Input data left justified.
    <#if selectedDevice?contains("753")>
    ${dacReferenceFormat} = 0;
    <#else>
    ${dacReferenceFormat} = 1;
    </#if>
    
    //Loading 16bit data to DAC${instanceNumber}
    ${dacReferenceLowReg}  = (uint8_t) input16BitData;  
    ${dacReferenceHighReg}  = (uint8_t)(input16BitData >> 8);
    //Loading DAC${instanceNumber} double buffer data to latch.
    ${moduleNameUpperCase}_DoubleBufferLatch();
}

void ${moduleNameUpperCase}_Load10bitInputData(uint16_t input10BitData)
{
    //DAC input reference range should be 10bit.
    //Input data right justified.
    <#if selectedDevice?contains("753")>
    ${dacReferenceFormat} = 1;
    <#else>
    ${dacReferenceFormat} = 0;
    </#if>
    
    //Loading 10bit data to DAC${instanceNumber}
    ${dacReferenceLowReg}  = (uint8_t) input10BitData;  
    ${dacReferenceHighReg}  = (uint8_t)(input10BitData >> 8);
    //Loading DAC${instanceNumber} double buffer data to latch.
    ${moduleNameUpperCase}_DoubleBufferLatch();
}

void ${moduleNameUpperCase}_Load8bitInputData(uint8_t input8BitData)
{
    //DAC input reference range should be 8 bit.
    //Input data right justified.
    ${dacReferenceFormat} = 0;
    
    //Loading 10bit data to DAC${instanceNumber}
    ${dacReferenceLowReg}  = input8BitData;  
    //Loading DAC${instanceNumber} double buffer data to latch.
    ${moduleNameUpperCase}_DoubleBufferLatch();
}

uint16_t ${moduleNameUpperCase}_Read10BitInputData(void) {
    // Right justified, to match ?load? function
    <#if selectedDevice?contains("753")>
    ${dacReferenceFormat} = 1;
    <#else>
    ${dacReferenceFormat} = 0;
    </#if>

    // Read data
    uint16_t data = ((uint16_t) ${dacReferenceHighReg}) << 8;
    data |= ((uint16_t) ${dacReferenceLowReg});

    return data;
}
/**
 End of File
*/ 



