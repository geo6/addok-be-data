-- Create tables

CREATE TABLE "urb_a_adpt" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "si_id"                NUMERIC,
  "bu_id"                NUMERIC,
  "mu_id"                NUMERIC,
  "pz_id"                NUMERIC,
  "pn_id"                NUMERIC,
  "adrn"                 VARCHAR (40),
  "planchenum"           NUMERIC,
  "angle"                NUMERIC,
  "capakey"              VARCHAR (40),
  "x"                    NUMERIC,
  "y"                    NUMERIC,
  "pz_nat_code"          VARCHAR (8),
  "mu_nat_code"          VARCHAR (30),
  "mu_name_fre"          VARCHAR (120),
  "mu_name_dut"          VARCHAR (120),
  "pn_name_fre"          VARCHAR (120),
  "pn_name_dut"          VARCHAR (120),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_mu" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "name_fre"             VARCHAR (120),
  "short_fre"            VARCHAR (6),
  "name_dut"             VARCHAR (120),
  "short_dut"            VARCHAR (6),
  "mu3c"                 VARCHAR (6),
  "pol_id"               NUMERIC,
  "country"              VARCHAR (4),
  "national_code"        VARCHAR (30),
  "national_level"       NUMERIC,
  "area"                 NUMERIC,
  "legal_status"         VARCHAR (40),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_mz" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "mu_id"                NUMERIC,
  "pz_id"                NUMERIC,
  "national_code"        VARCHAR (8),
  "area"                 NUMERIC,
  "pz_name_fre"          VARCHAR (120),
  "pz_name_dut"          VARCHAR (120),
  "pz_nat_code"          VARCHAR (8),
  "mu_name_fre"          VARCHAR (120),
  "mu_name_dut"          VARCHAR (120),
  "mu_nat_code"          VARCHAR (30),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_pn" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "type"                 VARCHAR (10),
  "gw_id"                NUMERIC,
  "mz_id"                NUMERIC,
  "pnmc"                 VARCHAR (8),
  "name_fre"             VARCHAR (120),
  "name_dut"             VARCHAR (120),
  "fre_st"               VARCHAR (40),
  "fre_ab"               VARCHAR (60),
  "fre_ti"               VARCHAR (40),
  "fre_fi"               VARCHAR (40),
  "fre_la"               VARCHAR (60),
  "dut_st"               VARCHAR (40),
  "dut_ab"               VARCHAR (60),
  "dut_ti"               VARCHAR (40),
  "dut_fi"               VARCHAR (40),
  "dut_la"               VARCHAR (60),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_pn_syn" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "lang"                 VARCHAR (20),
  "name"                 VARCHAR (60),
  "pn_id"                NUMERIC,
  "st"                   VARCHAR (20),
  "ab"                   VARCHAR (30),
  "ti"                   VARCHAR (20),
  "fi"                   VARCHAR (20),
  "la"                   VARCHAR (30),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_sa" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "sn_id_b"              NUMERIC,
  "sn_id_e"              NUMERIC,
  "length"               NUMERIC,
  "slope"                NUMERIC,
  "type"                 VARCHAR (5),
  "level_z"              NUMERIC,
  "flow_direction"       VARCHAR (15),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_sa_ss" (
  "sa_id"                NUMERIC,
  "ss_id"                NUMERIC,
  "inspire_id"           VARCHAR (100),
  "versionid"            NUMERIC,
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE "urb_a_ss" (
  "id"                   NUMERIC,
  "versionid"            NUMERIC,
  "type"                 VARCHAR (5),
  "pn_id"                NUMERIC,
  "level_z"              NUMERIC,
  "pnmc"                 VARCHAR (60),
  "area"                 NUMERIC,
  "administrator"        VARCHAR (30),
  "admin_valid"          VARCHAR (1),
  "hierarchy"            VARCHAR (5),
  "hierarchy_valid"      VARCHAR (1),
  "pn_name_fre"          VARCHAR (60),
  "pn_name_dut"          VARCHAR (60),
  "mu_name_fre"          VARCHAR (60),
  "mu_name_dut"          VARCHAR (60),
  "mu_nat_code"          VARCHAR (15),
  "pz_nat_code"          VARCHAR (4),
  "inspire_id"           VARCHAR (100),
  "beginlifespanversion" TIMESTAMP WITHOUT TIME ZONE,
  "endlifespanversion"   TIMESTAMP WITHOUT TIME ZONE
);

-- Load data

COPY "urb_a_adpt"   FROM '/tmp/urb_a_adpt.tsv'   DELIMITER '	' CSV HEADER;
COPY "urb_a_mu"     FROM '/tmp/urb_a_mu.tsv'     DELIMITER '	' CSV HEADER;
COPY "urb_a_mz"     FROM '/tmp/urb_a_mz.tsv'     DELIMITER '	' CSV HEADER;
COPY "urb_a_pn"     FROM '/tmp/urb_a_pn.tsv'     DELIMITER '	' CSV HEADER;
COPY "urb_a_pn_syn" FROM '/tmp/urb_a_pn_syn.tsv' DELIMITER '	' CSV HEADER;
COPY "urb_a_sa"     FROM '/tmp/urb_a_sa.tsv'     DELIMITER '	' CSV HEADER;
COPY "urb_a_sa_ss"  FROM '/tmp/urb_a_sa_ss.tsv'  DELIMITER '	' CSV HEADER;
COPY "urb_a_ss"     FROM '/tmp/urb_a_ss.tsv'     DELIMITER '	' CSV HEADER;
