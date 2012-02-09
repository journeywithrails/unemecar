/*
Function: Set default values of input elements. Get the default value from associated label having class="default-value"
Author:   Lasse Bunk (lassebunk@gmail.com - http://lassebunk.dk)
Demo:     http://lassebunk.dk/demos/default-values/
Version:  1.0
License:  Use as you wish :-)
*/
Event.observe(window,"load", function(event) {
	$$("label.default-value").each(function(label) {
		/* Change this to your default class name */
		var defaultClass = "default";

		/* Get the default value */
		var defaultValue = label.innerHTML;

		/* Get the associated input */
		var input = $(label.htmlFor);

		/* Get the form */
		var form = input.up('form');

		/* Store information about the input being a password so we can use this later */
		var isPassword = (input.type && input.type == "password");

		if (isPassword) {
			default_password = new Element('input',{'type':'text','class':defaultClass,'value':defaultValue}).hide();
			if (input.readAttribute('tabindex'))
				default_password.writeAttribute('tabindex',input.readAttribute('tabindex'));
			input.insert({after:default_password});
			default_password.observe("focus", function(event) {
				default_password.hide();
				input.show().focus();
			});
		}

		/* When input gets focus, set value to "" if value is default value */
		input.observe("focus", function(event) {
			if (input.value == defaultValue) {
				if (!isPassword) {
					input.value = "";
					input.removeClassName(defaultClass);
				} else {
					default_password.hide();
					input.show();
				}
			}
		});

		/* When input loses focus, set value to default value if value = "" */
		input.observe("blur", function(event) {
			if (input.value == "") {
				if (!isPassword) {
					input.value = defaultValue;
					input.addClassName(defaultClass);
				} else {
					input.hide();
					default_password.show();
				}
			}
		});

		/* Set default values to "" when form is submitted */
		if (form) {
			form.observe("submit", function(event) {
				if (input.value == defaultValue) {
					input.value = "";
				}
			});
		}

		/* Set default value when page loads */
		if (input.value == "" || input.value == defaultValue) {
			if (!isPassword) {
				input.value = defaultValue;
				input.addClassName(defaultClass);
			} else {
				input.hide();
				default_password.show();
			}
		}

		/* Hide the label using javascript so css-but-no-javascript browsers will see the label */
		label.hide();
	});
});
