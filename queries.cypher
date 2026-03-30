//----TESTIDATA---

// 1. Tyhjennetään kanta alkutilaan
MATCH (n) DETACH DELETE n;

// 2. Luodaan henkilöt 
CREATE (anna:Henkilo {nimi: 'Anna'}),
       (matti:Henkilo {nimi: 'Matti'}),
       (liisa:Henkilo {nimi: 'Liisa'}),
       (teemu:Henkilo {nimi: 'Teemu'})

// 3. Luodaan kohteet 
CREATE (pariisi:Kohde {nimi: 'Pariisi'}),
       (lontoo:Kohde {nimi: 'Lontoo'}),
       (rooma:Kohde {nimi: 'Rooma'}),
       (berliini:Kohde {nimi: 'Berliini'}),
       (tokio:Kohde {nimi: 'Tokio'}),
       (barcelona:Kohde {nimi: 'Barcelona'}),
       (lappi:Kohde {nimi: 'Lappi'})

// 4. Luodaan ajankohdat 
CREATE (vko25:Ajankohta {viikko: 25}),
       (vko26:Ajankohta {viikko: 26}),
       (vko27:Ajankohta {viikko: 27}),
       (vko28:Ajankohta {viikko: 28}),
       (vko29:Ajankohta {viikko: 29}),
       (vko30:Ajankohta {viikko: 30})
       

// 5. Luodaan kohdetoiveet (HALUAA)
CREATE 
  (anna)-[:HALUAA]->(pariisi), (anna)-[:HALUAA]->(rooma), (anna)-[:HALUAA]->(berliini), (anna)-[:HALUAA]->(barcelona), (anna)-[:HALUAA]->(lappi),
  (matti)-[:HALUAA]->(pariisi), (matti)-[:HALUAA]->(lontoo), (matti)-[:HALUAA]->(tokio), (matti)-[:HALUAA]->(berliini), (matti)-[:HALUAA]->(lappi),
  (liisa)-[:HALUAA]->(pariisi), (liisa)-[:HALUAA]->(rooma), (liisa)-[:HALUAA]->(barcelona), (liisa)-[:HALUAA]->(tokio), (liisa)-[:HALUAA]->(lappi),
  (teemu)-[:HALUAA]->(rooma), (teemu)-[:HALUAA]->(lontoo), (teemu)-[:HALUAA]->(berliini), (teemu)-[:HALUAA]->(barcelona), (teemu)-[:HALUAA]->(lappi)

// 6. Luodaan vapaat ajat (VAPAA)
CREATE 
  (anna)-[:VAPAA]->(vko25), (anna)-[:VAPAA]->(vko26), (anna)-[:VAPAA]->(vko27), 
  (matti)-[:VAPAA]->(vko25), (matti)-[:VAPAA]->(vko27), (matti)-[:VAPAA]->(vko29), (matti)-[:VAPAA]->(vko28),
  (liisa)-[:VAPAA]->(vko25), (liisa)-[:VAPAA]->(vko26), (liisa)-[:VAPAA]->(vko30), (liisa)-[:VAPAA]->(vko29),
  (teemu)-[:VAPAA]->(vko25), (teemu)-[:VAPAA]->(vko27), (teemu)-[:VAPAA]->(vko28), (teemu)-[:VAPAA]->(vko30)



//------KYSELYT-------



//Palauttaa graafin tietokannasta
MATCH (n) RETURN n


//Suosituimmat lomakohteet
MATCH (k:Kohde)<-[:HALUAA]-(h:Henkilö)
RETURN k.nimi AS Kohde, count(h) AS Halukkaiden_Määrä
ORDER BY Halukkaiden_Määrä DESC;


//Kertoo ketkä on lomalla milläkin viikolla
MATCH (h:Henkilo)-[:VAPAA]->(a:Ajankohta)
RETURN a.viikko AS Viikko,  
       collect(h.nimi) AS Keillä_Vapaata
ORDER BY Viikko;


//Hakee täydelliset matchit
MATCH (kaikki:Henkilo)
WITH count(kaikki) AS porukan_koko
MATCH (h:Henkilo)-[:HALUAA]->(k:Kohde),
      (h)-[:VAPAA]->(a:Ajankohta)
WITH k, a, count(h) AS osumat, porukan_koko, collect(h.nimi) AS nimet
WHERE osumat = porukan_koko
RETURN k.nimi AS Kohde, 
       a.viikko AS Viikko, 
       osumat AS Osallistujat,
       nimet AS Henkilöt;