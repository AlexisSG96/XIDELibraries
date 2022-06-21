/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "FLASH2_driver.h"
#include "FLASH2_example.h"

uint8_t page_buffer[650];

void FLASH2_example(void){
    Flash2_info_t myInfo;
    uint8_t buffer[4]                   = {15,20,25,30};
    uint32_t count                      = 4;
    uint32_t address                    = 0x010000;
    uint8_t receive_buffer[4];
	uint16_t i;
    
    for(i =0;i<sizeof(page_buffer);i++)
    {
        page_buffer[i] = 'x';
    }
    
    FLASH2_GetDeviceInfo(&myInfo);

    FLASH2_ChipErase();

    FLASH2_Write( address, buffer, count );
    FLASH2_Read( address, receive_buffer, count );

    FLASH2_ChipErase();

    FLASH2_Write(address,page_buffer,sizeof(page_buffer));
    for(i =0;i<sizeof(page_buffer);i++)
    {
        page_buffer[i] = 'a';
    }

    FLASH2_Read( address, page_buffer, sizeof(page_buffer) );

}
