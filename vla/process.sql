ALTER TABLE "crabadr" DROP COLUMN IF EXISTS "ogc_fid";
ALTER TABLE "straatnm" DROP COLUMN IF EXISTS "ogc_fid";
ALTER TABLE "wegsegment" DROP COLUMN IF EXISTS "ogc_fid";

ALTER TABLE "straatnm" ADD PRIMARY KEY ("id");
CREATE INDEX ON "wegsegment" ("lstrnmid");
CREATE INDEX ON "wegsegment" ("rstrnmid");

CREATE TABLE "street_axis_longest" AS (
    SELECT
        s."id",
        (
            SELECT
                "the_geog"
            FROM
                "wegsegment" ws
            WHERE
                ws."lstrnmid" = s."id" OR
                ws."rstrnmid" = s."id"
            ORDER BY
                ST_Length(ws."the_geog") DESC
            LIMIT 1
        ) AS "the_geog"
    FROM
        "straatnm" s
);
ALTER TABLE "street_axis_longest" ADD PRIMARY KEY ("id");

CREATE TABLE "street_axis_union" AS (
    SELECT
        s."id",
        (
            SELECT
                ST_LineMerge(ST_Union(ws."the_geog"::geometry))::geography
            FROM
                "wegsegment" ws
            WHERE
                ws."lstrnmid" = s."id" OR
                ws."rstrnmid" = s."id"
        ) AS "the_geog"
    FROM
        "straatnm" s
);
ALTER TABLE "street_axis_union" ADD PRIMARY KEY ("id");

CREATE TABLE "street_axis" AS (
    SELECT
        s."id",
        sau."the_geog",
        ST_LineMerge(sal."the_geog"::geometry)::geography AS "longest",
        NULL::geography AS "center"
    FROM
        "straatnm" AS s
        JOIN "street_axis_union" AS sau USING("id")
        JOIN "street_axis_longest" AS sal USING("id")
);

UPDATE "street_axis" SET "center" = ST_LineInterpolatePoint("the_geog"::geometry, 0.5)::geography WHERE GeometryType("the_geog"::geometry) = 'LINESTRING';
UPDATE "street_axis" SET "center" = ST_LineInterpolatePoint("longest"::geometry, 0.5)::geography WHERE GeometryType("the_geog"::geometry) = 'MULTILINESTRING' AND GeometryType("longest"::geometry) = 'LINESTRING' ;

-- TODO : Add center coordinates for street where "longest" is MULTILINESTRING !!!
