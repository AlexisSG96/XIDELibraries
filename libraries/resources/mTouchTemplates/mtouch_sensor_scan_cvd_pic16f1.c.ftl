/*
    MICROCHIP SOFTWARE NOTICE AND DISCLAIMER:

    You may use this software, and any derivatives created by any person or
    entity by or on your behalf, exclusively with Microchip's products.
    Microchip and its subsidiaries ("Microchip"), and its licensors, retain all
    ownership and intellectual property rights in the accompanying software and
    in all derivatives hereto.

    This software and any accompanying information is for suggestion only. It
    does not modify Microchip's standard warranty for its products.  You agree
    that you are solely responsible for testing the software and determining
    its suitability.  Microchip has no obligation to modify, test, certify, or
    support the software.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE APPLY TO THIS SOFTWARE, ITS INTERACTION WITH MICROCHIP'S
    PRODUCTS, COMBINATION WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT, WILL MICROCHIP BE LIABLE, WHETHER IN CONTRACT, WARRANTY, TORT
    (INCLUDING NEGLIGENCE OR BREACH OF STATUTORY DUTY), STRICT LIABILITY,
    INDEMNITY, CONTRIBUTION, OR OTHERWISE, FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    EXEMPLARY, INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, FOR COST OR EXPENSE OF
    ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWSOEVER CAUSED, EVEN IF
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE
    FORESEEABLE.  TO THE FULLEST EXTENT ALLOWABLE BY LAW, MICROCHIP'S TOTAL
    LIABILITY ON ALL CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED
    THE AMOUNT OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR
    THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF
    THESE TERMS.
*/
#include <xc.h>
#include "mtouch_sensor_scan.h"

<#list 0..mtouch.sensor.items?size-1 as i>
/**
* @prototype    void MTOUCH_CVD_ScanA_${i}
*
* @description  CVD scanA for sensor ${i}
*               - name:                         ${mtouch.sensor.items[i].name}
*               - pin:                          ${mtouch.sensor.items[i].pinName}
*               - analog channel:               ${mtouch.sensor.items[i].functionName}
*               - reference type:               ${mtouch.sensor.items[i].reference.type}
*               - guard type:                   ${mtouch.sensor.items[i].guard.type}
<#if mtouch.sensor.items[i].xcharge??>
*               - multiple charge type:         ${mtouch.sensor.items[i].xcharge.order} ${mtouch.sensor.items[i].xcharge.type}
</#if>
*
*/
void MTOUCH_CVD_ScanA_${i}(void)
{
<#switch mtouch.sensor.items[i].reference.type>
    <#case "MTOUCH_OPTION_REFTYPE_PREVIOUS">
    /* Initialize Precharge Source - Previous Sensor R${mtouch.sensor.items[i].reference.port}${mtouch.sensor.items[i].reference.pin} */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bsf            " ___mkstr(MTOUCH_S${i}_REF_LAT) "& 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    <#break>

    <#case "MTOUCH_OPTION_REFTYPE_IO">
    /* Initialize Precharge Source - Assigned I/O R${mtouch.sensor.items[i].reference.port}${mtouch.sensor.items[i].reference.pin} */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bsf            " ___mkstr(MTOUCH_S${i}_REF_LAT) "& 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    <#break>

    <#case "MTOUCH_OPTION_REFTYPE_DAC">
    /* Initialize Precharge Source - DAC */
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vdd}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_vdd}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    <#break>

    <#case "MTOUCH_OPTION_REFTYPE_SELF">
    /* Initialize Precharge Source - Sensor itself R${mtouch.sensor.items[i].reference.port}${mtouch.sensor.items[i].reference.pin} */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bsf            " ___mkstr(MTOUCH_S${i}_REF_LAT) " & 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    <#break>

    <#default>
    #error("Sensor ${i} does not have a reference.")
    <#break>
</#switch>

    /* Begin Precharge Stage */
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_REF_ADCON0));
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");

    /* Precharge Delay */
    _delay(MTOUCH_S${i}_PRECHARGE_TIME);

<#if mtouch.sensor.items[i].reference.type == "MTOUCH_OPTION_REFTYPE_SELF">
    /* Self-Reference Logic */
    asm("movlw          ${pic.adc.adcon0_unimpl}");
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bcf            " ___mkstr(MTOUCH_S${i}_REF_LAT) " & 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    asm("BANKSEL        ${pic.adc.adcon0_register}");
</#if>

    /* Prepare FSR0 for Settling Phase */
    asm("movlw LOW      " ___mkstr(MTOUCH_S${i}_TRIS));
    asm("movwf          FSR0L & 0x7F");
    asm("movlw HIGH     " ___mkstr(MTOUCH_S${i}_TRIS));
    asm("movwf          FSR0H & 0x7F");

    /* Prepare FSR1 for Settling Phase */
<#switch mtouch.sensor.items[i].guard.type>
    <#case "MTOUCH_OPTION_GUARDTYPE_DAC">
    asm("movlw LOW      ${pic.adc.adcon0_register}");
    asm("movwf          FSR1L & 0x7F");
    asm("movlw HIGH     ${pic.adc.adcon0_register}");
    asm("movwf          FSR1H & 0x7F");
    <#break>

    <#case "MTOUCH_OPTION_GUARDTYPE_IO">
    asm("movlw LOW      " ___mkstr(MTOUCH_S${i}_GUARD_LAT));
    asm("movwf          FSR1L & 0x7F");
    asm("movlw HIGH     " ___mkstr(MTOUCH_S${i}_GUARD_LAT));
    asm("movwf          FSR1H & 0x7F");
    <#break>

    <#default>
    asm("movlw LOW      " ___mkstr(MTOUCH_S${i}_LAT));
    asm("movwf          FSR1L & 0x7F");
    asm("movlw HIGH     " ___mkstr(MTOUCH_S${i}_LAT));
    asm("movwf          FSR1H & 0x7F");
    <#break>
</#switch>

    /* Begin Settling Stage: Connect */
<#if mtouch.sensor.items[i].guard.type == "NONE">
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");

<#elseif mtouch.sensor.items[i].guard.type == "MTOUCH_OPTION_GUARDTYPE_DAC">
        <#switch mtouch.sensor.items[i].reference.type>
            <#case "MTOUCH_OPTION_REFTYPE_PREVIOUS">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vss}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardA}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#case "MTOUCH_OPTION_REFTYPE_IO">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vss}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardA}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#case "MTOUCH_OPTION_REFTYPE_DAC">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.adc.adcon0_unimpl}");
    asm("movwf          INDF1 & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardA}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#case "MTOUCH_OPTION_REFTYPE_SELF">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vss}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardA}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F), ${pic.dac.dacout.enable_bit}");
            <#break>

            <#default>
    #error("Sensor ${i} does not have a reference.")
    <#break>
        </#switch>
<#else>
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    asm("bsf            INDF1 & 0x7F, " ___mkstr(MTOUCH_S${i}_GUARD_PIN));
</#if>

<#if mtouch.sensor.items[i].tx??>
    /* Set Tx Pins Output High */
    <#list 0..mtouch.sensor.items[i].tx?size-1 as j>
    LAT${mtouch.sensor.items[i].tx[j].port} |= ${mtouch.sensor.items[i].tx[j].mask};
    </#list>
</#if>

    /* Settling Delay */
    _delay(MTOUCH_S${i}_ACQUISITION_TIME);

<#if mtouch.sensor.items[i].xcharge??>
<#if mtouch.sensor.items[i].xcharge.type == "MTOUCH_OPTION_XCHARGETYPE_DOUBLE">
    /* Multiple Charges - Double*/
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    <#list 0..mtouch.sensor.items[i].xcharge.order-1 as j>
    asm("movlw          " ___mkstr(MTOUCH_S${i}_REF_ADCON0));
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    _delay(MTOUCH_S${i}_XCHARGE_TIME);
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    _delay(MTOUCH_S${i}_ACQUISITION_TIME);
    </#list>
<#elseif mtouch.sensor.items[i].xcharge.type == "MTOUCH_OPTION_XCHARGETYPE_HALF">
    /* Multiple Charges - Half*/
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    <#list 0..mtouch.sensor.items[i].xcharge.order-1 as j>
    asm("movlw          ${pic.adc.adcon0_unimpl}"); /* Unimplemented ADC channel */
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    asm("bcf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_XCHARGE_TIME;
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    _delay(MTOUCH_S${i}_ACQUISITION_TIME);
    </#list>

</#if>
</#if>
    /* Begin Conversion */
<#if mtouch.sensor.items[i].guard.type == "MTOUCH_OPTION_GUARDTYPE_DAC">
    asm("bsf            INDF1 & 0x7F, ${pic.adc.go_bit}");
<#else>
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    asm("bsf            ${pic.adc.adcon0_register} & 0x7F, ${pic.adc.go_bit}");
</#if>

    /* Disconnection Delay */
    _delay(MTOUCH_S${i}_DISCON_TIME);

    /* Exit Logic - Output Low */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_LAT));
    asm("bsf            " ___mkstr(MTOUCH_S${i}_LAT) " & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    asm("bcf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
<#if mtouch.sensor.items[i].guard.type == "MTOUCH_OPTION_GUARDTYPE_DAC">
    asm("BANKSEL        LAT${pic.dac.dacout.port}");
    asm("bsf            LAT${pic.dac.dacout.port} & 0x7F, ${pic.dac.dacout.pin}");
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("clrf           ${pic.dac.daccon0_register} & 0x7F");
<#elseif mtouch.sensor.items[i].reference.type == "MTOUCH_OPTION_REFTYPE_DAC" >
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("clrf           ${pic.dac.daccon0_register} & 0x7F");
</#if>

}

/**
* @prototype    void MTOUCH_CVD_ScanB_${i}
*
* @description    CVD scanB for sensor ${i}
*                - name:                         ${mtouch.sensor.items[i].name}
*                - pin:                          ${mtouch.sensor.items[i].pinName}
*                - analog channel:               ${mtouch.sensor.items[i].functionName}
*                - reference type:               ${mtouch.sensor.items[i].reference.type}
*                - guard type:                   ${mtouch.sensor.items[i].guard.type}
<#if mtouch.sensor.items[i].xcharge??>
*                - multiple charge type:         ${mtouch.sensor.items[i].xcharge.order} ${mtouch.sensor.items[i].xcharge.type}
</#if>
*
*/
void MTOUCH_CVD_ScanB_${i}(void)
{
<#switch mtouch.sensor.items[i].reference.type>
    <#case "MTOUCH_OPTION_REFTYPE_PREVIOUS">
    /* Initialize Precharge Source - Previous Sensor R${mtouch.sensor.items[i].reference.port}${mtouch.sensor.items[i].reference.pin} */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bcf            " ___mkstr(MTOUCH_S${i}_REF_LAT) " & 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    <#break>

    <#case "MTOUCH_OPTION_REFTYPE_IO">
    /* Initialize Precharge Source - Assigned I/O R${mtouch.sensor.items[i].reference.port}${mtouch.sensor.items[i].reference.pin} */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bcf            " ___mkstr(MTOUCH_S${i}_REF_LAT) " & 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    <#break>

    <#case "MTOUCH_OPTION_REFTYPE_DAC">
    /* Initialize Precharge Source - DAC */
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vss}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_vss}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    <#break>

    <#case "MTOUCH_OPTION_REFTYPE_SELF">
    /* Initialize Precharge Source - Sensor itself R${mtouch.sensor.items[i].reference.port}${mtouch.sensor.items[i].reference.pin} */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bcf            " ___mkstr(MTOUCH_S${i}_REF_LAT) " & 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    <#break>

    <#default>
    #error("Sensor ${i} does not have a reference.")
    <#break>
</#switch>

    /* Begin Precharge Stage */
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_REF_ADCON0));
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");

    /* Precharge Delay */
    _delay(MTOUCH_S${i}_PRECHARGE_TIME);

<#if mtouch.sensor.items[i].reference.type == "MTOUCH_OPTION_REFTYPE_SELF">
    /* Self-Reference Logic */
    asm("movlw          ${pic.adc.adcon0_unimpl}");
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_REF_LAT));
    asm("bsf            " ___mkstr(MTOUCH_S${i}_REF_LAT) " & 0x7F," ___mkstr(MTOUCH_S${i}_REF_PIN));
    asm("BANKSEL        ${pic.adc.adcon0_register}");
</#if>

    /* Prepare FSR0 for Settling Phase */
    asm("movlw LOW      " ___mkstr(MTOUCH_S${i}_TRIS));
    asm("movwf          FSR0L & 0x7F");
    asm("movlw HIGH     " ___mkstr(MTOUCH_S${i}_TRIS));
    asm("movwf          FSR0H & 0x7F");

    /* Prepare FSR1 for Settling Phase */
<#switch mtouch.sensor.items[i].guard.type>
    <#case "MTOUCH_OPTION_GUARDTYPE_DAC">
    asm("movlw LOW      ${pic.adc.adcon0_register}");
    asm("movwf          FSR1L & 0x7F");
    asm("movlw HIGH     ${pic.adc.adcon0_register}");
    asm("movwf          FSR1H & 0x7F");
    <#break>

    <#case "MTOUCH_OPTION_GUARDTYPE_IO">
    asm("movlw LOW      " ___mkstr(MTOUCH_S${i}_GUARD_LAT));
    asm("movwf          FSR1L & 0x7F");
    asm("movlw HIGH     " ___mkstr(MTOUCH_S${i}_GUARD_LAT));
    asm("movwf          FSR1H & 0x7F");
    <#break>

    <#default>
    asm("movlw LOW      " ___mkstr(MTOUCH_S${i}_LAT));
    asm("movwf          FSR1L & 0x7F");
    asm("movlw HIGH     " ___mkstr(MTOUCH_S${i}_LAT));
    asm("movwf          FSR1H & 0x7F");
    <#break>
</#switch>

    /* Begin Settling Stage: Connect */
<#if mtouch.sensor.items[i].guard.type == "NONE">
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");

<#elseif mtouch.sensor.items[i].guard.type == "MTOUCH_OPTION_GUARDTYPE_DAC">
        <#switch mtouch.sensor.items[i].reference.type>
            <#case "MTOUCH_OPTION_REFTYPE_PREVIOUS">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vdd}");
    asm("movwf          (${pic.dac.daccon0_register} & 0x7F)");
    asm("movlw          ${pic.dac.daccon1_guardB}");
    asm("movwf          (${pic.dac.daccon1_register} & 0x7F)");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#case "MTOUCH_OPTION_REFTYPE_IO">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vdd}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardB}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#case "MTOUCH_OPTION_REFTYPE_DAC">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.adc.adcon0_unimpl}");
    asm("movwf          INDF1 & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardB}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#case "MTOUCH_OPTION_REFTYPE_SELF">
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("movlw          ${pic.dac.daccon0_vdd}");
    asm("movwf          ${pic.dac.daccon0_register} & 0x7F");
    asm("movlw          ${pic.dac.daccon1_guardB}");
    asm("movwf          ${pic.dac.daccon1_register} & 0x7F");
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          INDF1 & 0x7F");
    asm("bsf            ${pic.dac.daccon0_register} & 0x7F, ${pic.dac.dacout.enable_bit}");
            <#break>

            <#default>
    #error("Sensor ${i} does not have a reference.")
    <#break>
        </#switch>
<#else>
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    asm("bcf            INDF1 & 0x7F, " ___mkstr(MTOUCH_S${i}_GUARD_PIN));
</#if>


<#if mtouch.sensor.items[i].tx??>
    /* Set Tx Pins Output High */
    <#list 0..mtouch.sensor.items[i].tx?size-1 as j>
    LAT${mtouch.sensor.items[i].tx[j].port} &= ~${mtouch.sensor.items[i].tx[j].mask};
    </#list>
</#if>

    /* Settling Delay */
    _delay(MTOUCH_S${i}_ACQUISITION_TIME);

<#if mtouch.sensor.items[i].xcharge??>
<#if mtouch.sensor.items[i].xcharge.type == "MTOUCH_OPTION_XCHARGETYPE_DOUBLE">
    /* Multiple Charges - Double*/
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    <#list 0..mtouch.sensor.items[i].xcharge.order-1 as j>
    asm("movlw          " ___mkstr(MTOUCH_S${i}_REF_ADCON0));
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    _delay(MTOUCH_S${i}_XCHARGE_TIME);
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    _delay(MTOUCH_S${i}_ACQUISITION_TIME);
    </#list>
<#elseif mtouch.sensor.items[i].xcharge.type == "MTOUCH_OPTION_XCHARGETYPE_HALF">
    /* Multiple Charges - Half*/
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    <#list 0..mtouch.sensor.items[i].xcharge.order-1 as j>
    asm("movlw          ${pic.adc.adcon0_unimpl}");
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    asm("bcf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_XCHARGE_TIME;
    asm("movlw          " ___mkstr(MTOUCH_S${i}_ADCON0_SENSOR));
    asm("bsf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    _delay(MTOUCH_S${i}_SWITCH_TIME);
    asm("movwf          ${pic.adc.adcon0_register} & 0x7F");
    _delay(MTOUCH_S${i}_ACQUISITION_TIME);
    </#list>

</#if>
</#if>
    /* Begin Conversion */
<#if mtouch.sensor.items[i].guard.type == "MTOUCH_OPTION_GUARDTYPE_DAC">
    asm("bsf            INDF1 & 0x7F, ${pic.adc.go_bit}");
<#else>
    asm("BANKSEL        ${pic.adc.adcon0_register}");
    asm("bsf            ${pic.adc.adcon0_register} & 0x7F, ${pic.adc.go_bit}");
</#if>

    /* Disconnection Delay */
    _delay(MTOUCH_S${i}_DISCON_TIME);

    /* Exit Logic - Output Low */
    asm("BANKSEL        " ___mkstr(MTOUCH_S${i}_LAT));
    asm("bcf            " ___mkstr(MTOUCH_S${i}_LAT) " & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
    asm("bcf            INDF0 & 0x7F, " ___mkstr(MTOUCH_S${i}_PIN));
<#if mtouch.sensor.items[i].guard.type == "MTOUCH_OPTION_GUARDTYPE_DAC">
    asm("BANKSEL        LAT${pic.dac.dacout.port}");
    asm("bcf            LAT${pic.dac.dacout.port} & 0x7F, PIC_DAC_DACOUT_PIN");
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("clrf           ${pic.dac.daccon0_register} & 0x7F");
<#elseif mtouch.sensor.items[i].reference.type == "MTOUCH_OPTION_REFTYPE_DAC" >
    asm("BANKSEL        ${pic.dac.daccon0_register}");
    asm("clrf           ${pic.dac.daccon0_register} & 0x7F");
</#if>

}

</#list>
