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
    <#list initRegistersAddMulti as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>

    <#if useEiInterrupt>            
    ${interruptFlagBit} = 0;
    ${errorInterruptFlagBit} = 0;
    ${pirEnableIntBit} = 1;
    ${pirEnableErrorIntBit} = 1;
    </#if>
}
</#list>

  
<#if useEiInterrupt>    
void ${moduleNameUpperCase}_AdditionAndMultiplication(uint16_t a, uint16_t b, uint16_t c)
{
    ${pidK1HRegister}  = (uint8_t) ((c & 0xFF00) >> 8);
    ${pidK1LRegister}  = (uint8_t)  (c & 0x00FF);
    ${pidSETHRegister} = (uint8_t) ((b & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (b & 0x00FF);
    ${pidINHRegister}  = (uint8_t) ((a & 0xFF00) >> 8);
    ${pidINLRegister}  = (uint8_t)  (a & 0x00FF);   // starts module operation
}

void ${moduleNameUpperCase}_Addition(uint16_t a, uint16_t b)
{
    ${pidK1HRegister}  = 0;
    ${pidK1LRegister}  = 1;
    ${pidSETHRegister} = (uint8_t) ((b & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (b & 0x00FF);
    ${pidINHRegister}  = (uint8_t) ((a & 0xFF00) >> 8);
    ${pidINLRegister}  = (uint8_t)  (a & 0x00FF);   // starts module operation
}
void ${moduleNameUpperCase}_Multiplication(uint16_t b, uint16_t c)
{
    ${pidK1HRegister}  = (uint8_t) ((c & 0xFF00) >> 8);
    ${pidK1LRegister}  = (uint8_t)  (c & 0x00FF);
    ${pidSETHRegister} = (uint8_t) ((b & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (b & 0x00FF);
    ${pidINHRegister}  = 0;
    ${pidINLRegister}  = 0;    // starts module operation
}
<#else>     
MATHACCResult ${moduleNameUpperCase}_AdditionAndMultiplicationResultGet(uint16_t a, uint16_t b, uint16_t c)
{
    MATHACCResult result;	
    ${pidK1HRegister}  = (uint8_t) ((c & 0xFF00) >> 8);
    ${pidK1LRegister}  = (uint8_t)  (c & 0x00FF);
    ${pidSETHRegister} = (uint8_t) ((b & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (b & 0x00FF);
    ${pidINHRegister}  = (uint8_t) ((a & 0xFF00) >> 8);
    ${pidINLRegister}  = (uint8_t)  (a & 0x00FF);   // starts module operation
	
    while (${isPidModuleBusy} == 1);  // wait for the module to complete 
	
    result.byteLL = ${pidOutLLRegister};
    result.byteLH = ${pidOutLHRegister};
    result.byteHL = ${pidOutHLRegister};
    result.byteHH = ${pidOutHHRegister};
    result.byteU  = ${pidOutURegister};
	
    return result;
}

MATHACCResult ${moduleNameUpperCase}_AdditionResultGet(uint16_t a, uint16_t b)
{
    MATHACCResult result;
	
	${pidK1HRegister}  = 0;
    ${pidK1LRegister}  = 1;   
    ${pidSETHRegister} = (uint8_t) ((b & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t) (b & 0x00FF);
    ${pidINHRegister}  = (uint8_t) ((a & 0xFF00) >> 8);
    ${pidINLRegister}  = (uint8_t) (a & 0x00FF);   // starts module operation
	
    while (${isPidModuleBusy} == 1);  // wait for the module to complete
	
    result.byteLL = ${pidOutLLRegister};
    result.byteLH = ${pidOutLHRegister};
    result.byteHL = ${pidOutHLRegister};
    result.byteHH = ${pidOutHHRegister};
    result.byteU  = ${pidOutURegister};
	
    return result;
}

MATHACCResult ${moduleNameUpperCase}_MultiplicationResultGet(uint16_t b, uint16_t c)
{
    MATHACCResult result;
	
    ${pidK1HRegister}  = (uint8_t) ((c & 0xFF00) >> 8);
    ${pidK1LRegister}  = (uint8_t)  (c & 0x00FF);
    ${pidSETHRegister} = (uint8_t) ((b & 0xFF00) >> 8);
    ${pidSETLRegister} = (uint8_t)  (b & 0x00FF);
    ${pidINHRegister}  = 0;
    ${pidINLRegister}  = 0;    // starts module operation
	
    while (${isPidModuleBusy} == 1);  // wait for the module to complete
	
    result.byteLL = ${pidOutLLRegister};
    result.byteLH = ${pidOutLHRegister};
    result.byteHL = ${pidOutHLRegister};
    result.byteHH = ${pidOutHHRegister};
    result.byteU  = ${pidOutURegister};

    return result;
}
</#if>      <#-- end <#if useEiInterrupt> -->                  

MATHACCResult ${moduleNameUpperCase}_ResultGet(void)
{
    MATHACCResult data;

    data.byteLL = ${pidOutLLRegister};
    data.byteLH = ${pidOutLHRegister};
    data.byteHL = ${pidOutHLRegister};
    data.byteHH = ${pidOutHHRegister};
    data.byteU  = ${pidOutURegister};

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

<#if useEiInterrupt>
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
     
        

        
