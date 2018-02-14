-- Note: https://github.com/etalab/ban-data/blob/master/scripts/out_pg2json.sh

SELECT
    format(
        '{"id":"crab.%s","type":"%s","name":"%s","postcode":"%s","citycode":"%s","lon":%s,"lat":%s,"city":"%s","importance":%s,"housenumbers":{%s}}',
        "straatnmid",
        'street',
        "straatnm",
        "postcode",
        "niscode",
        round(ST_X("center"::geometry)::numeric, 6),
        round(ST_Y("center"::geometry)::numeric, 6),
        "gemeente",
        1,
        "housenumbers"
    )
FROM
    (
        WITH
            "housenumbers" AS (
                SELECT
                    a."straatnmid",
                    string_agg(
                        format(
                            '"%s":{"lat":%s,"lon":%s,"id":"%s"}',
                            trim(a."huisnr"),
                            round(ST_Y(a."the_geog"::geometry)::numeric, 6),
                            round(ST_X(a."the_geog"::geometry)::numeric, 6),
                            a."id"
                        ),
                        ',' ORDER BY a."huisnr", a."id"
                    ) AS "housenumbers"
                FROM
                    "crabadr" a
                GROUP BY
                    a."straatnmid"
            )
        SELECT
            DISTINCT ON (a."straatnmid")
            a."straatnmid",
            a."straatnm",
            a."postcode",
            a."niscode",
            a."gemeente",
            sa."center",
            hn."housenumbers"
        FROM
            "crabadr" a
            LEFT JOIN "housenumbers" hn ON a."straatnmid" = hn."straatnmid"
            LEFT JOIN "street_axis" sa ON a."straatnmid" = sa."id"
    ) AS "crab";

-- TODO: Check if straatnmid is unique with postcode !!!
