DROP TABLE kfme_kvadraty;

CREATE TABLE kfme_kvadraty(id char(6) PRIMARY KEY, geom geometry(POLYGON, 4326));
CREATE INDEX ON kfme_kvadraty USING gist(geom);

INSERT INTO kfme_kvadraty
with kfme AS (
   SELECT y*100+x kfme_id
   , 12 + (x-38.)/6 x
   , 51 - (y-49.)/10 y
   FROM
   generate_series(49, 74) y
   , generate_series(38, 79) x
)
, q1 AS (
   SELECT kfme_id, qq q1
   , CASE qq
      WHEN 'b' THEN x+1./12
      WHEN 'd' THEN x+1./12
      ELSE x
   END x
   , CASE qq
      WHEN 'a' THEN y+1./20
      WHEN 'b' THEN y+1./20
      ELSE y
   END y
   FROM kfme
   ,( values('a'),('b'),('c'),('d'))q1 (qq)
)
, q2 AS (
   SELECT kfme_id, q1, qq q2
   , CASE qq
      WHEN 'b' THEN x+1./24
      WHEN 'd' THEN x+1./24
      ELSE x
   END x
   , CASE qq
      WHEN 'a' THEN y+1./40
      WHEN 'b' THEN y+1./40
      ELSE y
   END y
   FROM q1
   ,( values('a'),('b'),('c'),('d'))q2 (qq)
)
SELECT
 kfme_id::text||q1||q2 kfme_id
, 
ST_SetSRID(
   ST_Envelope(
      ST_Collect(
	 ST_MakePoint(x,y)
	 , ST_MakePoint(x + 1./24,y + 1./40) 
      )
   ), 4326
) geom
FROM q2
;
