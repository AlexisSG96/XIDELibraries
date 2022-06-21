<#assign x = mtouch.sensor.items?size>
<#if mtouch.button.enabled??>
<#assign b = mtouch.button.items?size>
<#else>
<#assign b = 0>
</#if>
<#if mtouch.prox.enabled??>
<#assign p = mtouch.prox.items?size>
<#else>
<#assign p = 0>
</#if>
<#if mtouch.slider.enabled??>
<#assign y = mtouch.slider.items?size>
<#else>
<#assign y = 0>
</#if>
<#if mtouch.surface.enabled??>
<#assign z = 1>
<#else>
<#assign z = 0>
</#if>

<#if (mtouch.button.enabled?? || mtouch.prox.enabled??)>

<#if mtouch.button.enabled??>
<#list 0..b-1 as i> 
Reading_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,3(Column:0;Row:${i})
Baseline_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,3(Column:1;Row:${i})
Deviation_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,3(Column:2;Row:${i})
Scaling_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,3(Column:3;Row:${i})
Threshold_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,3(Column:4;Row:${i})
State_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,3(Column:5;Row:${i})
</#list>
<#list 0..b-1 as i> 
State_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,${30+i}
</#list>
<#list 0..b-1 as i> 
Deviation_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,5(visible:1)
Threshold_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>,5(visible:1)
</#list>
</#if>

<#if mtouch.prox.enabled??>
<#list 0..p-1 as i> 
Reading_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,8(Column:0;Row:${i})
Baseline_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,8(Column:1;Row:${i})
Deviation_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,8(Column:2;Row:${i})
Scaling_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,8(Column:3;Row:${i})
Threshold_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,8(Column:4;Row:${i})
State_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,8(Column:5;Row:${i})
</#list>
<#list 0..p-1 as i> 
State_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,${30+b+i}
</#list>
<#list 0..p-1 as i> 
Deviation_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,10(visible:1)
Threshold_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>,10(visible:1)
</#list>
</#if>

<#else>

<#list 0..x-1 as i> 
RawData_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>,12(Column:0;Row:${i})
</#list>
<#list 0..x-1 as i> 
RawData_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>,15(visible:1)
</#list>

</#if>

<#if mtouch.dataStreamer.HCVD =="true">
<#list 0..x-1 as i>
Additional_Capacitor_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>,17(Column:0;Row:${i})
Acquisition_Time_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>,17(Column:1;Row:${i})
</#list>
</#if>

<#if mtouch.slider.enabled??>
<#list 0..y-1 as i>
SWState_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>, 24(Column:0;Row:${i})
SWDelta_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>, 24(Column:1;Row:${i})
SWThreshold_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>, 24(Column:2;Row:${i})
SWPosition_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>, 24(Column:3;Row:${i})
</#list>
<#list 0..y-1 as i>
SWState_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>, ${30+b+p+i}
</#list>
</#if>

<#if mtouch.surface.enabled??>
HorizPos0, 29(Column:0;Row:0)
VertPos0, 29(Column:1;Row:0)
<#if mtouch.surface.num_contacts == 2>
HorizPos1, 29(Column:0;Row:1)
VertPos1, 29(Column:1;Row:1)
</#if>
</#if>

Framecounter,1(Column:0;Row:0)



