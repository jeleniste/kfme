DROP TABLE kfme;

CREATE TABLE kfme(id int PRIMARY KEY, geom geography(POLYGON, 4326));
CREATE INDEX ON kfme USING gist(geom);

INSERT INTO kfme
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
   , 4326
)::geography(POLYGON, 4326)
   
FROM
generate_series(49, 74) y
, generate_series(38, 79) x;
