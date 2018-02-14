CREATE TABLE "street_axis_longest" AS (
    SELECT
        DISTINCT ON (ss."pn_id")
        ss."pn_id",
        sa."the_geog"
    FROM
        "urb_a_ss" AS ss
        JOIN "urb_a_sa_ss" AS sass ON ss."id" = sass."ss_id"
        JOIN "urbadm_street_axis" AS sa ON sass."sa_id" = sa."id"
    ORDER BY
        ss."pn_id",
        ST_Length(sa."the_geog") DESC
);

CREATE TABLE "street_axis" AS (
    SELECT
        ss."pn_id",
        ST_LineMerge(ST_Union(sa."the_geog"::geometry))::geography AS "the_geog",
        NULL::geography AS "longest",
        NULL::geography AS "center"
    FROM
        "urb_a_ss" AS ss
        JOIN "urb_a_sa_ss" AS sass ON ss."id" = sass."ss_id"
        JOIN "urbadm_street_axis" AS sa ON sass."sa_id" = sa."id"
    GROUP BY
        ss."pn_id"
);

UPDATE "street_axis" AS s
    SET
        "longest" = ST_LineMerge(l."the_geog"::geometry)::geography
    FROM
        "street_axis_longest" AS l
    WHERE
        s."pn_id" = l."pn_id"
;

UPDATE "street_axis" SET "center" = ST_LineInterpolatePoint("the_geog"::geometry, 0.5)::geography WHERE GeometryType("the_geog"::geometry) = 'LINESTRING';
UPDATE "street_axis" SET "center" = ST_LineInterpolatePoint("longest"::geometry, 0.5)::geography WHERE GeometryType("the_geog"::geometry) = 'MULTILINESTRING' AND GeometryType("longest"::geometry) = 'LINESTRING' ;

-- TODO : Add center coordinates for street where "longest" is MULTILINESTRING !!!
