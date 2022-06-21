/**
  ${moduleNameUpperCaseNew} Generated Driver  File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCaseNew}.c

  @Summary
    This is the generated driver implementation for the ${moduleNameUpperCaseNew} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.12.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCaseNew}.h"

<#list newInterruptArray as eachComponent>
<#list eachComponent.interrupts as eachInterrupt>
<#if eachInterrupt.usesHandler>
static void (*${eachInterrupt.handler})(void);
</#if>
</#list>
</#list>

/**
    Local Functions
*/  
static uint32_t convertReg2ExtendedCANid(uint8_t tempRXBn_EIDH, uint8_t tempRXBn_EIDL, uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL);
static uint32_t convertReg2StandardCANid(uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL);
static void convertCANid2Reg(uint32_t tempPassedInID, uint8_t canIdType, uint8_t *passedInEIDH, uint8_t *passedInEIDL, uint8_t *passedInSIDH, uint8_t *passedInSIDL);

<#list newInterruptArray as eachComponent>
<#list eachComponent.interrupts as eachInterrupt>
<#if eachInterrupt.usesHandler>
static void ${eachInterrupt.intDefHandlerName}(void) {}
</#if>
</#list>
</#list>

<#list initializers as initializer>
void ${initializer}(void)
{
    ${canConfigurationRegister} = 0x80;
    while (0x80 != (${canStatusRegister} & 0xE0)); // wait until ECAN is in config mode
    
    /**
    Mode 0
    */
    ${eCanControlRegister} = 0x00;
    
    /**
    Initialize CAN I/O
    */
    <#list initCioconRegister as reg>
    ${reg.name} = ${reg.value};
    </#list>
    
    ${canAddressTable}
 
/**    
    Initialize Receive Masks
*/   
<#-- the order the register are loaded is important -->    
    <#list initReceiveMasksRegisters as reg>
    ${reg.name} = ${reg.value};
    </#list>
 
    /**
    Initialize Receive Filters
    */   
    <#list initReceiveFiltersMode0Registers as reg>
    ${reg.name} = ${reg.value};
    </#list>

    /**
    Initialize CAN Timings
    */
    
  	/**
        Baud rate: ${baudRate}
        System frequency: ${systemFrequrncy}
        ECAN clock frequency: ${canClockFrequency}
        Time quanta: ${timeQuanta}
        Sample point: ${samplePoints}
        Sample point: ${samplePointsPercentage}
	*/ 
    
    <#list initCanTimingsRegisters as reg>
    ${reg.name} = ${reg.value};
    </#list>
    
    <#list newInterruptArray as eachComponent>
    <#list eachComponent.interrupts as eachInterrupt>
    <#if eachInterrupt.usesHandler>
    ${moduleNameUpperCaseNew}_${eachInterrupt.intHandlerName}(${eachInterrupt.intDefHandlerName});
    </#if>
    <#if eachInterrupt.shouldInitialize>
    ${eachInterrupt.flagName} = 0;
    ${eachInterrupt.enableName} = 1;
    
    </#if>
    </#list>
    </#list>   
    ${canConfigurationRegister} = 0x00;
    while (0x00 != (${canStatusRegister} & 0xE0)); // wait until ECAN is in Normal mode   
    
}
</#list>
/**
  Section: ${moduleNameUpperCase} APIs
*/

void CAN_sleep(void) 
{
    ${canConfigurationRegister} = 0x20; // request disable mode
    while ((${canStatusRegister} & 0xE0) != 0x20); // wait until ECAN is in disable mode   
    //Wake up from sleep should set the CAN module straight into Normal mode

}

uint8_t CAN_transmit(uCAN_MSG *tempCanMsg) {
    uint8_t tempEIDH = 0;
    uint8_t tempEIDL = 0;
    uint8_t tempSIDH = 0;
    uint8_t tempSIDL = 0;

    uint8_t returnValue = 0;

    if (${transmit0RequestStatusbit} != 1) 
    {
        convertCANid2Reg(tempCanMsg->frame.id, tempCanMsg->frame.idType, &tempEIDH, &tempEIDL, &tempSIDH, &tempSIDL);

        ${txBuff0ExtdIdRegisterHigh} = tempEIDH;
        ${txBuff0ExtdIdRegisterLow} = tempEIDL;
        ${txBuff0StdIdRegisterHigh} = tempSIDH;
        ${txBuff0StdIdRegisterLow} = tempSIDL;
        ${txBuff0DataLengthRegister}  = tempCanMsg->frame.dlc;
        ${txBuff0DataField0Register}   = tempCanMsg->frame.data0;
        ${txBuff0DataField1Register}   = tempCanMsg->frame.data1;
        ${txBuff0DataField2Register}   = tempCanMsg->frame.data2;
        ${txBuff0DataField3Register}   = tempCanMsg->frame.data3;
        ${txBuff0DataField4Register}   = tempCanMsg->frame.data4;
        ${txBuff0DataField5Register}   = tempCanMsg->frame.data5;
        ${txBuff0DataField6Register}   = tempCanMsg->frame.data6;
        ${txBuff0DataField7Register}   = tempCanMsg->frame.data7;

        ${transmit0RequestStatusbit} = 1; //Set the buffer to transmit		
        returnValue = 1;
        
    } 
    else if (${transmit1RequestStatusbit} != 1) 
    {

        convertCANid2Reg(tempCanMsg->frame.id, tempCanMsg->frame.idType, &tempEIDH, &tempEIDL, &tempSIDH, &tempSIDL);

        ${txBuff1ExtdIdRegisterHigh} = tempEIDH;
        ${txBuff1ExtdIdRegisterLow} = tempEIDL;
        ${txBuff1StdIdRegisterHigh} = tempSIDH;
        ${txBuff1StdIdRegisterLow} = tempSIDL;
        ${txBuff1DataLengthRegister}  = tempCanMsg->frame.dlc;
        ${txBuff1DataField0Register}   = tempCanMsg->frame.data0;
        ${txBuff1DataField1Register}   = tempCanMsg->frame.data1;
        ${txBuff1DataField2Register}   = tempCanMsg->frame.data2;
        ${txBuff1DataField3Register}   = tempCanMsg->frame.data3;
        ${txBuff1DataField4Register}   = tempCanMsg->frame.data4;
        ${txBuff1DataField5Register}   = tempCanMsg->frame.data5;
        ${txBuff1DataField6Register}   = tempCanMsg->frame.data6;
        ${txBuff1DataField7Register}   = tempCanMsg->frame.data7;

        ${transmit1RequestStatusbit} = 1; //Set the buffer to transmit		
        returnValue = 1;
    } 
    else if (${transmit2RequestStatusbit} != 1) 
    {

        convertCANid2Reg(tempCanMsg->frame.id, tempCanMsg->frame.idType, &tempEIDH, &tempEIDL, &tempSIDH, &tempSIDL);

        ${txBuff2ExtdIdRegisterHigh} = tempEIDH;
        ${txBuff2ExtdIdRegisterLow} = tempEIDL;
        ${txBuff2StdIdRegisterHigh} = tempSIDH;
        ${txBuff2StdIdRegisterLow} = tempSIDL;
        ${txBuff2DataLengthRegister}  = tempCanMsg->frame.dlc;
        ${txBuff2DataField0Register}   = tempCanMsg->frame.data0;
        ${txBuff2DataField1Register}   = tempCanMsg->frame.data1;
        ${txBuff2DataField2Register}   = tempCanMsg->frame.data2;
        ${txBuff2DataField3Register}   = tempCanMsg->frame.data3;
        ${txBuff2DataField4Register}   = tempCanMsg->frame.data4;
        ${txBuff2DataField5Register}   = tempCanMsg->frame.data5;
        ${txBuff2DataField6Register}   = tempCanMsg->frame.data6;
        ${txBuff2DataField7Register}   = tempCanMsg->frame.data7;

        ${transmit2RequestStatusbit} = 1; //Set the buffer to transmit		
        returnValue = 1;
    }

    return (returnValue);
}

uint8_t CAN_receive(uCAN_MSG *tempCanMsg) 
{
    uint8_t returnValue = 0;

         //check which buffer the CAN message is in
    if (${rxBuff0RxBuffFullStatusBit} != 0) //CheckRXB0
    {
        if ((${rxBuff0StdIdRegisterLow} & 0x08) == 0x08) //If Extended Message
        {
            //message is extended
            tempCanMsg->frame.idType = (uint8_t) dEXTENDED_CAN_MSG_ID_2_0B;
            tempCanMsg->frame.id     = convertReg2ExtendedCANid(${rxBuff0ExtdIdRegisterHigh}, ${rxBuff0ExtdIdRegisterLow}, ${rxBuff0StdIdRegisterHigh}, ${rxBuff0StdIdRegisterLow});
        } 
        else 
        {
            //message is standard
            tempCanMsg->frame.idType = (uint8_t) dSTANDARD_CAN_MSG_ID_2_0B;
            tempCanMsg->frame.id     = convertReg2StandardCANid(${rxBuff0StdIdRegisterHigh}, ${rxBuff0StdIdRegisterLow});
        }

        tempCanMsg->frame.dlc   = ${rxBuff0DataLengthRegister};
        tempCanMsg->frame.data0 = ${rxBuff0DataField0Register};
        tempCanMsg->frame.data1 = ${rxBuff0DataField1Register};
        tempCanMsg->frame.data2 = ${rxBuff0DataField2Register};
        tempCanMsg->frame.data3 = ${rxBuff0DataField3Register};
        tempCanMsg->frame.data4 = ${rxBuff0DataField4Register};
        tempCanMsg->frame.data5 = ${rxBuff0DataField5Register};
        tempCanMsg->frame.data6 = ${rxBuff0DataField6Register};
        tempCanMsg->frame.data7 = ${rxBuff0DataField7Register};
        ${rxBuff0RxBuffFullStatusBit} = 0;
        returnValue = 1;
    } 
    else if (${rxBuff1RxBuffFullStatusBit} != 0) //CheckRXB1
    {
        if ((${rxBuff1StdIdRegisterLow} & 0x08) == 0x08) //If Extended Message
        {
            //message is extended
            tempCanMsg->frame.idType = (uint8_t) dEXTENDED_CAN_MSG_ID_2_0B;
            tempCanMsg->frame.id     = convertReg2ExtendedCANid(${rxBuff1ExtdIdRegisterHigh}, ${rxBuff1ExtdIdRegisterLow}, ${rxBuff1StdIdRegisterHigh}, ${rxBuff1StdIdRegisterLow});
        }
        else
        {
            //message is standard
            tempCanMsg->frame.idType = (uint8_t) dSTANDARD_CAN_MSG_ID_2_0B;
            tempCanMsg->frame.id     = convertReg2StandardCANid(${rxBuff1StdIdRegisterHigh}, ${rxBuff1StdIdRegisterLow});
        }

        tempCanMsg->frame.dlc   = ${rxBuff1DataLengthRegister};
        tempCanMsg->frame.data0 = ${rxBuff1DataField0Register};
        tempCanMsg->frame.data1 = ${rxBuff1DataField1Register};
        tempCanMsg->frame.data2 = ${rxBuff1DataField2Register};
        tempCanMsg->frame.data3 = ${rxBuff1DataField3Register};
        tempCanMsg->frame.data4 = ${rxBuff1DataField4Register};
        tempCanMsg->frame.data5 = ${rxBuff1DataField5Register};
        tempCanMsg->frame.data6 = ${rxBuff1DataField6Register};
        tempCanMsg->frame.data7 = ${rxBuff1DataField7Register};
        ${rxBuff1RxBuffFullStatusBit} = 0;
        returnValue = 1;
    }
    return (returnValue);
}

uint8_t CAN_messagesInBuffer(void) 
{
    uint8_t messageCount = 0;
    if (${rxBuff0RxBuffFullStatusBit} != 0) //CheckRXB0
    {
        messageCount++;
    }
    if (${rxBuff1RxBuffFullStatusBit} != 0) //CheckRXB1
    {
        messageCount++;
    }

    return (messageCount);
}

uint8_t CAN_isBusOff(void) 
{
    uint8_t returnValue = 0;

    //COMSTAT bit 5 TXBO: Transmitter Bus-Off bit
    //1 = Transmit error counter > 255
    //0 = Transmit error counter less then or equal to 255

    if (${txBusOffbit} == 1) {
        returnValue = 1;
    }
    return (returnValue);
}

uint8_t CAN_isRXErrorPassive(void) 
{
    uint8_t returnValue = 0;

    //COMSTAT bit 3 RXBP: Receiver Bus Passive bit
    //1 = Receive error counter > 127
    //0 = Receive error counter less then or equal to 127

    if (${rxBusErrorPassiveBit} == 1) {
        returnValue = 1;
    }
    return (returnValue);
}

uint8_t CAN_isTXErrorPassive(void) 
{
    uint8_t returnValue = 0;

    //COMSTAT bit 4 TXBP: Transmitter Bus Passive bit
    //1 = Transmit error counter > 127
    //0 = Transmit error counter less then or equal to 127

    if (${txBusErrorPassiveBit} == 1) 
    {
        returnValue = 1;
    }
    return (returnValue);
}

/**
Internal functions
*/


static uint32_t convertReg2ExtendedCANid(uint8_t tempRXBn_EIDH, uint8_t tempRXBn_EIDL, uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL) 
{
    uint32_t returnValue = 0;
    uint32_t ConvertedID = 0;
    uint8_t CAN_standardLo_ID_lo2bits;
    uint8_t CAN_standardLo_ID_hi3bits;

    CAN_standardLo_ID_lo2bits = (uint8_t)(tempRXBn_SIDL & 0x03);
    CAN_standardLo_ID_hi3bits = (uint8_t)(tempRXBn_SIDL >> 5);
    ConvertedID = (uint32_t)(tempRXBn_SIDH << 3);
    ConvertedID = ConvertedID + CAN_standardLo_ID_hi3bits;
    ConvertedID = (ConvertedID << 2);
    ConvertedID = ConvertedID + CAN_standardLo_ID_lo2bits;
    ConvertedID = (ConvertedID << 8);
    ConvertedID = ConvertedID + tempRXBn_EIDH;
    ConvertedID = (ConvertedID << 8);
    ConvertedID = ConvertedID + tempRXBn_EIDL;
    returnValue = ConvertedID;    
    return (returnValue);
}

static uint32_t convertReg2StandardCANid(uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL) 
{
    uint32_t returnValue = 0;
    uint32_t ConvertedID;
    //if standard message (11 bits)
    //EIDH = 0 + EIDL = 0 + SIDH + upper three bits SIDL (3rd bit needs to be clear)
    //1111 1111 111
    ConvertedID = (uint32_t)(tempRXBn_SIDH << 3);
    ConvertedID = ConvertedID + (uint32_t)(tempRXBn_SIDL >> 5);
    returnValue = ConvertedID;
    return (returnValue);
}

static void convertCANid2Reg(uint32_t tempPassedInID, uint8_t canIdType, uint8_t *passedInEIDH, uint8_t *passedInEIDL, uint8_t *passedInSIDH, uint8_t *passedInSIDL) 
{
    uint8_t wipSIDL = 0;

    if (canIdType == dEXTENDED_CAN_MSG_ID_2_0B) {

        //EIDL
        *passedInEIDL = 0xFF & tempPassedInID; //CAN_extendedLo_ID_TX1 = &HFF And CAN_UserEnter_ID_TX1
        tempPassedInID = tempPassedInID >> 8; //CAN_UserEnter_ID_TX1 = CAN_UserEnter_ID_TX1 >> 8

        //EIDH
        *passedInEIDH = 0xFF & tempPassedInID; //CAN_extendedHi_ID_TX1 = &HFF And CAN_UserEnter_ID_TX1
        tempPassedInID = tempPassedInID >> 8; //CAN_UserEnter_ID_TX1 = CAN_UserEnter_ID_TX1 >> 8

        //SIDL
        //push back 5 and or it
        wipSIDL = 0x03 & tempPassedInID;
        tempPassedInID = tempPassedInID << 3; //CAN_UserEnter_ID_TX1 = CAN_UserEnter_ID_TX1 << 3
        wipSIDL = (0xE0 & tempPassedInID) + wipSIDL;
        wipSIDL = (uint8_t)(wipSIDL + 0x08); // TEMP_CAN_standardLo_ID_TX1 = TEMP_CAN_standardLo_ID_TX1 + &H8
        *passedInSIDL = (uint8_t)(0xEB & wipSIDL); //CAN_standardLo_ID_TX1 = &HEB And TEMP_CAN_standardLo_ID_TX1

        //SIDH
        tempPassedInID = tempPassedInID >> 8;
        *passedInSIDH = 0xFF & tempPassedInID;
    } 
    else //(canIdType == dSTANDARD_CAN_MSG_ID_2_0B)
    {
        *passedInEIDH = 0;
        *passedInEIDL = 0;
        tempPassedInID = tempPassedInID << 5;
        *passedInSIDL = 0xFF & tempPassedInID;
        tempPassedInID = tempPassedInID >> 8;
        *passedInSIDH = 0xFF & tempPassedInID;
    }
}

<#list newInterruptArray as eachComponent>
<#list eachComponent.interrupts as eachInterrupt>
<#if eachInterrupt.usesHandler>
void ${moduleNameUpperCaseNew}_${eachInterrupt.intHandlerName}(void (*handler)(void))
{
    ${eachInterrupt.handler} = handler;
}

</#if>
<#if eachInterrupt.hasISR>
<#if isVectoredInterruptEnabled>
<#if eachInterrupt.highPriority>
void __interrupt(irq(${eachInterrupt.IRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCaseNew}_${eachInterrupt.ISRName}(void)
<#else>
void __interrupt(irq(${eachInterrupt.IRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCaseNew}_${eachInterrupt.ISRName}(void)
</#if>
<#else>
void ${moduleNameUpperCaseNew}_${eachInterrupt.ISRName}(void)
</#if>
{
    <#list eachComponent.children as eachHandler>
    <#if eachHandler.varName != eachInterrupt.varName>
    if (${eachHandler.flagName})
    {
        ${eachHandler.handler}();
        <#if eachHandler.shouldManuallyClearFlag>
        ${eachHandler.flagName} = 0;
        </#if>
    }
    
    </#if>
    </#list>
    <#if eachInterrupt.usesHandler>
    ${eachInterrupt.handler}();
    </#if>
    ${eachInterrupt.flagName} = 0;
}

</#if>
</#list>
</#list>
