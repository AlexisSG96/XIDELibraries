/*
<#include "MicrochipDisclaimer.ftl">
*/

<#if drivers?size !=0>
<#assign driver=drivers[0]>
</#if>

#include "ff.h"
<#if driver??>
#include "${driver.include}"
</#if>

static FATFS drive;
static FIL file;

void FatFsDemo_Tasks(void)
{
    UINT actualLength;
    char data[] = "Hello World!";
    <#if driver??>
    <#if driver.IsMediaPresent??>
    if( ${driver.IsMediaPresent}() == false)
    {
        return;
    }
    </#if>
    </#if>

    if (f_mount(&drive,"0:",1) == FR_OK)
    {
        if (f_open(&file, "HELLO.TXT", FA_WRITE | FA_CREATE_NEW ) == FR_OK)
        {
            f_write(&file, data, sizeof(data)-1, &actualLength );
            f_close(&file);
        }

        f_mount(0,"0:",0);
    }
}