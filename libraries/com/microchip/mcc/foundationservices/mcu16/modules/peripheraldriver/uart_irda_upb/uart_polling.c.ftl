<#assign settings = pcgConfiguration.configuration.settings>
<#assign data = pcgConfiguration.configuration.data>
<#assign moduleNameLowerCase = data.moduleName?lower_case>
<#assign instanceNumber = settings.instanceNumber>
<#assign moduleNameUpperCase = data.moduleName?upper_case>
<#assign UTXREG = data.getRegisterByAlias("UTXREG").name>
<#assign URXREG = data.getRegisterByAlias("URXREG").name>
<#assign interruptTransmit = data.getInterrupt("UTXI")>
<#assign interruptReceive = data.getInterrupt("URXI")>

<#assign version = "2.00">
/**
  ${data.moduleName} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${data.moduleName} driver using ${pcgConfiguration.productName}

  @Description
    This header file provides implementations for driver APIs for ${data.moduleName}.
    Generation Information :
        Product Revision  :  ${pcgConfiguration.productName} - ${pcgConfiguration.productVersion}
        Device            :  ${pcgConfiguration.selectedDevice}
    The generated drivers are tested against the following:
        Compiler          :  ${pcgConfiguration.compiler}
        MPLAB             :  ${pcgConfiguration.tool}
*/

${pcgConfiguration.disclaimer}

/**
  Section: Included Files
*/
#include <xc.h>
#include "${moduleNameLowerCase}.h"

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list settings.initializers as initializer>
void ${moduleNameUpperCase}_${initializer.customName}(void)
{
    // Set the ${moduleNameUpperCase} module to the options selected in the user interface.

    <#list initializer.registers as reg>
    <#if (reg.alias=="UMODE") >
    // ${reg.comment}
    ${reg.name} = (${reg.value} & ~(1<<15)); // disabling UART ON bit  
    <#elseif (reg.name!=UTXREG) && (reg.name!=URXREG) >
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#if>   
    </#list>
     
    //Make sure to set LAT bit corresponding to TxPin as high before UART initialization
    <#assign reg = data.getRegisterByAlias("USTA")> 
    ${reg.name}SET = _${reg.name}_${reg.getSettingByAlias("UTXEN")}_MASK;
    <#assign reg = data.getRegisterByAlias("UMODE")>
    ${reg.name}SET = _${reg.name}_${reg.getSettingByAlias("UARTEN")}_MASK;  // enabling UART ON bit
    <#assign reg = data.getRegisterByAlias("USTA")>
    ${reg.name}SET = _${reg.name}_${reg.getSettingByAlias("URXEN")}_MASK; 
}

</#list>
uint8_t ${moduleNameUpperCase}_Read(void)
{
    <#assign reg = data.getRegisterByAlias("USTA")>
    while(!(${data.getRegisterByAlias("USTA").name}bits.URXDA == 1))
    {
    }

    <#assign reg = data.getRegisterByAlias("USTA")>
    if ((${reg.name}bits.${reg.getSettingByAlias("OERR").name} == 1))
    {
        ${reg.name}CLR = _${reg.name}_${reg.getSettingByAlias("OERR")}_MASK;
    }

    return ${data.getRegisterByAlias("URXREG").name};
}

void ${moduleNameUpperCase}_Write(uint8_t txData)
{
    <#assign reg = data.getRegisterByAlias("USTA")>
    while(${reg.name}bits.UTXBF == 1)
    {
    }

    ${data.getRegisterByAlias("UTXREG").name} = txData;    // Write the data byte to the USART.
}

bool ${moduleNameUpperCase}_IsRxReady(void)
{
    return ${data.getRegisterByAlias("USTA").name}bits.URXDA;
}

bool ${moduleNameUpperCase}_IsTxReady(void)
{
    return (${reg.name}bits.${reg.getSettingByAlias("TRMT").name} && ${reg.name}bits.${reg.getSettingByAlias("UTXEN").name} );
}

bool ${moduleNameUpperCase}_IsTxDone(void)
{
    return ${reg.name}bits.${reg.getSettingByAlias("TRMT").name};
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
${data.moduleName}_STATUS __attribute__((deprecated)) ${data.moduleName}_StatusGet (void)
{
    <#assign reg = data.getRegisterByAlias("USTA")>
    return ${reg.name};
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${data.moduleName}_DataReady(void)
{
    return ${moduleNameUpperCase}_IsRxReady();
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_ready(void)
{
    return ${moduleNameUpperCase}_IsTxReady();
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_rx_ready(void)
{
    return ${moduleNameUpperCase}_IsRxReady();
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_done(void)
{
    return ${moduleNameUpperCase}_IsTxDone();
}

<#if settings.usePrintf>
void _mon_putc(char c) {
    ${moduleNameUpperCase}_Write(c);
}
</#if>
