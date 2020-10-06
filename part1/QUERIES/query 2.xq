for $REGISTRATION in doc("my_xml")/my_xml/CARPASS/REGISTRATION
where $REGISTRATION//NAMEEMPLOYEE[text()contains text {'Charles Brownson'}any]
return $REGISTRATION/CARNo

