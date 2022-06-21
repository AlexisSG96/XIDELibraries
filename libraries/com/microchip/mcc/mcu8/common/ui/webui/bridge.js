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

var bridge = (function () {
    var callback;

    function sendMessage(data) { // js -> java/browser
        var isBrowser = true;
        try {
            javaCallback.onKeyChange( JSON.stringify(data));
            isBrowser = false;
        } catch (ex) { };

        if (isBrowser) {
            try {
                console.log('data: ' + JSON.stringify(data));
            } catch (ex) { };
        }
    }

    function onReceive(data) { // java -> js
        if (callback) {
            callback(data);
        }
    }

    function regListener(argCallback) {
        callback = argCallback;
    }
    
    function onJSReady(){
        try {
            javaCallback.onJSReady();
        } catch (ex) { };
    }

    return {
        regListener: regListener,
        sendMessage: sendMessage,
        onReceive: onReceive,
        onJSReady: onJSReady
    };
})();