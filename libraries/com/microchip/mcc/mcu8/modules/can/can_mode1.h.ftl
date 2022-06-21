/**
  ${moduleNameUpperCaseNew} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCaseNew}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCaseNew} driver using ${productName}

  @Description
    This header file provides APIs driver for ${moduleNameUpperCaseNew}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.12.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCaseNew}_H
#define ${moduleNameUpperCaseNew}_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>

/**

Global Defines  

*/
typedef union {

    struct {
        uint8_t idType;
        uint32_t id;
        uint8_t dlc;
        uint8_t data0;
        uint8_t data1;
        uint8_t data2;
        uint8_t data3;
        uint8_t data4;
        uint8_t data5;
        uint8_t data6;
        uint8_t data7;
    } frame;
    uint8_t array[14];
} uCAN_MSG;

/**
 Defines
*/

#define dSTANDARD_CAN_MSG_ID_2_0B 1
#define dEXTENDED_CAN_MSG_ID_2_0B 2

<#list oldApiMap?keys as oldApi>
<#assign newApi = oldApiMap[oldApi]>
<#if !isVectoredInterruptEnabled>
<#if oldApi?is_first>
// For backwards-compatibility with pre-v1.79 users
</#if>
#define ${oldApi} ${newApi}
</#if>
</#list>

/**
  Section: ${moduleNameUpperCaseNew} APIs
*/

<#list initializers as initializer>
/**
    @Summary
        Initializes the ${moduleNameUpperCaseNew} module. 

    @Description
        This routine sets all the set parameters to the ${moduleNameUpperCaseNew} module.

    @Preconditions 
        None

    @Param
        None
  
    @Returns
        None
 
    @Example
        <code>
        ${initializer}();  
        </code>                                                                      
*/
void ${initializer}(void);
</#list>
/**
                                                                           
    @Summary
        ${moduleNameUpperCase}_sleep

    @Description
        Puts the CAN module to sleep

    @Param
        None 

    @Returns
        None   

    @Example
        <code>
        ${moduleNameUpperCase}_Initialize();  
        </code> 
                                                                           
*/

void ${moduleNameUpperCase}_sleep(void);

/**
    @Summary
        ${moduleNameUpperCase}_transmit

    @Description
        Transmits out sCAN_MSG

    @Param
        Pointer to a sCAN_MSG

    @Returns
        True or False if message was loaded to transmit buffer 

    @Example
        <code>
        uCAN_MSG txMessage;
        ${moduleNameUpperCase}_transmit(&txMessage);  
        </code>                                                                             
*/
uint8_t ${moduleNameUpperCase}_transmit(uCAN_MSG *tempCanMsg);


/**

	@Summary
		${moduleNameUpperCase}_receive

	@Description
		Receives CAN messages

	@Param
		Pointer to a sCAN_MSG

	@Returns
		True or False for a new message 
  
	@Example
		<code>
		uCAN_MSG rxMessage;
		${moduleNameUpperCase}_receive(&rxMessage);  
		</code> 
                                                                             
*/
uint8_t ${moduleNameUpperCase}_receive(uCAN_MSG *tempCanMsg);

/**
 
	@Summary
		${moduleNameUpperCase}_messagesInBuffer
 
	@Description
		Checks to see how many messages are in the buffer
	
	@Param
		None

	@Returns
		Returns total number of messages in the buffers

	@Example
		<code>
		uint8_t nrMsg;
		nrMsg = ${moduleNameUpperCase}_messagesInBuffer();  
		</code>                                                                            
*/
uint8_t ${moduleNameUpperCase}_messagesInBuffer(void);

/**

	@Summary
		${moduleNameUpperCase}_isBusOff

	@Description
		Checks to see if module is busoff

	@Param
		None

	@Returns
		True if module is in Busoff, False is if it is not

	@Example
		<code>
		uint8_t busOff;
		busOff = ${moduleNameUpperCase}_isBusOff();  
		</code> 
                                                  
*/

uint8_t ${moduleNameUpperCase}_isBusOff(void);

/**

	@Summary
		${moduleNameUpperCase}_isRXErrorPassive

	@Description
		Checks to see if module is RX Error Passive
        
	@Param
		None
 
	@Returns
 		True if module is in RX Error Passive, False is if it is not                                                    

 	@Example
		<code>
		uint8_t errRxPasive;
		errRxPasive = ${moduleNameUpperCase}_isRXErrorPassive();
		</code>     
                                                    
 */
 
uint8_t ${moduleNameUpperCase}_isRXErrorPassive(void);

/**

	@Summary
		${moduleNameUpperCase}_isTXErrorPassive

	@Description
		Checks to see if module is TX Error Passive

	@Param
		None

	@Returns
		True if module is in TX Error Passive, False is if it is not

	@Example
		<code>
		uint8_t errTxPasive;
		errTxPasive = ${moduleNameUpperCase}_isTXErrorPassive();  
		</code>       

*/

uint8_t ${moduleNameUpperCase}_isTXErrorPassive(void);

<#list newInterruptArray as eachComponent>
<#list eachComponent.interrupts as eachInterrupt>
<#if eachInterrupt.usesHandler>
/**
    @Summary
        ${moduleNameUpperCaseNew}_${eachInterrupt.intHandlerName}

    @Description
        Sets the ${moduleNameUpperCaseNew} ${eachInterrupt.description} interrupt handler

    @Param
        Address of the callback routine

    @Returns
        None

    @Example
        <code>
        volatile bool custom${eachInterrupt.varName}Flag = false;

        void Custom${eachInterrupt.handler}(void)
        {
            custom${eachInterrupt.varName}Flag = true;
            // ...
        }

        void main(void)
        {
            // ...
            ${moduleNameUpperCaseNew}_${eachInterrupt.intHandlerName}(Custom${eachInterrupt.handler});

            while (1)
            {
                if (custom${eachInterrupt.varName}Flag) {
                    custom${eachInterrupt.varName}Flag = false;
                    // ...
                }
            }
        }
        </code>       
*/
void ${moduleNameUpperCaseNew}_${eachInterrupt.intHandlerName}(void (*handler)(void));

</#if>
<#if eachInterrupt.hasISR>
<#if !isVectoredInterruptEnabled>
/**
    @Summary
        ${moduleNameUpperCaseNew}_${eachInterrupt.ISRName}

    @Description
        Implements the ${moduleNameUpperCaseNew} ${eachInterrupt.description} interrupt service routine

    @Param
        None

    @Returns
        None
*/
void ${moduleNameUpperCaseNew}_${eachInterrupt.ISRName}(void);

</#if>
</#if>
</#list>
</#list>

#endif // ${moduleNameUpperCaseNew}_H
