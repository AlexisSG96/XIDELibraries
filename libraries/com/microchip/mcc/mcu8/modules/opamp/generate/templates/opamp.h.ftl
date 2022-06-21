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
        Driver Version    :  2.1.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/
#include <stdint.h>
#include <stdbool.h>

// Enumeration of R2/R1 resistor ratio
typedef enum
{
    ${moduleNameUpperCase}_R2byR1_is_0dp07,
    ${moduleNameUpperCase}_R2byR1_is_0dp14,
    ${moduleNameUpperCase}_R2byR1_is_0dp33,
    ${moduleNameUpperCase}_R2byR1_is_1,
    ${moduleNameUpperCase}_R2byR1_is_1dp67,
    ${moduleNameUpperCase}_R2byR1_is_3,
    ${moduleNameUpperCase}_R2byR1_is_7,
    ${moduleNameUpperCase}_R2byR1_is_15   
} ${moduleNameUpperCase}_resistor_select;

// Enumeration of available Positive Channels
typedef enum
{
    ${moduleNameUpperCase}_posChannel_Vss,
    ${moduleNameUpperCase}_posChannel_GSEL,
    ${moduleNameUpperCase}_posChannel_OPA${instance}IN,
    ${moduleNameUpperCase}_posChannel_Vdd_by_2,
    ${moduleNameUpperCase}_posChannel_DAC1,
    ${moduleNameUpperCase}_posChannel_DAC2
} ${moduleNameUpperCase}_posChannel_select;

// Enumeration of available Positive Sources
typedef enum
{
    <#list posSources as source>
    ${moduleNameUpperCase}_${source.name} = ${source.value}<#if source_has_next>,</#if>   
    </#list>
} ${moduleNameUpperCase}_posSource_select;

// Enumeration of available Negative Channels
typedef enum
{
    ${moduleNameUpperCase}_negChannel_No_Connection = 0x0,
    ${moduleNameUpperCase}_negChannel_GSEL = 0x1,
    ${moduleNameUpperCase}_negChannel_OPA${instance}IN = 0x2,
    ${moduleNameUpperCase}_negChannel_DAC1 = 0x4,
    ${moduleNameUpperCase}_negChannel_DAC2 = 0x5
} ${moduleNameUpperCase}_negChannel_select;

// Enumeration of available Negative Sources
typedef enum
{
    <#list negSources as source>
    ${moduleNameUpperCase}_${source.name} = ${source.value}<#if source_has_next>,</#if>   
    </#list>
} ${moduleNameUpperCase}_negSource_select;

/**
 * @brief Initializes the ${moduleNameUpperCase} module
 *        This routine must be called before any other ${moduleNameUpperCase} routine
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_Initialize(void);

/**
 * @brief Enables the ${moduleNameUpperCase} Charge Pump
 * @return None
 * @param None
 */
inline void ${moduleNameUpperCase}_EnableChargePump(void);

/**
 * @brief Disables the ${moduleNameUpperCase} Charge Pump
 * @return None
 * @param None
 */
inline void ${moduleNameUpperCase}_DisableChargePump(void);

/**
 * @brief Enables ${moduleNameUpperCase} to operate with unity gain 
 * @return None
 * @param None
 */
inline void ${moduleNameUpperCase}_EnableSoftwareUnityGain(void);

/**
 * @brief Disables unity gain in ${moduleNameUpperCase} 
 * @return None
 * @param None
 */
inline void ${moduleNameUpperCase}_DisableSoftwareUnityGain(void);

/**
 * @brief Sets the positive channel as per user selection
 * @return None 
 * @param [in] Desired positive channel
          For available positive channels refer ${moduleNameUpperCase}_posChannel_select enum from ${moduleNameLowerCase}.h file
 */
inline void ${moduleNameUpperCase}_SetPositiveChannel(${moduleNameUpperCase}_posChannel_select posChannel);

/**
 * @brief Sets the positive source as per user selection
 * @return None 
 * @param [in] Desired positive source
          For available positive sources refer ${moduleNameUpperCase}_posSource_select enum from ${moduleNameLowerCase}.h file
 */
inline void ${moduleNameUpperCase}_SetPositiveSource(${moduleNameUpperCase}_posSource_select posSource);

/**
 * @brief Sets the negative channel as per user selection
 * @return None 
 * @param [in] Desired negative channel
          For available negative channels refer ${moduleNameUpperCase}_negChannel_select enum from ${moduleNameLowerCase}.h file
 */
inline void ${moduleNameUpperCase}_SetNegativeChannel(${moduleNameUpperCase}_negChannel_select negChannel);

/**
 * @brief Sets the negative source as per user selection
 * @return None 
 * @param [in] Desired negative source
          For available negative sources refer ${moduleNameUpperCase}_negSource_select enum from ${moduleNameLowerCase}.h file
 */
inline void ${moduleNameUpperCase}_SetNegativeSource(${moduleNameUpperCase}_negSource_select negSource);

/**
 * @brief Sets the R1 and R2 values of internal resistor ladder as per user selection
 * @return None 
 * @param [in] Desired resistor selection
               For available resistor values refer ${moduleNameUpperCase}_resistor_sel enum from ${moduleNameLowerCase}.h file
 */
void ${moduleNameUpperCase}_SetResistorLadder(${moduleNameUpperCase}_resistor_select resistorSelection);

/**
 * @brief Enables hardware override by setting the override enable bit
 * @return None 
 * @param None
 */
inline void ${moduleNameUpperCase}_EnableHardwareOverride(void);

/**
 * @brief Selects the Hardware Override Source and polarity
          The ${moduleNameUpperCase}_EnableHardwareOverride() routine must be called before this routine
 * @return None 
 * @param [in] Desired hardware override source and source polarity
 */
void ${moduleNameUpperCase}_SetHardwareOverrideSource(uint8_t overrideSource, uint8_t polarity);

/**
 * @brief Disables the hardware override by clearing the override enable bit
 * @return None 
 * @param None
 */
inline void ${moduleNameUpperCase}_DisableHardwareOverride(void);

/**
 * @brief Selects the Software Override Mode
          The ${moduleNameUpperCase}_DisableHardwareOverride() routine must be called before this routine
 * @return None 
 * @param [in] Desired software override mode
 */
inline void ${moduleNameUpperCase}_SetSoftwareOverride(uint8_t softwareControl);

/**
 * @brief Sets the input offset calibration 
 * @return None 
 * @param [in] Desired input offset
 */
inline void ${moduleNameUpperCase}_SetInputOffset(uint8_t offset);

#endif //${moduleNameUpperCase}_H  