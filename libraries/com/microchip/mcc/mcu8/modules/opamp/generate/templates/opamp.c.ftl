/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.1.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"


void ${moduleNameUpperCase}_Initialize(void)
{
    //${OPACON1.csvComment}
    ${OPACON1.name} = ${OPACON1.hexValue};

    //${OPACON2.csvComment}
    ${OPACON2.name} = ${OPACON2.hexValue};

    //${OPACON3.csvComment}
    ${OPACON3.name} = ${OPACON3.hexValue};

    //${OPAHWC.csvComment}
    ${OPAHWC.name} = ${OPAHWC.hexValue};

    //${OPAORS.csvComment}
    ${OPAORS.name} = ${OPAORS.hexValue};    

    //${OPACON0.csvComment}
    ${OPACON0.name} = ${OPACON0.hexValue};
}

inline void ${moduleNameUpperCase}_EnableChargePump(void)
{
    ${OPACON0.name}bits.${OPACON0_CPON.name} = 1;
}

inline void ${moduleNameUpperCase}_DisableChargePump(void)
{
    ${OPACON0.name}bits.${OPACON0_CPON.name} = 0;
}

inline void ${moduleNameUpperCase}_EnableSoftwareUnityGain(void)
{
    ${OPACON0.name}bits.${OPACON0_UG.name} = 1;
}

inline void ${moduleNameUpperCase}_DisableSoftwareUnityGain(void)
{
    ${OPACON0.name}bits.${OPACON0_UG.name} = 0;
}

inline void ${moduleNameUpperCase}_SetPositiveChannel(${moduleNameUpperCase}_posChannel_select posChannel)
{
    ${OPACON2.name}bits.${OPACON2_PCH.name} = posChannel;
}

inline void ${moduleNameUpperCase}_SetPositiveSource(${moduleNameUpperCase}_posSource_select posSource)
{
    ${OPACON3.name}bits.${OPACON3_PSS.name} = posSource;
}

inline void ${moduleNameUpperCase}_SetNegativeChannel(${moduleNameUpperCase}_negChannel_select negChannel)
{
    ${OPACON2.name}bits.${OPACON2_NCH.name} = negChannel;
}

inline void ${moduleNameUpperCase}_SetNegativeSource(${moduleNameUpperCase}_negSource_select negSource)
{
    ${OPACON1.name}bits.${OPACON1_NSS.name} = negSource;
}

void ${moduleNameUpperCase}_SetResistorLadder(${moduleNameUpperCase}_resistor_select resistorSelection)
{
    ${OPACON1.name}bits.${OPACON1_RESON.name} = 1;
    ${OPACON1.name}bits.${OPACON1_GSEL.name} = resistorSelection;
}

inline void ${moduleNameUpperCase}_EnableHardwareOverride(void)
{
   ${OPAHWC.name}bits.${OPAHWC_OREN.name} = 1;
}

void ${moduleNameUpperCase}_SetHardwareOverrideSource(uint8_t overrideSource, uint8_t polarity)
{
    ${OPAORS.name} = overrideSource;
    ${OPAHWC.name}bits.${OPAHWC_ORPOL.name} = polarity;
}

inline void ${moduleNameUpperCase}_DisableHardwareOverride(void)
{
    ${OPAHWC.name}bits.${OPAHWC_OREN.name} = 0;
}

inline void ${moduleNameUpperCase}_SetSoftwareOverride(uint8_t softwareControl)
{
    ${OPACON0.name}bits.${OPACON0_SOC.name} = softwareControl;
}

inline void ${moduleNameUpperCase}_SetInputOffset(uint8_t offset)
{
    ${OPAOFFSET.name} = offset;
}

