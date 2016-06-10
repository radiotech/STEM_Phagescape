<?php

$CompiledJSON = file_get_contents('http://docs.google.com/document/d/1kkAmGzPFc3kJpiN-nEbqvUzDqTldl0XyOxCBTEcKFn0/pub?embedded=true');
$startPos = strpos($CompiledJSON,"\"><span class=\"")+19;
$stopPos = strpos($CompiledJSON,"</span></p>");
$CompiledJSON = substr($CompiledJSON,$startPos,$stopPos-$startPos);
$CompiledJSON = str_replace("&quot;","\"",$CompiledJSON);
echo $CompiledJSON;

$decoded = json_decode($CompiledJSON,true,30);

echo("<pre>");
print_r($decoded);
echo("</pre>");

?>