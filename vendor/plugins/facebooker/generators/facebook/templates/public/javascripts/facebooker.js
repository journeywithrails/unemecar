
function $(element) {
  if (typeof element == "string") {
    element=document.getElementById(element);
  }
  if (element)
    extend_instance(element,Element);
  return element;
}

function extend_instance(instance,hash) {
  for (var name in hash) {
    instance[name] = hash[name];
  }
}

var Element = {
  "hide": function () {
    this.setStyle("display","none")
  },
  "show": function () {
    this.setStyle("display","block")
  },
  "visible": function () {
    return (this.getStyle("display") != "none");
  },
  "toggle": function () {
    if (this.visible) {
      this.hide();
    } else {
      this.show();
    }
  }
};

function encodeURIComponent(str) {
  if (typeof(str) == "string") {
    return str.replace(/=/g,'%3D').replace(/&/g,'%26');
  }
  //checkboxes and radio buttons return objects instead of a string
  else if(typeof(str) == "object"){
    for (prop in str)
    {
      return str[prop].replace(/=/g,'%3D').replace(/&/g,'%26');
    }
  }
};

var Form = {};
Form.serialize = function(form_element) {
  return $(form_element).serialize();
};

Ajax.Updater = function (container,url,options) {
  this.container = container;
  this.url=url;
  this.ajax = new Ajax();
  this.ajax.requireLogin = 1;
  if (options["onSuccess"]) {
    this.ajax.responseType = Ajax.JSON;
    this.ajax.ondone = options["onSuccess"];
  } else {
    this.ajax.responseType = Ajax.FBML;
    this.ajax.ondone = function(data) {
      $(container).setInnerFBML(data);
    }
  }
  if (options["onFailure"]) {
    this.ajax.onerror = options["onFailure"];
  }

  // Yes, this is an excercise in undoing what we just did
  // FB doesn't provide encodeURI, but they will encode things passed as a hash
  // so we turn it into a string, esaping & and =
  // then we split it all back out here
  // this could be killed if encodeURIComponent was available
  parameters={};
  if (options['parameters']) {
    pairs=options['parameters'].split('&'); 
    for (var i=0; i<pairs.length; i++) {
      kv=pairs[i].split('=');
      key=kv[0].replace(/%3D/g,'=').replace(/%26/g,'&');
      val=kv[1].replace(/%3D/g,'=').replace(/%26/g,'&');
      parameters[key]=val;
    }
  }
  this.ajax.post(url,parameters); 
  if (options["onLoading"]) {
     options["onLoading"].call() 
  }
};
Ajax.Request = function(url,options) {
  Ajax.Updater('unused',url,options);
};

PeriodicalExecuter = function (callback, frequency) {
        setTimeout(callback, frequency *1000);
        setTimeout(function() { new PeriodicalExecuter(callback,frequency); }, frequency*1000);
};
