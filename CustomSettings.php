<?php
wfLoadExtension('VisualEditor');

// Enable by default for everybody
$wgDefaultUserOptions['visualeditor-enable'] = 1;

// Optional: Set VisualEditor as the default for anonymous users
// otherwise they will have to switch to VE
 $wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

// Don't allow users to disable it
$wgHiddenPrefs[] = 'visualeditor-enable';

// OPTIONAL: Enable VisualEditor's experimental code features
#$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

$wgVirtualRestConfig['modules']['parsoid'] = array(
	// URL to the Parsoid instance
	// Use port 8142 if you use the Debian package
	'url' => 'parsoid:8142',
	//'port' => 8142,
	// Parsoid "domain", see below (optional)
	'domain' => 'localhost',
	// Parsoid "prefix", see below (optional)
	#'prefix' => 'localhost'
);

$wgSessionsInObjectCache = true;

$wgVirtualRestConfig['modules']['parsoid']['forwardCookies'] = true;

error_reporting( -1 );
ini_set( 'display_errors', 1 );
$wgDebugToolbar = true;
