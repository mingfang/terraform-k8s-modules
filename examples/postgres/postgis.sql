-- psql -U postgres -c "SELECT Loader_Generate_Nation_Script('debbie')" -d postgis -tA > /data/gisdata/nation_script_load.sh
-- psql -U postgres -c "SELECT Loader_Generate_Script(ARRAY['NY'], 'debbie')" -d postgis -tA > /data/gisdata/ny_load.sh

SELECT g.rating, ST_Y(g.geomout)  || ' ' || ST_X(g.geomout) as lonlat, 
    (addy).address As stno, (addy).streetname As street,
    (addy).streettypeabbrev As styp, (addy).location As city, (addy).stateabbrev As state,(addy).zip
    FROM geocode('8714 colonial rd, brooklyn, ny, 11209', 1) As g;