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
        Driver Version    :  2.11
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"
<#if usingCRCInterrupt>
<#if usingCRCVectoredInterrupt>
#include "interrupt_manager.h"
</#if>
<#elseif usingSCANInterrupt>
<#if usingSCANVectoredInterrupt>
#include "interrupt_manager.h"
</#if>
</#if>

/**
 Section: Structures
 */

typedef struct
{
    uint8_t dataWidth;
    uint8_t polyWidth;
    uint8_t seedDirection;
}CRC_OBJ;

/**
 Section: Private Data
 */

static CRC_OBJ crcObj;

<#if usingCRCInterrupt>

static uint8_t crcBufferHead = 0;
static uint8_t crcBufferTail = 0;
static uint8_t crcBuffer[CRC_BUFFER_SIZE];
volatile uint8_t crcBufferRemaining;

</#if>

/**
  Section: CRCSCAN APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    uint16_t poly;
    uint16_t seed;    
    <#if isSeedNonZero>
    <#if isSeedDirect>
    <#else>             
    uint16_t crccon1Value;
    </#if>
    </#if>

    <#list initRegisters as reg>
    <#if reg.name=="CRCCON1">
    // ${reg.comment}
    <#if isSeedDirect>
    ${reg.name} = (${DataLengthSetting} << 4) | (${PolynomialLengthSetting});
    <#else>
    <#if isSeedNonZero>
    ${reg.name} = (${PolynomialLengthSetting} << 4) | (${PolynomialLengthSetting});
    crccon1Value = (${DataLengthSetting} << 4) | (${PolynomialLengthSetting});
    <#else>
    ${reg.name} = (${DataLengthSetting} << 4) | (${PolynomialLengthSetting});        
    </#if>
    </#if>
    <#else>
    <#if reg.name == "CRCXORL" || reg.name== "CRCXORH" || reg.name == "CRCSHIFTL" || reg.name == "CRCSHIFTH" || reg.name == "CRCDATL" || reg.name == "CRCDATH" >
    <#else>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#if>
    </#if>
    </#list>

    poly = ${PolynomialValueSetting};
    ${PolynomialHighByte} = poly >> 8;
    ${PolynomialLowByte} = poly;

    <#if isSeedDirect>
    seed  = ${SeedValueSetting};
    // CRCACC ${SeedValueSetting}
    ${ResultHighByte} = seed >> 8;
    ${ResultLowByte} = seed;
    <#else>        
    <#if isSeedNonZero>
    seed = ${SeedValueSetting};
    // CRCDAT ${SeedValueSetting}
    ${DataHighByte} = seed >> 8;
    ${DataLowByte} = seed;

    // Run the seed through the shift register
    ${CRCInterruptFlag} = 0;
    <#if usingCRCInterrupt>
    ${CRCInterruptEnableBit} = 0;
    </#if>

    <#if DataShiftDirectionSetting != SeedShiftDirectionSetting>
    ${ShiftModebit} ^= 1;
    </#if>
    ${CRCStartBit} = 1;
    while(${CRCInterruptFlag} == 0);
    ${CRCStartBit} = 0;
    <#if DataShiftDirectionSetting != SeedShiftDirectionSetting>
    ${ShiftModebit} ^= 1;
    </#if>
    <#if usingCRCInterrupt>
    <#else>

    ${CRCInterruptFlag} = 0;
    </#if>

    ${CRCControlRegister1} = crccon1Value;
    <#else>
    seed = ${SeedValueSetting};
    // CRCACC ${SeedValueSetting}
    ${ResultHighByte} = seed >> 8;
    ${ResultLowByte} = seed;
    </#if>
    </#if>
    <#if isSeedDirect>
    <#else>
    <#if DataShiftDirectionSetting != SeedShiftDirectionSetting>
    ${moduleNameLowerCase}Obj.seedDirection = ${ShiftModebit} ^ 1;
    <#else>
    ${moduleNameLowerCase}Obj.seedDirection = ${ShiftModebit};
    </#if>
    </#if>

    ${moduleNameLowerCase}Obj.dataWidth = (uint8_t)(${DataLengthregister} + 1);
    ${moduleNameLowerCase}Obj.polyWidth = (uint8_t)(${PolynomialLengthRegister} + 1);
    <#if usingCRCInterrupt>
    // Clearing circular buffer head and tail
    crcBufferHead = 0;
    crcBufferTail = 0;
    crcBufferRemaining = sizeof (crcBuffer);
    // Clear interrupt flag
    ${CRCInterruptFlag} = 0;
    // Enable interrupt
    ${CRCInterruptEnableBit} = 1;
    </#if>
    <#if usingSCANInterrupt>

    // Clear interrupt flag
    ${SCANInterruptFlag} = 0;
    // Enable interrupt
    ${SCANInterruptEnableBit} = 1;
    </#if> 
}
</#list>

void ${moduleNameUpperCase}_Start(void)
{
    // Start the serial shifter
    ${CRCStartBit} = 1;
}

<#if usingCRCInterrupt>
<#if isDataWidthGT8>
bool ${moduleNameUpperCase}_16BitBufferWrite(uint16_t data)
{
    if(!crcBufferRemaining)
    {
        return(0);
    }
    else
    {
        if((crcBufferRemaining==sizeof(crcBuffer)) || (CRCCON0bits.FULL == 0))
        {
            // Write 16-bit data
            CRCDATH = data >> 8;
            CRCDATL = data;
        }
        else
        {
            // Write data into CRC software buffer

            crcBuffer[crcBufferHead] = data;
            crcBuffer[crcBufferHead+1] = data >> 8;
            crcBufferHead += 2;
            crcBufferRemaining-=2;

            if(sizeof(crcBuffer) <= crcBufferHead)
            {
                crcBufferHead = 0;
            }
        }
    return(1);
    }
}
<#else>
bool ${moduleNameUpperCase}_8BitBufferWrite(uint8_t data)
{
    if(!crcBufferRemaining)
    {
      return(0);
    }
    else
    {
        if((crcBufferRemaining==sizeof(crcBuffer)) || (CRCCON0bits.FULL == 0))
        {
            // Write 8-bit data
            CRCDATL = (uint8_t)data;
        }
        else
        {
            // Write data into CRC software buffer
            crcBuffer[crcBufferHead] = data;
            crcBufferHead++;
            crcBufferRemaining--;

            if(sizeof(crcBuffer) <= crcBufferHead)
            {
                crcBufferHead = 0;
            }
        }
        return(1);
    }
}
</#if>
<#else>
<#if isDataWidthGT8>
bool ${moduleNameUpperCase}_16BitDataWrite(uint16_t data)
{
    if(!CRCCON0bits.FULL)
    {
        CRCDATH = data >> 8;
        CRCDATL = data;
        return (1);
    }
    else
    {
        return (0);
    }
}
<#else>
bool ${moduleNameUpperCase}_8BitDataWrite(uint8_t data)
{
    if(!CRCCON0bits.FULL)
    {
        CRCDATL = data;
        return(1);
    }
    else
    {
        return(0);
    }
}
</#if>
</#if>

static uint16_t ${moduleNameUpperCase}_ReverseValue(uint16_t crc)
{
    uint16_t mask;
    uint16_t reverse;

    mask = 1;
    mask <<= crcObj.polyWidth - 1;
    reverse = 0;

    while(crc)
    {
        if(crc & 0x01)
        {
            reverse |= mask;
        }
        mask >>= 1;
        crc >>= 1;
    }
    return reverse;
}

uint16_t ${moduleNameUpperCase}_CalculatedResultGet(bool reverse, uint16_t xorValue)
{
    uint16_t result,mask;
     
    <#if !isDataAugmented>
     // augmentation logic
     ${CRCStartBit} = 0;
     ${CRCInterruptFlag} = 0;
     <#if usingCRCInterrupt>
     ${CRCInterruptEnableBit} = 0;
     </#if>
     ${DataLengthregister}= ${PolynomialLengthRegister};
     
     if(${moduleNameLowerCase}Obj.polyWidth > 8)
     {
         ${DataHighByte} = 0;
         ${DataLowByte} = 0;  
     }
     else
     {
         ${DataLowByte} = 0;
     }
     
     ${CRCStartBit} = 1;
     while(${CRCInterruptFlag} == 0);
     ${CRCInterruptFlag} = 0;
     
     ${CRCStartBit} = 0;
     ${DataLengthregister} = (uint8_t)(${moduleNameLowerCase}Obj.dataWidth - 1);
     <#if usingCRCInterrupt>
     ${CRCInterruptEnableBit} = 1;   
     </#if>     
     </#if>        
     // Read result
     result = ((uint16_t)${ResultHighByte} << 8)|${ResultLowByte};
     if(${moduleNameLowerCase}Obj.polyWidth < 16)
     {
       // Polynomial mask   
        mask = (uint16_t)((1 << ${moduleNameLowerCase}Obj.polyWidth) - 1);
        result &= mask;
     }

    if(reverse)
        result = CRC_ReverseValue(result);

    result ^= xorValue;

    return result;
}

bool ${moduleNameUpperCase}_IsBusy(void)
{
    // Is shifting in progress?
    return(CRCCON0bits.BUSY);
}

void ${moduleNameUpperCase}_SCAN_StartScanner(void)
{
    // Start the CRC serial shifter
    ${CRCStartBit} = 1;

    // Start the scanner
    ${SCANStartBit} = 1;
}

void ${moduleNameUpperCase}_SCAN_StopScanner(void)
{
    // Stop the scanner
    ${SCANStartBit} = 0;

    // Stop the CRC serial shifter
    ${CRCStartBit} = 0;
}

<#if isAddress32Bit>
void ${moduleNameUpperCase}_SCAN_SetAddressLimit(uint32_t startAddr, uint32_t endAddr)
{
    // Load end address limit
    <#--SCANLADRH = startAddr >> 8;-->
    <#--SCANLADRL = startAddr;--> 
	${SCANHighAddrUpperByte} = 0x3F & (endAddr >> 16);
	${SCANHighAddrHighByte} = 0xFF & (endAddr >> 8);
	${SCANHighAddrLowByte} = 0xFF & endAddr;
	
    // Load start address limit
    <#--SCANHADRH = endAddr >> 8;-->
    <#--SCANHADRL = endAddr;-->
	${SCANLowAddrUpperByte} = 0x3F & (startAddr >> 16);
	${SCANLowAddrHighByte} = 0xFF & (startAddr >> 8);
	${SCANLowAddrLowByte} = 0xFF & startAddr;
}
<#else>
void ${moduleNameUpperCase}_SCAN_SetAddressLimit(uint16_t startAddr, uint16_t endAddr)
{
    // Load end address limit
    <#--SCANLADRH = startAddr >> 8;-->
    <#--SCANLADRL = startAddr;--> 
	${SCANHighAddrHighByte} = 0xFF & (endAddr >> 8);
	${SCANHighAddrLowByte} = 0xFF & endAddr;
	
    // Load start address limit
    <#--SCANHADRH = endAddr >> 8;-->
    <#--SCANHADRL = endAddr;-->
	${SCANLowAddrHighByte} = 0xFF & (startAddr >>8);
	${SCANLowAddrLowByte} = 0xFF & startAddr;
}
</#if>

<#if isSCANAddressInvalid>
bool ${moduleNameUpperCase}_SCAN_HasInvalidAddressOccured(void)
{
    // SCANLADRH/L contains invalid address?
    return(SCANCON0bits.INVALID);
}
</#if>

bool ${moduleNameUpperCase}_SCAN_IsScannerBusy(void)
{
    // Is scanner in progress?
    return(SCANCON0bits.BUSY);
}
<#if usingSCANInterrupt>
<#else>

bool ${moduleNameUpperCase}_SCAN_HasScanCompleted(void)
{
    // Has scanning completed?
    <#--bool status = PIR4bits.SCANIF && PIR4bits.CRCIF;-->
    bool status = (unsigned char)(${SCANInterruptFlag} && ${CRCInterruptFlag});
    if(status)
    {
        <#--MCCV3XX-1949-->
        <#--PIR4bits.CRCIF = 0;-->
        <#--PIR4bits.SCANIF = 0;-->
        ${CRCInterruptFlag} = 0;
        ${SCANInterruptFlag} = 0;        
    }
    return(status);
}
</#if>

<#if usingCRCInterrupt>
<#if usingCRCVectoredInterrupt>
<#if isCRCInterruptHighPriority>
void __interrupt(irq(${InterruptIRQNameCRC}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionNameCRC}()
<#else>
void __interrupt(irq(${InterruptIRQNameCRC}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionNameCRC}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionNameCRC}(void)
</#if>
{
    // Clear CRC interrupt flag
    <#--MCCV3XX-1949-->
    <#--PIR4bits.CRCIF = 0;-->
    ${CRCInterruptFlag} = 0;

    if(sizeof(crcBuffer) > crcBufferRemaining)
    {
        <#if isDataWidthGT8>
        CRCDATH = crcBuffer[crcBufferTail+1];
        CRCDATL = crcBuffer[crcBufferTail];
        crcBufferTail += 2;
        crcBufferRemaining+=2;
        <#else>
        CRCDATL = crcBuffer[crcBufferTail];
        crcBufferTail++;
        crcBufferRemaining++;
        </#if>
        if(sizeof(crcBuffer) <= crcBufferTail)
        {
            crcBufferTail = 0;
        }
    }
}
</#if>

<#if usingSCANInterrupt>
<#if usingSCANVectoredInterrupt>
<#if isSCANInterruptHighPriority>
void __interrupt(irq(${InterruptIRQNameSCAN}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionNameSCAN}()
<#else>
void __interrupt(irq(${InterruptIRQNameSCAN}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionNameSCAN}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionNameSCAN}(void)
</#if>
{
    // Clear SCANIF flag
    <#--MCCV3XX-1949-->
    <#--PIR4bits.SCANIF = 0;-->
    ${SCANInterruptFlag} = 0;    

    //User code here
}
</#if>
/**
 End of File
*/
