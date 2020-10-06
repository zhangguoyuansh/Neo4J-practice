for $x in doc("my_xml")/my_xml/CARPASS/REGISTRATION
where $x//NAMEEMPLOYEE[text()contains text {'Dionise K.'}any]
return $x	