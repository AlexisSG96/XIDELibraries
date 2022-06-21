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
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // set the PID${instanceNumber} module to the options selected in the User Interface
    <#list initRegistersPidCtl as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    
    </#list>
    
    ${pidK1HRegister} = (uint8_t) ((${k1Value} & 0xFF00) >> 8);
    ${pidK1LRegister} = (uint8_t)  (${k1Value} & 0x00FF);
    ${pidK2HRegister} = (uint8_t) ((${k2Value} & 0xFF00) >> 8);
    ${pidK2LRegister} = (uint8_t)  (${k2Value} & 0x00FF);
    ${pidK3HRegister} = (uint8_t) ((${k3Value} & 0xFF00) >> 8);
    ${pidK3LRegister} = (uint8_t)  (${k3Value} & 0x00FF);

    <#if useDiInterrupt>       
    ${interruptFlagBit} = 0;
    ${errorInterruptFlagBit} = 0;
    ${pirEnableIntBit} = 1;
    ${pirEnableErrorIntBit} = 1;
    </#if>
}
</#list>

<#if useDiInterrupt>
void ${moduleNameUpperCase}_PIDController(int16_t setpoint, int16_t input)
{
    ${pidSETHRegister} = (uint8_t) (((uint16_t)setpoint & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (setpoint & 0x00FF);   
    ${pidINHRegister}  = (uint8_t) (((uint16_t)input & 0xFF00) >> 8);
    ${pidINLRegister}  = (uint8_t)  (input & 0x00FF);   // starts module operation
}
<#else>
MATHACCResult ${moduleNameUpperCase}_PIDControllerModeResultGet(int16_t setpoint, int16_t input)
{
    MATHACCResult result;

    ${pidSETHRegister} = (uint8_t) (((uint16_t)setpoint & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (setpoint & 0x00FF);  
    ${pidINHRegister}  = (uint8_t) (((uint16_t)input & 0xFF00) >> 8);
    ${pidINLRegister}  = (uint8_t)  (input & 0x00FF);   // starts module operation

    while (${isPidModuleBusy} == 1);  // wait for the module to complete

    result.byteLL = ${pidOutLLRegister};
    result.byteLH = ${pidOutLHRegister};
    result.byteHL = ${pidOutHLRegister};
    result.byteHH = ${pidOutHHRegister};
    result.byteU  = ${pidOutURegister};
	
    return result;
}	
</#if>      <#-- end <#if useDiInterrupt> -->   

uint32_t ${moduleNameUpperCase}_Z1Get(void)
{
    uint32_t value = 0;

    value = (uint32_t)${pidZ1LRegister} & 0x000000FF;
    value = (value | ((uint32_t)${pidZ1HRegister} << 8)) & 0x0000FFFF;
    value = (value | ((uint32_t)${pidZ1URegister} << 16)) & 0x0001FFFF;

    return value;
}

uint32_t ${moduleNameUpperCase}_Z2Get(void)
{
    uint32_t value = 0;

    value = (uint32_t)${pidZ2LRegister} & 0x000000FF;
    value = (value | ((uint32_t)${pidZ2HRegister} << 8)) & 0x0000FFFF;
    value = (value | ((uint32_t)${pidZ2URegister} << 16)) & 0x0001FFFF;

    return value;
}

void ${moduleNameUpperCase}_LoadZ1(uint32_t value)
{
    ${pidZ1LRegister} = (0x000000FF & value);
    ${pidZ1HRegister} = ((0x0000FF00 & value)>>8);
    ${pidZ1URegister} = ((0x00010000 & value)>>16);
}

void ${moduleNameUpperCase}_LoadZ2(uint32_t value)
{
    ${pidZ2LRegister} = (0x000000FF & value);
    ${pidZ2HRegister} = ((0x0000FF00 & value)>>8);
    ${pidZ2URegister} = ((0x00010000 & value)>>16);
}

MATHACCResult ${moduleNameUpperCase}_ResultGet(void)
{
    MATHACCResult data;

    data.byteLL = ${pidOutLLRegister};
    data.byteLH = ${pidOutLHRegister};
    data.byteHL = ${pidOutHLRegister};
    data.byteHH = ${pidOutHHRegister};
    data.byteU = ${pidOutURegister};

    return data;
}

void ${moduleNameUpperCase}_ClearResult(void)
{
    ${pidOutLLRegister} = 0;
    ${pidOutLHRegister} = 0;
    ${pidOutHLRegister} = 0;
    ${pidOutHHRegister} = 0;
    ${pidOutURegister}  = 0;
}

<#if useDiInterrupt>
void ${moduleNameUpperCase}_Error_ISR( void )
{
    ${errorInterruptFlagBit} = 0;
    
    // user code here for error handling
}

void ${moduleNameUpperCase}_PID_ISR( void )
{
    ${interruptFlagBit} = 0;
    
    // user code here    
}
<#else> 
bool ${moduleNameUpperCase}_HasOverflowOccured(void)
{
    bool retVal = false;
    
    if (1 == ${errorInterruptFlagBit})
    {
        retVal = true;
        ${errorInterruptFlagBit} = 0;
    }
    
    return retVal;
}
</#if>  
// end of file
     
        

        
