/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for FatFs     (C)ChaN, 2016        */
/*-----------------------------------------------------------------------*/
/* If a working storage control module is available, it should be        */
/* attached to the FatFs via a glue function rather than modifying it.   */
/* This is an example of glue functions to attach various existing      */
/* storage control modules to the FatFs module with a defined API.       */
/*-----------------------------------------------------------------------*/

#include "diskio.h"		/* FatFs lower layer API */
<#list drivers as driver>
#include "${driver.include}"
</#list>

<#if drivers?size == 0>
#warning "No drivers were selected for use. Please go back into the MCC tool and select a driver to use or make modifications to this file to point to the physical driver in use."
</#if>

/* Definitions of physical drive number for each drive */
enum DRIVER_LIST{
<#list drivers as driver>
    ${driver.label} = ${driver.number},
</#list>
};

/*-----------------------------------------------------------------------*/
/* Get Drive Status                                                      */
/*-----------------------------------------------------------------------*/

DSTATUS disk_status (
    BYTE pdrv    /* Physical drive number to identify the drive */
)
{
    DSTATUS stat = STA_NOINIT;

    switch (pdrv) {
<#list drivers as driver>
<#if driver.IsMediaPresent??>
<#if driver.IsMediaInitialized??>

        case ${driver.label}:
            if ( ${driver.IsMediaPresent}() == false)
            {
               stat = STA_NODISK;
            }
            else if ( ${driver.IsMediaInitialized}() == true)
            {
                stat &= ~STA_NOINIT;
            }
        
<#if driver.IsWriteProtected??>
            if ( ${driver.IsWriteProtected}() == true)
            {
                stat |= STA_PROTECT;
            }

            break;
</#if>

</#if>
</#if>
</#list>
        default:
            break;
    }
    return stat;
}



/*-----------------------------------------------------------------------*/
/* Initialize a Drive                                                    */
/*-----------------------------------------------------------------------*/

DSTATUS disk_initialize (
    BYTE pdrv    /* Physical drive number to identify the drive */
)
{
    DSTATUS stat = STA_NOINIT;

    switch (pdrv) {
<#list drivers as driver>
<#if driver.MediaInitialize??>
        case ${driver.label} :
            if(${driver.MediaInitialize}() == true)
            {
                stat = RES_OK;
            }
            else
            {
                stat = RES_ERROR;
            }
            break;
</#if>
</#list>
        default:
            break;
    }

    return stat;
}



/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/

DRESULT disk_read (
    BYTE pdrv,    /* Physical drive number to identify the drive */
    BYTE *buff,   /* Data buffer to store read data */
    DWORD sector, /* Start sector in LBA */
    UINT count    /* Number of sectors to read */
)
{
    DRESULT res = RES_PARERR;

    switch (pdrv) {
<#list drivers as driver>
<#if driver.SectorRead??>
        case ${driver.label} :
            if(${driver.SectorRead}(sector, buff, count) == true)
            {
                res = RES_OK;
            }
            else
            {
                res = RES_ERROR;
            }
            break;

</#if>
</#list>
        default:
            break;
    }

    return res;
}



/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/

DRESULT disk_write (
    BYTE pdrv,          /* Physical drive number to identify the drive */
    const BYTE *buff,   /* Data to be written */
    DWORD sector,       /* Start sector in LBA */
    UINT count          /* Number of sectors to write */
)
{
    DRESULT res = RES_PARERR;

    switch (pdrv) {
<#list drivers as driver>
<#if driver.SectorWrite??>
        case ${driver.label} :
            if(${driver.SectorWrite}(sector, buff, count) == true)
            {
                res = RES_OK;
            }
            else
            {
                res = RES_ERROR;
            }
            break;

</#if>
</#list>
        default:
            break;
    }

    return res;
}



/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/

DRESULT disk_ioctl (
    BYTE pdrv,    /* Physical drive number (0..) */
    BYTE cmd,     /* Control code */
    void *buff    /* Buffer to send/receive control data */
)
{
    DRESULT res = RES_OK;

    switch (pdrv) {
<#list drivers as driver>
        case ${driver.label} :
            return res;

</#list>
        default:
            break;
    }

    return RES_PARERR;
}

