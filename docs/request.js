

function request(test) {
    var request = new XMLHttpRequest();
    request.open('GET', 'https://dev-gwang.github.io/os-security-patch-cookbook/roles/localhost.json', false);  // `false` makes the request synchronous
    request.send(null);

    if (request.status === 200) {
        return request.responseText;
    }
}

String.prototype.format = function() {
    var theString = this;
    
    for (var i = 0; i < arguments.length; i++) {
        var regExp = new RegExp('\\{' + i + '\\}', 'gm');
        theString = theString.replace(regExp, arguments[i]);       
    }
    
    return theString;
}

$( document ).ready(function() {
    var table_body_id = document.getElementById('table_body');
    var result = JSON.parse(request())["default_attributes"]
    
    for(var key in result){
        var personObj = result[key];
        for(var key2 in personObj){
            console.log(key + "," + key2 + ", " + personObj[key2]["type"] + ", " + personObj[key2]["value"]);  
            table_body_id.innerHTML += `
            <td class="mdl-data-table__cell--non-numeric">{0}</td>
            <td>{1}</td>
            <td >
            <div style='width:100%' class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <textarea class="mdl-textfield__input" type="text" value="{2}"  rows= "3" id="sample5" >{2}</textarea>
            </div>
            </td>`.format(key, key2, JSON.stringify(personObj[key2]["value"], null, "\t"))
        }
    }
});

