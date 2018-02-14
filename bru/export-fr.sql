-- Note: https://github.com/etalab/ban-data/blob/master/scripts/out_pg2json.sh

SELECT
    format(
        '{"id":"urbis.%s.fr","type":"%s","name":%s,"postcode":"%s","citycode":"%s","lon":%s,"lat":%s,"city":"%s","importance":%s,"housenumbers":{%s}}',
        "id",
        'street',
        CASE WHEN "aliases" IS NULL THEN '"'||"street_fre"||'"'
            ELSE '["'||"street_fre"||'",'||"aliases"||']'
        END,
        "pz_nat_code",
        "mun_code",
        round(ST_X("center"::geometry)::numeric, 6),
        round(ST_Y("center"::geometry)::numeric, 6),
        "mun_fre",
        1,
        "housenumbers"
    )
FROM
    (
        WITH
            "housenumbers" AS (
                SELECT
                    ad."pn_id",
                    string_agg(
                        format(
                            '"%s":{"lat":%s,"lon":%s,"id":"%s"}',
                            trim(ad."adrn"),
                            round(ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(ad."x", ad."y"), 31370), 4326))::numeric, 6),
                            round(ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(ad."x", ad."y"), 31370), 4326))::numeric, 6),
                            ad."id"
                        ),
                        ',' ORDER BY ad."adrn", ad."id"
                    ) AS "housenumbers"
                FROM
                    "urb_a_adpt" ad
                GROUP BY
                    ad."pn_id"
            ),
            "aliases" AS (
                SELECT
                    "pn_id",
                    string_agg(
                        format(
                            '"%s"',
                            "name"
                        ),
                        ','
                    ) AS "aliases"
                FROM
                    "urb_a_pn_syn"
                WHERE
                    "lang" = 'FRE'
                GROUP BY
                    "pn_id"
            )
        SELECT
            DISTINCT ON (pn."id")
            pn."id",
            pn."name_fre" AS "street_fre",
            mz."pz_nat_code",
            mu."national_code" AS "mun_code",
            mu."name_fre" AS "mun_fre",
            sa."center",
            hn."housenumbers",
            al."aliases"
        FROM
            "urb_a_pn" pn
            LEFT JOIN "housenumbers" hn ON pn."id" = hn."pn_id"
            LEFT JOIN "aliases" al ON pn."id" = al."pn_id"
            LEFT JOIN "street_axis" sa ON pn."id" = sa."pn_id"
            LEFT JOIN "urb_a_mz" mz ON pn."mz_id" = mz."id"
            LEFT JOIN "urb_a_mu" mu ON mz."mu_id" = mu."id"
        WHERE
            pn."type" = 'SS'
        ORDER BY
            pn."id"
    ) AS "urbis-fr";
