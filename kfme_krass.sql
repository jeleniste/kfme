DROP TABLE kfme_krass;

CREATE TABLE kfme_krass(id int PRIMARY KEY, geom geography(POLYGON, 4204));
CREATE INDEX ON kfme_krass USING gist(geom);

INSERT INTO kfme_krass
SELECT y*100+x kfme_id
--, *
, ST_SetSRID(
   ST_Envelope(
      ST_MakeLine(
	 ST_Point(
	    12 + (x-38.)/6
	    , 51 - (y-49.)/10
	 )
	 , ST_Point(
	    12 + (x-37.)/6
	    , 51 - (y-50.)/10
	 )
      )
   )
   , 4204
)::geography(POLYGON, 4204)
   
FROM
generate_series(49, 74) y
, generate_series(38, 79) x;
