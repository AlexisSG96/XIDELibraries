/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdbool.h>
#include <stdint.h>

bool ${instance_name}_IsMediaPresent(void)
{
    #warning "You will need to implement this function for this driver to work."
    return false;
}

bool ${instance_name}_MediaInitialize(void)
{
    #warning "You will need to implement this function for this driver to work."
    return false;
}

bool ${instance_name}_IsMediaInitialized(void)
{
    #warning "You will need to implement this function for this driver to work."
    return false;
}

bool ${instance_name}_IsWriteProtected(void)
{
    #warning "You will need to implement this function for this driver to work."
    return false;
}

uint16_t ${instance_name}_GetSectorSize(void)
{
    #warning "You will need to implement this function for this driver to work."
    return 512;
}

uint32_t ${instance_name}_GetSectorCount(void)
{
    #warning "You will need to implement this function for this driver to work."
    return 0;
}

bool ${instance_name}_SectorRead(uint32_t sector_address, uint8_t* buffer, uint16_t sector_count)
{
    #warning "You will need to implement this function for this driver to work."
    return false;
}

bool ${instance_name}_SectorWrite(uint32_t sector_address, const uint8_t* buffer, uint16_t sector_count);
{
    #warning "You will need to implement this function for this driver to work."
    return false;
}
