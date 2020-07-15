All of the commands on this page should be run within **Terminal 2**.

## `postgisftw` schema

To create a user-defined function, first we must log into the running database.

>**WAIT!** Before you execute the code block below, make sure you've navigated back to ```Terminal 2```. 

```PGPASSWORD="password" psql -h localhost -U groot firedata```{{execute}}

In order for pg_featureserv to publish a user-defined function, we first need to create the schema that pg_featureserv looks for. The schema needs to be called ```postgisftw``` (aka "PostGIS for the Web"). (Note: we are planning to expand the schemas available to pg_featureserv, but for now it is limited to this schema.)

```CREATE SCHEMA postgisftw;```{{execute}}

Now that we've created the schema, we can add our function. But before we do that, let's take a quick look at the data. 

First, let's take a look at what tables we have.

```SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'public' AND schemaname != 'information_schema' ;```{{execute}} 

You can see we have six tables with information about New York City. If you look at the pg_featureserv tab > Collections, those same tables are also available in the pg_featureserv UI. 


Now, let's go back to the **Terminal 2** tab, and we'll take a quick look at one of the tables we'll use in the function.

```SELECT DISTINCT * FROM public.nyc_subway_stations ORDER BY name ASC LIMIT 10;```{{execute}}

You can see there is a variety of data in the table, but we will only use a subesection of this table and the US Census Block table. Now, let's get back to the function.

## Create a user-defined function

We'll create a new function named `postgisftw.nyc_katacoda`.

This function does a query aganist US Census Block borough names, and returns the name of the borough and Census Block geometries that intersect with the subway geometry.

```
CREATE OR REPLACE FUNCTION postgisftw.parcels_dist(
	in_gid integer DEFAULT 69293,
	dist numeric DEFAULT 100)
RETURNS TABLE(geom text, parcelid integer, address text, acres text)
AS $$
BEGIN
	RETURN QUERY
SELECT ST_AsText( ST_Transform(a.geom, 4326)) AS wkt, a.gid,
        (a.sitnumber || ' ' ||  a.sitstreet || ', ' ||  a.sitcity || ' ' || a.sitzip) as address,
        a.acres::text
    FROM groot.assessor_parcels a
    JOIN groot.assessor_parcels b ON ST_DWithin(a.geom, b.geom, dist)
    WHERE b.gid = in_gid;
END;
$$
LANGUAGE 'plpgsql'
STABLE
STRICT;

CREATE OR REPLACE FUNCTION postgisftw.set_parcel_firehazard(
	in_gid integer DEFAULT 0,
	in_hazard text DEFAULT 'N')
RETURNS TABLE(parcelid integer, firehazard text)
AS $$
BEGIN
    UPDATE groot.assessor_parcels SET firehazard =
        CASE in_hazard WHEN 'Y' THEN 'Yes' ELSE 'No' END
        WHERE gid  = in_gid;
	RETURN QUERY
SELECT a.gid AS parcelid, a.firehazard::text
    FROM groot.assessor_parcels a
    WHERE a.gid = in_gid;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
STRICT;
```{{execute}}

Now if you return to the pg_featureserv tab, you can look under the Functions page and you'll see your newly created function.