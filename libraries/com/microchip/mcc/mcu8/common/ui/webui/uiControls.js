/*
 *  @license:
 *  © 2018 Microchip Technology Inc. and its subsidiaries.  
 *
 *  You may use this software and any derivatives exclusively with Microchip products. 
 *
 *  THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER EXPRESS, 
 *  IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED WARRANTIES OF 
 *  NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE, OR ITS 
 *  INTERACTION WITH MICROCHIP PRODUCTS, COMBINATION WITH ANY OTHER PRODUCTS, OR USE 
 *  IN ANY APPLICATION. 
 *
 *  IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, INCIDENTAL 
 *  OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND WHATSOEVER RELATED TO 
 *  THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY 
 *  OR THE DAMAGES ARE FORESEEABLE.  TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S 
 *  TOTAL LIABILITY ON ALL CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED 
 *  THE AMOUNT OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 *
 *  MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF THESE TERMS.
 * 
 *  @author: I17643
 */

var jsmodule = (function () {
    var bridge;
    var lib;
    var tableJsonData;

    function handleCheck(elementInst) {
        if (bridge) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst['checked']
            });
        }
    }

    function handleCombobox(elementInst) {
        if (bridge) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'text': elementInst.options[elementInst.selectedIndex].text,
                'value': elementInst.options[elementInst.selectedIndex].value
            });
        }
    }
    function handleTable(elementInst) {
        if (bridge) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'text': elementInst.textContent,
                'value': elementInst.value
            });
        }
    }

    function handleTableJsonData(elementInst) {
        var isValid = true;
        var array = elementInst['id'].split("-");
        var elementType = array[2];
        if (elementType === 'Checkbox') {
            if (elementInst['value'] === 'true') {
                elementInst['value'] = 'false';
            } else {
                elementInst['value'] = 'true';
            }
        } else if(elementType === "TimeField"){
            var pattern = /^(\d+(|[.]\d+))(\s|)(s|ms|us|ns)($)/;
            var validator = new RegExp(pattern, "ig");
            var value = elementInst.value;
            isValid = validator.test(value);
            if (isValid) {
                elementInst.classList.remove("errormatch");
            } else {
                elementInst.classList.add("errormatch");
            }  
        } else if(elementType === "FrequencyField"){
            var pattern = /^(\d+(|[.]\d+))(\s|)(hz|khz|mhz)($)/;
            var validator = new RegExp(pattern, "ig");
            var value = elementInst.value;
            isValid = validator.test(value);
            if (isValid) {
                elementInst.classList.remove("errormatch");
            } else {
                elementInst.classList.add("errormatch");
            }
        } else if(elementType === "PercentageField"){
            var pattern = /(\d+(|[.]\d+))($)/;
            var validator = new RegExp(pattern, "ig");
            var value = elementInst.value;
            isValid = validator.test(value);
            if (isValid && value <= 100) {
                elementInst.classList.remove("errormatch");
            } else {
                elementInst.classList.add("errormatch");
            }
        }
        var rowData;
        var jsonData = tableJsonData['dataArray'];
        jsonData.forEach(function (eachRowObj) {
            for (var key in eachRowObj) {
                if (key === array[1]) {
                    var eachColumnType = eachRowObj[key];
                    for (var eachColumnID in eachColumnType) {
                        if (eachColumnType[eachColumnID] === array[4]) {
                            eachColumnType['data'][array[3]] = elementInst.value;
                            rowData =eachRowObj;
                        }
                    }
                }
            }
        });
        tableJsonData['UpdatedControl'] = array[4]+"/"+elementInst['value']; 
        tableJsonData['UpdatedRowData'] =rowData;
        var jsonDataToJava = JSON.stringify(tableJsonData);
        if (bridge && isValid) {
            bridge.sendMessage({
                'key': tableJsonData['key'],
                'value': jsonDataToJava
            });
        }
    }

    function handleTextBox(elementInst) {
        //var pattern = "^\\d+$";
        var pattern = (undefined == elementInst['validator']) ? ".*" : elementInst['validator'];
        var validator = new RegExp(pattern, "g");
        var value = elementInst.value;
        var isValid = validator.test(value);
        if (isValid) {
            elementInst.classList.remove("errormatch");
        } else {
            elementInst.classList.add("errormatch");
        }

        if (bridge && isValid) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst.value
            });
        }
    }
    function handleTimeField(elementInst) {
        //var pattern = "^\\d+$";
        var pattern = /^(\d+(|[.]\d+))(\s|)(s|ms|us|ns)($)/;
        var validator = new RegExp(pattern, "ig");
        var value = elementInst.value;
        var isValid = validator.test(value);
        if (isValid) {
            elementInst.classList.remove("errormatch");
        } else {
            elementInst.classList.add("errormatch");
        }
        if (bridge && isValid) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst.value
            });
        }
    }
    
    function handleFreqField(elementInst) {
        //var pattern = "^\\d+$";
        var pattern = /^(\d+(|[.]\d+))(\s|)(hz|khz|mhz)($)/;
        var validator = new RegExp(pattern, "ig");
        var value = elementInst.value;
        var isValid = validator.test(value);
        if (isValid) {
            elementInst.classList.remove("errormatch");
        } else {
            elementInst.classList.add("errormatch");
        }
        if (bridge && isValid) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst.value
            });
        }
    }
    
    function handlePercentField(elementInst) {
        //var pattern = "^\\d+$";
        var pattern = /^(\d+(|[.]\d+))($)/;
        var validator = new RegExp(pattern, "ig");
        var value = elementInst.value;
        var isValid = validator.test(value);
        if (isValid && (value >= 1) && (value <= 100)) {
            elementInst.classList.remove("errormatch");
        } else {
            elementInst.classList.add("errormatch");
        }
        if (bridge && isValid) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst.value
            });
        }
    }

    function handleRange(elementInst) {
        var value = elementInst.value;
        var min = Number(elementInst['min']);
        var max = Number(elementInst['max']);

        var isValid = ((value <= max) && (value >= min));
        if(isNaN(value)){
            isValid = false;
        }
        if (isValid) {
            elementInst.classList.remove("errormatch");
        } else {
            elementInst.classList.add("errormatch");
        }

        if (bridge && isValid) {
            bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst.value
            });
        }
    }

    function handleLink(elementInst) {
        if (bridge) {
            if (elementInst.getAttribute('href') !== null) {
                 bridge.sendMessage({
                'key': elementInst['id'],
                'value': elementInst['id']
            });
            }
        }
    }

    function registerEvents() {

        // collapse expand behaviour of titlebar
        var tbArray = lib.getInstByClass('divTableBar');
        for (var tbi = 0; tbi < tbArray.length; tbi++) {
            tbArray[tbi].addEventListener('click', function (e) {
                e = e || window.event;
                e = e.target || e.srcElement;
                // hide panel body
                var paneBodyId = e.id + "Body"
                lib.toogleTable(paneBodyId);
                // change icon 
                var iconId = e.id + "Icon"
                var iconInst = lib.getInstById(iconId)
                if (lib.isVisible(paneBodyId)) {
                    iconInst.classList.remove("collapsed");
                    iconInst.classList.add("expanded");
                } else {
                    iconInst.classList.add("collapsed");
                    iconInst.classList.remove("expanded");
                }

            });
        }
    }

    function init() {
        if(undefined != bridge){
            bridge.onJSReady();
        }
		collapseRelevantNodesOnInit();
    }

    function setLibrary(library) {
        lib = library;
        registerEvents();
    }

    function setBridge(bdg) {
        bridge = bdg;
        bridge.regListener(function (jsonData) {
            //document.body.innerHTML = "json data from java " + JSON.stringify(jsonData);
            switch (jsonData['type']) {
                case 'combobox':
                    lib.populateSelect(jsonData['key'], jsonData['dataMap'], jsonData['value']);
                    break;
                case 'checkbox':
                    lib.updateCheckbox(jsonData['key'], jsonData['value']);
                    break;
                case 'range':
                    lib.updateRange(jsonData['key'], jsonData['value'], jsonData['min'], jsonData['max']);
                    break;
                case 'timeField':
                case 'freqField':
                case 'percentField':
                    lib.updateTextboxWithoutValidator(jsonData['key'], jsonData['value']);
                    break;
                case 'textbox':
                    lib.updateTextBox(jsonData['key'], jsonData['value'], jsonData['validator']);
                    break;
                case 'tableDynamicControls':
                    tableJsonData = jsonData;
                    lib.updateTableControl(jsonData['dataArray'], jsonData['key']);
                    break;
                case 'table':
                    lib.updateTableData(jsonData['dataArray'], jsonData['key']);
                    break;
                case 'showc':
                    var control = lib.getInstById(jsonData['key']);
                    if (undefined != control) {
                        lib.showHideDisplay(control.parentNode.parentNode,true);
                    }
                    break;
                case 'hidec':
                    var control = lib.getInstById(jsonData['key']);
                    if(undefined != control){
                        lib.showHideDisplay(control.parentNode.parentNode,false);
                    }
                    break;
                // The two cases below allow addition of hover help on labels
                case 'add-label-hover':
                    lib.addLabelHoverHelp(jsonData['key'], jsonData['helpText']);
                    break;
                case 'change-label-hover-text':
                    lib.changeLabelHoverHelpText(jsonData['key'], jsonData['helpText']);
                    break;
                // The case below is specifically added to handle customized UI's. For e.g. EVSYS, CCL
                case 'custom':
                    switch (jsonData['module']) {
                        case 'Event System':
                            generateEventUsersTextRow(jsonData['eventUsers']);
                            generateChannelInformation(jsonData['channels']);
                            break;
                        case 'Event System-Combo Box':
                            document.getElementById(jsonData['key']).value = jsonData['value']; 
                            break;
                        case 'Event System-Check Box':
                            if(jsonData['value'] === 'true') {  
                                uncheckCheckedBoxOfClass(jsonData['key'].split("-")[0]);
                               
                                var elementChecked = document.getElementById(jsonData['key']);                               
                                elementChecked.checked = true;  
                                
                                toggleCheckBoxes(elementChecked);
                            } else {
                                uncheckCheckedBoxOfClass(jsonData['key']);                                
                            }
                            break;
                        default:
                    }
                    break;
                case 'enable':
                        lib.disableDisplay(jsonData['key'],false);
                    break;
                case 'disable':
                        lib.disableDisplay(jsonData['key'],true);
                    break;
                case 'collapse':
                    lib.collapseExpandControl(jsonData['key'],true);
                break;
                case 'expand':
                    lib.collapseExpandControl(jsonData['key'],false);
                break;
                case 'image':
                    lib.displayImage(jsonData['key'],jsonData['value']);
                break;
            }
        });
    }
	
	function collapseRelevantNodesOnInit()
	{
		// By default collapse all the titlepanes has defaultcollapse attribute as yes
        var tbArray = lib.getInstByClass('divTable');
        for (var tbi = 0; tbi < tbArray.length; tbi++) 
		{
			var childrenArray = tbArray[tbi].children;	//getting the divTableBar and divtablebarbody as children
			
			if(childrenArray !== undefined)
			{
				var toCollapse = "";
				toCollapse = tbArray[tbi].getAttribute("data-collapse");
				
				if(toCollapse !== undefined)
				{
					if(toCollapse === "true")
					{
						lib.showHideDisplay(childrenArray[1],false);	//hiding the divtablebarbody for respective node.
					}
					else
					{
						//no need to do anything here.
					}
				}
			}	
        }
	}

    return {
        init: init,
        setBridge: setBridge,
        setLibrary: setLibrary,
        handleCheck: handleCheck,
        handleCombobox: handleCombobox,
        handleTextBox: handleTextBox,
        handleRange: handleRange,
        handleTimeField: handleTimeField,
        handleFreqField: handleFreqField,
        handlePercentField: handlePercentField,
        handleTable: handleTable,
	handleTableJsonData: handleTableJsonData,
	collapseRelevantNodesOnInit: collapseRelevantNodesOnInit,
        handleLink: handleLink
 
    };
})();