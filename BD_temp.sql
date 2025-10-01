PGDMP  #                    }            GeneSoft    18.0    18.0 [               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16388    GeneSoft    DATABASE        CREATE DATABASE "GeneSoft" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Bolivia.1252';
    DROP DATABASE "GeneSoft";
                     postgres    false            î            1255    16579 !   actualizar_calificacion_intento()    FUNCTION     g  CREATE FUNCTION public.actualizar_calificacion_intento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calcular el color automÃ¡ticamente si el intento estÃ¡ completado
    IF NEW.completado = TRUE THEN
        NEW.calificacion_color := calcular_calificacion_color(NEW.puntos_obtenidos, NEW.puntos_totales);
    END IF;
    RETURN NEW;
END;
$$;
 8   DROP FUNCTION public.actualizar_calificacion_intento();
       public               postgres    false            í            1255    16578 -   calcular_calificacion_color(integer, integer)    FUNCTION     	  CREATE FUNCTION public.calcular_calificacion_color(puntos_obtenidos integer, puntos_totales integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    porcentaje DECIMAL(5,2);
BEGIN
    IF puntos_totales = 0 THEN
        RETURN 'rojo';
    END IF;
    
    porcentaje := (puntos_obtenidos::DECIMAL / puntos_totales::DECIMAL) * 100;
    
    IF porcentaje >= 80 THEN
        RETURN 'verde';
    ELSIF porcentaje >= 50 THEN
        RETURN 'amarillo';
    ELSE
        RETURN 'rojo';
    END IF;
END;
$$;
 d   DROP FUNCTION public.calcular_calificacion_color(puntos_obtenidos integer, puntos_totales integer);
       public               postgres    false            æ            1259    16497    intentos_practica    TABLE     †  CREATE TABLE public.intentos_practica (
    id integer NOT NULL,
    estudiante_id integer NOT NULL,
    practica_id integer NOT NULL,
    fecha_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion timestamp without time zone,
    calificacion_color character varying(20),
    puntos_obtenidos integer,
    puntos_totales integer,
    tiempo_empleado_minutos integer,
    completado boolean DEFAULT false,
    CONSTRAINT intentos_practica_calificacion_color_check CHECK (((calificacion_color)::text = ANY ((ARRAY['rojo'::character varying, 'amarillo'::character varying, 'verde'::character varying])::text[])))
);
 %   DROP TABLE public.intentos_practica;
       public         heap r       postgres    false            à            1259    16436 	   practicas    TABLE     H  CREATE TABLE public.practicas (
    id integer NOT NULL,
    topico_id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text,
    orden_en_topico integer,
    codigo_inicial text,
    solucion_esperada text,
    nivel_dificultad character varying(20),
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true,
    CONSTRAINT practicas_nivel_dificultad_check CHECK (((nivel_dificultad)::text = ANY ((ARRAY['facil'::character varying, 'medio'::character varying, 'dificil'::character varying])::text[])))
);
    DROP TABLE public.practicas;
       public         heap r       postgres    false            Þ            1259    16415     topicos    TABLE       CREATE TABLE public.topicos (
    id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text,
    duracion_estimada_minutos integer,
    nivel character varying(20),
    orden_visualizacion integer,
    docente_id integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true,
    CONSTRAINT topicos_nivel_check CHECK (((nivel)::text = ANY ((ARRAY['principiante'::character varying, 'intermedio'::character varying, 'avanzado'::character varying])::text[])))
);
    DROP TABLE public.topicos;
       public         heap r       postgres    false            Ü            1259    16391    usuarios    TABLE     I  CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre_completo character varying(200) NOT NULL,
    nombre_usuario character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    contrasena_hash character varying(255) NOT NULL,
    rol character varying(20) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true,
    CONSTRAINT usuarios_rol_check CHECK (((rol)::text = ANY ((ARRAY['estudiante'::character varying, 'docente'::character varying, 'administrador'::character varying])::text[])))
);
    DROP TABLE public.usuarios;
       public         heap r       postgres    false            ë            1259    16581    historial_calificaciones    VIEW     ½  CREATE VIEW public.historial_calificaciones AS
 SELECT u.nombre_completo AS estudiante,
    u.nombre_usuario,
    t.titulo AS topico,
    p.titulo AS practica,
    ip.fecha_inicio,
    ip.fecha_finalizacion,
    ip.calificacion_color,
    ip.puntos_obtenidos,
    ip.puntos_totales,
    round((((ip.puntos_obtenidos)::numeric / (NULLIF(ip.puntos_totales, 0))::numeric) * (100)::numeric), 2) AS porcentaje,
    ip.tiempo_empleado_minutos,
    ip.completado
   FROM (((public.intentos_practica ip
     JOIN public.usuarios u ON ((ip.estudiante_id = u.id)))
     JOIN public.practicas p ON ((ip.practica_id = p.id)))
     JOIN public.topicos t ON ((p.topico_id = t.id)))
  ORDER BY ip.fecha_inicio DESC;
 +   DROP VIEW public.historial_calificaciones;
       public       v       postgres    false    230    230    230    230    230    230    230    230    230    224    224    220    224    222    222    220    220            å            1259    16496    intentos_practica_id_seq    SEQUENCE        CREATE SEQUENCE public.intentos_practica_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.intentos_practica_id_seq;
       public               postgres    false    230                       0    0    intentos_practica_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.intentos_practica_id_seq OWNED BY public.intentos_practica.id;
          public               postgres    false    229            ä            1259    16478    opciones_respuesta    TABLE     Ç   CREATE TABLE public.opciones_respuesta (
    id integer NOT NULL,
    pregunta_id integer NOT NULL,
    texto_opcion text NOT NULL,
    es_correcta boolean DEFAULT false,
    orden_opcion integer
);
 &   DROP TABLE public.opciones_respuesta;
       public         heap r       postgres    false            ã            1259    16477    opciones_respuesta_id_seq    SEQUENCE     ‘   CREATE SEQUENCE public.opciones_respuesta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.opciones_respuesta_id_seq;
       public               postgres    false    228                       0    0    opciones_respuesta_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.opciones_respuesta_id_seq OWNED BY public.opciones_respuesta.id;
          public               postgres    false    227            ß            1259    16435    practicas_id_seq    SEQUENCE     ˆ   CREATE SEQUENCE public.practicas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.practicas_id_seq;
       public               postgres    false    224                       0    0    practicas_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.practicas_id_seq OWNED BY public.practicas.id;
          public               postgres    false    223            â            1259    16457 	   preguntas    TABLE     3  CREATE TABLE public.preguntas (
    id integer NOT NULL,
    practica_id integer NOT NULL,
    descripcion text NOT NULL,
    tipo_pregunta character varying(30),
    orden_en_practica integer,
    puntos integer DEFAULT 1,
    codigo_prueba text,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT preguntas_tipo_pregunta_check CHECK (((tipo_pregunta)::text = ANY ((ARRAY['multiple_choice'::character varying, 'codigo'::character varying, 'verdadero_falso'::character varying, 'completar'::character varying])::text[])))
);
    DROP TABLE public.preguntas;
       public         heap r       postgres    false            á            1259    16456    preguntas_id_seq    SEQUENCE     ˆ   CREATE SEQUENCE public.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.preguntas_id_seq;
       public               postgres    false    226                       0    0    preguntas_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.preguntas_id_seq OWNED BY public.preguntas.id;
          public               postgres    false    225            ê            1259    16553    progreso_topicos    TABLE     0  CREATE TABLE public.progreso_topicos (
    id integer NOT NULL,
    estudiante_id integer NOT NULL,
    topico_id integer NOT NULL,
    fecha_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_completado timestamp without time zone,
    porcentaje_completado numeric(5,2) DEFAULT 0.00,
    mejor_calificacion character varying(20),
    CONSTRAINT progreso_topicos_mejor_calificacion_check CHECK (((mejor_calificacion)::text = ANY ((ARRAY['rojo'::character varying, 'amarillo'::character varying, 'verde'::character varying])::text[])))
);
 $   DROP TABLE public.progreso_topicos;
       public         heap r       postgres    false            ì            1259    16586    progreso_estudiantes    VIEW     ÷  CREATE VIEW public.progreso_estudiantes AS
 SELECT u.id AS estudiante_id,
    u.nombre_completo,
    u.nombre_usuario,
    count(DISTINCT pt.topico_id) AS topicos_iniciados,
    count(DISTINCT
        CASE
            WHEN (pt.porcentaje_completado = (100)::numeric) THEN pt.topico_id
            ELSE NULL::integer
        END) AS topicos_completados,
    avg(pt.porcentaje_completado) AS porcentaje_promedio_general,
    count(ip.id) AS total_intentos_practicas,
    count(
        CASE
            WHEN ((ip.calificacion_color)::text = 'verde'::text) THEN 1
            ELSE NULL::integer
        END) AS calificaciones_verdes,
    count(
        CASE
            WHEN ((ip.calificacion_color)::text = 'amarillo'::text) THEN 1
            ELSE NULL::integer
        END) AS calificaciones_amarillas,
    count(
        CASE
            WHEN ((ip.calificacion_color)::text = 'rojo'::text) THEN 1
            ELSE NULL::integer
        END) AS calificaciones_rojas
   FROM ((public.usuarios u
     LEFT JOIN public.progreso_topicos pt ON ((u.id = pt.estudiante_id)))
     LEFT JOIN public.intentos_practica ip ON (((u.id = ip.estudiante_id) AND (ip.completado = true))))
  WHERE ((u.rol)::text = 'estudiante'::text)
  GROUP BY u.id, u.nombre_completo, u.nombre_usuario;
 '   DROP VIEW public.progreso_estudiantes;
       public       v       postgres    false    234    220    230    230    230    230    234    234    220    220    220            é            1259    16552    progreso_topicos_id_seq    SEQUENCE        CREATE SEQUENCE public.progreso_topicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.progreso_topicos_id_seq;
       public               postgres    false    234                       0    0    progreso_topicos_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.progreso_topicos_id_seq OWNED BY public.progreso_topicos.id;
          public               postgres    false    233            è            1259    16523    respuestas_estudiante    TABLE     v  CREATE TABLE public.respuestas_estudiante (
    id integer NOT NULL,
    intento_practica_id integer NOT NULL,
    pregunta_id integer NOT NULL,
    respuesta_texto text,
    opcion_seleccionada_id integer,
    codigo_enviado text,
    es_correcta boolean,
    puntos_obtenidos integer DEFAULT 0,
    fecha_respuesta timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 )   DROP TABLE public.respuestas_estudiante;
       public         heap r       postgres    false            ç            1259    16522    respuestas_estudiante_id_seq    SEQUENCE     ”   CREATE SEQUENCE public.respuestas_estudiante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.respuestas_estudiante_id_seq;
       public               postgres    false    232                        0    0    respuestas_estudiante_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.respuestas_estudiante_id_seq OWNED BY public.respuestas_estudiante.id;
          public               postgres    false    231            Ý            1259    16414    topicos_id_seq    SEQUENCE     †   CREATE SEQUENCE public.topicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.topicos_id_seq;
       public               postgres    false    222            !           0    0    topicos_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.topicos_id_seq OWNED BY public.topicos.id;
          public               postgres    false    221            Û            1259    16390    usuarios_id_seq    SEQUENCE     ‡   CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.usuarios_id_seq;
       public               postgres    false    220            "           0    0    usuarios_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;
          public               postgres    false    219            3           2604    16500    intentos_practica id     DEFAULT     |   ALTER TABLE ONLY public.intentos_practica ALTER COLUMN id SET DEFAULT nextval('public.intentos_practica_id_seq'::regclass);
 C   ALTER TABLE public.intentos_practica ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    229    230    230            1           2604    16481    opciones_respuesta id     DEFAULT     ~   ALTER TABLE ONLY public.opciones_respuesta ALTER COLUMN id SET DEFAULT nextval('public.opciones_respuesta_id_seq'::regclass);
 D   ALTER TABLE public.opciones_respuesta ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    228    227    228            +           2604    16439    practicas id     DEFAULT     l   ALTER TABLE ONLY public.practicas ALTER COLUMN id SET DEFAULT nextval('public.practicas_id_seq'::regclass);
 ;   ALTER TABLE public.practicas ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    224    224            .           2604    16460    preguntas id     DEFAULT     l   ALTER TABLE ONLY public.preguntas ALTER COLUMN id SET DEFAULT nextval('public.preguntas_id_seq'::regclass);
 ;   ALTER TABLE public.preguntas ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    226    226            9           2604    16556    progreso_topicos id     DEFAULT     z   ALTER TABLE ONLY public.progreso_topicos ALTER COLUMN id SET DEFAULT nextval('public.progreso_topicos_id_seq'::regclass);
 B   ALTER TABLE public.progreso_topicos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    233    234    234            6           2604    16526    respuestas_estudiante id     DEFAULT     „   ALTER TABLE ONLY public.respuestas_estudiante ALTER COLUMN id SET DEFAULT nextval('public.respuestas_estudiante_id_seq'::regclass);
 G   ALTER TABLE public.respuestas_estudiante ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    232    231    232            (           2604    16418 
   topicos id     DEFAULT     h   ALTER TABLE ONLY public.topicos ALTER COLUMN id SET DEFAULT nextval('public.topicos_id_seq'::regclass);
 9   ALTER TABLE public.topicos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    222    221    222            %           2604    16394 
   usuarios id     DEFAULT     j   ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);
 :   ALTER TABLE public.usuarios ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    220    219    220                      0    16497    intentos_practica 
   TABLE DATA           È   COPY public.intentos_practica (id, estudiante_id, practica_id, fecha_inicio, fecha_finalizacion, calificacion_color, puntos_obtenidos, puntos_totales, tiempo_empleado_minutos, completado) FROM stdin;
    public               postgres    false    230   ˆ                 0    16478    opciones_respuesta 
   TABLE DATA           f   COPY public.opciones_respuesta (id, pregunta_id, texto_opcion, es_correcta, orden_opcion) FROM stdin;
    public               postgres    false    228   Êˆ       
          0    16436 	   practicas 
   TABLE DATA           ¥   COPY public.practicas (id, topico_id, titulo, descripcion, orden_en_topico, codigo_inicial, solucion_esperada, nivel_dificultad, fecha_creacion, activo) FROM stdin;
    public               postgres    false    224   ‰                 0    16457 	   preguntas 
   TABLE DATA           Š   COPY public.preguntas (id, practica_id, descripcion, tipo_pregunta, orden_en_practica, puntos, codigo_prueba, fecha_creacion) FROM stdin;
    public               postgres    false    226   ï‰                 0    16553    progreso_topicos 
   TABLE DATA           “   COPY public.progreso_topicos (id, estudiante_id, topico_id, fecha_inicio, fecha_completado, porcentaje_completado, mejor_calificacion) FROM stdin;
    public               postgres    false    234   ÆŠ                 0    16523    respuestas_estudiante 
   TABLE DATA           ¾   COPY public.respuestas_estudiante (id, intento_practica_id, pregunta_id, respuesta_texto, opcion_seleccionada_id, codigo_enviado, es_correcta, puntos_obtenidos, fecha_respuesta) FROM stdin;
    public               postgres    false    232   ãŠ                 0    16415     topicos 
   TABLE DATA           •   COPY public.topicos (id, titulo, descripcion, duracion_estimada_minutos, nivel, orden_visualizacion, docente_id, fecha_creacion, activo) FROM stdin;
    public               postgres    false    222    ‹                 0    16391    usuarios 
   TABLE DATA           |   COPY public.usuarios (id, nombre_completo, nombre_usuario, email, contrasena_hash, rol, fecha_registro, activo) FROM stdin;
    public               postgres    false    220    Œ       #           0    0    intentos_practica_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.intentos_practica_id_seq', 6, true);
          public               postgres    false    229            $           0    0    opciones_respuesta_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.opciones_respuesta_id_seq', 4, true);
          public               postgres    false    227            %           0    0    practicas_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.practicas_id_seq', 3, true);
          public               postgres    false    223            &           0    0    preguntas_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.preguntas_id_seq', 3, true);
          public               postgres    false    225            '           0    0    progreso_topicos_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.progreso_topicos_id_seq', 1, false);
          public               postgres    false    233            (           0    0    respuestas_estudiante_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.respuestas_estudiante_id_seq', 1, false);
          public               postgres    false    231            )           0    0    topicos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.topicos_id_seq', 3, true);
          public               postgres    false    221            *           0    0    usuarios_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.usuarios_id_seq', 3, true);
          public               postgres    false    219            [           2606    16508 (   intentos_practica intentos_practica_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.intentos_practica
    ADD CONSTRAINT intentos_practica_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.intentos_practica DROP CONSTRAINT intentos_practica_pkey;
       public                 postgres    false    230            V           2606    16489 *   opciones_respuesta opciones_respuesta_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.opciones_respuesta
    ADD CONSTRAINT opciones_respuesta_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.opciones_respuesta DROP CONSTRAINT opciones_respuesta_pkey;
       public                 postgres    false    228            P           2606    16449    practicas practicas_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.practicas
    ADD CONSTRAINT practicas_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.practicas DROP CONSTRAINT practicas_pkey;
       public                 postgres    false    224            S           2606    16470    preguntas preguntas_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.preguntas DROP CONSTRAINT preguntas_pkey;
       public                 postgres    false    226            a           2606    16566 =   progreso_topicos progreso_topicos_estudiante_id_topico_id_key 
   CONSTRAINT     Œ   ALTER TABLE ONLY public.progreso_topicos
    ADD CONSTRAINT progreso_topicos_estudiante_id_topico_id_key UNIQUE (estudiante_id, topico_id);
 g   ALTER TABLE ONLY public.progreso_topicos DROP CONSTRAINT progreso_topicos_estudiante_id_topico_id_key;
       public                 postgres    false    234    234            c           2606    16564 &   progreso_topicos progreso_topicos_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.progreso_topicos
    ADD CONSTRAINT progreso_topicos_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.progreso_topicos DROP CONSTRAINT progreso_topicos_pkey;
       public                 postgres    false    234            ^           2606    16535 0   respuestas_estudiante respuestas_estudiante_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.respuestas_estudiante
    ADD CONSTRAINT respuestas_estudiante_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.respuestas_estudiante DROP CONSTRAINT respuestas_estudiante_pkey;
       public                 postgres    false    232            M           2606    16427    topicos topicos_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.topicos
    ADD CONSTRAINT topicos_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.topicos DROP CONSTRAINT topicos_pkey;
       public                 postgres    false    222            E           2606    16411    usuarios usuarios_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_email_key;
       public                 postgres    false    220            G           2606    16409 $   usuarios usuarios_nombre_usuario_key 
   CONSTRAINT     i   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nombre_usuario_key UNIQUE (nombre_usuario);
 N   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_nombre_usuario_key;
       public                 postgres    false    220            I           2606    16407    usuarios usuarios_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public                 postgres    false    220            W           1259    16519    idx_intentos_estudiante    INDEX     ^   CREATE INDEX idx_intentos_estudiante ON public.intentos_practica USING btree (estudiante_id);
 +   DROP INDEX public.idx_intentos_estudiante;
       public                 postgres    false    230            X           1259    16521    idx_intentos_fecha    INDEX     X   CREATE INDEX idx_intentos_fecha ON public.intentos_practica USING btree (fecha_inicio);
 &   DROP INDEX public.idx_intentos_fecha;
       public                 postgres    false    230            Y           1259    16520    idx_intentos_practica_id    INDEX     ]   CREATE INDEX idx_intentos_practica_id ON public.intentos_practica USING btree (practica_id);
 ,   DROP INDEX public.idx_intentos_practica_id;
       public                 postgres    false    230            T           1259    16495    idx_opciones_pregunta    INDEX     [   CREATE INDEX idx_opciones_pregunta ON public.opciones_respuesta USING btree (pregunta_id);
 )   DROP INDEX public.idx_opciones_pregunta;
       public                 postgres    false    228            N           1259    16455    idx_practicas_topico    INDEX     O   CREATE INDEX idx_practicas_topico ON public.practicas USING btree (topico_id);
 (   DROP INDEX public.idx_practicas_topico;
       public                 postgres    false    224            Q           1259    16476    idx_preguntas_practica    INDEX     S   CREATE INDEX idx_preguntas_practica ON public.preguntas USING btree (practica_id);
 *   DROP INDEX public.idx_preguntas_practica;
       public                 postgres    false    226            _           1259    16577    idx_progreso_estudiante    INDEX     ]   CREATE INDEX idx_progreso_estudiante ON public.progreso_topicos USING btree (estudiante_id);
 +   DROP INDEX public.idx_progreso_estudiante;
       public                 postgres    false    234            \           1259    16551    idx_respuestas_intento    INDEX     g   CREATE INDEX idx_respuestas_intento ON public.respuestas_estudiante USING btree (intento_practica_id);
 *   DROP INDEX public.idx_respuestas_intento;
       public                 postgres    false    232            J           1259    16434    idx_topicos_docente    INDEX     M   CREATE INDEX idx_topicos_docente ON public.topicos USING btree (docente_id);
 '   DROP INDEX public.idx_topicos_docente;
       public                 postgres    false    222            K           1259    16433    idx_topicos_nivel    INDEX     F   CREATE INDEX idx_topicos_nivel ON public.topicos USING btree (nivel);
 %   DROP INDEX public.idx_topicos_nivel;
       public                 postgres    false    222            B           1259    16413    idx_usuarios_nombre_usuario    INDEX     Z   CREATE INDEX idx_usuarios_nombre_usuario ON public.usuarios USING btree (nombre_usuario);
 /   DROP INDEX public.idx_usuarios_nombre_usuario;
       public                 postgres    false    220            C           1259    16412    idx_usuarios_rol    INDEX     D   CREATE INDEX idx_usuarios_rol ON public.usuarios USING btree (rol);
 $   DROP INDEX public.idx_usuarios_rol;
       public                 postgres    false    220            o           2620    16591 1   intentos_practica trigger_actualizar_calificacion     TRIGGER     «   CREATE TRIGGER trigger_actualizar_calificacion BEFORE INSERT OR UPDATE ON public.intentos_practica FOR EACH ROW EXECUTE FUNCTION public.actualizar_calificacion_intento();
 J   DROP TRIGGER trigger_actualizar_calificacion ON public.intentos_practica;
       public               postgres    false    230    238            h           2606    16509 6   intentos_practica intentos_practica_estudiante_id_fkey 
   FK CONSTRAINT     °   ALTER TABLE ONLY public.intentos_practica
    ADD CONSTRAINT intentos_practica_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.intentos_practica DROP CONSTRAINT intentos_practica_estudiante_id_fkey;
       public               postgres    false    230    4937    220            i           2606    16514 4   intentos_practica intentos_practica_practica_id_fkey 
   FK CONSTRAINT     ­   ALTER TABLE ONLY public.intentos_practica
    ADD CONSTRAINT intentos_practica_practica_id_fkey FOREIGN KEY (practica_id) REFERENCES public.practicas(id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.intentos_practica DROP CONSTRAINT intentos_practica_practica_id_fkey;
       public               postgres    false    230    224    4944            g           2606    16490 6   opciones_respuesta opciones_respuesta_pregunta_id_fkey 
   FK CONSTRAINT     ¯   ALTER TABLE ONLY public.opciones_respuesta
    ADD CONSTRAINT opciones_respuesta_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.opciones_respuesta DROP CONSTRAINT opciones_respuesta_pregunta_id_fkey;
       public               postgres    false    4947    228    226            e           2606    16450 "   practicas practicas_topico_id_fkey 
   FK CONSTRAINT     —   ALTER TABLE ONLY public.practicas
    ADD CONSTRAINT practicas_topico_id_fkey FOREIGN KEY (topico_id) REFERENCES public.topicos(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.practicas DROP CONSTRAINT practicas_topico_id_fkey;
       public               postgres    false    224    222    4941            f           2606    16471 $   preguntas preguntas_practica_id_fkey 
   FK CONSTRAINT        ALTER TABLE ONLY public.preguntas
    ADD CONSTRAINT preguntas_practica_id_fkey FOREIGN KEY (practica_id) REFERENCES public.practicas(id) ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.preguntas DROP CONSTRAINT preguntas_practica_id_fkey;
       public               postgres    false    226    4944    224            m           2606    16567 4   progreso_topicos progreso_topicos_estudiante_id_fkey 
   FK CONSTRAINT     ®   ALTER TABLE ONLY public.progreso_topicos
    ADD CONSTRAINT progreso_topicos_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.progreso_topicos DROP CONSTRAINT progreso_topicos_estudiante_id_fkey;
       public               postgres    false    220    4937    234            n           2606    16572 0   progreso_topicos progreso_topicos_topico_id_fkey 
   FK CONSTRAINT     ¥   ALTER TABLE ONLY public.progreso_topicos
    ADD CONSTRAINT progreso_topicos_topico_id_fkey FOREIGN KEY (topico_id) REFERENCES public.topicos(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.progreso_topicos DROP CONSTRAINT progreso_topicos_topico_id_fkey;
       public               postgres    false    4941    234    222            j           2606    16536 D   respuestas_estudiante respuestas_estudiante_intento_practica_id_fkey 
   FK CONSTRAINT     Í   ALTER TABLE ONLY public.respuestas_estudiante
    ADD CONSTRAINT respuestas_estudiante_intento_practica_id_fkey FOREIGN KEY (intento_practica_id) REFERENCES public.intentos_practica(id) ON DELETE CASCADE;
 n   ALTER TABLE ONLY public.respuestas_estudiante DROP CONSTRAINT respuestas_estudiante_intento_practica_id_fkey;
       public               postgres    false    4955    230    232            k           2606    16546 G   respuestas_estudiante respuestas_estudiante_opcion_seleccionada_id_fkey 
   FK CONSTRAINT     Õ   ALTER TABLE ONLY public.respuestas_estudiante
    ADD CONSTRAINT respuestas_estudiante_opcion_seleccionada_id_fkey FOREIGN KEY (opcion_seleccionada_id) REFERENCES public.opciones_respuesta(id) ON DELETE SET NULL;
 q   ALTER TABLE ONLY public.respuestas_estudiante DROP CONSTRAINT respuestas_estudiante_opcion_seleccionada_id_fkey;
       public               postgres    false    228    4950    232            l           2606    16541 <   respuestas_estudiante respuestas_estudiante_pregunta_id_fkey 
   FK CONSTRAINT     µ   ALTER TABLE ONLY public.respuestas_estudiante
    ADD CONSTRAINT respuestas_estudiante_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON DELETE CASCADE;
 f   ALTER TABLE ONLY public.respuestas_estudiante DROP CONSTRAINT respuestas_estudiante_pregunta_id_fkey;
       public               postgres    false    232    226    4947            d           2606    16428    topicos topicos_docente_id_fkey 
   FK CONSTRAINT     —   ALTER TABLE ONLY public.topicos
    ADD CONSTRAINT topicos_docente_id_fkey FOREIGN KEY (docente_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.topicos DROP CONSTRAINT topicos_docente_id_fkey;
       public               postgres    false    222    4937    220               ©   xœu‘A
Ã E×ã)zˆ3ãXõ,ÝšEKJ „ž¿jCjL³{ÎãÿÑ’Î„ŽÍ…02Gòš½ÇÐ[‘÷0ß (O 
,
“
·’¢Âˆ¤M 4
²®BóôœÀ•$íU×sUAR£þÕÏqœ s¯<‹â½/œûÂZó‡Öžßp”dr¼mÃŸË
w”¹’,7•÷§H¢ƒAÏ-²5:üÀM+¥>þËZ2         .   xœ3ä4æÔç,á4ä2±ô9Ó8¸ŒLU Ë˜ËÈÒ²L¸bô¸¸¸ •øC      
   ×   xœ=N1Fkï)æy½iS
!D•fbÏJ#ùge;‘à6¹í^Œ1ED…ÜX~~Oß õŽ™ñè©À ¼ñ’
8‚ ¬©¨—Œ¶²E°™0ºç++Œã™2Å*·Úþ‰ë°ogFË^m¶½žúQƒvf»ÍFë›iºUµ3?/$~NQOX)¬—+ê•Ðó'Bú×Ki`S„¸~ÊR4ÿ/Žß§è¸	±M¸ûQŠå1,ž‚,A RóÉÖS–Ï=ùB×Y§¿#‡M×uß÷fhø         Ç   xœ…ÎAŠÂ0ÆñuzŠî•4µBÝÌÂý0 äÙ<4æub#ÌqæîÜöbFÄàöãñû¿JUj™áDÑÑÎ3¼§ž,¡Òï"—øMŒNÂÈaOž»êÄº½d¢Òjó­Œ6ÍL·³ZÃT+Ó¬j3×zÑ¶ËÂ¼í”lÉ–9ïÓ¥ç(àÜ‰òÂÍg¼ÎG·ë:Mÿ|{ÈÀ‘¬D	ÖÜÑMçiüü 	_ªO~tƒçmw×qþ¯ùÙÌ‹¢¸ €Yà         
   xœ‹Ñãââ Å ©         
   xœ‹Ñãââ Å ©         ð   xœ…ÍmÃ0FÏôÀ	d¹	à\ÓÈ­ô"Ë4BÀ‘ý´ð8™¡#x±ÒIsé%  à ¾G5pr9ú¡XËËCƒs>{ Gï,…ìöË5±•f ¿á¿LdÓO”jÌî³Á¬é} h)Á^Aˆì, 6.4RZéÝFu›V¡nzwhõV©—®ÛC®4¼¥‹Í%šÛRÑ½	Nc4ñíMTc_¬ÐqôQˆßgžº0ýÖÂ{‘¸w²ˆÜãðWÙñý7f,É¯ã#Xc0q¹^H¬Öc#‰ªƒF+`Æ

ì¡}†þÜVUõ
õvÏ             xœ3ätÌKTpO,J>¼6‘31/1ÈÌ³R+s
rRõ’ós93‹3â
K39Sò“SóJR9ŒLu
,u
Œ­ŒL­ŒôL,-Í8K¸Œ8‹rò‹|o.H­âLóròl¦§—”¦d&´À˜Ó7±èd… ü ^
487±(3±ÈÏDp)´&F‹‹
 Â0\Ê     