for $CARPASS in doc("my_xml")/my_xml/CARPASS
where $CARPASS//NAME[text()contains text {'OLI'}any]
return $CARPASS/REGISTRATION/SPOTNo
