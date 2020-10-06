//create nodes

//create carinfor
LOAD CSV WITH HEADERS FROM 'file:///carinfor.csv' AS row
MERGE (cinfo:carinfor {CarNo: row.CarNo})
  ON CREATE SET cinfo.CarNo = row.CarNo,cinfo.belongto = row.belongto,cinfo.type = row.type,cinfo.ownerName = row.ownerName,cinfo.ownerPhone = row.ownerPhone,cinfo.department = row.department,cinfo.ownergender = row.ownergender;
//create cartype
LOAD CSV WITH HEADERS FROM 'file:///cartype.csv' AS row
MERGE (ctype:cartype {type: row.TypeName})
  ON CREATE SET ctype.cartype = row.TypeName,ctype.cutoff = row.CutOff;
//create the relationship between car and cartype
LOAD CSV WITH HEADERS FROM "file:///carinfor.csv" AS row
MATCH (car:carinfor {CarNo: row.CarNo})
MATCH (type:cartype {cartype: row.type})
MERGE (type)<-[:belong_to]-(car);

//create carpass
LOAD CSV WITH HEADERS FROM 'file:///carpass.csv' AS row
MERGE (cpass:carpass {passno: row.PassNo})
  ON CREATE SET cpass.passno = row.PassNo,cpass.cparkno = row.No,cpass.position = row.Position,cpass.belongto = row.belongTo,cpass.comm = row.commnets,cpass.passtype = row.PassType;
//create carpark
LOAD CSV WITH HEADERS FROM 'file:///carpark.csv' AS row
MERGE (cpark:carpark {carparkno: row.CarParkNo})
  ON CREATE SET cpark.carparkno = row.CarParkNo,cpark.name = row.name,cpark.address = row.address, cpark.countparkingspace = row.countParkingSpace, cpark.surplusparkingspace = row.surplusParkingSpace;
//create the relationship between carpass and carpark
LOAD CSV WITH HEADERS FROM "file:///carpass.csv" AS row
MATCH (pass:carpass {passno: row.PassNo})
MATCH (park:carpark {carparkno: row.No})
MERGE (pass)-[:belong_to]->(park);


//create the relationship recordin between car and carpass 
LOAD CSV WITH HEADERS FROM "file:///recordin.csv" as row
MATCH (car:carinfor{CarNo:row.carNo}),(inpass:carpass{passno:row.inPass})
MERGE (car)-[r:enter{inno:row.InNo,intime:row.inTime,inday:row.inDay}]-(inpass);

//create the relationship between car enter and get out
LOAD CSV WITH HEADERS FROM "file:///recordout.csv" as row
MATCH (in:carpass{passno:row.inPass}) ,(outpass:carpass{passno:row.outPass})
MERGE (in)-[re:get_out_to{outno:row.no,outtime:row.outTime,outday:row.outday,money:row.money,frompassno:row.FromPass}]-(outpass);



//create the realtionship between cartype and feerules
LOAD CSV WITH HEADERS FROM "file:///feerules.csv" as row
MATCH (ct:cartype),(cp:carpark)
WHERE ct.type = row.type AND cp.carparkno = row.carParkNo
CREATE (ct)-[r:fees]->(cp)
SET r = row,
r.hourlyprice = toInteger(row.hourlyPrice);

//create carseats
LOAD CSV WITH HEADERS FROM 'file:///carseats.csv' AS row
MERGE (cs:carseats {seat: row.seats})
  ON CREATE SET cs.seat = row.seats;

//create the relationship between car and carseats
LOAD CSV WITH HEADERS FROM "file:///carseats.csv" AS row
MATCH (seat:carseats {seat: row.seats})
MATCH (car:carinfor {CarNo: row.carno})
MERGE (car)-[:has_seats]->(seat);
//create the trucks which is about the roadcapacity of the car
LOAD CSV WITH HEADERS FROM 'file:///trucks.csv' AS row
MERGE (t:trucks {loadcapacity: row.loadCapacity})
  ON CREATE SET t.loadcapacity = row.loadCapacity;
//create the relationship between car and trucks
LOAD CSV WITH HEADERS FROM "file:///trucks.csv" AS row
MATCH (lc:trucks {loadcapacity: row.loadCapacity})
MATCH (car:carinfor {CarNo: row.carno})
MERGE (car)-[:has_loadcapacity]->(lc);


//create the relationship register between car and carpass

LOAD CSV WITH HEADERS FROM "file:///register.csv" as row
MATCH (car:carinfor{CarNo:row.CarNo}),(pass:carpass{passno:row.PassNo})
MERGE (car)-[r:resigter{em:row.employname,spot:row.spotNo}]-(pass);

//create the indexes
CREATE INDEX car_no FOR (cinfo:carinfor) ON (cinfo.CarNo);
CREATE INDEX type_name FOR (ctype:cartype) ON (ctype.cartype);
CREATE INDEX pass_no FOR (cpass:carpass) ON (cpass.passno);
CREATE INDEX park_no FOR (cpark:carpark) ON (cpark.carparkno);
CREATE INDEX in_no FOR (in:enter) ON (in.inno);
CREATE INDEX seats FOR (s:carseats) ON (s.seat);
CREATE INDEX loadcapacity FOR (t:trucks) ON (t.loadcapacity);