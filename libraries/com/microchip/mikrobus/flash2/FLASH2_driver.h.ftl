/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef FLASH2_H
#define FLASH2_H

/**
  Section: Included Files
*/

#include <stdint.h>
typedef struct flash2_info_s
{
    uint8_t manu_id;
    uint8_t device_type;
    uint8_t device_id;
} Flash2_info_t;

void FLASH2_Initialize();
int FLASH2_GetDeviceInfo( Flash2_info_t* info );
int FLASH2_Write( uint32_t address, uint8_t *buffer, uint32_t data_count );
uint8_t FLASH2_ReadByte( uint8_t buffer );
void FLASH2_Read( uint32_t address, uint8_t *buffer, uint32_t data_count );
void FLASH2_ChipErase( void );
        

#endif // _FLASH2_H
/**
 End of File
*/
