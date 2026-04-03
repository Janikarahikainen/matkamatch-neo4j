# Valmiit kyselyt

## READ

Tässä on kokoelma hyödyllisiä Cypher-kyselyitä matkatietokannan analysointiin.

### Visualisoi koko graafi

```
MATCH (n) RETURN n
```

### Suosituimmat lomakohteet

```
MATCH (k:Kohde)<-[:HALUAA]-(h:Henkilo)
RETURN k.nimi AS Kohde, count(h) AS Halukkaat_lkm
ORDER BY Halukkaat_lkm DESC;
```

### Kertoo ketkä on lomalla milläkin viikolla

```
MATCH (h:Henkilo)-[:VAPAA]->(a:Ajankohta)
RETURN a.viikko AS Viikko,
 collect(h.nimi) AS Keilla_Vapaata
ORDER BY Viikko;
```

### Hakee täydelliset matchit

```
MATCH (kaikki:Henkilo)
WITH count(kaikki) AS porukan_koko
MATCH (h:Henkilo)-[:HALUAA]->(k:Kohde),
(h)-[:VAPAA]->(a:Ajankohta)
WITH k, a, count(h) AS osumat, porukan_koko, collect(h.nimi) AS nimet
WHERE osumat = porukan_koko
RETURN k.nimi AS Kohde,
a.viikko AS Viikko,
osumat AS Osallistujat,
nimet AS Henkilot;
```

## CREATE

### Lisätään uusi henkilö "Kalle" ja kytketään hänet Lappiin

```
MERGE (kalle:Henkilo {nimi: 'Kalle'})
WITH kalle
MATCH (lappi:Kohde {nimi: 'Lappi'})
MERGE (kalle)-[:HALUAA]->(lappi)
RETURN kalle, lappi
```

## UPDATE

### Etsitään Kalle ja lisätään hänelle viikko 28 vapaaksi

```
MERGE (kalle:Henkilo {nimi: 'Kalle'})
WITH kalle
MATCH (vko:Ajankohta {viikko: 28})
MERGE (kalle)-[:VAPAA]->(vko)
RETURN kalle, vko
```

## DELETE

### Poistaa Kallen ja hänen toiveensa

```
MATCH (h:Henkilo {nimi: 'Kalle'})
DETACH DELETE h
```
