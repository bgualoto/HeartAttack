--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-08-02 12:10:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 16957)
-- Name: auditoria; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auditoria;


ALTER SCHEMA auditoria OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 16958)
-- Name: fn_log_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_log_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    INSERT INTO "auditoria".tb_auditoria ("tabla_aud", "operacion_aud", "valoranterior_aud", "valornuevo_aud", "fecha_aud", "usuario_aud")
           VALUES (TG_TABLE_NAME, 'D', OLD, NULL, now(), USER);
    RETURN OLD;
  ELSIF (TG_OP = 'UPDATE') THEN
    INSERT INTO "auditoria".tb_auditoria ("tabla_aud", "operacion_aud", "valoranterior_aud", "valornuevo_aud", "fecha_aud", "usuario_aud")
           VALUES (TG_TABLE_NAME, 'U', OLD, NEW, now(), USER);
    RETURN NEW;
  ELSIF (TG_OP = 'INSERT') THEN
    INSERT INTO "auditoria".tb_auditoria ("tabla_aud", "operacion_aud", "valoranterior_aud", "valornuevo_aud", "fecha_aud", "usuario_aud")
           VALUES (TG_TABLE_NAME, 'I', NULL, NEW, now(), USER);
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.fn_log_audit() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 16959)
-- Name: tb_auditoria; Type: TABLE; Schema: auditoria; Owner: postgres
--

CREATE TABLE auditoria.tb_auditoria (
    id_aud integer NOT NULL,
    tabla_aud text,
    operacion_aud text,
    valoranterior_aud text,
    valornuevo_aud text,
    fecha_aud date,
    usuario_aud text
);


ALTER TABLE auditoria.tb_auditoria OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16965)
-- Name: tb_auditoria_id_aud_seq; Type: SEQUENCE; Schema: auditoria; Owner: postgres
--

CREATE SEQUENCE auditoria.tb_auditoria_id_aud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auditoria.tb_auditoria_id_aud_seq OWNER TO postgres;

--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 202
-- Name: tb_auditoria_id_aud_seq; Type: SEQUENCE OWNED BY; Schema: auditoria; Owner: postgres
--

ALTER SEQUENCE auditoria.tb_auditoria_id_aud_seq OWNED BY auditoria.tb_auditoria.id_aud;


--
-- TOC entry 203 (class 1259 OID 16967)
-- Name: dim_diagnostico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_diagnostico (
    pk_diagnostico bigint,
    sk_diagnostico double precision NOT NULL,
    presion_art bigint,
    colesterol bigint,
    azucar_sangre bigint,
    result_elect bigint,
    frec_cardiaca bigint,
    angina_inducida bigint,
    dolor_pecho bigint,
    fecha_diagnostico timestamp without time zone,
    valido_desde timestamp without time zone,
    valido_hasta timestamp without time zone,
    version double precision
);


ALTER TABLE public.dim_diagnostico OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16970)
-- Name: dim_fecha; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_fecha (
    sk_fecha double precision NOT NULL,
    anio double precision,
    trimestre double precision,
    mes double precision,
    dia double precision,
    fecha timestamp without time zone,
    semestre double precision,
    nombre_semestre character varying(9),
    nombre_trimestre character varying(10),
    nombre_mes character varying(10)
);


ALTER TABLE public.dim_fecha OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16973)
-- Name: dim_persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_persona (
    pk_persona bigint,
    sk_persona double precision NOT NULL,
    edad bigint,
    genero bigint,
    valido_desde timestamp without time zone,
    valido_hasta timestamp without time zone,
    version double precision
);


ALTER TABLE public.dim_persona OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16976)
-- Name: dim_report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_report (
    pk_report bigint NOT NULL,
    dolor_pecho bigint,
    presion_art bigint,
    colesterol bigint,
    azucar_sangre bigint,
    result_elect bigint,
    frec_cardiaca bigint,
    angina_inducida bigint,
    pico_anterior bigint,
    tasa_tal bigint,
    variable_objetivo bigint,
    fecha_diagnostico timestamp without time zone,
    edad bigint,
    genero bigint,
    saturacion bigint,
    buques bigint,
    pendiente bigint,
    anio double precision,
    trimestre double precision,
    mes double precision,
    dia double precision,
    fecha timestamp without time zone,
    semestre double precision,
    nombre_semestre character varying(9),
    nombre_trimestre character varying(10),
    nombre_mes character varying(10)
);


ALTER TABLE public.dim_report OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16979)
-- Name: dim_saturacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_saturacion (
    pk_saturacion bigint,
    sk_saturacion double precision NOT NULL,
    saturacion bigint,
    valido_desde timestamp without time zone,
    valido_hasta timestamp without time zone,
    version double precision
);


ALTER TABLE public.dim_saturacion OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16982)
-- Name: fact_rep_general; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fact_rep_general (
    sk_persona integer NOT NULL,
    sk_diagnostico integer NOT NULL,
    sk_saturacion integer NOT NULL,
    sk_fecha double precision NOT NULL,
    pico_anterior bigint,
    variable_objetivo bigint,
    tasa_tal bigint,
    buques bigint,
    pendiente bigint
);


ALTER TABLE public.fact_rep_general OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16985)
-- Name: tb_auto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_auto (
    id_auto integer NOT NULL,
    id_per integer,
    placa_auto text,
    anio_auto integer
);


ALTER TABLE public.tb_auto OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16991)
-- Name: tb_auto_id_auto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_auto_id_auto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_auto_id_auto_seq OWNER TO postgres;

--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 210
-- Name: tb_auto_id_auto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_auto_id_auto_seq OWNED BY public.tb_auto.id_auto;


--
-- TOC entry 211 (class 1259 OID 16993)
-- Name: tb_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_menu (
    id_men integer NOT NULL,
    nombre_men text,
    tipo_men text,
    submenu_men integer,
    id_rol integer
);


ALTER TABLE public.tb_menu OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16999)
-- Name: tb_menu_id_men_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_menu_id_men_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_menu_id_men_seq OWNER TO postgres;

--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 212
-- Name: tb_menu_id_men_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_menu_id_men_seq OWNED BY public.tb_menu.id_men;


--
-- TOC entry 213 (class 1259 OID 17001)
-- Name: tb_persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_persona (
    id_perf integer NOT NULL,
    nombre_per text,
    ciudad_per text,
    edad_per integer,
    estadocivil_per text
);


ALTER TABLE public.tb_persona OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17007)
-- Name: tb_persona_id_perf_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_persona_id_perf_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_persona_id_perf_seq OWNER TO postgres;

--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 214
-- Name: tb_persona_id_perf_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_persona_id_perf_seq OWNED BY public.tb_persona.id_perf;


--
-- TOC entry 215 (class 1259 OID 17009)
-- Name: tb_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_rol (
    id_rol integer NOT NULL,
    descripcion_rol text
);


ALTER TABLE public.tb_rol OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17015)
-- Name: tb_rol_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_rol_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_rol_id_rol_seq OWNER TO postgres;

--
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 216
-- Name: tb_rol_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_rol_id_rol_seq OWNED BY public.tb_rol.id_rol;


--
-- TOC entry 217 (class 1259 OID 17017)
-- Name: tb_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_usuario (
    id_per integer NOT NULL,
    nombre_per text,
    ciudad_per text,
    edad_per integer,
    estadocivil_per text,
    correo_per text,
    clave_per text
);


ALTER TABLE public.tb_usuario OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17023)
-- Name: tb_usuario_id_per_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_usuario_id_per_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_usuario_id_per_seq OWNER TO postgres;

--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 218
-- Name: tb_usuario_id_per_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_usuario_id_per_seq OWNED BY public.tb_usuario.id_per;


--
-- TOC entry 219 (class 1259 OID 17025)
-- Name: tb_usuariolog; Type: TABLE; Schema: public; Owner: pg_write_server_files
--

CREATE TABLE public.tb_usuariolog (
    id_us integer NOT NULL,
    correo_us text,
    clave_us text,
    estado_us boolean NOT NULL,
    id_per integer NOT NULL,
    id_rol integer NOT NULL
);


ALTER TABLE public.tb_usuariolog OWNER TO pg_write_server_files;

--
-- TOC entry 220 (class 1259 OID 17031)
-- Name: tb_usuariolog_id_us_seq; Type: SEQUENCE; Schema: public; Owner: pg_write_server_files
--

CREATE SEQUENCE public.tb_usuariolog_id_us_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_usuariolog_id_us_seq OWNER TO pg_write_server_files;

--
-- TOC entry 3141 (class 0 OID 0)
-- Dependencies: 220
-- Name: tb_usuariolog_id_us_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pg_write_server_files
--

ALTER SEQUENCE public.tb_usuariolog_id_us_seq OWNED BY public.tb_usuariolog.id_us;


--
-- TOC entry 2919 (class 2604 OID 17033)
-- Name: tb_auditoria id_aud; Type: DEFAULT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria.tb_auditoria ALTER COLUMN id_aud SET DEFAULT nextval('auditoria.tb_auditoria_id_aud_seq'::regclass);


--
-- TOC entry 2920 (class 2604 OID 17034)
-- Name: tb_auto id_auto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_auto ALTER COLUMN id_auto SET DEFAULT nextval('public.tb_auto_id_auto_seq'::regclass);


--
-- TOC entry 2921 (class 2604 OID 17035)
-- Name: tb_menu id_men; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_menu ALTER COLUMN id_men SET DEFAULT nextval('public.tb_menu_id_men_seq'::regclass);


--
-- TOC entry 2922 (class 2604 OID 17036)
-- Name: tb_persona id_perf; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_persona ALTER COLUMN id_perf SET DEFAULT nextval('public.tb_persona_id_perf_seq'::regclass);


--
-- TOC entry 2923 (class 2604 OID 17037)
-- Name: tb_rol id_rol; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_rol ALTER COLUMN id_rol SET DEFAULT nextval('public.tb_rol_id_rol_seq'::regclass);


--
-- TOC entry 2924 (class 2604 OID 17038)
-- Name: tb_usuario id_per; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario ALTER COLUMN id_per SET DEFAULT nextval('public.tb_usuario_id_per_seq'::regclass);


--
-- TOC entry 2925 (class 2604 OID 17039)
-- Name: tb_usuariolog id_us; Type: DEFAULT; Schema: public; Owner: pg_write_server_files
--

ALTER TABLE ONLY public.tb_usuariolog ALTER COLUMN id_us SET DEFAULT nextval('public.tb_usuariolog_id_us_seq'::regclass);


--
-- TOC entry 3110 (class 0 OID 16959)
-- Dependencies: 201
-- Data for Name: tb_auditoria; Type: TABLE DATA; Schema: auditoria; Owner: postgres
--

COPY auditoria.tb_auditoria (id_aud, tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud) FROM stdin;
38	tb_usuariolog	U	(4,mafer@gmail.com,123,f,4,2)	(4,mafer@gmail.com,456,f,4,2)	2021-07-24	postgres
39	tb_usuario	I	\N	(6,juanito,ibarra,45,Soltero,juanito@gmail.com,123)	2021-07-24	postgres
40	tb_usuario	I	\N	(5,juanito,ibarra,45,Soltero,juanito@gmail.com,123)	2021-07-24	postgres
41	tb_usuariolog	I	\N	(5,juanito@gmail.com,123,f,5,1)	2021-07-24	postgres
43	tb_usuariolog	D	(5,juanito@gmail.com,123,f,5,1)	\N	2021-07-24	postgres
44	tb_usuario	D	(6,juanito,ibarra,45,Soltero,juanito@gmail.com,123)	\N	2021-07-24	postgres
45	tb_usuario	D	(5,juanito,ibarra,45,Soltero,juanito@gmail.com,123)	\N	2021-07-24	postgres
46	tb_usuario	U	(1,"Alison Perez",Quito,21,Soltero,aperez@gmail.com,123)	(1,"Alison Perez",Quito,21,Soltero,aperez@gmail.com,1234)	2021-07-24	postgres
47	tb_usuario	U	(2,"Laura Jimenez",Ibarra,26,Soltero,ljimenez@hotmail.com,123)	(2,"Laura Jimenez",Ibarra,26,Soltero,ljimenez@hotmail.com,1234)	2021-07-24	postgres
48	tb_usuario	U	(3,Brian,Quito,23,Soltero,brian@gmail.com,123)	(3,Brian,Quito,23,Soltero,brian@gmail.com,1234)	2021-07-24	postgres
49	tb_usuario	U	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,123)	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,1234)	2021-07-24	postgres
50	tb_usuario	U	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,1234)	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,12345)	2021-07-24	postgres
51	tb_usuario	I	\N	(5,Anthony,Quito,23,Casado,anthony@gmail.com,123)	2021-07-25	postgres
52	tb_usuariolog	I	\N	(6,anthony@gmail.com,123,t,5,1)	2021-07-25	postgres
53	tb_usuariolog	U	(4,mafer@gmail.com,456,f,4,2)	(4,anthony@gmail.com,123,t,5,1)	2021-07-25	postgres
54	tb_usuariolog	D	(6,anthony@gmail.com,123,t,5,1)	\N	2021-07-25	postgres
55	tb_usuariolog	D	(4,anthony@gmail.com,123,t,5,1)	\N	2021-07-25	postgres
56	tb_usuario	D	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,12345)	\N	2021-07-25	postgres
57	tb_usuario	D	(5,Anthony,Quito,23,Casado,anthony@gmail.com,123)	\N	2021-07-25	postgres
58	tb_usuario	I	\N	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,amafer123)	2021-07-25	postgres
59	tb_usuariolog	I	\N	(4,mafer@gmail.com,amafer123,t,4,1)	2021-07-25	postgres
60	tb_usuariolog	U	(3,brian@gmail.com,123,f,3,2)	(3,mafer@gmail.com,amafer123,t,4,1)	2021-07-25	postgres
61	tb_usuariolog	D	(4,mafer@gmail.com,amafer123,t,4,1)	\N	2021-07-25	postgres
62	tb_usuariolog	U	(3,mafer@gmail.com,amafer123,t,4,1)	(3,mafer@gmail.com,amafer123,t,3,1)	2021-07-25	postgres
63	tb_usuario	D	(4,Mafer,Quito,21,Soltero,mafer@gmail.com,amafer123)	\N	2021-07-25	postgres
64	tb_usuariolog	U	(3,mafer@gmail.com,amafer123,t,3,1)	(3,mafer@gmail.com,123,t,3,1)	2021-07-25	postgres
65	tb_usuariolog	U	(3,mafer@gmail.com,123,t,3,1)	(3,mafer@gmail.com,123,f,3,1)	2021-07-25	postgres
66	tb_usuariolog	U	(1,aperez@gmail.com,aperez,t,1,1)	(1,aperez@gmail.com,123,t,1,1)	2021-07-25	postgres
67	tb_usuariolog	U	(1,aperez@gmail.com,123,t,1,1)	(1,aperez@gmail.com,1234,t,1,1)	2021-07-25	postgres
68	tb_usuariolog	U	(1,aperez@gmail.com,1234,t,1,1)	(1,aperez@gmail.com,1234,f,1,1)	2021-07-25	postgres
69	tb_usuariolog	U	(1,aperez@gmail.com,1234,f,1,1)	(1,aperez@gmail.com,1234,t,1,1)	2021-07-25	postgres
70	tb_usuariolog	U	(1,aperez@gmail.com,1234,t,1,1)	(1,aperez@gmail.com,1234,f,1,1)	2021-07-25	postgres
71	tb_usuariolog	U	(1,aperez@gmail.com,1234,f,1,1)	(1,aperez@gmail.com,1234,t,1,1)	2021-07-25	postgres
72	tb_usuario	I	\N	(4,juanito,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
73	tb_usuariolog	I	\N	(4,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
74	tb_usuariolog	U	(3,mafer@gmail.com,123,f,3,1)	(3,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
75	tb_usuario	I	\N	(5,andres,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
76	tb_usuariolog	I	\N	(5,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
77	tb_usuariolog	D	(4,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
78	tb_usuariolog	D	(3,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
79	tb_usuariolog	D	(5,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
80	tb_usuario	D	(3,Brian,Quito,23,Soltero,brian@gmail.com,1234)	\N	2021-07-25	postgres
81	tb_usuario	D	(4,juanito,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
82	tb_usuario	D	(5,andres,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
83	tb_usuario	I	\N	(6,andres,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
84	tb_usuario	D	(6,andres,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
85	tb_usuario	I	\N	(3,andres,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
86	tb_usuario	I	\N	(4,andres,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
87	tb_usuariolog	I	\N	(4,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
88	tb_usuariolog	I	\N	(5,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
89	tb_usuario	I	\N	(5,andres,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
90	tb_usuariolog	I	\N	(6,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
91	tb_usuariolog	I	\N	(7,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
92	tb_usuario	I	\N	(6,miguel,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
93	tb_usuariolog	I	\N	(8,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
94	tb_usuariolog	I	\N	(9,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
96	tb_usuariolog	D	(4,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
97	tb_usuariolog	D	(5,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
98	tb_usuariolog	D	(6,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
99	tb_usuariolog	D	(7,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
100	tb_usuariolog	D	(8,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
101	tb_usuariolog	D	(9,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
102	tb_usuario	D	(3,andres,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
103	tb_usuario	D	(4,andres,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
104	tb_usuario	D	(5,andres,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
105	tb_usuario	D	(6,miguel,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
106	tb_usuario	I	\N	(3,miguel,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
107	tb_usuario	I	\N	(4,miguel,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
108	tb_usuariolog	I	\N	(4,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
109	tb_usuariolog	I	\N	(5,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
110	tb_usuario	I	\N	(5,miguel,Quito,45,Soltero,juanito@gmail.com,123)	2021-07-25	postgres
111	tb_usuariolog	I	\N	(6,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
112	tb_usuariolog	I	\N	(7,juanito@gmail.com,123,t,4,2)	2021-07-25	postgres
113	tb_usuariolog	D	(4,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
114	tb_usuariolog	D	(5,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
115	tb_usuariolog	D	(6,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
116	tb_usuariolog	D	(7,juanito@gmail.com,123,t,4,2)	\N	2021-07-25	postgres
117	tb_usuario	D	(3,miguel,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
118	tb_usuario	D	(4,miguel,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
119	tb_usuario	D	(5,miguel,Quito,45,Soltero,juanito@gmail.com,123)	\N	2021-07-25	postgres
120	tb_usuariolog	U	(2,ljimenez@hotmail.com,ljimenez,f,2,2)	(2,ljimenez@hotmail.com,ljimenez,t,2,2)	2021-07-25	postgres
121	tb_usuariolog	U	(2,ljimenez@hotmail.com,ljimenez,t,2,2)	(2,ljimenez@hotmail.com,ljimenez,f,2,2)	2021-07-25	postgres
122	tb_usuariolog	U	(1,aperez@gmail.com,1234,t,1,1)	(1,aperez@gmail.com,aperezito,t,1,1)	2021-07-25	postgres
123	tb_usuario	I	\N	(3,Damian,Quito,23,Casado,damian@gmail.com,123)	2021-07-25	postgres
124	tb_usuariolog	I	\N	(3,damian@gmail.com,123,t,3,2)	2021-07-25	postgres
125	tb_usuario	I	\N	(4,Daniel,Quito,34,Casado,daniel@gmail.com,123)	2021-07-25	postgres
126	tb_usuariolog	I	\N	(4,daniel@gmail.com,123,t,4,2)	2021-07-25	postgres
127	tb_usuariolog	U	(4,daniel@gmail.com,123,t,4,2)	(4,daniel@gmail.com,123,f,4,2)	2021-07-25	postgres
128	tb_usuariolog	U	(4,daniel@gmail.com,123,f,4,2)	(4,daniel@gmail.com,daniel,f,4,2)	2021-07-25	postgres
129	tb_usuario	I	\N	(5,Anthony,Quito,23,Viudo,ant@gmail.com,123)	2021-07-25	postgres
130	tb_usuariolog	I	\N	(5,ant@gmail.com,123,t,5,2)	2021-07-25	postgres
131	tb_usuario	I	\N	(6,Anderson,Quito,18,Casado,anderson@gmail.com,1234567j)	2021-07-26	postgres
132	tb_usuariolog	I	\N	(6,anderson@gmail.com,1234567j,t,6,2)	2021-07-26	postgres
133	tb_usuariolog	U	(6,anderson@gmail.com,1234567j,t,6,2)	(6,anderson@gmail.com,anderson123,t,6,2)	2021-07-26	postgres
134	tb_usuariolog	U	(3,damian@gmail.com,123,t,3,2)	(3,damian@gmail.com,damian123,t,3,2)	2021-07-26	postgres
135	tb_usuario	I	\N	(7,Gustavo,Quito,59,Casado,gnavas@ups.edu.ec,gnavas123)	2021-07-26	postgres
136	tb_usuariolog	I	\N	(7,gnavas@ups.edu.ec,gnavas123,t,7,2)	2021-07-26	postgres
137	tb_usuariolog	U	(7,gnavas@ups.edu.ec,gnavas123,t,7,2)	(7,gnavas@ups.edu.ec,nuevacontra,t,7,2)	2021-07-26	postgres
138	tb_usuariolog	U	(7,gnavas@ups.edu.ec,nuevacontra,t,7,2)	(7,gnavas@ups.edu.ec,nuevacontra,f,7,2)	2021-07-26	postgres
\.


--
-- TOC entry 3112 (class 0 OID 16967)
-- Dependencies: 203
-- Data for Name: dim_diagnostico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_diagnostico (pk_diagnostico, sk_diagnostico, presion_art, colesterol, azucar_sangre, result_elect, frec_cardiaca, angina_inducida, dolor_pecho, fecha_diagnostico, valido_desde, valido_hasta, version) FROM stdin;
1	1	145	233	1	0	150	0	3	2018-04-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
2	2	130	250	0	1	187	0	2	2018-04-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
3	3	130	204	0	0	172	0	1	2018-04-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
4	4	120	236	0	1	178	0	1	2018-04-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
5	5	120	354	0	1	163	1	0	2018-04-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
6	6	140	192	0	1	148	0	0	2018-04-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
7	7	140	294	0	0	153	0	1	2018-04-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
8	8	120	263	0	1	173	0	1	2018-04-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
9	9	172	199	1	1	162	0	2	2018-04-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
10	10	150	168	0	1	174	0	2	2018-04-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
11	11	140	239	0	1	160	0	0	2018-04-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
12	12	130	275	0	1	139	0	2	2018-04-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
13	13	130	266	0	1	171	0	1	2018-04-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
14	14	110	211	0	0	144	1	3	2018-04-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
15	15	150	283	1	0	162	0	3	2018-04-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
16	16	120	219	0	1	158	0	2	2018-04-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
17	17	120	340	0	1	172	0	2	2018-04-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
18	18	150	226	0	1	114	0	3	2018-04-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
19	19	150	247	0	1	171	0	0	2018-04-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
20	20	140	239	0	1	151	0	3	2018-05-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
21	21	135	234	0	1	161	0	0	2018-05-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
22	22	130	233	0	1	179	1	2	2018-05-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
23	23	140	226	0	1	178	0	0	2018-05-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
24	24	150	243	1	1	137	1	2	2018-05-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
25	25	140	199	0	1	178	1	3	2018-05-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
26	26	160	302	0	1	162	0	1	2018-05-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
27	27	150	212	1	1	157	0	2	2018-05-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
28	28	110	175	0	1	123	0	2	2018-05-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
29	29	140	417	1	0	157	0	2	2018-05-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
30	30	130	197	1	0	152	0	2	2018-05-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
31	31	105	198	0	1	168	0	1	2018-05-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
32	32	120	177	0	1	140	0	0	2018-05-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
33	33	130	219	0	0	188	0	1	2018-05-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
34	34	125	273	0	0	152	0	2	2018-05-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
35	35	125	213	0	0	125	1	3	2018-05-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
36	36	142	177	0	0	160	1	2	2018-05-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
37	37	135	304	1	1	170	0	2	2018-05-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
38	38	150	232	0	0	165	0	2	2018-05-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
39	39	155	269	0	1	148	0	2	2018-05-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
40	40	160	360	0	0	151	0	2	2018-05-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
41	41	140	308	0	0	142	0	2	2018-05-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
42	42	130	245	0	0	180	0	1	2018-05-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
43	43	104	208	0	0	148	1	0	2018-05-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
44	44	130	264	0	0	143	0	0	2018-05-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
45	45	140	321	0	0	182	0	2	2018-05-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
46	46	120	325	0	1	172	0	1	2018-05-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
47	47	140	235	0	0	180	0	2	2018-05-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
48	48	138	257	0	0	156	0	2	2018-05-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
49	49	128	216	0	0	115	0	2	2018-05-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
50	50	138	234	0	0	160	0	0	2018-05-31 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
51	51	130	256	0	0	149	0	2	2018-06-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
52	52	120	302	0	0	151	0	0	2018-06-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
53	53	130	231	0	1	146	0	2	2018-06-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
54	54	108	141	0	1	175	0	2	2018-06-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
55	55	135	252	0	0	172	0	2	2018-06-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
56	56	134	201	0	1	158	0	1	2018-06-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
57	57	122	222	0	0	186	0	0	2018-06-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
58	58	115	260	0	0	185	0	0	2018-06-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
59	59	118	182	0	0	174	0	3	2018-06-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
60	60	128	303	0	0	159	0	0	2018-06-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
61	61	110	265	1	0	130	0	2	2018-06-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
62	62	108	309	0	1	156	0	1	2018-06-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
63	63	118	186	0	0	190	0	3	2018-06-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
64	64	135	203	0	1	132	0	1	2018-06-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
65	65	140	211	1	0	165	0	2	2018-06-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
66	66	138	183	0	1	182	0	0	2018-06-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
67	67	100	222	0	1	143	1	2	2018-06-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
68	68	130	234	0	0	175	0	1	2018-06-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
69	69	120	220	0	1	170	0	1	2018-06-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
70	70	124	209	0	1	163	0	0	2018-06-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
71	71	120	258	0	0	147	0	2	2018-06-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
72	72	94	227	0	1	154	1	2	2018-06-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
73	73	130	204	0	0	202	0	1	2018-06-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
74	74	140	261	0	0	186	1	0	2018-06-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
75	75	122	213	0	1	165	0	2	2018-06-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
76	76	135	250	0	0	161	0	1	2018-06-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
77	77	125	245	1	0	166	0	2	2018-06-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
78	78	140	221	0	1	164	1	1	2018-06-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
79	79	128	205	1	1	184	0	1	2018-06-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
80	80	105	240	0	0	154	1	2	2018-06-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
81	81	112	250	0	1	179	0	2	2018-07-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
82	82	128	308	0	0	170	0	1	2018-07-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
83	83	102	318	0	1	160	0	2	2018-07-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
84	84	152	298	1	1	178	0	3	2018-07-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
85	85	102	265	0	0	122	0	0	2018-07-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
86	86	115	564	0	0	160	0	2	2018-07-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
87	87	118	277	0	1	151	0	2	2018-07-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
88	88	101	197	1	1	156	0	1	2018-07-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
89	89	110	214	0	1	158	0	2	2018-07-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
90	90	100	248	0	0	122	0	0	2018-07-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
91	91	124	255	1	1	175	0	2	2018-07-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
92	92	132	207	0	1	168	1	0	2018-07-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
93	93	138	223	0	1	169	0	2	2018-07-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
94	94	132	288	1	0	159	1	1	2018-07-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
95	95	112	160	0	1	138	0	1	2018-07-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
96	96	142	226	0	0	111	1	0	2018-07-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
97	97	140	394	0	0	157	0	0	2018-07-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
98	98	108	233	1	1	147	0	0	2018-07-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
99	99	130	315	0	1	162	0	2	2018-07-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
100	100	130	246	1	0	173	0	2	2018-07-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
101	101	148	244	0	0	178	0	3	2018-07-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
102	102	178	270	0	0	145	0	3	2018-07-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
103	103	140	195	0	1	179	0	1	2018-07-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
104	104	120	240	1	1	194	0	2	2018-07-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
105	105	129	196	0	1	163	0	2	2018-07-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
106	106	120	211	0	0	115	0	2	2018-07-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
107	107	160	234	1	0	131	0	3	2018-07-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
108	108	138	236	0	0	152	1	0	2018-07-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
109	109	120	244	0	1	162	0	1	2018-07-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
110	110	110	254	0	0	159	0	0	2018-07-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
111	111	180	325	0	1	154	1	0	2018-07-31 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
112	112	150	126	1	1	173	0	2	2018-08-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
113	113	140	313	0	1	133	0	2	2018-08-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
114	114	110	211	0	1	161	0	0	2018-08-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
115	115	130	262	0	1	155	0	1	2018-08-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
116	116	120	215	0	1	170	0	2	2018-08-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
117	117	130	214	0	0	168	0	2	2018-08-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
118	118	120	193	0	0	162	0	3	2018-08-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
119	119	105	204	0	1	172	0	1	2018-08-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
120	120	138	243	0	0	152	1	0	2018-08-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
121	121	130	303	0	1	122	0	0	2018-08-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
122	122	138	271	0	0	182	0	0	2018-08-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
123	123	112	268	0	0	172	1	2	2018-08-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
124	124	108	267	0	0	167	0	2	2018-08-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
125	125	94	199	0	1	179	0	2	2018-08-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
126	126	118	210	0	1	192	0	1	2018-08-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
127	127	112	204	0	1	143	0	0	2018-08-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
128	128	152	277	0	1	172	0	2	2018-08-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
129	129	136	196	0	0	169	0	2	2018-08-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
130	130	120	269	0	0	121	1	1	2018-08-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
131	131	160	201	0	1	163	0	2	2018-08-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
132	132	134	271	0	1	162	0	1	2018-08-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
133	133	120	295	0	1	162	0	1	2018-08-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
134	134	110	235	0	1	153	0	1	2018-08-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
135	135	126	306	0	1	163	0	1	2018-08-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
136	136	130	269	0	1	163	0	0	2018-08-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
137	137	120	178	1	1	96	0	2	2018-08-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
138	138	128	208	1	0	140	0	1	2018-08-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
139	139	110	201	0	1	126	1	0	2018-08-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
140	140	128	263	0	1	105	1	0	2018-08-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
141	141	120	295	0	0	157	0	2	2018-08-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
142	142	115	303	0	1	181	0	0	2018-08-31 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
143	143	120	209	0	1	173	0	2	2018-09-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
144	144	106	223	0	1	142	0	0	2018-09-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
145	145	140	197	0	2	116	0	2	2018-09-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
146	146	156	245	0	0	143	0	1	2018-09-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
147	147	118	242	0	1	149	0	2	2018-09-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
148	148	150	240	0	1	171	0	3	2018-09-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
149	149	120	226	0	1	169	0	2	2018-09-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
150	150	130	180	0	1	150	0	2	2018-09-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
151	151	160	228	0	0	138	0	0	2018-09-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
152	152	112	149	0	1	125	0	0	2018-09-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
153	153	170	227	0	0	155	0	3	2018-09-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
154	154	146	278	0	0	152	0	2	2018-09-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
155	155	138	220	0	1	152	0	2	2018-09-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
156	156	130	197	0	1	131	0	0	2018-09-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
157	157	130	253	0	1	179	0	2	2018-09-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
158	158	122	192	0	1	174	0	1	2018-09-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
159	159	125	220	0	1	144	0	1	2018-09-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
160	160	130	221	0	0	163	0	1	2018-09-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
161	161	120	240	0	1	169	0	1	2018-09-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
162	162	132	342	0	1	166	0	1	2018-09-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
163	163	120	157	0	1	182	0	1	2018-09-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
164	164	138	175	0	1	173	0	2	2018-09-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
165	165	138	175	0	1	173	0	2	2018-09-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
166	166	160	286	0	0	108	1	0	2018-09-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
167	167	120	229	0	0	129	1	0	2018-09-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
168	168	140	268	0	0	160	0	0	2018-09-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
169	169	130	254	0	0	147	0	0	2018-09-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
170	170	140	203	1	0	155	1	0	2018-09-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
171	171	130	256	1	0	142	1	2	2018-09-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
172	172	110	229	0	1	168	0	1	2018-09-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
173	173	120	284	0	0	160	0	1	2018-10-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
174	174	132	224	0	0	173	0	2	2018-10-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
175	175	130	206	0	0	132	1	0	2018-10-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
176	176	110	167	0	0	114	1	0	2018-10-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
177	177	117	230	1	1	160	1	0	2018-10-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
178	178	140	335	0	1	158	0	2	2018-10-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
179	179	120	177	0	0	120	1	0	2018-10-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
180	180	150	276	0	0	112	1	0	2018-10-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
181	181	132	353	0	1	132	1	0	2018-10-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
182	182	150	225	0	0	114	0	0	2018-10-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
183	183	130	330	0	0	169	0	0	2018-10-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
184	184	112	230	0	0	165	0	2	2018-10-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
185	185	150	243	0	0	128	0	0	2018-10-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
186	186	112	290	0	0	153	0	0	2018-10-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
187	187	130	253	0	1	144	1	0	2018-10-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
188	188	124	266	0	0	109	1	0	2018-10-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
189	189	140	233	0	1	163	0	2	2018-10-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
190	190	110	172	0	0	158	0	0	2018-10-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
191	191	130	305	0	1	142	1	0	2018-10-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
192	192	128	216	0	0	131	1	0	2018-10-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
193	193	120	188	0	1	113	0	0	2018-10-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
194	194	145	282	0	0	142	1	0	2018-10-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
195	195	140	185	0	0	155	0	2	2018-10-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
196	196	170	326	0	0	140	1	0	2018-10-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
197	197	150	231	0	1	147	0	2	2018-10-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
198	198	125	254	1	1	163	0	0	2018-10-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
199	199	120	267	0	1	99	1	0	2018-10-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
200	200	110	248	0	0	158	0	0	2018-10-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
201	201	110	197	0	0	177	0	0	2018-10-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
202	202	125	258	0	0	141	1	0	2018-10-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
203	203	150	270	0	0	111	1	0	2018-10-31 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
204	204	180	274	1	0	150	1	2	2018-11-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
205	205	160	164	0	0	145	0	0	2018-11-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
206	206	128	255	0	1	161	1	0	2018-11-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
207	207	110	239	0	0	142	1	0	2018-11-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
208	208	150	258	0	0	157	0	0	2018-11-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
209	209	120	188	0	1	139	0	2	2018-11-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
210	210	140	177	0	1	162	1	0	2018-11-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
211	211	128	229	0	0	150	0	2	2018-11-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
212	212	120	260	0	1	140	1	0	2018-11-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
213	213	118	219	0	1	140	0	0	2018-11-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
214	214	145	307	0	0	146	1	0	2018-11-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
215	215	125	249	1	0	144	1	0	2018-11-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
216	216	132	341	1	0	136	1	0	2018-11-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
217	217	130	263	0	1	97	0	2	2018-11-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
218	218	130	330	1	0	132	1	0	2018-11-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
219	219	135	254	0	0	127	0	0	2018-11-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
220	220	130	256	1	0	150	1	0	2018-11-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
221	221	150	407	0	0	154	0	0	2018-11-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
222	222	140	217	0	1	111	1	0	2018-11-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
223	223	138	282	1	0	174	0	3	2018-11-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
224	224	200	288	1	0	133	1	0	2018-11-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
225	225	110	239	0	1	126	1	0	2018-11-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
226	226	145	174	0	1	125	1	0	2018-11-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
227	227	120	281	0	0	103	0	1	2018-11-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
228	228	120	198	0	1	130	1	0	2018-11-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
229	229	170	288	0	0	159	0	3	2018-11-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
230	230	125	309	0	1	131	1	2	2018-11-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
231	231	108	243	0	1	152	0	2	2018-11-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
232	232	165	289	1	0	124	0	0	2018-11-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
233	233	160	289	0	0	145	1	0	2018-11-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
234	234	120	246	0	0	96	1	0	2018-12-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
235	235	130	322	0	0	109	0	0	2018-12-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
236	236	140	299	0	1	173	1	0	2018-12-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
237	237	125	300	0	0	171	0	0	2018-12-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
238	238	140	293	0	0	170	0	0	2018-12-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
239	239	125	304	0	0	162	1	0	2018-12-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
240	240	126	282	0	0	156	1	0	2018-12-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
241	241	160	269	0	1	112	1	2	2018-12-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
242	242	174	249	0	1	143	1	0	2018-12-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
243	243	145	212	0	0	132	0	0	2018-12-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
244	244	152	274	0	1	88	1	0	2018-12-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
245	245	132	184	0	0	105	1	0	2018-12-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
246	246	124	274	0	0	166	0	0	2018-12-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
247	247	134	409	0	0	150	1	0	2018-12-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
248	248	160	246	0	1	120	1	1	2018-12-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
249	249	192	283	0	0	195	0	1	2018-12-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
250	250	140	254	0	0	146	0	2	2018-12-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
251	251	140	298	0	1	122	1	0	2018-12-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
252	252	132	247	1	0	143	1	0	2018-12-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
253	253	138	294	1	1	106	0	0	2018-12-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
254	254	100	299	0	0	125	1	0	2018-12-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
255	255	160	273	0	0	125	0	3	2018-12-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
256	256	142	309	0	0	147	1	0	2018-12-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
257	257	128	259	0	0	130	1	0	2018-12-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
258	258	144	200	0	0	126	1	0	2018-12-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
259	259	150	244	0	1	154	1	0	2018-12-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
260	260	120	231	0	1	182	1	3	2018-12-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
261	261	178	228	1	1	165	1	0	2018-12-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
262	262	112	230	0	1	160	0	0	2018-12-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
263	263	123	282	0	1	95	1	0	2018-12-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
264	264	108	269	0	1	169	1	0	2018-12-31 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
265	265	110	206	0	0	108	1	0	2019-01-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
266	266	112	212	0	0	132	1	0	2019-01-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
267	267	180	327	0	2	117	1	0	2019-01-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
268	268	118	149	0	0	126	0	2	2019-01-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
269	269	122	286	0	0	116	1	0	2019-01-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
270	270	130	283	1	0	103	1	0	2019-01-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
271	271	120	249	0	0	144	0	0	2019-01-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
272	272	134	234	0	1	145	0	3	2019-01-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
273	273	120	237	0	1	71	0	0	2019-01-09 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
274	274	100	234	0	1	156	0	0	2019-01-10 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
275	275	110	275	0	0	118	1	0	2019-01-11 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
276	276	125	212	0	1	168	0	0	2019-01-12 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
277	277	146	218	0	1	105	0	0	2019-01-13 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
278	278	124	261	0	1	141	0	1	2019-01-14 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
279	279	136	319	1	0	152	0	1	2019-01-15 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
280	280	138	166	0	0	125	1	0	2019-01-16 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
281	281	136	315	0	1	125	1	0	2019-01-17 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
282	282	128	204	1	1	156	1	0	2019-01-18 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
283	283	126	218	1	1	134	0	2	2019-01-19 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
284	284	152	223	0	1	181	0	0	2019-01-20 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
285	285	140	207	0	0	138	1	0	2019-01-21 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
286	286	140	311	0	1	120	1	0	2019-01-22 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
287	287	134	204	0	1	162	0	3	2019-01-23 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
288	288	154	232	0	0	164	0	1	2019-01-24 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
289	289	110	335	0	1	143	1	0	2019-01-25 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
290	290	128	205	0	2	130	1	0	2019-01-26 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
291	291	148	203	0	1	161	0	0	2019-01-27 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
292	292	114	318	0	2	140	0	0	2019-01-28 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
293	293	170	225	1	0	146	1	0	2019-01-29 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
294	294	152	212	0	0	150	0	2	2019-01-30 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
295	295	120	169	0	1	144	1	0	2019-01-31 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
296	296	140	187	0	0	144	1	0	2019-02-01 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
297	297	124	197	0	1	136	1	0	2019-02-02 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
298	298	164	176	1	0	90	0	0	2019-02-03 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
299	299	140	241	0	1	123	1	0	2019-02-04 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
300	300	110	264	0	1	132	0	3	2019-02-05 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
301	301	144	193	1	1	141	0	0	2019-02-06 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
302	302	130	131	0	1	115	1	0	2019-02-07 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
303	303	130	236	0	0	174	0	1	2019-02-08 00:00:00	2018-01-01 00:00:00	2025-12-31 00:00:00	1
\.


--
-- TOC entry 3113 (class 0 OID 16970)
-- Dependencies: 204
-- Data for Name: dim_fecha; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_fecha (sk_fecha, anio, trimestre, mes, dia, fecha, semestre, nombre_semestre, nombre_trimestre, nombre_mes) FROM stdin;
20180102	2018	1	1	2	2018-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20180103	2018	1	1	3	2018-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20180104	2018	1	1	4	2018-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20180105	2018	1	1	5	2018-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20180106	2018	1	1	6	2018-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20180107	2018	1	1	7	2018-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20180108	2018	1	1	8	2018-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20180109	2018	1	1	9	2018-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20180110	2018	1	1	10	2018-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20180111	2018	1	1	11	2018-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20180112	2018	1	1	12	2018-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20180113	2018	1	1	13	2018-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20180114	2018	1	1	14	2018-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20180115	2018	1	1	15	2018-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20180116	2018	1	1	16	2018-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20180117	2018	1	1	17	2018-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20180118	2018	1	1	18	2018-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20180119	2018	1	1	19	2018-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20180120	2018	1	1	20	2018-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20180121	2018	1	1	21	2018-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20180122	2018	1	1	22	2018-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20180123	2018	1	1	23	2018-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20180124	2018	1	1	24	2018-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20180125	2018	1	1	25	2018-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20180126	2018	1	1	26	2018-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20180127	2018	1	1	27	2018-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20180128	2018	1	1	28	2018-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20180129	2018	1	1	29	2018-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20180130	2018	1	1	30	2018-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20180131	2018	1	1	31	2018-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20180201	2018	1	2	1	2018-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180202	2018	1	2	2	2018-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180203	2018	1	2	3	2018-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180204	2018	1	2	4	2018-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180205	2018	1	2	5	2018-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180206	2018	1	2	6	2018-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180207	2018	1	2	7	2018-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180208	2018	1	2	8	2018-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180209	2018	1	2	9	2018-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180210	2018	1	2	10	2018-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180211	2018	1	2	11	2018-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180212	2018	1	2	12	2018-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180213	2018	1	2	13	2018-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180214	2018	1	2	14	2018-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180215	2018	1	2	15	2018-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180216	2018	1	2	16	2018-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180217	2018	1	2	17	2018-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180218	2018	1	2	18	2018-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180219	2018	1	2	19	2018-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180220	2018	1	2	20	2018-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180221	2018	1	2	21	2018-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180222	2018	1	2	22	2018-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180223	2018	1	2	23	2018-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180224	2018	1	2	24	2018-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180225	2018	1	2	25	2018-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180226	2018	1	2	26	2018-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180227	2018	1	2	27	2018-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180228	2018	1	2	28	2018-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20180301	2018	1	3	1	2018-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20180302	2018	1	3	2	2018-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20180303	2018	1	3	3	2018-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20180304	2018	1	3	4	2018-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20180305	2018	1	3	5	2018-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20180306	2018	1	3	6	2018-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20180307	2018	1	3	7	2018-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20180308	2018	1	3	8	2018-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20180309	2018	1	3	9	2018-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20180310	2018	1	3	10	2018-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20180311	2018	1	3	11	2018-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20180312	2018	1	3	12	2018-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20180313	2018	1	3	13	2018-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20180314	2018	1	3	14	2018-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20180315	2018	1	3	15	2018-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20180316	2018	1	3	16	2018-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20180317	2018	1	3	17	2018-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20180318	2018	1	3	18	2018-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20180319	2018	1	3	19	2018-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20180320	2018	1	3	20	2018-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20180321	2018	1	3	21	2018-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20180322	2018	1	3	22	2018-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20180323	2018	1	3	23	2018-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20180324	2018	1	3	24	2018-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20180325	2018	1	3	25	2018-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20180326	2018	1	3	26	2018-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20180327	2018	1	3	27	2018-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20180328	2018	1	3	28	2018-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20180329	2018	1	3	29	2018-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20180330	2018	1	3	30	2018-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20180331	2018	1	3	31	2018-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20180401	2018	2	4	1	2018-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180402	2018	2	4	2	2018-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180403	2018	2	4	3	2018-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180404	2018	2	4	4	2018-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180405	2018	2	4	5	2018-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180406	2018	2	4	6	2018-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180407	2018	2	4	7	2018-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180408	2018	2	4	8	2018-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180409	2018	2	4	9	2018-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180410	2018	2	4	10	2018-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180411	2018	2	4	11	2018-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180412	2018	2	4	12	2018-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180413	2018	2	4	13	2018-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180414	2018	2	4	14	2018-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180415	2018	2	4	15	2018-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180416	2018	2	4	16	2018-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180417	2018	2	4	17	2018-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180418	2018	2	4	18	2018-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180419	2018	2	4	19	2018-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180420	2018	2	4	20	2018-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180421	2018	2	4	21	2018-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180422	2018	2	4	22	2018-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180423	2018	2	4	23	2018-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180424	2018	2	4	24	2018-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180425	2018	2	4	25	2018-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180426	2018	2	4	26	2018-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180427	2018	2	4	27	2018-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180428	2018	2	4	28	2018-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180429	2018	2	4	29	2018-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180430	2018	2	4	30	2018-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20180501	2018	2	5	1	2018-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20180502	2018	2	5	2	2018-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20180503	2018	2	5	3	2018-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20180504	2018	2	5	4	2018-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20180505	2018	2	5	5	2018-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20180506	2018	2	5	6	2018-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20180507	2018	2	5	7	2018-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20180508	2018	2	5	8	2018-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20180509	2018	2	5	9	2018-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20180510	2018	2	5	10	2018-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20180511	2018	2	5	11	2018-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20180512	2018	2	5	12	2018-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20180513	2018	2	5	13	2018-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20180514	2018	2	5	14	2018-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20180515	2018	2	5	15	2018-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20180516	2018	2	5	16	2018-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20180517	2018	2	5	17	2018-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20180518	2018	2	5	18	2018-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20180519	2018	2	5	19	2018-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20180520	2018	2	5	20	2018-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20180521	2018	2	5	21	2018-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20180522	2018	2	5	22	2018-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20180523	2018	2	5	23	2018-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20180524	2018	2	5	24	2018-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20180525	2018	2	5	25	2018-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20180526	2018	2	5	26	2018-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20180527	2018	2	5	27	2018-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20180528	2018	2	5	28	2018-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20180529	2018	2	5	29	2018-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20180530	2018	2	5	30	2018-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20180531	2018	2	5	31	2018-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20180601	2018	2	6	1	2018-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180602	2018	2	6	2	2018-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180603	2018	2	6	3	2018-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180604	2018	2	6	4	2018-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180605	2018	2	6	5	2018-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180606	2018	2	6	6	2018-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180607	2018	2	6	7	2018-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180608	2018	2	6	8	2018-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180609	2018	2	6	9	2018-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180610	2018	2	6	10	2018-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180611	2018	2	6	11	2018-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180612	2018	2	6	12	2018-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180613	2018	2	6	13	2018-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180614	2018	2	6	14	2018-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180615	2018	2	6	15	2018-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180616	2018	2	6	16	2018-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180617	2018	2	6	17	2018-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180618	2018	2	6	18	2018-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180619	2018	2	6	19	2018-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180620	2018	2	6	20	2018-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180621	2018	2	6	21	2018-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180622	2018	2	6	22	2018-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180623	2018	2	6	23	2018-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180624	2018	2	6	24	2018-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180625	2018	2	6	25	2018-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180626	2018	2	6	26	2018-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180627	2018	2	6	27	2018-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180628	2018	2	6	28	2018-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180629	2018	2	6	29	2018-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180630	2018	2	6	30	2018-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20180701	2018	3	7	1	2018-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20180702	2018	3	7	2	2018-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20180703	2018	3	7	3	2018-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20180704	2018	3	7	4	2018-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20180705	2018	3	7	5	2018-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20180706	2018	3	7	6	2018-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20180707	2018	3	7	7	2018-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20180708	2018	3	7	8	2018-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20180709	2018	3	7	9	2018-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20180710	2018	3	7	10	2018-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20180711	2018	3	7	11	2018-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20180712	2018	3	7	12	2018-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20180713	2018	3	7	13	2018-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20180714	2018	3	7	14	2018-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20180715	2018	3	7	15	2018-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20180716	2018	3	7	16	2018-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20180717	2018	3	7	17	2018-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20180718	2018	3	7	18	2018-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20180719	2018	3	7	19	2018-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20180720	2018	3	7	20	2018-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20180721	2018	3	7	21	2018-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20180722	2018	3	7	22	2018-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20180723	2018	3	7	23	2018-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20180724	2018	3	7	24	2018-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20180725	2018	3	7	25	2018-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20180726	2018	3	7	26	2018-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20180727	2018	3	7	27	2018-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20180728	2018	3	7	28	2018-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20180729	2018	3	7	29	2018-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20180730	2018	3	7	30	2018-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20180731	2018	3	7	31	2018-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20180801	2018	3	8	1	2018-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180802	2018	3	8	2	2018-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180803	2018	3	8	3	2018-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180804	2018	3	8	4	2018-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180805	2018	3	8	5	2018-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180806	2018	3	8	6	2018-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180807	2018	3	8	7	2018-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180808	2018	3	8	8	2018-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180809	2018	3	8	9	2018-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180810	2018	3	8	10	2018-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180811	2018	3	8	11	2018-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180812	2018	3	8	12	2018-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180813	2018	3	8	13	2018-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180814	2018	3	8	14	2018-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180815	2018	3	8	15	2018-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180816	2018	3	8	16	2018-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180817	2018	3	8	17	2018-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180818	2018	3	8	18	2018-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180819	2018	3	8	19	2018-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180820	2018	3	8	20	2018-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180821	2018	3	8	21	2018-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180822	2018	3	8	22	2018-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180823	2018	3	8	23	2018-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180824	2018	3	8	24	2018-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180825	2018	3	8	25	2018-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180826	2018	3	8	26	2018-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180827	2018	3	8	27	2018-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180828	2018	3	8	28	2018-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180829	2018	3	8	29	2018-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180830	2018	3	8	30	2018-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180831	2018	3	8	31	2018-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20180901	2018	3	9	1	2018-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180902	2018	3	9	2	2018-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180903	2018	3	9	3	2018-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180904	2018	3	9	4	2018-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180905	2018	3	9	5	2018-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180906	2018	3	9	6	2018-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180907	2018	3	9	7	2018-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180908	2018	3	9	8	2018-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180909	2018	3	9	9	2018-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180910	2018	3	9	10	2018-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180911	2018	3	9	11	2018-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180912	2018	3	9	12	2018-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180913	2018	3	9	13	2018-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180914	2018	3	9	14	2018-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180915	2018	3	9	15	2018-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180916	2018	3	9	16	2018-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180917	2018	3	9	17	2018-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180918	2018	3	9	18	2018-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180919	2018	3	9	19	2018-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180920	2018	3	9	20	2018-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180921	2018	3	9	21	2018-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180922	2018	3	9	22	2018-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180923	2018	3	9	23	2018-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180924	2018	3	9	24	2018-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180925	2018	3	9	25	2018-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180926	2018	3	9	26	2018-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180927	2018	3	9	27	2018-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180928	2018	3	9	28	2018-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180929	2018	3	9	29	2018-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20180930	2018	3	9	30	2018-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20181001	2018	4	10	1	2018-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181002	2018	4	10	2	2018-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181003	2018	4	10	3	2018-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181004	2018	4	10	4	2018-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181005	2018	4	10	5	2018-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181006	2018	4	10	6	2018-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181007	2018	4	10	7	2018-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181008	2018	4	10	8	2018-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181009	2018	4	10	9	2018-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181010	2018	4	10	10	2018-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181011	2018	4	10	11	2018-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181012	2018	4	10	12	2018-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181013	2018	4	10	13	2018-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181014	2018	4	10	14	2018-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181015	2018	4	10	15	2018-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181016	2018	4	10	16	2018-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181017	2018	4	10	17	2018-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181018	2018	4	10	18	2018-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181019	2018	4	10	19	2018-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181020	2018	4	10	20	2018-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181021	2018	4	10	21	2018-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181022	2018	4	10	22	2018-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181023	2018	4	10	23	2018-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181024	2018	4	10	24	2018-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181025	2018	4	10	25	2018-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181026	2018	4	10	26	2018-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181027	2018	4	10	27	2018-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181028	2018	4	10	28	2018-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181029	2018	4	10	29	2018-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181030	2018	4	10	30	2018-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181031	2018	4	10	31	2018-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20181101	2018	4	11	1	2018-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181102	2018	4	11	2	2018-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181103	2018	4	11	3	2018-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181104	2018	4	11	4	2018-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181105	2018	4	11	5	2018-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181106	2018	4	11	6	2018-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181107	2018	4	11	7	2018-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181108	2018	4	11	8	2018-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181109	2018	4	11	9	2018-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181110	2018	4	11	10	2018-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181111	2018	4	11	11	2018-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181112	2018	4	11	12	2018-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181113	2018	4	11	13	2018-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181114	2018	4	11	14	2018-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181115	2018	4	11	15	2018-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181116	2018	4	11	16	2018-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181117	2018	4	11	17	2018-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181118	2018	4	11	18	2018-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181119	2018	4	11	19	2018-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181120	2018	4	11	20	2018-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181121	2018	4	11	21	2018-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181122	2018	4	11	22	2018-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181123	2018	4	11	23	2018-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181124	2018	4	11	24	2018-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181125	2018	4	11	25	2018-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181126	2018	4	11	26	2018-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181127	2018	4	11	27	2018-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181128	2018	4	11	28	2018-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181129	2018	4	11	29	2018-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181130	2018	4	11	30	2018-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20181201	2018	4	12	1	2018-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181202	2018	4	12	2	2018-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181203	2018	4	12	3	2018-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181204	2018	4	12	4	2018-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181205	2018	4	12	5	2018-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181206	2018	4	12	6	2018-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181207	2018	4	12	7	2018-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181208	2018	4	12	8	2018-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181209	2018	4	12	9	2018-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181210	2018	4	12	10	2018-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181211	2018	4	12	11	2018-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181212	2018	4	12	12	2018-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181213	2018	4	12	13	2018-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181214	2018	4	12	14	2018-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181215	2018	4	12	15	2018-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181216	2018	4	12	16	2018-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181217	2018	4	12	17	2018-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181218	2018	4	12	18	2018-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181219	2018	4	12	19	2018-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181220	2018	4	12	20	2018-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181221	2018	4	12	21	2018-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181222	2018	4	12	22	2018-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181223	2018	4	12	23	2018-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181224	2018	4	12	24	2018-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181225	2018	4	12	25	2018-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181226	2018	4	12	26	2018-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181227	2018	4	12	27	2018-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181228	2018	4	12	28	2018-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181229	2018	4	12	29	2018-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181230	2018	4	12	30	2018-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20181231	2018	4	12	31	2018-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20190101	2019	1	1	1	2019-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20190102	2019	1	1	2	2019-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20190103	2019	1	1	3	2019-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20190104	2019	1	1	4	2019-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20190105	2019	1	1	5	2019-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20190106	2019	1	1	6	2019-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20190107	2019	1	1	7	2019-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20190108	2019	1	1	8	2019-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20190109	2019	1	1	9	2019-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20190110	2019	1	1	10	2019-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20190111	2019	1	1	11	2019-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20190112	2019	1	1	12	2019-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20190113	2019	1	1	13	2019-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20190114	2019	1	1	14	2019-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20190115	2019	1	1	15	2019-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20190116	2019	1	1	16	2019-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20190117	2019	1	1	17	2019-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20190118	2019	1	1	18	2019-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20190119	2019	1	1	19	2019-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20190120	2019	1	1	20	2019-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20190121	2019	1	1	21	2019-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20190122	2019	1	1	22	2019-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20190123	2019	1	1	23	2019-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20190124	2019	1	1	24	2019-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20190125	2019	1	1	25	2019-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20190126	2019	1	1	26	2019-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20190127	2019	1	1	27	2019-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20190128	2019	1	1	28	2019-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20190129	2019	1	1	29	2019-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20190130	2019	1	1	30	2019-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20190131	2019	1	1	31	2019-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20190201	2019	1	2	1	2019-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190202	2019	1	2	2	2019-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190203	2019	1	2	3	2019-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190204	2019	1	2	4	2019-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190205	2019	1	2	5	2019-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190206	2019	1	2	6	2019-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190207	2019	1	2	7	2019-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190208	2019	1	2	8	2019-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190209	2019	1	2	9	2019-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190210	2019	1	2	10	2019-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190211	2019	1	2	11	2019-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190212	2019	1	2	12	2019-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190213	2019	1	2	13	2019-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190214	2019	1	2	14	2019-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190215	2019	1	2	15	2019-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190216	2019	1	2	16	2019-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190217	2019	1	2	17	2019-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190218	2019	1	2	18	2019-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190219	2019	1	2	19	2019-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190220	2019	1	2	20	2019-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190221	2019	1	2	21	2019-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190222	2019	1	2	22	2019-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190223	2019	1	2	23	2019-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190224	2019	1	2	24	2019-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190225	2019	1	2	25	2019-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190226	2019	1	2	26	2019-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190227	2019	1	2	27	2019-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190228	2019	1	2	28	2019-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20190301	2019	1	3	1	2019-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20190302	2019	1	3	2	2019-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20190303	2019	1	3	3	2019-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20190304	2019	1	3	4	2019-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20190305	2019	1	3	5	2019-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20190306	2019	1	3	6	2019-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20190307	2019	1	3	7	2019-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20190308	2019	1	3	8	2019-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20190309	2019	1	3	9	2019-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20190310	2019	1	3	10	2019-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20190311	2019	1	3	11	2019-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20190312	2019	1	3	12	2019-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20190313	2019	1	3	13	2019-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20190314	2019	1	3	14	2019-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20190315	2019	1	3	15	2019-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20190316	2019	1	3	16	2019-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20190317	2019	1	3	17	2019-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20190318	2019	1	3	18	2019-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20190319	2019	1	3	19	2019-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20190320	2019	1	3	20	2019-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20190321	2019	1	3	21	2019-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20190322	2019	1	3	22	2019-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20190323	2019	1	3	23	2019-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20190324	2019	1	3	24	2019-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20190325	2019	1	3	25	2019-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20190326	2019	1	3	26	2019-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20190327	2019	1	3	27	2019-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20190328	2019	1	3	28	2019-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20190329	2019	1	3	29	2019-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20190330	2019	1	3	30	2019-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20190331	2019	1	3	31	2019-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20190401	2019	2	4	1	2019-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190402	2019	2	4	2	2019-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190403	2019	2	4	3	2019-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190404	2019	2	4	4	2019-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190405	2019	2	4	5	2019-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190406	2019	2	4	6	2019-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190407	2019	2	4	7	2019-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190408	2019	2	4	8	2019-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190409	2019	2	4	9	2019-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190410	2019	2	4	10	2019-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190411	2019	2	4	11	2019-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190412	2019	2	4	12	2019-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190413	2019	2	4	13	2019-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190414	2019	2	4	14	2019-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190415	2019	2	4	15	2019-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190416	2019	2	4	16	2019-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190417	2019	2	4	17	2019-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190418	2019	2	4	18	2019-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190419	2019	2	4	19	2019-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190420	2019	2	4	20	2019-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190421	2019	2	4	21	2019-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190422	2019	2	4	22	2019-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190423	2019	2	4	23	2019-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190424	2019	2	4	24	2019-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190425	2019	2	4	25	2019-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190426	2019	2	4	26	2019-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190427	2019	2	4	27	2019-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190428	2019	2	4	28	2019-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190429	2019	2	4	29	2019-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190430	2019	2	4	30	2019-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20190501	2019	2	5	1	2019-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20190502	2019	2	5	2	2019-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20190503	2019	2	5	3	2019-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20190504	2019	2	5	4	2019-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20190505	2019	2	5	5	2019-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20190506	2019	2	5	6	2019-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20190507	2019	2	5	7	2019-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20190508	2019	2	5	8	2019-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20190509	2019	2	5	9	2019-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20190510	2019	2	5	10	2019-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20190511	2019	2	5	11	2019-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20190512	2019	2	5	12	2019-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20190513	2019	2	5	13	2019-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20190514	2019	2	5	14	2019-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20190515	2019	2	5	15	2019-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20190516	2019	2	5	16	2019-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20190517	2019	2	5	17	2019-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20190518	2019	2	5	18	2019-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20190519	2019	2	5	19	2019-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20190520	2019	2	5	20	2019-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20190521	2019	2	5	21	2019-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20190522	2019	2	5	22	2019-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20190523	2019	2	5	23	2019-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20190524	2019	2	5	24	2019-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20190525	2019	2	5	25	2019-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20190526	2019	2	5	26	2019-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20190527	2019	2	5	27	2019-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20190528	2019	2	5	28	2019-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20190529	2019	2	5	29	2019-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20190530	2019	2	5	30	2019-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20190531	2019	2	5	31	2019-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20190601	2019	2	6	1	2019-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190602	2019	2	6	2	2019-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190603	2019	2	6	3	2019-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190604	2019	2	6	4	2019-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190605	2019	2	6	5	2019-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190606	2019	2	6	6	2019-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190607	2019	2	6	7	2019-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190608	2019	2	6	8	2019-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190609	2019	2	6	9	2019-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190610	2019	2	6	10	2019-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190611	2019	2	6	11	2019-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190612	2019	2	6	12	2019-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190613	2019	2	6	13	2019-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190614	2019	2	6	14	2019-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190615	2019	2	6	15	2019-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190616	2019	2	6	16	2019-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190617	2019	2	6	17	2019-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190618	2019	2	6	18	2019-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190619	2019	2	6	19	2019-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190620	2019	2	6	20	2019-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190621	2019	2	6	21	2019-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190622	2019	2	6	22	2019-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190623	2019	2	6	23	2019-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190624	2019	2	6	24	2019-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190625	2019	2	6	25	2019-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190626	2019	2	6	26	2019-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190627	2019	2	6	27	2019-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190628	2019	2	6	28	2019-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190629	2019	2	6	29	2019-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190630	2019	2	6	30	2019-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20190701	2019	3	7	1	2019-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20190702	2019	3	7	2	2019-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20190703	2019	3	7	3	2019-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20190704	2019	3	7	4	2019-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20190705	2019	3	7	5	2019-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20190706	2019	3	7	6	2019-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20190707	2019	3	7	7	2019-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20190708	2019	3	7	8	2019-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20190709	2019	3	7	9	2019-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20190710	2019	3	7	10	2019-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20190711	2019	3	7	11	2019-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20190712	2019	3	7	12	2019-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20190713	2019	3	7	13	2019-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20190714	2019	3	7	14	2019-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20190715	2019	3	7	15	2019-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20190716	2019	3	7	16	2019-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20190717	2019	3	7	17	2019-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20190718	2019	3	7	18	2019-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20190719	2019	3	7	19	2019-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20190720	2019	3	7	20	2019-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20190721	2019	3	7	21	2019-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20190722	2019	3	7	22	2019-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20190723	2019	3	7	23	2019-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20190724	2019	3	7	24	2019-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20190725	2019	3	7	25	2019-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20190726	2019	3	7	26	2019-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20190727	2019	3	7	27	2019-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20190728	2019	3	7	28	2019-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20190729	2019	3	7	29	2019-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20190730	2019	3	7	30	2019-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20190731	2019	3	7	31	2019-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20190801	2019	3	8	1	2019-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190802	2019	3	8	2	2019-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190803	2019	3	8	3	2019-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190804	2019	3	8	4	2019-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190805	2019	3	8	5	2019-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190806	2019	3	8	6	2019-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190807	2019	3	8	7	2019-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190808	2019	3	8	8	2019-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190809	2019	3	8	9	2019-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190810	2019	3	8	10	2019-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190811	2019	3	8	11	2019-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190812	2019	3	8	12	2019-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190813	2019	3	8	13	2019-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190814	2019	3	8	14	2019-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190815	2019	3	8	15	2019-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190816	2019	3	8	16	2019-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190817	2019	3	8	17	2019-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190818	2019	3	8	18	2019-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190819	2019	3	8	19	2019-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190820	2019	3	8	20	2019-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190821	2019	3	8	21	2019-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190822	2019	3	8	22	2019-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190823	2019	3	8	23	2019-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190824	2019	3	8	24	2019-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190825	2019	3	8	25	2019-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190826	2019	3	8	26	2019-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190827	2019	3	8	27	2019-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190828	2019	3	8	28	2019-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190829	2019	3	8	29	2019-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190830	2019	3	8	30	2019-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190831	2019	3	8	31	2019-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20190901	2019	3	9	1	2019-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190902	2019	3	9	2	2019-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190903	2019	3	9	3	2019-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190904	2019	3	9	4	2019-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190905	2019	3	9	5	2019-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190906	2019	3	9	6	2019-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190907	2019	3	9	7	2019-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190908	2019	3	9	8	2019-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190909	2019	3	9	9	2019-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190910	2019	3	9	10	2019-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190911	2019	3	9	11	2019-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190912	2019	3	9	12	2019-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190913	2019	3	9	13	2019-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190914	2019	3	9	14	2019-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190915	2019	3	9	15	2019-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190916	2019	3	9	16	2019-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190917	2019	3	9	17	2019-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190918	2019	3	9	18	2019-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190919	2019	3	9	19	2019-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190920	2019	3	9	20	2019-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190921	2019	3	9	21	2019-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190922	2019	3	9	22	2019-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190923	2019	3	9	23	2019-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190924	2019	3	9	24	2019-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190925	2019	3	9	25	2019-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190926	2019	3	9	26	2019-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190927	2019	3	9	27	2019-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190928	2019	3	9	28	2019-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190929	2019	3	9	29	2019-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20190930	2019	3	9	30	2019-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20191001	2019	4	10	1	2019-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191002	2019	4	10	2	2019-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191003	2019	4	10	3	2019-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191004	2019	4	10	4	2019-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191005	2019	4	10	5	2019-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191006	2019	4	10	6	2019-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191007	2019	4	10	7	2019-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191008	2019	4	10	8	2019-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191009	2019	4	10	9	2019-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191010	2019	4	10	10	2019-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191011	2019	4	10	11	2019-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191012	2019	4	10	12	2019-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191013	2019	4	10	13	2019-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191014	2019	4	10	14	2019-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191015	2019	4	10	15	2019-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191016	2019	4	10	16	2019-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191017	2019	4	10	17	2019-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191018	2019	4	10	18	2019-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191019	2019	4	10	19	2019-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191020	2019	4	10	20	2019-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191021	2019	4	10	21	2019-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191022	2019	4	10	22	2019-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191023	2019	4	10	23	2019-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191024	2019	4	10	24	2019-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191025	2019	4	10	25	2019-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191026	2019	4	10	26	2019-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191027	2019	4	10	27	2019-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191028	2019	4	10	28	2019-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191029	2019	4	10	29	2019-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191030	2019	4	10	30	2019-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191031	2019	4	10	31	2019-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20191101	2019	4	11	1	2019-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191102	2019	4	11	2	2019-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191103	2019	4	11	3	2019-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191104	2019	4	11	4	2019-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191105	2019	4	11	5	2019-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191106	2019	4	11	6	2019-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191107	2019	4	11	7	2019-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191108	2019	4	11	8	2019-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191109	2019	4	11	9	2019-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191110	2019	4	11	10	2019-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191111	2019	4	11	11	2019-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191112	2019	4	11	12	2019-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191113	2019	4	11	13	2019-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191114	2019	4	11	14	2019-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191115	2019	4	11	15	2019-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191116	2019	4	11	16	2019-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191117	2019	4	11	17	2019-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191118	2019	4	11	18	2019-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191119	2019	4	11	19	2019-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191120	2019	4	11	20	2019-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191121	2019	4	11	21	2019-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191122	2019	4	11	22	2019-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191123	2019	4	11	23	2019-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191124	2019	4	11	24	2019-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191125	2019	4	11	25	2019-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191126	2019	4	11	26	2019-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191127	2019	4	11	27	2019-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191128	2019	4	11	28	2019-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191129	2019	4	11	29	2019-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191130	2019	4	11	30	2019-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20191201	2019	4	12	1	2019-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191202	2019	4	12	2	2019-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191203	2019	4	12	3	2019-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191204	2019	4	12	4	2019-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191205	2019	4	12	5	2019-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191206	2019	4	12	6	2019-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191207	2019	4	12	7	2019-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191208	2019	4	12	8	2019-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191209	2019	4	12	9	2019-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191210	2019	4	12	10	2019-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191211	2019	4	12	11	2019-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191212	2019	4	12	12	2019-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191213	2019	4	12	13	2019-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191214	2019	4	12	14	2019-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191215	2019	4	12	15	2019-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191216	2019	4	12	16	2019-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191217	2019	4	12	17	2019-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191218	2019	4	12	18	2019-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191219	2019	4	12	19	2019-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191220	2019	4	12	20	2019-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191221	2019	4	12	21	2019-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191222	2019	4	12	22	2019-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191223	2019	4	12	23	2019-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191224	2019	4	12	24	2019-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191225	2019	4	12	25	2019-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191226	2019	4	12	26	2019-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191227	2019	4	12	27	2019-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191228	2019	4	12	28	2019-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191229	2019	4	12	29	2019-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191230	2019	4	12	30	2019-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20191231	2019	4	12	31	2019-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20200101	2020	1	1	1	2020-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20200102	2020	1	1	2	2020-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20200103	2020	1	1	3	2020-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20200104	2020	1	1	4	2020-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20200105	2020	1	1	5	2020-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20200106	2020	1	1	6	2020-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20200107	2020	1	1	7	2020-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20200108	2020	1	1	8	2020-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20200109	2020	1	1	9	2020-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20200110	2020	1	1	10	2020-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20200111	2020	1	1	11	2020-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20200112	2020	1	1	12	2020-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20200113	2020	1	1	13	2020-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20200114	2020	1	1	14	2020-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20200115	2020	1	1	15	2020-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20200116	2020	1	1	16	2020-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20200117	2020	1	1	17	2020-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20200118	2020	1	1	18	2020-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20200119	2020	1	1	19	2020-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20200120	2020	1	1	20	2020-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20200121	2020	1	1	21	2020-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20200122	2020	1	1	22	2020-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20200123	2020	1	1	23	2020-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20200124	2020	1	1	24	2020-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20200125	2020	1	1	25	2020-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20200126	2020	1	1	26	2020-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20200127	2020	1	1	27	2020-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20200128	2020	1	1	28	2020-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20200129	2020	1	1	29	2020-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20200130	2020	1	1	30	2020-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20200131	2020	1	1	31	2020-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20200201	2020	1	2	1	2020-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200202	2020	1	2	2	2020-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200203	2020	1	2	3	2020-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200204	2020	1	2	4	2020-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200205	2020	1	2	5	2020-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200206	2020	1	2	6	2020-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200207	2020	1	2	7	2020-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200208	2020	1	2	8	2020-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200209	2020	1	2	9	2020-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200210	2020	1	2	10	2020-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200211	2020	1	2	11	2020-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200212	2020	1	2	12	2020-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200213	2020	1	2	13	2020-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200214	2020	1	2	14	2020-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200215	2020	1	2	15	2020-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200216	2020	1	2	16	2020-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200217	2020	1	2	17	2020-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200218	2020	1	2	18	2020-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200219	2020	1	2	19	2020-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200220	2020	1	2	20	2020-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200221	2020	1	2	21	2020-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200222	2020	1	2	22	2020-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200223	2020	1	2	23	2020-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200224	2020	1	2	24	2020-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200225	2020	1	2	25	2020-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200226	2020	1	2	26	2020-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200227	2020	1	2	27	2020-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200228	2020	1	2	28	2020-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200229	2020	1	2	29	2020-02-29 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20200301	2020	1	3	1	2020-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20200302	2020	1	3	2	2020-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20200303	2020	1	3	3	2020-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20200304	2020	1	3	4	2020-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20200305	2020	1	3	5	2020-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20200306	2020	1	3	6	2020-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20200307	2020	1	3	7	2020-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20200308	2020	1	3	8	2020-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20200309	2020	1	3	9	2020-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20200310	2020	1	3	10	2020-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20200311	2020	1	3	11	2020-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20200312	2020	1	3	12	2020-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20200313	2020	1	3	13	2020-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20200314	2020	1	3	14	2020-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20200315	2020	1	3	15	2020-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20200316	2020	1	3	16	2020-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20200317	2020	1	3	17	2020-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20200318	2020	1	3	18	2020-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20200319	2020	1	3	19	2020-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20200320	2020	1	3	20	2020-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20200321	2020	1	3	21	2020-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20200322	2020	1	3	22	2020-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20200323	2020	1	3	23	2020-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20200324	2020	1	3	24	2020-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20200325	2020	1	3	25	2020-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20200326	2020	1	3	26	2020-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20200327	2020	1	3	27	2020-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20200328	2020	1	3	28	2020-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20200329	2020	1	3	29	2020-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20200330	2020	1	3	30	2020-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20200331	2020	1	3	31	2020-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20200401	2020	2	4	1	2020-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200402	2020	2	4	2	2020-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200403	2020	2	4	3	2020-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200404	2020	2	4	4	2020-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200405	2020	2	4	5	2020-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200406	2020	2	4	6	2020-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200407	2020	2	4	7	2020-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200408	2020	2	4	8	2020-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200409	2020	2	4	9	2020-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200410	2020	2	4	10	2020-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200411	2020	2	4	11	2020-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200412	2020	2	4	12	2020-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200413	2020	2	4	13	2020-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200414	2020	2	4	14	2020-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200415	2020	2	4	15	2020-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200416	2020	2	4	16	2020-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200417	2020	2	4	17	2020-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200418	2020	2	4	18	2020-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200419	2020	2	4	19	2020-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200420	2020	2	4	20	2020-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200421	2020	2	4	21	2020-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200422	2020	2	4	22	2020-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200423	2020	2	4	23	2020-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200424	2020	2	4	24	2020-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200425	2020	2	4	25	2020-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200426	2020	2	4	26	2020-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200427	2020	2	4	27	2020-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200428	2020	2	4	28	2020-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200429	2020	2	4	29	2020-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200430	2020	2	4	30	2020-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20200501	2020	2	5	1	2020-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20200502	2020	2	5	2	2020-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20200503	2020	2	5	3	2020-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20200504	2020	2	5	4	2020-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20200505	2020	2	5	5	2020-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20200506	2020	2	5	6	2020-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20200507	2020	2	5	7	2020-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20200508	2020	2	5	8	2020-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20200509	2020	2	5	9	2020-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20200510	2020	2	5	10	2020-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20200511	2020	2	5	11	2020-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20200512	2020	2	5	12	2020-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20200513	2020	2	5	13	2020-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20200514	2020	2	5	14	2020-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20200515	2020	2	5	15	2020-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20200516	2020	2	5	16	2020-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20200517	2020	2	5	17	2020-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20200518	2020	2	5	18	2020-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20200519	2020	2	5	19	2020-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20200520	2020	2	5	20	2020-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20200521	2020	2	5	21	2020-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20200522	2020	2	5	22	2020-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20200523	2020	2	5	23	2020-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20200524	2020	2	5	24	2020-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20200525	2020	2	5	25	2020-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20200526	2020	2	5	26	2020-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20200527	2020	2	5	27	2020-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20200528	2020	2	5	28	2020-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20200529	2020	2	5	29	2020-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20200530	2020	2	5	30	2020-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20200531	2020	2	5	31	2020-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20200601	2020	2	6	1	2020-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200602	2020	2	6	2	2020-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200603	2020	2	6	3	2020-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200604	2020	2	6	4	2020-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200605	2020	2	6	5	2020-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200606	2020	2	6	6	2020-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200607	2020	2	6	7	2020-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200608	2020	2	6	8	2020-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200609	2020	2	6	9	2020-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200610	2020	2	6	10	2020-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200611	2020	2	6	11	2020-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200612	2020	2	6	12	2020-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200613	2020	2	6	13	2020-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200614	2020	2	6	14	2020-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200615	2020	2	6	15	2020-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200616	2020	2	6	16	2020-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200617	2020	2	6	17	2020-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200618	2020	2	6	18	2020-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200619	2020	2	6	19	2020-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200620	2020	2	6	20	2020-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200621	2020	2	6	21	2020-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200622	2020	2	6	22	2020-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200623	2020	2	6	23	2020-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200624	2020	2	6	24	2020-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200625	2020	2	6	25	2020-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200626	2020	2	6	26	2020-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200627	2020	2	6	27	2020-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200628	2020	2	6	28	2020-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200629	2020	2	6	29	2020-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200630	2020	2	6	30	2020-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20200701	2020	3	7	1	2020-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20200702	2020	3	7	2	2020-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20200703	2020	3	7	3	2020-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20200704	2020	3	7	4	2020-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20200705	2020	3	7	5	2020-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20200706	2020	3	7	6	2020-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20200707	2020	3	7	7	2020-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20200708	2020	3	7	8	2020-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20200709	2020	3	7	9	2020-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20200710	2020	3	7	10	2020-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20200711	2020	3	7	11	2020-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20200712	2020	3	7	12	2020-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20200713	2020	3	7	13	2020-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20200714	2020	3	7	14	2020-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20200715	2020	3	7	15	2020-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20200716	2020	3	7	16	2020-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20200717	2020	3	7	17	2020-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20200718	2020	3	7	18	2020-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20200719	2020	3	7	19	2020-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20200720	2020	3	7	20	2020-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20200721	2020	3	7	21	2020-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20200722	2020	3	7	22	2020-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20200723	2020	3	7	23	2020-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20200724	2020	3	7	24	2020-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20200725	2020	3	7	25	2020-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20200726	2020	3	7	26	2020-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20200727	2020	3	7	27	2020-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20200728	2020	3	7	28	2020-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20200729	2020	3	7	29	2020-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20200730	2020	3	7	30	2020-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20200731	2020	3	7	31	2020-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20200801	2020	3	8	1	2020-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200802	2020	3	8	2	2020-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200803	2020	3	8	3	2020-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200804	2020	3	8	4	2020-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200805	2020	3	8	5	2020-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200806	2020	3	8	6	2020-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200807	2020	3	8	7	2020-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200808	2020	3	8	8	2020-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200809	2020	3	8	9	2020-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200810	2020	3	8	10	2020-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200811	2020	3	8	11	2020-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200812	2020	3	8	12	2020-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200813	2020	3	8	13	2020-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200814	2020	3	8	14	2020-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200815	2020	3	8	15	2020-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200816	2020	3	8	16	2020-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200817	2020	3	8	17	2020-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200818	2020	3	8	18	2020-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200819	2020	3	8	19	2020-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200820	2020	3	8	20	2020-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200821	2020	3	8	21	2020-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200822	2020	3	8	22	2020-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200823	2020	3	8	23	2020-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200824	2020	3	8	24	2020-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200825	2020	3	8	25	2020-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200826	2020	3	8	26	2020-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200827	2020	3	8	27	2020-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200828	2020	3	8	28	2020-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200829	2020	3	8	29	2020-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200830	2020	3	8	30	2020-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200831	2020	3	8	31	2020-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20200901	2020	3	9	1	2020-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200902	2020	3	9	2	2020-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200903	2020	3	9	3	2020-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200904	2020	3	9	4	2020-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200905	2020	3	9	5	2020-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200906	2020	3	9	6	2020-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200907	2020	3	9	7	2020-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200908	2020	3	9	8	2020-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200909	2020	3	9	9	2020-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200910	2020	3	9	10	2020-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200911	2020	3	9	11	2020-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200912	2020	3	9	12	2020-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200913	2020	3	9	13	2020-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200914	2020	3	9	14	2020-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200915	2020	3	9	15	2020-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200916	2020	3	9	16	2020-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200917	2020	3	9	17	2020-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200918	2020	3	9	18	2020-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200919	2020	3	9	19	2020-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200920	2020	3	9	20	2020-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200921	2020	3	9	21	2020-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200922	2020	3	9	22	2020-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200923	2020	3	9	23	2020-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200924	2020	3	9	24	2020-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200925	2020	3	9	25	2020-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200926	2020	3	9	26	2020-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200927	2020	3	9	27	2020-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200928	2020	3	9	28	2020-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200929	2020	3	9	29	2020-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20200930	2020	3	9	30	2020-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20201001	2020	4	10	1	2020-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201002	2020	4	10	2	2020-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201003	2020	4	10	3	2020-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201004	2020	4	10	4	2020-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201005	2020	4	10	5	2020-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201006	2020	4	10	6	2020-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201007	2020	4	10	7	2020-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201008	2020	4	10	8	2020-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201009	2020	4	10	9	2020-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201010	2020	4	10	10	2020-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201011	2020	4	10	11	2020-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201012	2020	4	10	12	2020-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201013	2020	4	10	13	2020-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201014	2020	4	10	14	2020-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201015	2020	4	10	15	2020-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201016	2020	4	10	16	2020-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201017	2020	4	10	17	2020-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201018	2020	4	10	18	2020-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201019	2020	4	10	19	2020-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201020	2020	4	10	20	2020-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201021	2020	4	10	21	2020-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201022	2020	4	10	22	2020-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201023	2020	4	10	23	2020-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201024	2020	4	10	24	2020-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201025	2020	4	10	25	2020-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201026	2020	4	10	26	2020-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201027	2020	4	10	27	2020-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201028	2020	4	10	28	2020-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201029	2020	4	10	29	2020-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201030	2020	4	10	30	2020-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201031	2020	4	10	31	2020-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20201101	2020	4	11	1	2020-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201102	2020	4	11	2	2020-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201103	2020	4	11	3	2020-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201104	2020	4	11	4	2020-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201105	2020	4	11	5	2020-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201106	2020	4	11	6	2020-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201107	2020	4	11	7	2020-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201108	2020	4	11	8	2020-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201109	2020	4	11	9	2020-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201110	2020	4	11	10	2020-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201111	2020	4	11	11	2020-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201112	2020	4	11	12	2020-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201113	2020	4	11	13	2020-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201114	2020	4	11	14	2020-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201115	2020	4	11	15	2020-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201116	2020	4	11	16	2020-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201117	2020	4	11	17	2020-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201118	2020	4	11	18	2020-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201119	2020	4	11	19	2020-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201120	2020	4	11	20	2020-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201121	2020	4	11	21	2020-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201122	2020	4	11	22	2020-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201123	2020	4	11	23	2020-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201124	2020	4	11	24	2020-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201125	2020	4	11	25	2020-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201126	2020	4	11	26	2020-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201127	2020	4	11	27	2020-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201128	2020	4	11	28	2020-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201129	2020	4	11	29	2020-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201130	2020	4	11	30	2020-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20201201	2020	4	12	1	2020-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201202	2020	4	12	2	2020-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201203	2020	4	12	3	2020-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201204	2020	4	12	4	2020-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201205	2020	4	12	5	2020-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201206	2020	4	12	6	2020-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201207	2020	4	12	7	2020-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201208	2020	4	12	8	2020-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201209	2020	4	12	9	2020-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201210	2020	4	12	10	2020-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201211	2020	4	12	11	2020-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201212	2020	4	12	12	2020-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201213	2020	4	12	13	2020-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201214	2020	4	12	14	2020-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201215	2020	4	12	15	2020-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201216	2020	4	12	16	2020-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201217	2020	4	12	17	2020-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201218	2020	4	12	18	2020-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201219	2020	4	12	19	2020-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201220	2020	4	12	20	2020-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201221	2020	4	12	21	2020-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201222	2020	4	12	22	2020-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201223	2020	4	12	23	2020-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201224	2020	4	12	24	2020-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201225	2020	4	12	25	2020-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201226	2020	4	12	26	2020-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201227	2020	4	12	27	2020-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201228	2020	4	12	28	2020-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201229	2020	4	12	29	2020-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201230	2020	4	12	30	2020-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20201231	2020	4	12	31	2020-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20210101	2021	1	1	1	2021-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20210102	2021	1	1	2	2021-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20210103	2021	1	1	3	2021-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20210104	2021	1	1	4	2021-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20210105	2021	1	1	5	2021-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20210106	2021	1	1	6	2021-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20210107	2021	1	1	7	2021-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20210108	2021	1	1	8	2021-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20210109	2021	1	1	9	2021-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20210110	2021	1	1	10	2021-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20210111	2021	1	1	11	2021-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20210112	2021	1	1	12	2021-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20210113	2021	1	1	13	2021-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20210114	2021	1	1	14	2021-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20210115	2021	1	1	15	2021-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20210116	2021	1	1	16	2021-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20210117	2021	1	1	17	2021-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20210118	2021	1	1	18	2021-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20210119	2021	1	1	19	2021-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20210120	2021	1	1	20	2021-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20210121	2021	1	1	21	2021-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20210122	2021	1	1	22	2021-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20210123	2021	1	1	23	2021-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20210124	2021	1	1	24	2021-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20210125	2021	1	1	25	2021-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20210126	2021	1	1	26	2021-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20210127	2021	1	1	27	2021-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20210128	2021	1	1	28	2021-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20210129	2021	1	1	29	2021-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20210130	2021	1	1	30	2021-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20210131	2021	1	1	31	2021-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20210201	2021	1	2	1	2021-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210202	2021	1	2	2	2021-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210203	2021	1	2	3	2021-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210204	2021	1	2	4	2021-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210205	2021	1	2	5	2021-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210206	2021	1	2	6	2021-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210207	2021	1	2	7	2021-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210208	2021	1	2	8	2021-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210209	2021	1	2	9	2021-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210210	2021	1	2	10	2021-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210211	2021	1	2	11	2021-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210212	2021	1	2	12	2021-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210213	2021	1	2	13	2021-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210214	2021	1	2	14	2021-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210215	2021	1	2	15	2021-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210216	2021	1	2	16	2021-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210217	2021	1	2	17	2021-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210218	2021	1	2	18	2021-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210219	2021	1	2	19	2021-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210220	2021	1	2	20	2021-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210221	2021	1	2	21	2021-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210222	2021	1	2	22	2021-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210223	2021	1	2	23	2021-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210224	2021	1	2	24	2021-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210225	2021	1	2	25	2021-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210226	2021	1	2	26	2021-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210227	2021	1	2	27	2021-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210228	2021	1	2	28	2021-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20210301	2021	1	3	1	2021-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20210302	2021	1	3	2	2021-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20210303	2021	1	3	3	2021-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20210304	2021	1	3	4	2021-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20210305	2021	1	3	5	2021-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20210306	2021	1	3	6	2021-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20210307	2021	1	3	7	2021-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20210308	2021	1	3	8	2021-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20210309	2021	1	3	9	2021-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20210310	2021	1	3	10	2021-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20210311	2021	1	3	11	2021-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20210312	2021	1	3	12	2021-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20210313	2021	1	3	13	2021-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20210314	2021	1	3	14	2021-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20210315	2021	1	3	15	2021-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20210316	2021	1	3	16	2021-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20210317	2021	1	3	17	2021-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20210318	2021	1	3	18	2021-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20210319	2021	1	3	19	2021-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20210320	2021	1	3	20	2021-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20210321	2021	1	3	21	2021-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20210322	2021	1	3	22	2021-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20210323	2021	1	3	23	2021-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20210324	2021	1	3	24	2021-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20210325	2021	1	3	25	2021-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20210326	2021	1	3	26	2021-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20210327	2021	1	3	27	2021-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20210328	2021	1	3	28	2021-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20210329	2021	1	3	29	2021-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20210330	2021	1	3	30	2021-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20210331	2021	1	3	31	2021-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20210401	2021	2	4	1	2021-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210402	2021	2	4	2	2021-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210403	2021	2	4	3	2021-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210404	2021	2	4	4	2021-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210405	2021	2	4	5	2021-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210406	2021	2	4	6	2021-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210407	2021	2	4	7	2021-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210408	2021	2	4	8	2021-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210409	2021	2	4	9	2021-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210410	2021	2	4	10	2021-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210411	2021	2	4	11	2021-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210412	2021	2	4	12	2021-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210413	2021	2	4	13	2021-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210414	2021	2	4	14	2021-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210415	2021	2	4	15	2021-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210416	2021	2	4	16	2021-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210417	2021	2	4	17	2021-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210418	2021	2	4	18	2021-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210419	2021	2	4	19	2021-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210420	2021	2	4	20	2021-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210421	2021	2	4	21	2021-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210422	2021	2	4	22	2021-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210423	2021	2	4	23	2021-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210424	2021	2	4	24	2021-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210425	2021	2	4	25	2021-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210426	2021	2	4	26	2021-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210427	2021	2	4	27	2021-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210428	2021	2	4	28	2021-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210429	2021	2	4	29	2021-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210430	2021	2	4	30	2021-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20210501	2021	2	5	1	2021-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20210502	2021	2	5	2	2021-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20210503	2021	2	5	3	2021-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20210504	2021	2	5	4	2021-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20210505	2021	2	5	5	2021-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20210506	2021	2	5	6	2021-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20210507	2021	2	5	7	2021-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20210508	2021	2	5	8	2021-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20210509	2021	2	5	9	2021-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20210510	2021	2	5	10	2021-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20210511	2021	2	5	11	2021-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20210512	2021	2	5	12	2021-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20210513	2021	2	5	13	2021-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20210514	2021	2	5	14	2021-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20210515	2021	2	5	15	2021-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20210516	2021	2	5	16	2021-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20210517	2021	2	5	17	2021-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20210518	2021	2	5	18	2021-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20210519	2021	2	5	19	2021-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20210520	2021	2	5	20	2021-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20210521	2021	2	5	21	2021-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20210522	2021	2	5	22	2021-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20210523	2021	2	5	23	2021-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20210524	2021	2	5	24	2021-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20210525	2021	2	5	25	2021-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20210526	2021	2	5	26	2021-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20210527	2021	2	5	27	2021-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20210528	2021	2	5	28	2021-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20210529	2021	2	5	29	2021-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20210530	2021	2	5	30	2021-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20210531	2021	2	5	31	2021-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20210601	2021	2	6	1	2021-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210602	2021	2	6	2	2021-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210603	2021	2	6	3	2021-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210604	2021	2	6	4	2021-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210605	2021	2	6	5	2021-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210606	2021	2	6	6	2021-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210607	2021	2	6	7	2021-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210608	2021	2	6	8	2021-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210609	2021	2	6	9	2021-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210610	2021	2	6	10	2021-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210611	2021	2	6	11	2021-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210612	2021	2	6	12	2021-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210613	2021	2	6	13	2021-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210614	2021	2	6	14	2021-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210615	2021	2	6	15	2021-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210616	2021	2	6	16	2021-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210617	2021	2	6	17	2021-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210618	2021	2	6	18	2021-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210619	2021	2	6	19	2021-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210620	2021	2	6	20	2021-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210621	2021	2	6	21	2021-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210622	2021	2	6	22	2021-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210623	2021	2	6	23	2021-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210624	2021	2	6	24	2021-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210625	2021	2	6	25	2021-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210626	2021	2	6	26	2021-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210627	2021	2	6	27	2021-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210628	2021	2	6	28	2021-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210629	2021	2	6	29	2021-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210630	2021	2	6	30	2021-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20210701	2021	3	7	1	2021-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20210702	2021	3	7	2	2021-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20210703	2021	3	7	3	2021-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20210704	2021	3	7	4	2021-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20210705	2021	3	7	5	2021-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20210706	2021	3	7	6	2021-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20210707	2021	3	7	7	2021-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20210708	2021	3	7	8	2021-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20210709	2021	3	7	9	2021-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20210710	2021	3	7	10	2021-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20210711	2021	3	7	11	2021-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20210712	2021	3	7	12	2021-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20210713	2021	3	7	13	2021-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20210714	2021	3	7	14	2021-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20210715	2021	3	7	15	2021-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20210716	2021	3	7	16	2021-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20210717	2021	3	7	17	2021-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20210718	2021	3	7	18	2021-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20210719	2021	3	7	19	2021-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20210720	2021	3	7	20	2021-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20210721	2021	3	7	21	2021-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20210722	2021	3	7	22	2021-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20210723	2021	3	7	23	2021-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20210724	2021	3	7	24	2021-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20210725	2021	3	7	25	2021-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20210726	2021	3	7	26	2021-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20210727	2021	3	7	27	2021-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20210728	2021	3	7	28	2021-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20210729	2021	3	7	29	2021-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20210730	2021	3	7	30	2021-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20210731	2021	3	7	31	2021-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20210801	2021	3	8	1	2021-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210802	2021	3	8	2	2021-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210803	2021	3	8	3	2021-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210804	2021	3	8	4	2021-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210805	2021	3	8	5	2021-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210806	2021	3	8	6	2021-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210807	2021	3	8	7	2021-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210808	2021	3	8	8	2021-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210809	2021	3	8	9	2021-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210810	2021	3	8	10	2021-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210811	2021	3	8	11	2021-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210812	2021	3	8	12	2021-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210813	2021	3	8	13	2021-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210814	2021	3	8	14	2021-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210815	2021	3	8	15	2021-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210816	2021	3	8	16	2021-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210817	2021	3	8	17	2021-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210818	2021	3	8	18	2021-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210819	2021	3	8	19	2021-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210820	2021	3	8	20	2021-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210821	2021	3	8	21	2021-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210822	2021	3	8	22	2021-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210823	2021	3	8	23	2021-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210824	2021	3	8	24	2021-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210825	2021	3	8	25	2021-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210826	2021	3	8	26	2021-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210827	2021	3	8	27	2021-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210828	2021	3	8	28	2021-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210829	2021	3	8	29	2021-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210830	2021	3	8	30	2021-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210831	2021	3	8	31	2021-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20210901	2021	3	9	1	2021-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210902	2021	3	9	2	2021-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210903	2021	3	9	3	2021-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210904	2021	3	9	4	2021-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210905	2021	3	9	5	2021-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210906	2021	3	9	6	2021-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210907	2021	3	9	7	2021-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210908	2021	3	9	8	2021-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210909	2021	3	9	9	2021-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210910	2021	3	9	10	2021-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210911	2021	3	9	11	2021-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210912	2021	3	9	12	2021-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210913	2021	3	9	13	2021-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210914	2021	3	9	14	2021-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210915	2021	3	9	15	2021-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210916	2021	3	9	16	2021-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210917	2021	3	9	17	2021-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210918	2021	3	9	18	2021-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210919	2021	3	9	19	2021-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210920	2021	3	9	20	2021-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210921	2021	3	9	21	2021-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210922	2021	3	9	22	2021-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210923	2021	3	9	23	2021-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210924	2021	3	9	24	2021-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210925	2021	3	9	25	2021-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210926	2021	3	9	26	2021-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210927	2021	3	9	27	2021-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210928	2021	3	9	28	2021-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210929	2021	3	9	29	2021-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20210930	2021	3	9	30	2021-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20211001	2021	4	10	1	2021-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211002	2021	4	10	2	2021-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211003	2021	4	10	3	2021-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211004	2021	4	10	4	2021-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211005	2021	4	10	5	2021-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211006	2021	4	10	6	2021-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211007	2021	4	10	7	2021-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211008	2021	4	10	8	2021-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211009	2021	4	10	9	2021-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211010	2021	4	10	10	2021-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211011	2021	4	10	11	2021-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211012	2021	4	10	12	2021-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211013	2021	4	10	13	2021-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211014	2021	4	10	14	2021-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211015	2021	4	10	15	2021-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211016	2021	4	10	16	2021-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211017	2021	4	10	17	2021-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211018	2021	4	10	18	2021-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211019	2021	4	10	19	2021-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211020	2021	4	10	20	2021-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211021	2021	4	10	21	2021-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211022	2021	4	10	22	2021-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211023	2021	4	10	23	2021-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211024	2021	4	10	24	2021-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211025	2021	4	10	25	2021-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211026	2021	4	10	26	2021-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211027	2021	4	10	27	2021-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211028	2021	4	10	28	2021-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211029	2021	4	10	29	2021-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211030	2021	4	10	30	2021-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211031	2021	4	10	31	2021-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20211101	2021	4	11	1	2021-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211102	2021	4	11	2	2021-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211103	2021	4	11	3	2021-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211104	2021	4	11	4	2021-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211105	2021	4	11	5	2021-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211106	2021	4	11	6	2021-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211107	2021	4	11	7	2021-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211108	2021	4	11	8	2021-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211109	2021	4	11	9	2021-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211110	2021	4	11	10	2021-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211111	2021	4	11	11	2021-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211112	2021	4	11	12	2021-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211113	2021	4	11	13	2021-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211114	2021	4	11	14	2021-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211115	2021	4	11	15	2021-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211116	2021	4	11	16	2021-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211117	2021	4	11	17	2021-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211118	2021	4	11	18	2021-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211119	2021	4	11	19	2021-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211120	2021	4	11	20	2021-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211121	2021	4	11	21	2021-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211122	2021	4	11	22	2021-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211123	2021	4	11	23	2021-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211124	2021	4	11	24	2021-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211125	2021	4	11	25	2021-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211126	2021	4	11	26	2021-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211127	2021	4	11	27	2021-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211128	2021	4	11	28	2021-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211129	2021	4	11	29	2021-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211130	2021	4	11	30	2021-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20211201	2021	4	12	1	2021-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211202	2021	4	12	2	2021-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211203	2021	4	12	3	2021-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211204	2021	4	12	4	2021-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211205	2021	4	12	5	2021-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211206	2021	4	12	6	2021-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211207	2021	4	12	7	2021-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211208	2021	4	12	8	2021-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211209	2021	4	12	9	2021-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211210	2021	4	12	10	2021-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211211	2021	4	12	11	2021-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211212	2021	4	12	12	2021-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211213	2021	4	12	13	2021-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211214	2021	4	12	14	2021-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211215	2021	4	12	15	2021-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211216	2021	4	12	16	2021-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211217	2021	4	12	17	2021-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211218	2021	4	12	18	2021-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211219	2021	4	12	19	2021-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211220	2021	4	12	20	2021-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211221	2021	4	12	21	2021-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211222	2021	4	12	22	2021-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211223	2021	4	12	23	2021-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211224	2021	4	12	24	2021-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211225	2021	4	12	25	2021-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211226	2021	4	12	26	2021-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211227	2021	4	12	27	2021-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211228	2021	4	12	28	2021-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211229	2021	4	12	29	2021-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211230	2021	4	12	30	2021-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20211231	2021	4	12	31	2021-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20220101	2022	1	1	1	2022-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20220102	2022	1	1	2	2022-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20220103	2022	1	1	3	2022-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20220104	2022	1	1	4	2022-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20220105	2022	1	1	5	2022-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20220106	2022	1	1	6	2022-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20220107	2022	1	1	7	2022-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20220108	2022	1	1	8	2022-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20220109	2022	1	1	9	2022-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20220110	2022	1	1	10	2022-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20220111	2022	1	1	11	2022-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20220112	2022	1	1	12	2022-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20220113	2022	1	1	13	2022-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20220114	2022	1	1	14	2022-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20220115	2022	1	1	15	2022-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20220116	2022	1	1	16	2022-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20220117	2022	1	1	17	2022-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20220118	2022	1	1	18	2022-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20220119	2022	1	1	19	2022-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20220120	2022	1	1	20	2022-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20220121	2022	1	1	21	2022-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20220122	2022	1	1	22	2022-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20220123	2022	1	1	23	2022-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20220124	2022	1	1	24	2022-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20220125	2022	1	1	25	2022-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20220126	2022	1	1	26	2022-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20220127	2022	1	1	27	2022-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20220128	2022	1	1	28	2022-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20220129	2022	1	1	29	2022-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20220130	2022	1	1	30	2022-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20220131	2022	1	1	31	2022-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20220201	2022	1	2	1	2022-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220202	2022	1	2	2	2022-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220203	2022	1	2	3	2022-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220204	2022	1	2	4	2022-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220205	2022	1	2	5	2022-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220206	2022	1	2	6	2022-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220207	2022	1	2	7	2022-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220208	2022	1	2	8	2022-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220209	2022	1	2	9	2022-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220210	2022	1	2	10	2022-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220211	2022	1	2	11	2022-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220212	2022	1	2	12	2022-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220213	2022	1	2	13	2022-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220214	2022	1	2	14	2022-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220215	2022	1	2	15	2022-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220216	2022	1	2	16	2022-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220217	2022	1	2	17	2022-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220218	2022	1	2	18	2022-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220219	2022	1	2	19	2022-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220220	2022	1	2	20	2022-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220221	2022	1	2	21	2022-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220222	2022	1	2	22	2022-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220223	2022	1	2	23	2022-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220224	2022	1	2	24	2022-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220225	2022	1	2	25	2022-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220226	2022	1	2	26	2022-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220227	2022	1	2	27	2022-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220228	2022	1	2	28	2022-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20220301	2022	1	3	1	2022-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20220302	2022	1	3	2	2022-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20220303	2022	1	3	3	2022-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20220304	2022	1	3	4	2022-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20220305	2022	1	3	5	2022-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20220306	2022	1	3	6	2022-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20220307	2022	1	3	7	2022-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20220308	2022	1	3	8	2022-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20220309	2022	1	3	9	2022-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20220310	2022	1	3	10	2022-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20220311	2022	1	3	11	2022-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20220312	2022	1	3	12	2022-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20220313	2022	1	3	13	2022-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20220314	2022	1	3	14	2022-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20220315	2022	1	3	15	2022-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20220316	2022	1	3	16	2022-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20220317	2022	1	3	17	2022-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20220318	2022	1	3	18	2022-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20220319	2022	1	3	19	2022-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20220320	2022	1	3	20	2022-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20220321	2022	1	3	21	2022-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20220322	2022	1	3	22	2022-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20220323	2022	1	3	23	2022-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20220324	2022	1	3	24	2022-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20220325	2022	1	3	25	2022-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20220326	2022	1	3	26	2022-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20220327	2022	1	3	27	2022-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20220328	2022	1	3	28	2022-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20220329	2022	1	3	29	2022-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20220330	2022	1	3	30	2022-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20220331	2022	1	3	31	2022-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20220401	2022	2	4	1	2022-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220402	2022	2	4	2	2022-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220403	2022	2	4	3	2022-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220404	2022	2	4	4	2022-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220405	2022	2	4	5	2022-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220406	2022	2	4	6	2022-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220407	2022	2	4	7	2022-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220408	2022	2	4	8	2022-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220409	2022	2	4	9	2022-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220410	2022	2	4	10	2022-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220411	2022	2	4	11	2022-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220412	2022	2	4	12	2022-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220413	2022	2	4	13	2022-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220414	2022	2	4	14	2022-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220415	2022	2	4	15	2022-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220416	2022	2	4	16	2022-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220417	2022	2	4	17	2022-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220418	2022	2	4	18	2022-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220419	2022	2	4	19	2022-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220420	2022	2	4	20	2022-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220421	2022	2	4	21	2022-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220422	2022	2	4	22	2022-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220423	2022	2	4	23	2022-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220424	2022	2	4	24	2022-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220425	2022	2	4	25	2022-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220426	2022	2	4	26	2022-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220427	2022	2	4	27	2022-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220428	2022	2	4	28	2022-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220429	2022	2	4	29	2022-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220430	2022	2	4	30	2022-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20220501	2022	2	5	1	2022-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20220502	2022	2	5	2	2022-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20220503	2022	2	5	3	2022-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20220504	2022	2	5	4	2022-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20220505	2022	2	5	5	2022-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20220506	2022	2	5	6	2022-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20220507	2022	2	5	7	2022-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20220508	2022	2	5	8	2022-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20220509	2022	2	5	9	2022-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20220510	2022	2	5	10	2022-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20220511	2022	2	5	11	2022-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20220512	2022	2	5	12	2022-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20220513	2022	2	5	13	2022-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20220514	2022	2	5	14	2022-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20220515	2022	2	5	15	2022-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20220516	2022	2	5	16	2022-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20220517	2022	2	5	17	2022-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20220518	2022	2	5	18	2022-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20220519	2022	2	5	19	2022-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20220520	2022	2	5	20	2022-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20220521	2022	2	5	21	2022-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20220522	2022	2	5	22	2022-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20220523	2022	2	5	23	2022-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20220524	2022	2	5	24	2022-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20220525	2022	2	5	25	2022-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20220526	2022	2	5	26	2022-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20220527	2022	2	5	27	2022-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20220528	2022	2	5	28	2022-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20220529	2022	2	5	29	2022-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20220530	2022	2	5	30	2022-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20220531	2022	2	5	31	2022-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20220601	2022	2	6	1	2022-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220602	2022	2	6	2	2022-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220603	2022	2	6	3	2022-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220604	2022	2	6	4	2022-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220605	2022	2	6	5	2022-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220606	2022	2	6	6	2022-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220607	2022	2	6	7	2022-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220608	2022	2	6	8	2022-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220609	2022	2	6	9	2022-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220610	2022	2	6	10	2022-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220611	2022	2	6	11	2022-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220612	2022	2	6	12	2022-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220613	2022	2	6	13	2022-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220614	2022	2	6	14	2022-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220615	2022	2	6	15	2022-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220616	2022	2	6	16	2022-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220617	2022	2	6	17	2022-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220618	2022	2	6	18	2022-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220619	2022	2	6	19	2022-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220620	2022	2	6	20	2022-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220621	2022	2	6	21	2022-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220622	2022	2	6	22	2022-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220623	2022	2	6	23	2022-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220624	2022	2	6	24	2022-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220625	2022	2	6	25	2022-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220626	2022	2	6	26	2022-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220627	2022	2	6	27	2022-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220628	2022	2	6	28	2022-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220629	2022	2	6	29	2022-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220630	2022	2	6	30	2022-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20220701	2022	3	7	1	2022-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20220702	2022	3	7	2	2022-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20220703	2022	3	7	3	2022-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20220704	2022	3	7	4	2022-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20220705	2022	3	7	5	2022-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20220706	2022	3	7	6	2022-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20220707	2022	3	7	7	2022-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20220708	2022	3	7	8	2022-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20220709	2022	3	7	9	2022-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20220710	2022	3	7	10	2022-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20220711	2022	3	7	11	2022-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20220712	2022	3	7	12	2022-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20220713	2022	3	7	13	2022-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20220714	2022	3	7	14	2022-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20220715	2022	3	7	15	2022-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20220716	2022	3	7	16	2022-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20220717	2022	3	7	17	2022-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20220718	2022	3	7	18	2022-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20220719	2022	3	7	19	2022-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20220720	2022	3	7	20	2022-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20220721	2022	3	7	21	2022-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20220722	2022	3	7	22	2022-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20220723	2022	3	7	23	2022-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20220724	2022	3	7	24	2022-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20220725	2022	3	7	25	2022-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20220726	2022	3	7	26	2022-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20220727	2022	3	7	27	2022-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20220728	2022	3	7	28	2022-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20220729	2022	3	7	29	2022-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20220730	2022	3	7	30	2022-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20220731	2022	3	7	31	2022-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20220801	2022	3	8	1	2022-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220802	2022	3	8	2	2022-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220803	2022	3	8	3	2022-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220804	2022	3	8	4	2022-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220805	2022	3	8	5	2022-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220806	2022	3	8	6	2022-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220807	2022	3	8	7	2022-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220808	2022	3	8	8	2022-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220809	2022	3	8	9	2022-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220810	2022	3	8	10	2022-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220811	2022	3	8	11	2022-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220812	2022	3	8	12	2022-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220813	2022	3	8	13	2022-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220814	2022	3	8	14	2022-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220815	2022	3	8	15	2022-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220816	2022	3	8	16	2022-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220817	2022	3	8	17	2022-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220818	2022	3	8	18	2022-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220819	2022	3	8	19	2022-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220820	2022	3	8	20	2022-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220821	2022	3	8	21	2022-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220822	2022	3	8	22	2022-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220823	2022	3	8	23	2022-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220824	2022	3	8	24	2022-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220825	2022	3	8	25	2022-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220826	2022	3	8	26	2022-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220827	2022	3	8	27	2022-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220828	2022	3	8	28	2022-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220829	2022	3	8	29	2022-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220830	2022	3	8	30	2022-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220831	2022	3	8	31	2022-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20220901	2022	3	9	1	2022-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220902	2022	3	9	2	2022-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220903	2022	3	9	3	2022-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220904	2022	3	9	4	2022-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220905	2022	3	9	5	2022-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220906	2022	3	9	6	2022-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220907	2022	3	9	7	2022-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220908	2022	3	9	8	2022-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220909	2022	3	9	9	2022-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220910	2022	3	9	10	2022-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220911	2022	3	9	11	2022-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220912	2022	3	9	12	2022-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220913	2022	3	9	13	2022-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220914	2022	3	9	14	2022-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220915	2022	3	9	15	2022-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220916	2022	3	9	16	2022-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220917	2022	3	9	17	2022-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220918	2022	3	9	18	2022-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220919	2022	3	9	19	2022-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220920	2022	3	9	20	2022-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220921	2022	3	9	21	2022-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220922	2022	3	9	22	2022-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220923	2022	3	9	23	2022-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220924	2022	3	9	24	2022-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220925	2022	3	9	25	2022-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220926	2022	3	9	26	2022-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220927	2022	3	9	27	2022-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220928	2022	3	9	28	2022-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220929	2022	3	9	29	2022-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20220930	2022	3	9	30	2022-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20221001	2022	4	10	1	2022-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221002	2022	4	10	2	2022-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221003	2022	4	10	3	2022-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221004	2022	4	10	4	2022-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221005	2022	4	10	5	2022-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221006	2022	4	10	6	2022-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221007	2022	4	10	7	2022-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221008	2022	4	10	8	2022-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221009	2022	4	10	9	2022-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221010	2022	4	10	10	2022-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221011	2022	4	10	11	2022-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221012	2022	4	10	12	2022-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221013	2022	4	10	13	2022-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221014	2022	4	10	14	2022-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221015	2022	4	10	15	2022-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221016	2022	4	10	16	2022-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221017	2022	4	10	17	2022-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221018	2022	4	10	18	2022-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221019	2022	4	10	19	2022-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221020	2022	4	10	20	2022-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221021	2022	4	10	21	2022-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221022	2022	4	10	22	2022-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221023	2022	4	10	23	2022-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221024	2022	4	10	24	2022-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221025	2022	4	10	25	2022-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221026	2022	4	10	26	2022-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221027	2022	4	10	27	2022-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221028	2022	4	10	28	2022-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221029	2022	4	10	29	2022-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221030	2022	4	10	30	2022-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221031	2022	4	10	31	2022-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20221101	2022	4	11	1	2022-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221102	2022	4	11	2	2022-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221103	2022	4	11	3	2022-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221104	2022	4	11	4	2022-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221105	2022	4	11	5	2022-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221106	2022	4	11	6	2022-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221107	2022	4	11	7	2022-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221108	2022	4	11	8	2022-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221109	2022	4	11	9	2022-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221110	2022	4	11	10	2022-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221111	2022	4	11	11	2022-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221112	2022	4	11	12	2022-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221113	2022	4	11	13	2022-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221114	2022	4	11	14	2022-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221115	2022	4	11	15	2022-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221116	2022	4	11	16	2022-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221117	2022	4	11	17	2022-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221118	2022	4	11	18	2022-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221119	2022	4	11	19	2022-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221120	2022	4	11	20	2022-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221121	2022	4	11	21	2022-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221122	2022	4	11	22	2022-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221123	2022	4	11	23	2022-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221124	2022	4	11	24	2022-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221125	2022	4	11	25	2022-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221126	2022	4	11	26	2022-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221127	2022	4	11	27	2022-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221128	2022	4	11	28	2022-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221129	2022	4	11	29	2022-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221130	2022	4	11	30	2022-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20221201	2022	4	12	1	2022-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221202	2022	4	12	2	2022-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221203	2022	4	12	3	2022-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221204	2022	4	12	4	2022-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221205	2022	4	12	5	2022-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221206	2022	4	12	6	2022-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221207	2022	4	12	7	2022-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221208	2022	4	12	8	2022-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221209	2022	4	12	9	2022-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221210	2022	4	12	10	2022-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221211	2022	4	12	11	2022-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221212	2022	4	12	12	2022-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221213	2022	4	12	13	2022-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221214	2022	4	12	14	2022-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221215	2022	4	12	15	2022-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221216	2022	4	12	16	2022-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221217	2022	4	12	17	2022-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221218	2022	4	12	18	2022-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221219	2022	4	12	19	2022-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221220	2022	4	12	20	2022-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221221	2022	4	12	21	2022-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221222	2022	4	12	22	2022-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221223	2022	4	12	23	2022-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221224	2022	4	12	24	2022-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221225	2022	4	12	25	2022-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221226	2022	4	12	26	2022-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221227	2022	4	12	27	2022-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221228	2022	4	12	28	2022-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221229	2022	4	12	29	2022-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221230	2022	4	12	30	2022-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20221231	2022	4	12	31	2022-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20230101	2023	1	1	1	2023-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20230102	2023	1	1	2	2023-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20230103	2023	1	1	3	2023-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20230104	2023	1	1	4	2023-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20230105	2023	1	1	5	2023-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20230106	2023	1	1	6	2023-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20230107	2023	1	1	7	2023-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20230108	2023	1	1	8	2023-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20230109	2023	1	1	9	2023-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20230110	2023	1	1	10	2023-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20230111	2023	1	1	11	2023-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20230112	2023	1	1	12	2023-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20230113	2023	1	1	13	2023-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20230114	2023	1	1	14	2023-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20230115	2023	1	1	15	2023-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20230116	2023	1	1	16	2023-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20230117	2023	1	1	17	2023-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20230118	2023	1	1	18	2023-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20230119	2023	1	1	19	2023-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20230120	2023	1	1	20	2023-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20230121	2023	1	1	21	2023-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20230122	2023	1	1	22	2023-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20230123	2023	1	1	23	2023-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20230124	2023	1	1	24	2023-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20230125	2023	1	1	25	2023-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20230126	2023	1	1	26	2023-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20230127	2023	1	1	27	2023-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20230128	2023	1	1	28	2023-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20230129	2023	1	1	29	2023-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20230130	2023	1	1	30	2023-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20230131	2023	1	1	31	2023-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20230201	2023	1	2	1	2023-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230202	2023	1	2	2	2023-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230203	2023	1	2	3	2023-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230204	2023	1	2	4	2023-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230205	2023	1	2	5	2023-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230206	2023	1	2	6	2023-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230207	2023	1	2	7	2023-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230208	2023	1	2	8	2023-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230209	2023	1	2	9	2023-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230210	2023	1	2	10	2023-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230211	2023	1	2	11	2023-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230212	2023	1	2	12	2023-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230213	2023	1	2	13	2023-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230214	2023	1	2	14	2023-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230215	2023	1	2	15	2023-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230216	2023	1	2	16	2023-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230217	2023	1	2	17	2023-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230218	2023	1	2	18	2023-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230219	2023	1	2	19	2023-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230220	2023	1	2	20	2023-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230221	2023	1	2	21	2023-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230222	2023	1	2	22	2023-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230223	2023	1	2	23	2023-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230224	2023	1	2	24	2023-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230225	2023	1	2	25	2023-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230226	2023	1	2	26	2023-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230227	2023	1	2	27	2023-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230228	2023	1	2	28	2023-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20230301	2023	1	3	1	2023-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20230302	2023	1	3	2	2023-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20230303	2023	1	3	3	2023-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20230304	2023	1	3	4	2023-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20230305	2023	1	3	5	2023-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20230306	2023	1	3	6	2023-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20230307	2023	1	3	7	2023-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20230308	2023	1	3	8	2023-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20230309	2023	1	3	9	2023-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20230310	2023	1	3	10	2023-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20230311	2023	1	3	11	2023-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20230312	2023	1	3	12	2023-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20230313	2023	1	3	13	2023-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20230314	2023	1	3	14	2023-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20230315	2023	1	3	15	2023-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20230316	2023	1	3	16	2023-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20230317	2023	1	3	17	2023-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20230318	2023	1	3	18	2023-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20230319	2023	1	3	19	2023-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20230320	2023	1	3	20	2023-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20230321	2023	1	3	21	2023-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20230322	2023	1	3	22	2023-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20230323	2023	1	3	23	2023-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20230324	2023	1	3	24	2023-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20230325	2023	1	3	25	2023-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20230326	2023	1	3	26	2023-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20230327	2023	1	3	27	2023-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20230328	2023	1	3	28	2023-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20230329	2023	1	3	29	2023-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20230330	2023	1	3	30	2023-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20230331	2023	1	3	31	2023-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20230401	2023	2	4	1	2023-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230402	2023	2	4	2	2023-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230403	2023	2	4	3	2023-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230404	2023	2	4	4	2023-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230405	2023	2	4	5	2023-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230406	2023	2	4	6	2023-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230407	2023	2	4	7	2023-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230408	2023	2	4	8	2023-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230409	2023	2	4	9	2023-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230410	2023	2	4	10	2023-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230411	2023	2	4	11	2023-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230412	2023	2	4	12	2023-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230413	2023	2	4	13	2023-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230414	2023	2	4	14	2023-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230415	2023	2	4	15	2023-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230416	2023	2	4	16	2023-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230417	2023	2	4	17	2023-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230418	2023	2	4	18	2023-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230419	2023	2	4	19	2023-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230420	2023	2	4	20	2023-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230421	2023	2	4	21	2023-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230422	2023	2	4	22	2023-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230423	2023	2	4	23	2023-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230424	2023	2	4	24	2023-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230425	2023	2	4	25	2023-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230426	2023	2	4	26	2023-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230427	2023	2	4	27	2023-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230428	2023	2	4	28	2023-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230429	2023	2	4	29	2023-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230430	2023	2	4	30	2023-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20230501	2023	2	5	1	2023-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20230502	2023	2	5	2	2023-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20230503	2023	2	5	3	2023-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20230504	2023	2	5	4	2023-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20230505	2023	2	5	5	2023-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20230506	2023	2	5	6	2023-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20230507	2023	2	5	7	2023-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20230508	2023	2	5	8	2023-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20230509	2023	2	5	9	2023-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20230510	2023	2	5	10	2023-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20230511	2023	2	5	11	2023-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20230512	2023	2	5	12	2023-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20230513	2023	2	5	13	2023-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20230514	2023	2	5	14	2023-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20230515	2023	2	5	15	2023-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20230516	2023	2	5	16	2023-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20230517	2023	2	5	17	2023-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20230518	2023	2	5	18	2023-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20230519	2023	2	5	19	2023-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20230520	2023	2	5	20	2023-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20230521	2023	2	5	21	2023-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20230522	2023	2	5	22	2023-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20230523	2023	2	5	23	2023-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20230524	2023	2	5	24	2023-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20230525	2023	2	5	25	2023-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20230526	2023	2	5	26	2023-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20230527	2023	2	5	27	2023-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20230528	2023	2	5	28	2023-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20230529	2023	2	5	29	2023-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20230530	2023	2	5	30	2023-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20230531	2023	2	5	31	2023-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20230601	2023	2	6	1	2023-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230602	2023	2	6	2	2023-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230603	2023	2	6	3	2023-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230604	2023	2	6	4	2023-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230605	2023	2	6	5	2023-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230606	2023	2	6	6	2023-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230607	2023	2	6	7	2023-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230608	2023	2	6	8	2023-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230609	2023	2	6	9	2023-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230610	2023	2	6	10	2023-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230611	2023	2	6	11	2023-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230612	2023	2	6	12	2023-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230613	2023	2	6	13	2023-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230614	2023	2	6	14	2023-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230615	2023	2	6	15	2023-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230616	2023	2	6	16	2023-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230617	2023	2	6	17	2023-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230618	2023	2	6	18	2023-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230619	2023	2	6	19	2023-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230620	2023	2	6	20	2023-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230621	2023	2	6	21	2023-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230622	2023	2	6	22	2023-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230623	2023	2	6	23	2023-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230624	2023	2	6	24	2023-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230625	2023	2	6	25	2023-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230626	2023	2	6	26	2023-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230627	2023	2	6	27	2023-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230628	2023	2	6	28	2023-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230629	2023	2	6	29	2023-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230630	2023	2	6	30	2023-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20230701	2023	3	7	1	2023-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20230702	2023	3	7	2	2023-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20230703	2023	3	7	3	2023-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20230704	2023	3	7	4	2023-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20230705	2023	3	7	5	2023-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20230706	2023	3	7	6	2023-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20230707	2023	3	7	7	2023-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20230708	2023	3	7	8	2023-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20230709	2023	3	7	9	2023-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20230710	2023	3	7	10	2023-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20230711	2023	3	7	11	2023-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20230712	2023	3	7	12	2023-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20230713	2023	3	7	13	2023-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20230714	2023	3	7	14	2023-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20230715	2023	3	7	15	2023-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20230716	2023	3	7	16	2023-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20230717	2023	3	7	17	2023-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20230718	2023	3	7	18	2023-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20230719	2023	3	7	19	2023-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20230720	2023	3	7	20	2023-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20230721	2023	3	7	21	2023-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20230722	2023	3	7	22	2023-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20230723	2023	3	7	23	2023-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20230724	2023	3	7	24	2023-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20230725	2023	3	7	25	2023-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20230726	2023	3	7	26	2023-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20230727	2023	3	7	27	2023-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20230728	2023	3	7	28	2023-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20230729	2023	3	7	29	2023-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20230730	2023	3	7	30	2023-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20230731	2023	3	7	31	2023-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20230801	2023	3	8	1	2023-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230802	2023	3	8	2	2023-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230803	2023	3	8	3	2023-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230804	2023	3	8	4	2023-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230805	2023	3	8	5	2023-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230806	2023	3	8	6	2023-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230807	2023	3	8	7	2023-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230808	2023	3	8	8	2023-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230809	2023	3	8	9	2023-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230810	2023	3	8	10	2023-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230811	2023	3	8	11	2023-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230812	2023	3	8	12	2023-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230813	2023	3	8	13	2023-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230814	2023	3	8	14	2023-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230815	2023	3	8	15	2023-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230816	2023	3	8	16	2023-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230817	2023	3	8	17	2023-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230818	2023	3	8	18	2023-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230819	2023	3	8	19	2023-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230820	2023	3	8	20	2023-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230821	2023	3	8	21	2023-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230822	2023	3	8	22	2023-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230823	2023	3	8	23	2023-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230824	2023	3	8	24	2023-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230825	2023	3	8	25	2023-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230826	2023	3	8	26	2023-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230827	2023	3	8	27	2023-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230828	2023	3	8	28	2023-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230829	2023	3	8	29	2023-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230830	2023	3	8	30	2023-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230831	2023	3	8	31	2023-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20230901	2023	3	9	1	2023-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230902	2023	3	9	2	2023-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230903	2023	3	9	3	2023-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230904	2023	3	9	4	2023-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230905	2023	3	9	5	2023-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230906	2023	3	9	6	2023-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230907	2023	3	9	7	2023-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230908	2023	3	9	8	2023-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230909	2023	3	9	9	2023-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230910	2023	3	9	10	2023-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230911	2023	3	9	11	2023-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230912	2023	3	9	12	2023-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230913	2023	3	9	13	2023-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230914	2023	3	9	14	2023-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230915	2023	3	9	15	2023-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230916	2023	3	9	16	2023-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230917	2023	3	9	17	2023-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230918	2023	3	9	18	2023-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230919	2023	3	9	19	2023-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230920	2023	3	9	20	2023-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230921	2023	3	9	21	2023-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230922	2023	3	9	22	2023-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230923	2023	3	9	23	2023-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230924	2023	3	9	24	2023-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230925	2023	3	9	25	2023-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230926	2023	3	9	26	2023-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230927	2023	3	9	27	2023-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230928	2023	3	9	28	2023-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230929	2023	3	9	29	2023-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20230930	2023	3	9	30	2023-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20231001	2023	4	10	1	2023-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231002	2023	4	10	2	2023-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231003	2023	4	10	3	2023-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231004	2023	4	10	4	2023-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231005	2023	4	10	5	2023-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231006	2023	4	10	6	2023-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231007	2023	4	10	7	2023-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231008	2023	4	10	8	2023-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231009	2023	4	10	9	2023-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231010	2023	4	10	10	2023-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231011	2023	4	10	11	2023-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231012	2023	4	10	12	2023-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231013	2023	4	10	13	2023-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231014	2023	4	10	14	2023-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231015	2023	4	10	15	2023-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231016	2023	4	10	16	2023-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231017	2023	4	10	17	2023-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231018	2023	4	10	18	2023-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231019	2023	4	10	19	2023-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231020	2023	4	10	20	2023-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231021	2023	4	10	21	2023-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231022	2023	4	10	22	2023-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231023	2023	4	10	23	2023-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231024	2023	4	10	24	2023-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231025	2023	4	10	25	2023-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231026	2023	4	10	26	2023-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231027	2023	4	10	27	2023-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231028	2023	4	10	28	2023-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231029	2023	4	10	29	2023-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231030	2023	4	10	30	2023-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231031	2023	4	10	31	2023-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20231101	2023	4	11	1	2023-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231102	2023	4	11	2	2023-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231103	2023	4	11	3	2023-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231104	2023	4	11	4	2023-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231105	2023	4	11	5	2023-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231106	2023	4	11	6	2023-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231107	2023	4	11	7	2023-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231108	2023	4	11	8	2023-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231109	2023	4	11	9	2023-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231110	2023	4	11	10	2023-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231111	2023	4	11	11	2023-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231112	2023	4	11	12	2023-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231113	2023	4	11	13	2023-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231114	2023	4	11	14	2023-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231115	2023	4	11	15	2023-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231116	2023	4	11	16	2023-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231117	2023	4	11	17	2023-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231118	2023	4	11	18	2023-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231119	2023	4	11	19	2023-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231120	2023	4	11	20	2023-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231121	2023	4	11	21	2023-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231122	2023	4	11	22	2023-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231123	2023	4	11	23	2023-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231124	2023	4	11	24	2023-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231125	2023	4	11	25	2023-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231126	2023	4	11	26	2023-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231127	2023	4	11	27	2023-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231128	2023	4	11	28	2023-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231129	2023	4	11	29	2023-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231130	2023	4	11	30	2023-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20231201	2023	4	12	1	2023-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231202	2023	4	12	2	2023-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231203	2023	4	12	3	2023-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231204	2023	4	12	4	2023-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231205	2023	4	12	5	2023-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231206	2023	4	12	6	2023-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231207	2023	4	12	7	2023-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231208	2023	4	12	8	2023-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231209	2023	4	12	9	2023-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231210	2023	4	12	10	2023-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231211	2023	4	12	11	2023-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231212	2023	4	12	12	2023-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231213	2023	4	12	13	2023-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231214	2023	4	12	14	2023-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231215	2023	4	12	15	2023-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231216	2023	4	12	16	2023-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231217	2023	4	12	17	2023-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231218	2023	4	12	18	2023-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231219	2023	4	12	19	2023-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231220	2023	4	12	20	2023-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231221	2023	4	12	21	2023-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231222	2023	4	12	22	2023-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231223	2023	4	12	23	2023-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231224	2023	4	12	24	2023-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231225	2023	4	12	25	2023-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231226	2023	4	12	26	2023-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231227	2023	4	12	27	2023-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231228	2023	4	12	28	2023-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231229	2023	4	12	29	2023-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231230	2023	4	12	30	2023-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20231231	2023	4	12	31	2023-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20240101	2024	1	1	1	2024-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20240102	2024	1	1	2	2024-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20240103	2024	1	1	3	2024-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20240104	2024	1	1	4	2024-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20240105	2024	1	1	5	2024-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20240106	2024	1	1	6	2024-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20240107	2024	1	1	7	2024-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20240108	2024	1	1	8	2024-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20240109	2024	1	1	9	2024-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20240110	2024	1	1	10	2024-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20240111	2024	1	1	11	2024-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20240112	2024	1	1	12	2024-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20240113	2024	1	1	13	2024-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20240114	2024	1	1	14	2024-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20240115	2024	1	1	15	2024-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20240116	2024	1	1	16	2024-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20240117	2024	1	1	17	2024-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20240118	2024	1	1	18	2024-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20240119	2024	1	1	19	2024-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20240120	2024	1	1	20	2024-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20240121	2024	1	1	21	2024-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20240122	2024	1	1	22	2024-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20240123	2024	1	1	23	2024-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20240124	2024	1	1	24	2024-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20240125	2024	1	1	25	2024-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20240126	2024	1	1	26	2024-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20240127	2024	1	1	27	2024-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20240128	2024	1	1	28	2024-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20240129	2024	1	1	29	2024-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20240130	2024	1	1	30	2024-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20240131	2024	1	1	31	2024-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20240201	2024	1	2	1	2024-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240202	2024	1	2	2	2024-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240203	2024	1	2	3	2024-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240204	2024	1	2	4	2024-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240205	2024	1	2	5	2024-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240206	2024	1	2	6	2024-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240207	2024	1	2	7	2024-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240208	2024	1	2	8	2024-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240209	2024	1	2	9	2024-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240210	2024	1	2	10	2024-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240211	2024	1	2	11	2024-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240212	2024	1	2	12	2024-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240213	2024	1	2	13	2024-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240214	2024	1	2	14	2024-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240215	2024	1	2	15	2024-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240216	2024	1	2	16	2024-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240217	2024	1	2	17	2024-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240218	2024	1	2	18	2024-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240219	2024	1	2	19	2024-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240220	2024	1	2	20	2024-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240221	2024	1	2	21	2024-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240222	2024	1	2	22	2024-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240223	2024	1	2	23	2024-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240224	2024	1	2	24	2024-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240225	2024	1	2	25	2024-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240226	2024	1	2	26	2024-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240227	2024	1	2	27	2024-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240228	2024	1	2	28	2024-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240229	2024	1	2	29	2024-02-29 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20240301	2024	1	3	1	2024-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20240302	2024	1	3	2	2024-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20240303	2024	1	3	3	2024-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20240304	2024	1	3	4	2024-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20240305	2024	1	3	5	2024-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20240306	2024	1	3	6	2024-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20240307	2024	1	3	7	2024-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20240308	2024	1	3	8	2024-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20240309	2024	1	3	9	2024-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20240310	2024	1	3	10	2024-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20240311	2024	1	3	11	2024-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20240312	2024	1	3	12	2024-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20240313	2024	1	3	13	2024-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20240314	2024	1	3	14	2024-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20240315	2024	1	3	15	2024-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20240316	2024	1	3	16	2024-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20240317	2024	1	3	17	2024-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20240318	2024	1	3	18	2024-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20240319	2024	1	3	19	2024-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20240320	2024	1	3	20	2024-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20240321	2024	1	3	21	2024-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20240322	2024	1	3	22	2024-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20240323	2024	1	3	23	2024-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20240324	2024	1	3	24	2024-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20240325	2024	1	3	25	2024-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20240326	2024	1	3	26	2024-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20240327	2024	1	3	27	2024-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20240328	2024	1	3	28	2024-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20240329	2024	1	3	29	2024-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20240330	2024	1	3	30	2024-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20240331	2024	1	3	31	2024-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20240401	2024	2	4	1	2024-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240402	2024	2	4	2	2024-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240403	2024	2	4	3	2024-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240404	2024	2	4	4	2024-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240405	2024	2	4	5	2024-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240406	2024	2	4	6	2024-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240407	2024	2	4	7	2024-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240408	2024	2	4	8	2024-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240409	2024	2	4	9	2024-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240410	2024	2	4	10	2024-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240411	2024	2	4	11	2024-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240412	2024	2	4	12	2024-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240413	2024	2	4	13	2024-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240414	2024	2	4	14	2024-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240415	2024	2	4	15	2024-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240416	2024	2	4	16	2024-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240417	2024	2	4	17	2024-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240418	2024	2	4	18	2024-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240419	2024	2	4	19	2024-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240420	2024	2	4	20	2024-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240421	2024	2	4	21	2024-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240422	2024	2	4	22	2024-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240423	2024	2	4	23	2024-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240424	2024	2	4	24	2024-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240425	2024	2	4	25	2024-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240426	2024	2	4	26	2024-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240427	2024	2	4	27	2024-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240428	2024	2	4	28	2024-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240429	2024	2	4	29	2024-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240430	2024	2	4	30	2024-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20240501	2024	2	5	1	2024-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20240502	2024	2	5	2	2024-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20240503	2024	2	5	3	2024-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20240504	2024	2	5	4	2024-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20240505	2024	2	5	5	2024-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20240506	2024	2	5	6	2024-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20240507	2024	2	5	7	2024-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20240508	2024	2	5	8	2024-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20240509	2024	2	5	9	2024-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20240510	2024	2	5	10	2024-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20240511	2024	2	5	11	2024-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20240512	2024	2	5	12	2024-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20240513	2024	2	5	13	2024-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20240514	2024	2	5	14	2024-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20240515	2024	2	5	15	2024-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20240516	2024	2	5	16	2024-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20240517	2024	2	5	17	2024-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20240518	2024	2	5	18	2024-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20240519	2024	2	5	19	2024-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20240520	2024	2	5	20	2024-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20240521	2024	2	5	21	2024-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20240522	2024	2	5	22	2024-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20240523	2024	2	5	23	2024-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20240524	2024	2	5	24	2024-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20240525	2024	2	5	25	2024-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20240526	2024	2	5	26	2024-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20240527	2024	2	5	27	2024-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20240528	2024	2	5	28	2024-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20240529	2024	2	5	29	2024-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20240530	2024	2	5	30	2024-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20240531	2024	2	5	31	2024-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20240601	2024	2	6	1	2024-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240602	2024	2	6	2	2024-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240603	2024	2	6	3	2024-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240604	2024	2	6	4	2024-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240605	2024	2	6	5	2024-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240606	2024	2	6	6	2024-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240607	2024	2	6	7	2024-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240608	2024	2	6	8	2024-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240609	2024	2	6	9	2024-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240610	2024	2	6	10	2024-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240611	2024	2	6	11	2024-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240612	2024	2	6	12	2024-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240613	2024	2	6	13	2024-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240614	2024	2	6	14	2024-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240615	2024	2	6	15	2024-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240616	2024	2	6	16	2024-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240617	2024	2	6	17	2024-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240618	2024	2	6	18	2024-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240619	2024	2	6	19	2024-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240620	2024	2	6	20	2024-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240621	2024	2	6	21	2024-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240622	2024	2	6	22	2024-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240623	2024	2	6	23	2024-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240624	2024	2	6	24	2024-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240625	2024	2	6	25	2024-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240626	2024	2	6	26	2024-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240627	2024	2	6	27	2024-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240628	2024	2	6	28	2024-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240629	2024	2	6	29	2024-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240630	2024	2	6	30	2024-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20240701	2024	3	7	1	2024-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20240702	2024	3	7	2	2024-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20240703	2024	3	7	3	2024-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20240704	2024	3	7	4	2024-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20240705	2024	3	7	5	2024-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20240706	2024	3	7	6	2024-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20240707	2024	3	7	7	2024-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20240708	2024	3	7	8	2024-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20240709	2024	3	7	9	2024-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20240710	2024	3	7	10	2024-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20240711	2024	3	7	11	2024-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20240712	2024	3	7	12	2024-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20240713	2024	3	7	13	2024-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20240714	2024	3	7	14	2024-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20240715	2024	3	7	15	2024-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20240716	2024	3	7	16	2024-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20240717	2024	3	7	17	2024-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20240718	2024	3	7	18	2024-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20240719	2024	3	7	19	2024-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20240720	2024	3	7	20	2024-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20240721	2024	3	7	21	2024-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20240722	2024	3	7	22	2024-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20240723	2024	3	7	23	2024-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20240724	2024	3	7	24	2024-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20240725	2024	3	7	25	2024-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20240726	2024	3	7	26	2024-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20240727	2024	3	7	27	2024-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20240728	2024	3	7	28	2024-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20240729	2024	3	7	29	2024-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20240730	2024	3	7	30	2024-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20240731	2024	3	7	31	2024-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20240801	2024	3	8	1	2024-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240802	2024	3	8	2	2024-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240803	2024	3	8	3	2024-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240804	2024	3	8	4	2024-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240805	2024	3	8	5	2024-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240806	2024	3	8	6	2024-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240807	2024	3	8	7	2024-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240808	2024	3	8	8	2024-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240809	2024	3	8	9	2024-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240810	2024	3	8	10	2024-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240811	2024	3	8	11	2024-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240812	2024	3	8	12	2024-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240813	2024	3	8	13	2024-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240814	2024	3	8	14	2024-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240815	2024	3	8	15	2024-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240816	2024	3	8	16	2024-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240817	2024	3	8	17	2024-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240818	2024	3	8	18	2024-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240819	2024	3	8	19	2024-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240820	2024	3	8	20	2024-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240821	2024	3	8	21	2024-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240822	2024	3	8	22	2024-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240823	2024	3	8	23	2024-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240824	2024	3	8	24	2024-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240825	2024	3	8	25	2024-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240826	2024	3	8	26	2024-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240827	2024	3	8	27	2024-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240828	2024	3	8	28	2024-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240829	2024	3	8	29	2024-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240830	2024	3	8	30	2024-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240831	2024	3	8	31	2024-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20240901	2024	3	9	1	2024-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240902	2024	3	9	2	2024-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240903	2024	3	9	3	2024-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240904	2024	3	9	4	2024-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240905	2024	3	9	5	2024-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240906	2024	3	9	6	2024-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240907	2024	3	9	7	2024-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240908	2024	3	9	8	2024-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240909	2024	3	9	9	2024-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240910	2024	3	9	10	2024-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240911	2024	3	9	11	2024-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240912	2024	3	9	12	2024-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240913	2024	3	9	13	2024-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240914	2024	3	9	14	2024-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240915	2024	3	9	15	2024-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240916	2024	3	9	16	2024-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240917	2024	3	9	17	2024-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240918	2024	3	9	18	2024-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240919	2024	3	9	19	2024-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240920	2024	3	9	20	2024-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240921	2024	3	9	21	2024-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240922	2024	3	9	22	2024-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240923	2024	3	9	23	2024-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240924	2024	3	9	24	2024-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240925	2024	3	9	25	2024-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240926	2024	3	9	26	2024-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240927	2024	3	9	27	2024-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240928	2024	3	9	28	2024-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240929	2024	3	9	29	2024-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20240930	2024	3	9	30	2024-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20241001	2024	4	10	1	2024-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241002	2024	4	10	2	2024-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241003	2024	4	10	3	2024-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241004	2024	4	10	4	2024-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241005	2024	4	10	5	2024-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241006	2024	4	10	6	2024-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241007	2024	4	10	7	2024-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241008	2024	4	10	8	2024-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241009	2024	4	10	9	2024-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241010	2024	4	10	10	2024-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241011	2024	4	10	11	2024-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241012	2024	4	10	12	2024-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241013	2024	4	10	13	2024-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241014	2024	4	10	14	2024-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241015	2024	4	10	15	2024-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241016	2024	4	10	16	2024-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241017	2024	4	10	17	2024-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241018	2024	4	10	18	2024-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241019	2024	4	10	19	2024-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241020	2024	4	10	20	2024-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241021	2024	4	10	21	2024-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241022	2024	4	10	22	2024-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241023	2024	4	10	23	2024-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241024	2024	4	10	24	2024-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241025	2024	4	10	25	2024-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241026	2024	4	10	26	2024-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241027	2024	4	10	27	2024-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241028	2024	4	10	28	2024-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241029	2024	4	10	29	2024-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241030	2024	4	10	30	2024-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241031	2024	4	10	31	2024-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20241101	2024	4	11	1	2024-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241102	2024	4	11	2	2024-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241103	2024	4	11	3	2024-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241104	2024	4	11	4	2024-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241105	2024	4	11	5	2024-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241106	2024	4	11	6	2024-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241107	2024	4	11	7	2024-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241108	2024	4	11	8	2024-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241109	2024	4	11	9	2024-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241110	2024	4	11	10	2024-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241111	2024	4	11	11	2024-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241112	2024	4	11	12	2024-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241113	2024	4	11	13	2024-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241114	2024	4	11	14	2024-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241115	2024	4	11	15	2024-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241116	2024	4	11	16	2024-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241117	2024	4	11	17	2024-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241118	2024	4	11	18	2024-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241119	2024	4	11	19	2024-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241120	2024	4	11	20	2024-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241121	2024	4	11	21	2024-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241122	2024	4	11	22	2024-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241123	2024	4	11	23	2024-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241124	2024	4	11	24	2024-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241125	2024	4	11	25	2024-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241126	2024	4	11	26	2024-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241127	2024	4	11	27	2024-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241128	2024	4	11	28	2024-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241129	2024	4	11	29	2024-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241130	2024	4	11	30	2024-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20241201	2024	4	12	1	2024-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241202	2024	4	12	2	2024-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241203	2024	4	12	3	2024-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241204	2024	4	12	4	2024-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241205	2024	4	12	5	2024-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241206	2024	4	12	6	2024-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241207	2024	4	12	7	2024-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241208	2024	4	12	8	2024-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241209	2024	4	12	9	2024-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241210	2024	4	12	10	2024-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241211	2024	4	12	11	2024-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241212	2024	4	12	12	2024-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241213	2024	4	12	13	2024-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241214	2024	4	12	14	2024-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241215	2024	4	12	15	2024-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241216	2024	4	12	16	2024-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241217	2024	4	12	17	2024-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241218	2024	4	12	18	2024-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241219	2024	4	12	19	2024-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241220	2024	4	12	20	2024-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241221	2024	4	12	21	2024-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241222	2024	4	12	22	2024-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241223	2024	4	12	23	2024-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241224	2024	4	12	24	2024-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241225	2024	4	12	25	2024-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241226	2024	4	12	26	2024-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241227	2024	4	12	27	2024-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241228	2024	4	12	28	2024-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241229	2024	4	12	29	2024-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241230	2024	4	12	30	2024-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20241231	2024	4	12	31	2024-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20250101	2025	1	1	1	2025-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20250102	2025	1	1	2	2025-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20250103	2025	1	1	3	2025-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20250104	2025	1	1	4	2025-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20250105	2025	1	1	5	2025-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20250106	2025	1	1	6	2025-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20250107	2025	1	1	7	2025-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20250108	2025	1	1	8	2025-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20250109	2025	1	1	9	2025-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20250110	2025	1	1	10	2025-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20250111	2025	1	1	11	2025-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20250112	2025	1	1	12	2025-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20250113	2025	1	1	13	2025-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20250114	2025	1	1	14	2025-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20250115	2025	1	1	15	2025-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20250116	2025	1	1	16	2025-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20250117	2025	1	1	17	2025-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20250118	2025	1	1	18	2025-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20250119	2025	1	1	19	2025-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20250120	2025	1	1	20	2025-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20250121	2025	1	1	21	2025-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20250122	2025	1	1	22	2025-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20250123	2025	1	1	23	2025-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20250124	2025	1	1	24	2025-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20250125	2025	1	1	25	2025-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20250126	2025	1	1	26	2025-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20250127	2025	1	1	27	2025-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20250128	2025	1	1	28	2025-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20250129	2025	1	1	29	2025-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20250130	2025	1	1	30	2025-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20250131	2025	1	1	31	2025-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20250201	2025	1	2	1	2025-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250202	2025	1	2	2	2025-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250203	2025	1	2	3	2025-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250204	2025	1	2	4	2025-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250205	2025	1	2	5	2025-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250206	2025	1	2	6	2025-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250207	2025	1	2	7	2025-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250208	2025	1	2	8	2025-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250209	2025	1	2	9	2025-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250210	2025	1	2	10	2025-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250211	2025	1	2	11	2025-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250212	2025	1	2	12	2025-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250213	2025	1	2	13	2025-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250214	2025	1	2	14	2025-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250215	2025	1	2	15	2025-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250216	2025	1	2	16	2025-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250217	2025	1	2	17	2025-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250218	2025	1	2	18	2025-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250219	2025	1	2	19	2025-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250220	2025	1	2	20	2025-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250221	2025	1	2	21	2025-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250222	2025	1	2	22	2025-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250223	2025	1	2	23	2025-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250224	2025	1	2	24	2025-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250225	2025	1	2	25	2025-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250226	2025	1	2	26	2025-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250227	2025	1	2	27	2025-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250228	2025	1	2	28	2025-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20250301	2025	1	3	1	2025-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20250302	2025	1	3	2	2025-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20250303	2025	1	3	3	2025-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20250304	2025	1	3	4	2025-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20250305	2025	1	3	5	2025-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20250306	2025	1	3	6	2025-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20250307	2025	1	3	7	2025-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20250308	2025	1	3	8	2025-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20250309	2025	1	3	9	2025-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20250310	2025	1	3	10	2025-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20250311	2025	1	3	11	2025-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20250312	2025	1	3	12	2025-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20250313	2025	1	3	13	2025-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20250314	2025	1	3	14	2025-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20250315	2025	1	3	15	2025-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20250316	2025	1	3	16	2025-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20250317	2025	1	3	17	2025-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20250318	2025	1	3	18	2025-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20250319	2025	1	3	19	2025-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20250320	2025	1	3	20	2025-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20250321	2025	1	3	21	2025-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20250322	2025	1	3	22	2025-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20250323	2025	1	3	23	2025-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20250324	2025	1	3	24	2025-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20250325	2025	1	3	25	2025-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20250326	2025	1	3	26	2025-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20250327	2025	1	3	27	2025-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20250328	2025	1	3	28	2025-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20250329	2025	1	3	29	2025-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20250330	2025	1	3	30	2025-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20250331	2025	1	3	31	2025-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20250401	2025	2	4	1	2025-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250402	2025	2	4	2	2025-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250403	2025	2	4	3	2025-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250404	2025	2	4	4	2025-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250405	2025	2	4	5	2025-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250406	2025	2	4	6	2025-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250407	2025	2	4	7	2025-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250408	2025	2	4	8	2025-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250409	2025	2	4	9	2025-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250410	2025	2	4	10	2025-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250411	2025	2	4	11	2025-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250412	2025	2	4	12	2025-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250413	2025	2	4	13	2025-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250414	2025	2	4	14	2025-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250415	2025	2	4	15	2025-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250416	2025	2	4	16	2025-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250417	2025	2	4	17	2025-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250418	2025	2	4	18	2025-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250419	2025	2	4	19	2025-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250420	2025	2	4	20	2025-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250421	2025	2	4	21	2025-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250422	2025	2	4	22	2025-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250423	2025	2	4	23	2025-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250424	2025	2	4	24	2025-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250425	2025	2	4	25	2025-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250426	2025	2	4	26	2025-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250427	2025	2	4	27	2025-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250428	2025	2	4	28	2025-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250429	2025	2	4	29	2025-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250430	2025	2	4	30	2025-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20250501	2025	2	5	1	2025-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20250502	2025	2	5	2	2025-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20250503	2025	2	5	3	2025-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20250504	2025	2	5	4	2025-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20250505	2025	2	5	5	2025-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20250506	2025	2	5	6	2025-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20250507	2025	2	5	7	2025-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20250508	2025	2	5	8	2025-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20250509	2025	2	5	9	2025-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20250510	2025	2	5	10	2025-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20250511	2025	2	5	11	2025-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20250512	2025	2	5	12	2025-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20250513	2025	2	5	13	2025-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20250514	2025	2	5	14	2025-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20250515	2025	2	5	15	2025-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20250516	2025	2	5	16	2025-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20250517	2025	2	5	17	2025-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20250518	2025	2	5	18	2025-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20250519	2025	2	5	19	2025-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20250520	2025	2	5	20	2025-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20250521	2025	2	5	21	2025-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20250522	2025	2	5	22	2025-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20250523	2025	2	5	23	2025-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20250524	2025	2	5	24	2025-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20250525	2025	2	5	25	2025-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20250526	2025	2	5	26	2025-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20250527	2025	2	5	27	2025-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20250528	2025	2	5	28	2025-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20250529	2025	2	5	29	2025-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20250530	2025	2	5	30	2025-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20250531	2025	2	5	31	2025-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20250601	2025	2	6	1	2025-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250602	2025	2	6	2	2025-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250603	2025	2	6	3	2025-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250604	2025	2	6	4	2025-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250605	2025	2	6	5	2025-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250606	2025	2	6	6	2025-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250607	2025	2	6	7	2025-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250608	2025	2	6	8	2025-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250609	2025	2	6	9	2025-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250610	2025	2	6	10	2025-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250611	2025	2	6	11	2025-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250612	2025	2	6	12	2025-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250613	2025	2	6	13	2025-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250614	2025	2	6	14	2025-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250615	2025	2	6	15	2025-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250616	2025	2	6	16	2025-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250617	2025	2	6	17	2025-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250618	2025	2	6	18	2025-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250619	2025	2	6	19	2025-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250620	2025	2	6	20	2025-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250621	2025	2	6	21	2025-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250622	2025	2	6	22	2025-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250623	2025	2	6	23	2025-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250624	2025	2	6	24	2025-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250625	2025	2	6	25	2025-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250626	2025	2	6	26	2025-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250627	2025	2	6	27	2025-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250628	2025	2	6	28	2025-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250629	2025	2	6	29	2025-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250630	2025	2	6	30	2025-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20250701	2025	3	7	1	2025-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20250702	2025	3	7	2	2025-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20250703	2025	3	7	3	2025-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20250704	2025	3	7	4	2025-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20250705	2025	3	7	5	2025-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20250706	2025	3	7	6	2025-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20250707	2025	3	7	7	2025-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20250708	2025	3	7	8	2025-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20250709	2025	3	7	9	2025-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20250710	2025	3	7	10	2025-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20250711	2025	3	7	11	2025-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20250712	2025	3	7	12	2025-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20250713	2025	3	7	13	2025-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20250714	2025	3	7	14	2025-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20250715	2025	3	7	15	2025-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20250716	2025	3	7	16	2025-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20250717	2025	3	7	17	2025-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20250718	2025	3	7	18	2025-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20250719	2025	3	7	19	2025-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20250720	2025	3	7	20	2025-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20250721	2025	3	7	21	2025-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20250722	2025	3	7	22	2025-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20250723	2025	3	7	23	2025-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20250724	2025	3	7	24	2025-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20250725	2025	3	7	25	2025-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20250726	2025	3	7	26	2025-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20250727	2025	3	7	27	2025-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20250728	2025	3	7	28	2025-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20250729	2025	3	7	29	2025-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20250730	2025	3	7	30	2025-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20250731	2025	3	7	31	2025-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20250801	2025	3	8	1	2025-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250802	2025	3	8	2	2025-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250803	2025	3	8	3	2025-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250804	2025	3	8	4	2025-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250805	2025	3	8	5	2025-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250806	2025	3	8	6	2025-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250807	2025	3	8	7	2025-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250808	2025	3	8	8	2025-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250809	2025	3	8	9	2025-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250810	2025	3	8	10	2025-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250811	2025	3	8	11	2025-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250812	2025	3	8	12	2025-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250813	2025	3	8	13	2025-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250814	2025	3	8	14	2025-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250815	2025	3	8	15	2025-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250816	2025	3	8	16	2025-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250817	2025	3	8	17	2025-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250818	2025	3	8	18	2025-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250819	2025	3	8	19	2025-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250820	2025	3	8	20	2025-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250821	2025	3	8	21	2025-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250822	2025	3	8	22	2025-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250823	2025	3	8	23	2025-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250824	2025	3	8	24	2025-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250825	2025	3	8	25	2025-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250826	2025	3	8	26	2025-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250827	2025	3	8	27	2025-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250828	2025	3	8	28	2025-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250829	2025	3	8	29	2025-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250830	2025	3	8	30	2025-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250831	2025	3	8	31	2025-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20250901	2025	3	9	1	2025-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250902	2025	3	9	2	2025-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250903	2025	3	9	3	2025-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250904	2025	3	9	4	2025-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250905	2025	3	9	5	2025-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250906	2025	3	9	6	2025-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250907	2025	3	9	7	2025-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250908	2025	3	9	8	2025-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250909	2025	3	9	9	2025-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250910	2025	3	9	10	2025-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250911	2025	3	9	11	2025-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250912	2025	3	9	12	2025-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250913	2025	3	9	13	2025-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250914	2025	3	9	14	2025-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250915	2025	3	9	15	2025-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250916	2025	3	9	16	2025-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250917	2025	3	9	17	2025-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250918	2025	3	9	18	2025-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250919	2025	3	9	19	2025-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250920	2025	3	9	20	2025-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250921	2025	3	9	21	2025-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250922	2025	3	9	22	2025-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250923	2025	3	9	23	2025-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250924	2025	3	9	24	2025-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250925	2025	3	9	25	2025-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250926	2025	3	9	26	2025-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250927	2025	3	9	27	2025-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250928	2025	3	9	28	2025-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250929	2025	3	9	29	2025-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20250930	2025	3	9	30	2025-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20251001	2025	4	10	1	2025-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251002	2025	4	10	2	2025-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251003	2025	4	10	3	2025-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251004	2025	4	10	4	2025-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251005	2025	4	10	5	2025-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251006	2025	4	10	6	2025-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251007	2025	4	10	7	2025-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251008	2025	4	10	8	2025-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251009	2025	4	10	9	2025-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251010	2025	4	10	10	2025-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251011	2025	4	10	11	2025-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251012	2025	4	10	12	2025-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251013	2025	4	10	13	2025-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251014	2025	4	10	14	2025-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251015	2025	4	10	15	2025-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251016	2025	4	10	16	2025-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251017	2025	4	10	17	2025-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251018	2025	4	10	18	2025-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251019	2025	4	10	19	2025-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251020	2025	4	10	20	2025-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251021	2025	4	10	21	2025-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251022	2025	4	10	22	2025-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251023	2025	4	10	23	2025-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251024	2025	4	10	24	2025-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251025	2025	4	10	25	2025-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251026	2025	4	10	26	2025-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251027	2025	4	10	27	2025-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251028	2025	4	10	28	2025-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251029	2025	4	10	29	2025-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251030	2025	4	10	30	2025-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251031	2025	4	10	31	2025-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20251101	2025	4	11	1	2025-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251102	2025	4	11	2	2025-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251103	2025	4	11	3	2025-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251104	2025	4	11	4	2025-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251105	2025	4	11	5	2025-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251106	2025	4	11	6	2025-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251107	2025	4	11	7	2025-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251108	2025	4	11	8	2025-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251109	2025	4	11	9	2025-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251110	2025	4	11	10	2025-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251111	2025	4	11	11	2025-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251112	2025	4	11	12	2025-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251113	2025	4	11	13	2025-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251114	2025	4	11	14	2025-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251115	2025	4	11	15	2025-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251116	2025	4	11	16	2025-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251117	2025	4	11	17	2025-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251118	2025	4	11	18	2025-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251119	2025	4	11	19	2025-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251120	2025	4	11	20	2025-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251121	2025	4	11	21	2025-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251122	2025	4	11	22	2025-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251123	2025	4	11	23	2025-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251124	2025	4	11	24	2025-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251125	2025	4	11	25	2025-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251126	2025	4	11	26	2025-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251127	2025	4	11	27	2025-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251128	2025	4	11	28	2025-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251129	2025	4	11	29	2025-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251130	2025	4	11	30	2025-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20251201	2025	4	12	1	2025-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251202	2025	4	12	2	2025-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251203	2025	4	12	3	2025-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251204	2025	4	12	4	2025-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251205	2025	4	12	5	2025-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251206	2025	4	12	6	2025-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251207	2025	4	12	7	2025-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251208	2025	4	12	8	2025-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251209	2025	4	12	9	2025-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251210	2025	4	12	10	2025-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251211	2025	4	12	11	2025-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251212	2025	4	12	12	2025-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251213	2025	4	12	13	2025-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251214	2025	4	12	14	2025-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251215	2025	4	12	15	2025-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251216	2025	4	12	16	2025-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251217	2025	4	12	17	2025-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251218	2025	4	12	18	2025-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251219	2025	4	12	19	2025-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251220	2025	4	12	20	2025-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251221	2025	4	12	21	2025-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251222	2025	4	12	22	2025-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251223	2025	4	12	23	2025-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251224	2025	4	12	24	2025-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251225	2025	4	12	25	2025-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251226	2025	4	12	26	2025-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251227	2025	4	12	27	2025-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251228	2025	4	12	28	2025-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251229	2025	4	12	29	2025-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251230	2025	4	12	30	2025-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20251231	2025	4	12	31	2025-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20260101	2026	1	1	1	2026-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20260102	2026	1	1	2	2026-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20260103	2026	1	1	3	2026-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20260104	2026	1	1	4	2026-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20260105	2026	1	1	5	2026-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20260106	2026	1	1	6	2026-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20260107	2026	1	1	7	2026-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20260108	2026	1	1	8	2026-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20260109	2026	1	1	9	2026-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20260110	2026	1	1	10	2026-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20260111	2026	1	1	11	2026-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20260112	2026	1	1	12	2026-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20260113	2026	1	1	13	2026-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20260114	2026	1	1	14	2026-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20260115	2026	1	1	15	2026-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20260116	2026	1	1	16	2026-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20260117	2026	1	1	17	2026-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20260118	2026	1	1	18	2026-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20260119	2026	1	1	19	2026-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20260120	2026	1	1	20	2026-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20260121	2026	1	1	21	2026-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20260122	2026	1	1	22	2026-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20260123	2026	1	1	23	2026-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20260124	2026	1	1	24	2026-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20260125	2026	1	1	25	2026-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20260126	2026	1	1	26	2026-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20260127	2026	1	1	27	2026-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20260128	2026	1	1	28	2026-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20260129	2026	1	1	29	2026-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20260130	2026	1	1	30	2026-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20260131	2026	1	1	31	2026-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20260201	2026	1	2	1	2026-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260202	2026	1	2	2	2026-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260203	2026	1	2	3	2026-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260204	2026	1	2	4	2026-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260205	2026	1	2	5	2026-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260206	2026	1	2	6	2026-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260207	2026	1	2	7	2026-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260208	2026	1	2	8	2026-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260209	2026	1	2	9	2026-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260210	2026	1	2	10	2026-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260211	2026	1	2	11	2026-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260212	2026	1	2	12	2026-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260213	2026	1	2	13	2026-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260214	2026	1	2	14	2026-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260215	2026	1	2	15	2026-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260216	2026	1	2	16	2026-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260217	2026	1	2	17	2026-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260218	2026	1	2	18	2026-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260219	2026	1	2	19	2026-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260220	2026	1	2	20	2026-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260221	2026	1	2	21	2026-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260222	2026	1	2	22	2026-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260223	2026	1	2	23	2026-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260224	2026	1	2	24	2026-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260225	2026	1	2	25	2026-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260226	2026	1	2	26	2026-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260227	2026	1	2	27	2026-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260228	2026	1	2	28	2026-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20260301	2026	1	3	1	2026-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20260302	2026	1	3	2	2026-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20260303	2026	1	3	3	2026-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20260304	2026	1	3	4	2026-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20260305	2026	1	3	5	2026-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20260306	2026	1	3	6	2026-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20260307	2026	1	3	7	2026-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20260308	2026	1	3	8	2026-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20260309	2026	1	3	9	2026-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20260310	2026	1	3	10	2026-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20260311	2026	1	3	11	2026-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20260312	2026	1	3	12	2026-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20260313	2026	1	3	13	2026-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20260314	2026	1	3	14	2026-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20260315	2026	1	3	15	2026-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20260316	2026	1	3	16	2026-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20260317	2026	1	3	17	2026-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20260318	2026	1	3	18	2026-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20260319	2026	1	3	19	2026-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20260320	2026	1	3	20	2026-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20260321	2026	1	3	21	2026-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20260322	2026	1	3	22	2026-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20260323	2026	1	3	23	2026-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20260324	2026	1	3	24	2026-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20260325	2026	1	3	25	2026-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20260326	2026	1	3	26	2026-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20260327	2026	1	3	27	2026-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20260328	2026	1	3	28	2026-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20260329	2026	1	3	29	2026-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20260330	2026	1	3	30	2026-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20260331	2026	1	3	31	2026-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20260401	2026	2	4	1	2026-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260402	2026	2	4	2	2026-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260403	2026	2	4	3	2026-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260404	2026	2	4	4	2026-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260405	2026	2	4	5	2026-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260406	2026	2	4	6	2026-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260407	2026	2	4	7	2026-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260408	2026	2	4	8	2026-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260409	2026	2	4	9	2026-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260410	2026	2	4	10	2026-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260411	2026	2	4	11	2026-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260412	2026	2	4	12	2026-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260413	2026	2	4	13	2026-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260414	2026	2	4	14	2026-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260415	2026	2	4	15	2026-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260416	2026	2	4	16	2026-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260417	2026	2	4	17	2026-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260418	2026	2	4	18	2026-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260419	2026	2	4	19	2026-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260420	2026	2	4	20	2026-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260421	2026	2	4	21	2026-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260422	2026	2	4	22	2026-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260423	2026	2	4	23	2026-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260424	2026	2	4	24	2026-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260425	2026	2	4	25	2026-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260426	2026	2	4	26	2026-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260427	2026	2	4	27	2026-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260428	2026	2	4	28	2026-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260429	2026	2	4	29	2026-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260430	2026	2	4	30	2026-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20260501	2026	2	5	1	2026-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20260502	2026	2	5	2	2026-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20260503	2026	2	5	3	2026-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20260504	2026	2	5	4	2026-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20260505	2026	2	5	5	2026-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20260506	2026	2	5	6	2026-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20260507	2026	2	5	7	2026-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20260508	2026	2	5	8	2026-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20260509	2026	2	5	9	2026-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20260510	2026	2	5	10	2026-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20260511	2026	2	5	11	2026-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20260512	2026	2	5	12	2026-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20260513	2026	2	5	13	2026-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20260514	2026	2	5	14	2026-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20260515	2026	2	5	15	2026-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20260516	2026	2	5	16	2026-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20260517	2026	2	5	17	2026-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20260518	2026	2	5	18	2026-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20260519	2026	2	5	19	2026-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20260520	2026	2	5	20	2026-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20260521	2026	2	5	21	2026-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20260522	2026	2	5	22	2026-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20260523	2026	2	5	23	2026-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20260524	2026	2	5	24	2026-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20260525	2026	2	5	25	2026-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20260526	2026	2	5	26	2026-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20260527	2026	2	5	27	2026-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20260528	2026	2	5	28	2026-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20260529	2026	2	5	29	2026-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20260530	2026	2	5	30	2026-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20260531	2026	2	5	31	2026-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20260601	2026	2	6	1	2026-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260602	2026	2	6	2	2026-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260603	2026	2	6	3	2026-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260604	2026	2	6	4	2026-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260605	2026	2	6	5	2026-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260606	2026	2	6	6	2026-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260607	2026	2	6	7	2026-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260608	2026	2	6	8	2026-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260609	2026	2	6	9	2026-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260610	2026	2	6	10	2026-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260611	2026	2	6	11	2026-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260612	2026	2	6	12	2026-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260613	2026	2	6	13	2026-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260614	2026	2	6	14	2026-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260615	2026	2	6	15	2026-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260616	2026	2	6	16	2026-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260617	2026	2	6	17	2026-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260618	2026	2	6	18	2026-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260619	2026	2	6	19	2026-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260620	2026	2	6	20	2026-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260621	2026	2	6	21	2026-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260622	2026	2	6	22	2026-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260623	2026	2	6	23	2026-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260624	2026	2	6	24	2026-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260625	2026	2	6	25	2026-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260626	2026	2	6	26	2026-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260627	2026	2	6	27	2026-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260628	2026	2	6	28	2026-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260629	2026	2	6	29	2026-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260630	2026	2	6	30	2026-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20260701	2026	3	7	1	2026-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20260702	2026	3	7	2	2026-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20260703	2026	3	7	3	2026-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20260704	2026	3	7	4	2026-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20260705	2026	3	7	5	2026-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20260706	2026	3	7	6	2026-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20260707	2026	3	7	7	2026-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20260708	2026	3	7	8	2026-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20260709	2026	3	7	9	2026-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20260710	2026	3	7	10	2026-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20260711	2026	3	7	11	2026-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20260712	2026	3	7	12	2026-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20260713	2026	3	7	13	2026-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20260714	2026	3	7	14	2026-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20260715	2026	3	7	15	2026-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20260716	2026	3	7	16	2026-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20260717	2026	3	7	17	2026-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20260718	2026	3	7	18	2026-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20260719	2026	3	7	19	2026-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20260720	2026	3	7	20	2026-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20260721	2026	3	7	21	2026-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20260722	2026	3	7	22	2026-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20260723	2026	3	7	23	2026-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20260724	2026	3	7	24	2026-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20260725	2026	3	7	25	2026-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20260726	2026	3	7	26	2026-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20260727	2026	3	7	27	2026-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20260728	2026	3	7	28	2026-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20260729	2026	3	7	29	2026-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20260730	2026	3	7	30	2026-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20260731	2026	3	7	31	2026-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20260801	2026	3	8	1	2026-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260802	2026	3	8	2	2026-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260803	2026	3	8	3	2026-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260804	2026	3	8	4	2026-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260805	2026	3	8	5	2026-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260806	2026	3	8	6	2026-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260807	2026	3	8	7	2026-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260808	2026	3	8	8	2026-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260809	2026	3	8	9	2026-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260810	2026	3	8	10	2026-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260811	2026	3	8	11	2026-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260812	2026	3	8	12	2026-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260813	2026	3	8	13	2026-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260814	2026	3	8	14	2026-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260815	2026	3	8	15	2026-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260816	2026	3	8	16	2026-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260817	2026	3	8	17	2026-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260818	2026	3	8	18	2026-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260819	2026	3	8	19	2026-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260820	2026	3	8	20	2026-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260821	2026	3	8	21	2026-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260822	2026	3	8	22	2026-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260823	2026	3	8	23	2026-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260824	2026	3	8	24	2026-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260825	2026	3	8	25	2026-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260826	2026	3	8	26	2026-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260827	2026	3	8	27	2026-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260828	2026	3	8	28	2026-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260829	2026	3	8	29	2026-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260830	2026	3	8	30	2026-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260831	2026	3	8	31	2026-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20260901	2026	3	9	1	2026-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260902	2026	3	9	2	2026-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260903	2026	3	9	3	2026-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260904	2026	3	9	4	2026-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260905	2026	3	9	5	2026-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260906	2026	3	9	6	2026-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260907	2026	3	9	7	2026-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260908	2026	3	9	8	2026-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260909	2026	3	9	9	2026-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260910	2026	3	9	10	2026-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260911	2026	3	9	11	2026-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260912	2026	3	9	12	2026-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260913	2026	3	9	13	2026-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260914	2026	3	9	14	2026-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260915	2026	3	9	15	2026-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260916	2026	3	9	16	2026-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260917	2026	3	9	17	2026-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260918	2026	3	9	18	2026-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260919	2026	3	9	19	2026-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260920	2026	3	9	20	2026-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260921	2026	3	9	21	2026-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260922	2026	3	9	22	2026-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260923	2026	3	9	23	2026-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260924	2026	3	9	24	2026-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260925	2026	3	9	25	2026-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260926	2026	3	9	26	2026-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260927	2026	3	9	27	2026-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260928	2026	3	9	28	2026-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260929	2026	3	9	29	2026-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20260930	2026	3	9	30	2026-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20261001	2026	4	10	1	2026-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261002	2026	4	10	2	2026-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261003	2026	4	10	3	2026-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261004	2026	4	10	4	2026-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261005	2026	4	10	5	2026-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261006	2026	4	10	6	2026-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261007	2026	4	10	7	2026-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261008	2026	4	10	8	2026-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261009	2026	4	10	9	2026-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261010	2026	4	10	10	2026-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261011	2026	4	10	11	2026-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261012	2026	4	10	12	2026-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261013	2026	4	10	13	2026-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261014	2026	4	10	14	2026-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261015	2026	4	10	15	2026-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261016	2026	4	10	16	2026-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261017	2026	4	10	17	2026-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261018	2026	4	10	18	2026-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261019	2026	4	10	19	2026-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261020	2026	4	10	20	2026-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261021	2026	4	10	21	2026-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261022	2026	4	10	22	2026-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261023	2026	4	10	23	2026-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261024	2026	4	10	24	2026-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261025	2026	4	10	25	2026-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261026	2026	4	10	26	2026-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261027	2026	4	10	27	2026-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261028	2026	4	10	28	2026-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261029	2026	4	10	29	2026-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261030	2026	4	10	30	2026-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261031	2026	4	10	31	2026-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20261101	2026	4	11	1	2026-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261102	2026	4	11	2	2026-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261103	2026	4	11	3	2026-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261104	2026	4	11	4	2026-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261105	2026	4	11	5	2026-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261106	2026	4	11	6	2026-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261107	2026	4	11	7	2026-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261108	2026	4	11	8	2026-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261109	2026	4	11	9	2026-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261110	2026	4	11	10	2026-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261111	2026	4	11	11	2026-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261112	2026	4	11	12	2026-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261113	2026	4	11	13	2026-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261114	2026	4	11	14	2026-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261115	2026	4	11	15	2026-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261116	2026	4	11	16	2026-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261117	2026	4	11	17	2026-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261118	2026	4	11	18	2026-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261119	2026	4	11	19	2026-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261120	2026	4	11	20	2026-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261121	2026	4	11	21	2026-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261122	2026	4	11	22	2026-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261123	2026	4	11	23	2026-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261124	2026	4	11	24	2026-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261125	2026	4	11	25	2026-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261126	2026	4	11	26	2026-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261127	2026	4	11	27	2026-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261128	2026	4	11	28	2026-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261129	2026	4	11	29	2026-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261130	2026	4	11	30	2026-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20261201	2026	4	12	1	2026-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261202	2026	4	12	2	2026-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261203	2026	4	12	3	2026-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261204	2026	4	12	4	2026-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261205	2026	4	12	5	2026-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261206	2026	4	12	6	2026-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261207	2026	4	12	7	2026-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261208	2026	4	12	8	2026-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261209	2026	4	12	9	2026-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261210	2026	4	12	10	2026-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261211	2026	4	12	11	2026-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261212	2026	4	12	12	2026-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261213	2026	4	12	13	2026-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261214	2026	4	12	14	2026-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261215	2026	4	12	15	2026-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261216	2026	4	12	16	2026-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261217	2026	4	12	17	2026-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261218	2026	4	12	18	2026-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261219	2026	4	12	19	2026-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261220	2026	4	12	20	2026-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261221	2026	4	12	21	2026-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261222	2026	4	12	22	2026-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261223	2026	4	12	23	2026-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261224	2026	4	12	24	2026-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261225	2026	4	12	25	2026-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261226	2026	4	12	26	2026-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261227	2026	4	12	27	2026-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261228	2026	4	12	28	2026-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261229	2026	4	12	29	2026-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261230	2026	4	12	30	2026-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20261231	2026	4	12	31	2026-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20270101	2027	1	1	1	2027-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20270102	2027	1	1	2	2027-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20270103	2027	1	1	3	2027-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20270104	2027	1	1	4	2027-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20270105	2027	1	1	5	2027-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20270106	2027	1	1	6	2027-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20270107	2027	1	1	7	2027-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20270108	2027	1	1	8	2027-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20270109	2027	1	1	9	2027-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20270110	2027	1	1	10	2027-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20270111	2027	1	1	11	2027-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20270112	2027	1	1	12	2027-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20270113	2027	1	1	13	2027-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20270114	2027	1	1	14	2027-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20270115	2027	1	1	15	2027-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20270116	2027	1	1	16	2027-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20270117	2027	1	1	17	2027-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20270118	2027	1	1	18	2027-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20270119	2027	1	1	19	2027-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20270120	2027	1	1	20	2027-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20270121	2027	1	1	21	2027-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20270122	2027	1	1	22	2027-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20270123	2027	1	1	23	2027-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20270124	2027	1	1	24	2027-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20270125	2027	1	1	25	2027-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20270126	2027	1	1	26	2027-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20270127	2027	1	1	27	2027-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20270128	2027	1	1	28	2027-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20270129	2027	1	1	29	2027-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20270130	2027	1	1	30	2027-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20270131	2027	1	1	31	2027-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20270201	2027	1	2	1	2027-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270202	2027	1	2	2	2027-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270203	2027	1	2	3	2027-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270204	2027	1	2	4	2027-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270205	2027	1	2	5	2027-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270206	2027	1	2	6	2027-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270207	2027	1	2	7	2027-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270208	2027	1	2	8	2027-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270209	2027	1	2	9	2027-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270210	2027	1	2	10	2027-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270211	2027	1	2	11	2027-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270212	2027	1	2	12	2027-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270213	2027	1	2	13	2027-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270214	2027	1	2	14	2027-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270215	2027	1	2	15	2027-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270216	2027	1	2	16	2027-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270217	2027	1	2	17	2027-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270218	2027	1	2	18	2027-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270219	2027	1	2	19	2027-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270220	2027	1	2	20	2027-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270221	2027	1	2	21	2027-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270222	2027	1	2	22	2027-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270223	2027	1	2	23	2027-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270224	2027	1	2	24	2027-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270225	2027	1	2	25	2027-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270226	2027	1	2	26	2027-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270227	2027	1	2	27	2027-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270228	2027	1	2	28	2027-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20270301	2027	1	3	1	2027-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20270302	2027	1	3	2	2027-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20270303	2027	1	3	3	2027-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20270304	2027	1	3	4	2027-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20270305	2027	1	3	5	2027-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20270306	2027	1	3	6	2027-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20270307	2027	1	3	7	2027-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20270308	2027	1	3	8	2027-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20270309	2027	1	3	9	2027-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20270310	2027	1	3	10	2027-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20270311	2027	1	3	11	2027-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20270312	2027	1	3	12	2027-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20270313	2027	1	3	13	2027-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20270314	2027	1	3	14	2027-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20270315	2027	1	3	15	2027-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20270316	2027	1	3	16	2027-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20270317	2027	1	3	17	2027-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20270318	2027	1	3	18	2027-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20270319	2027	1	3	19	2027-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20270320	2027	1	3	20	2027-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20270321	2027	1	3	21	2027-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20270322	2027	1	3	22	2027-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20270323	2027	1	3	23	2027-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20270324	2027	1	3	24	2027-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20270325	2027	1	3	25	2027-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20270326	2027	1	3	26	2027-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20270327	2027	1	3	27	2027-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20270328	2027	1	3	28	2027-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20270329	2027	1	3	29	2027-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20270330	2027	1	3	30	2027-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20270331	2027	1	3	31	2027-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20270401	2027	2	4	1	2027-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270402	2027	2	4	2	2027-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270403	2027	2	4	3	2027-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270404	2027	2	4	4	2027-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270405	2027	2	4	5	2027-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270406	2027	2	4	6	2027-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270407	2027	2	4	7	2027-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270408	2027	2	4	8	2027-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270409	2027	2	4	9	2027-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270410	2027	2	4	10	2027-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270411	2027	2	4	11	2027-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270412	2027	2	4	12	2027-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270413	2027	2	4	13	2027-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270414	2027	2	4	14	2027-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270415	2027	2	4	15	2027-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270416	2027	2	4	16	2027-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270417	2027	2	4	17	2027-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270418	2027	2	4	18	2027-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270419	2027	2	4	19	2027-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270420	2027	2	4	20	2027-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270421	2027	2	4	21	2027-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270422	2027	2	4	22	2027-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270423	2027	2	4	23	2027-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270424	2027	2	4	24	2027-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270425	2027	2	4	25	2027-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270426	2027	2	4	26	2027-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270427	2027	2	4	27	2027-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270428	2027	2	4	28	2027-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270429	2027	2	4	29	2027-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270430	2027	2	4	30	2027-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20270501	2027	2	5	1	2027-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20270502	2027	2	5	2	2027-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20270503	2027	2	5	3	2027-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20270504	2027	2	5	4	2027-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20270505	2027	2	5	5	2027-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20270506	2027	2	5	6	2027-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20270507	2027	2	5	7	2027-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20270508	2027	2	5	8	2027-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20270509	2027	2	5	9	2027-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20270510	2027	2	5	10	2027-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20270511	2027	2	5	11	2027-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20270512	2027	2	5	12	2027-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20270513	2027	2	5	13	2027-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20270514	2027	2	5	14	2027-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20270515	2027	2	5	15	2027-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20270516	2027	2	5	16	2027-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20270517	2027	2	5	17	2027-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20270518	2027	2	5	18	2027-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20270519	2027	2	5	19	2027-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20270520	2027	2	5	20	2027-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20270521	2027	2	5	21	2027-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20270522	2027	2	5	22	2027-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20270523	2027	2	5	23	2027-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20270524	2027	2	5	24	2027-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20270525	2027	2	5	25	2027-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20270526	2027	2	5	26	2027-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20270527	2027	2	5	27	2027-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20270528	2027	2	5	28	2027-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20270529	2027	2	5	29	2027-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20270530	2027	2	5	30	2027-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20270531	2027	2	5	31	2027-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20270601	2027	2	6	1	2027-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270602	2027	2	6	2	2027-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270603	2027	2	6	3	2027-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270604	2027	2	6	4	2027-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270605	2027	2	6	5	2027-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270606	2027	2	6	6	2027-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270607	2027	2	6	7	2027-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270608	2027	2	6	8	2027-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270609	2027	2	6	9	2027-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270610	2027	2	6	10	2027-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270611	2027	2	6	11	2027-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270612	2027	2	6	12	2027-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270613	2027	2	6	13	2027-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270614	2027	2	6	14	2027-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270615	2027	2	6	15	2027-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270616	2027	2	6	16	2027-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270617	2027	2	6	17	2027-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270618	2027	2	6	18	2027-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270619	2027	2	6	19	2027-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270620	2027	2	6	20	2027-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270621	2027	2	6	21	2027-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270622	2027	2	6	22	2027-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270623	2027	2	6	23	2027-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270624	2027	2	6	24	2027-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270625	2027	2	6	25	2027-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270626	2027	2	6	26	2027-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270627	2027	2	6	27	2027-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270628	2027	2	6	28	2027-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270629	2027	2	6	29	2027-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270630	2027	2	6	30	2027-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20270701	2027	3	7	1	2027-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20270702	2027	3	7	2	2027-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20270703	2027	3	7	3	2027-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20270704	2027	3	7	4	2027-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20270705	2027	3	7	5	2027-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20270706	2027	3	7	6	2027-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20270707	2027	3	7	7	2027-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20270708	2027	3	7	8	2027-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20270709	2027	3	7	9	2027-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20270710	2027	3	7	10	2027-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20270711	2027	3	7	11	2027-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20270712	2027	3	7	12	2027-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20270713	2027	3	7	13	2027-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20270714	2027	3	7	14	2027-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20270715	2027	3	7	15	2027-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20270716	2027	3	7	16	2027-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20270717	2027	3	7	17	2027-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20270718	2027	3	7	18	2027-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20270719	2027	3	7	19	2027-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20270720	2027	3	7	20	2027-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20270721	2027	3	7	21	2027-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20270722	2027	3	7	22	2027-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20270723	2027	3	7	23	2027-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20270724	2027	3	7	24	2027-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20270725	2027	3	7	25	2027-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20270726	2027	3	7	26	2027-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20270727	2027	3	7	27	2027-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20270728	2027	3	7	28	2027-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20270729	2027	3	7	29	2027-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20270730	2027	3	7	30	2027-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20270731	2027	3	7	31	2027-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20270801	2027	3	8	1	2027-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270802	2027	3	8	2	2027-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270803	2027	3	8	3	2027-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270804	2027	3	8	4	2027-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270805	2027	3	8	5	2027-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270806	2027	3	8	6	2027-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270807	2027	3	8	7	2027-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270808	2027	3	8	8	2027-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270809	2027	3	8	9	2027-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270810	2027	3	8	10	2027-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270811	2027	3	8	11	2027-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270812	2027	3	8	12	2027-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270813	2027	3	8	13	2027-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270814	2027	3	8	14	2027-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270815	2027	3	8	15	2027-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270816	2027	3	8	16	2027-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270817	2027	3	8	17	2027-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270818	2027	3	8	18	2027-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270819	2027	3	8	19	2027-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270820	2027	3	8	20	2027-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270821	2027	3	8	21	2027-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270822	2027	3	8	22	2027-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270823	2027	3	8	23	2027-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270824	2027	3	8	24	2027-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270825	2027	3	8	25	2027-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270826	2027	3	8	26	2027-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270827	2027	3	8	27	2027-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270828	2027	3	8	28	2027-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270829	2027	3	8	29	2027-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270830	2027	3	8	30	2027-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270831	2027	3	8	31	2027-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20270901	2027	3	9	1	2027-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270902	2027	3	9	2	2027-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270903	2027	3	9	3	2027-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270904	2027	3	9	4	2027-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270905	2027	3	9	5	2027-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270906	2027	3	9	6	2027-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270907	2027	3	9	7	2027-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270908	2027	3	9	8	2027-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270909	2027	3	9	9	2027-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270910	2027	3	9	10	2027-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270911	2027	3	9	11	2027-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270912	2027	3	9	12	2027-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270913	2027	3	9	13	2027-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270914	2027	3	9	14	2027-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270915	2027	3	9	15	2027-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270916	2027	3	9	16	2027-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270917	2027	3	9	17	2027-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270918	2027	3	9	18	2027-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270919	2027	3	9	19	2027-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270920	2027	3	9	20	2027-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270921	2027	3	9	21	2027-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270922	2027	3	9	22	2027-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270923	2027	3	9	23	2027-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270924	2027	3	9	24	2027-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270925	2027	3	9	25	2027-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270926	2027	3	9	26	2027-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270927	2027	3	9	27	2027-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270928	2027	3	9	28	2027-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270929	2027	3	9	29	2027-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20270930	2027	3	9	30	2027-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20271001	2027	4	10	1	2027-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271002	2027	4	10	2	2027-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271003	2027	4	10	3	2027-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271004	2027	4	10	4	2027-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271005	2027	4	10	5	2027-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271006	2027	4	10	6	2027-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271007	2027	4	10	7	2027-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271008	2027	4	10	8	2027-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271009	2027	4	10	9	2027-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271010	2027	4	10	10	2027-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271011	2027	4	10	11	2027-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271012	2027	4	10	12	2027-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271013	2027	4	10	13	2027-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271014	2027	4	10	14	2027-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271015	2027	4	10	15	2027-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271016	2027	4	10	16	2027-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271017	2027	4	10	17	2027-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271018	2027	4	10	18	2027-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271019	2027	4	10	19	2027-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271020	2027	4	10	20	2027-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271021	2027	4	10	21	2027-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271022	2027	4	10	22	2027-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271023	2027	4	10	23	2027-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271024	2027	4	10	24	2027-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271025	2027	4	10	25	2027-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271026	2027	4	10	26	2027-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271027	2027	4	10	27	2027-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271028	2027	4	10	28	2027-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271029	2027	4	10	29	2027-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271030	2027	4	10	30	2027-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271031	2027	4	10	31	2027-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20271101	2027	4	11	1	2027-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271102	2027	4	11	2	2027-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271103	2027	4	11	3	2027-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271104	2027	4	11	4	2027-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271105	2027	4	11	5	2027-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271106	2027	4	11	6	2027-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271107	2027	4	11	7	2027-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271108	2027	4	11	8	2027-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271109	2027	4	11	9	2027-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271110	2027	4	11	10	2027-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271111	2027	4	11	11	2027-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271112	2027	4	11	12	2027-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271113	2027	4	11	13	2027-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271114	2027	4	11	14	2027-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271115	2027	4	11	15	2027-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271116	2027	4	11	16	2027-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271117	2027	4	11	17	2027-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271118	2027	4	11	18	2027-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271119	2027	4	11	19	2027-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271120	2027	4	11	20	2027-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271121	2027	4	11	21	2027-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271122	2027	4	11	22	2027-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271123	2027	4	11	23	2027-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271124	2027	4	11	24	2027-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271125	2027	4	11	25	2027-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271126	2027	4	11	26	2027-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271127	2027	4	11	27	2027-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271128	2027	4	11	28	2027-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271129	2027	4	11	29	2027-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271130	2027	4	11	30	2027-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20271201	2027	4	12	1	2027-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271202	2027	4	12	2	2027-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271203	2027	4	12	3	2027-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271204	2027	4	12	4	2027-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271205	2027	4	12	5	2027-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271206	2027	4	12	6	2027-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271207	2027	4	12	7	2027-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271208	2027	4	12	8	2027-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271209	2027	4	12	9	2027-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271210	2027	4	12	10	2027-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271211	2027	4	12	11	2027-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271212	2027	4	12	12	2027-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271213	2027	4	12	13	2027-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271214	2027	4	12	14	2027-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271215	2027	4	12	15	2027-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271216	2027	4	12	16	2027-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271217	2027	4	12	17	2027-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271218	2027	4	12	18	2027-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271219	2027	4	12	19	2027-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271220	2027	4	12	20	2027-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271221	2027	4	12	21	2027-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271222	2027	4	12	22	2027-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271223	2027	4	12	23	2027-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271224	2027	4	12	24	2027-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271225	2027	4	12	25	2027-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271226	2027	4	12	26	2027-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271227	2027	4	12	27	2027-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271228	2027	4	12	28	2027-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271229	2027	4	12	29	2027-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271230	2027	4	12	30	2027-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20271231	2027	4	12	31	2027-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20280101	2028	1	1	1	2028-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20280102	2028	1	1	2	2028-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20280103	2028	1	1	3	2028-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20280104	2028	1	1	4	2028-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20280105	2028	1	1	5	2028-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20280106	2028	1	1	6	2028-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20280107	2028	1	1	7	2028-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20280108	2028	1	1	8	2028-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20280109	2028	1	1	9	2028-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20280110	2028	1	1	10	2028-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20280111	2028	1	1	11	2028-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20280112	2028	1	1	12	2028-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20280113	2028	1	1	13	2028-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20280114	2028	1	1	14	2028-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20280115	2028	1	1	15	2028-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20280116	2028	1	1	16	2028-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20280117	2028	1	1	17	2028-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20280118	2028	1	1	18	2028-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20280119	2028	1	1	19	2028-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20280120	2028	1	1	20	2028-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20280121	2028	1	1	21	2028-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20280122	2028	1	1	22	2028-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20280123	2028	1	1	23	2028-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20280124	2028	1	1	24	2028-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20280125	2028	1	1	25	2028-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20280126	2028	1	1	26	2028-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20280127	2028	1	1	27	2028-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20280128	2028	1	1	28	2028-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20280129	2028	1	1	29	2028-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20280130	2028	1	1	30	2028-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20280131	2028	1	1	31	2028-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20280201	2028	1	2	1	2028-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280202	2028	1	2	2	2028-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280203	2028	1	2	3	2028-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280204	2028	1	2	4	2028-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280205	2028	1	2	5	2028-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280206	2028	1	2	6	2028-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280207	2028	1	2	7	2028-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280208	2028	1	2	8	2028-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280209	2028	1	2	9	2028-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280210	2028	1	2	10	2028-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280211	2028	1	2	11	2028-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280212	2028	1	2	12	2028-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280213	2028	1	2	13	2028-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280214	2028	1	2	14	2028-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280215	2028	1	2	15	2028-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280216	2028	1	2	16	2028-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280217	2028	1	2	17	2028-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280218	2028	1	2	18	2028-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280219	2028	1	2	19	2028-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280220	2028	1	2	20	2028-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280221	2028	1	2	21	2028-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280222	2028	1	2	22	2028-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280223	2028	1	2	23	2028-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280224	2028	1	2	24	2028-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280225	2028	1	2	25	2028-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280226	2028	1	2	26	2028-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280227	2028	1	2	27	2028-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280228	2028	1	2	28	2028-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280229	2028	1	2	29	2028-02-29 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20280301	2028	1	3	1	2028-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20280302	2028	1	3	2	2028-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20280303	2028	1	3	3	2028-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20280304	2028	1	3	4	2028-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20280305	2028	1	3	5	2028-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20280306	2028	1	3	6	2028-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20280307	2028	1	3	7	2028-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20280308	2028	1	3	8	2028-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20280309	2028	1	3	9	2028-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20280310	2028	1	3	10	2028-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20280311	2028	1	3	11	2028-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20280312	2028	1	3	12	2028-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20280313	2028	1	3	13	2028-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20280314	2028	1	3	14	2028-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20280315	2028	1	3	15	2028-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20280316	2028	1	3	16	2028-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20280317	2028	1	3	17	2028-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20280318	2028	1	3	18	2028-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20280319	2028	1	3	19	2028-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20280320	2028	1	3	20	2028-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20280321	2028	1	3	21	2028-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20280322	2028	1	3	22	2028-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20280323	2028	1	3	23	2028-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20280324	2028	1	3	24	2028-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20280325	2028	1	3	25	2028-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20280326	2028	1	3	26	2028-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20280327	2028	1	3	27	2028-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20280328	2028	1	3	28	2028-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20280329	2028	1	3	29	2028-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20280330	2028	1	3	30	2028-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20280331	2028	1	3	31	2028-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20280401	2028	2	4	1	2028-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280402	2028	2	4	2	2028-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280403	2028	2	4	3	2028-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280404	2028	2	4	4	2028-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280405	2028	2	4	5	2028-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280406	2028	2	4	6	2028-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280407	2028	2	4	7	2028-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280408	2028	2	4	8	2028-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280409	2028	2	4	9	2028-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280410	2028	2	4	10	2028-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280411	2028	2	4	11	2028-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280412	2028	2	4	12	2028-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280413	2028	2	4	13	2028-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280414	2028	2	4	14	2028-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280415	2028	2	4	15	2028-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280416	2028	2	4	16	2028-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280417	2028	2	4	17	2028-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280418	2028	2	4	18	2028-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280419	2028	2	4	19	2028-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280420	2028	2	4	20	2028-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280421	2028	2	4	21	2028-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280422	2028	2	4	22	2028-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280423	2028	2	4	23	2028-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280424	2028	2	4	24	2028-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280425	2028	2	4	25	2028-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280426	2028	2	4	26	2028-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280427	2028	2	4	27	2028-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280428	2028	2	4	28	2028-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280429	2028	2	4	29	2028-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280430	2028	2	4	30	2028-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20280501	2028	2	5	1	2028-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20280502	2028	2	5	2	2028-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20280503	2028	2	5	3	2028-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20280504	2028	2	5	4	2028-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20280505	2028	2	5	5	2028-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20280506	2028	2	5	6	2028-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20280507	2028	2	5	7	2028-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20280508	2028	2	5	8	2028-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20280509	2028	2	5	9	2028-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20280510	2028	2	5	10	2028-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20280511	2028	2	5	11	2028-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20280512	2028	2	5	12	2028-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20280513	2028	2	5	13	2028-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20280514	2028	2	5	14	2028-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20280515	2028	2	5	15	2028-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20280516	2028	2	5	16	2028-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20280517	2028	2	5	17	2028-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20280518	2028	2	5	18	2028-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20280519	2028	2	5	19	2028-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20280520	2028	2	5	20	2028-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20280521	2028	2	5	21	2028-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20280522	2028	2	5	22	2028-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20280523	2028	2	5	23	2028-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20280524	2028	2	5	24	2028-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20280525	2028	2	5	25	2028-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20280526	2028	2	5	26	2028-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20280527	2028	2	5	27	2028-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20280528	2028	2	5	28	2028-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20280529	2028	2	5	29	2028-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20280530	2028	2	5	30	2028-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20280531	2028	2	5	31	2028-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20280601	2028	2	6	1	2028-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280602	2028	2	6	2	2028-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280603	2028	2	6	3	2028-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280604	2028	2	6	4	2028-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280605	2028	2	6	5	2028-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280606	2028	2	6	6	2028-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280607	2028	2	6	7	2028-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280608	2028	2	6	8	2028-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280609	2028	2	6	9	2028-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280610	2028	2	6	10	2028-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280611	2028	2	6	11	2028-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280612	2028	2	6	12	2028-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280613	2028	2	6	13	2028-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280614	2028	2	6	14	2028-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280615	2028	2	6	15	2028-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280616	2028	2	6	16	2028-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280617	2028	2	6	17	2028-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280618	2028	2	6	18	2028-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280619	2028	2	6	19	2028-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280620	2028	2	6	20	2028-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280621	2028	2	6	21	2028-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280622	2028	2	6	22	2028-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280623	2028	2	6	23	2028-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280624	2028	2	6	24	2028-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280625	2028	2	6	25	2028-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280626	2028	2	6	26	2028-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280627	2028	2	6	27	2028-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280628	2028	2	6	28	2028-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280629	2028	2	6	29	2028-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280630	2028	2	6	30	2028-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20280701	2028	3	7	1	2028-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20280702	2028	3	7	2	2028-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20280703	2028	3	7	3	2028-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20280704	2028	3	7	4	2028-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20280705	2028	3	7	5	2028-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20280706	2028	3	7	6	2028-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20280707	2028	3	7	7	2028-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20280708	2028	3	7	8	2028-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20280709	2028	3	7	9	2028-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20280710	2028	3	7	10	2028-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20280711	2028	3	7	11	2028-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20280712	2028	3	7	12	2028-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20280713	2028	3	7	13	2028-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20280714	2028	3	7	14	2028-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20280715	2028	3	7	15	2028-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20280716	2028	3	7	16	2028-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20280717	2028	3	7	17	2028-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20280718	2028	3	7	18	2028-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20280719	2028	3	7	19	2028-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20280720	2028	3	7	20	2028-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20280721	2028	3	7	21	2028-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20280722	2028	3	7	22	2028-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20280723	2028	3	7	23	2028-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20280724	2028	3	7	24	2028-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20280725	2028	3	7	25	2028-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20280726	2028	3	7	26	2028-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20280727	2028	3	7	27	2028-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20280728	2028	3	7	28	2028-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20280729	2028	3	7	29	2028-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20280730	2028	3	7	30	2028-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20280731	2028	3	7	31	2028-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20280801	2028	3	8	1	2028-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280802	2028	3	8	2	2028-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280803	2028	3	8	3	2028-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280804	2028	3	8	4	2028-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280805	2028	3	8	5	2028-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280806	2028	3	8	6	2028-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280807	2028	3	8	7	2028-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280808	2028	3	8	8	2028-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280809	2028	3	8	9	2028-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280810	2028	3	8	10	2028-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280811	2028	3	8	11	2028-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280812	2028	3	8	12	2028-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280813	2028	3	8	13	2028-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280814	2028	3	8	14	2028-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280815	2028	3	8	15	2028-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280816	2028	3	8	16	2028-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280817	2028	3	8	17	2028-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280818	2028	3	8	18	2028-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280819	2028	3	8	19	2028-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280820	2028	3	8	20	2028-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280821	2028	3	8	21	2028-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280822	2028	3	8	22	2028-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280823	2028	3	8	23	2028-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280824	2028	3	8	24	2028-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280825	2028	3	8	25	2028-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280826	2028	3	8	26	2028-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280827	2028	3	8	27	2028-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280828	2028	3	8	28	2028-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280829	2028	3	8	29	2028-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280830	2028	3	8	30	2028-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280831	2028	3	8	31	2028-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20280901	2028	3	9	1	2028-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280902	2028	3	9	2	2028-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280903	2028	3	9	3	2028-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280904	2028	3	9	4	2028-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280905	2028	3	9	5	2028-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280906	2028	3	9	6	2028-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280907	2028	3	9	7	2028-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280908	2028	3	9	8	2028-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280909	2028	3	9	9	2028-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280910	2028	3	9	10	2028-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280911	2028	3	9	11	2028-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280912	2028	3	9	12	2028-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280913	2028	3	9	13	2028-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280914	2028	3	9	14	2028-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280915	2028	3	9	15	2028-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280916	2028	3	9	16	2028-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280917	2028	3	9	17	2028-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280918	2028	3	9	18	2028-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280919	2028	3	9	19	2028-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280920	2028	3	9	20	2028-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280921	2028	3	9	21	2028-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280922	2028	3	9	22	2028-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280923	2028	3	9	23	2028-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280924	2028	3	9	24	2028-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280925	2028	3	9	25	2028-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280926	2028	3	9	26	2028-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280927	2028	3	9	27	2028-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280928	2028	3	9	28	2028-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280929	2028	3	9	29	2028-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20280930	2028	3	9	30	2028-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20281001	2028	4	10	1	2028-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281002	2028	4	10	2	2028-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281003	2028	4	10	3	2028-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281004	2028	4	10	4	2028-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281005	2028	4	10	5	2028-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281006	2028	4	10	6	2028-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281007	2028	4	10	7	2028-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281008	2028	4	10	8	2028-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281009	2028	4	10	9	2028-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281010	2028	4	10	10	2028-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281011	2028	4	10	11	2028-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281012	2028	4	10	12	2028-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281013	2028	4	10	13	2028-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281014	2028	4	10	14	2028-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281015	2028	4	10	15	2028-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281016	2028	4	10	16	2028-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281017	2028	4	10	17	2028-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281018	2028	4	10	18	2028-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281019	2028	4	10	19	2028-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281020	2028	4	10	20	2028-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281021	2028	4	10	21	2028-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281022	2028	4	10	22	2028-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281023	2028	4	10	23	2028-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281024	2028	4	10	24	2028-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281025	2028	4	10	25	2028-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281026	2028	4	10	26	2028-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281027	2028	4	10	27	2028-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281028	2028	4	10	28	2028-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281029	2028	4	10	29	2028-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281030	2028	4	10	30	2028-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281031	2028	4	10	31	2028-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20281101	2028	4	11	1	2028-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281102	2028	4	11	2	2028-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281103	2028	4	11	3	2028-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281104	2028	4	11	4	2028-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281105	2028	4	11	5	2028-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281106	2028	4	11	6	2028-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281107	2028	4	11	7	2028-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281108	2028	4	11	8	2028-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281109	2028	4	11	9	2028-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281110	2028	4	11	10	2028-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281111	2028	4	11	11	2028-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281112	2028	4	11	12	2028-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281113	2028	4	11	13	2028-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281114	2028	4	11	14	2028-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281115	2028	4	11	15	2028-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281116	2028	4	11	16	2028-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281117	2028	4	11	17	2028-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281118	2028	4	11	18	2028-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281119	2028	4	11	19	2028-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281120	2028	4	11	20	2028-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281121	2028	4	11	21	2028-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281122	2028	4	11	22	2028-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281123	2028	4	11	23	2028-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281124	2028	4	11	24	2028-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281125	2028	4	11	25	2028-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281126	2028	4	11	26	2028-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281127	2028	4	11	27	2028-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281128	2028	4	11	28	2028-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281129	2028	4	11	29	2028-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281130	2028	4	11	30	2028-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20281201	2028	4	12	1	2028-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281202	2028	4	12	2	2028-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281203	2028	4	12	3	2028-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281204	2028	4	12	4	2028-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281205	2028	4	12	5	2028-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281206	2028	4	12	6	2028-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281207	2028	4	12	7	2028-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281208	2028	4	12	8	2028-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281209	2028	4	12	9	2028-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281210	2028	4	12	10	2028-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281211	2028	4	12	11	2028-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281212	2028	4	12	12	2028-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281213	2028	4	12	13	2028-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281214	2028	4	12	14	2028-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281215	2028	4	12	15	2028-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281216	2028	4	12	16	2028-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281217	2028	4	12	17	2028-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281218	2028	4	12	18	2028-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281219	2028	4	12	19	2028-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281220	2028	4	12	20	2028-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281221	2028	4	12	21	2028-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281222	2028	4	12	22	2028-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281223	2028	4	12	23	2028-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281224	2028	4	12	24	2028-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281225	2028	4	12	25	2028-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281226	2028	4	12	26	2028-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281227	2028	4	12	27	2028-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281228	2028	4	12	28	2028-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281229	2028	4	12	29	2028-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281230	2028	4	12	30	2028-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20281231	2028	4	12	31	2028-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20290101	2029	1	1	1	2029-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20290102	2029	1	1	2	2029-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20290103	2029	1	1	3	2029-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20290104	2029	1	1	4	2029-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20290105	2029	1	1	5	2029-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20290106	2029	1	1	6	2029-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20290107	2029	1	1	7	2029-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20290108	2029	1	1	8	2029-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20290109	2029	1	1	9	2029-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20290110	2029	1	1	10	2029-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20290111	2029	1	1	11	2029-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20290112	2029	1	1	12	2029-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20290113	2029	1	1	13	2029-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20290114	2029	1	1	14	2029-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20290115	2029	1	1	15	2029-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20290116	2029	1	1	16	2029-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20290117	2029	1	1	17	2029-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20290118	2029	1	1	18	2029-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20290119	2029	1	1	19	2029-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20290120	2029	1	1	20	2029-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20290121	2029	1	1	21	2029-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20290122	2029	1	1	22	2029-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20290123	2029	1	1	23	2029-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20290124	2029	1	1	24	2029-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20290125	2029	1	1	25	2029-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20290126	2029	1	1	26	2029-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20290127	2029	1	1	27	2029-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20290128	2029	1	1	28	2029-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20290129	2029	1	1	29	2029-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20290130	2029	1	1	30	2029-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20290131	2029	1	1	31	2029-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20290201	2029	1	2	1	2029-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290202	2029	1	2	2	2029-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290203	2029	1	2	3	2029-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290204	2029	1	2	4	2029-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290205	2029	1	2	5	2029-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290206	2029	1	2	6	2029-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290207	2029	1	2	7	2029-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290208	2029	1	2	8	2029-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290209	2029	1	2	9	2029-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290210	2029	1	2	10	2029-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290211	2029	1	2	11	2029-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290212	2029	1	2	12	2029-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290213	2029	1	2	13	2029-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290214	2029	1	2	14	2029-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290215	2029	1	2	15	2029-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290216	2029	1	2	16	2029-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290217	2029	1	2	17	2029-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290218	2029	1	2	18	2029-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290219	2029	1	2	19	2029-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290220	2029	1	2	20	2029-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290221	2029	1	2	21	2029-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290222	2029	1	2	22	2029-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290223	2029	1	2	23	2029-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290224	2029	1	2	24	2029-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290225	2029	1	2	25	2029-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290226	2029	1	2	26	2029-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290227	2029	1	2	27	2029-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290228	2029	1	2	28	2029-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20290301	2029	1	3	1	2029-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20290302	2029	1	3	2	2029-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20290303	2029	1	3	3	2029-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20290304	2029	1	3	4	2029-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20290305	2029	1	3	5	2029-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20290306	2029	1	3	6	2029-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20290307	2029	1	3	7	2029-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20290308	2029	1	3	8	2029-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20290309	2029	1	3	9	2029-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20290310	2029	1	3	10	2029-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20290311	2029	1	3	11	2029-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20290312	2029	1	3	12	2029-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20290313	2029	1	3	13	2029-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20290314	2029	1	3	14	2029-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20290315	2029	1	3	15	2029-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20290316	2029	1	3	16	2029-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20290317	2029	1	3	17	2029-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20290318	2029	1	3	18	2029-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20290319	2029	1	3	19	2029-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20290320	2029	1	3	20	2029-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20290321	2029	1	3	21	2029-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20290322	2029	1	3	22	2029-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20290323	2029	1	3	23	2029-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20290324	2029	1	3	24	2029-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20290325	2029	1	3	25	2029-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20290326	2029	1	3	26	2029-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20290327	2029	1	3	27	2029-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20290328	2029	1	3	28	2029-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20290329	2029	1	3	29	2029-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20290330	2029	1	3	30	2029-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20290331	2029	1	3	31	2029-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20290401	2029	2	4	1	2029-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290402	2029	2	4	2	2029-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290403	2029	2	4	3	2029-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290404	2029	2	4	4	2029-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290405	2029	2	4	5	2029-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290406	2029	2	4	6	2029-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290407	2029	2	4	7	2029-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290408	2029	2	4	8	2029-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290409	2029	2	4	9	2029-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290410	2029	2	4	10	2029-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290411	2029	2	4	11	2029-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290412	2029	2	4	12	2029-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290413	2029	2	4	13	2029-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290414	2029	2	4	14	2029-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290415	2029	2	4	15	2029-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290416	2029	2	4	16	2029-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290417	2029	2	4	17	2029-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290418	2029	2	4	18	2029-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290419	2029	2	4	19	2029-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290420	2029	2	4	20	2029-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290421	2029	2	4	21	2029-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290422	2029	2	4	22	2029-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290423	2029	2	4	23	2029-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290424	2029	2	4	24	2029-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290425	2029	2	4	25	2029-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290426	2029	2	4	26	2029-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290427	2029	2	4	27	2029-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290428	2029	2	4	28	2029-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290429	2029	2	4	29	2029-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290430	2029	2	4	30	2029-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20290501	2029	2	5	1	2029-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20290502	2029	2	5	2	2029-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20290503	2029	2	5	3	2029-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20290504	2029	2	5	4	2029-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20290505	2029	2	5	5	2029-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20290506	2029	2	5	6	2029-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20290507	2029	2	5	7	2029-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20290508	2029	2	5	8	2029-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20290509	2029	2	5	9	2029-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20290510	2029	2	5	10	2029-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20290511	2029	2	5	11	2029-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20290512	2029	2	5	12	2029-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20290513	2029	2	5	13	2029-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20290514	2029	2	5	14	2029-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20290515	2029	2	5	15	2029-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20290516	2029	2	5	16	2029-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20290517	2029	2	5	17	2029-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20290518	2029	2	5	18	2029-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20290519	2029	2	5	19	2029-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20290520	2029	2	5	20	2029-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20290521	2029	2	5	21	2029-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20290522	2029	2	5	22	2029-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20290523	2029	2	5	23	2029-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20290524	2029	2	5	24	2029-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20290525	2029	2	5	25	2029-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20290526	2029	2	5	26	2029-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20290527	2029	2	5	27	2029-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20290528	2029	2	5	28	2029-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20290529	2029	2	5	29	2029-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20290530	2029	2	5	30	2029-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20290531	2029	2	5	31	2029-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20290601	2029	2	6	1	2029-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290602	2029	2	6	2	2029-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290603	2029	2	6	3	2029-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290604	2029	2	6	4	2029-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290605	2029	2	6	5	2029-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290606	2029	2	6	6	2029-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290607	2029	2	6	7	2029-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290608	2029	2	6	8	2029-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290609	2029	2	6	9	2029-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290610	2029	2	6	10	2029-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290611	2029	2	6	11	2029-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290612	2029	2	6	12	2029-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290613	2029	2	6	13	2029-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290614	2029	2	6	14	2029-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290615	2029	2	6	15	2029-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290616	2029	2	6	16	2029-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290617	2029	2	6	17	2029-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290618	2029	2	6	18	2029-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290619	2029	2	6	19	2029-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290620	2029	2	6	20	2029-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290621	2029	2	6	21	2029-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290622	2029	2	6	22	2029-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290623	2029	2	6	23	2029-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290624	2029	2	6	24	2029-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290625	2029	2	6	25	2029-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290626	2029	2	6	26	2029-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290627	2029	2	6	27	2029-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290628	2029	2	6	28	2029-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290629	2029	2	6	29	2029-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290630	2029	2	6	30	2029-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20290701	2029	3	7	1	2029-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20290702	2029	3	7	2	2029-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20290703	2029	3	7	3	2029-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20290704	2029	3	7	4	2029-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20290705	2029	3	7	5	2029-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20290706	2029	3	7	6	2029-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20290707	2029	3	7	7	2029-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20290708	2029	3	7	8	2029-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20290709	2029	3	7	9	2029-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20290710	2029	3	7	10	2029-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20290711	2029	3	7	11	2029-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20290712	2029	3	7	12	2029-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20290713	2029	3	7	13	2029-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20290714	2029	3	7	14	2029-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20290715	2029	3	7	15	2029-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20290716	2029	3	7	16	2029-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20290717	2029	3	7	17	2029-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20290718	2029	3	7	18	2029-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20290719	2029	3	7	19	2029-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20290720	2029	3	7	20	2029-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20290721	2029	3	7	21	2029-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20290722	2029	3	7	22	2029-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20290723	2029	3	7	23	2029-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20290724	2029	3	7	24	2029-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20290725	2029	3	7	25	2029-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20290726	2029	3	7	26	2029-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20290727	2029	3	7	27	2029-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20290728	2029	3	7	28	2029-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20290729	2029	3	7	29	2029-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20290730	2029	3	7	30	2029-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20290731	2029	3	7	31	2029-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20290801	2029	3	8	1	2029-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290802	2029	3	8	2	2029-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290803	2029	3	8	3	2029-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290804	2029	3	8	4	2029-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290805	2029	3	8	5	2029-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290806	2029	3	8	6	2029-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290807	2029	3	8	7	2029-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290808	2029	3	8	8	2029-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290809	2029	3	8	9	2029-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290810	2029	3	8	10	2029-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290811	2029	3	8	11	2029-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290812	2029	3	8	12	2029-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290813	2029	3	8	13	2029-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290814	2029	3	8	14	2029-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290815	2029	3	8	15	2029-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290816	2029	3	8	16	2029-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290817	2029	3	8	17	2029-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290818	2029	3	8	18	2029-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290819	2029	3	8	19	2029-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290820	2029	3	8	20	2029-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290821	2029	3	8	21	2029-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290822	2029	3	8	22	2029-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290823	2029	3	8	23	2029-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290824	2029	3	8	24	2029-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290825	2029	3	8	25	2029-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290826	2029	3	8	26	2029-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290827	2029	3	8	27	2029-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290828	2029	3	8	28	2029-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290829	2029	3	8	29	2029-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290830	2029	3	8	30	2029-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290831	2029	3	8	31	2029-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20290901	2029	3	9	1	2029-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290902	2029	3	9	2	2029-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290903	2029	3	9	3	2029-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290904	2029	3	9	4	2029-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290905	2029	3	9	5	2029-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290906	2029	3	9	6	2029-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290907	2029	3	9	7	2029-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290908	2029	3	9	8	2029-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290909	2029	3	9	9	2029-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290910	2029	3	9	10	2029-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290911	2029	3	9	11	2029-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290912	2029	3	9	12	2029-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290913	2029	3	9	13	2029-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290914	2029	3	9	14	2029-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290915	2029	3	9	15	2029-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290916	2029	3	9	16	2029-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290917	2029	3	9	17	2029-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290918	2029	3	9	18	2029-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290919	2029	3	9	19	2029-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290920	2029	3	9	20	2029-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290921	2029	3	9	21	2029-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290922	2029	3	9	22	2029-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290923	2029	3	9	23	2029-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290924	2029	3	9	24	2029-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290925	2029	3	9	25	2029-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290926	2029	3	9	26	2029-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290927	2029	3	9	27	2029-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290928	2029	3	9	28	2029-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290929	2029	3	9	29	2029-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20290930	2029	3	9	30	2029-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20291001	2029	4	10	1	2029-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291002	2029	4	10	2	2029-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291003	2029	4	10	3	2029-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291004	2029	4	10	4	2029-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291005	2029	4	10	5	2029-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291006	2029	4	10	6	2029-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291007	2029	4	10	7	2029-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291008	2029	4	10	8	2029-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291009	2029	4	10	9	2029-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291010	2029	4	10	10	2029-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291011	2029	4	10	11	2029-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291012	2029	4	10	12	2029-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291013	2029	4	10	13	2029-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291014	2029	4	10	14	2029-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291015	2029	4	10	15	2029-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291016	2029	4	10	16	2029-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291017	2029	4	10	17	2029-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291018	2029	4	10	18	2029-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291019	2029	4	10	19	2029-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291020	2029	4	10	20	2029-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291021	2029	4	10	21	2029-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291022	2029	4	10	22	2029-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291023	2029	4	10	23	2029-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291024	2029	4	10	24	2029-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291025	2029	4	10	25	2029-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291026	2029	4	10	26	2029-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291027	2029	4	10	27	2029-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291028	2029	4	10	28	2029-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291029	2029	4	10	29	2029-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291030	2029	4	10	30	2029-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291031	2029	4	10	31	2029-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20291101	2029	4	11	1	2029-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291102	2029	4	11	2	2029-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291103	2029	4	11	3	2029-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291104	2029	4	11	4	2029-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291105	2029	4	11	5	2029-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291106	2029	4	11	6	2029-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291107	2029	4	11	7	2029-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291108	2029	4	11	8	2029-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291109	2029	4	11	9	2029-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291110	2029	4	11	10	2029-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291111	2029	4	11	11	2029-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291112	2029	4	11	12	2029-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291113	2029	4	11	13	2029-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291114	2029	4	11	14	2029-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291115	2029	4	11	15	2029-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291116	2029	4	11	16	2029-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291117	2029	4	11	17	2029-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291118	2029	4	11	18	2029-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291119	2029	4	11	19	2029-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291120	2029	4	11	20	2029-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291121	2029	4	11	21	2029-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291122	2029	4	11	22	2029-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291123	2029	4	11	23	2029-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291124	2029	4	11	24	2029-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291125	2029	4	11	25	2029-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291126	2029	4	11	26	2029-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291127	2029	4	11	27	2029-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291128	2029	4	11	28	2029-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291129	2029	4	11	29	2029-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291130	2029	4	11	30	2029-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20291201	2029	4	12	1	2029-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291202	2029	4	12	2	2029-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291203	2029	4	12	3	2029-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291204	2029	4	12	4	2029-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291205	2029	4	12	5	2029-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291206	2029	4	12	6	2029-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291207	2029	4	12	7	2029-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291208	2029	4	12	8	2029-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291209	2029	4	12	9	2029-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291210	2029	4	12	10	2029-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291211	2029	4	12	11	2029-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291212	2029	4	12	12	2029-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291213	2029	4	12	13	2029-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291214	2029	4	12	14	2029-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291215	2029	4	12	15	2029-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291216	2029	4	12	16	2029-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291217	2029	4	12	17	2029-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291218	2029	4	12	18	2029-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291219	2029	4	12	19	2029-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291220	2029	4	12	20	2029-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291221	2029	4	12	21	2029-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291222	2029	4	12	22	2029-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291223	2029	4	12	23	2029-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291224	2029	4	12	24	2029-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291225	2029	4	12	25	2029-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291226	2029	4	12	26	2029-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291227	2029	4	12	27	2029-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291228	2029	4	12	28	2029-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291229	2029	4	12	29	2029-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291230	2029	4	12	30	2029-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20291231	2029	4	12	31	2029-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20300101	2030	1	1	1	2030-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20300102	2030	1	1	2	2030-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20300103	2030	1	1	3	2030-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20300104	2030	1	1	4	2030-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20300105	2030	1	1	5	2030-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20300106	2030	1	1	6	2030-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20300107	2030	1	1	7	2030-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20300108	2030	1	1	8	2030-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20300109	2030	1	1	9	2030-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20300110	2030	1	1	10	2030-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20300111	2030	1	1	11	2030-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20300112	2030	1	1	12	2030-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20300113	2030	1	1	13	2030-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20300114	2030	1	1	14	2030-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20300115	2030	1	1	15	2030-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20300116	2030	1	1	16	2030-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20300117	2030	1	1	17	2030-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20300118	2030	1	1	18	2030-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20300119	2030	1	1	19	2030-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20300120	2030	1	1	20	2030-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20300121	2030	1	1	21	2030-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20300122	2030	1	1	22	2030-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20300123	2030	1	1	23	2030-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20300124	2030	1	1	24	2030-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20300125	2030	1	1	25	2030-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20300126	2030	1	1	26	2030-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20300127	2030	1	1	27	2030-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20300128	2030	1	1	28	2030-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20300129	2030	1	1	29	2030-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20300130	2030	1	1	30	2030-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20300131	2030	1	1	31	2030-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20300201	2030	1	2	1	2030-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300202	2030	1	2	2	2030-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300203	2030	1	2	3	2030-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300204	2030	1	2	4	2030-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300205	2030	1	2	5	2030-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300206	2030	1	2	6	2030-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300207	2030	1	2	7	2030-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300208	2030	1	2	8	2030-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300209	2030	1	2	9	2030-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300210	2030	1	2	10	2030-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300211	2030	1	2	11	2030-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300212	2030	1	2	12	2030-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300213	2030	1	2	13	2030-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300214	2030	1	2	14	2030-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300215	2030	1	2	15	2030-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300216	2030	1	2	16	2030-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300217	2030	1	2	17	2030-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300218	2030	1	2	18	2030-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300219	2030	1	2	19	2030-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300220	2030	1	2	20	2030-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300221	2030	1	2	21	2030-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300222	2030	1	2	22	2030-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300223	2030	1	2	23	2030-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300224	2030	1	2	24	2030-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300225	2030	1	2	25	2030-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300226	2030	1	2	26	2030-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300227	2030	1	2	27	2030-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300228	2030	1	2	28	2030-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20300301	2030	1	3	1	2030-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20300302	2030	1	3	2	2030-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20300303	2030	1	3	3	2030-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20300304	2030	1	3	4	2030-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20300305	2030	1	3	5	2030-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20300306	2030	1	3	6	2030-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20300307	2030	1	3	7	2030-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20300308	2030	1	3	8	2030-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20300309	2030	1	3	9	2030-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20300310	2030	1	3	10	2030-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20300311	2030	1	3	11	2030-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20300312	2030	1	3	12	2030-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20300313	2030	1	3	13	2030-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20300314	2030	1	3	14	2030-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20300315	2030	1	3	15	2030-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20300316	2030	1	3	16	2030-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20300317	2030	1	3	17	2030-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20300318	2030	1	3	18	2030-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20300319	2030	1	3	19	2030-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20300320	2030	1	3	20	2030-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20300321	2030	1	3	21	2030-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20300322	2030	1	3	22	2030-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20300323	2030	1	3	23	2030-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20300324	2030	1	3	24	2030-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20300325	2030	1	3	25	2030-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20300326	2030	1	3	26	2030-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20300327	2030	1	3	27	2030-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20300328	2030	1	3	28	2030-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20300329	2030	1	3	29	2030-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20300330	2030	1	3	30	2030-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20300331	2030	1	3	31	2030-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20300401	2030	2	4	1	2030-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300402	2030	2	4	2	2030-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300403	2030	2	4	3	2030-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300404	2030	2	4	4	2030-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300405	2030	2	4	5	2030-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300406	2030	2	4	6	2030-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300407	2030	2	4	7	2030-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300408	2030	2	4	8	2030-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300409	2030	2	4	9	2030-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300410	2030	2	4	10	2030-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300411	2030	2	4	11	2030-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300412	2030	2	4	12	2030-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300413	2030	2	4	13	2030-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300414	2030	2	4	14	2030-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300415	2030	2	4	15	2030-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300416	2030	2	4	16	2030-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300417	2030	2	4	17	2030-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300418	2030	2	4	18	2030-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300419	2030	2	4	19	2030-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300420	2030	2	4	20	2030-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300421	2030	2	4	21	2030-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300422	2030	2	4	22	2030-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300423	2030	2	4	23	2030-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300424	2030	2	4	24	2030-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300425	2030	2	4	25	2030-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300426	2030	2	4	26	2030-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300427	2030	2	4	27	2030-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300428	2030	2	4	28	2030-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300429	2030	2	4	29	2030-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300430	2030	2	4	30	2030-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20300501	2030	2	5	1	2030-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20300502	2030	2	5	2	2030-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20300503	2030	2	5	3	2030-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20300504	2030	2	5	4	2030-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20300505	2030	2	5	5	2030-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20300506	2030	2	5	6	2030-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20300507	2030	2	5	7	2030-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20300508	2030	2	5	8	2030-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20300509	2030	2	5	9	2030-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20300510	2030	2	5	10	2030-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20300511	2030	2	5	11	2030-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20300512	2030	2	5	12	2030-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20300513	2030	2	5	13	2030-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20300514	2030	2	5	14	2030-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20300515	2030	2	5	15	2030-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20300516	2030	2	5	16	2030-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20300517	2030	2	5	17	2030-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20300518	2030	2	5	18	2030-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20300519	2030	2	5	19	2030-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20300520	2030	2	5	20	2030-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20300521	2030	2	5	21	2030-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20300522	2030	2	5	22	2030-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20300523	2030	2	5	23	2030-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20300524	2030	2	5	24	2030-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20300525	2030	2	5	25	2030-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20300526	2030	2	5	26	2030-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20300527	2030	2	5	27	2030-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20300528	2030	2	5	28	2030-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20300529	2030	2	5	29	2030-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20300530	2030	2	5	30	2030-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20300531	2030	2	5	31	2030-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20300601	2030	2	6	1	2030-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300602	2030	2	6	2	2030-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300603	2030	2	6	3	2030-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300604	2030	2	6	4	2030-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300605	2030	2	6	5	2030-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300606	2030	2	6	6	2030-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300607	2030	2	6	7	2030-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300608	2030	2	6	8	2030-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300609	2030	2	6	9	2030-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300610	2030	2	6	10	2030-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300611	2030	2	6	11	2030-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300612	2030	2	6	12	2030-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300613	2030	2	6	13	2030-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300614	2030	2	6	14	2030-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300615	2030	2	6	15	2030-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300616	2030	2	6	16	2030-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300617	2030	2	6	17	2030-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300618	2030	2	6	18	2030-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300619	2030	2	6	19	2030-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300620	2030	2	6	20	2030-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300621	2030	2	6	21	2030-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300622	2030	2	6	22	2030-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300623	2030	2	6	23	2030-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300624	2030	2	6	24	2030-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300625	2030	2	6	25	2030-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300626	2030	2	6	26	2030-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300627	2030	2	6	27	2030-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300628	2030	2	6	28	2030-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300629	2030	2	6	29	2030-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300630	2030	2	6	30	2030-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20300701	2030	3	7	1	2030-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20300702	2030	3	7	2	2030-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20300703	2030	3	7	3	2030-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20300704	2030	3	7	4	2030-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20300705	2030	3	7	5	2030-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20300706	2030	3	7	6	2030-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20300707	2030	3	7	7	2030-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20300708	2030	3	7	8	2030-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20300709	2030	3	7	9	2030-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20300710	2030	3	7	10	2030-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20300711	2030	3	7	11	2030-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20300712	2030	3	7	12	2030-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20300713	2030	3	7	13	2030-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20300714	2030	3	7	14	2030-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20300715	2030	3	7	15	2030-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20300716	2030	3	7	16	2030-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20300717	2030	3	7	17	2030-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20300718	2030	3	7	18	2030-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20300719	2030	3	7	19	2030-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20300720	2030	3	7	20	2030-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20300721	2030	3	7	21	2030-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20300722	2030	3	7	22	2030-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20300723	2030	3	7	23	2030-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20300724	2030	3	7	24	2030-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20300725	2030	3	7	25	2030-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20300726	2030	3	7	26	2030-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20300727	2030	3	7	27	2030-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20300728	2030	3	7	28	2030-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20300729	2030	3	7	29	2030-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20300730	2030	3	7	30	2030-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20300731	2030	3	7	31	2030-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20300801	2030	3	8	1	2030-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300802	2030	3	8	2	2030-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300803	2030	3	8	3	2030-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300804	2030	3	8	4	2030-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300805	2030	3	8	5	2030-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300806	2030	3	8	6	2030-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300807	2030	3	8	7	2030-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300808	2030	3	8	8	2030-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300809	2030	3	8	9	2030-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300810	2030	3	8	10	2030-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300811	2030	3	8	11	2030-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300812	2030	3	8	12	2030-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300813	2030	3	8	13	2030-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300814	2030	3	8	14	2030-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300815	2030	3	8	15	2030-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300816	2030	3	8	16	2030-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300817	2030	3	8	17	2030-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300818	2030	3	8	18	2030-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300819	2030	3	8	19	2030-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300820	2030	3	8	20	2030-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300821	2030	3	8	21	2030-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300822	2030	3	8	22	2030-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300823	2030	3	8	23	2030-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300824	2030	3	8	24	2030-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300825	2030	3	8	25	2030-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300826	2030	3	8	26	2030-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300827	2030	3	8	27	2030-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300828	2030	3	8	28	2030-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300829	2030	3	8	29	2030-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300830	2030	3	8	30	2030-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300831	2030	3	8	31	2030-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20300901	2030	3	9	1	2030-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300902	2030	3	9	2	2030-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300903	2030	3	9	3	2030-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300904	2030	3	9	4	2030-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300905	2030	3	9	5	2030-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300906	2030	3	9	6	2030-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300907	2030	3	9	7	2030-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300908	2030	3	9	8	2030-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300909	2030	3	9	9	2030-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300910	2030	3	9	10	2030-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300911	2030	3	9	11	2030-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300912	2030	3	9	12	2030-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300913	2030	3	9	13	2030-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300914	2030	3	9	14	2030-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300915	2030	3	9	15	2030-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300916	2030	3	9	16	2030-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300917	2030	3	9	17	2030-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300918	2030	3	9	18	2030-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300919	2030	3	9	19	2030-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300920	2030	3	9	20	2030-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300921	2030	3	9	21	2030-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300922	2030	3	9	22	2030-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300923	2030	3	9	23	2030-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300924	2030	3	9	24	2030-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300925	2030	3	9	25	2030-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300926	2030	3	9	26	2030-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300927	2030	3	9	27	2030-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300928	2030	3	9	28	2030-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300929	2030	3	9	29	2030-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20300930	2030	3	9	30	2030-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20301001	2030	4	10	1	2030-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301002	2030	4	10	2	2030-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301003	2030	4	10	3	2030-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301004	2030	4	10	4	2030-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301005	2030	4	10	5	2030-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301006	2030	4	10	6	2030-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301007	2030	4	10	7	2030-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301008	2030	4	10	8	2030-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301009	2030	4	10	9	2030-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301010	2030	4	10	10	2030-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301011	2030	4	10	11	2030-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301012	2030	4	10	12	2030-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301013	2030	4	10	13	2030-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301014	2030	4	10	14	2030-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301015	2030	4	10	15	2030-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301016	2030	4	10	16	2030-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301017	2030	4	10	17	2030-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301018	2030	4	10	18	2030-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301019	2030	4	10	19	2030-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301020	2030	4	10	20	2030-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301021	2030	4	10	21	2030-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301022	2030	4	10	22	2030-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301023	2030	4	10	23	2030-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301024	2030	4	10	24	2030-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301025	2030	4	10	25	2030-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301026	2030	4	10	26	2030-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301027	2030	4	10	27	2030-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301028	2030	4	10	28	2030-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301029	2030	4	10	29	2030-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301030	2030	4	10	30	2030-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301031	2030	4	10	31	2030-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20301101	2030	4	11	1	2030-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301102	2030	4	11	2	2030-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301103	2030	4	11	3	2030-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301104	2030	4	11	4	2030-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301105	2030	4	11	5	2030-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301106	2030	4	11	6	2030-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301107	2030	4	11	7	2030-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301108	2030	4	11	8	2030-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301109	2030	4	11	9	2030-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301110	2030	4	11	10	2030-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301111	2030	4	11	11	2030-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301112	2030	4	11	12	2030-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301113	2030	4	11	13	2030-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301114	2030	4	11	14	2030-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301115	2030	4	11	15	2030-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301116	2030	4	11	16	2030-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301117	2030	4	11	17	2030-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301118	2030	4	11	18	2030-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301119	2030	4	11	19	2030-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301120	2030	4	11	20	2030-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301121	2030	4	11	21	2030-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301122	2030	4	11	22	2030-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301123	2030	4	11	23	2030-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301124	2030	4	11	24	2030-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301125	2030	4	11	25	2030-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301126	2030	4	11	26	2030-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301127	2030	4	11	27	2030-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301128	2030	4	11	28	2030-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301129	2030	4	11	29	2030-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301130	2030	4	11	30	2030-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20301201	2030	4	12	1	2030-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301202	2030	4	12	2	2030-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301203	2030	4	12	3	2030-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301204	2030	4	12	4	2030-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301205	2030	4	12	5	2030-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301206	2030	4	12	6	2030-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301207	2030	4	12	7	2030-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301208	2030	4	12	8	2030-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301209	2030	4	12	9	2030-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301210	2030	4	12	10	2030-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301211	2030	4	12	11	2030-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301212	2030	4	12	12	2030-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301213	2030	4	12	13	2030-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301214	2030	4	12	14	2030-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301215	2030	4	12	15	2030-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301216	2030	4	12	16	2030-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301217	2030	4	12	17	2030-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301218	2030	4	12	18	2030-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301219	2030	4	12	19	2030-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301220	2030	4	12	20	2030-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301221	2030	4	12	21	2030-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301222	2030	4	12	22	2030-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301223	2030	4	12	23	2030-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301224	2030	4	12	24	2030-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301225	2030	4	12	25	2030-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301226	2030	4	12	26	2030-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301227	2030	4	12	27	2030-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301228	2030	4	12	28	2030-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301229	2030	4	12	29	2030-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301230	2030	4	12	30	2030-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20301231	2030	4	12	31	2030-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20310101	2031	1	1	1	2031-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20310102	2031	1	1	2	2031-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20310103	2031	1	1	3	2031-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20310104	2031	1	1	4	2031-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20310105	2031	1	1	5	2031-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20310106	2031	1	1	6	2031-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20310107	2031	1	1	7	2031-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20310108	2031	1	1	8	2031-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20310109	2031	1	1	9	2031-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20310110	2031	1	1	10	2031-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20310111	2031	1	1	11	2031-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20310112	2031	1	1	12	2031-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20310113	2031	1	1	13	2031-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20310114	2031	1	1	14	2031-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20310115	2031	1	1	15	2031-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20310116	2031	1	1	16	2031-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20310117	2031	1	1	17	2031-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20310118	2031	1	1	18	2031-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20310119	2031	1	1	19	2031-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20310120	2031	1	1	20	2031-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20310121	2031	1	1	21	2031-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20310122	2031	1	1	22	2031-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20310123	2031	1	1	23	2031-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20310124	2031	1	1	24	2031-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20310125	2031	1	1	25	2031-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20310126	2031	1	1	26	2031-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20310127	2031	1	1	27	2031-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20310128	2031	1	1	28	2031-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20310129	2031	1	1	29	2031-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20310130	2031	1	1	30	2031-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20310131	2031	1	1	31	2031-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20310201	2031	1	2	1	2031-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310202	2031	1	2	2	2031-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310203	2031	1	2	3	2031-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310204	2031	1	2	4	2031-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310205	2031	1	2	5	2031-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310206	2031	1	2	6	2031-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310207	2031	1	2	7	2031-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310208	2031	1	2	8	2031-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310209	2031	1	2	9	2031-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310210	2031	1	2	10	2031-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310211	2031	1	2	11	2031-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310212	2031	1	2	12	2031-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310213	2031	1	2	13	2031-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310214	2031	1	2	14	2031-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310215	2031	1	2	15	2031-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310216	2031	1	2	16	2031-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310217	2031	1	2	17	2031-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310218	2031	1	2	18	2031-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310219	2031	1	2	19	2031-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310220	2031	1	2	20	2031-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310221	2031	1	2	21	2031-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310222	2031	1	2	22	2031-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310223	2031	1	2	23	2031-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310224	2031	1	2	24	2031-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310225	2031	1	2	25	2031-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310226	2031	1	2	26	2031-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310227	2031	1	2	27	2031-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310228	2031	1	2	28	2031-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20310301	2031	1	3	1	2031-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20310302	2031	1	3	2	2031-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20310303	2031	1	3	3	2031-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20310304	2031	1	3	4	2031-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20310305	2031	1	3	5	2031-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20310306	2031	1	3	6	2031-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20310307	2031	1	3	7	2031-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20310308	2031	1	3	8	2031-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20310309	2031	1	3	9	2031-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20310310	2031	1	3	10	2031-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20310311	2031	1	3	11	2031-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20310312	2031	1	3	12	2031-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20310313	2031	1	3	13	2031-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20310314	2031	1	3	14	2031-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20310315	2031	1	3	15	2031-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20310316	2031	1	3	16	2031-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20310317	2031	1	3	17	2031-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20310318	2031	1	3	18	2031-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20310319	2031	1	3	19	2031-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20310320	2031	1	3	20	2031-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20310321	2031	1	3	21	2031-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20310322	2031	1	3	22	2031-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20310323	2031	1	3	23	2031-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20310324	2031	1	3	24	2031-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20310325	2031	1	3	25	2031-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20310326	2031	1	3	26	2031-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20310327	2031	1	3	27	2031-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20310328	2031	1	3	28	2031-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20310329	2031	1	3	29	2031-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20310330	2031	1	3	30	2031-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20310331	2031	1	3	31	2031-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20310401	2031	2	4	1	2031-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310402	2031	2	4	2	2031-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310403	2031	2	4	3	2031-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310404	2031	2	4	4	2031-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310405	2031	2	4	5	2031-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310406	2031	2	4	6	2031-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310407	2031	2	4	7	2031-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310408	2031	2	4	8	2031-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310409	2031	2	4	9	2031-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310410	2031	2	4	10	2031-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310411	2031	2	4	11	2031-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310412	2031	2	4	12	2031-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310413	2031	2	4	13	2031-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310414	2031	2	4	14	2031-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310415	2031	2	4	15	2031-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310416	2031	2	4	16	2031-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310417	2031	2	4	17	2031-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310418	2031	2	4	18	2031-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310419	2031	2	4	19	2031-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310420	2031	2	4	20	2031-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310421	2031	2	4	21	2031-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310422	2031	2	4	22	2031-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310423	2031	2	4	23	2031-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310424	2031	2	4	24	2031-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310425	2031	2	4	25	2031-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310426	2031	2	4	26	2031-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310427	2031	2	4	27	2031-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310428	2031	2	4	28	2031-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310429	2031	2	4	29	2031-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310430	2031	2	4	30	2031-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20310501	2031	2	5	1	2031-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20310502	2031	2	5	2	2031-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20310503	2031	2	5	3	2031-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20310504	2031	2	5	4	2031-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20310505	2031	2	5	5	2031-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20310506	2031	2	5	6	2031-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20310507	2031	2	5	7	2031-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20310508	2031	2	5	8	2031-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20310509	2031	2	5	9	2031-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20310510	2031	2	5	10	2031-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20310511	2031	2	5	11	2031-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20310512	2031	2	5	12	2031-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20310513	2031	2	5	13	2031-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20310514	2031	2	5	14	2031-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20310515	2031	2	5	15	2031-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20310516	2031	2	5	16	2031-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20310517	2031	2	5	17	2031-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20310518	2031	2	5	18	2031-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20310519	2031	2	5	19	2031-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20310520	2031	2	5	20	2031-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20310521	2031	2	5	21	2031-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20310522	2031	2	5	22	2031-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20310523	2031	2	5	23	2031-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20310524	2031	2	5	24	2031-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20310525	2031	2	5	25	2031-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20310526	2031	2	5	26	2031-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20310527	2031	2	5	27	2031-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20310528	2031	2	5	28	2031-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20310529	2031	2	5	29	2031-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20310530	2031	2	5	30	2031-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20310531	2031	2	5	31	2031-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20310601	2031	2	6	1	2031-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310602	2031	2	6	2	2031-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310603	2031	2	6	3	2031-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310604	2031	2	6	4	2031-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310605	2031	2	6	5	2031-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310606	2031	2	6	6	2031-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310607	2031	2	6	7	2031-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310608	2031	2	6	8	2031-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310609	2031	2	6	9	2031-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310610	2031	2	6	10	2031-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310611	2031	2	6	11	2031-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310612	2031	2	6	12	2031-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310613	2031	2	6	13	2031-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310614	2031	2	6	14	2031-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310615	2031	2	6	15	2031-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310616	2031	2	6	16	2031-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310617	2031	2	6	17	2031-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310618	2031	2	6	18	2031-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310619	2031	2	6	19	2031-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310620	2031	2	6	20	2031-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310621	2031	2	6	21	2031-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310622	2031	2	6	22	2031-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310623	2031	2	6	23	2031-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310624	2031	2	6	24	2031-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310625	2031	2	6	25	2031-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310626	2031	2	6	26	2031-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310627	2031	2	6	27	2031-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310628	2031	2	6	28	2031-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310629	2031	2	6	29	2031-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310630	2031	2	6	30	2031-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20310701	2031	3	7	1	2031-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20310702	2031	3	7	2	2031-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20310703	2031	3	7	3	2031-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20310704	2031	3	7	4	2031-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20310705	2031	3	7	5	2031-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20310706	2031	3	7	6	2031-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20310707	2031	3	7	7	2031-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20310708	2031	3	7	8	2031-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20310709	2031	3	7	9	2031-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20310710	2031	3	7	10	2031-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20310711	2031	3	7	11	2031-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20310712	2031	3	7	12	2031-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20310713	2031	3	7	13	2031-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20310714	2031	3	7	14	2031-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20310715	2031	3	7	15	2031-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20310716	2031	3	7	16	2031-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20310717	2031	3	7	17	2031-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20310718	2031	3	7	18	2031-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20310719	2031	3	7	19	2031-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20310720	2031	3	7	20	2031-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20310721	2031	3	7	21	2031-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20310722	2031	3	7	22	2031-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20310723	2031	3	7	23	2031-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20310724	2031	3	7	24	2031-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20310725	2031	3	7	25	2031-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20310726	2031	3	7	26	2031-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20310727	2031	3	7	27	2031-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20310728	2031	3	7	28	2031-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20310729	2031	3	7	29	2031-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20310730	2031	3	7	30	2031-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20310731	2031	3	7	31	2031-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20310801	2031	3	8	1	2031-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310802	2031	3	8	2	2031-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310803	2031	3	8	3	2031-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310804	2031	3	8	4	2031-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310805	2031	3	8	5	2031-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310806	2031	3	8	6	2031-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310807	2031	3	8	7	2031-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310808	2031	3	8	8	2031-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310809	2031	3	8	9	2031-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310810	2031	3	8	10	2031-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310811	2031	3	8	11	2031-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310812	2031	3	8	12	2031-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310813	2031	3	8	13	2031-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310814	2031	3	8	14	2031-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310815	2031	3	8	15	2031-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310816	2031	3	8	16	2031-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310817	2031	3	8	17	2031-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310818	2031	3	8	18	2031-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310819	2031	3	8	19	2031-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310820	2031	3	8	20	2031-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310821	2031	3	8	21	2031-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310822	2031	3	8	22	2031-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310823	2031	3	8	23	2031-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310824	2031	3	8	24	2031-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310825	2031	3	8	25	2031-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310826	2031	3	8	26	2031-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310827	2031	3	8	27	2031-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310828	2031	3	8	28	2031-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310829	2031	3	8	29	2031-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310830	2031	3	8	30	2031-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310831	2031	3	8	31	2031-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20310901	2031	3	9	1	2031-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310902	2031	3	9	2	2031-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310903	2031	3	9	3	2031-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310904	2031	3	9	4	2031-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310905	2031	3	9	5	2031-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310906	2031	3	9	6	2031-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310907	2031	3	9	7	2031-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310908	2031	3	9	8	2031-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310909	2031	3	9	9	2031-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310910	2031	3	9	10	2031-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310911	2031	3	9	11	2031-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310912	2031	3	9	12	2031-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310913	2031	3	9	13	2031-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310914	2031	3	9	14	2031-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310915	2031	3	9	15	2031-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310916	2031	3	9	16	2031-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310917	2031	3	9	17	2031-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310918	2031	3	9	18	2031-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310919	2031	3	9	19	2031-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310920	2031	3	9	20	2031-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310921	2031	3	9	21	2031-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310922	2031	3	9	22	2031-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310923	2031	3	9	23	2031-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310924	2031	3	9	24	2031-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310925	2031	3	9	25	2031-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310926	2031	3	9	26	2031-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310927	2031	3	9	27	2031-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310928	2031	3	9	28	2031-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310929	2031	3	9	29	2031-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20310930	2031	3	9	30	2031-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20311001	2031	4	10	1	2031-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311002	2031	4	10	2	2031-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311003	2031	4	10	3	2031-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311004	2031	4	10	4	2031-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311005	2031	4	10	5	2031-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311006	2031	4	10	6	2031-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311007	2031	4	10	7	2031-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311008	2031	4	10	8	2031-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311009	2031	4	10	9	2031-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311010	2031	4	10	10	2031-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311011	2031	4	10	11	2031-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311012	2031	4	10	12	2031-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311013	2031	4	10	13	2031-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311014	2031	4	10	14	2031-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311015	2031	4	10	15	2031-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311016	2031	4	10	16	2031-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311017	2031	4	10	17	2031-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311018	2031	4	10	18	2031-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311019	2031	4	10	19	2031-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311020	2031	4	10	20	2031-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311021	2031	4	10	21	2031-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311022	2031	4	10	22	2031-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311023	2031	4	10	23	2031-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311024	2031	4	10	24	2031-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311025	2031	4	10	25	2031-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311026	2031	4	10	26	2031-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311027	2031	4	10	27	2031-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311028	2031	4	10	28	2031-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311029	2031	4	10	29	2031-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311030	2031	4	10	30	2031-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311031	2031	4	10	31	2031-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20311101	2031	4	11	1	2031-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311102	2031	4	11	2	2031-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311103	2031	4	11	3	2031-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311104	2031	4	11	4	2031-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311105	2031	4	11	5	2031-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311106	2031	4	11	6	2031-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311107	2031	4	11	7	2031-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311108	2031	4	11	8	2031-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311109	2031	4	11	9	2031-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311110	2031	4	11	10	2031-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311111	2031	4	11	11	2031-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311112	2031	4	11	12	2031-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311113	2031	4	11	13	2031-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311114	2031	4	11	14	2031-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311115	2031	4	11	15	2031-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311116	2031	4	11	16	2031-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311117	2031	4	11	17	2031-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311118	2031	4	11	18	2031-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311119	2031	4	11	19	2031-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311120	2031	4	11	20	2031-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311121	2031	4	11	21	2031-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311122	2031	4	11	22	2031-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311123	2031	4	11	23	2031-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311124	2031	4	11	24	2031-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311125	2031	4	11	25	2031-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311126	2031	4	11	26	2031-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311127	2031	4	11	27	2031-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311128	2031	4	11	28	2031-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311129	2031	4	11	29	2031-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311130	2031	4	11	30	2031-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20311201	2031	4	12	1	2031-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311202	2031	4	12	2	2031-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311203	2031	4	12	3	2031-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311204	2031	4	12	4	2031-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311205	2031	4	12	5	2031-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311206	2031	4	12	6	2031-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311207	2031	4	12	7	2031-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311208	2031	4	12	8	2031-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311209	2031	4	12	9	2031-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311210	2031	4	12	10	2031-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311211	2031	4	12	11	2031-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311212	2031	4	12	12	2031-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311213	2031	4	12	13	2031-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311214	2031	4	12	14	2031-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311215	2031	4	12	15	2031-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311216	2031	4	12	16	2031-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311217	2031	4	12	17	2031-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311218	2031	4	12	18	2031-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311219	2031	4	12	19	2031-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311220	2031	4	12	20	2031-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311221	2031	4	12	21	2031-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311222	2031	4	12	22	2031-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311223	2031	4	12	23	2031-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311224	2031	4	12	24	2031-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311225	2031	4	12	25	2031-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311226	2031	4	12	26	2031-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311227	2031	4	12	27	2031-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311228	2031	4	12	28	2031-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311229	2031	4	12	29	2031-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311230	2031	4	12	30	2031-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20311231	2031	4	12	31	2031-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20320101	2032	1	1	1	2032-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20320102	2032	1	1	2	2032-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20320103	2032	1	1	3	2032-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20320104	2032	1	1	4	2032-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20320105	2032	1	1	5	2032-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20320106	2032	1	1	6	2032-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20320107	2032	1	1	7	2032-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20320108	2032	1	1	8	2032-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20320109	2032	1	1	9	2032-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20320110	2032	1	1	10	2032-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20320111	2032	1	1	11	2032-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20320112	2032	1	1	12	2032-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20320113	2032	1	1	13	2032-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20320114	2032	1	1	14	2032-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20320115	2032	1	1	15	2032-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20320116	2032	1	1	16	2032-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20320117	2032	1	1	17	2032-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20320118	2032	1	1	18	2032-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20320119	2032	1	1	19	2032-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20320120	2032	1	1	20	2032-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20320121	2032	1	1	21	2032-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20320122	2032	1	1	22	2032-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20320123	2032	1	1	23	2032-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20320124	2032	1	1	24	2032-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20320125	2032	1	1	25	2032-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20320126	2032	1	1	26	2032-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20320127	2032	1	1	27	2032-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20320128	2032	1	1	28	2032-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20320129	2032	1	1	29	2032-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20320130	2032	1	1	30	2032-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20320131	2032	1	1	31	2032-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20320201	2032	1	2	1	2032-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320202	2032	1	2	2	2032-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320203	2032	1	2	3	2032-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320204	2032	1	2	4	2032-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320205	2032	1	2	5	2032-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320206	2032	1	2	6	2032-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320207	2032	1	2	7	2032-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320208	2032	1	2	8	2032-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320209	2032	1	2	9	2032-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320210	2032	1	2	10	2032-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320211	2032	1	2	11	2032-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320212	2032	1	2	12	2032-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320213	2032	1	2	13	2032-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320214	2032	1	2	14	2032-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320215	2032	1	2	15	2032-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320216	2032	1	2	16	2032-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320217	2032	1	2	17	2032-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320218	2032	1	2	18	2032-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320219	2032	1	2	19	2032-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320220	2032	1	2	20	2032-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320221	2032	1	2	21	2032-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320222	2032	1	2	22	2032-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320223	2032	1	2	23	2032-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320224	2032	1	2	24	2032-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320225	2032	1	2	25	2032-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320226	2032	1	2	26	2032-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320227	2032	1	2	27	2032-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320228	2032	1	2	28	2032-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320229	2032	1	2	29	2032-02-29 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20320301	2032	1	3	1	2032-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20320302	2032	1	3	2	2032-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20320303	2032	1	3	3	2032-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20320304	2032	1	3	4	2032-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20320305	2032	1	3	5	2032-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20320306	2032	1	3	6	2032-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20320307	2032	1	3	7	2032-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20320308	2032	1	3	8	2032-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20320309	2032	1	3	9	2032-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20320310	2032	1	3	10	2032-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20320311	2032	1	3	11	2032-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20320312	2032	1	3	12	2032-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20320313	2032	1	3	13	2032-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20320314	2032	1	3	14	2032-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20320315	2032	1	3	15	2032-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20320316	2032	1	3	16	2032-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20320317	2032	1	3	17	2032-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20320318	2032	1	3	18	2032-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20320319	2032	1	3	19	2032-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20320320	2032	1	3	20	2032-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20320321	2032	1	3	21	2032-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20320322	2032	1	3	22	2032-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20320323	2032	1	3	23	2032-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20320324	2032	1	3	24	2032-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20320325	2032	1	3	25	2032-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20320326	2032	1	3	26	2032-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20320327	2032	1	3	27	2032-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20320328	2032	1	3	28	2032-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20320329	2032	1	3	29	2032-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20320330	2032	1	3	30	2032-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20320331	2032	1	3	31	2032-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20320401	2032	2	4	1	2032-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320402	2032	2	4	2	2032-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320403	2032	2	4	3	2032-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320404	2032	2	4	4	2032-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320405	2032	2	4	5	2032-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320406	2032	2	4	6	2032-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320407	2032	2	4	7	2032-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320408	2032	2	4	8	2032-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320409	2032	2	4	9	2032-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320410	2032	2	4	10	2032-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320411	2032	2	4	11	2032-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320412	2032	2	4	12	2032-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320413	2032	2	4	13	2032-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320414	2032	2	4	14	2032-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320415	2032	2	4	15	2032-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320416	2032	2	4	16	2032-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320417	2032	2	4	17	2032-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320418	2032	2	4	18	2032-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320419	2032	2	4	19	2032-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320420	2032	2	4	20	2032-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320421	2032	2	4	21	2032-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320422	2032	2	4	22	2032-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320423	2032	2	4	23	2032-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320424	2032	2	4	24	2032-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320425	2032	2	4	25	2032-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320426	2032	2	4	26	2032-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320427	2032	2	4	27	2032-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320428	2032	2	4	28	2032-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320429	2032	2	4	29	2032-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320430	2032	2	4	30	2032-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20320501	2032	2	5	1	2032-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20320502	2032	2	5	2	2032-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20320503	2032	2	5	3	2032-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20320504	2032	2	5	4	2032-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20320505	2032	2	5	5	2032-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20320506	2032	2	5	6	2032-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20320507	2032	2	5	7	2032-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20320508	2032	2	5	8	2032-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20320509	2032	2	5	9	2032-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20320510	2032	2	5	10	2032-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20320511	2032	2	5	11	2032-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20320512	2032	2	5	12	2032-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20320513	2032	2	5	13	2032-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20320514	2032	2	5	14	2032-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20320515	2032	2	5	15	2032-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20320516	2032	2	5	16	2032-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20320517	2032	2	5	17	2032-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20320518	2032	2	5	18	2032-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20320519	2032	2	5	19	2032-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20320520	2032	2	5	20	2032-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20320521	2032	2	5	21	2032-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20320522	2032	2	5	22	2032-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20320523	2032	2	5	23	2032-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20320524	2032	2	5	24	2032-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20320525	2032	2	5	25	2032-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20320526	2032	2	5	26	2032-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20320527	2032	2	5	27	2032-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20320528	2032	2	5	28	2032-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20320529	2032	2	5	29	2032-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20320530	2032	2	5	30	2032-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20320531	2032	2	5	31	2032-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20320601	2032	2	6	1	2032-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320602	2032	2	6	2	2032-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320603	2032	2	6	3	2032-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320604	2032	2	6	4	2032-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320605	2032	2	6	5	2032-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320606	2032	2	6	6	2032-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320607	2032	2	6	7	2032-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320608	2032	2	6	8	2032-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320609	2032	2	6	9	2032-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320610	2032	2	6	10	2032-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320611	2032	2	6	11	2032-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320612	2032	2	6	12	2032-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320613	2032	2	6	13	2032-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320614	2032	2	6	14	2032-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320615	2032	2	6	15	2032-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320616	2032	2	6	16	2032-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320617	2032	2	6	17	2032-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320618	2032	2	6	18	2032-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320619	2032	2	6	19	2032-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320620	2032	2	6	20	2032-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320621	2032	2	6	21	2032-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320622	2032	2	6	22	2032-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320623	2032	2	6	23	2032-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320624	2032	2	6	24	2032-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320625	2032	2	6	25	2032-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320626	2032	2	6	26	2032-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320627	2032	2	6	27	2032-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320628	2032	2	6	28	2032-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320629	2032	2	6	29	2032-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320630	2032	2	6	30	2032-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20320701	2032	3	7	1	2032-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20320702	2032	3	7	2	2032-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20320703	2032	3	7	3	2032-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20320704	2032	3	7	4	2032-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20320705	2032	3	7	5	2032-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20320706	2032	3	7	6	2032-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20320707	2032	3	7	7	2032-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20320708	2032	3	7	8	2032-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20320709	2032	3	7	9	2032-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20320710	2032	3	7	10	2032-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20320711	2032	3	7	11	2032-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20320712	2032	3	7	12	2032-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20320713	2032	3	7	13	2032-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20320714	2032	3	7	14	2032-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20320715	2032	3	7	15	2032-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20320716	2032	3	7	16	2032-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20320717	2032	3	7	17	2032-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20320718	2032	3	7	18	2032-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20320719	2032	3	7	19	2032-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20320720	2032	3	7	20	2032-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20320721	2032	3	7	21	2032-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20320722	2032	3	7	22	2032-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20320723	2032	3	7	23	2032-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20320724	2032	3	7	24	2032-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20320725	2032	3	7	25	2032-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20320726	2032	3	7	26	2032-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20320727	2032	3	7	27	2032-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20320728	2032	3	7	28	2032-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20320729	2032	3	7	29	2032-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20320730	2032	3	7	30	2032-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20320731	2032	3	7	31	2032-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20320801	2032	3	8	1	2032-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320802	2032	3	8	2	2032-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320803	2032	3	8	3	2032-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320804	2032	3	8	4	2032-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320805	2032	3	8	5	2032-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320806	2032	3	8	6	2032-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320807	2032	3	8	7	2032-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320808	2032	3	8	8	2032-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320809	2032	3	8	9	2032-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320810	2032	3	8	10	2032-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320811	2032	3	8	11	2032-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320812	2032	3	8	12	2032-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320813	2032	3	8	13	2032-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320814	2032	3	8	14	2032-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320815	2032	3	8	15	2032-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320816	2032	3	8	16	2032-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320817	2032	3	8	17	2032-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320818	2032	3	8	18	2032-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320819	2032	3	8	19	2032-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320820	2032	3	8	20	2032-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320821	2032	3	8	21	2032-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320822	2032	3	8	22	2032-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320823	2032	3	8	23	2032-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320824	2032	3	8	24	2032-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320825	2032	3	8	25	2032-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320826	2032	3	8	26	2032-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320827	2032	3	8	27	2032-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320828	2032	3	8	28	2032-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320829	2032	3	8	29	2032-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320830	2032	3	8	30	2032-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320831	2032	3	8	31	2032-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20320901	2032	3	9	1	2032-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320902	2032	3	9	2	2032-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320903	2032	3	9	3	2032-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320904	2032	3	9	4	2032-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320905	2032	3	9	5	2032-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320906	2032	3	9	6	2032-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320907	2032	3	9	7	2032-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320908	2032	3	9	8	2032-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320909	2032	3	9	9	2032-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320910	2032	3	9	10	2032-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320911	2032	3	9	11	2032-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320912	2032	3	9	12	2032-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320913	2032	3	9	13	2032-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320914	2032	3	9	14	2032-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320915	2032	3	9	15	2032-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320916	2032	3	9	16	2032-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320917	2032	3	9	17	2032-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320918	2032	3	9	18	2032-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320919	2032	3	9	19	2032-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320920	2032	3	9	20	2032-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320921	2032	3	9	21	2032-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320922	2032	3	9	22	2032-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320923	2032	3	9	23	2032-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320924	2032	3	9	24	2032-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320925	2032	3	9	25	2032-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320926	2032	3	9	26	2032-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320927	2032	3	9	27	2032-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320928	2032	3	9	28	2032-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320929	2032	3	9	29	2032-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20320930	2032	3	9	30	2032-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20321001	2032	4	10	1	2032-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321002	2032	4	10	2	2032-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321003	2032	4	10	3	2032-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321004	2032	4	10	4	2032-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321005	2032	4	10	5	2032-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321006	2032	4	10	6	2032-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321007	2032	4	10	7	2032-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321008	2032	4	10	8	2032-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321009	2032	4	10	9	2032-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321010	2032	4	10	10	2032-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321011	2032	4	10	11	2032-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321012	2032	4	10	12	2032-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321013	2032	4	10	13	2032-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321014	2032	4	10	14	2032-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321015	2032	4	10	15	2032-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321016	2032	4	10	16	2032-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321017	2032	4	10	17	2032-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321018	2032	4	10	18	2032-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321019	2032	4	10	19	2032-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321020	2032	4	10	20	2032-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321021	2032	4	10	21	2032-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321022	2032	4	10	22	2032-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321023	2032	4	10	23	2032-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321024	2032	4	10	24	2032-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321025	2032	4	10	25	2032-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321026	2032	4	10	26	2032-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321027	2032	4	10	27	2032-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321028	2032	4	10	28	2032-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321029	2032	4	10	29	2032-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321030	2032	4	10	30	2032-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321031	2032	4	10	31	2032-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20321101	2032	4	11	1	2032-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321102	2032	4	11	2	2032-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321103	2032	4	11	3	2032-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321104	2032	4	11	4	2032-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321105	2032	4	11	5	2032-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321106	2032	4	11	6	2032-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321107	2032	4	11	7	2032-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321108	2032	4	11	8	2032-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321109	2032	4	11	9	2032-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321110	2032	4	11	10	2032-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321111	2032	4	11	11	2032-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321112	2032	4	11	12	2032-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321113	2032	4	11	13	2032-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321114	2032	4	11	14	2032-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321115	2032	4	11	15	2032-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321116	2032	4	11	16	2032-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321117	2032	4	11	17	2032-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321118	2032	4	11	18	2032-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321119	2032	4	11	19	2032-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321120	2032	4	11	20	2032-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321121	2032	4	11	21	2032-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321122	2032	4	11	22	2032-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321123	2032	4	11	23	2032-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321124	2032	4	11	24	2032-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321125	2032	4	11	25	2032-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321126	2032	4	11	26	2032-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321127	2032	4	11	27	2032-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321128	2032	4	11	28	2032-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321129	2032	4	11	29	2032-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321130	2032	4	11	30	2032-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20321201	2032	4	12	1	2032-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321202	2032	4	12	2	2032-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321203	2032	4	12	3	2032-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321204	2032	4	12	4	2032-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321205	2032	4	12	5	2032-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321206	2032	4	12	6	2032-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321207	2032	4	12	7	2032-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321208	2032	4	12	8	2032-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321209	2032	4	12	9	2032-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321210	2032	4	12	10	2032-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321211	2032	4	12	11	2032-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321212	2032	4	12	12	2032-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321213	2032	4	12	13	2032-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321214	2032	4	12	14	2032-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321215	2032	4	12	15	2032-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321216	2032	4	12	16	2032-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321217	2032	4	12	17	2032-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321218	2032	4	12	18	2032-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321219	2032	4	12	19	2032-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321220	2032	4	12	20	2032-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321221	2032	4	12	21	2032-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321222	2032	4	12	22	2032-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321223	2032	4	12	23	2032-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321224	2032	4	12	24	2032-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321225	2032	4	12	25	2032-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321226	2032	4	12	26	2032-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321227	2032	4	12	27	2032-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321228	2032	4	12	28	2032-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321229	2032	4	12	29	2032-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321230	2032	4	12	30	2032-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20321231	2032	4	12	31	2032-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20330101	2033	1	1	1	2033-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
20330102	2033	1	1	2	2033-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
20330103	2033	1	1	3	2033-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
20330104	2033	1	1	4	2033-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
20330105	2033	1	1	5	2033-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
20330106	2033	1	1	6	2033-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
20330107	2033	1	1	7	2033-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
20330108	2033	1	1	8	2033-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
20330109	2033	1	1	9	2033-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
20330110	2033	1	1	10	2033-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
20330111	2033	1	1	11	2033-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
20330112	2033	1	1	12	2033-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
20330113	2033	1	1	13	2033-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
20330114	2033	1	1	14	2033-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
20330115	2033	1	1	15	2033-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
20330116	2033	1	1	16	2033-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
20330117	2033	1	1	17	2033-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
20330118	2033	1	1	18	2033-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
20330119	2033	1	1	19	2033-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
20330120	2033	1	1	20	2033-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
20330121	2033	1	1	21	2033-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
20330122	2033	1	1	22	2033-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
20330123	2033	1	1	23	2033-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
20330124	2033	1	1	24	2033-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
20330125	2033	1	1	25	2033-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
20330126	2033	1	1	26	2033-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
20330127	2033	1	1	27	2033-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
20330128	2033	1	1	28	2033-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
20330129	2033	1	1	29	2033-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
20330130	2033	1	1	30	2033-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
20330131	2033	1	1	31	2033-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
20330201	2033	1	2	1	2033-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330202	2033	1	2	2	2033-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330203	2033	1	2	3	2033-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330204	2033	1	2	4	2033-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330205	2033	1	2	5	2033-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330206	2033	1	2	6	2033-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330207	2033	1	2	7	2033-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330208	2033	1	2	8	2033-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330209	2033	1	2	9	2033-02-09 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330210	2033	1	2	10	2033-02-10 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330211	2033	1	2	11	2033-02-11 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330212	2033	1	2	12	2033-02-12 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330213	2033	1	2	13	2033-02-13 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330214	2033	1	2	14	2033-02-14 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330215	2033	1	2	15	2033-02-15 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330216	2033	1	2	16	2033-02-16 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330217	2033	1	2	17	2033-02-17 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330218	2033	1	2	18	2033-02-18 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330219	2033	1	2	19	2033-02-19 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330220	2033	1	2	20	2033-02-20 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330221	2033	1	2	21	2033-02-21 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330222	2033	1	2	22	2033-02-22 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330223	2033	1	2	23	2033-02-23 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330224	2033	1	2	24	2033-02-24 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330225	2033	1	2	25	2033-02-25 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330226	2033	1	2	26	2033-02-26 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330227	2033	1	2	27	2033-02-27 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330228	2033	1	2	28	2033-02-28 00:00:00	1	Semestre1	Trimestre1	FEBRERO
20330301	2033	1	3	1	2033-03-01 00:00:00	1	Semestre1	Trimestre1	MARZO
20330302	2033	1	3	2	2033-03-02 00:00:00	1	Semestre1	Trimestre1	MARZO
20330303	2033	1	3	3	2033-03-03 00:00:00	1	Semestre1	Trimestre1	MARZO
20330304	2033	1	3	4	2033-03-04 00:00:00	1	Semestre1	Trimestre1	MARZO
20330305	2033	1	3	5	2033-03-05 00:00:00	1	Semestre1	Trimestre1	MARZO
20330306	2033	1	3	6	2033-03-06 00:00:00	1	Semestre1	Trimestre1	MARZO
20330307	2033	1	3	7	2033-03-07 00:00:00	1	Semestre1	Trimestre1	MARZO
20330308	2033	1	3	8	2033-03-08 00:00:00	1	Semestre1	Trimestre1	MARZO
20330309	2033	1	3	9	2033-03-09 00:00:00	1	Semestre1	Trimestre1	MARZO
20330310	2033	1	3	10	2033-03-10 00:00:00	1	Semestre1	Trimestre1	MARZO
20330311	2033	1	3	11	2033-03-11 00:00:00	1	Semestre1	Trimestre1	MARZO
20330312	2033	1	3	12	2033-03-12 00:00:00	1	Semestre1	Trimestre1	MARZO
20330313	2033	1	3	13	2033-03-13 00:00:00	1	Semestre1	Trimestre1	MARZO
20330314	2033	1	3	14	2033-03-14 00:00:00	1	Semestre1	Trimestre1	MARZO
20330315	2033	1	3	15	2033-03-15 00:00:00	1	Semestre1	Trimestre1	MARZO
20330316	2033	1	3	16	2033-03-16 00:00:00	1	Semestre1	Trimestre1	MARZO
20330317	2033	1	3	17	2033-03-17 00:00:00	1	Semestre1	Trimestre1	MARZO
20330318	2033	1	3	18	2033-03-18 00:00:00	1	Semestre1	Trimestre1	MARZO
20330319	2033	1	3	19	2033-03-19 00:00:00	1	Semestre1	Trimestre1	MARZO
20330320	2033	1	3	20	2033-03-20 00:00:00	1	Semestre1	Trimestre1	MARZO
20330321	2033	1	3	21	2033-03-21 00:00:00	1	Semestre1	Trimestre1	MARZO
20330322	2033	1	3	22	2033-03-22 00:00:00	1	Semestre1	Trimestre1	MARZO
20330323	2033	1	3	23	2033-03-23 00:00:00	1	Semestre1	Trimestre1	MARZO
20330324	2033	1	3	24	2033-03-24 00:00:00	1	Semestre1	Trimestre1	MARZO
20330325	2033	1	3	25	2033-03-25 00:00:00	1	Semestre1	Trimestre1	MARZO
20330326	2033	1	3	26	2033-03-26 00:00:00	1	Semestre1	Trimestre1	MARZO
20330327	2033	1	3	27	2033-03-27 00:00:00	1	Semestre1	Trimestre1	MARZO
20330328	2033	1	3	28	2033-03-28 00:00:00	1	Semestre1	Trimestre1	MARZO
20330329	2033	1	3	29	2033-03-29 00:00:00	1	Semestre1	Trimestre1	MARZO
20330330	2033	1	3	30	2033-03-30 00:00:00	1	Semestre1	Trimestre1	MARZO
20330331	2033	1	3	31	2033-03-31 00:00:00	1	Semestre1	Trimestre1	MARZO
20330401	2033	2	4	1	2033-04-01 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330402	2033	2	4	2	2033-04-02 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330403	2033	2	4	3	2033-04-03 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330404	2033	2	4	4	2033-04-04 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330405	2033	2	4	5	2033-04-05 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330406	2033	2	4	6	2033-04-06 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330407	2033	2	4	7	2033-04-07 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330408	2033	2	4	8	2033-04-08 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330409	2033	2	4	9	2033-04-09 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330410	2033	2	4	10	2033-04-10 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330411	2033	2	4	11	2033-04-11 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330412	2033	2	4	12	2033-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330413	2033	2	4	13	2033-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330414	2033	2	4	14	2033-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330415	2033	2	4	15	2033-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330416	2033	2	4	16	2033-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330417	2033	2	4	17	2033-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330418	2033	2	4	18	2033-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330419	2033	2	4	19	2033-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330420	2033	2	4	20	2033-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330421	2033	2	4	21	2033-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330422	2033	2	4	22	2033-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330423	2033	2	4	23	2033-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330424	2033	2	4	24	2033-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330425	2033	2	4	25	2033-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330426	2033	2	4	26	2033-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330427	2033	2	4	27	2033-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330428	2033	2	4	28	2033-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330429	2033	2	4	29	2033-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330430	2033	2	4	30	2033-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20330501	2033	2	5	1	2033-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
20330502	2033	2	5	2	2033-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
20330503	2033	2	5	3	2033-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
20330504	2033	2	5	4	2033-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
20330505	2033	2	5	5	2033-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
20330506	2033	2	5	6	2033-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
20330507	2033	2	5	7	2033-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
20330508	2033	2	5	8	2033-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
20330509	2033	2	5	9	2033-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
20330510	2033	2	5	10	2033-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
20330511	2033	2	5	11	2033-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
20330512	2033	2	5	12	2033-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
20330513	2033	2	5	13	2033-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
20330514	2033	2	5	14	2033-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
20330515	2033	2	5	15	2033-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
20330516	2033	2	5	16	2033-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
20330517	2033	2	5	17	2033-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
20330518	2033	2	5	18	2033-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
20330519	2033	2	5	19	2033-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
20330520	2033	2	5	20	2033-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
20330521	2033	2	5	21	2033-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
20330522	2033	2	5	22	2033-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
20330523	2033	2	5	23	2033-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
20330524	2033	2	5	24	2033-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
20330525	2033	2	5	25	2033-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
20330526	2033	2	5	26	2033-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
20330527	2033	2	5	27	2033-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
20330528	2033	2	5	28	2033-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
20330529	2033	2	5	29	2033-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
20330530	2033	2	5	30	2033-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
20330531	2033	2	5	31	2033-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
20330601	2033	2	6	1	2033-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330602	2033	2	6	2	2033-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330603	2033	2	6	3	2033-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330604	2033	2	6	4	2033-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330605	2033	2	6	5	2033-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330606	2033	2	6	6	2033-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330607	2033	2	6	7	2033-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330608	2033	2	6	8	2033-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330609	2033	2	6	9	2033-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330610	2033	2	6	10	2033-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330611	2033	2	6	11	2033-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330612	2033	2	6	12	2033-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330613	2033	2	6	13	2033-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330614	2033	2	6	14	2033-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330615	2033	2	6	15	2033-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330616	2033	2	6	16	2033-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330617	2033	2	6	17	2033-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330618	2033	2	6	18	2033-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330619	2033	2	6	19	2033-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330620	2033	2	6	20	2033-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330621	2033	2	6	21	2033-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330622	2033	2	6	22	2033-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330623	2033	2	6	23	2033-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330624	2033	2	6	24	2033-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330625	2033	2	6	25	2033-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330626	2033	2	6	26	2033-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330627	2033	2	6	27	2033-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330628	2033	2	6	28	2033-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330629	2033	2	6	29	2033-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330630	2033	2	6	30	2033-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
20330701	2033	3	7	1	2033-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
20330702	2033	3	7	2	2033-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
20330703	2033	3	7	3	2033-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
20330704	2033	3	7	4	2033-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
20330705	2033	3	7	5	2033-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
20330706	2033	3	7	6	2033-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
20330707	2033	3	7	7	2033-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
20330708	2033	3	7	8	2033-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
20330709	2033	3	7	9	2033-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
20330710	2033	3	7	10	2033-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
20330711	2033	3	7	11	2033-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
20330712	2033	3	7	12	2033-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
20330713	2033	3	7	13	2033-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
20330714	2033	3	7	14	2033-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
20330715	2033	3	7	15	2033-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
20330716	2033	3	7	16	2033-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
20330717	2033	3	7	17	2033-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
20330718	2033	3	7	18	2033-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
20330719	2033	3	7	19	2033-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
20330720	2033	3	7	20	2033-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
20330721	2033	3	7	21	2033-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
20330722	2033	3	7	22	2033-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
20330723	2033	3	7	23	2033-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
20330724	2033	3	7	24	2033-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
20330725	2033	3	7	25	2033-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
20330726	2033	3	7	26	2033-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
20330727	2033	3	7	27	2033-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
20330728	2033	3	7	28	2033-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
20330729	2033	3	7	29	2033-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
20330730	2033	3	7	30	2033-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
20330731	2033	3	7	31	2033-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
20330801	2033	3	8	1	2033-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330802	2033	3	8	2	2033-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330803	2033	3	8	3	2033-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330804	2033	3	8	4	2033-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330805	2033	3	8	5	2033-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330806	2033	3	8	6	2033-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330807	2033	3	8	7	2033-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330808	2033	3	8	8	2033-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330809	2033	3	8	9	2033-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330810	2033	3	8	10	2033-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330811	2033	3	8	11	2033-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330812	2033	3	8	12	2033-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330813	2033	3	8	13	2033-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330814	2033	3	8	14	2033-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330815	2033	3	8	15	2033-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330816	2033	3	8	16	2033-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330817	2033	3	8	17	2033-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330818	2033	3	8	18	2033-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330819	2033	3	8	19	2033-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330820	2033	3	8	20	2033-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330821	2033	3	8	21	2033-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330822	2033	3	8	22	2033-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330823	2033	3	8	23	2033-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330824	2033	3	8	24	2033-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330825	2033	3	8	25	2033-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330826	2033	3	8	26	2033-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330827	2033	3	8	27	2033-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330828	2033	3	8	28	2033-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330829	2033	3	8	29	2033-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330830	2033	3	8	30	2033-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330831	2033	3	8	31	2033-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
20330901	2033	3	9	1	2033-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330902	2033	3	9	2	2033-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330903	2033	3	9	3	2033-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330904	2033	3	9	4	2033-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330905	2033	3	9	5	2033-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330906	2033	3	9	6	2033-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330907	2033	3	9	7	2033-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330908	2033	3	9	8	2033-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330909	2033	3	9	9	2033-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330910	2033	3	9	10	2033-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330911	2033	3	9	11	2033-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330912	2033	3	9	12	2033-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330913	2033	3	9	13	2033-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330914	2033	3	9	14	2033-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330915	2033	3	9	15	2033-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330916	2033	3	9	16	2033-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330917	2033	3	9	17	2033-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330918	2033	3	9	18	2033-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330919	2033	3	9	19	2033-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330920	2033	3	9	20	2033-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330921	2033	3	9	21	2033-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330922	2033	3	9	22	2033-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330923	2033	3	9	23	2033-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330924	2033	3	9	24	2033-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330925	2033	3	9	25	2033-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330926	2033	3	9	26	2033-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330927	2033	3	9	27	2033-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330928	2033	3	9	28	2033-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330929	2033	3	9	29	2033-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20330930	2033	3	9	30	2033-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
20331001	2033	4	10	1	2033-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331002	2033	4	10	2	2033-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331003	2033	4	10	3	2033-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331004	2033	4	10	4	2033-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331005	2033	4	10	5	2033-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331006	2033	4	10	6	2033-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331007	2033	4	10	7	2033-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331008	2033	4	10	8	2033-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331009	2033	4	10	9	2033-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331010	2033	4	10	10	2033-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331011	2033	4	10	11	2033-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331012	2033	4	10	12	2033-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331013	2033	4	10	13	2033-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331014	2033	4	10	14	2033-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331015	2033	4	10	15	2033-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331016	2033	4	10	16	2033-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331017	2033	4	10	17	2033-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331018	2033	4	10	18	2033-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331019	2033	4	10	19	2033-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331020	2033	4	10	20	2033-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331021	2033	4	10	21	2033-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331022	2033	4	10	22	2033-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331023	2033	4	10	23	2033-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331024	2033	4	10	24	2033-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331025	2033	4	10	25	2033-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331026	2033	4	10	26	2033-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331027	2033	4	10	27	2033-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331028	2033	4	10	28	2033-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331029	2033	4	10	29	2033-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331030	2033	4	10	30	2033-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331031	2033	4	10	31	2033-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
20331101	2033	4	11	1	2033-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331102	2033	4	11	2	2033-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331103	2033	4	11	3	2033-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331104	2033	4	11	4	2033-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331105	2033	4	11	5	2033-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331106	2033	4	11	6	2033-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331107	2033	4	11	7	2033-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331108	2033	4	11	8	2033-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331109	2033	4	11	9	2033-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331110	2033	4	11	10	2033-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331111	2033	4	11	11	2033-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331112	2033	4	11	12	2033-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331113	2033	4	11	13	2033-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331114	2033	4	11	14	2033-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331115	2033	4	11	15	2033-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331116	2033	4	11	16	2033-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331117	2033	4	11	17	2033-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331118	2033	4	11	18	2033-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331119	2033	4	11	19	2033-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331120	2033	4	11	20	2033-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331121	2033	4	11	21	2033-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331122	2033	4	11	22	2033-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331123	2033	4	11	23	2033-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331124	2033	4	11	24	2033-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331125	2033	4	11	25	2033-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331126	2033	4	11	26	2033-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331127	2033	4	11	27	2033-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331128	2033	4	11	28	2033-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331129	2033	4	11	29	2033-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331130	2033	4	11	30	2033-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
20331201	2033	4	12	1	2033-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331202	2033	4	12	2	2033-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331203	2033	4	12	3	2033-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331204	2033	4	12	4	2033-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331205	2033	4	12	5	2033-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331206	2033	4	12	6	2033-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331207	2033	4	12	7	2033-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331208	2033	4	12	8	2033-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331209	2033	4	12	9	2033-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331210	2033	4	12	10	2033-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331211	2033	4	12	11	2033-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331212	2033	4	12	12	2033-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331213	2033	4	12	13	2033-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331214	2033	4	12	14	2033-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331215	2033	4	12	15	2033-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331216	2033	4	12	16	2033-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331217	2033	4	12	17	2033-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331218	2033	4	12	18	2033-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331219	2033	4	12	19	2033-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331220	2033	4	12	20	2033-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331221	2033	4	12	21	2033-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331222	2033	4	12	22	2033-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331223	2033	4	12	23	2033-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331224	2033	4	12	24	2033-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331225	2033	4	12	25	2033-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331226	2033	4	12	26	2033-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331227	2033	4	12	27	2033-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331228	2033	4	12	28	2033-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331229	2033	4	12	29	2033-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331230	2033	4	12	30	2033-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20331231	2033	4	12	31	2033-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
20340101	2034	1	1	1	2034-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
\.


--
-- TOC entry 3114 (class 0 OID 16973)
-- Dependencies: 205
-- Data for Name: dim_persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_persona (pk_persona, sk_persona, edad, genero, valido_desde, valido_hasta, version) FROM stdin;
1	1	63	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
2	2	37	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
3	3	41	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
4	4	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
5	5	57	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
6	6	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
7	7	56	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
8	8	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
9	9	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
10	10	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
11	11	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
12	12	48	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
13	13	49	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
14	14	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
15	15	58	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
16	16	50	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
17	17	58	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
18	18	66	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
19	19	43	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
20	20	69	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
21	21	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
22	22	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
23	23	42	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
24	24	61	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
25	25	40	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
26	26	71	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
27	27	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
28	28	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
29	29	65	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
30	30	53	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
31	31	41	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
32	32	65	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
33	33	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
34	34	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
35	35	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
36	36	46	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
37	37	54	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
38	38	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
39	39	65	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
40	40	65	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
41	41	51	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
42	42	48	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
43	43	45	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
44	44	53	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
45	45	39	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
46	46	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
47	47	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
48	48	47	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
49	49	53	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
50	50	53	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
51	51	51	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
52	52	66	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
53	53	62	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
54	54	44	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
55	55	63	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
56	56	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
57	57	48	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
58	58	45	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
59	59	34	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
60	60	57	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
61	61	71	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
62	62	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
63	63	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
64	64	41	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
65	65	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
66	66	35	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
67	67	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
68	68	45	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
69	69	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
70	70	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
71	71	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
72	72	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
73	73	29	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
74	74	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
75	75	43	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
76	76	55	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
77	77	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
78	78	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
79	79	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
80	80	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
81	81	41	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
82	82	45	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
83	83	60	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
84	84	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
85	85	42	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
86	86	67	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
87	87	68	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
88	88	46	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
89	89	54	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
90	90	58	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
91	91	48	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
92	92	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
93	93	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
94	94	54	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
95	95	45	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
96	96	53	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
97	97	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
98	98	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
99	99	43	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
100	100	53	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
101	101	42	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
102	102	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
103	103	63	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
104	104	42	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
105	105	50	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
106	106	68	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
107	107	69	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
108	108	45	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
109	109	50	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
110	110	50	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
111	111	64	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
112	112	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
113	113	64	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
114	114	43	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
115	115	55	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
116	116	37	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
117	117	41	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
118	118	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
119	119	46	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
120	120	46	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
121	121	64	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
122	122	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
123	123	41	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
124	124	54	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
125	125	39	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
126	126	34	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
127	127	47	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
128	128	67	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
129	129	52	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
130	130	74	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
131	131	54	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
132	132	49	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
133	133	42	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
134	134	41	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
135	135	41	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
136	136	49	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
137	137	60	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
138	138	62	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
139	139	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
140	140	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
141	141	51	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
142	142	43	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
143	143	42	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
144	144	67	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
145	145	76	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
146	146	70	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
147	147	44	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
148	148	60	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
149	149	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
150	150	42	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
151	151	66	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
152	152	71	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
153	153	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
154	154	66	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
155	155	39	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
156	156	58	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
157	157	47	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
158	158	35	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
159	159	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
160	160	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
161	161	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
162	162	55	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
163	163	41	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
164	164	38	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
165	165	38	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
166	166	67	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
167	167	67	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
168	168	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
169	169	63	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
170	170	53	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
171	171	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
172	172	48	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
173	173	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
174	174	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
175	175	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
176	176	40	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
177	177	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
178	178	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
179	179	43	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
180	180	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
181	181	55	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
182	182	65	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
183	183	61	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
184	184	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
185	185	50	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
186	186	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
187	187	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
188	188	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
189	189	50	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
190	190	41	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
191	191	51	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
192	192	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
193	193	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
194	194	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
195	195	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
196	196	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
197	197	46	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
198	198	67	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
199	199	62	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
200	200	65	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
201	201	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
202	202	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
203	203	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
204	204	68	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
205	205	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
206	206	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
207	207	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
208	208	60	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
209	209	49	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
210	210	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
211	211	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
212	212	61	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
213	213	39	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
214	214	61	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
215	215	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
216	216	43	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
217	217	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
218	218	63	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
219	219	65	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
220	220	48	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
221	221	63	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
222	222	55	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
223	223	65	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
224	224	56	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
225	225	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
226	226	70	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
227	227	62	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
228	228	35	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
229	229	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
230	230	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
231	231	47	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
232	232	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
233	233	55	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
234	234	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
235	235	70	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
236	236	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
237	237	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
238	238	60	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
239	239	77	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
240	240	35	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
241	241	70	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
242	242	59	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
243	243	64	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
244	244	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
245	245	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
246	246	48	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
247	247	56	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
248	248	66	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
249	249	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
250	250	69	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
251	251	51	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
252	252	43	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
253	253	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
254	254	67	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
255	255	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
256	256	45	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
257	257	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
258	258	50	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
259	259	62	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
260	260	38	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
261	261	66	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
262	262	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
263	263	53	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
264	264	63	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
265	265	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
266	266	66	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
267	267	55	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
268	268	49	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
269	269	54	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
270	270	56	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
271	271	46	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
272	272	61	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
273	273	67	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
274	274	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
275	275	47	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
276	276	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
277	277	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
278	278	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
279	279	58	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
280	280	61	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
281	281	42	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
282	282	52	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
283	283	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
284	284	40	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
285	285	61	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
286	286	46	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
287	287	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
288	288	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
289	289	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
290	290	55	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
291	291	61	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
292	292	58	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
293	293	58	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
294	294	67	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
295	295	44	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
296	296	63	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
297	297	63	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
298	298	59	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
299	299	57	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
300	300	45	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
301	301	68	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
302	302	57	1	2018-01-01 00:00:00	2025-12-31 00:00:00	1
303	303	57	0	2018-01-01 00:00:00	2025-12-31 00:00:00	1
\.


--
-- TOC entry 3115 (class 0 OID 16976)
-- Dependencies: 206
-- Data for Name: dim_report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_report (pk_report, dolor_pecho, presion_art, colesterol, azucar_sangre, result_elect, frec_cardiaca, angina_inducida, pico_anterior, tasa_tal, variable_objetivo, fecha_diagnostico, edad, genero, saturacion, buques, pendiente, anio, trimestre, mes, dia, fecha, semestre, nombre_semestre, nombre_trimestre, nombre_mes) FROM stdin;
1	3	145	233	1	0	150	0	2	1	1	2018-04-12 00:00:00	63	1	99	0	0	2018	2	4	12	2018-04-12 00:00:00	1	Semestre1	Trimestre2	ABRIL
2	2	130	250	0	1	187	0	4	2	1	2018-04-13 00:00:00	37	1	99	0	0	2018	2	4	13	2018-04-13 00:00:00	1	Semestre1	Trimestre2	ABRIL
3	1	130	204	0	0	172	0	1	2	1	2018-04-14 00:00:00	41	0	99	0	2	2018	2	4	14	2018-04-14 00:00:00	1	Semestre1	Trimestre2	ABRIL
4	1	120	236	0	1	178	0	1	2	1	2018-04-15 00:00:00	56	1	99	0	2	2018	2	4	15	2018-04-15 00:00:00	1	Semestre1	Trimestre2	ABRIL
5	0	120	354	0	1	163	1	1	2	1	2018-04-16 00:00:00	57	0	99	0	2	2018	2	4	16	2018-04-16 00:00:00	1	Semestre1	Trimestre2	ABRIL
6	0	140	192	0	1	148	0	0	1	1	2018-04-17 00:00:00	57	1	98	0	1	2018	2	4	17	2018-04-17 00:00:00	1	Semestre1	Trimestre2	ABRIL
7	1	140	294	0	0	153	0	1	2	1	2018-04-18 00:00:00	56	0	98	0	1	2018	2	4	18	2018-04-18 00:00:00	1	Semestre1	Trimestre2	ABRIL
8	1	120	263	0	1	173	0	0	3	1	2018-04-19 00:00:00	44	1	98	0	2	2018	2	4	19	2018-04-19 00:00:00	1	Semestre1	Trimestre2	ABRIL
9	2	172	199	1	1	162	0	0	3	1	2018-04-20 00:00:00	52	1	98	0	2	2018	2	4	20	2018-04-20 00:00:00	1	Semestre1	Trimestre2	ABRIL
10	2	150	168	0	1	174	0	2	2	1	2018-04-21 00:00:00	57	1	98	0	2	2018	2	4	21	2018-04-21 00:00:00	1	Semestre1	Trimestre2	ABRIL
11	0	140	239	0	1	160	0	1	2	1	2018-04-22 00:00:00	54	1	98	0	2	2018	2	4	22	2018-04-22 00:00:00	1	Semestre1	Trimestre2	ABRIL
12	2	130	275	0	1	139	0	0	2	1	2018-04-23 00:00:00	48	0	98	0	2	2018	2	4	23	2018-04-23 00:00:00	1	Semestre1	Trimestre2	ABRIL
13	1	130	266	0	1	171	0	1	2	1	2018-04-24 00:00:00	49	1	98	0	2	2018	2	4	24	2018-04-24 00:00:00	1	Semestre1	Trimestre2	ABRIL
14	3	110	211	0	0	144	1	2	2	1	2018-04-25 00:00:00	64	1	98	0	1	2018	2	4	25	2018-04-25 00:00:00	1	Semestre1	Trimestre2	ABRIL
15	3	150	283	1	0	162	0	1	2	1	2018-04-26 00:00:00	58	0	98	0	2	2018	2	4	26	2018-04-26 00:00:00	1	Semestre1	Trimestre2	ABRIL
16	2	120	219	0	1	158	0	2	2	1	2018-04-27 00:00:00	50	0	98	0	1	2018	2	4	27	2018-04-27 00:00:00	1	Semestre1	Trimestre2	ABRIL
17	2	120	340	0	1	172	0	0	2	1	2018-04-28 00:00:00	58	0	98	0	2	2018	2	4	28	2018-04-28 00:00:00	1	Semestre1	Trimestre2	ABRIL
18	3	150	226	0	1	114	0	3	2	1	2018-04-29 00:00:00	66	0	99	0	0	2018	2	4	29	2018-04-29 00:00:00	1	Semestre1	Trimestre2	ABRIL
19	0	150	247	0	1	171	0	2	2	1	2018-04-30 00:00:00	43	1	99	0	2	2018	2	4	30	2018-04-30 00:00:00	1	Semestre1	Trimestre2	ABRIL
20	3	140	239	0	1	151	0	2	2	1	2018-05-01 00:00:00	69	0	99	2	2	2018	2	5	1	2018-05-01 00:00:00	1	Semestre1	Trimestre2	MAYO
21	0	135	234	0	1	161	0	0	3	1	2018-05-02 00:00:00	59	1	99	0	1	2018	2	5	2	2018-05-02 00:00:00	1	Semestre1	Trimestre2	MAYO
22	2	130	233	0	1	179	1	0	2	1	2018-05-03 00:00:00	44	1	99	0	2	2018	2	5	3	2018-05-03 00:00:00	1	Semestre1	Trimestre2	MAYO
23	0	140	226	0	1	178	0	0	2	1	2018-05-04 00:00:00	42	1	99	0	2	2018	2	5	4	2018-05-04 00:00:00	1	Semestre1	Trimestre2	MAYO
24	2	150	243	1	1	137	1	1	2	1	2018-05-05 00:00:00	61	1	99	0	1	2018	2	5	5	2018-05-05 00:00:00	1	Semestre1	Trimestre2	MAYO
25	3	140	199	0	1	178	1	1	3	1	2018-05-06 00:00:00	40	1	98	0	2	2018	2	5	6	2018-05-06 00:00:00	1	Semestre1	Trimestre2	MAYO
26	1	160	302	0	1	162	0	0	2	1	2018-05-07 00:00:00	71	0	98	2	2	2018	2	5	7	2018-05-07 00:00:00	1	Semestre1	Trimestre2	MAYO
27	2	150	212	1	1	157	0	2	2	1	2018-05-08 00:00:00	59	1	98	0	2	2018	2	5	8	2018-05-08 00:00:00	1	Semestre1	Trimestre2	MAYO
28	2	110	175	0	1	123	0	1	2	1	2018-05-09 00:00:00	51	1	98	0	2	2018	2	5	9	2018-05-09 00:00:00	1	Semestre1	Trimestre2	MAYO
29	2	140	417	1	0	157	0	1	2	1	2018-05-10 00:00:00	65	0	98	1	2	2018	2	5	10	2018-05-10 00:00:00	1	Semestre1	Trimestre2	MAYO
30	2	130	197	1	0	152	0	1	2	1	2018-05-11 00:00:00	53	1	98	0	0	2018	2	5	11	2018-05-11 00:00:00	1	Semestre1	Trimestre2	MAYO
31	1	105	198	0	1	168	0	0	2	1	2018-05-12 00:00:00	41	0	98	1	2	2018	2	5	12	2018-05-12 00:00:00	1	Semestre1	Trimestre2	MAYO
32	0	120	177	0	1	140	0	0	3	1	2018-05-13 00:00:00	65	1	98	0	2	2018	2	5	13	2018-05-13 00:00:00	1	Semestre1	Trimestre2	MAYO
33	1	130	219	0	0	188	0	0	2	1	2018-05-14 00:00:00	44	1	98	0	2	2018	2	5	14	2018-05-14 00:00:00	1	Semestre1	Trimestre2	MAYO
34	2	125	273	0	0	152	0	0	2	1	2018-05-15 00:00:00	54	1	98	1	0	2018	2	5	15	2018-05-15 00:00:00	1	Semestre1	Trimestre2	MAYO
35	3	125	213	0	0	125	1	1	2	1	2018-05-16 00:00:00	51	1	98	1	2	2018	2	5	16	2018-05-16 00:00:00	1	Semestre1	Trimestre2	MAYO
36	2	142	177	0	0	160	1	1	2	1	2018-05-17 00:00:00	46	0	98	0	0	2018	2	5	17	2018-05-17 00:00:00	1	Semestre1	Trimestre2	MAYO
37	2	135	304	1	1	170	0	0	2	1	2018-05-18 00:00:00	54	0	98	0	2	2018	2	5	18	2018-05-18 00:00:00	1	Semestre1	Trimestre2	MAYO
38	2	150	232	0	0	165	0	2	3	1	2018-05-19 00:00:00	54	1	98	0	2	2018	2	5	19	2018-05-19 00:00:00	1	Semestre1	Trimestre2	MAYO
39	2	155	269	0	1	148	0	1	2	1	2018-05-20 00:00:00	65	0	98	0	2	2018	2	5	20	2018-05-20 00:00:00	1	Semestre1	Trimestre2	MAYO
40	2	160	360	0	0	151	0	1	2	1	2018-05-21 00:00:00	65	0	98	0	2	2018	2	5	21	2018-05-21 00:00:00	1	Semestre1	Trimestre2	MAYO
41	2	140	308	0	0	142	0	2	2	1	2018-05-22 00:00:00	51	0	98	1	2	2018	2	5	22	2018-05-22 00:00:00	1	Semestre1	Trimestre2	MAYO
42	1	130	245	0	0	180	0	0	2	1	2018-05-23 00:00:00	48	1	98	0	1	2018	2	5	23	2018-05-23 00:00:00	1	Semestre1	Trimestre2	MAYO
43	0	104	208	0	0	148	1	3	2	1	2018-05-24 00:00:00	45	1	98	0	1	2018	2	5	24	2018-05-24 00:00:00	1	Semestre1	Trimestre2	MAYO
44	0	130	264	0	0	143	0	0	2	1	2018-05-25 00:00:00	53	0	98	0	1	2018	2	5	25	2018-05-25 00:00:00	1	Semestre1	Trimestre2	MAYO
45	2	140	321	0	0	182	0	0	2	1	2018-05-26 00:00:00	39	1	98	0	2	2018	2	5	26	2018-05-26 00:00:00	1	Semestre1	Trimestre2	MAYO
46	1	120	325	0	1	172	0	0	2	1	2018-05-27 00:00:00	52	1	98	0	2	2018	2	5	27	2018-05-27 00:00:00	1	Semestre1	Trimestre2	MAYO
47	2	140	235	0	0	180	0	0	2	1	2018-05-28 00:00:00	44	1	97	0	2	2018	2	5	28	2018-05-28 00:00:00	1	Semestre1	Trimestre2	MAYO
48	2	138	257	0	0	156	0	0	2	1	2018-05-29 00:00:00	47	1	96	0	2	2018	2	5	29	2018-05-29 00:00:00	1	Semestre1	Trimestre2	MAYO
49	2	128	216	0	0	115	0	0	0	1	2018-05-30 00:00:00	53	0	96	0	2	2018	2	5	30	2018-05-30 00:00:00	1	Semestre1	Trimestre2	MAYO
50	0	138	234	0	0	160	0	0	2	1	2018-05-31 00:00:00	53	0	97	0	2	2018	2	5	31	2018-05-31 00:00:00	1	Semestre1	Trimestre2	MAYO
51	2	130	256	0	0	149	0	0	2	1	2018-06-01 00:00:00	51	0	98	0	2	2018	2	6	1	2018-06-01 00:00:00	1	Semestre1	Trimestre2	JUNIO
52	0	120	302	0	0	151	0	0	2	1	2018-06-02 00:00:00	66	1	98	0	1	2018	2	6	2	2018-06-02 00:00:00	1	Semestre1	Trimestre2	JUNIO
53	2	130	231	0	1	146	0	2	3	1	2018-06-03 00:00:00	62	1	98	3	1	2018	2	6	3	2018-06-03 00:00:00	1	Semestre1	Trimestre2	JUNIO
54	2	108	141	0	1	175	0	1	2	1	2018-06-04 00:00:00	44	0	98	0	1	2018	2	6	4	2018-06-04 00:00:00	1	Semestre1	Trimestre2	JUNIO
55	2	135	252	0	0	172	0	0	2	1	2018-06-05 00:00:00	63	0	98	0	2	2018	2	6	5	2018-06-05 00:00:00	1	Semestre1	Trimestre2	JUNIO
56	1	134	201	0	1	158	0	1	2	1	2018-06-06 00:00:00	52	1	98	1	2	2018	2	6	6	2018-06-06 00:00:00	1	Semestre1	Trimestre2	JUNIO
57	0	122	222	0	0	186	0	0	2	1	2018-06-07 00:00:00	48	1	98	0	2	2018	2	6	7	2018-06-07 00:00:00	1	Semestre1	Trimestre2	JUNIO
58	0	115	260	0	0	185	0	0	2	1	2018-06-08 00:00:00	45	1	98	0	2	2018	2	6	8	2018-06-08 00:00:00	1	Semestre1	Trimestre2	JUNIO
59	3	118	182	0	0	174	0	0	2	1	2018-06-09 00:00:00	34	1	98	0	2	2018	2	6	9	2018-06-09 00:00:00	1	Semestre1	Trimestre2	JUNIO
60	0	128	303	0	0	159	0	0	2	1	2018-06-10 00:00:00	57	0	98	1	2	2018	2	6	10	2018-06-10 00:00:00	1	Semestre1	Trimestre2	JUNIO
61	2	110	265	1	0	130	0	0	2	1	2018-06-11 00:00:00	71	0	98	1	2	2018	2	6	11	2018-06-11 00:00:00	1	Semestre1	Trimestre2	JUNIO
62	1	108	309	0	1	156	0	0	3	1	2018-06-12 00:00:00	54	1	98	0	2	2018	2	6	12	2018-06-12 00:00:00	1	Semestre1	Trimestre2	JUNIO
63	3	118	186	0	0	190	0	0	1	1	2018-06-13 00:00:00	52	1	98	0	1	2018	2	6	13	2018-06-13 00:00:00	1	Semestre1	Trimestre2	JUNIO
64	1	135	203	0	1	132	0	0	1	1	2018-06-14 00:00:00	41	1	98	0	1	2018	2	6	14	2018-06-14 00:00:00	1	Semestre1	Trimestre2	JUNIO
65	2	140	211	1	0	165	0	0	2	1	2018-06-15 00:00:00	58	1	98	0	2	2018	2	6	15	2018-06-15 00:00:00	1	Semestre1	Trimestre2	JUNIO
66	0	138	183	0	1	182	0	1	2	1	2018-06-16 00:00:00	35	0	98	0	2	2018	2	6	16	2018-06-16 00:00:00	1	Semestre1	Trimestre2	JUNIO
67	2	100	222	0	1	143	1	1	2	1	2018-06-17 00:00:00	51	1	98	0	1	2018	2	6	17	2018-06-17 00:00:00	1	Semestre1	Trimestre2	JUNIO
68	1	130	234	0	0	175	0	1	2	1	2018-06-18 00:00:00	45	0	98	0	1	2018	2	6	18	2018-06-18 00:00:00	1	Semestre1	Trimestre2	JUNIO
69	1	120	220	0	1	170	0	0	2	1	2018-06-19 00:00:00	44	1	98	0	2	2018	2	6	19	2018-06-19 00:00:00	1	Semestre1	Trimestre2	JUNIO
70	0	124	209	0	1	163	0	0	2	1	2018-06-20 00:00:00	62	0	98	0	2	2018	2	6	20	2018-06-20 00:00:00	1	Semestre1	Trimestre2	JUNIO
71	2	120	258	0	0	147	0	0	3	1	2018-06-21 00:00:00	54	1	98	0	1	2018	2	6	21	2018-06-21 00:00:00	1	Semestre1	Trimestre2	JUNIO
72	2	94	227	0	1	154	1	0	3	1	2018-06-22 00:00:00	51	1	98	1	2	2018	2	6	22	2018-06-22 00:00:00	1	Semestre1	Trimestre2	JUNIO
73	1	130	204	0	0	202	0	0	2	1	2018-06-23 00:00:00	29	1	98	0	2	2018	2	6	23	2018-06-23 00:00:00	1	Semestre1	Trimestre2	JUNIO
74	0	140	261	0	0	186	1	0	2	1	2018-06-24 00:00:00	51	1	98	0	2	2018	2	6	24	2018-06-24 00:00:00	1	Semestre1	Trimestre2	JUNIO
75	2	122	213	0	1	165	0	0	2	1	2018-06-25 00:00:00	43	0	98	0	1	2018	2	6	25	2018-06-25 00:00:00	1	Semestre1	Trimestre2	JUNIO
76	1	135	250	0	0	161	0	1	2	1	2018-06-26 00:00:00	55	0	98	0	1	2018	2	6	26	2018-06-26 00:00:00	1	Semestre1	Trimestre2	JUNIO
77	2	125	245	1	0	166	0	2	2	1	2018-06-27 00:00:00	51	1	98	0	1	2018	2	6	27	2018-06-27 00:00:00	1	Semestre1	Trimestre2	JUNIO
78	1	140	221	0	1	164	1	0	2	1	2018-06-28 00:00:00	59	1	98	0	2	2018	2	6	28	2018-06-28 00:00:00	1	Semestre1	Trimestre2	JUNIO
79	1	128	205	1	1	184	0	0	2	1	2018-06-29 00:00:00	52	1	98	0	2	2018	2	6	29	2018-06-29 00:00:00	1	Semestre1	Trimestre2	JUNIO
80	2	105	240	0	0	154	1	1	3	1	2018-06-30 00:00:00	58	1	98	0	1	2018	2	6	30	2018-06-30 00:00:00	1	Semestre1	Trimestre2	JUNIO
81	2	112	250	0	1	179	0	0	2	1	2018-07-01 00:00:00	41	1	98	0	2	2018	3	7	1	2018-07-01 00:00:00	2	Semestre2	Trimestre3	JULIO
82	1	128	308	0	0	170	0	0	2	1	2018-07-02 00:00:00	45	1	98	0	2	2018	3	7	2	2018-07-02 00:00:00	2	Semestre2	Trimestre3	JULIO
83	2	102	318	0	1	160	0	0	2	1	2018-07-03 00:00:00	60	0	98	1	2	2018	3	7	3	2018-07-03 00:00:00	2	Semestre2	Trimestre3	JULIO
84	3	152	298	1	1	178	0	1	3	1	2018-07-04 00:00:00	52	1	98	0	1	2018	3	7	4	2018-07-04 00:00:00	2	Semestre2	Trimestre3	JULIO
85	0	102	265	0	0	122	0	1	2	1	2018-07-05 00:00:00	42	0	98	0	1	2018	3	7	5	2018-07-05 00:00:00	2	Semestre2	Trimestre3	JULIO
86	2	115	564	0	0	160	0	2	3	1	2018-07-06 00:00:00	67	0	98	0	1	2018	3	7	6	2018-07-06 00:00:00	2	Semestre2	Trimestre3	JULIO
87	2	118	277	0	1	151	0	1	3	1	2018-07-07 00:00:00	68	1	98	1	2	2018	3	7	7	2018-07-07 00:00:00	2	Semestre2	Trimestre3	JULIO
88	1	101	197	1	1	156	0	0	3	1	2018-07-08 00:00:00	46	1	98	0	2	2018	3	7	8	2018-07-08 00:00:00	2	Semestre2	Trimestre3	JULIO
89	2	110	214	0	1	158	0	2	2	1	2018-07-09 00:00:00	54	0	98	0	1	2018	3	7	9	2018-07-09 00:00:00	2	Semestre2	Trimestre3	JULIO
90	0	100	248	0	0	122	0	1	2	1	2018-07-10 00:00:00	58	0	98	0	1	2018	3	7	10	2018-07-10 00:00:00	2	Semestre2	Trimestre3	JULIO
91	2	124	255	1	1	175	0	0	2	1	2018-07-11 00:00:00	48	1	98	2	2	2018	3	7	11	2018-07-11 00:00:00	2	Semestre2	Trimestre3	JULIO
92	0	132	207	0	1	168	1	0	3	1	2018-07-12 00:00:00	57	1	98	0	2	2018	3	7	12	2018-07-12 00:00:00	2	Semestre2	Trimestre3	JULIO
93	2	138	223	0	1	169	0	0	2	1	2018-07-13 00:00:00	52	1	98	4	2	2018	3	7	13	2018-07-13 00:00:00	2	Semestre2	Trimestre3	JULIO
94	1	132	288	1	0	159	1	0	2	1	2018-07-14 00:00:00	54	0	98	1	2	2018	3	7	14	2018-07-14 00:00:00	2	Semestre2	Trimestre3	JULIO
95	1	112	160	0	1	138	0	0	2	1	2018-07-15 00:00:00	45	0	98	0	1	2018	3	7	15	2018-07-15 00:00:00	2	Semestre2	Trimestre3	JULIO
96	0	142	226	0	0	111	1	0	3	1	2018-07-16 00:00:00	53	1	98	0	2	2018	3	7	16	2018-07-16 00:00:00	2	Semestre2	Trimestre3	JULIO
97	0	140	394	0	0	157	0	1	2	1	2018-07-17 00:00:00	62	0	98	0	1	2018	3	7	17	2018-07-17 00:00:00	2	Semestre2	Trimestre3	JULIO
98	0	108	233	1	1	147	0	0	3	1	2018-07-18 00:00:00	52	1	98	3	2	2018	3	7	18	2018-07-18 00:00:00	2	Semestre2	Trimestre3	JULIO
99	2	130	315	0	1	162	0	2	2	1	2018-07-19 00:00:00	43	1	98	1	2	2018	3	7	19	2018-07-19 00:00:00	2	Semestre2	Trimestre3	JULIO
100	2	130	246	1	0	173	0	0	2	1	2018-07-20 00:00:00	53	1	98	3	2	2018	3	7	20	2018-07-20 00:00:00	2	Semestre2	Trimestre3	JULIO
101	3	148	244	0	0	178	0	1	2	1	2018-07-21 00:00:00	42	1	98	2	2	2018	3	7	21	2018-07-21 00:00:00	2	Semestre2	Trimestre3	JULIO
102	3	178	270	0	0	145	0	4	3	1	2018-07-22 00:00:00	59	1	98	0	0	2018	3	7	22	2018-07-22 00:00:00	2	Semestre2	Trimestre3	JULIO
103	1	140	195	0	1	179	0	0	2	1	2018-07-23 00:00:00	63	0	98	2	2	2018	3	7	23	2018-07-23 00:00:00	2	Semestre2	Trimestre3	JULIO
104	2	120	240	1	1	194	0	1	3	1	2018-07-24 00:00:00	42	1	98	0	0	2018	3	7	24	2018-07-24 00:00:00	2	Semestre2	Trimestre3	JULIO
105	2	129	196	0	1	163	0	0	2	1	2018-07-25 00:00:00	50	1	98	0	2	2018	3	7	25	2018-07-25 00:00:00	2	Semestre2	Trimestre3	JULIO
106	2	120	211	0	0	115	0	2	2	1	2018-07-26 00:00:00	68	0	98	0	1	2018	3	7	26	2018-07-26 00:00:00	2	Semestre2	Trimestre3	JULIO
107	3	160	234	1	0	131	0	0	2	1	2018-07-27 00:00:00	69	1	98	1	1	2018	3	7	27	2018-07-27 00:00:00	2	Semestre2	Trimestre3	JULIO
108	0	138	236	0	0	152	1	0	2	1	2018-07-28 00:00:00	45	0	98	0	1	2018	3	7	28	2018-07-28 00:00:00	2	Semestre2	Trimestre3	JULIO
109	1	120	244	0	1	162	0	1	2	1	2018-07-29 00:00:00	50	0	98	0	2	2018	3	7	29	2018-07-29 00:00:00	2	Semestre2	Trimestre3	JULIO
110	0	110	254	0	0	159	0	0	2	1	2018-07-30 00:00:00	50	0	98	0	2	2018	3	7	30	2018-07-30 00:00:00	2	Semestre2	Trimestre3	JULIO
111	0	180	325	0	1	154	1	0	2	1	2018-07-31 00:00:00	64	0	98	0	2	2018	3	7	31	2018-07-31 00:00:00	2	Semestre2	Trimestre3	JULIO
112	2	150	126	1	1	173	0	0	3	1	2018-08-01 00:00:00	57	1	98	1	2	2018	3	8	1	2018-08-01 00:00:00	2	Semestre2	Trimestre3	AGOSTO
113	2	140	313	0	1	133	0	0	3	1	2018-08-02 00:00:00	64	0	98	0	2	2018	3	8	2	2018-08-02 00:00:00	2	Semestre2	Trimestre3	AGOSTO
114	0	110	211	0	1	161	0	0	3	1	2018-08-03 00:00:00	43	1	98	0	2	2018	3	8	3	2018-08-03 00:00:00	2	Semestre2	Trimestre3	AGOSTO
115	1	130	262	0	1	155	0	0	2	1	2018-08-04 00:00:00	55	1	98	0	2	2018	3	8	4	2018-08-04 00:00:00	2	Semestre2	Trimestre3	AGOSTO
116	2	120	215	0	1	170	0	0	2	1	2018-08-05 00:00:00	37	0	98	0	2	2018	3	8	5	2018-08-05 00:00:00	2	Semestre2	Trimestre3	AGOSTO
117	2	130	214	0	0	168	0	2	2	1	2018-08-06 00:00:00	41	1	98	0	1	2018	3	8	6	2018-08-06 00:00:00	2	Semestre2	Trimestre3	AGOSTO
118	3	120	193	0	0	162	0	2	3	1	2018-08-07 00:00:00	56	1	98	0	1	2018	3	8	7	2018-08-07 00:00:00	2	Semestre2	Trimestre3	AGOSTO
119	1	105	204	0	1	172	0	0	2	1	2018-08-08 00:00:00	46	0	98	0	2	2018	3	8	8	2018-08-08 00:00:00	2	Semestre2	Trimestre3	AGOSTO
120	0	138	243	0	0	152	1	0	2	1	2018-08-09 00:00:00	46	0	98	0	1	2018	3	8	9	2018-08-09 00:00:00	2	Semestre2	Trimestre3	AGOSTO
121	0	130	303	0	1	122	0	2	2	1	2018-08-10 00:00:00	64	0	98	2	1	2018	3	8	10	2018-08-10 00:00:00	2	Semestre2	Trimestre3	AGOSTO
122	0	138	271	0	0	182	0	0	2	1	2018-08-11 00:00:00	59	1	98	0	2	2018	3	8	11	2018-08-11 00:00:00	2	Semestre2	Trimestre3	AGOSTO
123	2	112	268	0	0	172	1	0	2	1	2018-08-12 00:00:00	41	0	98	0	2	2018	3	8	12	2018-08-12 00:00:00	2	Semestre2	Trimestre3	AGOSTO
124	2	108	267	0	0	167	0	0	2	1	2018-08-13 00:00:00	54	0	98	0	2	2018	3	8	13	2018-08-13 00:00:00	2	Semestre2	Trimestre3	AGOSTO
125	2	94	199	0	1	179	0	0	2	1	2018-08-14 00:00:00	39	0	98	0	2	2018	3	8	14	2018-08-14 00:00:00	2	Semestre2	Trimestre3	AGOSTO
126	1	118	210	0	1	192	0	1	2	1	2018-08-15 00:00:00	34	0	98	0	2	2018	3	8	15	2018-08-15 00:00:00	2	Semestre2	Trimestre3	AGOSTO
127	0	112	204	0	1	143	0	0	2	1	2018-08-16 00:00:00	47	1	98	0	2	2018	3	8	16	2018-08-16 00:00:00	2	Semestre2	Trimestre3	AGOSTO
128	2	152	277	0	1	172	0	0	2	1	2018-08-17 00:00:00	67	0	98	1	2	2018	3	8	17	2018-08-17 00:00:00	2	Semestre2	Trimestre3	AGOSTO
129	2	136	196	0	0	169	0	0	2	1	2018-08-18 00:00:00	52	0	98	0	1	2018	3	8	18	2018-08-18 00:00:00	2	Semestre2	Trimestre3	AGOSTO
130	1	120	269	0	0	121	1	0	2	1	2018-08-19 00:00:00	74	0	98	1	2	2018	3	8	19	2018-08-19 00:00:00	2	Semestre2	Trimestre3	AGOSTO
131	2	160	201	0	1	163	0	0	2	1	2018-08-20 00:00:00	54	0	98	1	2	2018	3	8	20	2018-08-20 00:00:00	2	Semestre2	Trimestre3	AGOSTO
132	1	134	271	0	1	162	0	0	2	1	2018-08-21 00:00:00	49	0	98	0	1	2018	3	8	21	2018-08-21 00:00:00	2	Semestre2	Trimestre3	AGOSTO
133	1	120	295	0	1	162	0	0	2	1	2018-08-22 00:00:00	42	1	98	0	2	2018	3	8	22	2018-08-22 00:00:00	2	Semestre2	Trimestre3	AGOSTO
134	1	110	235	0	1	153	0	0	2	1	2018-08-23 00:00:00	41	1	98	0	2	2018	3	8	23	2018-08-23 00:00:00	2	Semestre2	Trimestre3	AGOSTO
135	1	126	306	0	1	163	0	0	2	1	2018-08-24 00:00:00	41	0	98	0	2	2018	3	8	24	2018-08-24 00:00:00	2	Semestre2	Trimestre3	AGOSTO
136	0	130	269	0	1	163	0	0	2	1	2018-08-25 00:00:00	49	0	98	0	2	2018	3	8	25	2018-08-25 00:00:00	2	Semestre2	Trimestre3	AGOSTO
137	2	120	178	1	1	96	0	0	2	1	2018-08-26 00:00:00	60	0	98	0	2	2018	3	8	26	2018-08-26 00:00:00	2	Semestre2	Trimestre3	AGOSTO
138	1	128	208	1	0	140	0	0	2	1	2018-08-27 00:00:00	62	1	98	0	2	2018	3	8	27	2018-08-27 00:00:00	2	Semestre2	Trimestre3	AGOSTO
139	0	110	201	0	1	126	1	2	1	1	2018-08-28 00:00:00	57	1	98	0	1	2018	3	8	28	2018-08-28 00:00:00	2	Semestre2	Trimestre3	AGOSTO
140	0	128	263	0	1	105	1	0	3	1	2018-08-29 00:00:00	64	1	98	1	1	2018	3	8	29	2018-08-29 00:00:00	2	Semestre2	Trimestre3	AGOSTO
141	2	120	295	0	0	157	0	1	2	1	2018-08-30 00:00:00	51	0	98	0	2	2018	3	8	30	2018-08-30 00:00:00	2	Semestre2	Trimestre3	AGOSTO
142	0	115	303	0	1	181	0	1	2	1	2018-08-31 00:00:00	43	1	98	0	1	2018	3	8	31	2018-08-31 00:00:00	2	Semestre2	Trimestre3	AGOSTO
143	2	120	209	0	1	173	0	0	2	1	2018-09-01 00:00:00	42	0	98	0	1	2018	3	9	1	2018-09-01 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
144	0	106	223	0	1	142	0	0	2	1	2018-09-02 00:00:00	67	0	98	2	2	2018	3	9	2	2018-09-02 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
145	2	140	197	0	2	116	0	1	2	1	2018-09-03 00:00:00	76	0	98	0	1	2018	3	9	3	2018-09-03 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
146	1	156	245	0	0	143	0	0	2	1	2018-09-04 00:00:00	70	1	98	0	2	2018	3	9	4	2018-09-04 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
147	2	118	242	0	1	149	0	0	2	1	2018-09-05 00:00:00	44	0	98	1	1	2018	3	9	5	2018-09-05 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
148	3	150	240	0	1	171	0	1	2	1	2018-09-06 00:00:00	60	0	98	0	2	2018	3	9	6	2018-09-06 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
149	2	120	226	0	1	169	0	0	2	1	2018-09-07 00:00:00	44	1	98	0	2	2018	3	9	7	2018-09-07 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
150	2	130	180	0	1	150	0	0	2	1	2018-09-08 00:00:00	42	1	98	0	2	2018	3	9	8	2018-09-08 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
151	0	160	228	0	0	138	0	2	1	1	2018-09-09 00:00:00	66	1	98	0	2	2018	3	9	9	2018-09-09 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
152	0	112	149	0	1	125	0	2	2	1	2018-09-10 00:00:00	71	0	98	0	1	2018	3	9	10	2018-09-10 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
153	3	170	227	0	0	155	0	1	3	1	2018-09-11 00:00:00	64	1	98	0	1	2018	3	9	11	2018-09-11 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
154	2	146	278	0	0	152	0	0	2	1	2018-09-12 00:00:00	66	0	98	1	1	2018	3	9	12	2018-09-12 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
155	2	138	220	0	1	152	0	0	2	1	2018-09-13 00:00:00	39	0	98	0	1	2018	3	9	13	2018-09-13 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
156	0	130	197	0	1	131	0	1	2	1	2018-09-14 00:00:00	58	0	98	0	1	2018	3	9	14	2018-09-14 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
157	2	130	253	0	1	179	0	0	2	1	2018-09-15 00:00:00	47	1	98	0	2	2018	3	9	15	2018-09-15 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
158	1	122	192	0	1	174	0	0	2	1	2018-09-16 00:00:00	35	1	98	0	2	2018	3	9	16	2018-09-16 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
159	1	125	220	0	1	144	0	0	3	1	2018-09-17 00:00:00	58	1	98	4	1	2018	3	9	17	2018-09-17 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
160	1	130	221	0	0	163	0	0	3	1	2018-09-18 00:00:00	56	1	98	0	2	2018	3	9	18	2018-09-18 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
161	1	120	240	0	1	169	0	0	2	1	2018-09-19 00:00:00	56	1	98	0	0	2018	3	9	19	2018-09-19 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
162	1	132	342	0	1	166	0	1	2	1	2018-09-20 00:00:00	55	0	98	0	2	2018	3	9	20	2018-09-20 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
163	1	120	157	0	1	182	0	0	2	1	2018-09-21 00:00:00	41	1	98	0	2	2018	3	9	21	2018-09-21 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
164	2	138	175	0	1	173	0	0	2	1	2018-09-22 00:00:00	38	1	98	4	2	2018	3	9	22	2018-09-22 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
165	2	138	175	0	1	173	0	0	2	1	2018-09-23 00:00:00	38	1	98	4	2	2018	3	9	23	2018-09-23 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
166	0	160	286	0	0	108	1	2	2	0	2018-09-24 00:00:00	67	1	98	3	1	2018	3	9	24	2018-09-24 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
167	0	120	229	0	0	129	1	3	3	0	2018-09-25 00:00:00	67	1	98	2	1	2018	3	9	25	2018-09-25 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
168	0	140	268	0	0	160	0	4	2	0	2018-09-26 00:00:00	62	0	98	2	0	2018	3	9	26	2018-09-26 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
169	0	130	254	0	0	147	0	1	3	0	2018-09-27 00:00:00	63	1	98	1	1	2018	3	9	27	2018-09-27 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
170	0	140	203	1	0	155	1	3	3	0	2018-09-28 00:00:00	53	1	98	0	0	2018	3	9	28	2018-09-28 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
171	2	130	256	1	0	142	1	1	1	0	2018-09-29 00:00:00	56	1	98	1	1	2018	3	9	29	2018-09-29 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
172	1	110	229	0	1	168	0	1	3	0	2018-09-30 00:00:00	48	1	98	0	0	2018	3	9	30	2018-09-30 00:00:00	2	Semestre2	Trimestre3	SEPTIEMBRE
173	1	120	284	0	0	160	0	2	2	0	2018-10-01 00:00:00	58	1	98	0	1	2018	4	10	1	2018-10-01 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
174	2	132	224	0	0	173	0	3	3	0	2018-10-02 00:00:00	58	1	98	2	2	2018	4	10	2	2018-10-02 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
175	0	130	206	0	0	132	1	2	3	0	2018-10-03 00:00:00	60	1	98	2	1	2018	4	10	3	2018-10-03 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
176	0	110	167	0	0	114	1	2	3	0	2018-10-04 00:00:00	40	1	98	0	1	2018	4	10	4	2018-10-04 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
177	0	117	230	1	1	160	1	1	3	0	2018-10-05 00:00:00	60	1	98	2	2	2018	4	10	5	2018-10-05 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
178	2	140	335	0	1	158	0	0	2	0	2018-10-06 00:00:00	64	1	98	0	2	2018	4	10	6	2018-10-06 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
179	0	120	177	0	0	120	1	2	3	0	2018-10-07 00:00:00	43	1	98	0	1	2018	4	10	7	2018-10-07 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
180	0	150	276	0	0	112	1	1	1	0	2018-10-08 00:00:00	57	1	98	1	1	2018	4	10	8	2018-10-08 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
181	0	132	353	0	1	132	1	1	3	0	2018-10-09 00:00:00	55	1	98	1	1	2018	4	10	9	2018-10-09 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
182	0	150	225	0	0	114	0	1	3	0	2018-10-10 00:00:00	65	0	98	3	1	2018	4	10	10	2018-10-10 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
183	0	130	330	0	0	169	0	0	2	0	2018-10-11 00:00:00	61	0	98	0	2	2018	4	10	11	2018-10-11 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
184	2	112	230	0	0	165	0	2	3	0	2018-10-12 00:00:00	58	1	98	1	1	2018	4	10	12	2018-10-12 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
185	0	150	243	0	0	128	0	3	3	0	2018-10-13 00:00:00	50	1	98	0	1	2018	4	10	13	2018-10-13 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
186	0	112	290	0	0	153	0	0	2	0	2018-10-14 00:00:00	44	1	98	1	2	2018	4	10	14	2018-10-14 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
187	0	130	253	0	1	144	1	1	3	0	2018-10-15 00:00:00	60	1	98	1	2	2018	4	10	15	2018-10-15 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
188	0	124	266	0	0	109	1	2	3	0	2018-10-16 00:00:00	54	1	98	1	1	2018	4	10	16	2018-10-16 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
189	2	140	233	0	1	163	0	1	3	0	2018-10-17 00:00:00	50	1	98	1	1	2018	4	10	17	2018-10-17 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
190	0	110	172	0	0	158	0	0	3	0	2018-10-18 00:00:00	41	1	98	0	2	2018	4	10	18	2018-10-18 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
191	0	130	305	0	1	142	1	1	3	0	2018-10-19 00:00:00	51	0	98	0	1	2018	4	10	19	2018-10-19 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
192	0	128	216	0	0	131	1	2	3	0	2018-10-20 00:00:00	58	1	98	3	1	2018	4	10	20	2018-10-20 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
193	0	120	188	0	1	113	0	1	3	0	2018-10-21 00:00:00	54	1	98	1	1	2018	4	10	21	2018-10-21 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
194	0	145	282	0	0	142	1	3	3	0	2018-10-22 00:00:00	60	1	98	2	1	2018	4	10	22	2018-10-22 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
195	2	140	185	0	0	155	0	3	2	0	2018-10-23 00:00:00	60	1	98	0	1	2018	4	10	23	2018-10-23 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
196	0	170	326	0	0	140	1	3	3	0	2018-10-24 00:00:00	59	1	98	0	0	2018	4	10	24	2018-10-24 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
197	2	150	231	0	1	147	0	4	2	0	2018-10-25 00:00:00	46	1	98	0	1	2018	4	10	25	2018-10-25 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
198	0	125	254	1	1	163	0	0	3	0	2018-10-26 00:00:00	67	1	98	2	1	2018	4	10	26	2018-10-26 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
199	0	120	267	0	1	99	1	2	3	0	2018-10-27 00:00:00	62	1	98	2	1	2018	4	10	27	2018-10-27 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
200	0	110	248	0	0	158	0	1	1	0	2018-10-28 00:00:00	65	1	98	2	2	2018	4	10	28	2018-10-28 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
201	0	110	197	0	0	177	0	0	2	0	2018-10-29 00:00:00	44	1	98	1	2	2018	4	10	29	2018-10-29 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
202	0	125	258	0	0	141	1	3	3	0	2018-10-30 00:00:00	60	1	98	1	1	2018	4	10	30	2018-10-30 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
203	0	150	270	0	0	111	1	1	3	0	2018-10-31 00:00:00	58	1	98	0	2	2018	4	10	31	2018-10-31 00:00:00	2	Semestre2	Trimestre4	OCTUBRE
204	2	180	274	1	0	150	1	2	3	0	2018-11-01 00:00:00	68	1	98	0	1	2018	4	11	1	2018-11-01 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
205	0	160	164	0	0	145	0	6	3	0	2018-11-02 00:00:00	62	0	98	3	0	2018	4	11	2	2018-11-02 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
206	0	128	255	0	1	161	1	0	3	0	2018-11-03 00:00:00	52	1	98	1	2	2018	4	11	3	2018-11-03 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
207	0	110	239	0	0	142	1	1	3	0	2018-11-04 00:00:00	59	1	98	1	1	2018	4	11	4	2018-11-04 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
208	0	150	258	0	0	157	0	3	3	0	2018-11-05 00:00:00	60	0	98	2	1	2018	4	11	5	2018-11-05 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
209	2	120	188	0	1	139	0	2	3	0	2018-11-06 00:00:00	49	1	98	3	1	2018	4	11	6	2018-11-06 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
210	0	140	177	0	1	162	1	0	3	0	2018-11-07 00:00:00	59	1	98	1	2	2018	4	11	7	2018-11-07 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
211	2	128	229	0	0	150	0	0	3	0	2018-11-08 00:00:00	57	1	98	1	1	2018	4	11	8	2018-11-08 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
212	0	120	260	0	1	140	1	4	3	0	2018-11-09 00:00:00	61	1	98	1	1	2018	4	11	9	2018-11-09 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
213	0	118	219	0	1	140	0	1	3	0	2018-11-10 00:00:00	39	1	98	0	1	2018	4	11	10	2018-11-10 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
214	0	145	307	0	0	146	1	1	3	0	2018-11-11 00:00:00	61	0	98	0	1	2018	4	11	11	2018-11-11 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
215	0	125	249	1	0	144	1	1	2	0	2018-11-12 00:00:00	56	1	98	1	1	2018	4	11	12	2018-11-12 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
216	0	132	341	1	0	136	1	3	3	0	2018-11-13 00:00:00	43	0	98	0	1	2018	4	11	13	2018-11-13 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
217	2	130	263	0	1	97	0	1	3	0	2018-11-14 00:00:00	62	0	98	1	1	2018	4	11	14	2018-11-14 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
218	0	130	330	1	0	132	1	2	3	0	2018-11-15 00:00:00	63	1	98	3	2	2018	4	11	15	2018-11-15 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
219	0	135	254	0	0	127	0	3	3	0	2018-11-16 00:00:00	65	1	98	1	1	2018	4	11	16	2018-11-16 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
220	0	130	256	1	0	150	1	0	3	0	2018-11-17 00:00:00	48	1	98	2	2	2018	4	11	17	2018-11-17 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
221	0	150	407	0	0	154	0	4	3	0	2018-11-18 00:00:00	63	0	98	3	1	2018	4	11	18	2018-11-18 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
222	0	140	217	0	1	111	1	6	3	0	2018-11-19 00:00:00	55	1	98	0	0	2018	4	11	19	2018-11-19 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
223	3	138	282	1	0	174	0	1	2	0	2018-11-20 00:00:00	65	1	98	1	1	2018	4	11	20	2018-11-20 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
224	0	200	288	1	0	133	1	4	3	0	2018-11-21 00:00:00	56	0	98	2	0	2018	4	11	21	2018-11-21 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
225	0	110	239	0	1	126	1	3	3	0	2018-11-22 00:00:00	54	1	98	1	1	2018	4	11	22	2018-11-22 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
226	0	145	174	0	1	125	1	3	3	0	2018-11-23 00:00:00	70	1	98	0	0	2018	4	11	23	2018-11-23 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
227	1	120	281	0	0	103	0	1	3	0	2018-11-24 00:00:00	62	1	98	1	1	2018	4	11	24	2018-11-24 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
228	0	120	198	0	1	130	1	2	3	0	2018-11-25 00:00:00	35	1	98	0	1	2018	4	11	25	2018-11-25 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
229	3	170	288	0	0	159	0	0	3	0	2018-11-26 00:00:00	59	1	98	0	1	2018	4	11	26	2018-11-26 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
230	2	125	309	0	1	131	1	2	3	0	2018-11-27 00:00:00	64	1	98	0	1	2018	4	11	27	2018-11-27 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
231	2	108	243	0	1	152	0	0	2	0	2018-11-28 00:00:00	47	1	98	0	2	2018	4	11	28	2018-11-28 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
232	0	165	289	1	0	124	0	1	3	0	2018-11-29 00:00:00	57	1	98	3	1	2018	4	11	29	2018-11-29 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
233	0	160	289	0	0	145	1	1	3	0	2018-11-30 00:00:00	55	1	98	1	1	2018	4	11	30	2018-11-30 00:00:00	2	Semestre2	Trimestre4	NOVIEMBRE
234	0	120	246	0	0	96	1	2	2	0	2018-12-01 00:00:00	64	1	98	1	0	2018	4	12	1	2018-12-01 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
235	0	130	322	0	0	109	0	2	2	0	2018-12-02 00:00:00	70	1	98	3	1	2018	4	12	2	2018-12-02 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
236	0	140	299	0	1	173	1	2	3	0	2018-12-03 00:00:00	51	1	98	0	2	2018	4	12	3	2018-12-03 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
237	0	125	300	0	0	171	0	0	3	0	2018-12-04 00:00:00	58	1	98	2	2	2018	4	12	4	2018-12-04 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
238	0	140	293	0	0	170	0	1	3	0	2018-12-05 00:00:00	60	1	98	2	1	2018	4	12	5	2018-12-05 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
239	0	125	304	0	0	162	1	0	2	0	2018-12-06 00:00:00	77	1	98	3	2	2018	4	12	6	2018-12-06 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
240	0	126	282	0	0	156	1	0	3	0	2018-12-07 00:00:00	35	1	98	0	2	2018	4	12	7	2018-12-07 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
241	2	160	269	0	1	112	1	3	3	0	2018-12-08 00:00:00	70	1	98	1	1	2018	4	12	8	2018-12-08 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
242	0	174	249	0	1	143	1	0	2	0	2018-12-09 00:00:00	59	0	98	0	1	2018	4	12	9	2018-12-09 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
243	0	145	212	0	0	132	0	2	1	0	2018-12-10 00:00:00	64	1	98	2	1	2018	4	12	10	2018-12-10 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
244	0	152	274	0	1	88	1	1	3	0	2018-12-11 00:00:00	57	1	98	1	1	2018	4	12	11	2018-12-11 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
245	0	132	184	0	0	105	1	2	1	0	2018-12-12 00:00:00	56	1	98	1	1	2018	4	12	12	2018-12-12 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
246	0	124	274	0	0	166	0	0	3	0	2018-12-13 00:00:00	48	1	98	0	1	2018	4	12	13	2018-12-13 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
247	0	134	409	0	0	150	1	2	3	0	2018-12-14 00:00:00	56	0	98	2	1	2018	4	12	14	2018-12-14 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
248	1	160	246	0	1	120	1	0	1	0	2018-12-15 00:00:00	66	1	98	3	1	2018	4	12	15	2018-12-15 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
249	1	192	283	0	0	195	0	0	3	0	2018-12-16 00:00:00	54	1	98	1	2	2018	4	12	16	2018-12-16 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
250	2	140	254	0	0	146	0	2	3	0	2018-12-17 00:00:00	69	1	98	3	1	2018	4	12	17	2018-12-17 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
251	0	140	298	0	1	122	1	4	3	0	2018-12-18 00:00:00	51	1	98	3	1	2018	4	12	18	2018-12-18 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
252	0	132	247	1	0	143	1	0	3	0	2018-12-19 00:00:00	43	1	97	4	1	2018	4	12	19	2018-12-19 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
253	0	138	294	1	1	106	0	2	2	0	2018-12-20 00:00:00	62	0	97	3	1	2018	4	12	20	2018-12-20 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
254	0	100	299	0	0	125	1	1	2	0	2018-12-21 00:00:00	67	1	96	2	1	2018	4	12	21	2018-12-21 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
255	3	160	273	0	0	125	0	0	2	0	2018-12-22 00:00:00	59	1	96	0	2	2018	4	12	22	2018-12-22 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
256	0	142	309	0	0	147	1	0	3	0	2018-12-23 00:00:00	45	1	97	3	1	2018	4	12	23	2018-12-23 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
257	0	128	259	0	0	130	1	3	3	0	2018-12-24 00:00:00	58	1	98	2	1	2018	4	12	24	2018-12-24 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
258	0	144	200	0	0	126	1	1	3	0	2018-12-25 00:00:00	50	1	98	0	1	2018	4	12	25	2018-12-25 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
259	0	150	244	0	1	154	1	1	2	0	2018-12-26 00:00:00	62	0	98	0	1	2018	4	12	26	2018-12-26 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
260	3	120	231	0	1	182	1	4	3	0	2018-12-27 00:00:00	38	1	98	0	1	2018	4	12	27	2018-12-27 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
261	0	178	228	1	1	165	1	1	3	0	2018-12-28 00:00:00	66	0	98	2	1	2018	4	12	28	2018-12-28 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
262	0	112	230	0	1	160	0	0	2	0	2018-12-29 00:00:00	52	1	98	1	2	2018	4	12	29	2018-12-29 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
263	0	123	282	0	1	95	1	2	3	0	2018-12-30 00:00:00	53	1	98	2	1	2018	4	12	30	2018-12-30 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
264	0	108	269	0	1	169	1	2	2	0	2018-12-31 00:00:00	63	0	98	2	1	2018	4	12	31	2018-12-31 00:00:00	2	Semestre2	Trimestre4	DICIEMBRE
265	0	110	206	0	0	108	1	0	2	0	2019-01-01 00:00:00	54	1	98	1	1	2019	1	1	1	2019-01-01 00:00:00	1	Semestre1	Trimestre1	ENERO
266	0	112	212	0	0	132	1	0	2	0	2019-01-02 00:00:00	66	1	98	1	2	2019	1	1	2	2019-01-02 00:00:00	1	Semestre1	Trimestre1	ENERO
267	0	180	327	0	2	117	1	3	2	0	2019-01-03 00:00:00	55	0	98	0	1	2019	1	1	3	2019-01-03 00:00:00	1	Semestre1	Trimestre1	ENERO
268	2	118	149	0	0	126	0	1	2	0	2019-01-04 00:00:00	49	1	98	3	2	2019	1	1	4	2019-01-04 00:00:00	1	Semestre1	Trimestre1	ENERO
269	0	122	286	0	0	116	1	3	2	0	2019-01-05 00:00:00	54	1	98	2	1	2019	1	1	5	2019-01-05 00:00:00	1	Semestre1	Trimestre1	ENERO
270	0	130	283	1	0	103	1	2	3	0	2019-01-06 00:00:00	56	1	98	0	0	2019	1	1	6	2019-01-06 00:00:00	1	Semestre1	Trimestre1	ENERO
271	0	120	249	0	0	144	0	1	3	0	2019-01-07 00:00:00	46	1	98	0	2	2019	1	1	7	2019-01-07 00:00:00	1	Semestre1	Trimestre1	ENERO
272	3	134	234	0	1	145	0	3	2	0	2019-01-08 00:00:00	61	1	98	2	1	2019	1	1	8	2019-01-08 00:00:00	1	Semestre1	Trimestre1	ENERO
273	0	120	237	0	1	71	0	1	2	0	2019-01-09 00:00:00	67	1	97	0	1	2019	1	1	9	2019-01-09 00:00:00	1	Semestre1	Trimestre1	ENERO
274	0	100	234	0	1	156	0	0	3	0	2019-01-10 00:00:00	58	1	96	1	2	2019	1	1	10	2019-01-10 00:00:00	1	Semestre1	Trimestre1	ENERO
275	0	110	275	0	0	118	1	1	2	0	2019-01-11 00:00:00	47	1	96	1	1	2019	1	1	11	2019-01-11 00:00:00	1	Semestre1	Trimestre1	ENERO
276	0	125	212	0	1	168	0	1	3	0	2019-01-12 00:00:00	52	1	96	2	2	2019	1	1	12	2019-01-12 00:00:00	1	Semestre1	Trimestre1	ENERO
277	0	146	218	0	1	105	0	2	3	0	2019-01-13 00:00:00	58	1	96	1	1	2019	1	1	13	2019-01-13 00:00:00	1	Semestre1	Trimestre1	ENERO
278	1	124	261	0	1	141	0	0	3	0	2019-01-14 00:00:00	57	1	96	0	2	2019	1	1	14	2019-01-14 00:00:00	1	Semestre1	Trimestre1	ENERO
279	1	136	319	1	0	152	0	0	2	0	2019-01-15 00:00:00	58	0	96	2	2	2019	1	1	15	2019-01-15 00:00:00	1	Semestre1	Trimestre1	ENERO
280	0	138	166	0	0	125	1	4	2	0	2019-01-16 00:00:00	61	1	96	1	1	2019	1	1	16	2019-01-16 00:00:00	1	Semestre1	Trimestre1	ENERO
281	0	136	315	0	1	125	1	2	1	0	2019-01-17 00:00:00	42	1	96	0	1	2019	1	1	17	2019-01-17 00:00:00	1	Semestre1	Trimestre1	ENERO
282	0	128	204	1	1	156	1	1	0	0	2019-01-18 00:00:00	52	1	96	0	1	2019	1	1	18	2019-01-18 00:00:00	1	Semestre1	Trimestre1	ENERO
283	2	126	218	1	1	134	0	2	1	0	2019-01-19 00:00:00	59	1	96	1	1	2019	1	1	19	2019-01-19 00:00:00	1	Semestre1	Trimestre1	ENERO
284	0	152	223	0	1	181	0	0	3	0	2019-01-20 00:00:00	40	1	96	0	2	2019	1	1	20	2019-01-20 00:00:00	1	Semestre1	Trimestre1	ENERO
285	0	140	207	0	0	138	1	2	3	0	2019-01-21 00:00:00	61	1	96	1	2	2019	1	1	21	2019-01-21 00:00:00	1	Semestre1	Trimestre1	ENERO
286	0	140	311	0	1	120	1	2	3	0	2019-01-22 00:00:00	46	1	96	2	1	2019	1	1	22	2019-01-22 00:00:00	1	Semestre1	Trimestre1	ENERO
287	3	134	204	0	1	162	0	1	2	0	2019-01-23 00:00:00	59	1	96	2	2	2019	1	1	23	2019-01-23 00:00:00	1	Semestre1	Trimestre1	ENERO
288	1	154	232	0	0	164	0	0	2	0	2019-01-24 00:00:00	57	1	96	1	2	2019	1	1	24	2019-01-24 00:00:00	1	Semestre1	Trimestre1	ENERO
289	0	110	335	0	1	143	1	3	3	0	2019-01-25 00:00:00	57	1	97	1	1	2019	1	1	25	2019-01-25 00:00:00	1	Semestre1	Trimestre1	ENERO
290	0	128	205	0	2	130	1	2	3	0	2019-01-26 00:00:00	55	0	98	1	1	2019	1	1	26	2019-01-26 00:00:00	1	Semestre1	Trimestre1	ENERO
291	0	148	203	0	1	161	0	0	3	0	2019-01-27 00:00:00	61	1	98	1	2	2019	1	1	27	2019-01-27 00:00:00	1	Semestre1	Trimestre1	ENERO
292	0	114	318	0	2	140	0	4	1	0	2019-01-28 00:00:00	58	1	98	3	0	2019	1	1	28	2019-01-28 00:00:00	1	Semestre1	Trimestre1	ENERO
293	0	170	225	1	0	146	1	3	1	0	2019-01-29 00:00:00	58	0	98	2	1	2019	1	1	29	2019-01-29 00:00:00	1	Semestre1	Trimestre1	ENERO
294	2	152	212	0	0	150	0	1	3	0	2019-01-30 00:00:00	67	1	98	0	1	2019	1	1	30	2019-01-30 00:00:00	1	Semestre1	Trimestre1	ENERO
295	0	120	169	0	1	144	1	3	1	0	2019-01-31 00:00:00	44	1	98	0	0	2019	1	1	31	2019-01-31 00:00:00	1	Semestre1	Trimestre1	ENERO
296	0	140	187	0	0	144	1	4	3	0	2019-02-01 00:00:00	63	1	98	2	2	2019	1	2	1	2019-02-01 00:00:00	1	Semestre1	Trimestre1	FEBRERO
297	0	124	197	0	1	136	1	0	2	0	2019-02-02 00:00:00	63	0	98	0	1	2019	1	2	2	2019-02-02 00:00:00	1	Semestre1	Trimestre1	FEBRERO
298	0	164	176	1	0	90	0	1	1	0	2019-02-03 00:00:00	59	1	98	2	1	2019	1	2	3	2019-02-03 00:00:00	1	Semestre1	Trimestre1	FEBRERO
299	0	140	241	0	1	123	1	0	3	0	2019-02-04 00:00:00	57	0	98	0	1	2019	1	2	4	2019-02-04 00:00:00	1	Semestre1	Trimestre1	FEBRERO
300	3	110	264	0	1	132	0	1	3	0	2019-02-05 00:00:00	45	1	98	0	1	2019	1	2	5	2019-02-05 00:00:00	1	Semestre1	Trimestre1	FEBRERO
301	0	144	193	1	1	141	0	3	3	0	2019-02-06 00:00:00	68	1	98	2	1	2019	1	2	6	2019-02-06 00:00:00	1	Semestre1	Trimestre1	FEBRERO
302	0	130	131	0	1	115	1	1	3	0	2019-02-07 00:00:00	57	1	98	1	1	2019	1	2	7	2019-02-07 00:00:00	1	Semestre1	Trimestre1	FEBRERO
303	1	130	236	0	0	174	0	0	2	0	2019-02-08 00:00:00	57	0	98	1	1	2019	1	2	8	2019-02-08 00:00:00	1	Semestre1	Trimestre1	FEBRERO
\.


--
-- TOC entry 3116 (class 0 OID 16979)
-- Dependencies: 207
-- Data for Name: dim_saturacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_saturacion (pk_saturacion, sk_saturacion, saturacion, valido_desde, valido_hasta, version) FROM stdin;
1	1	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
2	2	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
3	3	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
4	4	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
5	5	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
6	6	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
7	7	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
8	8	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
9	9	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
10	10	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
11	11	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
12	12	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
13	13	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
14	14	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
15	15	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
16	16	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
17	17	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
18	18	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
19	19	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
20	20	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
21	21	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
22	22	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
23	23	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
24	24	99	2018-01-01 00:00:00	2025-12-31 00:00:00	1
25	25	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
26	26	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
27	27	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
28	28	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
29	29	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
30	30	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
31	31	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
32	32	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
33	33	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
34	34	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
35	35	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
36	36	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
37	37	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
38	38	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
39	39	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
40	40	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
41	41	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
42	42	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
43	43	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
44	44	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
45	45	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
46	46	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
47	47	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
48	48	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
49	49	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
50	50	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
51	51	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
52	52	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
53	53	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
54	54	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
55	55	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
56	56	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
57	57	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
58	58	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
59	59	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
60	60	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
61	61	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
62	62	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
63	63	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
64	64	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
65	65	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
66	66	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
67	67	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
68	68	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
69	69	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
70	70	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
71	71	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
72	72	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
73	73	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
74	74	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
75	75	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
76	76	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
77	77	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
78	78	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
79	79	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
80	80	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
81	81	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
82	82	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
83	83	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
84	84	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
85	85	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
86	86	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
87	87	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
88	88	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
89	89	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
90	90	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
91	91	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
92	92	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
93	93	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
94	94	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
95	95	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
96	96	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
97	97	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
98	98	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
99	99	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
100	100	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
101	101	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
102	102	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
103	103	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
104	104	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
105	105	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
106	106	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
107	107	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
108	108	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
109	109	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
110	110	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
111	111	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
112	112	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
113	113	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
114	114	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
115	115	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
116	116	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
117	117	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
118	118	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
119	119	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
120	120	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
121	121	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
122	122	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
123	123	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
124	124	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
125	125	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
126	126	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
127	127	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
128	128	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
129	129	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
130	130	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
131	131	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
132	132	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
133	133	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
134	134	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
135	135	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
136	136	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
137	137	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
138	138	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
139	139	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
140	140	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
141	141	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
142	142	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
143	143	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
144	144	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
145	145	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
146	146	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
147	147	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
148	148	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
149	149	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
150	150	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
151	151	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
152	152	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
153	153	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
154	154	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
155	155	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
156	156	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
157	157	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
158	158	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
159	159	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
160	160	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
161	161	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
162	162	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
163	163	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
164	164	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
165	165	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
166	166	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
167	167	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
168	168	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
169	169	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
170	170	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
171	171	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
172	172	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
173	173	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
174	174	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
175	175	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
176	176	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
177	177	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
178	178	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
179	179	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
180	180	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
181	181	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
182	182	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
183	183	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
184	184	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
185	185	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
186	186	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
187	187	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
188	188	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
189	189	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
190	190	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
191	191	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
192	192	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
193	193	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
194	194	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
195	195	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
196	196	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
197	197	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
198	198	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
199	199	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
200	200	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
201	201	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
202	202	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
203	203	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
204	204	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
205	205	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
206	206	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
207	207	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
208	208	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
209	209	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
210	210	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
211	211	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
212	212	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
213	213	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
214	214	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
215	215	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
216	216	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
217	217	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
218	218	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
219	219	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
220	220	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
221	221	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
222	222	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
223	223	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
224	224	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
225	225	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
226	226	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
227	227	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
228	228	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
229	229	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
230	230	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
231	231	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
232	232	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
233	233	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
234	234	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
235	235	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
236	236	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
237	237	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
238	238	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
239	239	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
240	240	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
241	241	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
242	242	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
243	243	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
244	244	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
245	245	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
246	246	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
247	247	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
248	248	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
249	249	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
250	250	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
251	251	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
252	252	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
253	253	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
254	254	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
255	255	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
256	256	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
257	257	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
258	258	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
259	259	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
260	260	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
261	261	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
262	262	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
263	263	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
264	264	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
265	265	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
266	266	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
267	267	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
268	268	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
269	269	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
270	270	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
271	271	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
272	272	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
273	273	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
274	274	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
275	275	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
276	276	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
277	277	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
278	278	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
279	279	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
280	280	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
281	281	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
282	282	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
283	283	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
284	284	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
285	285	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
286	286	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
287	287	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
288	288	96	2018-01-01 00:00:00	2025-12-31 00:00:00	1
289	289	97	2018-01-01 00:00:00	2025-12-31 00:00:00	1
290	290	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
291	291	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
292	292	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
293	293	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
294	294	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
295	295	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
296	296	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
297	297	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
298	298	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
299	299	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
300	300	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
301	301	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
302	302	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
303	303	98	2018-01-01 00:00:00	2025-12-31 00:00:00	1
\.


--
-- TOC entry 3117 (class 0 OID 16982)
-- Dependencies: 208
-- Data for Name: fact_rep_general; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fact_rep_general (sk_persona, sk_diagnostico, sk_saturacion, sk_fecha, pico_anterior, variable_objetivo, tasa_tal, buques, pendiente) FROM stdin;
1	1	1	20180412	2	1	1	0	0
2	2	2	20180413	4	1	2	0	0
3	3	3	20180414	1	1	2	0	2
4	4	4	20180415	1	1	2	0	2
5	5	5	20180416	1	1	2	0	2
6	6	6	20180417	0	1	1	0	1
7	7	7	20180418	1	1	2	0	1
8	8	8	20180419	0	1	3	0	2
9	9	9	20180420	0	1	3	0	2
10	10	10	20180421	2	1	2	0	2
11	11	11	20180422	1	1	2	0	2
12	12	12	20180423	0	1	2	0	2
13	13	13	20180424	1	1	2	0	2
14	14	14	20180425	2	1	2	0	1
15	15	15	20180426	1	1	2	0	2
16	16	16	20180427	2	1	2	0	1
17	17	17	20180428	0	1	2	0	2
18	18	18	20180429	3	1	2	0	0
19	19	19	20180430	2	1	2	0	2
20	20	20	20180501	2	1	2	2	2
21	21	21	20180502	0	1	3	0	1
22	22	22	20180503	0	1	2	0	2
23	23	23	20180504	0	1	2	0	2
24	24	24	20180505	1	1	2	0	1
25	25	25	20180506	1	1	3	0	2
26	26	26	20180507	0	1	2	2	2
27	27	27	20180508	2	1	2	0	2
28	28	28	20180509	1	1	2	0	2
29	29	29	20180510	1	1	2	1	2
30	30	30	20180511	1	1	2	0	0
31	31	31	20180512	0	1	2	1	2
32	32	32	20180513	0	1	3	0	2
33	33	33	20180514	0	1	2	0	2
34	34	34	20180515	0	1	2	1	0
35	35	35	20180516	1	1	2	1	2
36	36	36	20180517	1	1	2	0	0
37	37	37	20180518	0	1	2	0	2
38	38	38	20180519	2	1	3	0	2
39	39	39	20180520	1	1	2	0	2
40	40	40	20180521	1	1	2	0	2
41	41	41	20180522	2	1	2	1	2
42	42	42	20180523	0	1	2	0	1
43	43	43	20180524	3	1	2	0	1
44	44	44	20180525	0	1	2	0	1
45	45	45	20180526	0	1	2	0	2
46	46	46	20180527	0	1	2	0	2
47	47	47	20180528	0	1	2	0	2
48	48	48	20180529	0	1	2	0	2
49	49	49	20180530	0	1	0	0	2
50	50	50	20180531	0	1	2	0	2
51	51	51	20180601	0	1	2	0	2
52	52	52	20180602	0	1	2	0	1
53	53	53	20180603	2	1	3	3	1
54	54	54	20180604	1	1	2	0	1
55	55	55	20180605	0	1	2	0	2
56	56	56	20180606	1	1	2	1	2
57	57	57	20180607	0	1	2	0	2
58	58	58	20180608	0	1	2	0	2
59	59	59	20180609	0	1	2	0	2
60	60	60	20180610	0	1	2	1	2
61	61	61	20180611	0	1	2	1	2
62	62	62	20180612	0	1	3	0	2
63	63	63	20180613	0	1	1	0	1
64	64	64	20180614	0	1	1	0	1
65	65	65	20180615	0	1	2	0	2
66	66	66	20180616	1	1	2	0	2
67	67	67	20180617	1	1	2	0	1
68	68	68	20180618	1	1	2	0	1
69	69	69	20180619	0	1	2	0	2
70	70	70	20180620	0	1	2	0	2
71	71	71	20180621	0	1	3	0	1
72	72	72	20180622	0	1	3	1	2
73	73	73	20180623	0	1	2	0	2
74	74	74	20180624	0	1	2	0	2
75	75	75	20180625	0	1	2	0	1
76	76	76	20180626	1	1	2	0	1
77	77	77	20180627	2	1	2	0	1
78	78	78	20180628	0	1	2	0	2
79	79	79	20180629	0	1	2	0	2
80	80	80	20180630	1	1	3	0	1
81	81	81	20180701	0	1	2	0	2
82	82	82	20180702	0	1	2	0	2
83	83	83	20180703	0	1	2	1	2
84	84	84	20180704	1	1	3	0	1
85	85	85	20180705	1	1	2	0	1
86	86	86	20180706	2	1	3	0	1
87	87	87	20180707	1	1	3	1	2
88	88	88	20180708	0	1	3	0	2
89	89	89	20180709	2	1	2	0	1
90	90	90	20180710	1	1	2	0	1
91	91	91	20180711	0	1	2	2	2
92	92	92	20180712	0	1	3	0	2
93	93	93	20180713	0	1	2	4	2
94	94	94	20180714	0	1	2	1	2
95	95	95	20180715	0	1	2	0	1
96	96	96	20180716	0	1	3	0	2
97	97	97	20180717	1	1	2	0	1
98	98	98	20180718	0	1	3	3	2
99	99	99	20180719	2	1	2	1	2
100	100	100	20180720	0	1	2	3	2
101	101	101	20180721	1	1	2	2	2
102	102	102	20180722	4	1	3	0	0
103	103	103	20180723	0	1	2	2	2
104	104	104	20180724	1	1	3	0	0
105	105	105	20180725	0	1	2	0	2
106	106	106	20180726	2	1	2	0	1
107	107	107	20180727	0	1	2	1	1
108	108	108	20180728	0	1	2	0	1
109	109	109	20180729	1	1	2	0	2
110	110	110	20180730	0	1	2	0	2
111	111	111	20180731	0	1	2	0	2
112	112	112	20180801	0	1	3	1	2
113	113	113	20180802	0	1	3	0	2
114	114	114	20180803	0	1	3	0	2
115	115	115	20180804	0	1	2	0	2
116	116	116	20180805	0	1	2	0	2
117	117	117	20180806	2	1	2	0	1
118	118	118	20180807	2	1	3	0	1
119	119	119	20180808	0	1	2	0	2
120	120	120	20180809	0	1	2	0	1
121	121	121	20180810	2	1	2	2	1
122	122	122	20180811	0	1	2	0	2
123	123	123	20180812	0	1	2	0	2
124	124	124	20180813	0	1	2	0	2
125	125	125	20180814	0	1	2	0	2
126	126	126	20180815	1	1	2	0	2
127	127	127	20180816	0	1	2	0	2
128	128	128	20180817	0	1	2	1	2
129	129	129	20180818	0	1	2	0	1
130	130	130	20180819	0	1	2	1	2
131	131	131	20180820	0	1	2	1	2
132	132	132	20180821	0	1	2	0	1
133	133	133	20180822	0	1	2	0	2
134	134	134	20180823	0	1	2	0	2
135	135	135	20180824	0	1	2	0	2
136	136	136	20180825	0	1	2	0	2
137	137	137	20180826	0	1	2	0	2
138	138	138	20180827	0	1	2	0	2
139	139	139	20180828	2	1	1	0	1
140	140	140	20180829	0	1	3	1	1
141	141	141	20180830	1	1	2	0	2
142	142	142	20180831	1	1	2	0	1
143	143	143	20180901	0	1	2	0	1
144	144	144	20180902	0	1	2	2	2
145	145	145	20180903	1	1	2	0	1
146	146	146	20180904	0	1	2	0	2
147	147	147	20180905	0	1	2	1	1
148	148	148	20180906	1	1	2	0	2
149	149	149	20180907	0	1	2	0	2
150	150	150	20180908	0	1	2	0	2
151	151	151	20180909	2	1	1	0	2
152	152	152	20180910	2	1	2	0	1
153	153	153	20180911	1	1	3	0	1
154	154	154	20180912	0	1	2	1	1
155	155	155	20180913	0	1	2	0	1
156	156	156	20180914	1	1	2	0	1
157	157	157	20180915	0	1	2	0	2
158	158	158	20180916	0	1	2	0	2
159	159	159	20180917	0	1	3	4	1
160	160	160	20180918	0	1	3	0	2
161	161	161	20180919	0	1	2	0	0
162	162	162	20180920	1	1	2	0	2
163	163	163	20180921	0	1	2	0	2
164	164	164	20180922	0	1	2	4	2
165	165	165	20180923	0	1	2	4	2
166	166	166	20180924	2	0	2	3	1
167	167	167	20180925	3	0	3	2	1
168	168	168	20180926	4	0	2	2	0
169	169	169	20180927	1	0	3	1	1
170	170	170	20180928	3	0	3	0	0
171	171	171	20180929	1	0	1	1	1
172	172	172	20180930	1	0	3	0	0
173	173	173	20181001	2	0	2	0	1
174	174	174	20181002	3	0	3	2	2
175	175	175	20181003	2	0	3	2	1
176	176	176	20181004	2	0	3	0	1
177	177	177	20181005	1	0	3	2	2
178	178	178	20181006	0	0	2	0	2
179	179	179	20181007	2	0	3	0	1
180	180	180	20181008	1	0	1	1	1
181	181	181	20181009	1	0	3	1	1
182	182	182	20181010	1	0	3	3	1
183	183	183	20181011	0	0	2	0	2
184	184	184	20181012	2	0	3	1	1
185	185	185	20181013	3	0	3	0	1
186	186	186	20181014	0	0	2	1	2
187	187	187	20181015	1	0	3	1	2
188	188	188	20181016	2	0	3	1	1
189	189	189	20181017	1	0	3	1	1
190	190	190	20181018	0	0	3	0	2
191	191	191	20181019	1	0	3	0	1
192	192	192	20181020	2	0	3	3	1
193	193	193	20181021	1	0	3	1	1
194	194	194	20181022	3	0	3	2	1
195	195	195	20181023	3	0	2	0	1
196	196	196	20181024	3	0	3	0	0
197	197	197	20181025	4	0	2	0	1
198	198	198	20181026	0	0	3	2	1
199	199	199	20181027	2	0	3	2	1
200	200	200	20181028	1	0	1	2	2
201	201	201	20181029	0	0	2	1	2
202	202	202	20181030	3	0	3	1	1
203	203	203	20181031	1	0	3	0	2
204	204	204	20181101	2	0	3	0	1
205	205	205	20181102	6	0	3	3	0
206	206	206	20181103	0	0	3	1	2
207	207	207	20181104	1	0	3	1	1
208	208	208	20181105	3	0	3	2	1
209	209	209	20181106	2	0	3	3	1
210	210	210	20181107	0	0	3	1	2
211	211	211	20181108	0	0	3	1	1
212	212	212	20181109	4	0	3	1	1
213	213	213	20181110	1	0	3	0	1
214	214	214	20181111	1	0	3	0	1
215	215	215	20181112	1	0	2	1	1
216	216	216	20181113	3	0	3	0	1
217	217	217	20181114	1	0	3	1	1
218	218	218	20181115	2	0	3	3	2
219	219	219	20181116	3	0	3	1	1
220	220	220	20181117	0	0	3	2	2
221	221	221	20181118	4	0	3	3	1
222	222	222	20181119	6	0	3	0	0
223	223	223	20181120	1	0	2	1	1
224	224	224	20181121	4	0	3	2	0
225	225	225	20181122	3	0	3	1	1
226	226	226	20181123	3	0	3	0	0
227	227	227	20181124	1	0	3	1	1
228	228	228	20181125	2	0	3	0	1
229	229	229	20181126	0	0	3	0	1
230	230	230	20181127	2	0	3	0	1
231	231	231	20181128	0	0	2	0	2
232	232	232	20181129	1	0	3	3	1
233	233	233	20181130	1	0	3	1	1
234	234	234	20181201	2	0	2	1	0
235	235	235	20181202	2	0	2	3	1
236	236	236	20181203	2	0	3	0	2
237	237	237	20181204	0	0	3	2	2
238	238	238	20181205	1	0	3	2	1
239	239	239	20181206	0	0	2	3	2
240	240	240	20181207	0	0	3	0	2
241	241	241	20181208	3	0	3	1	1
242	242	242	20181209	0	0	2	0	1
243	243	243	20181210	2	0	1	2	1
244	244	244	20181211	1	0	3	1	1
245	245	245	20181212	2	0	1	1	1
246	246	246	20181213	0	0	3	0	1
247	247	247	20181214	2	0	3	2	1
248	248	248	20181215	0	0	1	3	1
249	249	249	20181216	0	0	3	1	2
250	250	250	20181217	2	0	3	3	1
251	251	251	20181218	4	0	3	3	1
252	252	252	20181219	0	0	3	4	1
253	253	253	20181220	2	0	2	3	1
254	254	254	20181221	1	0	2	2	1
255	255	255	20181222	0	0	2	0	2
256	256	256	20181223	0	0	3	3	1
257	257	257	20181224	3	0	3	2	1
258	258	258	20181225	1	0	3	0	1
259	259	259	20181226	1	0	2	0	1
260	260	260	20181227	4	0	3	0	1
261	261	261	20181228	1	0	3	2	1
262	262	262	20181229	0	0	2	1	2
263	263	263	20181230	2	0	3	2	1
264	264	264	20181231	2	0	2	2	1
265	265	265	20190101	0	0	2	1	1
266	266	266	20190102	0	0	2	1	2
267	267	267	20190103	3	0	2	0	1
268	268	268	20190104	1	0	2	3	2
269	269	269	20190105	3	0	2	2	1
270	270	270	20190106	2	0	3	0	0
271	271	271	20190107	1	0	3	0	2
272	272	272	20190108	3	0	2	2	1
273	273	273	20190109	1	0	2	0	1
274	274	274	20190110	0	0	3	1	2
275	275	275	20190111	1	0	2	1	1
276	276	276	20190112	1	0	3	2	2
277	277	277	20190113	2	0	3	1	1
278	278	278	20190114	0	0	3	0	2
279	279	279	20190115	0	0	2	2	2
280	280	280	20190116	4	0	2	1	1
281	281	281	20190117	2	0	1	0	1
282	282	282	20190118	1	0	0	0	1
283	283	283	20190119	2	0	1	1	1
284	284	284	20190120	0	0	3	0	2
285	285	285	20190121	2	0	3	1	2
286	286	286	20190122	2	0	3	2	1
287	287	287	20190123	1	0	2	2	2
288	288	288	20190124	0	0	2	1	2
289	289	289	20190125	3	0	3	1	1
290	290	290	20190126	2	0	3	1	1
291	291	291	20190127	0	0	3	1	2
292	292	292	20190128	4	0	1	3	0
293	293	293	20190129	3	0	1	2	1
294	294	294	20190130	1	0	3	0	1
295	295	295	20190131	3	0	1	0	0
296	296	296	20190201	4	0	3	2	2
297	297	297	20190202	0	0	2	0	1
298	298	298	20190203	1	0	1	2	1
299	299	299	20190204	0	0	3	0	1
300	300	300	20190205	1	0	3	0	1
301	301	301	20190206	3	0	3	2	1
302	302	302	20190207	1	0	3	1	1
303	303	303	20190208	0	0	2	1	1
\.


--
-- TOC entry 3118 (class 0 OID 16985)
-- Dependencies: 209
-- Data for Name: tb_auto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_auto (id_auto, id_per, placa_auto, anio_auto) FROM stdin;
1	1	PQW-4152	2019
\.


--
-- TOC entry 3120 (class 0 OID 16993)
-- Dependencies: 211
-- Data for Name: tb_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_menu (id_men, nombre_men, tipo_men, submenu_men, id_rol) FROM stdin;
1	Reportes	M	\N	1
2	Consulta1	S	1	1
3	Consulta2	S	1	1
4	Cambiar Clave	M	\N	1
\.


--
-- TOC entry 3122 (class 0 OID 17001)
-- Dependencies: 213
-- Data for Name: tb_persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_persona (id_perf, nombre_per, ciudad_per, edad_per, estadocivil_per) FROM stdin;
1	Ana Perez	Quito	33	soltera
2	Luis Jimenez	Guayaquil	29	casado
3	Jose	Ibarra	23	soltero
\.


--
-- TOC entry 3124 (class 0 OID 17009)
-- Dependencies: 215
-- Data for Name: tb_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_rol (id_rol, descripcion_rol) FROM stdin;
1	administrador
2	registrado
\.


--
-- TOC entry 3126 (class 0 OID 17017)
-- Dependencies: 217
-- Data for Name: tb_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_usuario (id_per, nombre_per, ciudad_per, edad_per, estadocivil_per, correo_per, clave_per) FROM stdin;
3	Damian	Quito	23	Casado	damian@gmail.com	123
4	Daniel	Quito	34	Casado	daniel@gmail.com	123
5	Anthony	Quito	23	Viudo	ant@gmail.com	123
1	Alison Perez	Quito	21	Soltero	aperez@gmail.com	1234
2	Laura Jimenez	Ibarra	26	Soltero	ljimenez@hotmail.com	1234
6	Anderson	Quito	18	Casado	anderson@gmail.com	1234567j
7	Gustavo	Quito	59	Casado	gnavas@ups.edu.ec	gnavas123
\.


--
-- TOC entry 3128 (class 0 OID 17025)
-- Dependencies: 219
-- Data for Name: tb_usuariolog; Type: TABLE DATA; Schema: public; Owner: pg_write_server_files
--

COPY public.tb_usuariolog (id_us, correo_us, clave_us, estado_us, id_per, id_rol) FROM stdin;
2	ljimenez@hotmail.com	ljimenez	f	2	2
1	aperez@gmail.com	aperezito	t	1	1
4	daniel@gmail.com	daniel	f	4	2
5	ant@gmail.com	123	t	5	2
6	anderson@gmail.com	anderson123	t	6	2
3	damian@gmail.com	damian123	t	3	2
7	gnavas@ups.edu.ec	nuevacontra	f	7	2
\.


--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 202
-- Name: tb_auditoria_id_aud_seq; Type: SEQUENCE SET; Schema: auditoria; Owner: postgres
--

SELECT pg_catalog.setval('auditoria.tb_auditoria_id_aud_seq', 138, true);


--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 210
-- Name: tb_auto_id_auto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_auto_id_auto_seq', 14, true);


--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 212
-- Name: tb_menu_id_men_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_menu_id_men_seq', 1, false);


--
-- TOC entry 3145 (class 0 OID 0)
-- Dependencies: 214
-- Name: tb_persona_id_perf_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_persona_id_perf_seq', 1, false);


--
-- TOC entry 3146 (class 0 OID 0)
-- Dependencies: 216
-- Name: tb_rol_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_rol_id_rol_seq', 1, false);


--
-- TOC entry 3147 (class 0 OID 0)
-- Dependencies: 218
-- Name: tb_usuario_id_per_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_usuario_id_per_seq', 7, true);


--
-- TOC entry 3148 (class 0 OID 0)
-- Dependencies: 220
-- Name: tb_usuariolog_id_us_seq; Type: SEQUENCE SET; Schema: public; Owner: pg_write_server_files
--

SELECT pg_catalog.setval('public.tb_usuariolog_id_us_seq', 7, true);


--
-- TOC entry 2927 (class 2606 OID 17041)
-- Name: tb_auditoria pk_tb_auditoria; Type: CONSTRAINT; Schema: auditoria; Owner: postgres
--

ALTER TABLE ONLY auditoria.tb_auditoria
    ADD CONSTRAINT pk_tb_auditoria PRIMARY KEY (id_aud);


--
-- TOC entry 2939 (class 2606 OID 17043)
-- Name: dim_report dim_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_report
    ADD CONSTRAINT dim_report_pkey PRIMARY KEY (pk_report);


--
-- TOC entry 2947 (class 2606 OID 17045)
-- Name: tb_auto id_auto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_auto
    ADD CONSTRAINT id_auto PRIMARY KEY (id_auto);


--
-- TOC entry 2949 (class 2606 OID 17047)
-- Name: tb_menu id_men; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_menu
    ADD CONSTRAINT id_men PRIMARY KEY (id_men);


--
-- TOC entry 2955 (class 2606 OID 17049)
-- Name: tb_usuario id_per; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario
    ADD CONSTRAINT id_per PRIMARY KEY (id_per);


--
-- TOC entry 2951 (class 2606 OID 17051)
-- Name: tb_persona id_perf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_persona
    ADD CONSTRAINT id_perf PRIMARY KEY (id_perf);


--
-- TOC entry 2953 (class 2606 OID 17053)
-- Name: tb_rol id_rol; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_rol
    ADD CONSTRAINT id_rol PRIMARY KEY (id_rol);


--
-- TOC entry 2958 (class 2606 OID 17055)
-- Name: tb_usuariolog id_us; Type: CONSTRAINT; Schema: public; Owner: pg_write_server_files
--

ALTER TABLE ONLY public.tb_usuariolog
    ADD CONSTRAINT id_us PRIMARY KEY (id_us);


--
-- TOC entry 2931 (class 2606 OID 17057)
-- Name: dim_diagnostico pk_dim_diagnostico; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_diagnostico
    ADD CONSTRAINT pk_dim_diagnostico PRIMARY KEY (sk_diagnostico);


--
-- TOC entry 2934 (class 2606 OID 17059)
-- Name: dim_fecha pk_dim_fecha; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_fecha
    ADD CONSTRAINT pk_dim_fecha PRIMARY KEY (sk_fecha);


--
-- TOC entry 2937 (class 2606 OID 17061)
-- Name: dim_persona pk_dim_persona; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_persona
    ADD CONSTRAINT pk_dim_persona PRIMARY KEY (sk_persona);


--
-- TOC entry 2942 (class 2606 OID 17063)
-- Name: dim_saturacion pk_dim_saturacion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_saturacion
    ADD CONSTRAINT pk_dim_saturacion PRIMARY KEY (sk_saturacion);


--
-- TOC entry 2945 (class 2606 OID 17065)
-- Name: fact_rep_general pk_fact_rep_general; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_rep_general
    ADD CONSTRAINT pk_fact_rep_general PRIMARY KEY (sk_persona, sk_saturacion, sk_diagnostico, sk_fecha);


--
-- TOC entry 2928 (class 1259 OID 17066)
-- Name: tb_auditoria_pk; Type: INDEX; Schema: auditoria; Owner: postgres
--

CREATE UNIQUE INDEX tb_auditoria_pk ON auditoria.tb_auditoria USING btree (id_aud);


--
-- TOC entry 2956 (class 1259 OID 17067)
-- Name: fki_id_per; Type: INDEX; Schema: public; Owner: pg_write_server_files
--

CREATE INDEX fki_id_per ON public.tb_usuariolog USING btree (id_per);


--
-- TOC entry 2929 (class 1259 OID 17068)
-- Name: idx_dim_diagnostico_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dim_diagnostico_lookup ON public.dim_diagnostico USING btree (pk_diagnostico);


--
-- TOC entry 2932 (class 1259 OID 17069)
-- Name: idx_dim_fecha_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dim_fecha_lookup ON public.dim_fecha USING btree (sk_fecha);


--
-- TOC entry 2935 (class 1259 OID 17070)
-- Name: idx_dim_persona_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dim_persona_lookup ON public.dim_persona USING btree (pk_persona);


--
-- TOC entry 2940 (class 1259 OID 17071)
-- Name: idx_dim_saturacion_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dim_saturacion_lookup ON public.dim_saturacion USING btree (pk_saturacion);


--
-- TOC entry 2943 (class 1259 OID 17072)
-- Name: idx_fact_rep_general_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fact_rep_general_lookup ON public.fact_rep_general USING btree (sk_persona, sk_diagnostico, sk_saturacion, sk_fecha);


--
-- TOC entry 2967 (class 2620 OID 17073)
-- Name: tb_persona dim_diagnostico_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER dim_diagnostico_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2968 (class 2620 OID 17074)
-- Name: tb_persona dim_fecha_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER dim_fecha_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2969 (class 2620 OID 17075)
-- Name: tb_persona dim_persona_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER dim_persona_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2970 (class 2620 OID 17076)
-- Name: tb_persona dim_saturacion_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER dim_saturacion_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2971 (class 2620 OID 17077)
-- Name: tb_persona fact_rep_general_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fact_rep_general_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2972 (class 2620 OID 17078)
-- Name: tb_persona tb_auto_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_auto_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2973 (class 2620 OID 17079)
-- Name: tb_persona tb_menu_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_menu_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2974 (class 2620 OID 17080)
-- Name: tb_persona tb_persona_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_persona_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2975 (class 2620 OID 17081)
-- Name: tb_persona tb_rol_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_rol_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2976 (class 2620 OID 17082)
-- Name: tb_persona tb_usuario_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_usuario_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2978 (class 2620 OID 17083)
-- Name: tb_usuario tb_usuario_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_usuario_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_usuario FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2977 (class 2620 OID 17084)
-- Name: tb_persona tb_usuariolog_tg_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tb_usuariolog_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_persona FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2979 (class 2620 OID 17085)
-- Name: tb_usuariolog tb_usuariolog_tg_audit; Type: TRIGGER; Schema: public; Owner: pg_write_server_files
--

CREATE TRIGGER tb_usuariolog_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_usuariolog FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();


--
-- TOC entry 2959 (class 2606 OID 17086)
-- Name: fact_rep_general dim_diagnostico_fact_rep_general_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_rep_general
    ADD CONSTRAINT dim_diagnostico_fact_rep_general_fk FOREIGN KEY (sk_diagnostico) REFERENCES public.dim_diagnostico(sk_diagnostico);


--
-- TOC entry 2960 (class 2606 OID 17091)
-- Name: fact_rep_general dim_fecha_fact_rep_general_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_rep_general
    ADD CONSTRAINT dim_fecha_fact_rep_general_fk FOREIGN KEY (sk_fecha) REFERENCES public.dim_fecha(sk_fecha);


--
-- TOC entry 2961 (class 2606 OID 17096)
-- Name: fact_rep_general dim_personas_fact_rep_general_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_rep_general
    ADD CONSTRAINT dim_personas_fact_rep_general_fk FOREIGN KEY (sk_persona) REFERENCES public.dim_persona(sk_persona);


--
-- TOC entry 2962 (class 2606 OID 17101)
-- Name: fact_rep_general dim_saturacion_fact_rep_general_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_rep_general
    ADD CONSTRAINT dim_saturacion_fact_rep_general_fk FOREIGN KEY (sk_saturacion) REFERENCES public.dim_saturacion(sk_saturacion);


--
-- TOC entry 2963 (class 2606 OID 17106)
-- Name: tb_auto id_per; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_auto
    ADD CONSTRAINT id_per FOREIGN KEY (id_per) REFERENCES public.tb_usuario(id_per);


--
-- TOC entry 2965 (class 2606 OID 17111)
-- Name: tb_usuariolog id_per; Type: FK CONSTRAINT; Schema: public; Owner: pg_write_server_files
--

ALTER TABLE ONLY public.tb_usuariolog
    ADD CONSTRAINT id_per FOREIGN KEY (id_per) REFERENCES public.tb_usuario(id_per);


--
-- TOC entry 2966 (class 2606 OID 17116)
-- Name: tb_usuariolog id_rol; Type: FK CONSTRAINT; Schema: public; Owner: pg_write_server_files
--

ALTER TABLE ONLY public.tb_usuariolog
    ADD CONSTRAINT id_rol FOREIGN KEY (id_rol) REFERENCES public.tb_rol(id_rol) NOT VALID;


--
-- TOC entry 2964 (class 2606 OID 17121)
-- Name: tb_menu id_rol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_menu
    ADD CONSTRAINT id_rol FOREIGN KEY (id_rol) REFERENCES public.tb_rol(id_rol) NOT VALID;


-- Completed on 2021-08-02 12:10:34

--
-- PostgreSQL database dump complete
--

