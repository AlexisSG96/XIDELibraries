/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.0.2
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*******************************************************************************/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: Macro Declarations
*/

#define WRITE_FLASH_BLOCKSIZE    ${writeFlashBlockSize}
#define ERASE_FLASH_BLOCKSIZE    ${eraseFlashBlockSize}
#define END_FLASH                ${endFlash}

/**
  Section: Flash Module APIs
*/

/**
  @Summary
    Reads a word from Flash

  @Description
    This routine reads a word from given Flash address

  @Preconditions
    None

  @Param
    flashAddr - Flash program memory location from which data has to be read

  @Returns
    Data word read from given Flash address

  @Example
    <code>
    uint16_t    readWord;
    uint16_t    flashAddr = 0x01C0;

    readWord = FLASH_ReadWord(flashAddr);
    </code>
*/
uint16_t FLASH_ReadWord(uint16_t flashAddr);

/**
  @Summary
    Writes a word into Flash

  @Description
    This routine writes the given word into mentioned Flash address

  @Preconditions
    None

  @Param
    flashAddr - Flash program memory location to which data has to be written
    *ramBuf   - Pointer to an array of size 'ERASE_FLASH_BLOCKSIZE' at least
    word      - Word to be written in Flash

  @Returns
    None

  @Example
    <code>
    uint16_t    writeData = 0x15AA;
    uint16_t    flashAddr = 0x01C0;
    uint16_t    Buf[ERASE_FLASH_BLOCKSIZE];

    FLASH_WriteWord(flashAddr, Buf, writeData);
    </code>
*/
void FLASH_WriteWord(uint16_t flashAddr, uint16_t *ramBuf, uint16_t word);

/**
  @Summary
    Writes data to complete block of Flash

  @Description
    This routine writes data words to complete block in Flash program memory

  @Preconditions
    None

  @Param
    writeAddr         - A valid block starting address in Flash
    *flashWordArray   - Pointer to an array of size 'WRITE_FLASH_BLOCKSIZE' at least

  @Returns
    -1, if the given address is not a valid block starting address of Flash
    0, in case of valid block starting address

  @Example
    <code>
    #define FLASH_ROW_ADDRESS     0x01C0

    uint16_t wrBlockData[] =
    {
        0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007,
        0x0008, 0x0009, 0x000A, 0x000B, 0x000C, 0x000D, 0x000D, 0x000F,
        0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017,
        0x0018, 0x0019, 0x001A, 0x001B, 0x001C, 0x001D, 0x001E, 0x001F
    }

    // write to Flash memory block
    FLASH_WriteBlock((uint16_t)FLASH_ROW_ADDRESS, (uint16_t*)wrBlockData);
    </code>
*/
int8_t FLASH_WriteBlock(uint16_t writeAddr, uint16_t *flashWordArray);

/**
  @Summary
    Erases complete Flash program memory block

  @Description
    This routine erases complete Flash program memory block

  @Preconditions
    None

  @Param
    startAddr - A valid block starting address in Flash program memory

  @Returns
    None

  @Example
    <code>
    uint16_t    flashBlockStartAddr = 0x01C0;

    FLASH_EraseBlock(flashBlockStartAddr);
    </code>
*/
void FLASH_EraseBlock(uint16_t startAddr);



<#if useDATAEE>
/**
  Section: Data EEPROM Module APIs
*/

/**
  @Summary
    Writes a data byte to Data EEPROM

  @Description
    This routine writes a data byte to given Data EEPROM location

  @Preconditions
    None

  @Param
    bAdd  - Data EEPROM location to which data to be written
    bData - Data to be written to Data EEPROM location

  @Returns
    None

  @Example
    <code>
    uint16_t dataeeAddr = 0xF010;
    uint8_t dataeeData = 0x55;

    DATAEE_WriteByte(dataeeAddr, dataeeData);
    </code>
*/
void DATAEE_WriteByte(uint16_t bAdd, uint8_t bData);

/**
  @Summary
    Reads a data byte from Data EEPROM

  @Description
    This routine reads a data byte from given Data EEPROM location

  @Preconditions
    None

  @Param
    bAdd  - Data EEPROM location from which data has to be read

  @Returns
    Data byte read from given Data EEPROM location

  @Example
    <code>
    uint16_t dataeeAddr = 0xF010;
    uint8_t readData;

    readData = DATAEE_ReadByte(dataeeAddr);
    </code>
*/
uint8_t DATAEE_ReadByte(uint16_t bAdd);
</#if>

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
void ${moduleNameUpperCase}_${interruptFunctionName}(void);
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/

