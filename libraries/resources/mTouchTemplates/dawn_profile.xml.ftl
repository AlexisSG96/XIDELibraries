<Dawn>
 <NewTouchProfile>
  <Variables>
   <Variable Name="Button Threshold" Type="uchar(8-bit)" Number="${mtouch.button.items?size}" Location="${mtouch.communication.memoryMap.buttonThresholdAddress}" Description=""/>
<#if mtouch.proximity??>
    <Variable Name="Proximity Threshold" Type="uchar(8-bit)" Number="${mtouch.proximity.items?size}" Location="${mtouch.communication.memoryMap.proximityThresholdAddress}" Description=""/>
</#if>
   <Variable Name="Button StateMask" Type="${mtouch.button.buttonmask.DawnType}" Number="1" Location="${mtouch.communication.memoryMap.statemaskAddress}" Description=""/>
<#if mtouch.proximity??>
   <Variable Name="Proximity Sensitivity Scaling" Type="uchar(8-bit)" Number="${mtouch.proximity.items?size}" Location="${mtouch.communication.memoryMap.proximityScalingAddress}" Description=""/>
</#if>
   <Variable Name="Button Sensitivity Scaling" Type="uchar(8-bit)" Number="${mtouch.button.items?size}" Location="${mtouch.communication.memoryMap.buttonScalingAddress}" Description=""/>
   <Variable Name="Force Sensor Calibration" Type="uchar(8-bit)" Number="1" Location="${mtouch.communication.memoryMap.calibrationAddress}" Description=""/>
  </Variables>
  <Signals>
   <Signal Name="Button Signal Deviation" Type="char(8-bit)" Number="${mtouch.button.items?size}" Location="${mtouch.communication.memoryMap.buttonDeivationAddress}" ShowLevelBar="Yes" Description="">
    <Threshold Name="Press Button Signal Deviation (Dawn)" Location="${mtouch.communication.memoryMap.buttonThresholdAddress}"/>
   </Signal>
<#if mtouch.proximity??>
   <Signal Name="Proximity Signal Deviation" Type="char(8-bit)" Number="${mtouch.proximity.items?size}" Location="${mtouch.communication.memoryMap.proximityDeviationAddress}" ShowLevelBar="Yes" Description="">
    <Threshold Name="Press Proximity Signal Deviation (Dawn)" Location="${mtouch.communication.memoryMap.proximityThresholdAddress}"/>
</#if>
   </Signal>
  </Signals>
  <System>
   <System Name="ProductID" Value="0x0001" Description=" Connected Device ID number."/>
   <System Name="I2CAddress" Value="${mtouch.communication.i2caddress}" Description="Address value of touch product, allowing it to be accessed on an I2C communication bus"/>
   <System Name="Webpage" Weblink="http://www.microchip.com"/>
  </System>
 </NewTouchProfile>
</Dawn>
