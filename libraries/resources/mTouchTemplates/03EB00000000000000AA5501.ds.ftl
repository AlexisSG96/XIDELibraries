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

B,1,1,frame_start

<#if (mtouch.button.enabled?? || mtouch.prox.enabled??)>

<#if mtouch.button.enabled??>
<#list 0..b-1 as i> 
D,${i+2},${i+1},Reading_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>
D,${i+3},${i+1},Baseline_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>
-D,${i+4},${i+1},Deviation_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>
D,${i+5},${i+1},Scaling_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>
B,${i+6},${i+1},Threshold_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>
B,${i+7},${i+1},State_<#list 0..mtouch.button.items[i].name?length-1 as j>${mtouch.button.items[i].name[j]}</#list>
</#list>
</#if>

<#if mtouch.prox.enabled??>
<#list 0..p-1 as i> 
D,${b+i+2},${b+i+1},Reading_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>
D,${b+i+2},${b+i+1},Baseline_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>
-D,${b+i+2},${b+i+1},Deviation_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>
D,${b+i+2},${b+i+1},Scaling_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>
B,${b+i+2},${b+i+1},Threshold_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>
B,${b+i+2},${b+i+1},State_<#list 0..mtouch.prox.items[i].name?length-1 as j>${mtouch.prox.items[i].name[j]}</#list>
</#list>
</#if>

<#else>

<#list 0..x-1 as i>
D,${i+2},${i+1},RawData_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>
</#list>
</#if>

<#if mtouch.dataStreamer.HCVD =="true">
<#if (mtouch.button.enabled?? || mtouch.prox.enabled??)>
<#list 0..x-1 as i>
B,${b+p+i+2},${b+p+i+1},Additional_Capacitor_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>
B,${b+p+i+2},${b+p+i+1},Acquisition_Time_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>
</#list>  
<#else>
<#list 0..x-1 as i>
B,${x+i+2},${x+i+1},Additional_Capacitor_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>
B,${x+i+2},${x+i+1},Acquisition_Time_<#list 0..mtouch.sensor.items[i].name?length-1 as j>${mtouch.sensor.items[i].name[j]}</#list>
</#list>  
</#if>
</#if>

<#if mtouch.slider.enabled??>
<#list 0..y-1 as i>
B,${x+b+p+2},${x+b+p+i+1},SWState_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>
D,${x+b+p+3},${x+b+p+i+1},SWDelta_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>
D,${x+b+p+4},${x+b+p+i+1},SWThreshold_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>
D,${x+b+p+5},${x+b+p+i+1},SWPosition_<#list 0..mtouch.slider.items[i].name?length-1 as j>${mtouch.slider.items[i].name[j]}</#list>
</#list>
</#if>

<#if mtouch.surface.enabled??>
D,${x+y+b+p+2},${x+y+b+p+1},HorizPos0
D,${x+y+b+p+3},${x+y+b+p+1},VertPos0
<#if mtouch.surface.num_contacts == 2>
D,${x+y+b+p+2},${x+y+b+p+2},HorizPos1
D,${x+y+b+p+3},${x+y+b+p+2},VertPos1
</#if>
</#if>

B,1,2,frame_end
