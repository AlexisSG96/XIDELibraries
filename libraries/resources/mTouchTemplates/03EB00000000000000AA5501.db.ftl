<#setting number_format="0.####">

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
<#assign contacts = mtouch.surface.num_contacts >
<#else>
<#assign z = 0>
</#if>

<#assign height = 30>
<#assign gap = 25>
<#assign variab = 0>


{
0,
'm','T','o','u','c','h',' ','D', 'a', 't', 'a', ' ','V', 'i', 's', 'u', 'a', 'l', 'i', 'z', 'e', 'r','\0',
0, 255, 255, 255,
200, 6,
};
{
0, // Dashboard ID
0, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
22, 5, // Width
${height}, 0, // Height
16, // Font Size
0,
1, // Horizontal Alignment
1, // Vertical Alignment
255, 255, 0, 0, // Background Color
255, 0, 0, 0, // Foreground Color
'm', 'T', 'o', 'u', 'c', 'h', ' ', 'D', 'a', 't', 'a', ' ', 'V', 'i', 's', 'u', 'a', 'l', 'i', 'z', 'e', 'r', '\0', // Text
};
<#assign variab = (variab + height)>
<#if (mtouch.button.enabled?? || mtouch.prox.enabled??)>
<#if mtouch.button.enabled??>
{
0, // Dashboard ID
1, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
118, 2, // Width
${height}, 0, // Height
12, // Font Size
3,
1, // Horizontal Alignment
1, // Vertical Alignment
136, 0, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
'B', 'u', 't', 't', 'o', 'n', ' ', 'D', 'a', 't', 'a', '\0', // Text
};

<#assign variab = (variab + height)>
{
0, // Dashboard ID
2, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
55, 2, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
90,0, // Data Width
90,0, // Label Width
${height},0, // Row Height
1, // Number of Rows
7, // Number of Columns
0,
'0', ':', '0', ':', 'N', 'a', 'm', 'e', ';', '1', ':', '0', ':', 'R', 'e', 'a', 'd', 'i', 'n', 'g', ';', '2', ':', '0', ':', 'B', 'a', 's', 'e', 'l', 'i', 'n', 'e', ';', '3', ':', '0', ':', 'D', 'e', 'v', 'i', 'a', 't', 'i', 'o', 'n', ';', '4', ':', '0', ':', 'S', 'c', 'a', 'l', 'i', 'n', 'g', ';', '5', ':', '0', ':', 'T', 'h', 'r', 'e', 's', 'h', 'o', 'l', 'd', ';', '6', ':', '0', ':', 'S', 't', 'a', 't', 'e', '\0', // Label Configuration
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};
<#assign variab = (variab + height)>
{
0, // Dashboard ID
3, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
90, 0, // X-coordinate
${variab}, 0, // Y-coordinate
230, 1, // Width
${height}, 0, // Height
12, // Data Font Size
14, // Label Font Size
90,0, // Data Width
90,0, // Label Width
${height},0, // Row Height
${b}, // Number of Rows
6, // Number of Columns
0, // AutoLabels
'\0', // Label Configuration
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
4, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
90, 0, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
90,0, // Data Width
90,0, // Label Width
${height},0, // Row Height
${b}, // Number of Rows
1, // Number of Columns
0,
<#list 0..b-1 as i> 
'0',':','${i}',':',<#list 0..mtouch.button.items[i].name?length-1 as j> '${mtouch.button.items[i].name[j]}',<#if mtouch.button.items[i].name[j] == '_' > '_',</#if> </#list>';',</#list> '\0', // Label Configuration:- No line feed, '_' has to be duplicated
4,
0, 255, 255, 118, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

<#list 0..b-1 as i> 
{
0, // Dashboard ID
${30+i}, // Element ID
DB_TYPE_SIGNAL, // Element Type
0, // Z-Index (GUI stack order)
285, 1, // X-coordinate
${(variab + (height * i))}, 0, // Y-coordinate
90, 0, // Width
${height}, 0, // Height
110, 0, 255, 0, // Color On
110, 255, 0, 0, // Color Off
};

</#list>

{
0, // Dashboard ID
5, // Element ID
DB_TYPE_GRAPH, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${((3*height) + (b*height)) }, 0, // Y-coordinate
120, 2, // Width
250, 0, // Height
255, 255, 255, // Title color
0, 0, 0, // Background color
20, 20, 20, // Graph background color
'B','u','t','t','o','n',' ','G','r','a','p','h','\0',
${b * 2},
0,0,0,0, // X Minimum
0,0,32,65, // X Maximum
0,0,0,0, // Y Minimum
0,0,32,65, // Y Maximum
5,
1,
};
<#assign variab = (variab + (x*height) + gap + 300 + (x * (75/5)))>
</#if>
<#if mtouch.prox.enabled??>
{
0, // Dashboard ID
6, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
118, 2, // Width
${height}, 0, // Height
12, // Font Size
3,
1, // Horizontal Alignment
1, // Vertical Alignment
136, 0, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
'P','r','o','x','i','m','i','t','y',' ','D','a','t','a','\0',
};
<#assign variab = (variab + height)>
{
0, // Dashboard ID
7, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
55, 2, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
90,0, // Data Width
90,0, // Label Width
${height},0, // Row Height
1, // Number of Rows
7, // Number of Columns
0,
'0', ':', '0', ':', 'N', 'a', 'm', 'e', ';', '1', ':', '0', ':', 'R', 'e', 'a', 'd', 'i', 'n', 'g', ';', '2', ':', '0', ':', 'B', 'a', 's', 'e', 'l', 'i', 'n', 'e', ';', '3', ':', '0', ':', 'D', 'e', 'v', 'i', 'a', 't', 'i', 'o', 'n', ';', '4', ':', '0', ':', 'S', 'c', 'a', 'l', 'i', 'n', 'g', ';', '5', ':', '0', ':', 'T', 'h', 'r', 'e', 's', 'h', 'o', 'l', 'd', ';', '6', ':', '0', ':', 'S', 't', 'a', 't', 'e', '\0', // Label Configuration
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};
<#assign variab = (variab + height)>
{
0, // Dashboard ID
8, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
90, 0, // X-coordinate
${variab}, 0, // Y-coordinate
230, 1, // Width
${height}, 0, // Height
12, // Data Font Size
14, // Label Font Size
90,0, // Data Width
90,0, // Label Width
${height},0, // Row Height
${p}, // Number of Rows
6, // Number of Columns
0, // AutoLabels
'\0', // Label Configuration
0,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
9, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab}, 0, // Y-coordinate
90, 0, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
90,0, // Data Width
90,0, // Label Width
${height},0, // Row Height
${p}, // Number of Rows
1, // Number of Columns
0,
<#list 0..p-1 as i> 
'0',':','${i}',':',<#list 0..mtouch.prox.items[i].name?length-1 as j>'${mtouch.prox.items[i].name[j]}',<#if mtouch.prox.items[i].name[j] == '_' > '_',</#if></#list>';',</#list>'\0', // Label Configuration:- No line feed, '_' has to be duplicated
4,
0, 255, 255, 118, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

<#list 0..p-1 as i> 
{
0, // Dashboard ID
${30+b+i}, // Element ID
DB_TYPE_SIGNAL, // Element Type
0, // Z-Index (GUI stack order)
285, 1, // X-coordinate
${(variab + (height * i))}, 0, // Y-coordinate
90, 0, // Width
${height}, 0, // Height
110, 0, 255, 0, // Color On
110, 255, 0, 0, // Color Off
};
</#list>
{
0, // Dashboard ID
10, // Element ID
DB_TYPE_GRAPH, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${variab + (height * p)}, 0, // Y-coordinate
120, 2, // Width
250, 0, // Height
255, 255, 255, // Title color
0, 0, 0, // Background color
20, 20, 20, // Graph background color
'P','r','o','x','i','m','i','t','y',' ','G','r','a','p','h','\0',
${p * 2},
0,0,0,0, // X Minimum
0,0,32,65, // X Maximum
0,0,0,0, // Y Minimum
0,0,32,65, // Y Maximum
5,
1,
};
</#if>
<#else>
{
0, // Dashboard ID
11, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
30, 0, // Y-coordinate
190, 1, // Width
${height}, 0, // Height
14, // Font Size
3,
1, // Horizontal Alignment
1, // Vertical Alignment
126, 0, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
'S','e','n','s','o','r',' ','D','a','t','a','\0',
};
{
0, // Dashboard ID
12, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
222, 0, // X-coordinate
90, 0, // Y-coordinate
225, 0, // Width
114, 0, // Height
12, // Data Font Size
12, // Label Font Size
225,0, // Data Width
225,0, // Label Width
${height},0, // Row Height
${x}, // Number of Rows
1, // Number of Columns
0, // AutoLabels
'\0', // Label Configuration
0,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
13, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
90, 0, // Y-coordinate
224, 0, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
224,0, // Data Width
224,0, // Label Width
${height},0, // Row Height
${x}, // Number of Rows
1, // Number of Columns
0,
<#list 0..x-1 as i> 
'0',':','${i}',':',<#list 0..mtouch.sensor.items[i].name?length-1 as j> '${mtouch.sensor.items[i].name[j]}',<#if mtouch.sensor.items[i].name[j] == '_' > '_',</#if></#list>';',</#list> '\0', // Label Configuration:- No line feed, '_' has to be duplicated
4,
0, 255, 255, 118, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};
{
0, // Dashboard ID
14, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
60, 0, // Y-coordinate
192, 1, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
224,0, // Data Width
224,0, // Label Width
${height},0, // Row Height
1, // Number of Rows
2, // Number of Columns
0,
'0', ':', '0', ':', 'S', 'e', 'n', 's', 'o', 'r', ' ', 'N', 'a', 'm', 'e', ';', '1', ':', '0', ':', 'R', 'a', 'w', ' ', 'D', 'a', 't', 'a', '\0', // Label Configuration
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
15, // Element ID
DB_TYPE_GRAPH, // Element Type
0, // Z-Index (GUI stack order)
0, 0, // X-coordinate
${90 + ( height * z )}, 0, // Y-coordinate
93, 2, // Width
55, 1, // Height
255, 255, 255, // Title color
0, 0, 0, // Background color
20, 20, 20, // Graph background color
'S','e','n','s','o','r',' ','G','r','a','p','h','\0',
${x},
0,0,0,0, // X Minimum
0,0,32,65, // X Maximum
0,0,0,0, // Y Minimum
0,0,32,65, // Y Maximum
5,
1,
};

</#if>

<#if mtouch.dataStreamer.HCVD =="true">
{
0, // Dashboard ID
16, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
30, 0, // Y-coordinate
345, 1, // Width
${height}, 0, // Height
14, // Font Size
3,
1, // Horizontal Alignment
1, // Vertical Alignment
126, 0, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
'H','C','V','D',' ','D','a','t','a','\0',
};

{
0, // Dashboard ID
17, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
350, 2, // X-coordinate
90, 0, // Y-coordinate
34, 1, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
200,0, // Data Width
200,0, // Label Width
${height},0, // Row Height
${x}, // Number of Rows
2, // Number of Columns
0, // AutoLabels
'\0', // Label Configuration
0,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
18, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
90, 0, // Y-coordinate
150, 0, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
200,0, // Data Width
200,0, // Label Width
${height},0, // Row Height
${x}, // Number of Rows
1, // Number of Columns
0,
<#list 0..x-1 as i> 
'0',':','${i}',':',<#list 0..mtouch.sensor.items[i].name?length-1 as j>'${mtouch.sensor.items[i].name[j]}',<#if mtouch.sensor.items[i].name[j] == '_' > '_',</#if></#list>';',</#list> '\0', // Label Configuration:- No line feed, '_' has to be duplicated
4,
0, 255, 255, 118, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};
{
0, // Dashboard ID
19, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
60, 0, // Y-coordinate
200, 1, // Width
${height}, 0, // Height
12, // Data Font Size
12, // Label Font Size
200,0, // Data Width
200,0, // Label Width
${height},0, // Row Height
1, // Number of Rows
3, // Number of Columns
0,
'0', ':', '0', ':', 'S', 'e', 'n', 's', 'o', 'r', ' ', 'N', 'a', 'm', 'e', ';', '1', ':', '0', ':', 'A', 'd', 'd', 'i', 't', 'i', 'o', 'n', 'a', 'l', ' ','S','a','m','p','l','e',' ', 'C', 'a', 'p', '[','p', 'F', ']',';', '2', ':', '0', ':', 'A', 'c', 'q', '.', ' ', 'T', 'i', 'm', 'e','[','I','n','s','t','.',' ','C', 'y','c','l','e',']','\0', // Label Configuration
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};
</#if>

<#if mtouch.slider.enabled??>
{
0, // Dashboard ID
20, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
${120 + ( height * x )}, 0, // Y-coordinate
650, 0, // Width
${height}, 0, // Height
14, // Font Size
3,
1, // Horizontal Alignment
1, // Vertical Alignment
126, 0, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
'S','l','i','d','e','r',' ','D','a','t','a','\0', // Text
};

{
0, // Dashboard ID
21, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
${150 + ( height * x )}, 0, // Y-coordinate
125, 0, // Width
${height}, 0, // Height
12, // Data Font Size
14, // Label Font Size
150,0, // Data Column Width
150,0, // Label Column Width
${height},0, // Row Height
1, // Number of Rows
1, // Number of Columns
0, // AutoLabels
'0',':','0',':','N','a','m','e',';','\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
22, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
${180 + ( height * x )}, 0, // Y-coordinate
250, 0, // Width
${height*8}, 0, // Height
12, // Data Font Size
14, // Label Font Size
150,0, // Data Column Width
150,0, // Label Column Width
${height},0, // Row Height
${y}, // Number of Rows
1, // Number of Columns
0, // AutoLabels
<#list 0..y-1 as i> 
'0',':','${i}', ':',<#list 0..mtouch.slider.items[i].name?length-1 as j>'${mtouch.slider.items[i].name[j]}',<#if mtouch.slider.items[i].name[j] == '_' > '_',</#if></#list>';',</#list> '\0', // Label Configuration:- No line feed, '_' has to be duplicated
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};


{
0, // Dashboard ID
23, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
300, 2, // X-coordinate
${150 + ( height * x )}, 0, // Y-coordinate
500, 0, // Width
${height}, 0, // Height
12, // Data Font Size
14, // Label Font Size
125,0, // Data Column Width
125,0, // Label Column Width
${height},0, // Row Height
1, // Number of Rows
4, // Number of Columns
0, // AutoLabels
'0',':','0',':','S','t','a','t','e',';','1',':','0',':',','C','o','n','t','a','c','t',' ','S','i','z','e',';','2',':','0',':','S','W',' ','T','h','r','e','s','h','o','l','d',';','3',':','0',':','P','o','s','i','t','i','o','n',';','\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
24, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
300, 2, // X-coordinate
${180 + ( height * x )}, 0, // Y-coordinate
700, 0, // Width
${height*2}, 0, // Height
12, // Data Font Size
14, // Label Font Size
125,0, // Data Column Width
125,0, // Label Column Width
${height},0, // Row Height
${y}, // Number of Rows
4, // Number of Columns
0, // AutoLabels
'\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

<#list 0..y-1 as i>
{
0, // Dashboard ID
${30+b+p+i}, // Element ID
DB_TYPE_SIGNAL, // Element Type
0, // Z-Index (GUI stack order)
300, 2, // X-coordinate
${180+(x*height)+(i*height)}, 0, // Y-coordinate
125, 0, // Width
${height}, 0, // Height
128, 0, 255, 0, // Color On
128, 255, 0, 0, // Color Off
};
</#list>
</#if>

<#if mtouch.surface.enabled??>

{
0, // Dashboard ID
25, // Element ID
DB_TYPE_LABEL, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
${210+( height * x )+( height * y )}, 0, // Y-coordinate
400, 0, // Width
${height}, 0, // Height
14, // Font Size
3,
1, // Horizontal Alignment
1, // Vertical Alignment
126, 0, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
'S','u','r','f','a','c','e',' ','D','a','t','a','\0', // Text
};

{
0, // Dashboard ID
26, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
${240+(height * x)+(height * y)}, 0, // Y-coordinate
125, 0, // Width
${height}, 0, // Height
12, // Data Font Size
14, // Label Font Size
150,0, // Data Column Width
150,0, // Label Column Width
30,0, // Row Height
1, // Number of Rows
1, // Number of Columns
0, // AutoLabels
'0',':','0',':','C','o','n','t','a','c','t',';','\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};
	
{
0, // Dashboard ID
27, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
150, 2, // X-coordinate
${270+(height * x)+(height * y)}, 0, // Y-coordinate
250, 0, // Width
${height*8}, 0, // Height
12, // Data Font Size
14, // Label Font Size
150,0, // Data Column Width
150,0, // Label Column Width
30,0, // Row Height
${contacts}, // Number of Rows
1, // Number of Columns
0, // AutoLabels
'0',':','0',':','C','o','n','t','a','c','t',' ','0',';',<#if contacts == 2>'0',':','1',':','C','o','n','t','a','c','t',' ','1',';',</#if>'\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
28, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
300, 2, // X-coordinate
${240+(height * x)+(height * y)}, 0, // Y-coordinate
500, 0, // Width
${height}, 0, // Height
12, // Data Font Size
14, // Label Font Size
125,0, // Data Column Width
125,0, // Label Column Width
30,0, // Row Height
1, // Number of Rows
2, // Number of Columns
0, // AutoLabels
'0',':','0',':','H','o','r','i','z',' ','P','o','s,';','1',':','0',':','V','e','r','t',' ','P','o','s',';','\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

{
0, // Dashboard ID
29, // Element ID
DB_TYPE_TABLE, // Element Type
0, // Z-Index (GUI stack order)
300, 2, // X-coordinate
${270+(height * x)+(height * y)}, 0, // Y-coordinate
700, 0, // Width
${height*2}, 0, // Height
12, // Data Font Size
14, // Label Font Size
125,0, // Data Column Width
125,0, // Label Column Width
30,0, // Row Height
${contacts}, // Number of Rows
2, // Number of Columns
0, // AutoLabels
'\0', // Text
4,
0, 255, 255, 255, // Background Color
255, 0, 0, 0, // Foreground Color
1, // Label Horizontal Alignment
1, // Data Horizontal Alignment
};

</#if>
