<?php
function Redirect($url)
{
  header('Location: ' . $url, true, 302);
  exit();
}

$accept = $_SERVER['HTTP_ACCEPT'];
if (strpos($accept, 'application/json+fhir') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.json2');
elseif (strpos($accept, 'application/fhir+json') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.json1');
elseif (strpos($accept, 'json') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.json');
elseif (strpos($accept, 'application/xml+fhir') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.xml2');
elseif (strpos($accept, 'application/fhir+xml') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.xml1');
elseif (strpos($accept, 'html') !== false)
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.html');
else 
  Redirect('http://smart.who.int/immunizations-measles/0.1.0/Questionnaire-QIMMZCRegisterClient.xml');
?>
    
You should not be seeing this page. If you do, PHP has failed badly.
