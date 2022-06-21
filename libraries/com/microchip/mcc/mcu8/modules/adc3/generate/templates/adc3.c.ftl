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
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"

//Pointers to ADC interrupt handlers
//User can use them in application code to initialize with custom ISRs
static void (*${moduleNameUpperCase}_ConversionComplete_ISR)(void);
static void (*${moduleNameUpperCase}_Context1Thereshld_ISR)(void);
<#if enableCtx2>
static void (*${moduleNameUpperCase}_Context2Thereshld_ISR)(void);
</#if>
<#if enableCtx3>
static void (*${moduleNameUpperCase}_Context3Thereshld_ISR)(void);
</#if>
<#if enableCtx4>
static void (*${moduleNameUpperCase}_Context4Thereshld_ISR)(void);
</#if>
static void (*${moduleNameUpperCase}_ActiveClockTuning_ISR)(void);

static void ${moduleNameUpperCase}_DefaultADI_ISR(void);
static void ${moduleNameUpperCase}_DefaultContext1Threshold_ISR(void);
<#if enableCtx2>
static void ${moduleNameUpperCase}_DefaultContext2Threshold_ISR(void);
</#if>
<#if enableCtx3>
static void ${moduleNameUpperCase}_DefaultContext3Threshold_ISR(void);
</#if>
<#if enableCtx4>
static void ${moduleNameUpperCase}_DefaultContext4Threshold_ISR(void);
</#if>
static void ${moduleNameUpperCase}_DefaultActiveClockTuning_ISR(void);

<#function createRegName name>
    <#return name?replace("CTX\\d+_", "", "r")>
</#function>

void ${moduleNameUpperCase}_Initialize(void)
{
    <#if ADACT??>
    //${ADACT.csvComment}
    ${createRegName(ADACT.name)} = ${ADACT.hexValue};
    </#if>

    <#if ADCLK??>
    //${ADCLK.csvComment}
    ${createRegName(ADCLK.name)} = ${ADCLK.hexValue};
    </#if>
    
    <#if ADCP??>
    //ADC charge pump control
    ${ADCP.name} = ${ADCP.hexValue};
    </#if>
    
    <#if enableCtx1>

    /****************************************
     *         Configure Context-1          *
     ****************************************/
    <#if ADCTX??>
    ${ADCTX.name} = 0x0;
    </#if>

    <#if CTX1_ADLTHL??>
    //${CTX1_ADLTHL.csvComment}
    ${createRegName(CTX1_ADLTHL.name)} = ${CTX1_ADLTHL.hexValue};
    </#if>

    <#if CTX1_ADLTHH??>
    //${CTX1_ADLTHH.csvComment}
    ${createRegName(CTX1_ADLTHH.name)} = ${CTX1_ADLTHH.hexValue};
    </#if>

    <#if CTX1_ADUTHL??>
    //${CTX1_ADUTHL.csvComment}
    ${createRegName(CTX1_ADUTHL.name)} = ${CTX1_ADUTHL.hexValue};
    </#if>

    <#if CTX1_ADUTHH??>
    //${CTX1_ADUTHH.csvComment}
    ${createRegName(CTX1_ADUTHH.name)} = ${CTX1_ADUTHH.hexValue};
    </#if>

    <#if CTX1_ADSTPTL??>
    //${CTX1_ADSTPTL.csvComment}
    ${createRegName(CTX1_ADSTPTL.name)} = ${CTX1_ADSTPTL.hexValue};
    </#if>

    <#if CTX1_ADSTPTH??>
    //${CTX1_ADSTPTH.csvComment}
    ${createRegName(CTX1_ADSTPTH.name)} = ${CTX1_ADSTPTH.hexValue};
    </#if>

    <#if CTX1_ADACCL??>
    //${CTX1_ADACCL.csvComment}
    ${createRegName(CTX1_ADACCL.name)} = ${CTX1_ADACCL.hexValue};
    </#if>

    <#if CTX1_ADACCH??>
    //${CTX1_ADACCH.csvComment}
    ${createRegName(CTX1_ADACCH.name)} = ${CTX1_ADACCH.hexValue};
    </#if>

    <#if CTX1_ADACCU??>
    //${CTX1_ADACCU.csvComment}
    ${createRegName(CTX1_ADACCU.name)} = ${CTX1_ADACCU.hexValue};
    </#if>

    <#if CTX1_ADCNT??>
    //${CTX1_ADCNT.csvComment}
    ${createRegName(CTX1_ADCNT.name)} = ${CTX1_ADCNT.hexValue};
    </#if>

    <#if CTX1_ADRPT??>
    //${CTX1_ADRPT.csvComment}
    ${createRegName(CTX1_ADRPT.name)} = ${CTX1_ADRPT.hexValue};
    </#if>

    <#if CTX1_ADRESL??>
    //${CTX1_ADRESL.csvComment}
    ${createRegName(CTX1_ADRESL.name)} = ${CTX1_ADRESL.hexValue};
    </#if>

    <#if CTX1_ADRESH??>
    //${CTX1_ADRESH.csvComment}
    ${createRegName(CTX1_ADRESH.name)} = ${CTX1_ADRESH.hexValue};
    </#if>

    <#if CTX1_ADPCH??>
    //${CTX1_ADPCH.csvComment}
    ${createRegName(CTX1_ADPCH.name)} = ${CTX1_ADPCH.hexValue};
    </#if>

    <#if CTX1_ADACQL??>
    //${CTX1_ADACQL.csvComment}
    ${createRegName(CTX1_ADACQL.name)} = ${CTX1_ADACQL.hexValue};
    </#if>

    <#if CTX1_ADACQH??>
    //${CTX1_ADACQH.csvComment}
    ${createRegName(CTX1_ADACQH.name)} = ${CTX1_ADACQH.hexValue};
    </#if>

    <#if CTX1_ADCAP??>
    //${CTX1_ADCAP.csvComment}
    ${createRegName(CTX1_ADCAP.name)} = ${CTX1_ADCAP.hexValue};
    </#if>

    <#if CTX1_ADPREL??>
    //${CTX1_ADPREL.csvComment}
    ${createRegName(CTX1_ADPREL.name)} = ${CTX1_ADPREL.hexValue};
    </#if>

    <#if CTX1_ADPREH??>
    //${CTX1_ADPREH.csvComment}
    ${createRegName(CTX1_ADPREH.name)} = ${CTX1_ADPREH.hexValue};
    </#if>
    
    <#if CTX1_ADCON0??>
    //${CTX1_ADCON0.csvComment}
    ${createRegName(CTX1_ADCON0.name)} = ${CTX1_ADCON0.hexValue};
    </#if>

    <#if CTX1_ADCON1??>
    //${CTX1_ADCON1.csvComment}
    ${createRegName(CTX1_ADCON1.name)} = ${CTX1_ADCON1.hexValue};
    </#if>

    <#if CTX1_ADCON2??>
    //${CTX1_ADCON2.csvComment}
    ${createRegName(CTX1_ADCON2.name)} = ${CTX1_ADCON2.hexValue};
    </#if>

    <#if CTX1_ADCON3??>
    //${CTX1_ADCON3.csvComment}
    ${createRegName(CTX1_ADCON3.name)} = ${CTX1_ADCON3.hexValue};
    </#if>

    <#if CTX1_ADSTAT??>
    //${CTX1_ADSTAT.csvComment}
    ${createRegName(CTX1_ADSTAT.name)} = ${CTX1_ADSTAT.hexValue};
    </#if>

    <#if CTX1_ADREF??>
    //${CTX1_ADREF.csvComment}
    ${createRegName(CTX1_ADREF.name)} = ${CTX1_ADREF.hexValue};
    </#if>
    
    <#if ADCSEL1??>
    //${ADCSEL1.csvComment}
    ${ADCSEL1.name} = ${ADCSEL1.hexValue};
    </#if>    
    </#if>    
    <#if enableCtx2>
	
    /****************************************
     *         Configure Context-2          *
     ****************************************/
    <#if ADCTX??>
    ${ADCTX.name} = 0x1;
    </#if>

    <#if CTX2_ADLTHL??>
    //${CTX2_ADLTHL.csvComment}
    ${createRegName(CTX2_ADLTHL.name)} = ${CTX2_ADLTHL.hexValue};
    </#if>

    <#if CTX2_ADLTHH??>
    //${CTX2_ADLTHH.csvComment}
    ${createRegName(CTX2_ADLTHH.name)} = ${CTX2_ADLTHH.hexValue};
    </#if>

    <#if CTX2_ADUTHL??>
    //${CTX2_ADUTHL.csvComment}
    ${createRegName(CTX2_ADUTHL.name)} = ${CTX2_ADUTHL.hexValue};
    </#if>

    <#if CTX2_ADUTHH??>
    //${CTX2_ADUTHH.csvComment}
    ${createRegName(CTX2_ADUTHH.name)} = ${CTX2_ADUTHH.hexValue};
    </#if>

    <#if CTX2_ADSTPTL??>
    //${CTX2_ADSTPTL.csvComment}
    ${createRegName(CTX2_ADSTPTL.name)} = ${CTX2_ADSTPTL.hexValue};
    </#if>

    <#if CTX2_ADSTPTH??>
    //${CTX2_ADSTPTH.csvComment}
    ${createRegName(CTX2_ADSTPTH.name)} = ${CTX2_ADSTPTH.hexValue};
    </#if>

    <#if CTX2_ADACCL??>
    //${CTX2_ADACCL.csvComment}
    ${createRegName(CTX2_ADACCL.name)} = ${CTX2_ADACCL.hexValue};
    </#if>

    <#if CTX2_ADACCH??>
    //${CTX2_ADACCH.csvComment}
    ${createRegName(CTX2_ADACCH.name)} = ${CTX2_ADACCH.hexValue};
    </#if>

    <#if CTX2_ADACCU??>
    //${CTX2_ADACCU.csvComment}
    ${createRegName(CTX2_ADACCU.name)} = ${CTX2_ADACCU.hexValue};
    </#if>

    <#if CTX2_ADCNT??>
    //${CTX2_ADCNT.csvComment}
    ${createRegName(CTX2_ADCNT.name)} = ${CTX2_ADCNT.hexValue};
    </#if>

    <#if CTX2_ADRPT??>
    //${CTX2_ADRPT.csvComment}
    ${createRegName(CTX2_ADRPT.name)} = ${CTX2_ADRPT.hexValue};
    </#if>

    <#if CTX2_ADRESL??>
    //${CTX2_ADRESL.csvComment}
    ${createRegName(CTX2_ADRESL.name)} = ${CTX2_ADRESL.hexValue};
    </#if>

    <#if CTX2_ADRESH??>
    //${CTX2_ADRESH.csvComment}
    ${createRegName(CTX2_ADRESH.name)} = ${CTX2_ADRESH.hexValue};
    </#if>

    <#if CTX2_ADPCH??>
    //${CTX2_ADPCH.csvComment}
    ${createRegName(CTX2_ADPCH.name)} = ${CTX2_ADPCH.hexValue};
    </#if>

    <#if CTX2_ADACQL??>
    //${CTX2_ADACQL.csvComment}
    ${createRegName(CTX2_ADACQL.name)} = ${CTX2_ADACQL.hexValue};
    </#if>

    <#if CTX2_ADACQH??>
    //${CTX2_ADACQH.csvComment}
    ${createRegName(CTX2_ADACQH.name)} = ${CTX2_ADACQH.hexValue};
    </#if>

    <#if CTX2_ADCAP??>
    //${CTX2_ADCAP.csvComment}
    ${createRegName(CTX2_ADCAP.name)} = ${CTX2_ADCAP.hexValue};
    </#if>

    <#if CTX2_ADPREL??>
    //${CTX2_ADPREL.csvComment}
    ${createRegName(CTX2_ADPREL.name)} = ${CTX2_ADPREL.hexValue};
    </#if>

    <#if CTX2_ADPREH??>
    //${CTX2_ADPREH.csvComment}
    ${createRegName(CTX2_ADPREH.name)} = ${CTX2_ADPREH.hexValue};
    </#if>
    
    <#if CTX2_ADCON0??>
    //${CTX2_ADCON0.csvComment}
    ${createRegName(CTX2_ADCON0.name)} = ${CTX2_ADCON0.hexValue};
    </#if>

    <#if CTX2_ADCON1??>
    //${CTX2_ADCON1.csvComment}
    ${createRegName(CTX2_ADCON1.name)} = ${CTX2_ADCON1.hexValue};
    </#if>

    <#if CTX2_ADCON2??>
    //${CTX2_ADCON2.csvComment}
    ${createRegName(CTX2_ADCON2.name)} = ${CTX2_ADCON2.hexValue};
    </#if>

    <#if CTX2_ADCON3??>
    //${CTX2_ADCON3.csvComment}
    ${createRegName(CTX2_ADCON3.name)} = ${CTX2_ADCON3.hexValue};
    </#if>

    <#if CTX2_ADSTAT??>
    //${CTX2_ADSTAT.csvComment}
    ${createRegName(CTX2_ADSTAT.name)} = ${CTX2_ADSTAT.hexValue};
    </#if>

    <#if CTX2_ADREF??>
    //${CTX2_ADREF.csvComment}
    ${createRegName(CTX2_ADREF.name)} = ${CTX2_ADREF.hexValue};
    </#if>
    
    <#if ADCSEL2??>
    //${ADCSEL2.csvComment}
    ${ADCSEL2.name} = ${ADCSEL2.hexValue};
    </#if>
    </#if>
    <#if enableCtx3>
	
    /****************************************
     *         Configure Context-3          *
     ****************************************/
    <#if ADCTX??>
    ${ADCTX.name} = 0x2;
    </#if>

    <#if CTX3_ADLTHL??>
    //${CTX3_ADLTHL.csvComment}
    ${createRegName(CTX3_ADLTHL.name)} = ${CTX3_ADLTHL.hexValue};
    </#if>

    <#if CTX3_ADLTHH??>
    //${CTX3_ADLTHH.csvComment}
    ${createRegName(CTX3_ADLTHH.name)} = ${CTX3_ADLTHH.hexValue};
    </#if>

    <#if CTX3_ADUTHL??>
    //${CTX3_ADUTHL.csvComment}
    ${createRegName(CTX3_ADUTHL.name)} = ${CTX3_ADUTHL.hexValue};
    </#if>

    <#if CTX3_ADUTHH??>
    //${CTX3_ADUTHH.csvComment}
    ${createRegName(CTX3_ADUTHH.name)} = ${CTX3_ADUTHH.hexValue};
    </#if>

    <#if CTX3_ADSTPTL??>
    //${CTX3_ADSTPTL.csvComment}
    ${createRegName(CTX3_ADSTPTL.name)} = ${CTX3_ADSTPTL.hexValue};
    </#if>

    <#if CTX3_ADSTPTH??>
    //${CTX3_ADSTPTH.csvComment}
    ${createRegName(CTX3_ADSTPTH.name)} = ${CTX3_ADSTPTH.hexValue};
    </#if>

    <#if CTX3_ADACCL??>
    //${CTX3_ADACCL.csvComment}
    ${createRegName(CTX3_ADACCL.name)} = ${CTX3_ADACCL.hexValue};
    </#if>

    <#if CTX3_ADACCH??>
    //${CTX3_ADACCH.csvComment}
    ${createRegName(CTX3_ADACCH.name)} = ${CTX3_ADACCH.hexValue};
    </#if>

    <#if CTX3_ADACCU??>
    //${CTX3_ADACCU.csvComment}
    ${createRegName(CTX3_ADACCU.name)} = ${CTX3_ADACCU.hexValue};
    </#if>

    <#if CTX3_ADCNT??>
    //${CTX3_ADCNT.csvComment}
    ${createRegName(CTX3_ADCNT.name)} = ${CTX3_ADCNT.hexValue};
    </#if>

    <#if CTX3_ADRPT??>
    //${CTX3_ADRPT.csvComment}
    ${createRegName(CTX3_ADRPT.name)} = ${CTX3_ADRPT.hexValue};
    </#if>

    <#if CTX3_ADRESL??>
    //${CTX3_ADRESL.csvComment}
    ${createRegName(CTX3_ADRESL.name)} = ${CTX3_ADRESL.hexValue};
    </#if>

    <#if CTX3_ADRESH??>
    //${CTX3_ADRESH.csvComment}
    ${createRegName(CTX3_ADRESH.name)} = ${CTX3_ADRESH.hexValue};
    </#if>

    <#if CTX3_ADPCH??>
    //${CTX3_ADPCH.csvComment}
    ${createRegName(CTX3_ADPCH.name)} = ${CTX3_ADPCH.hexValue};
    </#if>

    <#if CTX3_ADACQL??>
    //${CTX3_ADACQL.csvComment}
    ${createRegName(CTX3_ADACQL.name)} = ${CTX3_ADACQL.hexValue};
    </#if>

    <#if CTX3_ADACQH??>
    //${CTX3_ADACQH.csvComment}
    ${createRegName(CTX3_ADACQH.name)} = ${CTX3_ADACQH.hexValue};
    </#if>

    <#if CTX3_ADCAP??>
    //${CTX3_ADCAP.csvComment}
    ${createRegName(CTX3_ADCAP.name)} = ${CTX3_ADCAP.hexValue};
    </#if>

    <#if CTX3_ADPREL??>
    //${CTX3_ADPREL.csvComment}
    ${createRegName(CTX3_ADPREL.name)} = ${CTX3_ADPREL.hexValue};
    </#if>

    <#if CTX3_ADPREH??>
    //${CTX3_ADPREH.csvComment}
    ${createRegName(CTX3_ADPREH.name)} = ${CTX3_ADPREH.hexValue};
    </#if>
    
    <#if CTX3_ADCON0??>
    //${CTX3_ADCON0.csvComment}
    ${createRegName(CTX3_ADCON0.name)} = ${CTX3_ADCON0.hexValue};
    </#if>

    <#if CTX3_ADCON1??>
    //${CTX3_ADCON1.csvComment}
    ${createRegName(CTX3_ADCON1.name)} = ${CTX3_ADCON1.hexValue};
    </#if>

    <#if CTX3_ADCON2??>
    //${CTX3_ADCON2.csvComment}
    ${createRegName(CTX3_ADCON2.name)} = ${CTX3_ADCON2.hexValue};
    </#if>

    <#if CTX3_ADCON3??>
    //${CTX3_ADCON3.csvComment}
    ${createRegName(CTX3_ADCON3.name)} = ${CTX3_ADCON3.hexValue};
    </#if>

    <#if CTX3_ADSTAT??>
    //${CTX3_ADSTAT.csvComment}
    ${createRegName(CTX3_ADSTAT.name)} = ${CTX3_ADSTAT.hexValue};
    </#if>

    <#if CTX3_ADREF??>
    //${CTX3_ADREF.csvComment}
    ${createRegName(CTX3_ADREF.name)} = ${CTX3_ADREF.hexValue};
    </#if>
    
    <#if ADCSEL3??>
    //${ADCSEL3.csvComment}
    ${ADCSEL3.name} = ${ADCSEL3.hexValue};
    </#if>
    </#if>    
    <#if enableCtx4>
	
    /****************************************
     *         Configure Context-4          *
     ****************************************/
    <#if ADCTX??>
    ${ADCTX.name} = 0x3;
    </#if>

    <#if CTX4_ADLTHL??>
    //${CTX4_ADLTHL.csvComment}
    ${createRegName(CTX4_ADLTHL.name)} = ${CTX4_ADLTHL.hexValue};
    </#if>

    <#if CTX4_ADLTHH??>
    //${CTX4_ADLTHH.csvComment}
    ${createRegName(CTX4_ADLTHH.name)} = ${CTX4_ADLTHH.hexValue};
    </#if>

    <#if CTX4_ADUTHL??>
    //${CTX4_ADUTHL.csvComment}
    ${createRegName(CTX4_ADUTHL.name)} = ${CTX4_ADUTHL.hexValue};
    </#if>

    <#if CTX4_ADUTHH??>
    //${CTX4_ADUTHH.csvComment}
    ${createRegName(CTX4_ADUTHH.name)} = ${CTX4_ADUTHH.hexValue};
    </#if>

    <#if CTX4_ADSTPTL??>
    //${CTX4_ADSTPTL.csvComment}
    ${createRegName(CTX4_ADSTPTL.name)} = ${CTX4_ADSTPTL.hexValue};
    </#if>

    <#if CTX4_ADSTPTH??>
    //${CTX4_ADSTPTH.csvComment}
    ${createRegName(CTX4_ADSTPTH.name)} = ${CTX4_ADSTPTH.hexValue};
    </#if>

    <#if CTX4_ADACCL??>
    //${CTX4_ADACCL.csvComment}
    ${createRegName(CTX4_ADACCL.name)} = ${CTX4_ADACCL.hexValue};
    </#if>

    <#if CTX4_ADACCH??>
    //${CTX4_ADACCH.csvComment}
    ${createRegName(CTX4_ADACCH.name)} = ${CTX4_ADACCH.hexValue};
    </#if>

    <#if CTX4_ADACCU??>
    //${CTX4_ADACCU.csvComment}
    ${createRegName(CTX4_ADACCU.name)} = ${CTX4_ADACCU.hexValue};
    </#if>

    <#if CTX4_ADCNT??>
    //${CTX4_ADCNT.csvComment}
    ${createRegName(CTX4_ADCNT.name)} = ${CTX4_ADCNT.hexValue};
    </#if>

    <#if CTX4_ADRPT??>
    //${CTX4_ADRPT.csvComment}
    ${createRegName(CTX4_ADRPT.name)} = ${CTX4_ADRPT.hexValue};
    </#if>

    <#if CTX4_ADRESL??>
    //${CTX4_ADRESL.csvComment}
    ${createRegName(CTX4_ADRESL.name)} = ${CTX4_ADRESL.hexValue};
    </#if>

    <#if CTX4_ADRESH??>
    //${CTX4_ADRESH.csvComment}
    ${createRegName(CTX4_ADRESH.name)} = ${CTX4_ADRESH.hexValue};
    </#if>

    <#if CTX4_ADPCH??>
    //${CTX4_ADPCH.csvComment}
    ${createRegName(CTX4_ADPCH.name)} = ${CTX4_ADPCH.hexValue};
    </#if>

    <#if CTX4_ADACQL??>
    //${CTX4_ADACQL.csvComment}
    ${createRegName(CTX4_ADACQL.name)} = ${CTX4_ADACQL.hexValue};
    </#if>

    <#if CTX4_ADACQH??>
    //${CTX4_ADACQH.csvComment}
    ${createRegName(CTX4_ADACQH.name)} = ${CTX4_ADACQH.hexValue};
    </#if>

    <#if CTX4_ADCAP??>
    //${CTX4_ADCAP.csvComment}
    ${createRegName(CTX4_ADCAP.name)} = ${CTX4_ADCAP.hexValue};
    </#if>

    <#if CTX4_ADPREL??>
    //${CTX4_ADPREL.csvComment}
    ${createRegName(CTX4_ADPREL.name)} = ${CTX4_ADPREL.hexValue};
    </#if>

    <#if CTX4_ADPREH??>
    //${CTX4_ADPREH.csvComment}
    ${createRegName(CTX4_ADPREH.name)} = ${CTX4_ADPREH.hexValue};
    </#if>
    
    <#if CTX4_ADCON0??>
    //${CTX4_ADCON0.csvComment}
    ${createRegName(CTX4_ADCON0.name)} = ${CTX4_ADCON0.hexValue};
    </#if>

    <#if CTX4_ADCON1??>
    //${CTX4_ADCON1.csvComment}
    ${createRegName(CTX4_ADCON1.name)} = ${CTX4_ADCON1.hexValue};
    </#if>

    <#if CTX4_ADCON2??>
    //${CTX4_ADCON2.csvComment}
    ${createRegName(CTX4_ADCON2.name)} = ${CTX4_ADCON2.hexValue};
    </#if>

    <#if CTX4_ADCON3??>
    //${CTX4_ADCON3.csvComment}
    ${createRegName(CTX4_ADCON3.name)} = ${CTX4_ADCON3.hexValue};
    </#if>

    <#if CTX4_ADSTAT??>
    //${CTX4_ADSTAT.csvComment}
    ${createRegName(CTX4_ADSTAT.name)} = ${CTX4_ADSTAT.hexValue};
    </#if>

    <#if CTX4_ADREF??>
    //${CTX4_ADREF.csvComment}
    ${createRegName(CTX4_ADREF.name)} = ${CTX4_ADREF.hexValue};
    </#if>
    
    <#if ADCSEL4??>
    //${ADCSEL4.csvComment}
    ${ADCSEL4.name} = ${ADCSEL4.hexValue};
    </#if>
    </#if>
    
    //Clear ADC Interrupt Flag
    ${ADI_FLAG.name} = 0;
    
    //Clear ADC active clock tuning interrupt flag
    ${ACTI_FLAG.name} = 0;
    
    //Clear ADC Context Threshold Interrupt Flag
    <#if enableCtx1>
    ${ADCH1_FLAG.name} = 0;
    </#if>
    <#if enableCtx2>
    ${ADCH2_FLAG.name} = 0;
    </#if>
    <#if enableCtx3>
    ${ADCH3_FLAG.name} = 0;
    </#if>
    <#if enableCtx4>
    ${ADCH4_FLAG.name} = 0;
    </#if>
    
    <#if enableAdcInterrupt>
    //Set ADC interrupt enable bit
    ${ADI_ENABLE.name} = 1;
    </#if>
    <#if enableACTInterrupt>
    //Set ADC active clock tuning interrupt enable bit
    ${ACTI_ENABLE.name} = 1;
    </#if>
    <#if enableThreshouldInterruptCtx1>
    //Set ADC Context-1 threshold interrupt enable bit
    ${ADCH1_ENABLE.name} = 1;
    </#if>
    <#if enableCtx2 && enableThreshouldInterruptCtx2>
    //Set ADC Context-2 threshold interrupt enable bit
    ${ADCH2_ENABLE.name} = 1;
    </#if>
    <#if enableCtx3 && enableThreshouldInterruptCtx3>
    //Set ADC Context-3 threshold interrupt enable bit
    ${ADCH3_ENABLE.name} = 1;
    </#if>
    <#if enableCtx4 && enableThreshouldInterruptCtx4>
    //Set ADC Context-4 threshold interrupt enable bit
    ${ADCH4_ENABLE.name} = 1;
    </#if>

    //Configure interrupt handlers
    ${moduleNameUpperCase}_SetADIInterruptHandler(${moduleNameUpperCase}_DefaultADI_ISR);
    <#if enableCtx1>
    ${moduleNameUpperCase}_SetContext1ThresholdInterruptHandler(${moduleNameUpperCase}_DefaultContext1Threshold_ISR);
    </#if>
    <#if enableCtx2>
    ${moduleNameUpperCase}_SetContext2ThresholdInterruptHandler(${moduleNameUpperCase}_DefaultContext2Threshold_ISR);
    </#if>
    <#if enableCtx3>
    ${moduleNameUpperCase}_SetContext3ThresholdInterruptHandler(${moduleNameUpperCase}_DefaultContext3Threshold_ISR);
    </#if>
    <#if enableCtx4>
    ${moduleNameUpperCase}_SetContext4ThresholdInterruptHandler(${moduleNameUpperCase}_DefaultContext4Threshold_ISR);
    </#if>
    ${moduleNameUpperCase}_SetActiveClockTuningInterruptHandler(${moduleNameUpperCase}_DefaultActiveClockTuning_ISR);
        
    <#if ADCON0??>
    //${ADCON0.csvComment}
    ${ADCON0.name} = ${ADCON0.hexValue};
    </#if>
}

inline void ${moduleNameUpperCase}_EnableChannelSequencer(void)
{
    ${createRegName(CTX1_ADCON0.name)}bits.CSEN = 1;
}

inline void ${moduleNameUpperCase}_DisableChannelSequencer(void)
{
    ${createRegName(CTX1_ADCON0.name)}bits.CSEN = 0;
}

inline void ${moduleNameUpperCase}_StartChannelSequencer(void)
{
    ${ADCON0.name}bits.GO = 1;
}

inline void ${moduleNameUpperCase}_SelectContext(${moduleNameUpperCase}_context_t context)
{
    ${ADCTX.name} = context;
}

void ${moduleNameUpperCase}_EnableChannelScan(${moduleNameUpperCase}_context_t context)
{
    switch (context)
    {
        <#if enableCtx1>
    case ${labelCtx1}:
        ${ADCSEL1.name}bits.CHEN = 1;
        break;
        </#if>
        <#if enableCtx2>
    case ${labelCtx2}:
        ${ADCSEL2.name}bits.CHEN = 1;
        break;
        </#if>
        <#if enableCtx3>
    case ${labelCtx3}:
        ${ADCSEL3.name}bits.CHEN = 1;
        break;
        </#if>
        <#if enableCtx4>
    case ${labelCtx4}:
        ${ADCSEL4.name}bits.CHEN = 1;
        break;
        </#if>
    default:
        break;
    }
}

void ${moduleNameUpperCase}_DisableChannelScan(${moduleNameUpperCase}_context_t context)
{
    switch (context)
    {
        <#if enableCtx1>
    case ${labelCtx1}:
        ${ADCSEL1.name}bits.CHEN = 0;
        break;
        </#if>
        <#if enableCtx2>
    case ${labelCtx2}:
        ${ADCSEL2.name}bits.CHEN = 0;
        break;
        </#if>
        <#if enableCtx3>
    case ${labelCtx3}:
        ${ADCSEL3.name}bits.CHEN = 0;
        break;
        </#if>
        <#if enableCtx4>
    case ${labelCtx4}:
        ${ADCSEL4.name}bits.CHEN = 0;
        break;
        </#if>
    default:
        break;
    }
}

void ${moduleNameUpperCase}_StartConversion(${moduleNameUpperCase}_channel_t channel)
{
    //Select the A/D channel
    ${createRegName(CTX1_ADPCH.name)} = channel;

    //Turn ON the ADC module
    ${ADCON0.name}bits.ON = 1;

    //Start the conversion
    ${ADCON0.name}bits.GO = 1;
}

bool ${moduleNameUpperCase}_IsConversionDone(void)
{
    return (bool) (!${ADCON0.name}bits.GO);
}

adc_result_t ${moduleNameUpperCase}_GetConversionResult(void)
{
    //Return result of A/D conversion
    return ((adc_result_t) ((${createRegName(CTX1_ADRESH.name)} << 8) + ${createRegName(CTX1_ADRESL.name)}));
}

adc_result_t ${moduleNameUpperCase}_GetSingleConversion(${moduleNameUpperCase}_channel_t channel)
{
    //Select the A/D channel
    ${createRegName(CTX1_ADPCH.name)} = channel;

    //Turn ON the ADC module
    ${ADCON0.name}bits.ON = 1;

    //Disable the continuous mode
    ${ADCON0.name}bits.CONT = 0;

    //Start the conversion
    ${ADCON0.name}bits.GO = 1;

    //Wait for the conversion to finish
    while(${ADCON0.name}bits.GO)
    {

    }

    return ((adc_result_t) ((${createRegName(CTX1_ADRESH.name)} << 8) + ${createRegName(CTX1_ADRESL.name)}));
}

inline void ${moduleNameUpperCase}_StopConversion(void)
{
    //Reset the ADGO bit to manually stop conversion
    ${ADCON0.name}bits.GO = 0;
}

inline void ${moduleNameUpperCase}_SetStopOnInterrupt(void)
{
    ${createRegName(CTX1_ADCON3.name)}bits.SOI = 1;
}

inline void ${moduleNameUpperCase}_DischargeSampleCapacitor(void)
{
    //Set ADC channel to AVss
    ${createRegName(CTX1_ADPCH.name)} = 0x3b;
}

void ${moduleNameUpperCase}_LoadAcquisitionRegister(uint16_t acquisitionValue)
{
    ${createRegName(CTX1_ADACQH.name)} = acquisitionValue >> 8;
    ${createRegName(CTX1_ADACQL.name)} = acquisitionValue;
}

void ${moduleNameUpperCase}_SetPrechargeTime(uint16_t prechargeTime)
{
    ${createRegName(CTX1_ADPREH.name)} = prechargeTime >> 8;
    ${createRegName(CTX1_ADPREL.name)} = prechargeTime;
}

inline void ${moduleNameUpperCase}_SetRepeatCount(uint8_t repeatCount)
{
    ${createRegName(CTX1_ADRPT.name)} = repeatCount;
}

uint8_t ${moduleNameUpperCase}_GetCurrentCountofConversions(void)
{
    return ${createRegName(CTX1_ADCNT.name)};
}

inline void ${moduleNameUpperCase}_ClearAccumulator(void)
{
    ${createRegName(CTX1_ADCON2.name)}bits.ACLR = 1;
}

uint24_t ${moduleNameUpperCase}_GetAccumulatorValue(void)
{
    return ((uint24_t) ((${createRegName(CTX1_ADACCH.name)} << 8) + ${createRegName(CTX1_ADACCL.name)}));
}

bool ${moduleNameUpperCase}_HasAccumulatorOverflowed(void)
{
    return ${createRegName(CTX1_ADSTAT.name)}bits.ADAOV;
}

uint16_t ${moduleNameUpperCase}_GetFilterValue(void)
{
    return ((uint16_t) ((${createRegName(CTX1_ADFLTRH.name)} << 8) + ${createRegName(CTX1_ADFLTRL.name)}));
}

uint16_t ${moduleNameUpperCase}_GetPreviousResult(void)
{
    return ((uint16_t) ((${createRegName(CTX1_ADPREVH.name)} << 8) + ${createRegName(CTX1_ADPREVL.name)}));
}

void ${moduleNameUpperCase}_DefineSetPoint(uint16_t setPoint)
{
    ${createRegName(CTX1_ADSTPTH.name)} = setPoint >> 8;
    ${createRegName(CTX1_ADSTPTL.name)} = setPoint;
}

void ${moduleNameUpperCase}_SetUpperThreshold(uint16_t upperThreshold)
{
    ${createRegName(CTX1_ADUTHH.name)} = upperThreshold >> 8;
    ${createRegName(CTX1_ADUTHL.name)} = upperThreshold;
}

void ${moduleNameUpperCase}_SetLowerThreshold(uint16_t lowerThreshold)
{
    ${createRegName(CTX1_ADLTHH.name)} = lowerThreshold >> 8;
    ${createRegName(CTX1_ADLTHL.name)} = lowerThreshold;
}

uint16_t ${moduleNameUpperCase}_GetErrorCalculation(void)
{
    return ((uint16_t) ((${createRegName(CTX1_ADERRH.name)} << 8) + ${createRegName(CTX1_ADERRL.name)}));
}

inline void ${moduleNameUpperCase}_EnableDoubleSampling(void)
{
    ${createRegName(CTX1_ADCON1.name)}bits.DSEN = 1;
}

inline void ${moduleNameUpperCase}_EnableContinuousConversion(void)
{
    ${ADCON0.name}bits.CONT = 1;
}

inline void ${moduleNameUpperCase}_DisableContinuousConversion(void)
{
    ${ADCON0.name}bits.CONT = 0;
}

bool ${moduleNameUpperCase}_HasErrorCrossedUpperThreshold(void)
{
    return ${createRegName(CTX1_ADSTAT.name)}bits.ADUTHR;
}

bool ${moduleNameUpperCase}_HasErrorCrossedLowerThreshold(void)
{
    return ${createRegName(CTX1_ADSTAT.name)}bits.ADLTHR;
}

uint8_t ${moduleNameUpperCase}_GetConversionStageStatus(void)
{
    return ${createRegName(CTX1_ADSTAT.name)}bits.ADSTAT;
}

inline void ${moduleNameUpperCase}_EnableChargePump(void)
{
    ${ADCP.name}bits.CPON = 1;
}

inline void ${moduleNameUpperCase}_DisableChargePump(void)
{
    ${ADCP.name}bits.CPON = 0;
}

<#if isVectoredInterrupt>
<#if isADIHighPriority>
void __interrupt(irq(${ADI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ADI_ISR(void)
<#else>
void __interrupt(irq(${ADI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ADI_ISR(void)
</#if>
<#else>
void ${moduleNameUpperCase}_ADI_ISR(void)
</#if>
{
    ${ADI_FLAG.name} = 0;
    if (${moduleNameUpperCase}_ConversionComplete_ISR != NULL)
        ${moduleNameUpperCase}_ConversionComplete_ISR();
}

<#if isVectoredInterrupt>
<#if isACTIHighPriority>
void __interrupt(irq(${ACTI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ACTI_ISR(void)
<#else>
void __interrupt(irq(${ACTI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ACTI_ISR(void)
</#if>
<#else>
void ${moduleNameUpperCase}_ACTI_ISR(void)
</#if>
{
    ${ACTI_FLAG.name} = 0;
    if (${moduleNameUpperCase}_ActiveClockTuning_ISR != NULL)
        ${moduleNameUpperCase}_ActiveClockTuning_ISR();
}

<#if enableCtx1>

<#if isVectoredInterrupt>
<#if isADCH1HighPriority>
void __interrupt(irq(${ADCH1_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ADCH1_ISR(void)
<#else>
void __interrupt(irq(${ADCH1_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ADCH1_ISR(void)
</#if>
<#else>
void ${moduleNameUpperCase}_ADCH1_ISR(void)
</#if>
{
    ${ADCH1_FLAG.name} = 0;
    if (${moduleNameUpperCase}_Context1Thereshld_ISR != NULL)
        ${moduleNameUpperCase}_Context1Thereshld_ISR();
}
</#if>
<#if enableCtx2>

<#if isVectoredInterrupt>
<#if isADCH2HighPriority>
void __interrupt(irq(${ADCH2_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ADCH2_ISR(void)
<#else>
void __interrupt(irq(${ADCH2_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ADCH2_ISR(void)
</#if>
<#else>
void ${moduleNameUpperCase}_ADCH2_ISR(void)
</#if>
{
    ${ADCH2_FLAG.name} = 0;
    if (${moduleNameUpperCase}_Context2Thereshld_ISR != NULL)
        ${moduleNameUpperCase}_Context2Thereshld_ISR();
}
</#if>
<#if enableCtx3>

<#if isVectoredInterrupt>
<#if isADCH3HighPriority>
void __interrupt(irq(${ADCH3_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ADCH3_ISR(void)
<#else>
void __interrupt(irq(${ADCH3_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ADCH3_ISR(void)
</#if>
<#else>
void ${moduleNameUpperCase}_ADCH3_ISR(void)
</#if>
{
    ${ADCH3_FLAG.name} = 0;
    if (${moduleNameUpperCase}_Context3Thereshld_ISR != NULL)
        ${moduleNameUpperCase}_Context3Thereshld_ISR();
}
</#if>
<#if enableCtx4>

<#if isVectoredInterrupt>
<#if isADCH4HighPriority>
void __interrupt(irq(${ADCH4_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ADCH4_ISR(void)
<#else>
void __interrupt(irq(${ADCH4_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ADCH4_ISR(void)
</#if>
<#else>
void ${moduleNameUpperCase}_ADCH4_ISR(void)
</#if>
{
    ${ADCH4_FLAG.name} = 0;
    if (${moduleNameUpperCase}_Context4Thereshld_ISR != NULL)
        ${moduleNameUpperCase}_Context4Thereshld_ISR();
}
</#if>

void ${moduleNameUpperCase}_SetADIInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_ConversionComplete_ISR = InterruptHandler;
}
<#if enableCtx1>

void ${moduleNameUpperCase}_SetContext1ThresholdInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Context1Thereshld_ISR = InterruptHandler;
}
</#if>
<#if enableCtx2>

void ${moduleNameUpperCase}_SetContext2ThresholdInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Context2Thereshld_ISR = InterruptHandler;
}
</#if>
<#if enableCtx3>

void ${moduleNameUpperCase}_SetContext3ThresholdInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Context3Thereshld_ISR = InterruptHandler;
}
</#if>
<#if enableCtx4>

void ${moduleNameUpperCase}_SetContext4ThresholdInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Context4Thereshld_ISR = InterruptHandler;
}
</#if>

void ${moduleNameUpperCase}_SetActiveClockTuningInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_ActiveClockTuning_ISR = InterruptHandler;
}

static void ${moduleNameUpperCase}_DefaultADI_ISR(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_SetADIInterruptHandler() function to use Custom ISR
}

<#if enableCtx1>

static void ${moduleNameUpperCase}_DefaultContext1Threshold_ISR(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_SetContext1ThresholdInterruptHandler() function to use Custom ISR
}
</#if>
<#if enableCtx2>

static void ${moduleNameUpperCase}_DefaultContext2Threshold_ISR(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_SetContext2ThresholdInterruptHandler() function to use Custom ISR
}
</#if>
<#if enableCtx3>

static void ${moduleNameUpperCase}_DefaultContext3Threshold_ISR(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_SetContext3ThresholdInterruptHandler() function to use Custom ISR
}
</#if>
<#if enableCtx4>

static void ${moduleNameUpperCase}_DefaultContext4Threshold_ISR(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_SetContext4ThresholdInterruptHandler() function to use Custom ISR
}
</#if>

static void ${moduleNameUpperCase}_DefaultActiveClockTuning_ISR(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_SetActiveClockTuningInterruptHandler() function to use Custom ISR
}

/**
  End of File
 */
