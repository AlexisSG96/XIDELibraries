/**
\file
\addtogroup doc_driver_i2c_code
\brief This file provides some basic blocking helper functions for common operations on the I2C API

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/


#include "../${headerDirectory}/${masterheader}"
#include "${simpleheader}"

/****************************************************************/
static ${operations} wr1RegCompleteHandler(void *p)
{
    ${setBuffer}(p,1);
    ${setDataCompleteCallback}(NULL,NULL);
    return ${continue};
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to write 1 byte of data to a register location
 *  
 *  \param [in] address [type]i2c_address_t The slave address
 *         [in] reg     [type]uint8_t The register address to be written to
 *         [in] data    [type]uint8_t The data to be written
 *  
 *  \return None
 */
void ${write1ByteRegister}(${address} address, uint8_t reg, uint8_t data)
{
    while(!${open}(address)); // sit here until we get the bus..
    ${setDataCompleteCallback}(wr1RegCompleteHandler,&data);
    ${setBuffer}(&reg,1);
    ${setAddressNACKCallback}(${restartWrite},NULL); //NACK polling?
    ${masterWrite}();
    while(${BUSY} == ${close}()); // sit here until finished.
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to write N byte of data 
 *  
 *  \param [in] address [type]i2c_address_t Slave address
 *         [in] data    [type]uint8_t Array of data to be send
 *         [in] len     [type]uint8_t The size of the array
 *  
 *  \return None
 */
void ${writeNBytes}(${address} address, void* data, size_t len)
{
    while(!${open}(address)); // sit here until we get the bus..
    ${setBuffer}(data,len);
    ${setAddressNACKCallback}(${restartWrite},NULL); //NACK polling?
    ${masterWrite}();
    while(${BUSY} == ${close}()); // sit here until finished.
}

/****************************************************************/
static ${operations} rd1RegCompleteHandler(void *p)
{
    ${setBuffer}(p,1);
    ${setDataCompleteCallback}(NULL,NULL);
    return ${restart_read};
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to read 1 byte of data from a register location
 *  
 *  \param [in] address [type]i2c_address_t Slave address
 *         [in] reg     [type]uint8_t The register address to be read
 *  
 *  \return [out] The read data byte
 */
uint8_t ${read1ByteRegister}(${address} address, uint8_t reg)
{
    uint8_t    d2=42;
    ${error} e;
    int x;

    for(x = 2; x != 0; x--)
    {
        while(!${open}(address)); // sit here until we get the bus..
        ${setDataCompleteCallback}(rd1RegCompleteHandler,&d2);
        ${setBuffer}(&reg,1);
        ${setAddressNACKCallback}(${restartWrite},NULL); //NACK polling?
        ${masterWrite}();
        while(${BUSY} == (e = ${close}())); // sit here until finished.
        if(e==${NOERR}) break;
    }
    

    return d2;
}

/****************************************************************/
static ${operations} rd2RegCompleteHandler(void *p)
{
    ${setBuffer}(p,2);
    ${setDataCompleteCallback}(NULL,NULL);
    return ${restart_read};
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to read 2 byte of data from a register location
 *  
 *  \param [in] address [type]i2c_address_t Slave address
 *         [in] reg     [type]uint8_t The register address to be read
 *  
 *  \return [out] The read 2 bytes of data
 */
uint16_t ${read2ByteRegister}(${address} address, uint8_t reg)
{
    // result is little endian
    uint16_t    result;

    while(!${open}(address)); // sit here until we get the bus..
    ${setDataCompleteCallback}(rd2RegCompleteHandler,&result);
    ${setBuffer}(&reg,1);
    ${setAddressNACKCallback}(${restartWrite},NULL); //NACK polling?
    ${masterWrite}();
    while(${BUSY} == ${close}()); // sit here until finished.
    
    return (result << 8 | result >> 8);
}

/****************************************************************/
static ${operations} wr2RegCompleteHandler(void *p)
{
    ${setBuffer}(p,2);
    ${setDataCompleteCallback}(NULL,NULL);
    return ${continue};
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to write 1 byte of data to a register location
 *  
 *  \param [in] address [type]i2c_address_t The slave address
 *         [in] reg     [type]uint8_t The register address to be written to
 *         [in] data    [type]uint8_t The data to be written
 *  
 *  \return None
 */
void ${write2ByteRegister}(${address} address, uint8_t reg, uint16_t data)
{
    while(!${open}(address)); // sit here until we get the bus..
    ${setDataCompleteCallback}(wr2RegCompleteHandler,&data);
    ${setBuffer}(&reg,1);
    ${setAddressNACKCallback}(${restartWrite},NULL); //NACK polling?
    ${masterWrite}();
    while(${BUSY} == ${close}()); // sit here until finished.
}

/****************************************************************/
typedef struct
{
    size_t len;
    char *data;
}buf_t;

static ${operations} rdBlkRegCompleteHandler(void *p)
{
    ${setBuffer}(((buf_t *)p)->data,((buf_t*)p)->len);
    ${setDataCompleteCallback}(NULL,NULL);
    return ${restart_read};
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to read block of data from a register location
 *  
 *  \param [in] address [type]i2c_address_t Slave address
 *         [in] reg     [type]uint8_t The register address to be read
 *         [out] data   [type]void* The read data block
 *         [in] len     [type]size_t The size of data block
 *  
 *  \return None
 */
void ${readDataBlock}(${address} address, uint8_t reg, void *data, size_t len)
{
    // result is little endian
    buf_t    d;
    d.data = data;
    d.len = len;

    while(!${open}(address)); // sit here until we get the bus..
    ${setDataCompleteCallback}(rdBlkRegCompleteHandler,&d);
    ${setBuffer}(&reg,1);
    ${setAddressNACKCallback}(${restartWrite},NULL); //NACK polling?
    ${masterWrite}();
    while(${BUSY} == ${close}()); // sit here until finished.
}

/**
 *  \ingroup doc_driver_i2c_code
 *  \brief Function to read N bytes of data
 *  
 *  \param [in] address [type]i2c_address_t Slave address
 *         [out] data   [type]void* The read data block
 *         [in] len     [type]size_t The size of data block
 *  
 *  \return None
 */
void ${readNBytes}(${address} address, void *data, size_t len)
{
    while(!${open}(address)); // sit here until we get the bus..
    ${setBuffer}(data,len);
    ${masterRead}();
    while(${BUSY} == ${close}()); // sit here until finished.
}