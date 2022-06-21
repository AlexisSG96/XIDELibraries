<#assign settings = pcgConfiguration.configuration.settings>
<#assign data = pcgConfiguration.configuration.data>
<#assign moduleNameUpperCase = data.moduleName?upper_case>
<#assign moduleNameLowerCase = data.moduleName?lower_case>
<#assign instanceNumber = settings.instanceNumber>
<#assign moduleName = data.moduleName>
<#assign interruptadc = data.getInterrupt("ADI")>
<#if settings.usesInterrupt("ADI")>
    <#assign adcinterrupt = settings.getInterrupt("ADI")>
</#if>

/**
  ${data.moduleName} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated header file for the ${data.moduleName} driver using ${pcgConfiguration.productName}

  @Description
    This header file provides APIs for driver for ${data.moduleName}.
    Generation Information :
        Product Revision  :  ${pcgConfiguration.productName} - ${pcgConfiguration.productVersion}
        Device            :  ${pcgConfiguration.selectedDevice}
    The generated drivers are tested against the following:
        Compiler          :  ${pcgConfiguration.compiler}
        MPLAB 	          :  ${pcgConfiguration.tool}
*/

${pcgConfiguration.disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"

/**
  Section: Data Type Definitions
*/

/* ADC Driver Hardware Instance Object

  @Summary
    Defines the object required for the maintenance of the hardware instance.

  @Description
    This defines the object required for the maintenance of the hardware
    instance. This object exists once per hardware instance of the peripheral.

 */
typedef struct
{
	uint8_t intSample;
}

ADC_OBJECT;

static ADC_OBJECT adc1_obj;

/**
  Section: Driver Interface
*/

<#list settings.initializers as initializer>

void ${data.moduleName}_${initializer.customName} (void)
{
 <#-- Initialize the usart, by setting/reseting bits like UARTEN, SYNC, TXEN, BRGH, TX9, TX9D, RX9, SREN, CREN, CSRC, ADDEN, SCKP, BRG16, WUE and ABDEN. -->
   <#list initializer.registers as reg>
    // ${reg.comment}

   ${reg.name} = ${reg.value};

   </#list>

   <#assign reg = data.getRegisterByAlias("ADCON2")>
   adc1_obj.intSample = ${reg.name}bits.${reg.getSettingByAlias("SMPI").name};
   
<#if adcinterrupt??>
   // Enabling ${moduleNameUpperCase} interrupt.
   ${interruptadc.enableBitName} = 1;
</#if>
}
</#list>

void ${data.moduleName}_Start(void)
{
   <#assign reg = data.getRegisterByAlias("ADCON1")>
   ${reg.name}bits.${reg.getSettingByAlias("SAMP").name} = 1;
}
void ${data.moduleName}_Stop(void)
{
   <#assign reg = data.getRegisterByAlias("ADCON1")>
   ${reg.name}bits.${reg.getSettingByAlias("SAMP").name} = 0;
}
uint16_t ${data.moduleName}_ConversionResultBufferGet(uint16_t *buffer)
{
    int count;
    uint16_t *ADC16Ptr;

    <#assign reg = data.getRegisterByAlias("ADCBUF0")>
    ADC16Ptr = (uint16_t *)&(${reg.name});

    for(count=0;count<=adc1_obj.intSample;count++)
    {
        buffer[count] = (uint16_t)*ADC16Ptr;
        ADC16Ptr++;
    }
    return count;
}
uint16_t ${data.moduleName}_ConversionResultGet(void)
{
    <#assign reg = data.getRegisterByAlias("ADCBUF0")>
    return ${reg.name};
}
bool ${data.moduleName}_IsConversionComplete( void )
{
    <#assign reg = data.getRegisterByAlias("ADCON1")>
    return ${reg.name}bits.DONE; //Wait for conversion to complete   
}
void ${data.moduleName}_ChannelSelect( ${data.moduleName}_CHANNEL channel )
{
    <#assign reg = data.getRegisterByAlias("ADCHS")>
    ${reg.name} = channel;
}

uint16_t ${data.moduleName}_GetConversion(${data.moduleName}_CHANNEL channel)
{
    ${data.moduleName}_ChannelSelect(channel);
    
    ${data.moduleName}_Start();
    ${data.moduleName}_Stop();
    
    while (!${data.moduleName}_IsConversionComplete())
    {
    }
       
    return ${data.moduleName}_ConversionResultGet();
}

<#if settings.useInterrupt>

<#else>

</#if>
<#if settings.useInterrupt>
void __attribute__ ( ( __interrupt__ , auto_psv ) ) ${interruptadc.handlerName} ( void )
<#else>
void ${data.moduleName}_Tasks ( void )
</#if>
{
    // clear the ADC interrupt flag
    ${interruptadc.flagName} = false;
}


/**
  End of File
*/
