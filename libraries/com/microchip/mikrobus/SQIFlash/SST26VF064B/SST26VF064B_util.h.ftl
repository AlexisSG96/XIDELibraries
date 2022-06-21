/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SST26VF064B_UTIL_H
#define	SST26VF064B_UTIL_H

#include <stdint.h>

typedef enum {
    CMD_NOP         =       0x00, /**< No Operation */
    CMD_RSTEN       =       0x66, /**< Reset Enable */
    CMD_RST         =       0x99, /**< Reset Memory */
    CMD_EQIO        =       0x38, /**< Enable Quad I/O */
    CMD_RSTQIO      =       0xFF, /**< Reset Quad I/O */
    CMD_RDSR        =       0x05, /**< Read Status Register */
    CMD_WRSR        =       0x01, /**< Write Status Register */
    CMD_RDCR        =       0x35, /**< Read Configuration Register */
    CMD_READ        =       0x03, /**< Read Memory */
    CMD_HS_READ     =       0x0B, /**< Read Memory at Higher Speed */
    CMD_SQOR        =       0x6B, /**< SPI Quad Output Read */
    CMD_SQIOR       =       0xEB, /**< SPI Quad I/O Read */
    CMD_SDOR        =       0x3B, /**< SPI Dual Output Read */
    CMD_SDIOR       =       0xBB, /**< SPI Dual I/O Read */
    CMD_SB          =       0xC0, /**< Set Burst Length */
    CMD_RBSQI       =       0x0C, /**< SQI Read Burst with Wrap */
    CMD_RBSPI       =       0xEC, /**< SPI Read Burst with Wrap */
    CMD_JEDECID     =       0x9F, /**< JEDEC-ID Read */
    CMD_QUAD_JID    =       0xAF, /**< Quad I/O J-ID read */
    CMD_SFDP        =       0x5A, /**< Serial Flash Discoverable Parameters */
    CMD_WREN        =       0x06, /**< Write Enable */
    CMD_WRDI        =       0x04, /**< Write Disable */
    CMD_SE          =       0x20, /**< Erase 4 KBytes of Memory Array */
    CMD_BE          =       0xD8, /**< Erase 64, 32 or 8 KBytes of Memory Array */
    CMD_CE          =       0xC7, /**< Erase Full Array */
    CMD_PP          =       0x02, /**< Page Program */
    CMD_SPI_QUAD    =       0x32, /**< SQI Quad Page Program */
    CMD_WRSU        =       0xB0, /**< Suspends Program / Erase */
    CMD_WRRE        =       0x30, /**< Resumes Program / Erase */
    CMD_RBPR        =       0x72, /**< Read Block-Protection Register */
    CMD_WBPR        =       0x42, /**< Write Block-Protection Register */
    CMD_LBPR        =       0x8D, /**< Lock Down Block-Protection Register */
    CMD_NVWLDR      =       0xE8, /**< Non-Volatile Write Lock-Down Register */
    CMD_ULBPR       =       0x98, /**< Global Block Protection Unlock */
    CMD_RSID        =       0x88, /**< Read Security ID */
    CMD_PSID        =       0xA5, /**< Program User Security ID Area */
    CMD_LSID        =       0x85, /**< Lockout Security ID Programming */
} SST26VF064B_cmd_t;            

typedef enum {
    STATUS_WEL  =   0x02, /**< Write-enable latch status 
                           * 1 = device is write-enabled
                           * 0 = device is not write-enabled */
            
    STATUS_WSE  =   0x04, /**< Write suspend-erase status 
                           * 1 = erase suspended
                           * 0 = erase is not suspended */
            
    STATUS_WSP  =   0x08, /**< Write suspend-program status 
                           * 1 = program suspended
                           * 0 = program is not suspended */
            
    STATUS_WPLD =   0x10, /**< Write protections lock-down status 
                           * 1 = write protection lock-down enabled 
                           * 0 = write protection lock-down disabled */
            
    STATUS_SEC  =   0x20, /**< Security ID status 
                           * 1 = security ID space locked
                           * 0 = security ID space not locked */
            
    STATUS_RES  =   0x40, /**< Reserved for future use */
            
    STATUS_BUSY =   0x80, /**< Write operation status 
                           * 1 = write in progress 
                           * 0 = no operation in progress */
} SST26VF064B_status_t;

void SST26VF064B_writeAddress(uint32_t address);

#endif	/* SST26VF064B_UTIL_H */

