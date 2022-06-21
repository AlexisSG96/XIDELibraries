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

var library = (function () {

    /*var elementInst = {
     'id': '',
     'class': '',
     'innerHTML': ''
     }*/

    function createDivElement(parentInst, elementInst) {
        var divInst = document.createElement('div');
        (elementInst['id']) ? (divInst.id = elementInst['id']) : undefined;
        (elementInst['class']) ? (divInst.className = elementInst['class']) : undefined;
        (elementInst['innerHTML']) ? (divInst.innerHTML = elementInst['innerHTML']) : undefined;

        if (parentInst) {
            parentInst.appendChild(divInst);
        }

        return divInst;
    }

    function getInstByClass(className) {
        return document.getElementsByClassName(className);
    }

    function getInstById(id) {
        if (document.getElementById) {
            return document.getElementById(id);
        } else if (document.all) {
            return window.document.all[id];
        } else if (document.layers) {
            return window.document.layers[id];
        } else {
            return undefined;
        }
    }

    function toogleTable(id) {
        var inst = getInstById(id);
        if (undefined !== inst) {
            if (inst.style.display === "none") {
                inst.style.display = "table-row-group";
            } else {
                inst.style.display = "none";
            }
        }
    }

    function showHideDisplay(node, show) {
        if (undefined !== node) {
            if (show) {
                node.style.display = "table-row";
            } else {
                node.style.display = "none";
            }
        }
    }

    function disableDisplay(id, disable) {
        var inst = getInstById(id);
        var parentInstance;
        if (undefined !== inst) {
            inst.disabled = disable;
            parentInstance = inst.parentNode;
            if (undefined !== parentInstance && parentInstance.className === "divTableCell")
            {
                if (disable) {
                    parentInstance.style.opacity = "0.5";
                } else {
                    parentInstance.style.opacity = "1";
                }
            } else if (undefined !== inst && inst.className === "divTable") {
                if (disable) {
                    // disable div
                    inst.style.opacity = "0.5"; //makes the control grey
                    inst.style['pointer-events'] = "none";  //makes the control non clickable
                } else {
                    // renable div
                    inst.style.opacity = "1";
                    inst.style['pointer-events'] = "";
                }
            }
        }
    }

    function collapseExpandControl(controlId, toCollapse)
    {
        var inst = getInstById(controlId);
        if (undefined !== inst)
        {
            if (toCollapse)
            {
                showHideDisplay(inst.children[1], false);
                inst.children[0].children[0].classList.remove("expanded");
                inst.children[0].children[0].classList.add("collapsed");
            } else
            {
                showHideDisplay(inst.children[1], true);
                inst.children[0].children[0].classList.remove("collapsed");
                inst.children[0].children[0].classList.add("expanded");
            }
        }
    }
    function isVisible(id) {
        var inst = getInstById(id);
        if (undefined != inst) {
            if ("none" === inst.style.display) {
                return false;
            } else {
                return true;
            }
        }
    }

    function populateSelect(nodeId, arrOfOpt, defaultOpt) {
        // remove all options
        var combobox = getInstById(nodeId);
        if (combobox) {
            while (combobox.options.length > 0) {
                combobox.remove(0);
            }

            // add options
            arrOfOpt.forEach(function (eachOpt) {
                var opt = document.createElement("option");
                opt.value = eachOpt.value;
                opt.innerHTML = eachOpt.text;
                if (defaultOpt == opt.value) {
                    opt.selected = 'selected';
                }
                combobox.appendChild(opt);
            });
        }
    }

    function updateCheckbox(nodeId, defaultOpt) {
        var checkbox = getInstById(nodeId);
        if ('true' === defaultOpt) {
            checkbox.checked = 'checked';
        } else {
            checkbox.checked = null;
        }
    }

    function updateRange(nodeId, value, min, max) {
        var textBox = getInstById(nodeId);
        if (textBox.value !== value) {
            textBox.value = value;
        }
        textBox['min'] = min;
        textBox['max'] = max;
        var minText = getInstById(nodeId + '_MIN');
        minText.textContent = min;
        var maxText = getInstById(nodeId + '_MAX');
        maxText.textContent = max;
    }

    function updateTextboxWithoutValidator(nodeId, value) {
        var textBox = getInstById(nodeId);
        if (textBox.value !== value) {
            textBox.value = value;
        }
    }

    function updateTextBox(nodeId, value, validator) {
        var textBox = getInstById(nodeId);
        if (textBox.value !== value) {
            textBox.value = value;
        }
        textBox['validator'] = validator;
    }
    function updateTableData(jsonRowArray, key) {
        removeChildofId(key, 1);
        var tableList = document.getElementsByClassName("div-table");
        for (var i = 0; i < tableList.length; i++)
        {
            if (tableList[i].id === key)
            {
                jsonRowArray.forEach(function (eachRowObj) {
                    var trDiv = document.createElement('div');
                    trDiv.className = "tr";

                    for (var key in eachRowObj) {
                        var tcDiv = document.createElement('div');
                        tcDiv.className = "table-rowData";
                        tcDiv.innerHTML = eachRowObj[key];
                        trDiv.appendChild(tcDiv);
                    }
                    var rootDiv = tableList[i];
                    rootDiv.appendChild(trDiv);
                });
                break;
            }
        }
    }

    function  validateAndCorrectTableData(jsonRowArray) {
        jsonRowArray.forEach(function (eachRowObj) {
            for (var eachRawData in eachRowObj) {
                if (undefined === eachRowObj[eachRawData]['data']['isDisable']) {
                    eachRowObj[eachRawData]['data']['isDisable'] = false;
                } else {
                    if (eachRowObj[eachRawData]['data']['isDisable'] === "true") {
                        eachRowObj[eachRawData]['data']['isDisable'] = true;
                    } else {
                        eachRowObj[eachRawData]['data']['isDisable'] = false;
                    }
                }
            }

        });
        return jsonRowArray;
    }

    function  updateTableControl(jsonRowArray, key) {
        jsonRowArray = validateAndCorrectTableData(jsonRowArray);
        if (getInstById(key) !== null) {
            createTableControl(jsonRowArray, key);
        } else {
            updateTableControlData(jsonRowArray, key);
        }
    }

    function  updateTableControlData(jsonRowArray, key) {
        var tableList = document.getElementsByClassName("div-table");
        for (var i = 0; i < tableList.length; i++)
        {
            if (tableList[i].id === key)
            {
                jsonRowArray.forEach(function (eachRowObj) {
                    for (var parameter in eachRowObj) {
                        getTableControlTypeAndUpdateValue(tableList[i], eachRowObj[parameter], parameter);
                    }
                });
                break;
            }
        }
    }

    function  getTableControlTypeAndUpdateValue(rootDiv, jsonRowArray, parameter) {
        var tableRow = rootDiv.getElementsByClassName("tc tableCell");
        var i;
        for (i = 0; i < tableRow.length; i++) {
            var column = tableRow[i].id;
            if (parameter.replace(/\s/g, "") === column.replace(/\s/g, "")) {
                var tcDiv = document.createElement('div');
                tcDiv.className = "table-rowData";
                var dataControlValue = tableRow[i].getAttribute('data-control');
                var htmlElement = getInstById("tableView-" + dataControlValue + "-value-" + jsonRowArray['id']);
                var htmlElementType = dataControlValue.split("-")[1];
                if (htmlElement !== null) {
                    switch (htmlElementType) {
                        case 'Combobox':
                            break;
                        case 'Checkbox':
                            var isCheckBox = jsonRowArray['data']['value'];
                            if (isCheckBox === 'true') {
                                htmlElement.checked = true;
                            } else {
                                htmlElement.checked = false;
                            }
                            break;
                        case 'RangeBox':
                            break;
                        case 'Textbox':
                        case 'TimeField':
                        case 'FrequencyField':
                        case 'PercentageField':
                        case 'TextboxRo':
                            htmlElement.value = jsonRowArray['data']['value'];
                            htmlElement.text = jsonRowArray['data']['text'];
                            break;
                        default :
                            htmlElement.text = jsonRowArray['data']['text'];
                            break;
                    }
                }
            }
        }
    }

    function createTableControl(jsonRowArray, key) {
        removeChildofId(key, 1);
        var rowNumber = 0;
        jsonRowArray.forEach(function (eachRowObj) {
            var trDiv = document.createElement('div');
            trDiv.className = "tr";
            trDiv.addEventListener("mouseover", function () {
                this.style.backgroundColor = "#A9A9A9";
            });
            trDiv.addEventListener("mouseout", function () {
                this.style.backgroundColor = "#ffffff";
            });
            trDiv.addEventListener("focusout", function () {
                this.style.backgroundColor = "#ffffff";
            });
            for (var parameter in eachRowObj) {
                var tableRow = findControlType(trDiv, eachRowObj[parameter], parameter, rowNumber, key);
            }
            rowNumber++;
            var tablesList = document.getElementsByClassName("div-table");
            for (var j = 0; j < tablesList.length; j++) {
                if (tablesList[j].id === key) {
                    var rootDiv = tablesList[j];
                    rootDiv.appendChild(tableRow);
                }
            }
        });
    }

    function  findControlType(trDiv, eachRowObj, columnName, rowNumberIndex, key) {
        var tablesList = document.getElementsByClassName("div-table");
        for (var j = 0; j < tablesList.length; j++) {
            if (tablesList[j].id === key) {
                var rootDiv = tablesList[j];
                var tableRow = rootDiv.getElementsByClassName("tc tableCell");
                var i;
                for (i = 0; i < tableRow.length; i++) {
                    var column = tableRow[i].id;
                    if (columnName.replace(/\s/g, "") === column.replace(/\s/g, "")) {
                        var tcDiv = document.createElement('div');
                        tcDiv.className = "table-rowData";
                        var dataControlValue = tableRow[i].getAttribute('data-control');

                        if (tableRow[i].id === columnName) {
                            var tableControl = createTableViewControls(tcDiv, dataControlValue, eachRowObj, rowNumberIndex);
                            trDiv.appendChild(tableControl);
                            return trDiv;
                        }
                    }
                }
            }
        }
    }

    function createTableViewControls(tcDiv, dataControlValue, data, rowNumberIndex) {
        var controlType = dataControlValue.split("-")[01];
        switch (controlType) {
            case 'Combobox':
                var divTableRaw = document.createElement('div');
                divTableRaw.className = 'divTableRow';
                var labelDiv = document.createElement('div');
                labelDiv.className = 'divTableCell';
                labelDiv.innerHTML = data['data']['text'];
                var comboLabel = document.createElement('div');
                comboLabel.className = 'cellLabel';
                labelDiv.appendChild(comboLabel);
                var comboDiv = document.createElement('div');
                comboDiv.className = 'divTableCell';
                var select = document.createElement('select');
                select.className = 'cellCombobox';
                var dataList = data['data']['options'];
                var selectedValue = data['data']['value'];
                var dataListArray = dataList.split(',');
                var options_str = "";

                dataListArray.forEach(function (eachData) {
                    var isOptions = eachData.includes('#');
                    if (isOptions) {
                        isOptions = eachData.split("#");
                        options_str += '<option ' + isOptions[1] + ' value="' + isOptions[0] + '" >' + isOptions[0] + '</option>';
                    } else {
                        options_str += '<option ' + "disable" + ' value="' + eachData + '" >' + eachData + '</option>';
                    }
                });
                select.innerHTML = options_str;
                select.value = selectedValue;//select.selected;
                select.id = "tableView-" + dataControlValue + "-value-" + data['id'];

                select.setAttribute("onchange", "jsmodule.handleTableJsonData(this);");
                select.disabled = data['data']['isDisable'];
                comboDiv.appendChild(select);
                divTableRaw.appendChild(comboDiv);
                tcDiv.appendChild(divTableRaw);
//                populateSelect(select.id,dataListArray,selectedValue);
                break;
            case 'Checkbox':
                var divTableRaw = document.createElement('div');
                divTableRaw.className = 'divTableRow';
                var divTableCell = document.createElement('div');
                divTableCell.className = "divTableCell";
                var chk = document.createElement('input');
                chk.setAttribute('type', 'checkbox');
                chk.setAttribute('id', "tableView-" + dataControlValue + "-value-" + data['id']);
                chk.setAttribute("onclick", "jsmodule.handleTableJsonData(this);");
                divTableCell.appendChild(chk);

                var isCheckBox = data['data']['value'];
                if (isCheckBox === 'true') {
                    chk.checked = true;
                } else {
                    chk.checked = false;
                }
                chk.setAttribute('value', chk.checked);
                var lbl = document.createElement('label');
                lbl.setAttribute('style', 'float:left;');
                lbl.setAttribute('for', "tableView-" + dataControlValue + "-value-" + data['id']);
                var labelText = document.createElement('div');
                labelText.setAttribute('style', 'padding-top:2px;padding-left:5px;float:left;');
                labelText.innerHTML = data['data']['text'];
                divTableCell.appendChild(lbl);
                divTableCell.appendChild(labelText);
                divTableRaw.appendChild(divTableCell);
                tcDiv.appendChild(divTableRaw);
                break;
            case 'RangeBox':
                var divTableRaw = document.createElement('div');
                divTableRaw.className = 'divTableRow';
                var divTableCell = document.createElement('div');
                divTableCell.className = 'divTableCell';
                var minLabel = document.createElement('span');
                minLabel.innerHTML = data['data']['min'];
                minLabel.readOnly = "true";
                minLabel.id = "min_" + data['id'];
                divTableCell.appendChild(minLabel);
                var inputField = document.createElement('input');
                inputField.type = "text";
                inputField.value = data['data']['textValue'];
                inputField.id = "tableView-" + dataControlValue + "-textValue-" + data['id'];
                inputField.setAttribute("onkeyup", "jsmodule.handleTableJsonData(this);");
                divTableCell.appendChild(inputField);
                var maxLabel = document.createElement('span');
                maxLabel.innerHTML = data['data']['max'];
                maxLabel.readOnly = "true";
                maxLabel.id = "max_" + data['id'];
                divTableCell.appendChild(maxLabel);
                divTableRaw.appendChild(divTableCell);
                tcDiv.appendChild(divTableRaw);
                break;
            case 'Textbox':
            case 'TimeField':
            case 'FrequencyField':
            case 'PercentageField':
                var hBoxDiv = document.createElement('div');
                hBoxDiv.className = "divTableCell";
                var inputField = document.createElement('input');
                inputField.type = "text";
                inputField.name = "name";
                inputField.value = data['data']['value'];
                inputField.disabled = data['data']['isDisable'];
                inputField.id = "tableView-" + dataControlValue + "-value-" + data['id'];
                inputField.setAttribute("onblur", "jsmodule.handleTableJsonData(this);");
                hBoxDiv.appendChild(inputField);
                tcDiv.appendChild(hBoxDiv);
                break;
            case 'TextboxRo':
                var hBoxDiv = document.createElement('div');
                hBoxDiv.className = "divTableCell";
                var labelField = document.createElement('input');
                labelField.type = "text";
                labelField.name = "name";
                labelField.value = data['data']['value'];
                labelField.id = "tableView-" + dataControlValue + "-value-" + data['id'];
                labelField.setAttribute("readonly", "readonly");
                hBoxDiv.appendChild(labelField);
                tcDiv.appendChild(hBoxDiv);
                break;
            default :
                var tcDiv = document.createElement('div');
                tcDiv.innerHTML = data['data']['text'];
                tcDiv.id = dataControlValue + "-default-" + rowNumberIndex;
                return tcDiv;
                break;
        }
        return tcDiv;
    }

    function removeChildofId(parendId, afterChildIndex) {
        var parentNode = getInstById(parendId);
        if (parentNode !== null) {
            var childArray = parentNode.children;
            while (childArray.length > afterChildIndex) {
                parentNode.removeChild(childArray[afterChildIndex]);
            }
        }
    }

    // If you need to elaborate on the existence of certain UI controls, the below API's can be used
    // to add hover help on labels
    function addLabelHoverHelp(id, helpText) {
        var parentLabel = document.getElementById(id);
        if (parentLabel.className === "cellLabel") {
            var helpImage = document.createElement("img");
            helpImage.className = "label-hover";
            helpImage.src = "images/help.png";
            helpImage.style = "vertical-align: text-bottom";

            var hoverText = document.createElement("p");
            hoverText.className = "label-hover-text";
            hoverText.innerHTML = helpText;

            parentLabel.appendChild(helpImage);
            parentLabel.appendChild(hoverText);
        }
    }
    function displayImage(nodeId, defaultOpt) {
        var imageTag = getInstById(nodeId);
        if (undefined !== imageTag) {
            imageTag.src = defaultOpt;
        }
    }

    function changeLabelHoverHelpText(id, helpText) {
        var parentLabel = document.getElementById(id);
        if (parentLabel.className === "cellLabel") {
            var labelChildren = parentLabel.children;
            for (let i = 0; i < labelChildren.length; i++) {
                if (labelChildren[i].className === "label-hover-text") {
                    labelChildren[i].innerHTML = helpText;
                }
            }
        }
    }


    return {
        createDivElement: createDivElement,
        getInstByClass: getInstByClass,
        getInstById: getInstById,
        populateSelect: populateSelect,
        updateCheckbox: updateCheckbox,
        updateRange: updateRange,
        updateTextBox: updateTextBox,
        updateTextboxWithoutValidator: updateTextboxWithoutValidator,
        createTableControl: createTableControl,
        toogleTable: toogleTable,
        showHideDisplay: showHideDisplay,
        isVisible: isVisible,
        disableDisplay: disableDisplay,
        updateTableControl: updateTableControl,
        updateTableData: updateTableData,
        addLabelHoverHelp: addLabelHoverHelp,
        changeLabelHoverHelpText: changeLabelHoverHelpText,
        collapseExpandControl: collapseExpandControl,
        displayImage:displayImage,
    };
})();
