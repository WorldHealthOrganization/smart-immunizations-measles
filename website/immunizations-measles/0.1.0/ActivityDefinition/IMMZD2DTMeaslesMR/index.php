<?php
function Redirect($url)
{
  header('Location: ' . $url, true, 302);
  exit();
}

$accept = $_SERVER['HTTP_ACCEPT'];
if (strpos($accept, 'application/json+fhir') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.json2');
elseif (strpos($accept, 'application/fhir+json') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.json1');
elseif (strpos($accept, 'json') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.json');
elseif (strpos($accept, 'application/xml+fhir') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.xml2');
elseif (strpos($accept, 'application/fhir+xml') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.xml1');
elseif (strpos($accept, 'html') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.html');
else 
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/ActivityDefinition-IMMZD2DTMeaslesMR.xml');
?>
    
You should not be seeing this page. If you do, PHP has failed badly.
