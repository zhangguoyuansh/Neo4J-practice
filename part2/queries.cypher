match(n:carpass)-[r:get_out_to]->(m:carpass) 
where  r.outday <= "2020/7/5" and r.outday >= "2020/5/2"
return r.outday,r.money;

match(n:carinfor)-[r:enter]->(m:carpass) 
return n.ownerName, m.passno;


match(n:carinfor)-[r:enter]->(m:carpass) 
where r.inday <= "2020/04/05" and r.inday >= "2020/04/02"
return n, m;

MATCH (n:carinfor) WHERE n.type="student" 
RETURN n;

MATCH (ci:carinfor)-[rel:enter]->(cp:carpass)-[rel2:belong_to]->(p:carpark)
RETURN ci, rel, cp, rel2, p LIMIT 25;

MATCH  (carinfor)-[:enter]->(carpass)-[:belong_to]->(other:carpark)
RETURN other.name as otherpark, count(distinct carpass) as count;

match (cinfor: carinfor)-[r:enter]->(cpass: carpass) 
where cinfor.CarNo=~"K.+" and cpass.position= "west" and r.intime<"9:30"
return cinfor,r,cpass;

MATCH (carinfor)-[:enter]-(carpass)
  WHERE carinfor.CarNo =~ 'K.*'
  WITH carinfor, count(carpass) AS in
  WHERE in > 3
  RETURN carinfor;

MATCH (students:cartype { cartype:'student'}) - [*0..1]- (x)
RETURN x;

MATCH (cinfo:carinfor {CarNo:'JKJG89'})
OPTIONAL MATCH (cinfo)-[r:enter]->()
RETURN r;



MATCH (c1:carinfor {CarNo: 'KS7673J'})-[:enter]->(carpass1)
WITH c1, collect(id(carpass1)) AS c1Carpass
MATCH (c2:carinfor {CarNo: "OU23HJ"})-[:enter]->(carpass2)
WITH c1, c1Carpass, c2, collect(id(carpass2)) AS c2Carpass
RETURN c1.CarNo AS from,
       c2.CarNo AS to,
       gds.alpha.similarity.jaccard(c1Carpass, c2Carpass) AS similarity;

MATCH (c1:carinfor {CarNo: 'KS7673J'})-[:enter]->(carpass1)
WITH c1, collect(id(carpass1)) AS c1Carpass
MATCH (c2:carinfor)-[:enter]->(carpass2) where c1<>c2
WITH c1, c1Carpass, c2, collect(id(carpass2)) AS c2Carpass
RETURN c1.CarNo AS from,
       c2.CarNo AS to,
       gds.alpha.similarity.jaccard(c1Carpass, c2Carpass) AS similarity
ORDER BY to, similarity DESC;

