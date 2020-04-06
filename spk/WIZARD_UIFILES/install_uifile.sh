#!/bin/sh

/bin/cat > /tmp/wizard.php <<'EOF'
<?php
$ini_array = parse_ini_file("/var/packages/phpvirtualbox4dsm/target/.config");

# page1 
$wizard_no_auth=$ini_array["wizard_no_auth"];
$wizard_enable_advanced_config=$ini_array["wizard_enable_advanced_config"];
$wizard_start_stop_config=$ini_array["wizard_start_stop_config"];
$wizard_enable_custom_icons=$ini_array["wizard_enable_custom_icons"];

# page2
$wizard_vboxsvcdomain=$ini_array["wizard_vboxsvcdomain"];

# page3
$wizard_language_en=$ini_array["wizard_language_en"];
$wizard_language_ger=$ini_array["wizard_language_ger"];
$wizard_keyboard_layout_en=$ini_array["wizard_keyboard_layout_en"];
$wizard_keyboard_layout_ger=$ini_array["wizard_keyboard_layout_ger"];

# page1 defaults
if (empty($wizard_no_auth)) $wizard_no_auth = "false";
if (empty($wizard_enable_advanced_config)) $wizard_enable_advanced_config = "false";
if (empty($wizard_start_stop_config)) $wizard_start_stop_config = "false";
if (empty($wizard_enable_custom_icons)) $wizard_enable_custom_icons = "false";

# page2 defaults
if (empty($wizard_vboxsvcdomain)) $wizard_vboxsvcdomain = "http://127.0.0.1:18083";

# page3 defaults
if (empty($wizard_language_en) || $wizard_language_ger == "en") $wizard_language_en = "true";
if (empty($wizard_keyboard_layout_en) || $wizard_keyboard_layout_ger == "EN") $wizard_keyboard_layout_en = "true";
if (empty($wizard_language_ger) || $wizard_language_ger == "en") $wizard_language_ger = "false";
if (empty($wizard_keyboard_layout_ger) || $wizard_keyboard_layout_ger == "EN") $wizard_keyboard_layout_ger = "false";

echo  <<<EOF
[
{
    "step_title": "phpVirtualBox configuration (page 1)",
    "items": [{
        "type": "multiselect",
        "desc": "No authentication? You will not be prompted to login into phpVirtualBox.",
        "subitems": [{
            "key": "wizard_no_auth",
            "desc": "Disable authentication",
			"defaultValue":$wizard_no_auth
        }]
    }, 
	{
        "type": "multiselect",
        "desc": "Enable advanced configuration items (normally hidden in the VirtualBox GUI)?",
        "subitems": [{
            "key": "wizard_enable_advanced_config",
            "desc": "Enable advanced configuration",
			"defaultValue":$wizard_enable_advanced_config
        }]
    }, 
	{
        "type": "multiselect",
        "desc": "Enable startup / shutdown configuration?",
        "subitems": [{
            "key": "wizard_start_stop_config",
            "desc": "Enable start/stop",
			"defaultValue":$wizard_start_stop_config
        }]
    }, 
	{
        "type": "multiselect",
        "desc": "Enable custom VM icons",
        "subitems": [{
            "key": "wizard_enable_custom_icons",
            "desc": "Enable custom VM icons",
			"defaultValue":$wizard_enable_custom_icons
        }]
    }
	]
}, 
{
	"step_title": "phpVirtualBox language configuration (page 2)",
	"items": [
	{
       "type": "textfield",
       "desc": "Url to vboxwebsvc (optional, leave default if unsure)",
       "subitems": [{
                        "key": "wizard_vboxsvcdomain",
                        "desc": "URL",
                        "defaultValue": "$wizard_vboxsvcdomain"
       }]
    }, 
	{
		"type": "textfield",
		"desc": "Authentication password for vboxwebsvc (optional, leave default if unsure)",
		"subitems": [{
				"key": "wizard_use_vboxwebsvc_pass",
				"desc": "vboxwebsvc password",
				"defaultValue": ""
		}]
    }
	]
}, 
{
	"step_title": "phpVirtualBox language configuration (page 3)",
	"items": [{
		"type": "singleselect",
		"desc": "Default language. See languages folder for more language options. Can also be changed in File -> Preferences -> Language in phpVirtualBox.",
		"subitems": [{
			"key": "wizard_language_en",
			"desc": "English Language",
			"defaultValue": $wizard_language_en
		},
		{
			"key": "wizard_language_ger",
			"desc": "German Language",
			"defaultVaule": $wizard_language_ger
		}]
	},
	{
		"type": "singleselect",
		"desc": "Console tab keyboard layout. Currently Oracle's RDP client only supports EN and DE.",
		"subitems": [{
			"key": "wizard_keyboard_layout_en",
			"desc": "English Layout",
			"defaultValue": $wizard_keyboard_layout_en
		},
		{
			"key": "wizard_keyboard_layout_ger",
			"desc": "German Layout",
			"defaultVaule": $wizard_keyboard_layout_ger
		}]
	}]
}
];
EOF;
?>
EOF

/usr/bin/php -n /tmp/wizard.php > $SYNOPKG_TEMP_LOGFILE
rm /tmp/wizard.php
exit 0
