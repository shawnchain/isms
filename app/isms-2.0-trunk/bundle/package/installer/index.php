<?php

/* iPhone Installer Repository 2.2 */


/* Config */

define('__PLISTS_PATH__', 'plists');
define('__REDIRECT_URL__', '/dist/');


/* Start */

if(!$_GET['debug'] && !(strstr($_SERVER['HTTP_USER_AGENT'], 'CFNetwork') || strstr($_SERVER['HTTP_USER_AGENT'], 'iPhone'))) die(header('Location: ' . __REDIRECT_URL__));
if(!$_GET['debug']) header('Content-type: application/x-apptapp-repository');
die(generateIndex(__PLISTS_PATH__));


/* Functions */

function generateIndex($path) {
	global $index, $indexPackagesArray;

	$index = new DOMDocument();
	$index->load('repository.plist');
	$indexPackagesArray = $index->getElementsByTagName('array')->item(0);

	findPackages($path);
	//$index->normalizeDocument();
	return $index->saveXML();
}

function findPackages($path) {
	$packages = dir($path);

	while($entry = $packages->read()) {
		if($entry != "." && $entry != "..") {
			$entryPath = $path . '/' . $entry;
			if(is_dir($entryPath)) {
				findPackages($entryPath);
			} else if(stristr($entry, ".plist")){
				if($path != __PLISTS_PATH__) $category = basename($path);
				else $category = NULL;

				addPackage($entryPath, $category);
			}
		}
	}

	$packages->close();
}

function addPackage($path, $category) {
	global $index, $indexPackagesArray;

	$package = new DOMDocument();
	if($package->load($path)) {
		$dict = $package->getElementsByTagName('dict')->item(0);

		if($category != NULL) {
			$dict->appendChild($package->createElement('key', 'category'));
			$dict->appendChild($package->createElement('string', htmlentities($category)));
		}
		$dict->appendChild($package->createElement('key', 'date'));
		$dict->appendChild($package->createElement('string', filemtime($path)));

		$child = $index->importNode($dict, true);
		$indexPackagesArray->appendChild($child);
	}
}

?>
