--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ap2_meeting_appointmentsetting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_meeting_appointmentsetting (
    id bigint NOT NULL,
    provider_timezone character varying(50) NOT NULL,
    session_length character varying(10) NOT NULL,
    week_start character varying(10) NOT NULL,
    session_type character varying(10) NOT NULL,
    tutor_id bigint NOT NULL
);


ALTER TABLE ap2_meeting_appointmentsetting OWNER TO postgres;

--
-- Name: ap2_meeting_appointmentsettings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_meeting_appointmentsettings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_meeting_appointmentsettings_id_seq OWNER TO postgres;

--
-- Name: ap2_meeting_appointmentsettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_meeting_appointmentsettings_id_seq OWNED BY ap2_meeting_appointmentsetting.id;


--
-- Name: ap2_meeting_availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_meeting_availability (
    id bigint NOT NULL,
    start_time_utc timestamp with time zone NOT NULL,
    end_time_utc timestamp with time zone NOT NULL,
    is_available boolean NOT NULL,
    tutor_id bigint NOT NULL,
    tutor_timezone character varying(50) NOT NULL,
    status character varying(20) NOT NULL
);


ALTER TABLE ap2_meeting_availability OWNER TO postgres;

--
-- Name: ap2_meeting_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_meeting_availability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_meeting_availability_id_seq OWNER TO postgres;

--
-- Name: ap2_meeting_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_meeting_availability_id_seq OWNED BY ap2_meeting_availability.id;


--
-- Name: ap2_meeting_review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_meeting_review (
    id bigint NOT NULL,
    message text NOT NULL,
    create_date timestamp with time zone NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    student_id bigint NOT NULL,
    tutor_id bigint NOT NULL,
    session_id bigint,
    status character varying(20) NOT NULL,
    rate_session integer,
    rate_tutor integer,
    is_published boolean NOT NULL,
    dislike_count integer,
    like_count integer,
    CONSTRAINT ap2_meeting_review_dislike_count_check CHECK ((dislike_count >= 0)),
    CONSTRAINT ap2_meeting_review_like_count_check CHECK ((like_count >= 0))
);


ALTER TABLE ap2_meeting_review OWNER TO postgres;

--
-- Name: ap2_meeting_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_meeting_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_meeting_review_id_seq OWNER TO postgres;

--
-- Name: ap2_meeting_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_meeting_review_id_seq OWNED BY ap2_meeting_review.id;


--
-- Name: ap2_meeting_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_meeting_session (
    id bigint NOT NULL,
    subject character varying(100) NOT NULL,
    session_type character varying(10) NOT NULL,
    start_session_utc timestamp with time zone NOT NULL,
    end_session_utc timestamp with time zone NOT NULL,
    tutor_id bigint NOT NULL,
    status character varying(20) NOT NULL,
    is_rescheduled boolean NOT NULL,
    rescheduled_at timestamp with time zone,
    rescheduled_by_id integer,
    tutor_timezone character varying(50) NOT NULL,
    students_timezone character varying(50) NOT NULL,
    rating numeric(3,2),
    appointment_id character varying(10) NOT NULL,
    cost numeric(10,2) NOT NULL
);


ALTER TABLE ap2_meeting_session OWNER TO postgres;

--
-- Name: ap2_meeting_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_meeting_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_meeting_session_id_seq OWNER TO postgres;

--
-- Name: ap2_meeting_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_meeting_session_id_seq OWNED BY ap2_meeting_session.id;


--
-- Name: ap2_meeting_session_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_meeting_session_reviews (
    id bigint NOT NULL,
    session_id bigint NOT NULL,
    review_id bigint NOT NULL
);


ALTER TABLE ap2_meeting_session_reviews OWNER TO postgres;

--
-- Name: ap2_meeting_session_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_meeting_session_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_meeting_session_reviews_id_seq OWNER TO postgres;

--
-- Name: ap2_meeting_session_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_meeting_session_reviews_id_seq OWNED BY ap2_meeting_session_reviews.id;


--
-- Name: ap2_meeting_session_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_meeting_session_students (
    id bigint NOT NULL,
    session_id bigint NOT NULL,
    student_id bigint NOT NULL
);


ALTER TABLE ap2_meeting_session_students OWNER TO postgres;

--
-- Name: ap2_meeting_session_students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_meeting_session_students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_meeting_session_students_id_seq OWNER TO postgres;

--
-- Name: ap2_meeting_session_students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_meeting_session_students_id_seq OWNED BY ap2_meeting_session_students.id;


--
-- Name: ap2_student_cnotification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_student_cnotification (
    id bigint NOT NULL,
    type character varying(50) NOT NULL,
    seen boolean NOT NULL,
    date timestamp with time zone NOT NULL,
    appointment_id bigint,
    client_id bigint
);


ALTER TABLE ap2_student_cnotification OWNER TO postgres;

--
-- Name: ap2_student_cnotification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_student_cnotification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_student_cnotification_id_seq OWNER TO postgres;

--
-- Name: ap2_student_cnotification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_student_cnotification_id_seq OWNED BY ap2_student_cnotification.id;


--
-- Name: ap2_student_student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_student_student (
    id bigint NOT NULL,
    major character varying(100),
    session_count integer NOT NULL,
    tutor_count integer NOT NULL,
    profile_id bigint NOT NULL
);


ALTER TABLE ap2_student_student OWNER TO postgres;

--
-- Name: ap2_student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_student_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_student_student_id_seq OWNER TO postgres;

--
-- Name: ap2_student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_student_student_id_seq OWNED BY ap2_student_student.id;


--
-- Name: ap2_student_student_interests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_student_student_interests (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    subject_id bigint NOT NULL
);


ALTER TABLE ap2_student_student_interests OWNER TO postgres;

--
-- Name: ap2_student_student_interests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_student_student_interests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_student_student_interests_id_seq OWNER TO postgres;

--
-- Name: ap2_student_student_interests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_student_student_interests_id_seq OWNED BY ap2_student_student_interests.id;


--
-- Name: ap2_student_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_student_subject (
    id bigint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE ap2_student_subject OWNER TO postgres;

--
-- Name: ap2_student_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_student_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_student_subject_id_seq OWNER TO postgres;

--
-- Name: ap2_student_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_student_subject_id_seq OWNED BY ap2_student_subject.id;


--
-- Name: ap2_student_wishlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_student_wishlist (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    student_id bigint NOT NULL,
    tutor_id bigint NOT NULL
);


ALTER TABLE ap2_student_wishlist OWNER TO postgres;

--
-- Name: ap2_student_wishlist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_student_wishlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_student_wishlist_id_seq OWNER TO postgres;

--
-- Name: ap2_student_wishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_student_wishlist_id_seq OWNED BY ap2_student_wishlist.id;


--
-- Name: ap2_tutor_skilllevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_tutor_skilllevel (
    id bigint NOT NULL,
    name character varying(2) NOT NULL
);


ALTER TABLE ap2_tutor_skilllevel OWNER TO postgres;

--
-- Name: ap2_tutor_languagelevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_tutor_languagelevel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_tutor_languagelevel_id_seq OWNER TO postgres;

--
-- Name: ap2_tutor_languagelevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_tutor_languagelevel_id_seq OWNED BY ap2_tutor_skilllevel.id;


--
-- Name: ap2_tutor_pnotification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_tutor_pnotification (
    id bigint NOT NULL,
    type character varying(50) NOT NULL,
    seen boolean NOT NULL,
    date timestamp with time zone NOT NULL,
    appointment_id bigint,
    provider_id bigint
);


ALTER TABLE ap2_tutor_pnotification OWNER TO postgres;

--
-- Name: ap2_tutor_pnotification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_tutor_pnotification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_tutor_pnotification_id_seq OWNER TO postgres;

--
-- Name: ap2_tutor_pnotification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_tutor_pnotification_id_seq OWNED BY ap2_tutor_pnotification.id;


--
-- Name: ap2_tutor_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_tutor_skill (
    id bigint NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE ap2_tutor_skill OWNER TO postgres;

--
-- Name: ap2_tutor_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_tutor_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_tutor_skill_id_seq OWNER TO postgres;

--
-- Name: ap2_tutor_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_tutor_skill_id_seq OWNED BY ap2_tutor_skill.id;


--
-- Name: ap2_tutor_tutor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_tutor_tutor (
    id bigint NOT NULL,
    video_url character varying(200) NOT NULL,
    cost_trial numeric(10,2) NOT NULL,
    cost_hourly numeric(10,2) NOT NULL,
    session_count integer NOT NULL,
    student_count integer NOT NULL,
    course_count integer NOT NULL,
    create_date timestamp with time zone NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    profile_id bigint NOT NULL,
    discount integer NOT NULL,
    discount_deadline timestamp with time zone
);


ALTER TABLE ap2_tutor_tutor OWNER TO postgres;

--
-- Name: ap2_tutor_tutor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_tutor_tutor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_tutor_tutor_id_seq OWNER TO postgres;

--
-- Name: ap2_tutor_tutor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_tutor_tutor_id_seq OWNED BY ap2_tutor_tutor.id;


--
-- Name: ap2_tutor_tutor_skill_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_tutor_tutor_skill_level (
    id bigint NOT NULL,
    tutor_id bigint NOT NULL,
    skilllevel_id bigint NOT NULL
);


ALTER TABLE ap2_tutor_tutor_skill_level OWNER TO postgres;

--
-- Name: ap2_tutor_tutor_skill_level_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_tutor_tutor_skill_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_tutor_tutor_skill_level_id_seq OWNER TO postgres;

--
-- Name: ap2_tutor_tutor_skill_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_tutor_tutor_skill_level_id_seq OWNED BY ap2_tutor_tutor_skill_level.id;


--
-- Name: ap2_tutor_tutor_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ap2_tutor_tutor_skills (
    id bigint NOT NULL,
    tutor_id bigint NOT NULL,
    skill_id bigint NOT NULL
);


ALTER TABLE ap2_tutor_tutor_skills OWNER TO postgres;

--
-- Name: ap2_tutor_tutor_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap2_tutor_tutor_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ap2_tutor_tutor_skills_id_seq OWNER TO postgres;

--
-- Name: ap2_tutor_tutor_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap2_tutor_tutor_skills_id_seq OWNED BY ap2_tutor_tutor_skills.id;


--
-- Name: app_accounts_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_accounts_language (
    id bigint NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE app_accounts_language OWNER TO postgres;

--
-- Name: app_accounts_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_accounts_language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_accounts_language_id_seq OWNER TO postgres;

--
-- Name: app_accounts_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_accounts_language_id_seq OWNED BY app_accounts_language.id;


--
-- Name: app_accounts_userprofile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_accounts_userprofile (
    id bigint NOT NULL,
    phone character varying(50),
    country character varying(100) NOT NULL,
    photo character varying(100),
    user_type character varying(20) NOT NULL,
    title character varying(100) NOT NULL,
    lang_native character varying(100) NOT NULL,
    bio text NOT NULL,
    availability boolean NOT NULL,
    rating double precision NOT NULL,
    reviews_count integer NOT NULL,
    url_facebook character varying(150) NOT NULL,
    url_insta character varying(150) NOT NULL,
    url_twitter character varying(150) NOT NULL,
    url_linkedin character varying(150) NOT NULL,
    url_youtube character varying(150) NOT NULL,
    create_date timestamp with time zone NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    gender character varying(20),
    is_vip boolean NOT NULL
);


ALTER TABLE app_accounts_userprofile OWNER TO postgres;

--
-- Name: app_accounts_userprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_accounts_userprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_accounts_userprofile_id_seq OWNER TO postgres;

--
-- Name: app_accounts_userprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_accounts_userprofile_id_seq OWNED BY app_accounts_userprofile.id;


--
-- Name: app_accounts_userprofile_lang_speak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_accounts_userprofile_lang_speak (
    id bigint NOT NULL,
    userprofile_id bigint NOT NULL,
    language_id bigint NOT NULL
);


ALTER TABLE app_accounts_userprofile_lang_speak OWNER TO postgres;

--
-- Name: app_accounts_userprofile_lang_speak_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_accounts_userprofile_lang_speak_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_accounts_userprofile_lang_speak_id_seq OWNER TO postgres;

--
-- Name: app_accounts_userprofile_lang_speak_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_accounts_userprofile_lang_speak_id_seq OWNED BY app_accounts_userprofile_lang_speak.id;


--
-- Name: app_admin_adminprofile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_admin_adminprofile (
    profile_id bigint NOT NULL,
    department character varying(100)
);


ALTER TABLE app_admin_adminprofile OWNER TO postgres;

--
-- Name: app_content_filler_cfboolean; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfboolean (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value boolean NOT NULL
);


ALTER TABLE app_content_filler_cfboolean OWNER TO postgres;

--
-- Name: app_content_filler_cfboolean_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfboolean_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfboolean_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfboolean_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfboolean_id_seq OWNED BY app_content_filler_cfboolean.id;


--
-- Name: app_content_filler_cfchar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfchar (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE app_content_filler_cfchar OWNER TO postgres;

--
-- Name: app_content_filler_cfchar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfchar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfchar_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfchar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfchar_id_seq OWNED BY app_content_filler_cfchar.id;


--
-- Name: app_content_filler_cfdatetime; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfdatetime (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value timestamp with time zone
);


ALTER TABLE app_content_filler_cfdatetime OWNER TO postgres;

--
-- Name: app_content_filler_cfdatetime_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfdatetime_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfdatetime_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfdatetime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfdatetime_id_seq OWNED BY app_content_filler_cfdatetime.id;


--
-- Name: app_content_filler_cfdecimal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfdecimal (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value numeric(10,2)
);


ALTER TABLE app_content_filler_cfdecimal OWNER TO postgres;

--
-- Name: app_content_filler_cfdecimal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfdecimal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfdecimal_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfdecimal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfdecimal_id_seq OWNED BY app_content_filler_cfdecimal.id;


--
-- Name: app_content_filler_cfemail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfemail (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(254)
);


ALTER TABLE app_content_filler_cfemail OWNER TO postgres;

--
-- Name: app_content_filler_cfemail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfemail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfemail_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfemail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfemail_id_seq OWNED BY app_content_filler_cfemail.id;


--
-- Name: app_content_filler_cffile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cffile (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(100)
);


ALTER TABLE app_content_filler_cffile OWNER TO postgres;

--
-- Name: app_content_filler_cffile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cffile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cffile_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cffile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cffile_id_seq OWNED BY app_content_filler_cffile.id;


--
-- Name: app_content_filler_cffloat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cffloat (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value double precision
);


ALTER TABLE app_content_filler_cffloat OWNER TO postgres;

--
-- Name: app_content_filler_cffloat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cffloat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cffloat_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cffloat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cffloat_id_seq OWNED BY app_content_filler_cffloat.id;


--
-- Name: app_content_filler_cfimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfimage (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(100)
);


ALTER TABLE app_content_filler_cfimage OWNER TO postgres;

--
-- Name: app_content_filler_cfimage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfimage_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfimage_id_seq OWNED BY app_content_filler_cfimage.id;


--
-- Name: app_content_filler_cfinteger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfinteger (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value integer
);


ALTER TABLE app_content_filler_cfinteger OWNER TO postgres;

--
-- Name: app_content_filler_cfinteger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfinteger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfinteger_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfinteger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfinteger_id_seq OWNED BY app_content_filler_cfinteger.id;


--
-- Name: app_content_filler_cfrichtext; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfrichtext (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE app_content_filler_cfrichtext OWNER TO postgres;

--
-- Name: app_content_filler_cfrichtext_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfrichtext_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfrichtext_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfrichtext_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfrichtext_id_seq OWNED BY app_content_filler_cfrichtext.id;


--
-- Name: app_content_filler_cftext; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cftext (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value text
);


ALTER TABLE app_content_filler_cftext OWNER TO postgres;

--
-- Name: app_content_filler_cftext_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cftext_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cftext_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cftext_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cftext_id_seq OWNED BY app_content_filler_cftext.id;


--
-- Name: app_content_filler_cfurl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_content_filler_cfurl (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(200)
);


ALTER TABLE app_content_filler_cfurl OWNER TO postgres;

--
-- Name: app_content_filler_cfurl_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_content_filler_cfurl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_content_filler_cfurl_id_seq OWNER TO postgres;

--
-- Name: app_content_filler_cfurl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_content_filler_cfurl_id_seq OWNED BY app_content_filler_cfurl.id;


--
-- Name: app_meeting_enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_meeting_enrollment (
    id bigint NOT NULL,
    cost numeric(10,2) NOT NULL,
    session_id bigint NOT NULL,
    student_id bigint NOT NULL
);


ALTER TABLE app_meeting_enrollment OWNER TO postgres;

--
-- Name: app_meeting_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_meeting_enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_meeting_enrollment_id_seq OWNER TO postgres;

--
-- Name: app_meeting_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_meeting_enrollment_id_seq OWNED BY app_meeting_enrollment.id;


--
-- Name: app_meeting_period; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_meeting_period (
    id bigint NOT NULL,
    day character varying(10) NOT NULL,
    "time" character varying(20) NOT NULL
);


ALTER TABLE app_meeting_period OWNER TO postgres;

--
-- Name: app_meeting_period_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_meeting_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_meeting_period_id_seq OWNER TO postgres;

--
-- Name: app_meeting_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_meeting_period_id_seq OWNED BY app_meeting_period.id;


--
-- Name: app_meeting_review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_meeting_review (
    id bigint NOT NULL,
    rating integer NOT NULL,
    comment text NOT NULL,
    create_date timestamp with time zone NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    student_id bigint NOT NULL,
    tutor_id bigint NOT NULL
);


ALTER TABLE app_meeting_review OWNER TO postgres;

--
-- Name: app_meeting_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_meeting_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_meeting_review_id_seq OWNER TO postgres;

--
-- Name: app_meeting_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_meeting_review_id_seq OWNED BY app_meeting_review.id;


--
-- Name: app_meeting_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_meeting_schedule (
    id bigint NOT NULL,
    date date NOT NULL,
    day character varying(10) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    tutor_id bigint NOT NULL
);


ALTER TABLE app_meeting_schedule OWNER TO postgres;

--
-- Name: app_meeting_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_meeting_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_meeting_schedule_id_seq OWNER TO postgres;

--
-- Name: app_meeting_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_meeting_schedule_id_seq OWNED BY app_meeting_schedule.id;


--
-- Name: app_meeting_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_meeting_session (
    id bigint NOT NULL,
    status character varying(20) NOT NULL,
    start_time timestamp with time zone NOT NULL,
    schedule_id bigint NOT NULL,
    tutor_id bigint NOT NULL
);


ALTER TABLE app_meeting_session OWNER TO postgres;

--
-- Name: app_meeting_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_meeting_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_meeting_session_id_seq OWNER TO postgres;

--
-- Name: app_meeting_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_meeting_session_id_seq OWNED BY app_meeting_session.id;


--
-- Name: app_pages_contactus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_pages_contactus (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    phone character varying(50) NOT NULL,
    email character varying(254) NOT NULL,
    message text NOT NULL,
    create_date timestamp with time zone NOT NULL,
    is_read boolean NOT NULL
);


ALTER TABLE app_pages_contactus OWNER TO postgres;

--
-- Name: app_pages_contactus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_pages_contactus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_pages_contactus_id_seq OWNER TO postgres;

--
-- Name: app_pages_contactus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_pages_contactus_id_seq OWNED BY app_pages_contactus.id;


--
-- Name: app_pages_contentfiller; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_pages_contentfiller (
    id bigint NOT NULL,
    data_title character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    logo character varying(100) NOT NULL,
    url character varying(100) NOT NULL,
    phone_1 character varying(50) NOT NULL,
    phone_2 character varying(50) NOT NULL,
    email_1 character varying(50) NOT NULL,
    email_2 character varying(50) NOT NULL,
    address_line_1 character varying(150) NOT NULL,
    address_line_2 character varying(150) NOT NULL,
    site_description_1 character varying(300) NOT NULL,
    site_description_2 character varying(300) NOT NULL,
    site_slogan_1 character varying(300) NOT NULL,
    site_slogan_2 character varying(300) NOT NULL,
    text_1 character varying(500) NOT NULL,
    text_2 character varying(500) NOT NULL,
    text_3 character varying(500) NOT NULL,
    text_4 character varying(500) NOT NULL,
    text_5 character varying(500) NOT NULL
);


ALTER TABLE app_pages_contentfiller OWNER TO postgres;

--
-- Name: app_pages_contentfiller_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_pages_contentfiller_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_pages_contentfiller_id_seq OWNER TO postgres;

--
-- Name: app_pages_contentfiller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_pages_contentfiller_id_seq OWNED BY app_pages_contentfiller.id;


--
-- Name: app_pages_page; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_pages_page (
    id bigint NOT NULL,
    content text NOT NULL,
    page_type character varying(20) NOT NULL
);


ALTER TABLE app_pages_page OWNER TO postgres;

--
-- Name: app_pages_page_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_pages_page_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_pages_page_id_seq OWNER TO postgres;

--
-- Name: app_pages_page_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_pages_page_id_seq OWNED BY app_pages_page.id;


--
-- Name: app_staff_staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_staff_staff (
    profile_id bigint NOT NULL,
    "position" character varying(100)
);


ALTER TABLE app_staff_staff OWNER TO postgres;

--
-- Name: app_student_student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_student_student (
    id bigint NOT NULL,
    major character varying(100),
    session_count integer NOT NULL,
    tutor_count integer NOT NULL,
    profile_id bigint NOT NULL
);


ALTER TABLE app_student_student OWNER TO postgres;

--
-- Name: app_student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_student_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_student_student_id_seq OWNER TO postgres;

--
-- Name: app_student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_student_student_id_seq OWNED BY app_student_student.id;


--
-- Name: app_student_student_interests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_student_student_interests (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    subject_id bigint NOT NULL
);


ALTER TABLE app_student_student_interests OWNER TO postgres;

--
-- Name: app_student_student_interests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_student_student_interests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_student_student_interests_id_seq OWNER TO postgres;

--
-- Name: app_student_student_interests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_student_student_interests_id_seq OWNED BY app_student_student_interests.id;


--
-- Name: app_student_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_student_subject (
    id bigint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE app_student_subject OWNER TO postgres;

--
-- Name: app_student_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_student_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_student_subject_id_seq OWNER TO postgres;

--
-- Name: app_student_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_student_subject_id_seq OWNED BY app_student_subject.id;


--
-- Name: app_temp_languagelevel2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_languagelevel2 (
    id bigint NOT NULL,
    name character varying(2) NOT NULL
);


ALTER TABLE app_temp_languagelevel2 OWNER TO postgres;

--
-- Name: app_temp_languagelevel2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_languagelevel2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_languagelevel2_id_seq OWNER TO postgres;

--
-- Name: app_temp_languagelevel2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_languagelevel2_id_seq OWNED BY app_temp_languagelevel2.id;


--
-- Name: app_temp_session3; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_session3 (
    id bigint NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    subject character varying(200) NOT NULL,
    tutor_id bigint NOT NULL
);


ALTER TABLE app_temp_session3 OWNER TO postgres;

--
-- Name: app_temp_session3_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_session3_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_session3_id_seq OWNER TO postgres;

--
-- Name: app_temp_session3_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_session3_id_seq OWNED BY app_temp_session3.id;


--
-- Name: app_temp_session3_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_session3_students (
    id bigint NOT NULL,
    session3_id bigint NOT NULL,
    student3_id bigint NOT NULL
);


ALTER TABLE app_temp_session3_students OWNER TO postgres;

--
-- Name: app_temp_session3_students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_session3_students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_session3_students_id_seq OWNER TO postgres;

--
-- Name: app_temp_session3_students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_session3_students_id_seq OWNED BY app_temp_session3_students.id;


--
-- Name: app_temp_skill2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_skill2 (
    id bigint NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE app_temp_skill2 OWNER TO postgres;

--
-- Name: app_temp_skill2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_skill2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_skill2_id_seq OWNER TO postgres;

--
-- Name: app_temp_skill2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_skill2_id_seq OWNED BY app_temp_skill2.id;


--
-- Name: app_temp_student3; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_student3 (
    id bigint NOT NULL,
    major character varying(100),
    session_count integer NOT NULL,
    tutor_count integer NOT NULL,
    profile_id bigint NOT NULL
);


ALTER TABLE app_temp_student3 OWNER TO postgres;

--
-- Name: app_temp_student3_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_student3_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_student3_id_seq OWNER TO postgres;

--
-- Name: app_temp_student3_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_student3_id_seq OWNED BY app_temp_student3.id;


--
-- Name: app_temp_student3_interests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_student3_interests (
    id bigint NOT NULL,
    student3_id bigint NOT NULL,
    subject2_id bigint NOT NULL
);


ALTER TABLE app_temp_student3_interests OWNER TO postgres;

--
-- Name: app_temp_student3_interests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_student3_interests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_student3_interests_id_seq OWNER TO postgres;

--
-- Name: app_temp_student3_interests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_student3_interests_id_seq OWNED BY app_temp_student3_interests.id;


--
-- Name: app_temp_subject2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_subject2 (
    id bigint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE app_temp_subject2 OWNER TO postgres;

--
-- Name: app_temp_subject2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_subject2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_subject2_id_seq OWNER TO postgres;

--
-- Name: app_temp_subject2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_subject2_id_seq OWNED BY app_temp_subject2.id;


--
-- Name: app_temp_tutor3; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_temp_tutor3 (
    id bigint NOT NULL,
    bio text NOT NULL,
    profile_id bigint NOT NULL
);


ALTER TABLE app_temp_tutor3 OWNER TO postgres;

--
-- Name: app_temp_tutor3_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_temp_tutor3_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_temp_tutor3_id_seq OWNER TO postgres;

--
-- Name: app_temp_tutor3_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_temp_tutor3_id_seq OWNED BY app_temp_tutor3.id;


--
-- Name: app_tutor_languagelevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_tutor_languagelevel (
    id bigint NOT NULL,
    name character varying(2) NOT NULL
);


ALTER TABLE app_tutor_languagelevel OWNER TO postgres;

--
-- Name: app_tutor_languagelevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_tutor_languagelevel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_tutor_languagelevel_id_seq OWNER TO postgres;

--
-- Name: app_tutor_languagelevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_tutor_languagelevel_id_seq OWNED BY app_tutor_languagelevel.id;


--
-- Name: app_tutor_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_tutor_skill (
    id bigint NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE app_tutor_skill OWNER TO postgres;

--
-- Name: app_tutor_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_tutor_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_tutor_skill_id_seq OWNER TO postgres;

--
-- Name: app_tutor_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_tutor_skill_id_seq OWNED BY app_tutor_skill.id;


--
-- Name: app_tutor_tutor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_tutor_tutor (
    id bigint NOT NULL,
    video_url character varying(200) NOT NULL,
    video_intro character varying(100) NOT NULL,
    cost_trial numeric(10,2) NOT NULL,
    cost_hourly numeric(10,2) NOT NULL,
    session_count integer NOT NULL,
    student_count integer NOT NULL,
    course_count integer NOT NULL,
    create_date timestamp with time zone NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    profile_id bigint NOT NULL
);


ALTER TABLE app_tutor_tutor OWNER TO postgres;

--
-- Name: app_tutor_tutor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_tutor_tutor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_tutor_tutor_id_seq OWNER TO postgres;

--
-- Name: app_tutor_tutor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_tutor_tutor_id_seq OWNED BY app_tutor_tutor.id;


--
-- Name: app_tutor_tutor_language_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_tutor_tutor_language_levels (
    id bigint NOT NULL,
    tutor_id bigint NOT NULL,
    languagelevel_id bigint NOT NULL
);


ALTER TABLE app_tutor_tutor_language_levels OWNER TO postgres;

--
-- Name: app_tutor_tutor_language_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_tutor_tutor_language_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_tutor_tutor_language_levels_id_seq OWNER TO postgres;

--
-- Name: app_tutor_tutor_language_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_tutor_tutor_language_levels_id_seq OWNED BY app_tutor_tutor_language_levels.id;


--
-- Name: app_tutor_tutor_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE app_tutor_tutor_skills (
    id bigint NOT NULL,
    tutor_id bigint NOT NULL,
    skill_id bigint NOT NULL
);


ALTER TABLE app_tutor_tutor_skills OWNER TO postgres;

--
-- Name: app_tutor_tutor_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE app_tutor_tutor_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_tutor_tutor_skills_id_seq OWNER TO postgres;

--
-- Name: app_tutor_tutor_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE app_tutor_tutor_skills_id_seq OWNED BY app_tutor_tutor_skills.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE django_session OWNER TO postgres;

--
-- Name: payments_bill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payments_bill (
    id bigint NOT NULL,
    appointment_id bigint NOT NULL,
    client_id bigint,
    provider_id bigint,
    bill_id character varying(10) NOT NULL,
    date timestamp with time zone NOT NULL,
    status character varying(10) NOT NULL,
    sub_total numeric(10,2) NOT NULL,
    tax numeric(10,2) NOT NULL,
    total numeric(10,2) NOT NULL
);


ALTER TABLE payments_bill OWNER TO postgres;

--
-- Name: payments_bill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payments_bill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payments_bill_id_seq OWNER TO postgres;

--
-- Name: payments_bill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE payments_bill_id_seq OWNED BY payments_bill.id;


--
-- Name: ap2_meeting_appointmentsetting id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_appointmentsetting ALTER COLUMN id SET DEFAULT nextval('ap2_meeting_appointmentsettings_id_seq'::regclass);


--
-- Name: ap2_meeting_availability id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_availability ALTER COLUMN id SET DEFAULT nextval('ap2_meeting_availability_id_seq'::regclass);


--
-- Name: ap2_meeting_review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_review ALTER COLUMN id SET DEFAULT nextval('ap2_meeting_review_id_seq'::regclass);


--
-- Name: ap2_meeting_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session ALTER COLUMN id SET DEFAULT nextval('ap2_meeting_session_id_seq'::regclass);


--
-- Name: ap2_meeting_session_reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_reviews ALTER COLUMN id SET DEFAULT nextval('ap2_meeting_session_reviews_id_seq'::regclass);


--
-- Name: ap2_meeting_session_students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_students ALTER COLUMN id SET DEFAULT nextval('ap2_meeting_session_students_id_seq'::regclass);


--
-- Name: ap2_student_cnotification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_cnotification ALTER COLUMN id SET DEFAULT nextval('ap2_student_cnotification_id_seq'::regclass);


--
-- Name: ap2_student_student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student ALTER COLUMN id SET DEFAULT nextval('ap2_student_student_id_seq'::regclass);


--
-- Name: ap2_student_student_interests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student_interests ALTER COLUMN id SET DEFAULT nextval('ap2_student_student_interests_id_seq'::regclass);


--
-- Name: ap2_student_subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_subject ALTER COLUMN id SET DEFAULT nextval('ap2_student_subject_id_seq'::regclass);


--
-- Name: ap2_student_wishlist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_wishlist ALTER COLUMN id SET DEFAULT nextval('ap2_student_wishlist_id_seq'::regclass);


--
-- Name: ap2_tutor_pnotification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_pnotification ALTER COLUMN id SET DEFAULT nextval('ap2_tutor_pnotification_id_seq'::regclass);


--
-- Name: ap2_tutor_skill id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_skill ALTER COLUMN id SET DEFAULT nextval('ap2_tutor_skill_id_seq'::regclass);


--
-- Name: ap2_tutor_skilllevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_skilllevel ALTER COLUMN id SET DEFAULT nextval('ap2_tutor_languagelevel_id_seq'::regclass);


--
-- Name: ap2_tutor_tutor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor ALTER COLUMN id SET DEFAULT nextval('ap2_tutor_tutor_id_seq'::regclass);


--
-- Name: ap2_tutor_tutor_skill_level id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skill_level ALTER COLUMN id SET DEFAULT nextval('ap2_tutor_tutor_skill_level_id_seq'::regclass);


--
-- Name: ap2_tutor_tutor_skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skills ALTER COLUMN id SET DEFAULT nextval('ap2_tutor_tutor_skills_id_seq'::regclass);


--
-- Name: app_accounts_language id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_language ALTER COLUMN id SET DEFAULT nextval('app_accounts_language_id_seq'::regclass);


--
-- Name: app_accounts_userprofile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile ALTER COLUMN id SET DEFAULT nextval('app_accounts_userprofile_id_seq'::regclass);


--
-- Name: app_accounts_userprofile_lang_speak id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile_lang_speak ALTER COLUMN id SET DEFAULT nextval('app_accounts_userprofile_lang_speak_id_seq'::regclass);


--
-- Name: app_content_filler_cfboolean id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfboolean ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfboolean_id_seq'::regclass);


--
-- Name: app_content_filler_cfchar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfchar ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfchar_id_seq'::regclass);


--
-- Name: app_content_filler_cfdatetime id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfdatetime ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfdatetime_id_seq'::regclass);


--
-- Name: app_content_filler_cfdecimal id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfdecimal ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfdecimal_id_seq'::regclass);


--
-- Name: app_content_filler_cfemail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfemail ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfemail_id_seq'::regclass);


--
-- Name: app_content_filler_cffile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cffile ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cffile_id_seq'::regclass);


--
-- Name: app_content_filler_cffloat id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cffloat ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cffloat_id_seq'::regclass);


--
-- Name: app_content_filler_cfimage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfimage ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfimage_id_seq'::regclass);


--
-- Name: app_content_filler_cfinteger id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfinteger ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfinteger_id_seq'::regclass);


--
-- Name: app_content_filler_cfrichtext id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfrichtext ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfrichtext_id_seq'::regclass);


--
-- Name: app_content_filler_cftext id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cftext ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cftext_id_seq'::regclass);


--
-- Name: app_content_filler_cfurl id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfurl ALTER COLUMN id SET DEFAULT nextval('app_content_filler_cfurl_id_seq'::regclass);


--
-- Name: app_meeting_enrollment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_enrollment ALTER COLUMN id SET DEFAULT nextval('app_meeting_enrollment_id_seq'::regclass);


--
-- Name: app_meeting_period id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_period ALTER COLUMN id SET DEFAULT nextval('app_meeting_period_id_seq'::regclass);


--
-- Name: app_meeting_review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_review ALTER COLUMN id SET DEFAULT nextval('app_meeting_review_id_seq'::regclass);


--
-- Name: app_meeting_schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_schedule ALTER COLUMN id SET DEFAULT nextval('app_meeting_schedule_id_seq'::regclass);


--
-- Name: app_meeting_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_session ALTER COLUMN id SET DEFAULT nextval('app_meeting_session_id_seq'::regclass);


--
-- Name: app_pages_contactus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_contactus ALTER COLUMN id SET DEFAULT nextval('app_pages_contactus_id_seq'::regclass);


--
-- Name: app_pages_contentfiller id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_contentfiller ALTER COLUMN id SET DEFAULT nextval('app_pages_contentfiller_id_seq'::regclass);


--
-- Name: app_pages_page id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_page ALTER COLUMN id SET DEFAULT nextval('app_pages_page_id_seq'::regclass);


--
-- Name: app_student_student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student ALTER COLUMN id SET DEFAULT nextval('app_student_student_id_seq'::regclass);


--
-- Name: app_student_student_interests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student_interests ALTER COLUMN id SET DEFAULT nextval('app_student_student_interests_id_seq'::regclass);


--
-- Name: app_student_subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_subject ALTER COLUMN id SET DEFAULT nextval('app_student_subject_id_seq'::regclass);


--
-- Name: app_temp_languagelevel2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_languagelevel2 ALTER COLUMN id SET DEFAULT nextval('app_temp_languagelevel2_id_seq'::regclass);


--
-- Name: app_temp_session3 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3 ALTER COLUMN id SET DEFAULT nextval('app_temp_session3_id_seq'::regclass);


--
-- Name: app_temp_session3_students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3_students ALTER COLUMN id SET DEFAULT nextval('app_temp_session3_students_id_seq'::regclass);


--
-- Name: app_temp_skill2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_skill2 ALTER COLUMN id SET DEFAULT nextval('app_temp_skill2_id_seq'::regclass);


--
-- Name: app_temp_student3 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3 ALTER COLUMN id SET DEFAULT nextval('app_temp_student3_id_seq'::regclass);


--
-- Name: app_temp_student3_interests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3_interests ALTER COLUMN id SET DEFAULT nextval('app_temp_student3_interests_id_seq'::regclass);


--
-- Name: app_temp_subject2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_subject2 ALTER COLUMN id SET DEFAULT nextval('app_temp_subject2_id_seq'::regclass);


--
-- Name: app_temp_tutor3 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_tutor3 ALTER COLUMN id SET DEFAULT nextval('app_temp_tutor3_id_seq'::regclass);


--
-- Name: app_tutor_languagelevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_languagelevel ALTER COLUMN id SET DEFAULT nextval('app_tutor_languagelevel_id_seq'::regclass);


--
-- Name: app_tutor_skill id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_skill ALTER COLUMN id SET DEFAULT nextval('app_tutor_skill_id_seq'::regclass);


--
-- Name: app_tutor_tutor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor ALTER COLUMN id SET DEFAULT nextval('app_tutor_tutor_id_seq'::regclass);


--
-- Name: app_tutor_tutor_language_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_language_levels ALTER COLUMN id SET DEFAULT nextval('app_tutor_tutor_language_levels_id_seq'::regclass);


--
-- Name: app_tutor_tutor_skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_skills ALTER COLUMN id SET DEFAULT nextval('app_tutor_tutor_skills_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: payments_bill id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments_bill ALTER COLUMN id SET DEFAULT nextval('payments_bill_id_seq'::regclass);


--
-- Data for Name: ap2_meeting_appointmentsetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_appointmentsetting (id, provider_timezone, session_length, week_start, session_type, tutor_id) FROM stdin;
7	Pacific/Truk	6	5	trial	1
2	Iran	4	1	group	3
1	UTC	4	1	group	5
8	Iran	2	0	trial	4
\.


--
-- Name: ap2_meeting_appointmentsettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_appointmentsettings_id_seq', 8, true);


--
-- Data for Name: ap2_meeting_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_availability (id, start_time_utc, end_time_utc, is_available, tutor_id, tutor_timezone, status) FROM stdin;
1	2025-02-01 21:59:01+03:30	2025-02-01 23:59:02+03:30	t	1	UTC	free
2	2025-02-01 06:30:00+03:30	2025-02-01 07:00:00+03:30	t	1	UTC	free
3	2025-02-01 03:30:00+03:30	2025-02-01 04:00:00+03:30	t	1	UTC	free
4	2025-02-01 04:00:00+03:30	2025-02-01 04:30:00+03:30	t	1	UTC	free
5	2025-02-01 04:00:00+03:30	2025-02-01 04:30:00+03:30	t	1	UTC	free
6	2025-02-01 04:00:00+03:30	2025-02-01 04:30:00+03:30	t	1	UTC	free
7	2025-02-06 03:30:00+03:30	2025-02-06 04:00:00+03:30	t	1	UTC	free
9	2025-02-01 03:30:00+03:30	2025-02-01 04:00:00+03:30	t	1	UTC	free
10	2025-02-01 04:30:00+03:30	2025-02-01 05:00:00+03:30	t	1	UTC	free
12	2025-02-07 11:30:00+03:30	2025-02-07 21:30:00+03:30	t	1	UTC	free
11	2025-02-04 03:30:00+03:30	2025-02-05 03:29:00+03:30	t	1	UTC	free
8	2025-02-08 04:30:00+03:30	2025-02-06 11:00:00+03:30	t	1	UTC	free
14	2025-02-07 03:30:00+03:30	2025-02-07 10:30:00+03:30	t	1	UTC	free
15	2025-02-06 05:44:41+03:30	2025-02-06 08:44:43+03:30	t	1	UTC	free
13	2025-02-08 05:00:00+03:30	2025-02-08 09:30:00+03:30	t	1	UTC	free
16	2025-02-03 13:30:00+03:30	2025-02-03 18:30:00+03:30	t	4	Iran	free
17	2025-02-04 14:30:00+03:30	2025-02-04 20:31:05+03:30	t	4	UTC	free
18	2025-02-10 14:30:00+03:30	2025-02-10 17:30:02+03:30	t	4	UTC	free
19	2025-02-13 11:30:00+03:30	2025-02-13 16:00:00+03:30	t	4	UTC	free
50	2025-02-09 14:30:00+03:30	2025-02-09 16:00:00+03:30	t	1	Asia/Tehran	free
21	2025-02-13 05:30:00+03:30	2025-02-14 06:30:00+03:30	t	1	UTC	free
23	2025-02-05 14:30:00+03:30	2025-02-05 15:30:00+03:30	t	3	Europe/Berlin	free
24	2025-02-06 11:19:37+03:30	2025-02-06 14:19:39+03:30	t	3	UTC	free
22	2025-02-27 08:51:49+03:30	2025-02-28 00:51:50+03:30	t	1	Europe/Berlin	free
25	2025-02-17 11:05:23+03:30	2025-02-17 21:05:24+03:30	t	1	UTC	free
26	2025-02-08 00:00:00+03:30	2025-02-08 01:30:00+03:30	t	1	Asia/Tehran	free
27	2025-02-08 02:30:00+03:30	2025-02-08 04:00:00+03:30	t	1	Asia/Tehran	free
28	2025-02-10 01:00:00+03:30	2025-02-10 02:30:00+03:30	t	1	Asia/Tehran	free
29	2025-02-10 03:00:00+03:30	2025-02-10 04:30:00+03:30	t	1	Asia/Tehran	free
30	2025-02-11 08:00:00+03:30	2025-02-11 09:30:00+03:30	t	1	Asia/Tehran	free
31	2025-02-10 10:30:00+03:30	2025-02-10 12:00:00+03:30	t	1	Asia/Tehran	free
32	2025-02-12 10:00:00+03:30	2025-02-12 11:30:00+03:30	t	1	Asia/Tehran	free
33	2025-02-15 09:30:00+03:30	2025-02-15 11:00:00+03:30	t	1	Asia/Tehran	free
34	2025-02-15 07:00:00+03:30	2025-02-15 08:30:00+03:30	t	1	Asia/Tehran	free
35	2025-02-12 05:00:00+03:30	2025-02-12 06:30:00+03:30	t	1	Asia/Tehran	free
36	2025-02-09 06:00:00+03:30	2025-02-09 07:30:00+03:30	t	1	Asia/Tehran	free
37	2025-02-13 00:30:00+03:30	2025-02-13 02:00:00+03:30	t	1	Asia/Tehran	free
38	2025-02-11 00:30:00+03:30	2025-02-11 02:00:00+03:30	t	1	Asia/Tehran	free
39	2025-02-15 13:30:00+03:30	2025-02-15 15:00:00+03:30	t	1	Asia/Tehran	free
40	2025-02-14 16:30:00+03:30	2025-02-14 18:00:00+03:30	t	1	Asia/Tehran	free
41	2025-02-11 18:00:00+03:30	2025-02-11 19:30:00+03:30	t	1	Asia/Tehran	free
42	2025-02-10 18:00:00+03:30	2025-02-10 19:30:00+03:30	t	1	Asia/Tehran	free
43	2025-02-09 18:30:00+03:30	2025-02-09 20:00:00+03:30	t	1	Asia/Tehran	free
44	2025-02-11 20:30:00+03:30	2025-02-11 22:00:00+03:30	t	1	Asia/Tehran	free
45	2025-02-12 21:00:00+03:30	2025-02-12 22:30:00+03:30	t	1	Asia/Tehran	free
46	2025-02-14 21:00:00+03:30	2025-02-14 22:30:00+03:30	t	1	Asia/Tehran	free
47	2025-02-15 19:00:00+03:30	2025-02-15 20:30:00+03:30	t	1	Asia/Tehran	free
48	2025-02-12 16:30:00+03:30	2025-02-12 18:00:00+03:30	t	1	Asia/Tehran	free
49	2025-02-11 13:00:00+03:30	2025-02-11 14:30:00+03:30	t	1	Asia/Tehran	free
51	2025-02-09 08:00:00+03:30	2025-02-09 09:30:00+03:30	t	1	Asia/Tehran	free
52	2025-02-10 13:00:00+03:30	2025-02-10 14:30:00+03:30	t	1	Asia/Tehran	free
53	2025-02-12 13:00:00+03:30	2025-02-12 14:30:00+03:30	t	1	Asia/Tehran	free
54	2025-02-14 13:00:00+03:30	2025-02-14 14:30:00+03:30	t	1	Asia/Tehran	free
55	2025-02-09 13:00:00+03:30	2025-02-09 14:30:00+03:30	t	1	Asia/Tehran	free
56	2025-02-11 04:30:00+03:30	2025-02-11 06:00:00+03:30	t	1	Asia/Tehran	free
57	2025-02-13 03:00:00+03:30	2025-02-13 04:30:00+03:30	t	1	Asia/Tehran	free
58	2025-02-14 07:30:00+03:30	2025-02-14 09:00:00+03:30	t	1	Asia/Tehran	free
59	2025-02-14 11:00:00+03:30	2025-02-14 11:30:00+03:30	t	1	Asia/Tehran	free
60	2025-02-14 11:30:00+03:30	2025-02-14 12:00:00+03:30	t	1	Asia/Tehran	free
61	2025-02-14 12:00:00+03:30	2025-02-14 12:30:00+03:30	t	1	Asia/Tehran	free
62	2025-02-14 12:30:00+03:30	2025-02-14 13:00:00+03:30	t	1	Asia/Tehran	free
63	2025-02-12 06:30:00+03:30	2025-02-12 07:00:00+03:30	t	1	Asia/Tehran	free
64	2025-02-12 07:00:00+03:30	2025-02-12 07:30:00+03:30	t	1	Asia/Tehran	free
65	2025-02-12 07:30:00+03:30	2025-02-12 08:00:00+03:30	t	1	Asia/Tehran	free
66	2025-02-12 08:00:00+03:30	2025-02-12 08:30:00+03:30	t	1	Asia/Tehran	free
67	2025-02-12 08:30:00+03:30	2025-02-12 09:00:00+03:30	t	1	Asia/Tehran	free
68	2025-02-12 09:00:00+03:30	2025-02-12 09:30:00+03:30	t	1	Asia/Tehran	free
69	2025-02-11 06:30:00+03:30	2025-02-11 07:00:00+03:30	t	1	Asia/Tehran	free
70	2025-02-10 06:30:00+03:30	2025-02-10 07:00:00+03:30	t	1	Asia/Tehran	free
71	2025-02-10 07:00:00+03:30	2025-02-10 07:30:00+03:30	t	1	Asia/Tehran	free
72	2025-02-15 01:00:00+03:30	2025-02-15 02:00:00+03:30	t	1	Asia/Tehran	free
73	2025-02-15 02:30:00+03:30	2025-02-15 03:30:00+03:30	t	1	Asia/Tehran	free
74	2025-02-15 04:00:00+03:30	2025-02-15 05:00:00+03:30	t	1	Asia/Tehran	free
75	2025-02-15 06:00:00+03:30	2025-02-15 07:00:00+03:30	t	1	Asia/Tehran	free
76	2025-02-08 14:30:00+03:30	2025-02-08 15:30:00+03:30	t	1	Asia/Tehran	free
77	2025-02-08 12:00:00+03:30	2025-02-08 13:00:00+03:30	t	1	Asia/Tehran	free
79	2025-02-15 00:00:00+03:30	2025-02-15 01:00:00+03:30	t	1	Asia/Tehran	free
20	2025-02-13 09:30:00+03:30	2025-02-13 10:30:00+03:30	f	4	UTC	booked
78	2025-02-08 10:30:00+03:30	2025-02-08 11:30:00+03:30	f	1	Asia/Tehran	booked
80	2025-02-09 00:30:00+03:30	2025-02-09 01:30:00+03:30	t	1	Asia/Tehran	free
81	2025-02-15 05:30:00+03:30	2025-02-15 06:30:00+03:30	t	1	Asia/Tehran	free
82	2025-02-15 04:00:00+03:30	2025-02-15 05:00:00+03:30	t	1	Asia/Tehran	free
83	2025-02-15 18:30:00+03:30	2025-02-15 19:30:00+03:30	t	1	Asia/Tehran	free
84	2025-02-15 16:00:00+03:30	2025-02-15 17:00:00+03:30	t	1	Asia/Tehran	free
85	2025-02-15 20:00:00+03:30	2025-02-15 21:00:00+03:30	t	1	Asia/Tehran	free
86	2025-02-15 23:00:00+03:30	2025-02-16 00:00:00+03:30	t	1	Asia/Tehran	free
87	2025-02-16 02:30:00+03:30	2025-02-16 03:30:00+03:30	t	1	UTC	free
88	2025-02-15 02:30:00+03:30	2025-02-15 03:30:00+03:30	t	1	UTC	free
89	2025-02-15 02:30:00+03:30	2025-02-15 03:30:00+03:30	t	1	UTC	free
90	2025-02-18 03:30:00+03:30	2025-02-18 04:30:00+03:30	t	1	UTC	free
91	2025-02-15 20:00:00+03:30	2025-02-15 21:00:00+03:30	t	1	Asia/Tehran	free
92	2025-02-12 02:00:00+03:30	2025-02-12 03:00:00+03:30	t	1	Asia/Tehran	free
93	2025-02-19 03:30:00+03:30	2025-02-19 05:00:00+03:30	t	1	Europe/Berlin	free
94	2025-02-12 00:30:00+03:30	2025-02-12 01:30:00+03:30	t	5	Asia/Tehran	free
95	2025-02-13 03:00:00+03:30	2025-02-13 04:00:00+03:30	t	5	Asia/Tehran	free
96	2025-02-15 03:00:00+03:30	2025-02-15 04:00:00+03:30	t	5	Asia/Tehran	free
97	2025-02-11 03:00:00+03:30	2025-02-11 04:00:00+03:30	t	5	Asia/Tehran	free
98	2025-02-10 03:00:00+03:30	2025-02-10 04:00:00+03:30	t	5	Asia/Tehran	free
99	2025-02-14 03:00:00+03:30	2025-02-14 04:00:00+03:30	t	5	Asia/Tehran	free
100	2025-02-12 03:00:00+03:30	2025-02-12 04:00:00+03:30	t	5	Asia/Tehran	free
101	2025-02-15 06:30:00+03:30	2025-02-15 07:30:00+03:30	t	5	Asia/Tehran	free
102	2025-02-14 06:30:00+03:30	2025-02-14 07:30:00+03:30	t	5	Asia/Tehran	free
103	2025-02-13 06:30:00+03:30	2025-02-13 07:30:00+03:30	t	5	Asia/Tehran	free
104	2025-02-12 06:30:00+03:30	2025-02-12 07:30:00+03:30	t	5	Asia/Tehran	free
105	2025-02-11 06:30:00+03:30	2025-02-11 07:30:00+03:30	t	5	Asia/Tehran	free
106	2025-02-10 06:30:00+03:30	2025-02-10 07:30:00+03:30	t	5	Asia/Tehran	free
108	2025-02-10 00:30:00+03:30	2025-02-10 01:30:00+03:30	t	5	Asia/Tehran	free
111	2025-02-13 18:30:00+03:30	2025-02-13 19:30:00+03:30	t	5	Asia/Tehran	free
112	2025-02-12 18:00:00+03:30	2025-02-12 19:00:00+03:30	t	5	Asia/Tehran	free
113	2025-02-11 18:00:00+03:30	2025-02-11 19:00:00+03:30	t	5	Asia/Tehran	free
114	2025-02-10 18:00:00+03:30	2025-02-10 19:00:00+03:30	t	5	Asia/Tehran	free
693	2025-03-02 03:30:00+03:30	2025-03-03 03:30:00+03:30	t	3	UTC	free
115	2025-02-16 06:30:00+03:30	2025-02-16 07:30:00+03:30	t	5	Africa/Algiers	free
117	2025-02-18 06:30:00+03:30	2025-02-18 07:30:00+03:30	t	5	Africa/Algiers	free
119	2025-02-21 06:30:00+03:30	2025-02-21 07:30:00+03:30	t	5	Africa/Algiers	free
121	2025-02-16 16:30:00+03:30	2025-02-16 17:30:00+03:30	t	5	Africa/Algiers	free
122	2025-02-17 16:30:00+03:30	2025-02-17 17:30:00+03:30	t	5	Africa/Algiers	free
123	2025-02-18 16:30:00+03:30	2025-02-18 17:30:00+03:30	t	5	Africa/Algiers	free
124	2025-02-19 16:30:00+03:30	2025-02-19 17:30:00+03:30	t	5	Africa/Algiers	free
125	2025-02-20 16:30:00+03:30	2025-02-20 17:30:00+03:30	t	5	Africa/Algiers	free
126	2025-02-21 16:30:00+03:30	2025-02-21 17:30:00+03:30	t	5	Africa/Algiers	free
128	2025-02-16 20:30:00+03:30	2025-02-16 21:30:00+03:30	t	5	Africa/Algiers	free
130	2025-02-18 20:30:00+03:30	2025-02-18 21:30:00+03:30	t	5	Africa/Algiers	free
131	2025-02-19 20:30:00+03:30	2025-02-19 21:30:00+03:30	t	5	Africa/Algiers	free
132	2025-02-20 20:30:00+03:30	2025-02-20 21:30:00+03:30	t	5	Africa/Algiers	free
133	2025-02-21 20:30:00+03:30	2025-02-21 21:30:00+03:30	t	5	Africa/Algiers	free
136	2025-02-19 23:30:00+03:30	2025-02-20 00:30:00+03:30	t	5	Africa/Algiers	free
138	2025-02-13 00:30:00+03:30	2025-02-13 01:30:00+03:30	t	5	Asia/Tehran	free
139	2025-02-20 09:30:00+03:30	2025-02-20 10:30:00+03:30	t	5	Asia/Tehran	free
140	2025-02-20 10:30:00+03:30	2025-02-20 11:30:00+03:30	t	5	Asia/Tehran	free
141	2025-02-20 11:30:00+03:30	2025-02-20 12:30:00+03:30	t	5	Asia/Tehran	free
694	2025-02-24 03:30:00+03:30	2025-02-25 03:30:00+03:30	t	3	UTC	free
142	2025-02-21 03:00:00+03:30	2025-02-21 04:30:00+03:30	t	5	Asia/Tehran	free
695	2025-02-25 03:30:00+03:30	2025-02-26 03:30:00+03:30	t	3	UTC	free
144	2025-02-27 16:00:00+03:30	2025-02-27 17:00:00+03:30	t	5	Asia/Tehran	free
145	2025-02-26 18:30:00+03:30	2025-02-26 19:30:00+03:30	t	5	UTC	free
146	2025-03-01 14:30:00+03:30	2025-03-01 15:30:00+03:30	t	5	UTC	free
147	2025-02-24 14:30:00+03:30	2025-02-24 15:30:00+03:30	t	5	UTC	free
148	2025-02-23 17:30:00+03:30	2025-02-23 18:30:00+03:30	t	5	UTC	free
697	2025-02-27 03:30:00+03:30	2025-02-28 03:30:00+03:30	t	3	UTC	free
698	2025-02-28 03:30:00+03:30	2025-03-01 03:30:00+03:30	t	3	UTC	free
699	2025-03-01 03:30:00+03:30	2025-03-02 03:30:00+03:30	t	3	UTC	free
167	2025-04-23 04:00:00+04:30	2025-04-23 05:00:00+04:30	t	5	Asia/Tehran	free
168	2025-04-25 23:00:00+04:30	2025-04-26 00:00:00+04:30	t	5	Asia/Tehran	free
180	2025-03-10 02:30:00+03:30	2025-03-10 03:30:00+03:30	t	5	Asia/Tehran	free
716	2025-03-04 03:30:00+03:30	2025-03-05 03:30:00+03:30	t	3	UTC	free
718	2025-03-06 03:30:00+03:30	2025-03-07 03:30:00+03:30	t	3	UTC	free
158	2025-02-14 11:30:00+03:30	2025-02-14 12:30:00+03:30	t	5	Asia/Tehran	free
160	2025-02-14 14:30:00+03:30	2025-02-14 15:30:00+03:30	t	5	Asia/Tehran	free
163	2025-03-13 22:30:00+03:30	2025-03-13 23:30:00+03:30	t	5	Asia/Tehran	free
164	2025-03-11 21:00:00+03:30	2025-03-11 22:00:00+03:30	t	5	Asia/Tehran	free
181	2025-03-11 02:30:00+03:30	2025-03-11 03:30:00+03:30	t	5	Asia/Tehran	free
182	2025-03-12 02:30:00+03:30	2025-03-12 03:30:00+03:30	t	5	Asia/Tehran	free
183	2025-03-13 02:30:00+03:30	2025-03-13 03:30:00+03:30	t	5	Asia/Tehran	free
184	2025-03-14 02:30:00+03:30	2025-03-14 03:30:00+03:30	t	5	Asia/Tehran	free
185	2025-03-15 02:30:00+03:30	2025-03-15 03:30:00+03:30	t	5	Asia/Tehran	free
188	2025-03-31 02:00:00+04:30	2025-03-31 03:00:00+04:30	t	5	Asia/Tehran	free
189	2025-03-30 02:00:00+04:30	2025-03-30 03:00:00+04:30	t	5	Asia/Tehran	free
190	2025-04-01 03:00:00+04:30	2025-04-01 04:00:00+04:30	t	5	Asia/Tehran	free
191	2025-04-01 04:00:00+04:30	2025-04-01 05:00:00+04:30	t	5	Asia/Tehran	free
192	2025-04-02 04:00:00+04:30	2025-04-02 05:00:00+04:30	t	5	Asia/Tehran	free
193	2025-04-03 04:00:00+04:30	2025-04-03 05:00:00+04:30	t	5	Asia/Tehran	free
194	2025-04-04 04:00:00+04:30	2025-04-04 05:00:00+04:30	t	5	Asia/Tehran	free
187	2025-04-01 02:00:00+04:30	2025-04-01 03:00:00+04:30	t	5	Asia/Tehran	free
195	2025-04-05 04:00:00+04:30	2025-04-05 05:00:00+04:30	t	5	Asia/Tehran	free
196	2025-03-30 02:00:00+04:30	2025-03-30 03:00:00+04:30	t	5	Asia/Tehran	free
197	2025-03-30 02:00:00+04:30	2025-03-30 03:00:00+04:30	t	5	Asia/Tehran	free
198	2025-04-02 05:00:00+04:30	2025-04-02 06:00:00+04:30	t	5	Asia/Tehran	free
199	2025-04-02 06:00:00+04:30	2025-04-02 07:00:00+04:30	t	5	Asia/Tehran	free
200	2025-04-03 03:00:00+04:30	2025-04-03 04:00:00+04:30	t	5	Asia/Tehran	free
201	2025-04-04 02:00:00+04:30	2025-04-04 03:00:00+04:30	t	5	Asia/Tehran	free
720	2025-03-08 03:30:00+03:30	2025-03-09 03:30:00+03:30	t	3	UTC	free
231	2025-04-08 04:00:00+04:30	2025-04-08 05:00:00+04:30	t	5	Asia/Tehran	free
232	2025-04-07 03:00:00+04:30	2025-04-07 04:00:00+04:30	t	5	Asia/Tehran	free
233	2025-04-07 06:00:00+04:30	2025-04-07 07:00:00+04:30	t	5	Asia/Tehran	free
234	2025-04-10 05:30:00+04:30	2025-04-10 06:30:00+04:30	t	5	Asia/Tehran	free
206	2025-04-12 01:30:00+04:30	2025-04-12 02:30:00+04:30	t	5	Asia/Tehran	free
746	2025-03-03 14:00:00+03:30	2025-03-03 15:00:00+03:30	t	4	Iran	free
207	2025-04-12 20:30:00+04:30	2025-04-12 21:30:00+04:30	t	5	Asia/Tehran	free
208	2025-04-11 20:30:00+04:30	2025-04-11 21:30:00+04:30	t	5	Asia/Tehran	free
235	2025-04-12 18:00:00+04:30	2025-04-12 19:00:00+04:30	t	5	Asia/Tehran	free
236	2025-04-11 17:30:00+04:30	2025-04-11 18:30:00+04:30	t	5	Asia/Tehran	free
211	2025-04-12 22:30:00+04:30	2025-04-12 23:30:00+04:30	t	5	Asia/Tehran	free
237	2025-04-12 16:30:00+04:30	2025-04-12 17:30:00+04:30	t	5	Asia/Tehran	free
213	2025-04-09 22:00:00+04:30	2025-04-09 23:00:00+04:30	t	5	Asia/Tehran	free
238	2025-04-10 16:30:00+04:30	2025-04-10 17:30:00+04:30	t	5	Asia/Tehran	free
217	2025-04-08 22:30:00+04:30	2025-04-08 23:30:00+04:30	t	5	Asia/Tehran	free
218	2025-04-07 23:00:00+04:30	2025-04-08 00:00:00+04:30	t	5	Asia/Tehran	free
219	2025-04-08 00:00:00+04:30	2025-04-08 01:00:00+04:30	t	5	Asia/Tehran	free
239	2025-04-12 19:00:00+04:30	2025-04-12 20:00:00+04:30	t	5	Asia/Tehran	free
240	2025-04-09 19:00:00+04:30	2025-04-09 20:00:00+04:30	t	5	Asia/Tehran	free
223	2025-04-11 21:30:00+04:30	2025-04-11 22:30:00+04:30	t	5	Asia/Tehran	free
224	2025-04-12 00:00:00+04:30	2025-04-12 01:00:00+04:30	t	5	Asia/Tehran	free
225	2025-04-13 00:00:00+04:30	2025-04-13 01:00:00+04:30	t	5	Asia/Tehran	free
259	2025-02-15 13:00:00+03:30	2025-02-15 14:00:00+03:30	t	5	Asia/Tehran	free
229	2025-04-09 04:30:00+04:30	2025-04-09 05:30:00+04:30	t	5	Asia/Tehran	free
230	2025-04-09 02:30:00+04:30	2025-04-09 03:30:00+04:30	t	5	Asia/Tehran	free
241	2025-02-15 01:00:00+03:30	2025-02-15 02:00:00+03:30	t	5	Asia/Tehran	free
242	2025-02-25 01:00:00+03:30	2025-02-25 02:00:00+03:30	t	5	Asia/Tehran	free
243	2025-02-24 06:30:00+03:30	2025-02-24 07:30:00+03:30	t	5	UTC	free
260	2025-02-15 09:30:00+03:30	2025-02-15 10:30:00+03:30	t	5	Asia/Tehran	free
245	2025-02-25 07:30:00+03:30	2025-02-25 08:30:00+03:30	t	5	UTC	free
246	2025-02-26 08:30:00+03:30	2025-02-26 09:30:00+03:30	t	5	UTC	free
248	2025-02-24 08:30:00+03:30	2025-02-24 09:30:00+03:30	t	5	UTC	free
249	2025-02-16 04:00:00+03:30	2025-02-16 05:00:00+03:30	t	5	Asia/Tehran	free
251	2025-02-18 04:00:00+03:30	2025-02-18 05:00:00+03:30	t	5	Asia/Tehran	free
253	2025-02-19 03:00:00+03:30	2025-02-19 04:00:00+03:30	t	5	Asia/Tehran	free
556	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
557	2025-02-19 06:00:00+03:30	2025-02-19 07:00:00+03:30	t	3	UTC	free
558	2025-02-19 04:00:00+03:30	2025-02-19 05:00:00+03:30	t	3	UTC	free
256	2025-02-15 16:00:00+03:30	2025-02-15 17:00:00+03:30	t	5	Asia/Tehran	free
261	2025-03-02 03:30:00+03:30	2025-03-09 03:29:00+03:30	t	5	UTC	free
258	2025-03-19 19:30:00+03:30	2025-03-19 20:30:00+03:30	t	5	Asia/Tehran	free
262	2025-02-22 00:00:00+03:30	2025-02-22 01:00:00+03:30	t	5	Asia/Tehran	free
263	2025-03-01 02:00:00+03:30	2025-03-01 03:00:00+03:30	t	5	Asia/Tehran	free
264	2025-02-17 20:30:00+03:30	2025-02-17 22:00:00+03:30	t	5	Pacific/Kosrae	free
265	2025-02-20 04:00:00+03:30	2025-02-20 06:00:00+03:30	t	5	Turkey	free
266	2025-02-17 06:30:00+03:30	2025-02-17 08:30:00+03:30	t	5	Turkey	free
267	2025-02-17 01:30:00+03:30	2025-02-17 03:30:00+03:30	t	5	Turkey	free
268	2025-02-19 06:00:00+03:30	2025-02-19 07:00:00+03:30	t	3	UTC	free
269	2025-02-21 07:30:00+03:30	2025-02-21 08:30:00+03:30	t	3	UTC	free
272	2025-02-18 08:30:00+03:30	2025-02-18 10:00:00+03:30	t	3	UTC	free
273	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
279	2025-02-21 22:30:00+03:30	2025-02-22 00:00:00+03:30	t	3	Iran	free
281	2025-02-19 04:00:00+03:30	2025-02-19 05:00:00+03:30	t	3	Iran	free
285	2025-02-19 10:00:00+03:30	2025-02-19 11:00:00+03:30	t	3	Iran	free
284	2025-02-18 02:00:00+03:30	2025-02-18 08:00:00+03:30	t	3	Iran	free
287	2025-02-19 10:00:00+03:30	2025-02-19 11:00:00+03:30	t	3	Iran	free
293	2025-02-19 03:30:00+03:30	2025-02-20 03:30:00+03:30	t	3	GMT	free
742	2025-03-01 08:30:00+03:30	2025-03-01 12:30:00+03:30	t	4	UTC	free
747	2025-03-07 19:30:00+03:30	2025-03-07 21:30:00+03:30	t	5	UTC	free
674	2025-02-23 22:30:00+03:30	2025-02-23 23:30:00+03:30	t	3	UTC	free
728	2025-03-16 03:30:00+03:30	2025-03-17 03:30:00+03:30	t	3	UTC	free
729	2025-03-10 03:30:00+03:30	2025-03-11 03:30:00+03:30	t	3	UTC	free
730	2025-03-11 03:30:00+03:30	2025-03-12 03:30:00+03:30	t	3	UTC	free
731	2025-03-12 03:30:00+03:30	2025-03-13 03:30:00+03:30	t	3	UTC	free
732	2025-03-13 03:30:00+03:30	2025-03-14 03:30:00+03:30	t	3	UTC	free
733	2025-03-14 03:30:00+03:30	2025-03-15 03:30:00+03:30	t	3	UTC	free
425	2025-02-17 05:30:00+03:30	2025-02-17 06:30:00+03:30	t	3	UTC	free
428	2025-02-18 08:30:00+03:30	2025-02-18 10:00:00+03:30	t	3	UTC	free
429	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
435	2025-02-20 14:00:00+03:30	2025-02-20 15:00:00+03:30	t	3	UTC	free
667	2025-02-23 18:30:00+03:30	2025-02-23 20:30:00+03:30	t	3	UTC	free
668	2025-02-23 20:30:00+03:30	2025-02-23 22:30:00+03:30	t	3	UTC	free
676	2025-02-23 23:30:00+03:30	2025-02-24 01:30:00+03:30	t	3	UTC	free
745	2025-03-05 10:00:00+03:30	2025-03-05 15:00:00+03:30	t	4	Iran	free
610	2025-02-17 13:00:00+03:30	2025-02-17 14:30:00+03:30	t	3	UTC	free
611	2025-02-18 02:00:00+03:30	2025-02-17 08:00:00+03:30	t	3	UTC	free
612	2025-02-18 08:30:00+03:30	2025-02-18 10:00:00+03:30	t	3	UTC	free
613	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
614	2025-02-18 08:30:00+03:30	2025-02-18 10:00:00+03:30	t	3	UTC	free
615	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
616	2025-02-18 08:30:00+03:30	2025-02-18 10:00:00+03:30	t	3	UTC	free
617	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
618	2025-02-18 08:30:00+03:30	2025-02-18 10:00:00+03:30	t	3	UTC	free
619	2025-02-18 11:30:00+03:30	2025-02-18 13:00:00+03:30	t	3	UTC	free
624	2025-02-19 10:00:00+03:30	2025-02-19 11:00:00+03:30	t	3	UTC	free
639	2025-02-19 03:30:00+03:30	2025-02-19 03:30:00+03:30	t	3	UTC	free
650	2025-02-21 12:00:00+03:30	2025-02-21 13:00:00+03:30	t	3	UTC	free
653	2025-02-22 06:00:00+03:30	2025-02-22 07:00:00+03:30	t	3	UTC	free
\.


--
-- Name: ap2_meeting_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_availability_id_seq', 747, true);


--
-- Data for Name: ap2_meeting_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_review (id, message, create_date, last_modified, student_id, tutor_id, session_id, status, rate_session, rate_tutor, is_published, dislike_count, like_count) FROM stdin;
4	This is the second time which I have class with her. Amazing.	2025-02-25 22:29:59.047833+03:30	2025-02-05 22:29:59+03:30	3	1	57	pending	5	5	f	0	0
2	Hello	2025-02-25 22:25:29.763326+03:30	2025-02-22 22:25:29+03:30	9	3	157	published	3	4	t	0	0
11	Satisfied conveying a dependent contented he gentleman agreeable do be. Warrant private blushes removed an in equally totally if. Delivered dejection necessary objection do Mr prevailed. Mr feeling does chiefly cordial in do. Satisfied conveying a dependent contented he gentleman agreeable do be	2025-03-22 15:00:58.32572+04:30	2025-03-22 14:59:45+04:30	21	34	61	pending	4	5	f	1	56
12	Louis was an amazing and not repetitive tutor for me. He is not only a teacher but also a great friend in other aspect of life. Thank you very much to have you my dear teacher.	2025-03-24 18:04:13.521788+04:30	2025-03-24 18:04:13+04:30	3	4	83	published	5	5	t	0	0
10	Hello dear Amanda. You are the best tutor that I know forever.\r\n many many thanks for your considerations in your classes and all the amazing notes which you learned me. \r\n\r\nwith the best wishes.	2025-03-22 14:47:23.746165+04:30	2025-03-22 14:37:29+04:30	19	5	4	pending	4	5	f	3	10
3	Hi, Cynthia is a great teacher. Thanks.	2025-02-25 22:28:51.621977+03:30	2020-02-25 22:28:51+03:30	3	1	64	pending	4	5	f	0	0
9	Satisfied conveying a dependent contented he gentleman agreeable do be. Warrant private blushes removed an in equally totally if. Delivered dejection necessary objection do Mr prevailed. Mr feeling does chiefly cordial in do.\r\n\r\nSatisfied conveying a dependent contented he gentleman agreeable do be	2025-03-22 14:29:58.917608+04:30	2025-03-19 13:28:20+03:30	14	5	5	published	5	4	t	1	6
8	Thanks dear professor. I can't wait for the next session.	2025-02-26 17:35:00.352076+03:30	2024-02-26 17:35:00+03:30	2	5	130	published	5	2	t	2	25
7	Fabulous teacher is Cynthia. Thank you.	2025-02-26 17:07:49.280182+03:30	2025-01-26 17:07:49+03:30	2	1	129	published	5	5	t	0	0
6	This group class was amazing. thanks dear Louis.This group class was amazing. thanks dear Louis.This group class was amazing. thanks dear Louis.This group class was amazing. thanks dear Louis.This group class was amazing. thanks dear Louis.This group class was amazing. thanks dear Louis.	2025-02-26 15:33:55.001084+03:30	2025-01-20 15:33:55+03:30	2	4	2	published	5	4	t	0	0
5	fabulous	2025-02-26 14:09:46.107693+03:30	2025-02-20 14:09:46+03:30	3	4	84	published	4	3	t	0	0
13	great. Awesome\r\n	2025-03-24 20:29:51.416715+04:30	2025-03-24 20:29:51.416715+04:30	3	1	123	published	5	5	t	0	0
14	Amazing Dance class\r\n\r\nThanks	2025-03-25 00:39:58.642442+04:30	2025-03-25 00:38:46+04:30	21	31	161	published	4	4	t	0	0
\.


--
-- Name: ap2_meeting_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_review_id_seq', 14, true);


--
-- Data for Name: ap2_meeting_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_session (id, subject, session_type, start_session_utc, end_session_utc, tutor_id, status, is_rescheduled, rescheduled_at, rescheduled_by_id, tutor_timezone, students_timezone, rating, appointment_id, cost) FROM stdin;
1	Cooking	private	2025-01-29 13:13:44+03:30	2025-01-29 13:13:44+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
3	Cooking	private	2025-01-29 20:42:35+03:30	2025-01-29 20:42:37+03:30	6	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
4	Cooking	group	2025-01-29 20:48:08+03:30	2025-01-29 20:48:21+03:30	5	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
5	English Class	private	2025-01-31 04:25:00+03:30	2025-01-31 04:14:00+03:30	6	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
6	English Class	private	2025-01-31 04:25:00+03:30	2025-01-31 04:14:00+03:30	6	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
21	Physics	group	2025-01-30 02:41:08+03:30	2025-01-30 02:41:08+03:30	5	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
22	Piano	group	2025-01-30 02:41:33+03:30	2025-01-30 02:41:33+03:30	5	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
36	English Class	private	2025-01-31 01:14:56+03:30	2025-01-31 04:14:00+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
37	English Class	private	2025-01-31 04:25:00+03:30	2025-01-31 01:14:56+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
38	English Class	private	2025-01-31 03:30:00+03:30	2025-01-31 04:30:00+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
39	English Class	private	2025-02-05 04:30:00+03:30	2025-02-05 06:00:00+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
40	English Class	private	2025-02-07 03:30:00+03:30	2025-02-07 05:00:00+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
41	English Class	private	2025-02-06 03:30:00+03:30	2025-02-06 05:00:00+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
42	English Class	private	2025-01-31 03:30:00+03:30	2025-01-31 05:00:00+03:30	6	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
43	English Class	private	2025-01-27 07:30:00+03:30	2025-01-27 09:00:00+03:30	6	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
44	English Class	private	2025-02-03 21:30:00+03:30	2025-02-03 23:00:00+03:30	4	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
45	English Class	private	2025-02-01 03:30:00+03:30	2025-02-01 05:00:00+03:30	2	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
46	English Class	private	2025-02-01 04:00:00+03:30	2025-02-01 05:30:00+03:30	2	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
47	English Class	private	2025-02-01 05:30:00+03:30	2025-02-01 07:00:00+03:30	2	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
48	English Class	private	2025-01-29 21:00:00+03:30	2025-01-29 22:30:00+03:30	2	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
49	English Class	private	2025-01-27 00:30:00+03:30	2025-01-27 02:00:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
50	English Class	private	2025-01-29 08:30:00+03:30	2025-01-29 10:00:00+03:30	4	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
51	Piano Class (Test)	private	2025-02-07 01:00:00+03:30	2025-02-07 01:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
52	Piano Class (Test)	private	2025-02-04 10:30:00+03:30	2025-02-04 11:00:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
54	Piano Class (Test)	private	2025-02-04 11:00:00+03:30	2025-02-04 11:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
55	Piano Class (Test)	private	2025-02-06 13:30:00+03:30	2025-02-06 14:00:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
53	Piano Class (Test)	private	2025-02-04 11:30:00+03:30	2025-02-04 12:00:00+03:30	1	cancelled	f	\N	\N	UTC	UTC	\N	348813	0.00
56	Piano Class (Test)	private	2025-02-06 16:00:00+03:30	2025-02-06 16:30:00+03:30	1	confirmed	f	\N	\N	UTC	UTC	\N	348813	0.00
57	Piano Class (Test)	private	2025-02-08 15:30:00+03:30	2025-02-08 16:00:00+03:30	1	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
58	Piano Class (Test)	private	2025-02-07 03:00:00+03:30	2025-02-07 03:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
59	Piano Class (Test)	private	2025-02-05 21:30:00+03:30	2025-02-05 22:00:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
60	Piano Class (Test)	private	2025-02-06 01:00:00+03:30	2025-02-06 01:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
61	Piano Class (Test)	private	2025-02-09 00:00:00+03:30	2025-02-09 00:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
62	Piano Class (Test)	private	2025-02-03 19:00:00+03:30	2025-02-03 19:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
63	Piano Class (Test)	private	2025-02-06 18:00:00+03:30	2025-02-06 18:30:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
65	Piano Class (Test)	private	2025-02-07 21:30:00+03:30	2025-02-07 22:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
66	Piano Class (Test)	private	2025-02-04 22:00:00+03:30	2025-02-04 22:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
67	Piano Class (Test)	private	2025-02-04 02:00:00+03:30	2025-02-04 02:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
68	Piano Class (Test)	private	2025-02-04 04:00:00+03:30	2025-02-04 04:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
69	Piano Class (Test)	private	2025-02-07 15:00:00+03:30	2025-02-07 15:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
70	Piano Class (Test)	private	2025-02-04 18:00:00+03:30	2025-02-04 18:30:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
71	Piano Class (Test)	private	2025-02-04 17:00:00+03:30	2025-02-04 17:30:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
72	Piano Class (Test)	private	2025-02-04 17:30:00+03:30	2025-02-04 18:00:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
73	Piano Class (Test)	private	2025-02-03 17:30:00+03:30	2025-02-03 18:00:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
74	Piano Class (Test)	private	2025-02-03 18:00:00+03:30	2025-02-03 18:30:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
75	Piano Class (Test)	private	2025-02-03 15:30:00+03:30	2025-02-03 16:00:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
76	Piano Class (Test)	private	2025-02-03 16:00:00+03:30	2025-02-03 16:30:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
77	Piano Class (Test)	private	2025-02-07 19:30:00+03:30	2025-02-07 20:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
78	Piano Class (Test)	private	2025-02-07 20:00:00+03:30	2025-02-07 20:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
79	Piano Class (Test)	private	2025-02-07 20:30:00+03:30	2025-02-07 21:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
80	Piano Class (Test)	private	2025-02-07 21:00:00+03:30	2025-02-07 21:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
81	Piano Class (Test)	private	2025-02-04 20:00:00+03:30	2025-02-04 20:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
82	Piano Class (Test)	private	2025-02-04 20:30:00+03:30	2025-02-04 21:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
84	Piano Class (Test)	private	2025-02-11 17:30:00+03:30	2025-02-11 18:00:00+03:30	4	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
83	Piano Class (Test)	private	2025-02-11 17:00:00+03:30	2025-02-11 17:30:00+03:30	4	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
20	English Class	private	2025-01-06 15:00:00+03:30	2025-01-06 15:30:00+03:30	4	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
12	English Class	private	2025-01-06 14:30:00+03:30	2025-01-06 15:00:00+03:30	4	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
13	English Class	private	2025-01-01 15:00:00+03:30	2025-01-01 15:30:00+03:30	6	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
11	English Class	private	2025-01-01 14:30:00+03:30	2025-01-01 15:00:00+03:30	2	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
8	English Class	private	2025-01-06 14:30:00+03:30	2025-01-06 15:00:00+03:30	5	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
10	English Class	private	2025-01-06 15:00:00+03:30	2025-01-06 15:30:00+03:30	5	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
7	English Class	private	2025-01-01 14:30:00+03:30	2025-01-01 15:00:00+03:30	5	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
19	English Class	private	2025-01-01 15:00:00+03:30	2025-01-01 15:30:00+03:30	1	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
9	English Class	private	2025-01-01 15:00:00+03:30	2025-01-01 15:30:00+03:30	5	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
2	Math	group	2025-01-29 20:42:11+03:30	2025-01-29 21:42:11+03:30	4	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
113	Piano Class (Test)	private	2025-02-05 00:30:00+03:30	2025-02-05 01:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
114	Piano Class (Test)	private	2025-02-05 01:00:00+03:30	2025-02-05 01:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
115	Piano Class (Test)	private	2025-02-05 01:30:00+03:30	2025-02-05 02:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
116	Piano Class (Test)	private	2025-02-05 02:00:00+03:30	2025-02-05 02:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
117	Piano Class (Test)	private	2025-02-05 02:30:00+03:30	2025-02-05 03:00:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
118	Piano Class (Test)	private	2025-02-05 03:00:00+03:30	2025-02-05 03:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
119	Piano Class (Test)	private	2025-02-07 04:30:00+03:30	2025-02-07 05:00:00+03:30	1	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
107	Piano Class (Test)	private	2025-02-04 15:00:00+03:30	2025-02-04 15:30:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
108	Piano Class (Test)	private	2025-02-04 15:30:00+03:30	2025-02-04 16:00:00+03:30	4	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
127	Piano Class (Test)	private	2025-02-05 14:30:00+03:30	2025-02-05 15:30:00+03:30	3	pending	f	\N	\N	UTC	UTC	\N	348813	0.00
128	Piano Class (Test)	private	2025-02-14 01:30:00+03:30	2025-02-14 02:30:00+03:30	1	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
131	Piano Class (Test)	private	2025-02-12 06:30:00+03:30	2025-02-12 07:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
132	Piano Class (Test)	private	2025-02-12 18:00:00+03:30	2025-02-12 19:00:00+03:30	5	confirmed	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
130	Piano Class (Test)	private	2025-02-12 03:00:00+03:30	2025-02-12 04:00:00+03:30	5	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
129	Piano Class (Test)	private	2025-02-10 01:30:00+03:30	2025-02-10 02:30:00+03:30	1	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
133	Piano Class (Test)	private	2025-03-05 00:30:00+03:30	2025-03-05 01:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
134	Piano Class (Test)	private	2025-03-06 02:00:00+03:30	2025-03-06 03:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
135	Piano Class (Test)	private	2025-03-08 01:30:00+03:30	2025-03-08 02:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
136	Piano Class (Test)	private	2025-03-04 04:00:00+03:30	2025-03-04 05:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
137	Piano Class (Test)	private	2025-03-01 02:00:00+03:30	2025-03-01 03:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
138	Piano Class (Test)	private	2025-03-06 04:30:00+03:30	2025-03-06 05:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
139	Piano Class (Test)	private	2025-03-05 06:00:00+03:30	2025-03-05 07:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
140	Piano Class (Test)	private	2025-03-07 06:00:00+03:30	2025-03-07 07:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
141	Piano Class (Test)	private	2025-02-20 03:00:00+03:30	2025-02-20 04:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
142	Piano Class (Test)	private	2025-03-04 01:00:00+03:30	2025-03-04 02:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
143	Piano Class (Test)	private	2025-03-08 00:00:00+03:30	2025-03-08 01:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
144	Piano Class (Test)	private	2025-03-06 00:30:00+03:30	2025-03-06 01:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
145	Piano Class (Test)	private	2025-02-16 04:00:00+03:30	2025-02-16 05:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
146	Piano Class (Test)	private	2025-04-04 04:00:00+04:30	2025-04-04 05:00:00+04:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
147	Piano Class (Test)	private	2025-03-02 07:30:00+03:30	2025-03-02 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
148	Piano Class (Test)	private	2025-03-03 07:30:00+03:30	2025-03-03 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
149	Piano Class (Test)	private	2025-03-04 07:30:00+03:30	2025-03-04 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
150	Piano Class (Test)	private	2025-03-05 07:30:00+03:30	2025-03-05 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
151	Piano Class (Test)	private	2025-03-06 07:30:00+03:30	2025-03-06 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
152	Piano Class (Test)	private	2025-03-07 07:30:00+03:30	2025-03-07 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
153	Piano Class (Test)	private	2025-03-08 07:30:00+03:30	2025-03-08 08:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
154	Piano Class (Test)	private	2025-03-05 09:30:00+03:30	2025-03-05 10:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
155	Piano Class (Test)	private	2025-03-05 11:00:00+03:30	2025-03-05 12:00:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
156	Piano Class (Test)	private	2025-03-05 12:30:00+03:30	2025-03-05 13:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
157	Piano Class (Test)	private	2025-02-28 04:30:00+03:30	2025-02-28 05:30:00+03:30	3	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
158	Piano Class (Test)	private	2025-02-25 04:30:00+03:30	2025-02-25 05:30:00+03:30	3	pending	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
64	Piano Class (Test)	private	2025-02-15 03:30:00+03:30	2025-02-15 04:00:00+03:30	1	finished	f	\N	\N	UTC	Europe/Dublin	\N	348813	0.00
111	Piano Class (Test)	private	2025-02-04 20:00:00+03:30	2025-02-04 20:30:00+03:30	4	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
112	Piano Class (Test)	private	2025-02-04 20:30:00+03:30	2025-02-04 21:00:00+03:30	4	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
109	Piano Class (Test)	private	2025-02-04 19:00:00+03:30	2025-02-04 19:30:00+03:30	4	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
110	Piano Class (Test)	private	2025-02-04 19:30:00+03:30	2025-02-04 20:00:00+03:30	4	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
125	Piano Class (Test)	private	2025-02-07 18:30:00+03:30	2025-02-07 19:30:00+03:30	1	finished	f	\N	\N	UTC	Europe/Berlin	\N	348813	0.00
126	Piano Class (Test)	private	2025-02-06 07:00:00+03:30	2025-02-06 08:00:00+03:30	1	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
122	Piano Class (Test)	private	2025-02-07 08:30:00+03:30	2025-02-07 10:00:00+03:30	1	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
124	Piano Class (Test)	private	2025-02-07 13:30:00+03:30	2025-02-07 14:30:00+03:30	1	finished	f	\N	\N	UTC	Europe/Berlin	\N	348813	0.00
123	Piano Class (Test)	private	2025-02-07 11:30:00+03:30	2025-02-07 12:30:00+03:30	1	finished	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
120	Piano Class (Test)	private	2025-02-07 05:00:00+03:30	2025-02-07 05:30:00+03:30	1	finished	f	\N	\N	UTC	UTC	\N	348813	0.00
159	Piano Class (Test)	private	2025-03-13 02:30:00+03:30	2025-03-13 03:30:00+03:30	5	pending	f	\N	\N	UTC	Asia/Tehran	\N	156561	0.00
121	Piano Class (Test)	private	2025-02-07 06:30:00+03:30	2025-02-07 08:00:00+03:30	1	confirmed	f	\N	\N	UTC	Asia/Tehran	\N	348813	0.00
160	Spanish Class	private	2025-03-28 23:41:01+04:30	2025-03-29 00:41:01+04:30	31	scheduled	f	\N	\N	UTC	UTC	\N	173942	10.00
161	Online Dance	private	2025-04-07 23:44:12+04:30	2025-04-08 00:44:12+04:30	33	finished	f	\N	\N	UTC	UTC	\N	508727	0.00
\.


--
-- Name: ap2_meeting_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_session_id_seq', 161, true);


--
-- Data for Name: ap2_meeting_session_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_session_reviews (id, session_id, review_id) FROM stdin;
\.


--
-- Name: ap2_meeting_session_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_session_reviews_id_seq', 1, false);


--
-- Data for Name: ap2_meeting_session_students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_session_students (id, session_id, student_id) FROM stdin;
1	1	1
2	2	2
3	2	3
4	3	4
5	4	2
6	4	3
7	4	4
8	5	1
9	6	1
10	7	3
11	8	3
12	9	3
13	10	3
14	11	3
15	12	3
16	13	3
22	19	3
23	20	3
24	21	1
25	21	2
26	22	2
27	22	4
33	36	6
34	37	6
35	38	6
36	39	6
37	40	6
38	41	6
39	42	6
40	43	6
41	44	6
42	45	6
43	46	6
44	47	6
45	48	6
46	49	6
47	50	6
48	51	3
49	52	3
50	53	3
51	54	3
52	55	3
53	56	3
54	57	3
55	58	3
56	59	3
57	60	3
58	61	3
59	62	3
60	63	3
61	64	3
62	65	3
63	66	3
64	67	3
65	68	3
66	69	3
67	70	3
68	71	3
69	72	3
70	73	3
71	74	3
72	75	3
73	76	3
74	77	3
75	78	3
76	79	3
77	80	3
78	81	3
79	82	3
80	83	3
81	84	3
104	107	3
105	108	3
106	109	3
107	110	3
108	111	3
109	112	3
110	113	3
111	114	3
112	115	3
113	116	3
114	117	3
115	118	3
116	119	3
117	120	3
118	121	3
119	122	3
120	123	3
121	124	3
122	125	3
123	126	3
124	127	3
125	128	2
126	129	2
127	130	2
128	131	2
129	132	2
130	133	2
131	134	2
132	135	2
133	136	2
134	137	2
135	138	2
136	139	2
137	140	2
138	141	2
139	142	2
140	143	2
141	144	2
142	145	2
143	146	2
144	147	2
145	148	2
146	149	2
147	150	2
148	151	2
149	152	2
150	153	2
151	154	2
152	155	2
153	156	2
154	157	9
155	158	9
156	159	4
157	160	21
158	161	21
\.


--
-- Name: ap2_meeting_session_students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_session_students_id_seq', 158, true);


--
-- Data for Name: ap2_student_cnotification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_cnotification (id, type, seen, date, appointment_id, client_id) FROM stdin;
\.


--
-- Name: ap2_student_cnotification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_cnotification_id_seq', 1, false);


--
-- Data for Name: ap2_student_student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_student (id, major, session_count, tutor_count, profile_id) FROM stdin;
1	Math	0	0	5
2	\N	0	0	2
5	Arts	0	0	16
6	\N	0	0	17
7	\N	0	0	18
8	\N	0	0	19
9	\N	0	0	20
4	\N	0	0	15
3	\N	0	0	1
10	IT consultant	19	3	37
11	Insurance claims handler	33	3	39
12	Engineering geologist	45	0	40
13	Investment banker, operational	34	9	43
14	Claims inspector/assessor	26	0	44
15	Race relations officer	16	2	45
16	Administrator	5	10	46
17	Psychologist, occupational	46	8	49
18	Museum/gallery conservator	46	6	50
19	Chartered management accountant	14	1	52
20	Conservation officer, nature	36	2	54
21	Chief Technology Officer	12	6	56
\.


--
-- Name: ap2_student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_student_id_seq', 21, true);


--
-- Data for Name: ap2_student_student_interests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_student_interests (id, student_id, subject_id) FROM stdin;
\.


--
-- Name: ap2_student_student_interests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_student_interests_id_seq', 1, false);


--
-- Data for Name: ap2_student_subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_subject (id, name) FROM stdin;
\.


--
-- Name: ap2_student_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_subject_id_seq', 1, false);


--
-- Data for Name: ap2_student_wishlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_wishlist (id, created_at, student_id, tutor_id) FROM stdin;
\.


--
-- Name: ap2_student_wishlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_wishlist_id_seq', 1, false);


--
-- Name: ap2_tutor_languagelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_languagelevel_id_seq', 6, true);


--
-- Data for Name: ap2_tutor_pnotification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_pnotification (id, type, seen, date, appointment_id, provider_id) FROM stdin;
\.


--
-- Name: ap2_tutor_pnotification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_pnotification_id_seq', 1, false);


--
-- Data for Name: ap2_tutor_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_skill (id, name) FROM stdin;
1	Persian
2	Chinese
3	Math
4	Piano
5	Physics
6	German
7	French
8	Turkish
9	Spanish
10	English
11	Hindi
\.


--
-- Name: ap2_tutor_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_skill_id_seq', 11, true);


--
-- Data for Name: ap2_tutor_skilllevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_skilllevel (id, name) FROM stdin;
1	A1
2	A2
3	B1
4	B2
5	C1
6	C2
\.


--
-- Data for Name: ap2_tutor_tutor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_tutor (id, video_url, cost_trial, cost_hourly, session_count, student_count, course_count, create_date, last_modified, profile_id, discount, discount_deadline) FROM stdin;
14	http://soto-campbell.info/	36.70	16.66	92	10	5	2025-03-18 16:43:58.089545+03:30	2025-03-18 16:43:58.088545+03:30	57	0	\N
16	http://smith-pollard.com/	20.49	81.07	38	45	8	2025-03-18 18:37:03.424134+03:30	2025-03-18 18:37:03.424134+03:30	59	0	\N
17	https://www.golden.com/	42.50	78.99	96	38	5	2025-03-18 18:37:06.15129+03:30	2025-03-18 18:37:06.15029+03:30	60	0	\N
20	https://holloway-prince.com/	32.88	45.20	13	25	18	2025-03-18 18:37:14.704779+03:30	2025-03-18 18:37:14.703779+03:30	63	0	\N
21	http://www.kelley.net/	11.10	80.15	26	35	19	2025-03-18 18:37:17.398933+03:30	2025-03-18 18:37:17.398933+03:30	64	0	\N
22	http://www.riley.com/	31.27	20.66	96	39	10	2025-03-18 18:37:19.990081+03:30	2025-03-18 18:37:19.990081+03:30	65	0	\N
23	https://bauer-weaver.net/	30.91	30.36	7	23	6	2025-03-18 18:37:22.806242+03:30	2025-03-18 18:37:22.806242+03:30	66	0	\N
27	http://www.pham.com/	9.05	81.46	12	30	5	2025-03-18 18:37:34.881933+03:30	2025-03-18 18:37:34.881933+03:30	70	0	\N
29	https://riley.com/	20.21	77.21	75	31	16	2025-03-18 18:37:40.120233+03:30	2025-03-18 18:37:40.119233+03:30	72	0	\N
18	http://hudson.com/	34.73	38.42	79	31	8	2025-03-18 18:37:09.006453+03:30	2025-03-21 22:21:54.233929+03:30	61	15	\N
15	https://williams-bell.com/	44.93	24.66	82	14	18	2025-03-18 18:37:00.438963+03:30	2025-03-21 22:21:54.240929+03:30	58	75	\N
6		5.00	30.00	98	24	2	2025-01-29 12:39:54.552208+03:30	2025-03-22 03:58:10.080126+04:30	10	50	2025-03-26 03:57:59+04:30
3		10.00	24.00	156	89	259	2025-01-29 12:39:39.516363+03:30	2025-03-22 03:58:10.097127+04:30	7	15	2025-03-22 03:58:07+04:30
32	https://www.arias.com/	4.38	12.38	70	3	2	2025-03-18 18:37:48.457709+03:30	2025-03-21 22:21:29.347505+03:30	75	20	\N
5		2.00	25.00	52	10	2	2025-01-29 12:39:49.113901+03:30	2025-03-22 16:29:20.856093+04:30	9	40	2025-03-22 22:30:00+04:30
30	https://mills.biz/	13.76	80.52	57	48	14	2025-03-18 18:37:42.964395+03:30	2025-03-21 22:21:29.360506+03:30	73	50	\N
28	http://rodriguez-berry.com/	25.70	41.67	27	11	1	2025-03-18 18:37:37.62409+03:30	2025-03-21 22:21:29.364506+03:30	71	40	\N
26	http://anderson-lewis.info/	8.22	44.18	34	14	16	2025-03-18 18:37:32.20378+03:30	2025-03-21 22:21:29.371507+03:30	69	30	\N
25	http://www.bell.com/	17.94	33.01	46	8	14	2025-03-18 18:37:29.247611+03:30	2025-03-21 22:21:29.378507+03:30	68	15	\N
24	http://www.duran.info/	44.36	88.18	39	30	3	2025-03-18 18:37:26.494453+03:30	2025-03-21 22:21:29.382507+03:30	67	30	\N
13	https://www.dixon.com/	34.37	38.60	91	16	0	2025-03-18 16:43:52.002197+03:30	2025-03-21 22:21:29.388508+03:30	55	100	\N
10	http://hall.com/	22.74	30.64	19	28	5	2025-03-18 16:43:25.373674+03:30	2025-03-21 22:21:29.393508+03:30	47	95	\N
9	http://www.mccarty.com/	1.41	70.21	8	13	11	2025-03-18 16:43:07.134631+03:30	2025-03-21 22:21:29.397508+03:30	41	90	\N
8	https://www.phillips-robinson.biz/	41.48	48.55	59	25	17	2025-03-18 16:42:57.926104+03:30	2025-03-21 22:21:29.404509+03:30	38	70	\N
7	http://king.com/	0.50	71.39	44	40	7	2025-03-18 16:38:25.80354+03:30	2025-03-21 22:21:29.410509+03:30	36	60	\N
4	http://www.google724.com	0.00	30.00	10	0	0	2025-01-29 12:39:44.161625+03:30	2025-03-21 22:21:29.42951+03:30	8	30	\N
2		0.00	35.00	0	0	0	2025-01-29 12:39:34.206063+03:30	2025-03-21 22:21:29.441511+03:30	6	10	\N
1	https://www.aparat.com/video/video/embed/videohash/hdt6sp8/vt/frame	0.00	10.00	4256	2691	5891	2025-01-29 12:39:28.826765+03:30	2025-03-21 22:21:29.447511+03:30	3	20	\N
19	http://combs-gomez.biz/	18.92	58.37	61	34	19	2025-03-18 18:37:11.831615+03:30	2025-03-21 22:21:54.216928+03:30	62	10	\N
12	http://www.brewer.com/	29.44	79.04	60	27	9	2025-03-18 16:43:45.945851+03:30	2025-03-21 22:21:54.246929+03:30	53	5	\N
11	http://black-johnson.com/	8.79	23.62	8	34	12	2025-03-18 16:43:28.510853+03:30	2025-03-21 22:21:54.25093+03:30	48	25	\N
31	http://davis.com/	12.00	45.00	14	33	40	2025-03-18 18:37:45.789557+03:30	2025-03-21 22:54:09.745639+03:30	74	10	2025-03-22 23:53:58+04:30
34	http://www.woods.com/	26.00	48.20	11	48	12	2025-03-18 18:37:53.967025+03:30	2025-03-22 03:57:33.43203+04:30	77	25	2025-03-23 03:53:40+04:30
33	http://walker.biz/	46.60	68.84	55	44	5	2025-03-18 18:37:51.212867+03:30	2025-03-22 03:57:33.453031+04:30	76	15	2025-03-24 03:57:18+04:30
\.


--
-- Name: ap2_tutor_tutor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_tutor_id_seq', 34, true);


--
-- Data for Name: ap2_tutor_tutor_skill_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_tutor_skill_level (id, tutor_id, skilllevel_id) FROM stdin;
1	6	1
2	6	2
3	6	3
4	6	4
5	6	5
6	6	6
7	5	2
9	3	4
10	3	5
11	2	5
12	1	3
13	1	4
14	1	5
15	1	6
37	4	3
40	4	4
41	1	1
42	7	1
43	7	2
44	8	3
45	8	4
46	9	2
47	9	4
48	10	2
49	10	5
50	11	1
51	11	5
52	12	1
53	12	6
54	13	1
55	13	3
56	14	2
57	14	4
58	15	3
59	15	6
60	16	1
61	16	3
62	17	4
63	17	5
64	18	1
65	18	2
66	19	1
67	19	2
68	20	1
69	20	6
70	21	1
71	21	6
72	22	3
73	22	6
74	23	1
75	23	4
76	24	3
77	24	6
78	25	5
79	25	6
80	26	4
81	26	5
82	27	3
83	27	6
84	28	4
85	28	6
86	29	2
87	29	6
88	30	1
89	30	5
90	31	1
91	31	4
92	32	3
93	32	5
94	33	1
95	33	2
96	34	1
97	34	3
98	5	1
99	5	3
100	5	5
\.


--
-- Name: ap2_tutor_tutor_skill_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_tutor_skill_level_id_seq', 100, true);


--
-- Data for Name: ap2_tutor_tutor_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_tutor_skills (id, tutor_id, skill_id) FROM stdin;
1	5	1
2	5	2
3	6	8
4	6	1
5	3	7
6	2	1
7	2	3
8	2	4
12	1	9
13	1	2
14	1	10
15	1	4
16	2	11
21	4	1
23	4	6
26	7	8
27	7	1
28	7	6
29	8	9
30	8	2
31	8	11
32	9	10
33	9	5
34	9	6
35	10	11
36	10	1
37	10	3
38	11	1
39	11	3
40	11	7
41	12	8
42	12	9
43	12	3
44	13	11
45	13	4
46	13	5
47	14	1
48	14	5
49	14	6
50	15	1
51	15	11
52	15	6
53	16	10
54	16	3
55	16	4
56	17	9
57	17	2
58	17	3
59	18	8
60	18	1
61	18	4
62	19	8
63	19	11
64	19	7
65	20	9
66	20	11
67	20	4
68	21	11
69	21	4
70	21	6
71	22	8
72	22	2
73	22	7
74	23	3
75	23	4
76	23	7
77	24	8
78	24	9
79	24	7
80	25	9
81	25	11
82	25	6
83	26	8
84	26	10
85	26	11
86	27	9
87	27	11
88	27	1
89	28	1
90	28	2
91	28	5
92	29	1
93	29	2
94	29	5
95	30	8
96	30	1
97	30	6
98	31	3
99	31	6
100	31	7
101	32	10
102	32	4
103	32	7
104	33	8
105	33	1
106	33	11
107	34	3
108	34	10
109	34	11
110	5	11
\.


--
-- Name: ap2_tutor_tutor_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_tutor_skills_id_seq', 110, true);


--
-- Data for Name: app_accounts_language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_language (id, name) FROM stdin;
1	Dutch
2	Persian
3	English
4	Spanish
5	French
6	Japanese
7	Swedish
8	Arabic
\.


--
-- Name: app_accounts_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_language_id_seq', 8, true);


--
-- Data for Name: app_accounts_userprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userprofile (id, phone, country, photo, user_type, title, lang_native, bio, availability, rating, reviews_count, url_facebook, url_insta, url_twitter, url_linkedin, url_youtube, create_date, last_modified, user_id, gender, is_vip) FROM stdin;
4	5431531	Nepal	photos/profiles/01_K5EYpFd.jpg	tutor		Persian		f	5	89						2025-01-25 22:54:38.015735+03:30	2025-01-25 23:29:25.98316+03:30	12	male	f
5	+1 8992563841	Afghanistan	photos/profiles/10.jpg	student		Korean		f	0	0						2025-01-25 23:27:36.89792+03:30	2025-01-25 23:37:53.830207+03:30	16	male	f
2	5131215161-5	Afghanistan	photos/profiles/12_GV0dYQu.jpg	student		Persian		f	0	0						2025-01-25 22:28:42.874786+03:30	2025-01-25 23:38:02.312692+03:30	4	male	f
10	54612120455	Spain	photos/profiles/08_uXXvnfz.jpg	tutor		Russian		f	4.9000000000000004	89						2025-01-26 12:38:04.272086+03:30	2025-01-26 12:38:04.241085+03:30	18	male	f
16	+96 -85941-85	Panama	photos/profiles/03_k181AZT.jpg	student		Swedish		t	4	0						2025-01-30 19:56:12.508885+03:30	2025-01-30 19:56:12.487884+03:30	20	male	f
18	+1-5896101213	United Kingdom	photos/profiles/07_IkFIHHl.jpg	student		English		t	0	0						2025-01-30 19:58:50.977949+03:30	2025-01-30 19:58:50.974949+03:30	22	male	f
15	\N	Australia	photos/profiles/08_knLd2mf.jpg	student		Persian	<p>hello</p>	t	2.8999999999999999	4						2025-01-26 14:32:30.386327+03:30	2025-01-30 20:06:00.026489+03:30	7	male	f
1	\N	Portugal	photos/profiles/02_e8LmfnG.jpg	student		Ukranian		f	0	0						2025-01-25 22:26:54.226572+03:30	2025-01-30 20:08:08.858858+03:30	3	male	f
17	+1 59688233	Afghanistan	photos/profiles/09_BUdTHqy.jpg	student		Italian		t	0	0						2025-01-30 19:57:52.741618+03:30	2025-02-27 01:36:56.073379+03:30	21	female	f
11	+1-589613321213	Namibia	photos/profiles/09_dnXUSr7.jpg	tutor		Russian		f	3.8999999999999999	490						2025-01-26 12:39:52.550717+03:30	2025-02-27 01:37:11.678272+03:30	19	female	f
7	+1 8992563841	Kazakhstan	photos/profiles/07_lfVjipg.jpg	tutor		Ukranian		f	4.9000000000000004	0						2025-01-25 23:28:18.390294+03:30	2025-02-27 01:37:37.212732+03:30	15	female	f
6	+1 8992563841	Afghanistan	photos/profiles/02_mZillEB.jpg	tutor		Persian		f	0	0						2025-01-25 23:27:55.925009+03:30	2025-02-27 01:37:46.553267+03:30	13	female	f
19	+1-5892321213	Poland	photos/profiles/06_VdNlHqK.jpg	student		Ukranian		t	0	0						2025-01-30 20:00:22.923208+03:30	2025-02-27 01:38:08.156502+03:30	23	female	f
20	+41-98562-1148	Iceland	photos/profiles/03_iGXLbOK.jpg	student		English	Hello, this is Durove	t	0	0						2025-01-30 20:02:18.458816+03:30	2025-03-07 16:32:16.312083+03:30	24	male	f
21	\N	Albania	photos/default.png	tutor		English		t	0	0						2025-03-07 16:34:27.777603+03:30	2025-03-07 16:34:27.776603+03:30	25	male	f
8	+98 1023658100	Argentina	photos/profiles/03_J8v2Ztj.jpg	tutor	Professor	Korean	Hello. This is your teacher Louis 11	f	5	0	http://Facebook.com/louis					2025-01-25 23:29:07.79612+03:30	2025-03-13 22:41:44.347871+03:30	14	male	f
24	+1-459-540-6048	Senegal	photos/default.png	student	Theatre director	Unknown	Feel field before hundred friend community air unit. Today and school able. Oil eight heavy cover well development create.\nPay capital house news can herself game. Black onto just Democrat front natural government. Forward education ten charge power community protect out.\nView number water account. Military know card effect study forget.	f	2.7000000000000002	131						2025-03-18 14:07:42.959774+03:30	2025-03-18 14:07:42.964775+03:30	28	transgender	t
9		Andorra	photos/profiles/06_I8TvO11.jpg	tutor		Korean	hii this is Amanda	f	4.3300000000000001	15						2025-01-26 12:36:17.363972+03:30	2025-03-22 16:29:20.846093+04:30	17	female	t
25	001-487-362-7993x338	Saint Lucia	photos/default.png	staff	Horticultural therapist	Unknown	Specific dinner respond result detail. Develop owner threat prepare away heavy pass. Really great eight left according where instead free.\nSay reason job hour until think hour start. Eye phone without describe.\nPlan mind pretty member. Example which common often through see. Per dark him. Most science sea ability week.	t	1.8	168						2025-03-18 14:11:32.740917+03:30	2025-03-18 14:11:32.748918+03:30	30	transgender	f
26	+1-430-369-4014	Bolivia	photos/default.png	tutor	Food technologist	Unknown	Well charge sister. His door particularly machine exactly provide trip.\nNation much administration over ahead general where. President opportunity office wait information among together. Impact Congress garden one.\nSeason then low guy bar forward east worry. My standard serious can product.	f	2.7999999999999998	137						2025-03-18 14:11:33.046935+03:30	2025-03-18 14:11:33.051935+03:30	31	male	t
22	+69-4895-2536	Algeria	photos/profiles/05_tKRX1Xa.jpg	staff	content producer	Dutch	I am Mary from Germany. I also know Persian. I am proud that working with Lingocept company.	f	0	0						2025-03-15 21:17:48.034586+03:30	2025-03-15 23:37:45.842369+03:30	26	female	f
27	+1-220-921-2679x366	North Macedonia	photos/default.png	tutor	Sports administrator	Unknown	Statement line provide arrive least. Account the others yard. Doctor sell both seem. Position matter pay visit song small agency thousand.\nGreen anyone local respond matter final drug week. Daughter rather become study participant yard beyond reach. Major have will black role pay agency.	f	1.8999999999999999	24						2025-03-18 14:11:33.344952+03:30	2025-03-18 14:11:33.349952+03:30	32	male	t
3	+1-589613321213	United States	photos/profiles/Cynthia_CRTKDdg.jpg	tutor	Teacher	English	Hello. This is Cynthia from America.	f	4.2000000000000002	0						2025-01-25 22:33:58.228823+03:30	2025-03-17 19:56:55.912047+03:30	5	female	f
23	613-275-7066	Guinea	photos/default.png	tutor	Historic buildings inspector/conservation officer	Unknown	Deal item miss like. Bad different charge nor eat.\nInclude might deep oil sign computer. Analysis reveal prevent must soon past. Film letter worry computer.\nCover service already audience find quickly. Operation seat enter sing one stage. Environmental catch myself maintain allow magazine.\nEach brother know. Give or the war.	f	2.2999999999999998	61						2025-03-18 14:07:42.653757+03:30	2025-03-18 14:07:42.662757+03:30	27	female	t
28	353-595-3387	Armenia	photos/default.png	tutor	Fitness centre manager	Arabic	Any American before investment. Writer firm learn base marriage product.\r\nLaw accept cover fund. Hair total idea go. Product join she they cold important question. Significant be respond.\r\nThat fund discussion public. Every this arm simple month.\r\nPolitics particular choose black word soon. Century husband low soon.	f	4.7999999999999998	152						2025-03-18 14:11:33.647969+03:30	2025-03-18 14:13:52.191893+03:30	33	transgender	f
29	001-849-794-8311x978	Kuwait	photos/default.png	tutor	Art gallery manager	Ukranian	Become individual a around movement almost always dinner. Course cause election strong significant.\r\nIndividual check alone tax. Put current simple many question.\r\nFine head score something loss. Field method mother family work type now. Gas school work stock.	t	4.2999999999999998	112						2025-03-18 14:11:33.946986+03:30	2025-03-18 14:13:34.47888+03:30	34	male	f
41	775.245.0034	Belgium	photos/profiles/profile_4.jpg	tutor	Economist	Turkish	Both race note focus blood fire. All me trade too over thing.\nGood west own front late detail. Character civil watch beautiful throughout network.\nLine trouble outside more moment his TV visit. Out fine list successful.\nData shoulder along administration understand side. Push though daughter Mrs. Bit wait field budget million nice home possible.	t	2.6000000000000001	149						2025-03-18 16:43:07.11563+03:30	2025-03-18 16:43:07.130631+03:30	51	female	t
12	+98 39394964255	Iran	photos/profiles/11_xGm7IsM.jpg	admin	Admin (CEO)	Persian	This is Super Admin Lucas.	f	5	199						2025-01-26 14:04:45.447106+03:30	2025-03-20 21:58:00.904718+03:30	2	male	f
31	(509)905-9181	Mozambique	photos/default.png	tutor	Human resources officer	Persian	Relate assume recognize measure. Street always eat pass adult. Relationship coach sense foot seem rate season.\r\nIncrease form its how cause drug. Majority natural interview fish term arrive language spend. Career want work but find. Traditional general song need field less north.	t	2.3999999999999999	71						2025-03-18 14:42:44.305565+03:30	2025-03-18 15:44:47.899486+03:30	36	male	t
30	(355)246-8838x103	Tuvalu	photos/default.png	student	Media planner	Persian	Bill coach soldier. Again director himself across military player trade yes.\r\nEvery beat father step however key. Save push music fire plant cover.\r\nCitizen he of. Right two allow worry. Final wear world.\r\nFilm wish fill forget part. Close hand sport now fire itself ahead. Around long stage attorney simply.\r\nShow adult what little.	f	1.5	94						2025-03-18 14:42:43.995547+03:30	2025-03-18 15:44:53.871828+03:30	35	transgender	t
35	+1-487-352-8219x6839	Latvia	photos/profiles/profile_2_Ne5rAdj.jpg	student	Chartered accountant	Russian	Approach leader impact someone federal beyond. They draw upon the reflect start.\nProbably yes continue particularly happen say. Many general season Republican body institution.\nReveal enough difficult safe could. Factor sort of media thousand hope player drop.	f	3.5	9						2025-03-18 15:59:17.537226+03:30	2025-03-18 15:59:17.556228+03:30	45	transgender	t
32	(763)948-8179x733	Japan	photos/profiles/profile_1_qRvv1AZ.jpg	tutor	Research scientist (maths)	Korean	Mention summer wait see often strategy consumer. Night reflect behind local of local social.\nGet know down continue resource at. Determine beyond wish sport score recently. Above positive however mother avoid. Add friend benefit area.\nFather parent task then little early cup exist. Until difference build difficult again true opportunity.	t	1.5	117						2025-03-18 15:58:04.408044+03:30	2025-03-18 15:58:04.430045+03:30	42	male	t
33	+1-494-226-4236x5416	Fiji	photos/profiles/profile_2.jpg	student	Mental health nurse	Persian	Century brother join blue myself. Six each response send process. Son center near down nor.\nCity down newspaper hear. Material so job money statement most. Break check oil at should.\nLeader also food become. According can much mission including draw agree.\nReligious town standard rock. Task sit difference citizen.	f	4.5999999999999996	141						2025-03-18 15:58:07.348212+03:30	2025-03-18 15:58:07.367213+03:30	43	transgender	f
36	+1-534-939-5731	Liechtenstein	photos/profiles/profile_1_whwXnZ7.jpg	tutor	Buyer, retail	French	Teacher southern talk hear about. Whatever analysis someone bring new item road kitchen. Drive available option take answer respond brother.\nRoom how Democrat ready stop authority find. Different meeting time sense blood believe consumer. Yourself determine stop anything grow well.\nMove value official source.	t	3	197						2025-03-18 16:38:25.785539+03:30	2025-03-18 16:38:25.796539+03:30	46	male	f
34	(826)810-3932x872	India	photos/profiles/profile_1_LnXSrw4.jpg	student	Publishing copy	Chinese	Effect rather future training west. Security for why. Gas be force black anyone thing form without.\nTogether partner by. Middle student position feeling establish. Almost loss feel middle manage according.\nPerhaps your nearly decade reduce including base. Challenge key child child if have state. People hospital arrive behind the seem serious.	f	2.8999999999999999	61						2025-03-18 15:59:14.937078+03:30	2025-03-18 15:59:14.958079+03:30	44	male	t
37	+1-496-724-6304x238	Czech Republic	photos/profiles/profile_2_0lS3Ndp.jpg	student	Physicist, medical	Ukranian	Would research candidate gun myself.\nMaybe special system phone law. Drop very lead environmental.\nLanguage glass ball wide. Shoulder those account use after nearly writer nothing.\nTrip red economic thought if buy message. Instead often different every hotel.\nClear sense case structure. Involve way ball fast hope federal skill.	t	4.2000000000000002	91						2025-03-18 16:38:28.582699+03:30	2025-03-18 16:38:28.6037+03:30	47	transgender	t
38	293.622.9946x97118	Nicaragua	photos/profiles/profile_1_LFx4ome.jpg	tutor	Education officer, environmental	Korean	Commercial job avoid ago truth dog culture special. Republican certain arrive make. Hard grow huge interest.\nMaterial show team occur or politics prevent. Today war agreement else very various.\nSport glass attention your country I. Hear TV production.	t	3.6000000000000001	159						2025-03-18 16:42:57.911103+03:30	2025-03-18 16:42:57.920104+03:30	48	transgender	t
39	001-935-420-4048x626	Morocco	photos/profiles/profile_2_evCZAvc.jpg	student	General practice doctor	Swedish	Out enough attention have rule responsibility girl second. Spend manager economic level.\nOften official be surface look pretty outside. Economy fast realize bill camera better figure cost. Everyone new claim help under.\nNorth service seat partner feeling audience. Public picture paper door reveal dark stock. Want only police. Those medical last.	t	2.3999999999999999	45						2025-03-18 16:43:00.869272+03:30	2025-03-18 16:43:00.891274+03:30	49	female	f
40	500-269-7871	Austria	photos/profiles/profile_3.jpg	student	Theme park manager	Korean	Pm second laugh cold military. Threat series economy scene people class method. Economic these fund participant sea.\nSave piece radio assume president line. Provide prove well thank report form significant nothing. Practice tend you east.\nScene save color town customer heart. Cultural professor staff fact apply.	f	1.2	180						2025-03-18 16:43:04.031453+03:30	2025-03-18 16:43:04.063455+03:30	50	male	f
42	001-443-530-2454x508	Austria	photos/profiles/profile_5.jpg	staff	Geophysical data processor	Arabic	Place difficult lawyer cell. Mother need drug food. Seat ever college account pay son key.\nHalf simply never serious college up. Stand reach culture kid no. Deal send reality though full point. Every strong beautiful sport available require indicate.	f	2.2999999999999998	33						2025-03-18 16:43:10.247809+03:30	2025-03-18 16:43:10.26081+03:30	52	male	t
48	406.740.5498	Vanuatu	photos/profiles/profile_11.jpg	tutor	Tax inspector	Dutch	Movement drug trip clearly time.\nMatter either standard guy. Culture gas cultural myself must they.\nGas must require word million stuff free.\nThan as turn try. Beat specific many.\nMiss law individual around main. Language that condition hope however. Just through now ball reduce citizen work.\nBlue scientist surface improve beautiful.	t	1	153						2025-03-18 16:43:28.492852+03:30	2025-03-18 16:43:28.506853+03:30	58	male	f
43	887-621-0279x473	Andorra	photos/profiles/profile_6.jpg	student	Equities trader	Arabic	Pass believe interest service decade.\nEnough education wind home president wrong purpose. Glass boy fine team alone data question many. Mother worker article assume assume ever manager.\nNight card laugh city. Bed attorney style beautiful consider real. Up population accept western cup if vote.\nBusiness large human floor raise face.	f	3.8999999999999999	162						2025-03-18 16:43:13.117973+03:30	2025-03-18 16:43:13.137974+03:30	53	female	t
44	(509)841-4206x120	Sierra Leone	photos/profiles/profile_7.jpg	student	Holiday representative	Russian	Career prove above character create house. Something a once section.\nSite someone different keep write family. Provide reflect medical international summer.\nOld manage ago from peace.	t	2.2000000000000002	95						2025-03-18 16:43:16.018139+03:30	2025-03-18 16:43:16.03114+03:30	54	male	f
45	+1-334-556-6778x4994	United Kingdom	photos/profiles/profile_8.jpg	student	Water engineer	Japanese	Support green out usually. Establish little support can anything western.\nLeast ground guy area at. Audience us place lawyer form. Nation significant far recognize often social. Guess society eat per.\nFull tax student strategy relate area spring.\nDirection voice management thus. Skin visit include play sit sure.	f	2.7000000000000002	65						2025-03-18 16:43:19.18432+03:30	2025-03-18 16:43:19.206321+03:30	55	female	t
49	+1-802-296-3564x7245	Libya	photos/profiles/profile_12.jpg	student	Investment banker, corporate	Ukranian	Trouble anything member may. Sport in employee life model wide relate off.\nExpert story back I police grow little. Range now forget system better.\nFoot bed doctor kitchen perhaps leave by. Return white cover customer hot. Change news interview reduce contain drop.	f	2.7999999999999998	69						2025-03-18 16:43:31.517025+03:30	2025-03-18 16:43:31.538027+03:30	59	transgender	t
46	(271)556-9585x49697	Peru	photos/profiles/profile_9.jpg	student	Politician's assistant	English	Year memory couple have size trade. Will free arm enjoy task growth.\nWrite say no. Program pressure why with store rock north.\nDo four response member mean must anyone. Nation stage language religious draw effort team. Pattern red behind model question feel go.\nLot indicate east. Hand forget wife two along bring stop expect.	f	1.8999999999999999	92						2025-03-18 16:43:22.50451+03:30	2025-03-18 16:43:22.524511+03:30	56	transgender	f
47	+1-830-910-4030	Qatar	photos/profiles/profile_10.jpg	tutor	Airline pilot	Ukranian	Today TV push religious could. Wear animal official wall. We reflect small computer risk.\nMagazine edge tax result us capital rest. Business almost find expect ago begin data we. Finally item green capital child break. Away fund safe hold begin.\nPiece after environment. Myself quality dog arrive from. Hit election whatever and my adult.	f	3.2999999999999998	98						2025-03-18 16:43:25.355673+03:30	2025-03-18 16:43:25.368674+03:30	57	male	t
55	(584)833-4784x9717	Gabon	photos/profiles/profile_18.jpg	tutor	Manufacturing systems engineer	Turkish	Name some ahead remain social save. End design material assume throw school whose pattern.\nSell lawyer traditional company expect. Letter a under certainly begin fill building. Face chair just generation other.\nProtect piece high strong. Police method peace large city expert. Information fund I and central.	f	1.3	124						2025-03-18 16:43:51.984196+03:30	2025-03-18 16:43:51.997197+03:30	65	male	t
50	697.202.7151x782	Thailand	photos/profiles/profile_13.jpg	student	Engineer, materials	Dutch	Maybe challenge today room explain physical friend chair. Score early couple window establish Republican ahead.\nDesign executive bank main listen. Maybe response mission begin surface. A support call join shake.	f	3.2000000000000002	77						2025-03-18 16:43:34.683207+03:30	2025-03-18 16:43:34.705208+03:30	60	male	f
51	001-745-542-8082x771	Seychelles	photos/profiles/profile_14.jpg	staff	Paediatric nurse		Tonight worry organization. Administration care your study. Crime require inside how she truth.\nModel environment cultural rate present. Seek foot raise develop decade so there. Blue home write fish price.\nYeah choice list decade floor soldier. Then agree not south five. Who late table field senior degree forward.	t	3.2999999999999998	67						2025-03-18 16:43:40.013511+03:30	2025-03-18 16:43:40.026512+03:30	61	male	t
52	+1-982-632-7167x4191	Lithuania	photos/profiles/profile_15.jpg	student	Sport and exercise psychologist	Italian	Themselves he including early approach scene actually. While open final. With smile hand imagine evening.\nUntil scientist Congress answer type six. Sound fight let natural parent.\nWish education amount. Purpose nor task week main truth. Born behavior memory design once.	f	1.8	47						2025-03-18 16:43:43.005683+03:30	2025-03-18 16:43:43.020683+03:30	62	transgender	t
53	264.707.4421x2720	Tonga	photos/profiles/profile_16.jpg	tutor	Engineer, maintenance (IT)	Persian	Everybody option none their establish wind end. Study through can stock goal improve else. Those station approach data race wear drive.\nAmerican eat plant tell now. Focus sing state yet reveal every least. Claim list want science accept various oil. Significant one there control difference.	t	1.8999999999999999	67						2025-03-18 16:43:45.93185+03:30	2025-03-18 16:43:45.94085+03:30	63	female	f
54	(797)668-7742x034	Albania	photos/profiles/profile_17.jpg	student	Printmaker		Film move manage thought part though. Kid feeling partner region. Themselves can room fill thank its.\nMachine your necessary century. Argue capital throughout.\nJust author fall number sound wait alone. Congress your whom piece court either interview. Home place kind notice participant too.\nSuccessful prepare next citizen turn.	f	3.6000000000000001	27						2025-03-18 16:43:48.73001+03:30	2025-03-18 16:43:48.750011+03:30	64	male	f
56	641.595.8202x330	Tunisia	photos/profiles/profile_19.jpg	student	Ship broker	French	Down recognize whom ten. Sister decide him who development style. Product this eat citizen.\r\nSo thank inside surface environment. Grow conference feeling woman safe during film.\r\nFather week through explain sing knowledge blue hot. Pressure nature station even.\r\nScientist vote painting people. Wide relationship daughter me task him.	f	3.7999999999999998	29						2025-03-18 16:43:55.253383+03:30	2025-03-18 22:18:14.174898+03:30	66	female	f
57	(323)942-8810	Sri Lanka	photos/profiles/profile_20.jpg	tutor	Clothing/textile technologist	French	Whether act these example.\nReally than rise which decision opportunity. Worry major enter state soon plant name research.\nInside piece population vote west offer. Care whatever institution generation effect power.\nUntil choose case cultural record. Movement product chance establish read situation decade.	f	1.3999999999999999	158						2025-03-18 16:43:58.071544+03:30	2025-03-18 16:43:58.084545+03:30	67	female	f
58	667-832-1938	Brunei	photos/profiles/profile_1_iNOYdkv.jpg	tutor	Chemist, analytical	French	Society wrong Congress hospital purpose trial. Where six land remain instead.\nAllow again away into face. Buy become mission level.\nStage bring remember travel give teacher. Enough for simple. Front difficult there hotel. Now question home we defense can too.	f	3	90						2025-03-18 18:37:00.411961+03:30	2025-03-18 18:37:00.426962+03:30	68	male	f
59	+1-570-306-7850x8786	Marshall Islands	photos/profiles/profile_2_a8mZL77.jpg	tutor	Producer, radio	Spanish	Customer could entire them trouble color. Two front ground between brother able well name.\nModel ask artist miss collection choose area per. Local under detail coach discover send operation. Range letter can commercial.\nMuch nation all current. Mission color energy parent likely trip. Process stuff subject professional nothing natural figure.	t	2.2999999999999998	20						2025-03-18 18:37:03.405133+03:30	2025-03-18 18:37:03.419133+03:30	69	male	t
60	959.820.3552x6567	Ukraine	photos/profiles/profile_3_YRLQtK4.jpg	tutor	Customer service manager	Turkish	Card candidate at side bar anyone.\nSeem worker everything before put time central. Modern writer receive edge song place.\nBut day above Mrs large. Call store paper its market.\nLand up find else certain beautiful. Work school old store benefit new girl budget. Difference camera service from put significant.	f	1.8999999999999999	153						2025-03-18 18:37:06.128288+03:30	2025-03-18 18:37:06.142289+03:30	70	male	t
61	776.813.0539	Sweden	photos/profiles/profile_4_NbPm8ok.jpg	tutor	Engineer, manufacturing	Korean	Town parent hair. True present ability less. Seem artist choice hundred reduce agency. Opportunity action agency message and.\nGo big ask story. Miss full every impact.\nOrganization region word health. Four left try something. Argue main little truth radio.	f	4.9000000000000004	142						2025-03-18 18:37:08.994452+03:30	2025-03-18 18:37:09.001453+03:30	71	male	t
62	(661)496-7640x60724	Bulgaria	photos/profiles/profile_5_bqyrNcf.jpg	tutor	Psychiatric nurse	Korean	Policy follow stock down suddenly. Form this senior economy instead wide book.\nBelieve soldier food PM. Late stage blood war either central quite do. Bar minute design.\nState lot add kind government cultural.\nDevelopment southern security similar claim wide. Business bed sit beyond. Particular newspaper responsibility manage ball key democratic.	f	4.2000000000000002	36						2025-03-18 18:37:11.812613+03:30	2025-03-18 18:37:11.826614+03:30	72	male	f
63	(675)564-6444x34323	Indonesia	photos/profiles/profile_6_cQsOpXs.jpg	tutor	Animal nutritionist	Turkish	Majority memory believe. Clear alone admit who require. Far evidence paper still top none.\nProduct anything modern time site performance different. Product something truth listen participant.\nThank medical employee force cultural between study. Unit reflect when control.	t	3.3999999999999999	62						2025-03-18 18:37:14.686778+03:30	2025-03-18 18:37:14.699779+03:30	73	male	f
64	+1-814-233-5653x1812	France	photos/profiles/profile_7_STWk4Hf.jpg	tutor	Civil engineer, contracting	Persian	Involve meet all base professional. Particularly training score now last quality. Church she director process hear.\nBed natural contain four defense. Indicate than my those second find.\nWestern happen certain trial capital watch. Outside fill decision discuss. While put street simply human dark. Well first boy international example popular.	f	3.3999999999999999	19						2025-03-18 18:37:17.372932+03:30	2025-03-18 18:37:17.390933+03:30	74	male	f
65	+1-475-800-2560	Samoa	photos/profiles/profile_8_frunYit.jpg	tutor	Advertising art director	Persian	Range fact box land to food particularly. Among market within career weight discussion energy. Management writer ten week deep bank speak.\nLanguage girl action issue. East fly mother interview theory of age. Financial however thought listen.\nDecade agency yourself live different. Myself interest data air eye red.	f	3.2000000000000002	188						2025-03-18 18:37:19.97308+03:30	2025-03-18 18:37:19.986081+03:30	75	female	t
66	964-573-8216	Cuba	photos/profiles/profile_9_0QCa9fH.jpg	tutor	Chief Marketing Officer		Measure class water improve quickly note whose. Simple safe ability recently either politics.\nFree source her full time investment place easy. Left lot while sign suddenly professor.\nSeveral term whom say care authority sit. Body sense public around last such. Present from far see.	t	4.9000000000000004	64						2025-03-18 18:37:22.787241+03:30	2025-03-18 18:37:22.801242+03:30	76	male	t
67	604-388-9651x95891	Botswana	photos/profiles/profile_10_oyDAPb8.jpg	tutor	Sports coach	Ukranian	Worry ago military way bag concern. Kid young last who carry. Century floor next glass school quality trial.\nProcess economy various than radio. International simply positive. Through heart hold beautiful employee.\nWear office moment reach law life mean. Leg close drop. Care send cover particularly option upon.	t	3.2000000000000002	87						2025-03-18 18:37:26.476452+03:30	2025-03-18 18:37:26.490453+03:30	77	female	f
68	653.879.6119x53934	Russia	photos/profiles/profile_11_71EsMw1.jpg	tutor	Commercial/residential surveyor	Russian	Wear gun audience rather action word wind. Test what entire difficult audience. Believe consumer character because election its law stop.\nField other environmental by set policy character computer. Never court morning month listen.\nFollow situation while subject direction here. Of remain lay Republican. Lawyer teacher yes present store analysis.	t	1.8	118						2025-03-18 18:37:29.22861+03:30	2025-03-18 18:37:29.24261+03:30	78	female	t
69	+1-203-438-9105x9633	Hungary	photos/profiles/profile_12_ZSAd3DD.jpg	tutor	Therapist, speech and language	Spanish	Interest of ask each light deal his. Truth organization artist system.\nStatement leg institution never of do. Whom home we anyone race board.\nOnto base mention over coach himself table condition. Water better strategy none hair.	f	3.5	63						2025-03-18 18:37:32.184779+03:30	2025-03-18 18:37:32.198779+03:30	79	female	f
70	453-220-5820	Iraq	photos/profiles/profile_13_yb8pT7P.jpg	tutor	Surveyor, insurance	Korean	Owner leader there market foot Mr new. Room along bit cold country. Natural believe let relate yourself community spend.\nAccording majority dog finally ball likely memory. Want ten walk begin.\nClear happy campaign raise. Church especially what professor pattern program enter cell. Up main political think eat cell.	t	1.3	195						2025-03-18 18:37:34.863932+03:30	2025-03-18 18:37:34.876933+03:30	80	transgender	t
71	001-271-818-2864x782	Argentina	photos/profiles/profile_14_mlXWLng.jpg	tutor	Geophysicist/field seismologist	Italian	Accept his stage kitchen trip. Own treat number say.\nBoard set rule possible team. Number fear sometimes heavy from near seem.\nDevelopment crime coach hair employee color. Thousand management process bed.\nTraditional she successful common make early investment. Western society pick wide. Election career cover since accept surface great Mrs.	t	4.7999999999999998	155						2025-03-18 18:37:37.606089+03:30	2025-03-18 18:37:37.61909+03:30	81	female	f
72	895-590-1896	Dominica	photos/profiles/profile_15_Sv1C6sw.jpg	tutor	Contracting civil engineer	Russian	American near far than serious life. First between generation mind.\nAccept on box husband draw. Seat staff animal summer field modern job. Discover along a trouble pretty.\nDuring husband answer. Happy system Mrs story.\nNatural hot as will reveal. State develop raise guy culture.\nDiscuss not floor when. Ability there system attorney believe.	t	4.2000000000000002	188						2025-03-18 18:37:40.101231+03:30	2025-03-18 18:37:40.115232+03:30	82	female	t
73	001-276-983-7451	Norway	photos/profiles/profile_16_acbk7ly.jpg	tutor	Drilling engineer	Korean	Now large perhaps as of. Art chair training.\nOur look main morning argue. Federal civil serve teacher arm around remember.\nSort goal strategy picture traditional main well. Read over whole mother time team say.\nBack American population on plan out positive. Under career church once identify over.	t	3.2000000000000002	107						2025-03-18 18:37:42.953395+03:30	2025-03-18 18:37:42.960395+03:30	83	female	t
74	001-642-464-9314	Haiti	photos/profiles/profile_17_wAqhKwr.jpg	tutor	General practice doctor	Dutch	Leave economy although stage break suffer common. Perhaps site pressure finish.\r\nHistory way history model. Accept peace major full movement himself. Behavior analysis budget very cause garden if life. Bring member top staff see range.\r\nNo whose respond keep certain do. Physical them why above. Across treatment her actually maintain.	t	5	153						2025-03-18 18:37:45.770556+03:30	2025-03-21 22:31:07.982601+03:30	84	female	f
75	(448)772-4242x1205	North Macedonia	photos/profiles/profile_18_harjDif.jpg	tutor	Colour technologist	Swedish	Magazine appear top task old write. Even about smile network performance or. Ever tree think tonight.\nWhatever rise board present late state. Exist matter husband. Student ever prepare summer on lead and.\nLeft husband when claim enough describe mouth. Answer show only red of these.	t	1.6000000000000001	127						2025-03-18 18:37:48.433708+03:30	2025-03-18 18:37:48.449709+03:30	85	female	t
76	001-513-289-6494x068	Brunei	photos/profiles/profile_19_4wxm90t.jpg	tutor	Lawyer	Korean	Read cost thousand cup field center total. Little when cause tell trouble door others.\nPolice building type else. Voice road land risk.\nCongress station tend. Hospital officer effect own. West different back exist growth themselves voice.\nThose pass toward. Account should sister front. How base pattern source cover away.	f	2.3999999999999999	12						2025-03-18 18:37:51.194866+03:30	2025-03-18 18:37:51.207867+03:30	86	female	f
78	\N	Unknown	photos/default.png	student		Unknown		t	0	0						2025-03-18 20:44:04.103832+03:30	2025-03-18 20:44:04.103832+03:30	88	male	f
77	833.912.9023x72119	Burundi	photos/profiles/profile_20_vcSH9SY.jpg	tutor	Investment banker, operational	Chinese	Knowledge agent artist teacher attention standard suddenly. Anything model recent financial.\r\nWriter without common rate individual history. Nor program behind seek director standard board. Pay although draw group more. Into other next to operation message.\r\nClass along whatever world prevent. Relationship east short local foot state.	f	3.6000000000000001	122						2025-03-18 18:37:53.950024+03:30	2025-03-22 02:48:21.51559+04:30	87	transgender	t
\.


--
-- Name: app_accounts_userprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userprofile_id_seq', 78, true);


--
-- Data for Name: app_accounts_userprofile_lang_speak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userprofile_lang_speak (id, userprofile_id, language_id) FROM stdin;
1	1	1
2	2	5
3	3	1
4	3	3
5	4	3
6	4	4
7	5	2
8	6	2
9	6	3
10	7	1
11	7	5
13	9	2
14	9	3
15	10	1
16	10	5
17	10	6
18	11	1
19	11	5
20	11	7
21	12	2
22	12	7
23	16	5
24	16	7
25	17	3
26	17	5
27	18	1
28	18	3
29	19	1
30	19	3
31	19	6
32	19	7
33	20	2
34	20	4
35	20	7
41	8	7
42	8	2
43	8	6
44	8	1
45	20	8
46	21	5
47	21	6
48	22	1
49	22	2
50	12	1
51	23	4
52	23	5
53	23	7
54	24	1
55	24	3
56	24	4
57	25	4
58	25	6
59	25	7
60	26	8
61	26	1
62	26	6
63	27	2
64	27	3
65	27	6
66	28	8
67	28	2
68	28	4
69	29	8
70	29	1
71	29	7
72	30	4
73	30	6
74	30	7
75	31	2
76	31	6
77	31	7
78	32	5
79	32	6
80	32	7
81	33	2
82	33	4
83	33	7
84	34	1
85	34	4
86	34	7
87	35	8
88	35	2
89	35	3
90	36	8
91	36	1
92	36	7
93	37	8
94	37	2
95	37	3
96	38	1
97	38	2
98	38	7
99	39	2
100	39	6
101	39	7
102	40	8
103	40	2
104	40	7
105	41	2
106	41	3
107	41	5
108	42	1
109	42	2
110	42	6
111	43	8
112	43	4
113	43	7
114	44	1
115	44	4
116	44	6
117	45	8
118	45	1
119	45	4
120	46	8
121	46	3
122	46	5
123	47	3
124	47	6
125	47	7
126	48	2
127	48	3
128	48	7
129	49	1
130	49	2
131	49	4
132	50	2
133	50	3
134	50	6
135	51	4
136	51	5
137	51	6
138	52	8
139	52	4
140	52	7
141	53	1
142	53	2
143	53	7
144	54	8
145	54	2
146	54	7
147	55	3
148	55	5
149	55	6
150	56	3
151	56	4
152	56	6
153	57	8
154	57	2
155	57	5
156	58	2
157	58	5
158	58	6
159	59	3
160	59	4
161	59	6
162	60	8
163	60	1
164	60	6
165	61	8
166	61	1
167	61	4
168	62	8
169	62	2
170	62	3
171	63	1
172	63	2
173	63	7
174	64	1
175	64	3
176	64	4
177	65	8
178	65	4
179	65	6
180	66	8
181	66	1
182	66	7
183	67	8
184	67	4
185	67	6
186	68	1
187	68	2
188	68	7
189	69	8
190	69	3
191	69	6
192	70	2
193	70	6
194	70	7
195	71	8
196	71	1
197	71	3
198	72	2
199	72	5
200	72	6
201	73	1
202	73	4
203	73	5
204	74	4
205	74	6
206	74	7
207	75	1
208	75	2
209	75	6
210	76	2
211	76	4
212	76	6
213	77	5
214	77	6
215	77	7
216	9	1
\.


--
-- Name: app_accounts_userprofile_lang_speak_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userprofile_lang_speak_id_seq', 216, true);


--
-- Data for Name: app_admin_adminprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_admin_adminprofile (profile_id, department) FROM stdin;
\.


--
-- Data for Name: app_content_filler_cfboolean; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfboolean (id, key, value) FROM stdin;
\.


--
-- Name: app_content_filler_cfboolean_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfboolean_id_seq', 1, false);


--
-- Data for Name: app_content_filler_cfchar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfchar (id, key, value) FROM stdin;
1	site_name	Lingocept
4	phone3	(678) 324-1251
3	phone2	+896-789-546
5	address2	2492 Centennial NW, Acworth, GA, 30102
2	phone1	+49 (423) 733-8222
6	address1	Chicago HQ Estica Cop. Macomb, MI 48042
7	address3	2002 Horton Ford Rd, Eidson, TN, 37731
\.


--
-- Name: app_content_filler_cfchar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfchar_id_seq', 7, true);


--
-- Data for Name: app_content_filler_cfdatetime; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfdatetime (id, key, value) FROM stdin;
\.


--
-- Name: app_content_filler_cfdatetime_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfdatetime_id_seq', 1, false);


--
-- Data for Name: app_content_filler_cfdecimal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfdecimal (id, key, value) FROM stdin;
\.


--
-- Name: app_content_filler_cfdecimal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfdecimal_id_seq', 1, false);


--
-- Data for Name: app_content_filler_cfemail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfemail (id, key, value) FROM stdin;
1	email1	support@Lingocept.com
3	gmail	Lingocept@gmail.com
2	email2	info@Lingocept.com
\.


--
-- Name: app_content_filler_cfemail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfemail_id_seq', 3, true);


--
-- Data for Name: app_content_filler_cffile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cffile (id, key, value) FROM stdin;
\.


--
-- Name: app_content_filler_cffile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cffile_id_seq', 1, false);


--
-- Data for Name: app_content_filler_cffloat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cffloat (id, key, value) FROM stdin;
\.


--
-- Name: app_content_filler_cffloat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cffloat_id_seq', 1, false);


--
-- Data for Name: app_content_filler_cfimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfimage (id, key, value) FROM stdin;
1	site_logo_light	content_images/logo1_easoC6Q.png
2	site_logo_dark	content_images/logo1_8Au74mK.png
\.


--
-- Name: app_content_filler_cfimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfimage_id_seq', 2, true);


--
-- Data for Name: app_content_filler_cfinteger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfinteger (id, key, value) FROM stdin;
\.


--
-- Name: app_content_filler_cfinteger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfinteger_id_seq', 1, false);


--
-- Data for Name: app_content_filler_cfrichtext; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfrichtext (id, key, value) FROM stdin;
1	test_richText	{"delta":"{\\"ops\\":[{\\"insert\\":\\"Hello \\"},{\\"attributes\\":{\\"color\\":\\"#008a00\\",\\"background\\":\\"#9933ff\\"},\\"insert\\":\\"Darling\\"},{\\"insert\\":\\"\\\\n\\"}]}","html":"<p>Hello <span style=\\"color: rgb(0, 138, 0); background-color: rgb(153, 51, 255);\\">Darling</span></p>"}
2	about_us	{"delta":"{\\"ops\\":[{\\"insert\\":\\"In this place we can type almost everything with Quill Rich Text .\\"},{\\"attributes\\":{\\"align\\":\\"center\\"},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"\\\\n\\\\nIn this place we can type\\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\" almost \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\"},\\"insert\\":\\"everything \\"},{\\"insert\\":\\"with \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"background\\":\\"#ffff00\\",\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\"Quill Rich Text \\"},{\\"attributes\\":{\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\".\\"},{\\"attributes\\":{\\"header\\":2},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"\\\\n\\"},{\\"attributes\\":{\\"link\\":\\"http://www.Google.com\\"},\\"insert\\":\\"Google\\"},{\\"insert\\":\\"\\\\n\\\\nIn this place we can type almost everything with Quill Rich Text .\\\\n\\\\n\\"},{\\"attributes\\":{\\"width\\":\\"454px\\"},\\"insert\\":{\\"image\\":\\"data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAQABAADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD6EdmzTTmpZR8340zHHFdcrWONEJpKcaKzKG0UUUAFFFH1oGFFFJQIKKKKYBRRRQAtFJS0AJS0lFAC0UUUgCiiigAooooAKKKSgBaKKKACij3ooAKKKKACiiigAooooAKKSimAtFJRSAWikooGGaWkooAKWkooAKWkooEFLSUUALSUUUwCikooAKTFLTTQAUjVBc3cFsu6aRUHuev+NUTqbynFraysOzSfIP15/SgdmamaQtjqcVz2p6tHZKP7R1CG3LHARMZJ9Ock/lXGax4902K3ae2kidB1a5dywA7iPv35yBkYqHOK3ZahJ7I9Oe7hU4Mgznsc1Vutas7VSZpgMdhyfyFeE6h8UGdJlh3Kp+VYtu3IHckep4xk/SucuvHxLbUtXEexQwVVUse4BILAfQ54qPbR6F+xZ9ETeLbCLtOwBAyEwOfrUbeMrVLaWdoJliiPzFyFx+Z6e9fMx8Y6gbqzuomhhFoCFhQfK+euf6en61auvFc1808kgMRcgMi4Ksv+0MfMf896n2xXsT6YsvE9tdxCRAVUru+ZhwMemc56fnWhFqEUgBO5QemRnP5V8q+HfEF5pWqLLBG4LDJjZ8Bk988dO9et6N4vstStIWidbO5ZypjyGC55J7dBznHb60Kr3JdK2x62GBHBp26uETXLe0iEjXp8kDLTs42HnHXpz7f4Vz2qfFjTLQN9nnmnkx8u2P5c/iB/kfSr9pFbkcjex65u9/1oDjnn9a+eNU+MmqzZXTLWKEf3pTub646CuZu/iL4kuSwfUWUHtEuf6cVPt4lKjJn1Z9oi7yKPq1OEinowP418nw/EHXYUZDMZATkGQEMD6gjH5Hir9t8S9YgdXdpTjqA24H8CP60e3iHsZH1GfrSYrxfwz8XLRlVdWkeBs8N5ZKkfh0r0/Q/EWn6vCr2tzFIGGQVb/OPpWkZKWxm4tbmxRR0oqxDqKKKBC0UlLQAUUUUAGaWkopDFopKKAFoopKAFopKKBC0UUUDHUU2igQ6m0UUDCiiigQUUUUAFFH0ooAM06m0UAFFFFABRRRQAUUlFAC0UlFMBc0ZpKKAFopKWgAooooAKKKKACiij6UgCiiigAooopgOoHWiigC3L1/Goz71JJ1/H1qLtxVy2JW5Eaaae1MNZlCUUUUAH1ooooGJRS0lABRS0UCEpaSigBaKSloAKSiigAooooAKWkooAKKWigBKKKKAFoopKAFopKWgAopKWgAooooAKSiloASiiigAooooAKKKKACiiigYUUlLQIKKKKYBRRSUAFFFGaACmPIB/npTJZMZJYKo6k1z2veIrHTLcyXF1FbxAcySEA/QD/P0pN2WpSjc25rxEbb96TrtUc/8A1vxrKv8AUdkZMtwIF9E5Y/if8PxryPxH8W4U3QeH7ZpySSZpSVTOOvPLfjXm2s+IdV1di2pXjup6RoNqfkOv+ea55V+xvGie4ax8QtB0mQiBhc3hHBBLk/8AAufT1rz/AMQfE7XdREkNiYbKJsqC0gyR646j9a8+HmEAJ8ozkDdjn8KsCGUjLoMerZP9axdaT3NlSSEvP7SvJ/MubuG5Y/8ATcH+ZzUEmn6ocO9jK4H3cEN+WK07a3jJ+a2aRvUDAP8AWr9tpgdgxtldR/CSwNTzIuzOYlttVC/vLS7Cj/pm2B+lQiR1ysnBzyrJ3/pXdSaeFX5Uezb1Ep4/DPNSvp128JUzrcx8ckZ4PuR+lK8R2ZwuEfqFDH2/rQLPGCq7D9c5robrSgsmHgKfTgj1OM4qS3sto2JyCfoR7+uaLhYw40bypkMe5mUZc/w4bqM9+2fQmpE87CykY2jbkevbH5VqvaNHIu4DCnDEdhUMsDb1bkKoCgZ6cD+v8qLisVbi6urpY43kcwoAqR54wOnH49ff3qHycH5zubpheg/Gte1sJJ3CKuSwyRnt7nsK2LbRoI9rORKf7xHyjP8AdXqf5VEplKByBhJXuq57CnfZHAy0bAdizEf/AK67qPSzJkwx7F6bzgufoOgH+eagltrO33fILhxyxzkD6k/4VHtSvZnDvASv8JHsuf50w2jZ+62f93FdNdXqRkhEB/65E4/E1lTag44Q/L6Lzj8cVSmxciM0wzoRgt9CvWr2navd6ZN5sJeA9N8bdfw6VC1+VX5/5EfpUT3w7Fl9mOafOyHFHsvgv4uhNltruGiAA+0IOn1FeyadqFrqVrHcWM6TQuMhkbNfGokjb7yAk91ODXS+D/Fl14auS9rM7W56x54H4cV0wxFtGc86HVH1fTq4zwZ4803xBFGnmrHc4GVJ6muz+hrrTTV0czVnqFFFFAhaSiimAUUUUALRRRSGFFFFABRRRQIKKKKAFoooFAwooooAKKKKBCUtJRQAtFJRQAtFFFABR1pKKACiiigApaKSgAooopgFLSUtABSUUUAFLSUUAL9aKSigAooooAKKKWgA+nFFJS0AFAoooAuydfxqM9Kkk68fpTKuWxKIDTTT2phqChKPej8aKACiiikAUUUlABS0UUAFFFFMApKWkpAFFLSUAFFJ3paACiiimAUtJRSAKWkpaAEooopgFLSUUgCiiloASiiloASloooAKKKKACkpaSgAooooAKKKKACik+tLQAUUlFMAoptLmgBKqahfxWiHc6ggZJJ4UVj+MvFen+GNNe4vJgGHCoDyT6Yr5w8b+Pb/AMQyGKR2t7Mni1ib5m93OP06e3esp1VHQ1hScj0Xxr8V4oGltdAAup1yHnY4jT6ev16ema8X1jVrjWLxri/nmv7gn6Ivt9KoPvmA3gbR92MDCipI1OMDbx1J6D6DpXHKcpas64wUdiRDLzuKRL6KMn8+1WLdYskqm98ZLueF98mq8TRk4EZlxzlvu5+laCQggLKFIU8KBwzf1+p/CpLJIZB/yyVCP775wfoMVrWPmPw0crcf8s4gG/XmiwtZHb7hyMZ2kDA+vRfoK1Y2t4MLK6t6pGTnPuTx+lZs0RatJTEB5ouIQvIXYGz+A/xq8dTXkNP8/vGFP0xxmsaW9RUKxxIR7Mc/y/rVWa+UJiWBynYOFP64z+tZ8rZpdI62G5TZhtjqQN5j+UjH+zzmozZw3CmW2kDcgsoJVh7+v8wa4SW+y2+2k8sjouSCvsDk/wCfWp7HWpBMpLfvs8HP3vw/w60+SSWguZN2OtkjUx7JNr7unACn/wCJP8uM+tZN1arFIshLeWTyAOR6Y/w//WIpdRa5klX+LYsysD246/TJFUJL/wA/TVfPz5557g5/A4wfxqldEuzNqOGK6iAkYBmzG59f9ofr/npQeJHZpmby4lHzORnaTztHqaXR5t15ZOy75Jwfkx3Vjn/0H/x41PfRK92kaHFvbqo653OcH8+R+VMVh1qjTgqieRbD5iOpOe7HuT6Vt2/kKvTEXU5OS59Se/8AnArIS43SCCI7Fj5Zh6/4/wCH1rF1TXNzeVZtsgHBI+83/wBb/wDVU2bK0R1VzfJO5jiPIGGRcDA9z0H06msm4CM20OHOcKIwQuPUcfzrEtWeXAYmOPqEQ/z9f89K6HTzCeFWIcctj+fenypC1ZkXOn3Dk+VCATz+8A3Y9cHoPwrNurFiG33ESMOp3A4/IfpXoUVnbSxhdksgOMhU2gfgaSXR7U8G3YjrhlKkn8P8KfNETizyqeJkXhVde/y9focVnSqgPH7pvQ85/wAK9L1PRYkJaL922ccsDx6cgetYF9puOJI1YdNw+X9OlWmiGmcczbOGXZ+B5p0Vw2TskbAPPHFa13YIq/u1ITqQ65H6f1rKu4GU/MSi9gifL+hp2TJdy9aajJBOssUnkTg8OhwD/hXu/wAL/iat15em62+yfgJIe9fOcYJXCsJF9Ohqa3uGiwCW2dmH3kq4ScHoZygprU+6FZXQMhDKRkEHrTq8E+EvxKe3mi0jXpt8TYEE7c/hXvKOsiBkIKkZBHcV3Rkpq6OOUXF2Y6iiimSFFFFMBaKKKQBRRmigAooooAKKKKACiiigYtFJS0CCkpaSgAooooAKKKKAFooooAb2p1JS0AJS0lFMAooopAFFFLQAlFFFMAooopAFFFFMAooooAKKKKAE70tGKKQC0UUUAFFFFMC3LTD09Klk6/jUR96t7EoiNJSmmmoKEooopAFFFFACUUtJQAUUUUAFFFFABRRRQAUUUUwCiiigAooooAKKKKACiiigAooooAKKKKQC0lFFABRS4pKAFopKKAFopKKACiiigApKWkoAKKKKACikz70lADqbRSEgDnpTAGrjfH/jmw8LWDNJIGuGBCIvLMfQCqHxM8f2nhixaONxJeuMJEDz+PoK+Ydd1a71jUHvNRlLyvxzztHoBWFWry6I2pUubVmj4l8Tahr+qG8uHYSg5jwf9WM54Pr0568VlRorAycgt1UHoagUFlH8K+5yTVq0bykZQBtbALMMjOfT/PWuO52JBgDluB3z1qRFMgAYbVz9wf1qaGLzMzBchRn5h93nGfzP61ctbF5mG1cDPAz94/4VNy7DdOgaRiU4CdML0OccduOTk+ldFpml/wASoWHT5RjHtk9P896t6XYQwqrFWdgAV67PTPH3j7fhXT2sahfnRYwOAZMZ/BRwKiU0ioxbM+209GjxNt2joCcJ+Xc1pQ6SW5WNlXHykJj+YOB9BVsTRw/OqIDj78rD9AKhur+JkOWlkJHA2jGawc2zdRsI1vaQRstwZGPcSSMuT9ME1jahe6bGCoj2P0VlkfGfoRUN/qZjMgEDADgkJgDPrXPXdx9rYiGSbJ6Iuwn6bSefwqoqTE7Imv0tJFyiljjl45A5H/ASoP61zNydsoPmL1wHwQfow7VFfRSRTbWlO4D7s0W0/jkVW82RCQ4Y8cgNnI9vf3rpimYyZfF5Jb3FnMX2gqUbB/2m/of0FVprlgsityGbfj06n+uKZcnzLZ1UZ8s+apAxkEAHjtyBx7mo5P3nksvAIGT7jA/pVWRJ3vgokNHNKR/o0DHHTGeefzP5GrGqXIgg87HKk7OP4jxn8Ofzqj4ZlVbGZlHLliygdQqj+pH61T8TytPdQwIeEAB+pOM/1rHdmnQgvLsppeyMMHuTg9zt4z+fArHSQRNhRvf9AasXzHBO4AJtVefYn+lUo/kGOFHuOv8AjWi2JL8M79ZG3DrjoP8A69a9nqBBAjBb2UYH1zWJb+WWBYEkd2P9K0ooo3wu5m5zgcVLaKSOlstYlQDzZooVzwAhZj/9etQa2u3e8TgdA5jYAj6n/CsHT9NQkFXVMnqM5/LFa1vpdwX/AHV0Wx/CULA+g6Ais/d6lalmPWGmjYptkjGSzbWHf6YrH1Ke1nyAixSk4LKAQfwHB/Ots6XOzAzWY3ZyJIWzz9Cc/nWVfWLhj92QjsV2lf5VSiuhDk+pzN2ZIid2PfBz29D/AJ5rNl2SZwu4Hkheo9/WtW/glj/vjHbriseZ03fvBtbswqiDOutP/wCWls278qrRyc7Z19s1q+ZJG25Tu9cdfy71HMsF4OyS/oapS7k27FA5gwMloScqw6qa93+DHxHMnlaLrUu5gMQTMevt9a8O8poN0cwO0/l9ag/eWk6yQuyMhBVhwVNaU6ji7oznBSVmfdQIIyOlOryr4MePk1/T49Ov5AL+JcLk/fFeq13pqSujhaadmFFNp1AgpaSimAtFJS0gCiiigAoo60UAFFFFABRRS0AFJS0lABRRRQAUUUUwFpKKPWkAnaloooAKKKKYBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAB9aKKKAFooooAKKKKACiigUAXZD1qI1LJ35qI1b2JW5EaaacaaagYmaKKKBhRRRSAKSiigAooooAKKKKYBRRRQAUtJRQAUtFFACUUUtACUUtJQAUUtFACUUUUgCiik7UALRRRQAUUUUAFFFFABRRRQAUlFFABRRTaAHU2iigApc02igAJwOelcL8S/G8HhnTWCsDeOMRoDyPetDxx4qtPDekS3dy4PBEUY+9I3+FfKXijXLvXtTlvL2Xlzx6KPQVjVq8qstzalT5nd7FXV9TuNU1CW6uZDJcSHJYnhfYVSVQDwNzdv8APakHzL8nyRjqx71Yt13fKq9e3UtXGdiFiX+98x9uBV2KAkhpOAOmePypIgI8bBvbHX0ra0fSJr6RWJxHnBc9vYD1/T+dQ3YtINMtHY+XbqcsOWPAI/wGK6zTtHcDBj+UdM/dA78Z5p1mlvaReXZxeaVxls4HHQlq0txChryfYrMMRpkb+n/As+wrFyvsaqJbgt7W2A8+aIMerOeT7AZq6k1ohBUTyDHVI8cewOPXrzWVaRFz/wAS+2WMYy0spwxHc+3SrkseyIG5uGaPqSMIuf6/lUW7mlyzJfQAkf2Szg95ZgPr1zVebVrJcRy6RDweNsyn+lc9fazpdqpRFWQ4A2oM4+pIrCuPE8YyU06Fl9S6n+lWotibR11zq3hwfLeaVLAfZtuPw7VUm0/wvqgAg1G4tmxgCZS4/wA/SuNufEllOu2azRQewKOB+nH51lz/AGG4Yvp8j2sn+yw2t+p/kK0UWQ5I6zUfC2oW6MbC5t9QsuyBt4HpweV/zmuQ1C0WKXa8TWc4P3HBIB9j1H61asdf1TS5Qsx81egPqP6j9K2RqdnrEeyRVSTujj5fw9KvVE6M5WGN1PzJuK8g5+8vcccYxn/PRxtii7cEqwJXP0x/StS90xrSUtbkgKcg85Q/zH1+lLbRGVWMnygfeX+4emR7c8j/ACBsFE2tEVo7B8Y3HcqKR1+ZQD+Waoaku28uJhyVcjP4HArQsYnjhlUriRAfp1ByPwx+hqnrQ8q4MJ6g7j6Hrg/l/Os09TS2hg3LsVUL6lmPck/5/Wq4wOep9TU0oLQgn+I5/D/JFRhccAfWtTOxNCwyO34Vp2jTZHlITnuB1rMRtp649xirkUjDAbcR/tOcfpmpZZ0Fq1+xwIz9GwK3rJpolzNZT7efmjOTj6iuatJjGnFru9Cpl9q1LPWJIdoZWGOzmTH6jFYtFnT22rKreWJfLI6rMv8AU4rTkkjnTbMv3u+4cfn/APXFYVtfwzoTLAwUfedCroPqRn9akYwnmykxIc7Vxnd098/56VNmthaPcr6xoccoJjyvHHyn+X+H5Vwms6aYMlsqo753L/8AW/GvRJb97dT56ny/7y8r/wDWrOuxFeDMbq3qS3XP+11H41pGb6mcodjy6RZYPmKgr1DoeKhJSblG2t64x+ddTrOjyQsXtt0Z7qRkH6j6d/0rlpiokIuIjDKejJyrfSttHqjHVEkc7ACOcbl7e1RTQqVHOYz90jt/n0phkIXn51/vCnROY13L88R6ikMNLvrrRtShurVzHMjBlZTj8a+vPh54qg8V+H4buMgXCjbMndWr5EmiEifLyrdPUGuj+Gni+48J6/HMWY2shCXEfYj1+tb0avKzCtT5lofX9Oqrp95BqFlDdWriSCVQysPSrFdxxDqKbTqQB9KWkopgFLSUtIAooooAKKKKACjpRRQAtJRR9KACiiigAoopaAEopaKYCUUtJQAUUUUAFFFFABS0lFAAKKKWgBKKKKACilpKACiiigAooopAFLSUUALRSUUwFpKXvQKALkvX8ajPSpJOvWoz0q3sStyNqjpzU01AwooooGFFFJQAUUUUAFFFFABRRRQAUUUUgClpKKYC0UlLQAlLRR/nmkAlFFH0oAWkoooAKKKKACiiigAooooAKKKKACiijrQAUlLSUAFFFFABTTS5pKAEozRSGmAZrJ8RaxbaTp811eSbIIhliOrH+6Per91OkETPI4RVGWYnAUetfMnxe8cPreom0sZGFlCcIo79sn3NZ1Z8iuaQhzM574heLLnxHrMk8zfuh8sMQPCD0/xNckVyQX5bsPSl+7yevc+n0p0KNOdsakr3Argbu7s7kraIWMb2BblQeAO/0/xrSSHaoDD5jxtHQD0pIVW3+7h39vur/jWtp9lz5lwcDrk/wj/PQVDZaRLpemb2Mk/EakFh6e2T3/lntXS2NtLqSiOP/R7NB/CcZH1x0/mfzFbTLJtUaMAGGyj5Cn+L3PqOPx/M1oSXhuG+z6exjtk+/IByfTGeue2P0FZtllsXCxYtdNg82bOAR91D/jgf56VdtLC3t3LahIZ7kjLQx8n/AOuOntUOlKPK8u3Xy4WGPkYAn6HHTpk9DxjtW5FYrBnYoMx5Ynoo9/8ACpukWlcq317ceSEgRIVJyqKNxJ9ux+vOK57VLWRlJvZm+bgBjuP+BPbGCB710V7cLbhhCdzH70rdTj+lcteXYkyFUzZ4Kjjj3PYfTms023oa2SWpg3MO4lYlVsDvyF9Dgcfiayrl7NQwlkmnbHPkncB+OK0dTvYQ5Rz5jEYWCIDg+4HA+nP61mNBqE84jht1tOcBdmGP4Y3dPaumKZhJmXdbON1jKFz1bjJ/EVXeKEk/6PLEfXOK6SPwlqkymWS2lYjrI7BAPzGahk8OzQZy9sjD/psGNa3SM7NmRAJE+XzCyejDOP51etYw3KqYyO4PB/GnizMZ+fYfcAf0ra0e2RpADGJPZJMN/n8KhyNIxZLYzHyxFdEE9FKkEY9j2+n8s1fsLRI76JkG9TkOoH8PQ4H0z9MYNaMWgpOqyRqUQEZJjAIPvzg/Q4z1FX49Pezubd9u5gd0YyRv9QCehHbI5xg8jnFvsbJFHUrAwSSBGBjuLc+WR6j/ABB6f7Vc7rLmW5nf6qPpyB+mK7zUoRJo8UgOTFseN8fwsCoHtgr+ornrHTVubeSUNmRCuARjPzAZx7c/5FKLKaORkhYkKP4Rgn/P41HNb+V94YOOn9a6+PTNscdwFBPl5Uf3iSQOvpx7fSsDVUQXDKvIU4U9eB3/AK1akRymDKxTBBJ9Khju8Y5lB7FeKuyRjdlwFHTcTTRDC3EcIlbuQ2R+WM1orGbuT2mqyg7Y3cEcAtICPxGK3rHWLuNgZQ7LjP8Aqxg/kc/5Nc4tzJbuY2jMI6lVhI/XGa17Sa1n2faojknhkULn8RjNTJIaudpYX9lPsJQRTg8OnUfiOVP1rUFkChbZ50bdwQSR65HX6VyUOnyZD2Nz5gzgK39GOMfjit/S7xom8uQGGUAZQrgN+HY+/X25NY7bF2FmhkjO63k47qx3L6dc5FZNzJCZwCGtJs49A30HQ/mM110wiuV+ddkrHj/a+nr9K5/VbRihGwTKDwB2/rTi0zOV0ZM100R23KADONy8Vi6zp8FzGZI8DPO9RkH/AHl/qP0qzOJIlJhZpkAx5bj7v/6qzPtEluTJDkxH7yHqv+fWrSaIbuc1c2k1tIeqtn1yD+P+NQxzjfz8kvcdAf8ACuruDbXsQwADjgDqvsPUe1c3qVkYm+bp/C4rVNPcztYI3y2B8reh6GpJoxKpK8Sr1HrWaHKEK/Xs1XYpDJj/AJ6L+o/xoatqG57R8BvGpt5v7Cv5CYm5gLHp7V7/AJzXxJBM8FxDdWjlZlbKsODkdq+p/hf4si8S6DCzNi7iULIvvXZQq8y5Wcdenyu6O1pc02itzAWnU2imA6im06gBaKSloAKKKKQBRR+FFABRRRQAUUUUALRSUtMApKWkoAKKKWgBKKWigBKKKKACiiloASilpKACiiigApaSloASiiikAUUUUAFFFFABS0lLmmAUUUUAXZOtRHpUsneoquWxKI2qM08036VAxKKKKBhSUtJQAUtJRSAKKKKYBRRRQAUUUUgCiiigAooooAKKKKACiiigApaSigAooooAKKKKACiiigBKWkooAKKKKACiiigAam0UUwCkozSE0AGajZgqkk4AGSfSnE4FcH8TvFseg6TMqOBMR2PPsB9Tx/8AqpSkoq7Gk27I4/40+NnjtpNK04sfM4ndTgKOyk9AT/KvAXdS2S249xGuc/ial1O9mv7hpruQyysxPPQE9eP8+lVJGC/KeT3A4Arz5Sc3dnfCPKrEqqmdxiXJ5+dyxP5YFacMZjjAm4HaMcA/XFQ2UItVE04BmblUx09z7e1XSyWw824/eTNykXp6E/4Vk2aJE8SRwKJJcAdFGOp9AP8AP9a19LsJtQkXzRtgY8KT+ef0HtyO9Z+h6bNqF55tyTlcZzwF9v8APbP1rp729GnWKi1/4+5/kgXgbVHG49h/Ic1DLHavc/KNMsTjBxM2MZPp6duewA/CrGjW5mcIg3Qqcse7nv8AhnrnrWTpNs/yoSfnHJPULnk/iR0+ldzZ2oRAM+TCqgyNg5A7KPr39fxyJZSNG0tEjjD/AHQ3IfPQeo/oen1qnfakkcRGdkSk4B5zx3pt3NNcRiOAeXEegYfe+gHJ/l71btNDVys0wJb+FnxnI6bVHTHPPXNZct3dmvMoqyOcMVzqrBEWXyj/AAKOT2BPt2/pV+38LTXIKzSiC3JOUiPzNnqWPf6fyrrobaG0jKhVAPXI4/AUSTBslV+X1PAqudR2Fyykc/Y+EtKs12pA05PXcSq/kOO9XfLS1Ux2sMEQJ5WFAP8AP5Vf8wDO/HfsBmqN9qdvCoU3cUTEdyP5VDrNlqkjIv7VphloBnoWaYMf1rmtQsFBJkiljOOPkAz+RrT1LVJm3CG+glBPQN/hWFc3NyT/AK0xk9iwIpxlJlcqRlTRlMhJFIz3z+tSQhUwWhB75RgP06VNLJM2PPXzMnqFGfzxSQwo7A7UB/u4I/xFaXEonRaFe7nChsnpuGEcDvxnDfTNdSkCPjeRjJbH3OccEr/D9R/KuNsbTzA37zGOpK/y6/0rp9M86AoZcFRwjD5Sv44rJyRooM2DZfaLCWMIS+z5CwAJYHPPbnpkfWsLT4GDT2qhirE4BOOCvpnHcf8AfJ9K62wOQpGAOuR0H0PWobrThFcfaY1yF5IzgnByP6ii4rdDjZomtNOjYr8scashxjDkE/8AjoZa5K4tWZdxTcMHoOW/H0Feo6lZqbUoqDG8qregAz/Lb+QrmL+zRreUCA/vWUB9oCooz8oJ9zj/AICaFOw+W555cxdx8wHvwPbpVfylbIaFQfXOP/110V9YAM2AJWBxlRkZz2xxmsuRAmQB+JH+f5VqpkODC2shIuwQMFxkhJSM+/erEXhx2kDWE7QP3WVchj6ZHX8RUcNxDBIGZ4YyOzRkCus0C8t7pwkkFtPnoscyhvqN3NVzMzcUUdPlutLuBHqUD2crfdIP7t8dwOV79BgYJAxmunDw3cCrOisM43KOBz/njvg1qQ2NjPGbeB5Yww+a3kABP03Z/IHn0qM6LJa7vJYzxYxgrtdR6EYww4HbsKzbuMpxxzW6lV/fwdCvU/4/59qlkZLuEBZQTjBDDOfz5FSxBol3oPMGOApI/wDr/h1FQ3FuLvMtuxjmAyCMfN/T0pCZyOs2bLIWZSjY65HH0P8An0rnbnaHJYBZRwcDIb/PpXfXEi3AaG6QJP3wPve4/l+nXpxOsWTWz5ILwkcEDlR/nnB/+vW0XcwasYFyrQP5sWTEeSvXFSpdK8eJQHibrikmYwNk/PGevoff/P8AWqUo8pvMh5ibqtXa5JW1Ky8vLx/PCT+VUI2ZGAByR0PrW1FcbBuHzwt1B7VTv7EH99bcjOcDtVp9GJrsIkgI3gEq331/r9a7T4beI38PeIYJjKfs0h2y4zhh/ex61wVtIc+h6EetWI2KsNnflfY+lGsXdEtKSsz7is7hLm3jliIZWGQQcgip68W+B3jI3Vt/Y17JmeIZgLHlk/u/UV7OrB1yK9CElONzz5RcXZjlpaSiqJFopKWmA6lplOoAWikpaQBRRRQAUUUUAFFFFAC0UlFABS0UUAHeiiigAooooAKKSigAooopgBooooAWkoooAKWkpaACkpaKQCUUtJQAUnelooAKKKKYC0CiigC7J1989qiPvUsneoj04q5bEoiNMNPNJUDG0UUUDCiiikAUUUUAFFFFACUtFFACUUtJQAUUUUAFFFFABRRRQAdKKKKACiiigAooooAKKKKACiiigApKWkoAKKKbQAUuaSkzQAUUUhpgGaTNGailfYme/QUAZ+v6rDpWnT3Vw2I4lJIHU+wr5W+I3id9c1RwshaGNugJwzc8/QZwP/r16P8AGzxUVX7Bay8k9j9cn/Pf3FeCSNvbiuGvPmdjroQsrgTgjAy56e1XLCAIRLJ82OVz6+tNtLXc2X6fxH+lWZ51iUMBk52on94/4CsGzpSJpJBAdwG+4YZVT/CP7x/Clsbd5ZwWJaVzwSOT/n+VV7WJ2Ylvndm5Pqf8K6bT40sbdrpvmb7qf7R9fpUjNeBFtoI7RW2AqXmcD7iDr+J/qKz7ETahetdMoUP8saE5CIOAPp/gadh5bVUdj5t2dzknkRj/ADn8K3tLtDJhSrBBgbFPzNgfdGenGOe1QUaGjwIG3HjtuYZ57nHc+3bjNakJaZ1jhz5S8jnJPvn+v4D1qrHIHlW1iCu64DEfdX/ZUdz/AI+xrprG1S1UF+ZD83PX6/l/nmobSLjdklnYpGpeQ5J7Duff/OBVmWcRnEY+cjoO3+FJNIVGEIVwOV7IPf1PpWBf6rDaApGS7YznPJPv/jXNKbbsdMKdtzUkkVTulYE9c9QKyb/xLZ2zFVkXdkDBJJ/Ic1x+seJraRWV5GmwD8kUm1M+7Vgx6pIWKWz2lqDj7jqx/lg1UaLerKc4rY7CTxK15IFRJSOR8iE5/l/Oqk53HElvOm49JbZGU/i7f1rFjtXuDtnvpWGOWWAMv5rkVsafoCBsypE/fDROpA+metacsYiu2V5LGCUMVjskbPJVlDfkpYCmR6dIuVDHtlVOR+XWunjsoIxhYokCn/nngAfnkmrEdnCVCxqz5/2eh+g/qaXP2KUDmIdPiLDgoR1Ygg/l/wDXrUhtlGVV4do43NuH8q2ksWzjy2Az0KBuPz4qwtgjYB8r6KjE1m5NlpJGfbWm8ggQFexVea17GyCMCr89O5/lUsNk4OGLAdgV/wDrdKuwxMjfIYjz/CvT9Kku/YtWkRQjgAdyD1/DFX4yoUAlSD/dziqUZbHzqTjqzdAPp0q1HI33QGx6k4z/AIVXMZtXIJ7cKpwAQ3JHX0H8hWLd6ehY7VZBnt0HXIOe+WP5V03Jxu/TvUU0JcYC5B6cVL1GjgdU0bcrsMcDr5Ywv4tjA/L6Vy+oaYB0UnPHP+eK9auLRM9MtjgKMYPtWTPpG4kuoLH+H0/+vU8zRqrNHkz6ezZ4X8s0v9hORuWzZj/eiYfyrsdV0doyWjBU+1c9LdXlo52svB6Ov9RWsarZnKmMsb7UtMYK7ztAOTFcIw/EMADXd+HvFaXSrGZElI/5Zv8AeH0P+e/NctYeNUtXC38bQjON7L5ifpyP/r11VufDuvIrvDEGP/LaBh19eOf51ruc8lbodDc21rfLviOybqV459/f6iuevrWW3Zt4IbP+tTjn1/8ArfjWnHpd7aoHs5/7QtB0BYCVfow61cguY72IpIPMI68bXU+4qn5mXoeearE85J6TrzlT1919f8g9jWbHdR3KGKcDz8c44EnuPQ+/5iu113RFYFrZ9uDkHbyp9ce/cd/qK8612zlgkaYr5ZVv3i9QD6+4Pt+uKuBnIyNVsTETJFzHnBGMdexHb+X5Vi8IxU8K3/jprrLa9juo9knzS424z98eh9/Q9/fJxg6nZYbCnKkZjbHUeh9DWifczMWXdDIzIOOjpUkM/lsDnMTdPahtx+U8Sx8f7wqAFcHH3W+8PQ+tMQ/ULTf+/t+G7gVXRvMjz0I6irFvM0LbDzjgqe4pLqII32iHlD94Cmn0YPuXtB1KbTdRgvbVys0LhwR3r648Ja5DrWj217bnKyoCV/unuPwORXxmreVICvTqK9g+C3if+z9RGnzP/o1ycxhv4X7j8R/KtqU+WVujMK0eZXPo0HIyOlFV4ZOn909ParFdpxi0UlFMQ6nUyloAdS0ynUALRSZpaQBR+lFFABRRRQAUUlLQAUfSiigApaTNFABRRRQAUUUUAFFFFABRS0lMAooooAKWkpaQBSUtJQAUUUUAFFFFABRRRTAWgUUUAXW6nFRfpT5f60w9Kt7EoiNNNONM/WoGFJS0UDCiiikAUUUUAJS0UlAC0lFFABS0lFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFJQAtFFJQAtJRRQAUUU2gBc0lFJQAUlBopgFITRmkzQAma5rxjrS6VpU05OOqKfQ9zXQXD7U4OCf0rwr4z+Iw0os4WVgnyhAepPJ/Dgfl71nVlyxLpxu7HlHim/bUdRllZuWJJJ/hX0rHhjDMMZCj82PrUjr5kpLMW5yx7saJ5hCuFGZW4CivNbPQSsSzSlVCKQvHJ7KKhtlM82SPYZ5IFQRq8jbAdwBy7f3j6fSte1i4AXg+tGyGXLKEElmOEQZJ9P/ANdWXdr67SL7secAf3VFVmkyFhi4UHr6n1rT0e0a4yIgf3nyD/dHX/D8DUlm1p6CZpZQvyuAiqOyjoPxxn8K3Lqf7DGLWA7rxxiRwf8AVjso/X+f0SHy9PtxOFyRxCmPvMeAf8PTFWvDenL5kl5dtuxk7zz+OP0Hc/jWTkkVGNzW8O6ctlCMrm5k7n+Edz/nvWwuHcpEcxqcSSnqT7ep96glLOyxR/LLIOQP4FH+f5msfxFq8VlYssTrGiqQCOB7/hXLKbk7HVCCSK3ibX4rKJlicKAOTXlWr6899IyBz5Z4Kg4z9T1P0FJqF7Prc5kxttlbjeSAfc+/t/kzWNhEAGUSv/tDEaj8TXTShGCvLcmUnLSJQt9PmnkztYA/dKw5/LIz+tb1jpCcefayvn+OSErj8iM1oafYoxGbVJOfvFQ5H4iuitrKRU/dxQoDzjcc/WlOvbRFwodWZ1hpaLgQiBY+uVJB/Wti1hiRdqiV+OmT19zj+tXbezlb/WmUj0yDn65q/FZjGcKvp0OPw7VzOrc6FCxDbIMYXyQvfC5/pWlHtXjbjjq/H/66ktrR/lH71/wwKvw6eQf9WB6EmhNg0iqqq4wEMh9hx/hVmOGTjhUXP1//AFVfisz/ABN+AHFWY7VccJu92qidDMjhTvz+HJqxGvTarH3HArUjs8n5hip0tlH8O4j1quVk8yM5YAfvfgOtSJCOgTFaXkkDJwBR5WOgP+FHKLmKawnoAB7UphyMZOfarnlkc4AH0oEY+tHKHMZ/kYACgfXNRi2GT3PU1qFccelMdc8DvUuI1I56/wBOWVScc1x2vaFnovUcV6ZNH8vTpWXd2qy+YGGcCs3Gz0NFLQ8L1PSWRiBlP8/5/Oudmgls5jLCz2sv/PSHIB9iBXs2vaUMscZx1B9OxridU0sqW+XHpW0KltGRKNw8L+OtU0mRf7QH2m0HBnjIIx7gf/Wr1SyvNL8T263NpMsd2P41IyPr/wDXrwaawZJd0ZaKUdHQ4P8Ak1JpWs3ekXolD+VMOk6AgN/vqOCPoM/WuhWexzTie7yeYrfZtQVVlH3JAPlauS8R6V8xIQFsEbSMhh3B/wA+nTGTt+F/Fth4ktVsr8CK9A6ZA3e6/wCcGruoWbQx+XP+9t8/JKBgr9fQ0baoxfZngmq2bWEwmj3tbOSOeo9j/tD8j171N563UJimOZcbkkH8fv8AX1HqPUZPY+KNNEDyybPNtpBiVV7+jD0I/n9a8+uoTZTeUz5hb5opBxj0I9OmD/8AqrVe8iGrFS/h3MSPllXv6/8A1v5VlyjBLYwD98envW9MTMu4/LMn3vf3rMuo8fPGOO4/pVIkpnkBW6j7rCprabGVcdThgfX1qHACgZ+U9PY0x8q/zDHY0ASSRCJ9n8B5U+ntVzRrt7S+iIYqQw2kHlW7GoY8TR+VIcSD7pquc5IPDr1qtyWj6+8C60utaFBOxzLjbIMdGFdRDJn5W6jofWvnz4NeIza3Zglf91KoDD0I6H9cV74T0ZTyOld1KXNG5xVI2di7mlFRRvvXIp9amI9aKQUuaQC0UlLQAU6m06gApaSigBaKKKACiiigAooooAKKKKACjNFFABRRRQAUUtFACUtFFMApKWigApKKWkAUlFFABRR9KKACiiigAooooAWgUUUwLsmc1EelSydaiPSrewiE001I1R1ABRRRQMKKKKQBRRRQAlLRSUAFFFFMAooopAFFFFABRRRQAUUUUAFFFFABRRRQAUlFFABRRRQAUU2igAoopKYBSUUGkAUmaSjNMAJptKTUcjbUJoAwPFurJpel3Fw7AbVOM18seILx9Q1CaeYkO5Oc/wAAJzj6nrXq/wAadexLDp8TKcfMRnP0yP1rw+/uA7kKeO59a4MRPmlZdDroRsrkVxOI0Gzv931NVYcsSzZO7uOp/wDrU1AZ5Mnp29q0o0SFQz8sRlE/qfasdjpJLaAKu5sKD+lX0O0Z6A9BVWANJLlzkjr6LVxOVLDjJ2r/AJ/H9ahu5SFiQsowMyynaoz0Gcf0IrvdGsvsyjOBFBGCzH1PQH9T+Ncr4dgE989wV/dW68YP8XQAfQD8/rXclPItorcjLufMm9z2Wpm7DjqJFG1/dLvz8vQdwp4/MnI/E10NsVlxsIWztzkkf8tH9vYevrWXZ25mhKxHiR8Fum/Hp7A5/wC+ccd9+OFYljiHEMK7nb+QrmmzoporXMzW0Lbzi4mGTg/cUV5Pr+oHXdSkjQkafBy5B+96D8T/AI11HjrVnNs1vCT591ncB1VAcY/XHvzWTFpHkLDZqOQd9wR3c9B+AoppL3may191GXa2L3TgsgXH3UC5CD2//VXb6H4ZBKvJFuJ7MMn8Tn+lavhzRQNrsoOOh/rXb2NmiKMDmonUctEbRiomPY6IiKMRqpHTAxj9a049NC4+UHjqRWxHHwKnRPTp6VCiNyMqPTeQfLT8ulWI7HH8C5z6VogHFSAdK0UEQ5MpLaMR2FTLaDuc8VaAzTwPwq1FEOTIVtlFTpGo6AYpwGetSAVaRLYwRjvT9uOBTkFSbTVpE3IdtIV9Kn200qaXKFyArkjPamlfzqcpmmlAetKwyAqSKZjmpyKaVqLFXK0g9earvHhCfxq4V5NNkXjGKlotMw762WRNwHK/rXK3+nKdyEZB+6fT2rvJI+v51i3tuFY5HHce1YtWNEzy3WNJaJjgdM4yOCO4rBu9N+0RMVUlhwR3P/1/8+tetX9kJUKt94dGPf3/AMa4/ULI28vmKMdmBH+eKuM7CauebIZbOdBvaMKcpIOqH/D+VeyeAvF/9owjTdUwLxRhWPIkH9fWuC1zT0kUyAY39sdG/wDr1zlu80EyKhZZozmJs8/7v+Hv9a6U7q5yzie5a9pYSMzwDfbt99OpXtkZ6j+nBryXxJpQhdoP+WLktC5/gPdfp/Lj616h4H8Sx6zYCGfBnAw6n+L3Hv8Az/Cs7xdoqSq6D7p5RsdPT8R/KhSszK19GeKo7xEiQYlj+U57j0P+f6YSbaP3icow5FaWtWkkUhfbtljO2QHp7fgR/nFZS4Q/9M36Z/z/AJ/CujfUzKcqeVIQeYm6H0qJwCNrdR0q3Ko5ifofuk9vaqjgjIP3l/UUEjYztYK/HofSrMymVdwGJkHzD+8PWq7gSL71JbyscDOJY/un+lPzEbXhG/8AsOpQTEkJuxIPQHg/59q+qPC979p09YpDl4xwfVf/AK3+FfImRHIJ4htVvvL/AHTX0N8K9TN7olvIhzNCNhH97HH8sV0UHaVjnqx0ueoQnaxH4irVUUcOiyIcjqKtxNuXiutHNIfTqbRTIHUtJRSAdRSUtADqKbTqACk/nS0n8qAFoopaACiiigAooooAKKWigBKWkpaADpRRSUAFFLSUALRSUtMBKWikoAKKKKQBRRRQAUUUUAFFFFMBaBRRQBdk71Een+NSv1qI/jVy2J6kbVHTzTKgYUUUUDCiiikAUUUUAFFFJQAUUUUAFFFFABRRRQAUUUlAC0UlFAC5opKKAFopKKACm06igBtFFJQAtFJRQAUlLSUwDNIaSigApppaaTQAjVleI9Qj07TJp5TtVVLE/StRjtXk15F8adeENoLRXwCcsPX0/l/Ooqy5Y3KiuZ2PF/F+qyX+pXFy5PmTndj+6vYfXGP0rlpQWYIvfr7VcupHkmZ2++xyfY+lRBRGwQffbr3wK81HoJEsSiGMNgFj90EcfU+1LEGcluWZjwT/ABGoz+8cbe5wv0q5apufI+6vGff1qWaItQoVQKOSe9OlcFgsX8IyMj8v1OaJWwCq8M3yjPYdz/n3rR8MWS3d8ZZuII/nfP4gD+v4UIGdT4bsxZ20ETL8ygSSA93PQfy/KtaRXmb9yczTvsUkde34D1/CoogywSMUzK5AwO7t0H4Z/WtfRrQf2gZOsduvlxkjq3cj9axm7suJq20C2gwn3IYxyfyx9eM1HqlwIbHY4y0py/09P6VbX94i7hxI+85/urwB/WuY8WXDzJIsJxIRsX6ngfrn8q5Zas6o6IwtNgOo6pcapIoZFbEKjvjgY+pIP1Fb+hWe+7ZmwxU9QPvHuar6fCtrZwxR/djjB+p6f1J/Cul8MQDyQx5ySfTv/wDqonLojanHqdBZ24hiUdT3961YU2jnrVa2TPzenAq7H7D9amJTJVyOvHpUwGOlNUd+tSqK2SM2KOaeopEGKlAq0iGAHpTgKUCngenWrSJuAWngZxmgDFSovpVpE3AD0pwWnBe5p4WrsTcj20hX8Km2/hSEcUWC5ARUZWrBWmlalodyuV9aYRjrVgjFMZe4qGikyuV9qYVwMVYK1GR+faoaLTKsi5OKo3sQI3EfWtRl6VDKm4EEdayki0zm7hCMr3Xp71h6rahvmA4PXH+e1dRdwkLu7rwfcVk3sQdHQjnHFY7M0R5/f2/l+ZHJkK3BP91h0NcZrNuQxJG2RTz7H/Doa9J1S38xDxkj5WGOtcZqUB2kHnjg+uOMflW1KZM43Rj6DqclhqaOjFfNPT0fuPx/nXstpexazpwLn5yoJPfP94f1rwe/iI8wDr94H+tdp4J1liIwzY8zgH+646j6Gtai6o50ug3xnp7W1wZdnIGGwOo65/DqK4K5jCMR1Vvu46fSvcNXtl1WwIxtlXjp0NeRarZG3uGiIG1j8voD6fQ9q0pz5kYTjZmHIhbKt17H+RqAkuv+2vX3FWZAQMZ+ZDjPqKry9Q6VqQVj8jZHQ80SjG2VD064qaVd2dvUcioYiAxU/damSW7dw2Vbo45+vY16d8GNWNlqk2nzNw3zpn9R+X8q8oiJjcxtz6ZrovDt79k1OyuweYZAHx1K1VOXKzOpG6PrSyba7R/wt8y/1q5bttcqfqK5/Sbkz2FvN/HGMMPccH8x/OtwnKh17civROIu0UyNtygin0yAp1NpfpQIWlpKKAHUUlLQAU6minUAFFFFAC5opKWgAooooAM0UUUAFLSUUAFLSUtMAopKWgApKKKQC0UUlMBfpSUtJQAUUUUgCiiigApaSlpgFFFAoAtyfe/Goz0qWTOaiarlsSiI0005vemmoGFFFFAwoFFFIAooooASiiigAooopgFFFFIApKKKACiiigAooooAKKKKACiim0AFFFJQAUUUlAC0lFGaACm0UUwA0maKSgAptGaQmgCjqd0tvBLI5/dxgscd/avmT4oag9zrEpc/Mp2lc5w3f8un4e9e9eNb/wCy2kmSFWJGnc57j7o/Pn8K+W9fuzdajK7HnJI9vUn3rjxEr6HTQXUzC3lc/wATDA/2R602FSVLDkscCmv8ze7H8hViFQGySNqDH41zHWiQjywqIP3jDaPYdzV2BQsYK8Igzn1Pb/GoIY2kkH/PSQ4Gew9P8aluXU/Ih/dL1PqO/wDhUliA75CAMnHT0HYfia7XQ7dbXS0DdZF89z6jOFH48t+Nct4dsjf3aRk4ErZZs/dXnn8sn8q9B0dUurlZQuFkcT7RxhBhY1/KnsiOpfs4mjmgjbAcJ5j5/h/ycf8AfNbemJnTi8YwZXKxKffjNZZ5t5p4wC8+FT0wO/49fxFdLYQeW9nF0Eab245z/k1yTZ0RQmobYFMaEjamB7Dp/Q1x125e4lccqhO33xnH8zXS6vOPLkm4xub8gCP5/wA65VSflBAJ+Utn6jP9awOqK0LqsN9wBz5SKv1xk/1FdboMW21hTGCQCa4vSMzxXZb+OXA+nAr0LSU+XJ6gce1RLexvFaGvHgcAdBVmIH6+3pVeM9KtxitYozZIoqZRimJUqitkZtj0FSAU1RUoFWkQ2AFSBemPSgCpAvrWiRFwA7ipQv500D261KBirSJuAHrTwM0qin49aqwrjcYox9KfijFOxNyHbximkccVORmoyMVNh3IXWoyv0qwRURGKhopMrlaY49RVgiomFQ0WmV3HWo2FWGqCQVlJGiZRuE+b2ase7gIUleq/rW7Ou5T6jkVQlXLdOGFYSRpFnIX8WZCcfeHf1FclrlkQxKjhvmX6+leh6nbbSWUZ71z2p2weMj8VNZKXKzfdHkupw4Y7f4Tx7g//AF6h8OSeXdS25PysA6e3r/St/XbQxyb8fKSQa5fJttSt5fSTa3Hrwf512xfNGxyzjys9V03UDLbpMfvKNso/mf61jeNdJFyplj4Y/MCO57/rz+NN0u4EF8qk/urlQRxxu/ycV0Lp59rJAceYnKMe4/zwfY1jGXLK5Mo3R41do2PMAwwOHGPx/wD1e4rPyAfVX5FdR4jtTa3rMFIjfPHp6j6g/wBfWubuIgj4/wCWbnKt6Gu5O6ONqzIMYO3uPumoJlycgYz1HoasYPRuo5ppyR8oywHP+0KaAjbMkIkX7ydatWNxscH+FhhhVSM+VL6q/SpNnlyFex5GKZJ9LfDLU/tmlqrPuLxq4+oGD+PT8q72xkypiPVen0NeA/BjWdk7WTn5ozvjz6Hgj9f1r3NGImSRf4hx/P8ApXfRlzROGorSNaBsEp6dKtZqjuyFkXpVpDlcitDJklLmm0tMkKdTaKAHUtJRQA6ikpaAHUU2nUAFFFFAC0UlFAC0UUlAC0UneigBaKKKACiiigAooooAKKKKACilpKYBRRRSAKKKKYBRRRQAtFFFAF2Tv1qE9Kkk+9+NRtVy2JREfammnGm1Aw+lJS/SkoGLSUUUgCiiigAooooAKKP0ooAKT+VLRQAUlFFABRRRQAUUUUANp1NooAKKPrRQAUn1oozQAUlH0ptADqbRRQAZpKM000wFopDSUAIaZIwC5NOJqhqkpS2IQ4ZuAfT3obsgPIvi3rQisZ41c7rhvXjavAH4nmvCZPnY54LnJ9cV3PxN1MX+sTGJh5QOyPaeMDgH+v41w0owp29SNq/415lR3Z30o2RDkli4HU4FXoowCqMcKMFjUFlGGkGP4Bx9TV3jdvHJJ4z+n4dTUM2RIT5MZAGJZAAR/dX0+v8A+r1qCQF5BDk4yN2O/tTpG8ld4yzMcJnv7/Wn2cPVjyRwOPvH1/n+QpAdJo0LR6TcPEuZrphaQge+Cx+mMCu4tYDb6XM0IBaXEcfrjtz24U/99CsPT7Py7qC3B4s08pWB/wCWjZMjD6ensK3fPE93GiACFXYgA/wrtB/VQPoPepm+gR7lu2jEmopGP9XCFAPpwD+owfxrqWk8qC7nGPkTH0PJ/qK5/QR5sgmIBLOWz9P/AK/9K2brcLGFTyZn3t9O36YFcc2dUUYuu/uoY7cc4CoM+3J/9BFc8p2xyswA6jn23CtvUTu1II3REZiPxrnd+2wbsT0/X/CszpgXvDal4U9WcHp+Nelacu2BfcCuD0C3KJAfcY9/85r0G3AVVA9Kn7Rs9Il6LrVmOqsXbFWo63iYsnUVNHzzUKmp15rZGbJB7VKKYO1SAYrRIzY9BjrUgH8+aaBTxWiRDZIBninoOKatPAqySQU4cU0U4cUyRaKKKYDTSEdjT6ZUjGHpUbDipTUZqWNEJGajNTP3qFqhlogf/wDXUTVM/eoWrJmiIJKpSrhTjt0q61V5BzXPJGiKNzGHQ1z93b/KR/dP6V0hXBI9Kz7qL5+nUVzyRtFnnuvWIdZFK/eFea6xblNwxg9fxH/6q9o1W2x1HH86868U2O0yED3Fa0JWdgqK6K9tIbnSIpEOJIiGHt3/AMR+Fdbp9x58MbDg7Qy59+oPt61w/haT90YWPRimP1B/9CrodMleKIxDkxNge49KqejsY7om8V2C3dr58Yx0z6qR3/p+RrzS5hK7onG056H+E168JI5Plf5oLgbTnse30z0+teeeI7BobqVGHzp6/wAQ9a3oT6HNVj1OUcHoeq8U3cBhhVm6XGHH0Oap/cfDdD2rpMRJUzkD/eWpEPmwZH+sTpR22sf91qah8qfJ4DHBHoaZJqaBqDabq1rexEgIw3AHqO4/EV9UaNdC/wBIt54yMugYHrg9RXyZs2sUxyeVr3r4N6uJ9KWzlb95sDID7cH+n5V0YeVnbuc1eOlz1K0k3qV7MMj29RVqFsEA9+PxrNhbZJ7Bs/gav/xEDuMj611nMXKQU1DkA0+mSLRSUtMQU6m0oNIB1FJS0ALRSUtABTqbTqACiiigAooooAKKKKAFooooAKKKKACiiigApaSigBaSiigAooopgFFFFIAooopgLRRQKALknWoj04qWTr+PpUR6VUhIiNNNOammpGFJS0lIAooooAKKKKACiiigA+lFFFABRRSUAFFFFABRRRQAUUfWm0AFFOptABSUUUAFJS0lADaKU0lABSUtNNAAaKKa1ABSE0E00mmA0muW8cX/ANi0e9mDYZE2Jz/E3p9BmuoJwCTXk3xY1Xy7WC2DYLZnfHvwv6ZrOq7RKirs8N1yUz30nIPzcc+9ZMx7j12r+FW7lyzO46ngD3NVQPNuFQfdUY/xrzep6KVi1Anl2uQMs/CjP+e1TFAGIBwIxtJP94/5/SlLZkUryV+VPb1P8hUd24iiIU8R8Z/vN/nn8qXUoZuM12Ao4QfoP6k8V03h228i4SaYBltVM788MwHGD9Sv5GsPSYCqyMf4VAJ/2m+Ufz/SurtFDaZHFuKNey7iccBB0/Qg09hG/pfmfZgwz5shIUnPVsZb6AYz+NaUgWFJynEaxrEhPoBkkmqlhHtaWd/ljhj6emRz+g/WrG1p/s0Mgx57B5BjoOC38x+VYSNIm/osf7mKPG1mQL9M8n/PtVzVpN13sTjYAFI9TS6UPLE07j5UBxz3/wD1YqpJJicsT833mz75Fcszqpox7586heugxtjIyfxP9KwbpfkgRf4iM/5/GtqfLQ3rocloifxPA/SsyGPzNSX+6pOPpnFZ30OmCuzrNHgx5A9SCPwFddFjjPNYOmR4dB/dTn61uRDJpRNJl2IGrUdVY+2etWouK6InMycVPHUCe9TJXREzZMpxUqVGn6U9a0RDJl4+lPHFMA9aevSrRBKP1qUVCPapVq0Sx4p9RrThTEOooooEFMNKaQ/pQMaajbn+dSH8qiJqGUhj1CakPSo26fhUMpELCoWFTPUOcgHpWTNEQtVeSrDVC4zWMkaIrSjPI61UuF3L/KrrCoJBisJI0RiX8PmRn1rhfEdpujPHTg16NcpwfTvXLa9a7om9ayWjNd0eR2hNnqsyjgOMr9R/9bNdRCR9rVl4Eq/kRyP61ga1GIb6GXGAHwf5GtW0kL2MTqctCcH8D/hXVPVJmGzsae9UOx/9TIdrD+6T/wDXx+dVvEVs95aecoBuYQN/+2p6H8f51JKoYEZ+V/lz6HqD+tOsbgshjYBpocgL/fQ9V/z3A9aiL5dSZK55zeRBWJUYjbtjp7GsuWPqh6jpXb+JNOWKUyxfNbzcg47+v5/rXHXCsrFT99P1Fd0JXVzjlGzKkZHRvut19jUm3OY2HzLwPcVHKo3Z/hb26U5N0ke3pNF0PqK0MyeL97EQfvR9fcf5/lXffDDVhY6nCHIBjf5iR/CeCf5/pXn0cuGE0fHZ1ra0W5+xapbXKnCZwfYE04Np3IqK6PqxeW56Hg1dhbMYJ5Knn/P0rC0K7N5pFvKxzLsG4++Bz+PX8a2YH+YejjGPQ16W5wF2FsZH901PVSM7XGfoasZpoTHCnUzNOpkjqKTNLQAU6m06gBaWkooAWnU2igB1FFFIAooooAKKKWgAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKYC0UUCgC3J978ajPvUsnU/41EenFXLYlERptONNNZlBSUUtABSUUUAFFFFABRRRQAUUUUAFJRRQAUUUUANp1FNoAKKKKACkalpKACkpaSgAooptABRRTTQAtNNLTSaABqQmjNI1MAammlNRk4oAr6hL5VnM54wpr55+KF+J9RvGB4BESjP935f6GveNamVYArsFUtuYnsq/Mf0FfMHi+5e71BgxG53Lt6DPJP61yYmWljegrs5yQ7VVj/d3fieP5UlsNkII+/L8q+w7mmzHzp9qng8DPZRViNA0jSfwgBUB646frzXIdpKn7uMyDqBhB79v8fwqk/724hiHQH+XJP8AOprpz5ojB5HJPv8A/qFT6TDvZpguSzCOMZ698f8AoI/E0kM2LWJUt7eE5Hmu07kA8KucfyrdtogNRkVQPKtoljBznH+SB+VY9p5f22aRPngjAgjbI5ClefxwP++jXQaHH5kMULA77hg7knpwG/pSlohLc20VZbKztH5N3+8kI7L1Gfw2irMbbtVuJznZEu1enTILfy/WmQnNxe3ijCRKIY/bHJ/Wrfh2Dz22MBlmBbd3y3P6KK52bI6NV8qxWIjkjLfzNZErZjnk/wBrA/DH+NaeoOI2l5+6oB9utZN4oS1CnnLbmx65/wDrVyz3OqGxmXIMCqp4wsasPx5/lUehJ51wXP8ADjoPfNTamwBIbruZv/Hdv8zVnw3Dtg3EYLk/5/Wob0OqmjqtPQ/M3Q9K1YugxVK1QKgA9Kvwj5RiqihSZYjH5VbizVeMdqsR10RMGToKmT3qJeKmUV0RMmSIMVKOopi1KBitEQx4/WnimgU8da0IHinimAU8UxElOH60wemaX3FMQ+iim5piFJprUv1opDIyKYalPFRtUsaImFRtUzdahPFRYtELVC1TvUbioaLRXaoXqw4qFqxki0V2FQsOxqyR1qFhWMkaJlGZfxFYupxBo2+ldBKvHSsq/j4J6+tc7WprFnkHiy1ISXjJzxVHRp8NKnGCAwB9CMH9a6vxba8SEd/auD09zDdLuOASY2+nb+ldMNYmc9GddagSW4jfoyjB7gjis67ma1uYrjup2yAf5+hq3BKFUEnKqQ/4Hhqj1aEEFjja42ufQ9jWS3E9iaWOO5t3hO1o5RujOOAccj6Efr9a4TW7N4ZPMA/eRnDA85Hr/n3rqdGuCyyWU5w8Z+Unt6f596Z4gtxPF9oVecYkAGMe/wCHX6VvTlyuxhON0efSKrKVX7rcr/hVXcysHHDLWlcQeTOUboT8pHY/5/nVGZCDnHK9fpXamcrQ/dyJ4xweJFH860tPZd5iY/upB8rehrIhk8qTplT1HqKswsIn2klojypoJPoj4Vag01gbaY/vEGMf7uB/Ij/vmvQovusB1ByK8C+HOs/Y9UtxM4A3KCxPBU8E/gCf0r32E5/EV3UZc0TiqR5ZFkNuUEd/0NXEOVB9RVCL+JPxFW4Wyg/WtkZMmopKWmSOpaSgUAOp1NooAdS0lLQAtFJmloAdRTadSAKKKKACiiigBaSiigBaKKKAE/nS0UUwCiiigAooopAFFFFABRRRQAUUUUAFLSUopgXJKiPSnSdfemn3q5bEoiNNNONN71BQlLSUUAFFFFIAooooASiiigAopaKAE+tFFFABTadTaACiiigAoopKACiikNABRRTaACiiigAphpTRmgBuaQ0GkamAUhoNIaAA1DIeQKkNVp32KzdT0FAHH+P74QaTdtnnZ5a89d3X9P51836tLmeV+fmzg+2a9o+Kd6IofKEn+rX5vcn/AAH868MvJAZSSMlui+g9TXn13eVjsw6srkMEZJLdAx2gk1bkYRRlkyY14U/3j6/59arxq0km8nO0Y6cLU10FMip1RB93+8ff9KwOhEEUTMoHWWY4H07n9P0rYvlGn2+1PlMCBVx3dupB9st+QptrELSL7Q+DLwijPfrj8OSffA71TkL309pDIzN5rl3P1OCf/QjTWrBm9oEfyQxsuRsV2z7kHH49PwrqtMH2e3e7fkJHnP65/ID86wrZdsM0o43nA9gB/wDXP5V0lihluLa2I9C4I6AdR/IVlNlRRcmU22l29rITvbDSZ68nkfiSRW94Mg/0UTEcvlvzI/xP6VzuvSZeUp/rDhFx6DIJ/P8AnXcaNALWzWP/AJ5IB+PH+BrHoaooak5eWZBzl0X6f5zVG7HmSRICCMgjj3/+vVjzN14zMcjdn+f+FVZAWLcdWUDnpziuOT1OyJm6qN4cj+Jto9s8n+Y/Kug0GD9yvYKOOK567+e5ii6fNk+3U/1rttKgKwLxzS3ZvHRF+3XCgYq7GuDgVHEnT0q2i10RiZyYsYqzGtRovpVhRit4xMGPAqZajSpRWyRDJEqVajWnitCGSrT1qMVIP1qiR4penSm/SnZqhDqeDUdOzg0CHZoz+FJmjNMBetGaTNNpAFIaCfzppNIY1qiapTURpFIiNRvxUhFMeoaLRCaixU5FMYVm4lFdx6VG68VYIzULkL16Cs3EpMqyLxxWfdpuUg4zWsQrrlSGBHY9ao3SEdutc9SFjWLOC8T2+6NjjNeUaqhiu5FHG/lfqK9s16APE3uK8e8VwGKQsv3kbIoob2HU1Vy/pU/2iJWHIdTx7kdP0NaIxPaFH542E/TkH8q53w1cbkkjBx/HH7cgkf59K3Fk8udj/Cx3Y9CDz+hNE1ZkLVGDdM8E3nc74T84/vL/AJH9a3oZllQNwY5Ryccex/Ug1ma7H9muBJjK/dYY6qag0efy5Ps7HdFJzET69xVPVXJ62KWv6WVJAByvK8c49PqK5qYdGPXo1ejXKfaoDGQDKmNpP8X/AOscGuL1S0MM5OPkf1relO6sc9SPUwXUg4/Ef4VJEwI2N0PQ+hp0qFc/3lPrUeOfY8itzA6HQLorMIpCQ6/dNfSngTVTqmiQSSnM8a7JPcjv+I5r5XtnY4ZTiSPv7etez/CDW1+0GJmwJgFYZ6Nxg/qfz9q2oS5ZWMK8bq57CTtZW9Dz9KuQHgj3qm/K4PerFo25eeo4Nd/U5HsW80opopQaZA7NOFMBpwoAeKKSloAKdTadQAtFJS0AFLSUtIAooooAdRRRQAUUUd6AClpM0UALRSUtABRRRQAUUUUAFFFFABRRRQAlLRRQAUZoopgWn6//AF6Yfant1ph/KrkSiM000403vUFCUUUUAFFFFIAooooAPpRRRQAUUlFMAooopANooooAKXNJSUAFFFJQAUUU2gAooooAKSlpKAGmkalNNNACU2nNTKYBSGlppNACGqF0xzjsMk/yq6TWHrtyYLGeReuNq/icf/XpSegHivxT1EyXW3IKt++OPToP0FeXzZ6t95jnHeur8b3cdxqlzP8AdXOFHUkDgH61yIZpJyQoVRzjqfbmvMk7ybPQpq0S1agm6jjGMKfm/wA/lVoffMj52qdxC9WJ4Cj3/wDr1Hplt+7luGztA5Pdiew/KpJXEE8Sq4JjG8gdFOAc/UcD25rPqaoS+ldWlDYJjTaQOiknJA/Hj8Kdo8ebqSU/dhjxn8h/8VVKVi0UWeN7bj9ARn+Rrc0eLbYHeuWmY9OMjpj8y35VWyEbdinNtbsMltu4fhk/+zV1OlAt9tvE52gquef88gVzMT/8TGWT7wjRnz/n6munsUEOj20P3TKVkcntk7j/ACrnkWgtIPtOt2sDD5VcMc+i5/ruFd5JmHT5T3YZ6+3H865XwnB5moXl2TlU+QH8SSP0Wum1pxFarGxxnBY+wxmspuyNYq7MBGLC5kA43EKAemCB/Sox8kiJ2U5P4Z/+tTIGxbRA9WO4jPtmkT53384Pzfkc/wBa42diK0C+frH3uAxHPboTXoFggCjHQAV5jDqttY3lzcXUixxK5GPx6D1/+tV8+MT+7ErtaBiNkSoJLh/QbRwv4963pU23cu6tY9RUorBWZQxHTPNWFwe9eZxeLWiKpPEbeBui7vMmcck7mz8v6nntW9pfiXzpSFt/LjPIeZyP6E9B1rsUbGTO0VKkA9azLLVLaRATcxO3pH0H9f5fStOORW74+pFWkjJ3JBT160zPpTgatCJkPtTxUAbFSg0xEoNPBqEGno1UQTZpwaoAacD6UxWJs+lKDUYb86XdTAkJozzUeaM5HWgB+7vRnNRbvWkLe9AWJc00t6UzeKYW7UDsPJz1phNJu/KopZAoHckgD+v6ZqRoeaYahkulBOOSOoqhf6vaWabriZVAONoySx9gOT1/CpuVZmgxzVaedIx87BR6k4ridX8e20chiikETH+EDzJf++RkL+NcfqnjuVJM21vLvbhTJId+foAT+WKlvsWo9z1G71OELnew90B//V/Suc1DxHPbrL5MzHB+VpoeB/wJT/Q15JqHiTV7x8mVI5AfuogJ9uW6c+wP8qx5ne9kkicXGo3eSQNzHyxxnLDjH1H41PKytD0+bx39ncx3jW+R0aPemPzX9RWpB49szt81t0Z6FiB37MOD+leOwWl35YS2js1YfKGKCRm7EABSAB3/AKmn/wBgX/zSENC5HDblth9SMc/kKThF7ju+x7ZNqFnqUBe1lDccr0I/CvNPFttuSXv6VzEU2oaZKrvKpKf8toWIIH0IAI/L61tvq39pWuJgPNI4YDAf6CsHRcHdF8ykrHLaLc/Zr4qeiHzB7g43CuvuWVLiMsflcjOOevH9RXD3JFrqMExOFWTDHHRTXWy/vNKQH70X7tvbHT9MfnTrLVMxg+hfvIvtmmlX++nyHnv2rlI2IfY3ykng/wB1/wDA/wCNdHp1z3fgSqM+zD/GsjXbXy7l9v8AFyP8+o/lWcH9llS7mpa3XmpHIRhjlX7c9x/I1Hq1mtzDIAAD16f579fxrK0uf94A54l4OezDj9elb9vIZFKE/vo+mf4hS1iyd0cFdwsh3EYZTtbPrVCRMDjoeVPpXZ67Zhl+0wLlSMOmO3/1v8K5WWPY5RskHlD/AJ/KuynK6ucso2ZBC7KwfuDyK6nwtfjT9UhOcQzcdemen6/1rlimxgT91vSrlochom4YfMh/pWnW5k9UfWmhX/8AaGlxSsf3oGH+v/1+takB2zezj9a8r+Euu/a4TbSt+9aPBB7sv/1iD+denW774VcdQf1FejCXNFM4GrOxqZpRUcbblBHen1ZA8UuabSimIfmlpi07NADhRSUtADqKbTqQBS0lLQAtFJS0AFOptOoAKKKKABaKKKAClpKKAFooooAKKKKACijNFABRRRQAUUUUAFAooFAFhuuKQ9Kc1NP5VpIlERpppxpKzKEooooAKKKKACiikoAKKKKACiiigAptOptABRRSUAFFFJQAUGiigBtFFFABRSUZoACaaaWm0wEzSE0ppGpAIabSmmmmAhppNKaaaAGSNtRj6DNcN46ugln5Svgqhc+o4IH6bvyrtbo4hI/vHH515R8SLzbbTIWw0gJ4HQdMfjWNaVol01eR4prUpluJHLbhnKj37fpUFnb79wdtibS0knUgf5/nRcZluMgZOcKMZyfan3j+Sn2SIhthDOQchmH9ByPzPevOPRSJ5LvMkXlKY4oz8qj+EYJH4/KeaphiIi3PmyD5vc+n5jFG5mV0ThSwXPr1H+P51Z0+Auy46j7rHgDAyT/M0bDC3ge6uFij4G3GfQcgn6f410kARfL8sjapyOOiqOv4lj+VZMZVmWCEbYF+Z2xgy4x19B/nrWlC4GnNM3BlGEH+zz/n/wDXUy1BFvTiZ47vHWVkhX23HFdlqeI51hYjYijI9uB/JjXMeE4fNmskI4Nw0jDHZV/oxFdJHnUNTKhgDLIF4GcDqP5/pWUi0dX4ag8rTYVIxJO29vfP/wBbFR+MpRhh2IVBj/aPP6YrYs0H2higG2MAAD8a5jxPL52qQQggbpmY/RRs/oKwmzanuQOdsTbf4UHH60yVvJhkGcgRhee/DZ/kKM/vMEdSGOfxP9KjuyDbSMo5bJH5ED+Vc3U60eSalqEn9rzSxebLOHby9rcRnceQe3OT+tLbvewZaOCUFuWZXBZvXsc9feu50bwnBMix3cEUrZzv25B5PBz711lv4GsQsflRNCT/ABRu23PoVORj/wCtXqqcbWRz8kt2eSJqtzKCsRgGOqG3CH6kgD69qsQancWzhng8nBzut22YP4Z9BzXqUvgISNu3iVlOA3+rKe49/bofasa+8DSwAusUU3+0E2sc+oHB/DH50+dDUX3ORt/E99HOpNw2RkbZCQcd9pz/AE/Cuu07xxe221nnZRwuHO9fpkAEH2I/Gse58N3EKspgL+sZ5P4H+L9DWBd6PJCxa1LKwHKDgn2yf5UvdZVpI9s0fx3HLGPtamIA/fGGU/iOO1dRba3FcANAUkU8/I2a+Y7W8mtnby5Cso6lflb8vyP4Ctay16eGfeWIbuY8qWH0HHvRaS2JumfSdvqEMhALbS3TPerTShCpJ4Jwa8I07xxMX8u6k82FxwzDH0J9D78966fSvFpngMVy58l2Kb3PMbdg3p7Hp/Rptbj5ex6sJKUP0rldH1z7TDGlw224wVIPGWU4PH9K0LTVY52dGIWWP7wz29fpWhHKzdD0ob3qoJOnOamV896Lk2LINLu/+vUAbin5piJM+9BbmmZpM0AOLe9ML0wtVW5n8uMsvJUZwe/tSuNIteYN2PXmmyTqoyW4NYl3qarFK68mIb+OpXGf1AIrK1LUi00UQJwJdxIP8KAEn/vrA/GpcrFKJ0NzqIRgM85C/Unmuev/ABRDEZZQ+U5hhBON5zhn+meB9CehFcjq+ryCzacuy/IxLIeWdzgAH2WuL1W5mvoiuQIWPllVbAYAfdU/3Rjlvf6Gs3Js0UUdTrXjqaRTHpw3yEE/3V9CzHsB0Hc+lcjcarLJNuvJ3llUgAsOFJzgKg4BxnGcnHpUKSyJL5cShm3ZZgvVh047ew7Dk8nhItNeeTbGjMfm4XqN3JJPbPfrxinp1HZ9Clc6hLKjRWqNFFjOxcgkY4IxxjBPOfWo9PgvL+XyrWBpCfvCMYx7FugH+c12uleC1l2tet8uf9Wpwv1J6k13+laJbQQhIkWKLHARQKn2i2Q+RbyPNtM8FyMAL9mnkPS1tuE/4EeCe3X867TT/A6PBHFNFEkQ4+zp/q1924yx+vH1612VtBDBGFiVQParXnAdxSv3Dm7IxIPCllGMyZY4xhflAHYVI+i2cSkWttEpPVgAM/VuprWM4NQyTjHJpNoXvHFa14ckmUst5MvtEu1fzJyfzry/W9IOnzkxSAyE5ztADn32jH417xdOr/e6+lch4nt47i3k3c8dc1KlrYbR4VqyedGzKCARkA9vat3w3cm8s2Vjy8YPP95TtP58H8KqazAIppFC8ZyKz/C1yLW8eJ/uxuH6fwkYb9K0krwML2mb1tIIpirfdDAMp7DGP0/xq9qcRuLXg/vY8YJ7+h/Gsu7XyNSZHOA38/8AP860rS43QruPzR/I/PUf/W/lXK9Hc2WuhzjsqTbukUnDDH3f8/57VsQyvLHu/wCXiPg8/eB6fn/P0qjqtuIblsjEbH06H0/rx71BazyRMB/GgIwf4h6fTH+fTRrmVzLZnRrMjAyJ80b/AH19/X6+v/181zuuaZ5W5ogDFnch9D3H+fatNJVRlmU5glPI9DVo8oYnG4qMAdpF9Pr6f/qqIycGOS5kcKVH3TnB5XP8qRcqw/56JyPcVqapYeU2UOYm+ZGrNwx5A2up5rti01c45Kzsdb4X1aTTLqDULc8RSIZ045HIJ/EEj/Ir6P0W5S4Q+WwZJFE0bDuD/n9a+VtGmjjuh5vFvKNknGcA8Z/A8/gK9q+FOrSGE6bdt/pOnyGPr96Njx+uPwIrqoStoclaPU9XtzglfxFTVWBwQwqwK7DnY8UtNFOBpki0q0gpaAH0tNoFIB1FFFADqKbTqAFooooAWikpaAHUU2nUAFFFFABRS+9FABRRRQAUUUUAFJRRQAUUUUALRRRQAUUUooAnf71Iac3WmNWkiURmkpTTazKCiiigAooooAKPeikoAKKKKACiiigBtFFFABSUUUAFJRRQAUhpKKAFNJRRQAlJS0lABTWoakoARqbTqaaYDSaQ0GkJoADTGpSaYTQBR1OTagwcY5/pXhHxFvjJLNht0bH5Oeo6Z/nXs3iO68mzlYZ3NwuOcE8A/wBa+fvGcyTajIWTbDGdgXjJxwB9fX6VxYl9Dow61ucyCII/OJxIwwn+yucFvx6D8T6VQVi8ckmOWGFFPvpHnm2cbnILY4A6cY9B/SnqMyAIOI149sd/zrlOwmt03SJFk7c4JUZJJ4wPw4q5csqfuEwMLmUqchFHIUfjyT3OPSofMW2hJi2s5yu4dBnkhfzwT78epSGIttRh945Yf7K8fzB/SkO5dtoJJ4I40whuHCAn+6M/p/8AXq7qciudsHEIwqfT/IoP+iqoBxJsbOO244/kD+YqtF+/uII/77c47j/OakDtfCcHkQTS5+aC2VQSP4pGyfy2r+ddD4VhD3pmUYClioz2AA/9m/Ss20GzQDs+WW9uCR7AHaPzCr+ddF4Whxp8kqk/vG2J9Mn/AB/lWMmaROitgYrGU4+dl2j6sP8AFq4eVvP16eTnES8H6ktXY384gt4x0AUzenTGP1K/lXD6ecrc3B65x9Plrnkb0kXd25jjgM+AB2UEZ/rVe+IW2Tj0GPpk5qX/AFceechOh9Tz/jWT4km+zpEg4Cr/AIf4Gsoq8jpOn0iVREOcenFdJaXICjnPsa8y0vVflxntnrW5FrQUD5h05ro5mjXk5kegJcocA/zpHmTHODmuG/tsLj5uBSf8JEAR6dDzVc7J9gdlPFBL1RSfcVhanodleZ8yMA/3hx+tZcfiaLc2+TGPeh/ElvkfOM96LsXI0YWu+D0kBONx7MODXK3Oh3FsSrAyDPGBtPr/AD5r0o63byfxg/U1Uup7eZScg56VUaskJ0kzzOa0ZG6Mp6jAwR9fWrFhcyWw2P8AxDCOOQef8/T+XXXNtC+cAEVRlsYiTkYOMVp7a+5Ps2tibStUd5PKDmESNvgY/wDLOQDlfoe35V0763uWG9jO148pcxgHoevv/tCuO+wDYV/hPTj7p9RVu2DLMXbBLjbKP74GAD9RzT50LlZ65oeqefbsrNloTtz/AHhxg/lWxazfKMnooya8z8OXLW0qo7ZGzaPfGCP0z+Vd1p8+/v8AdXn61akZyjY3kbPWpgeKpRPmrK1pczJc0jHjiimtRckikbFZN7MY5OT8jcc9j6fjWjMeD6Vhai25JVbPAyPwrOTLRg6heG3aMbvmyYjnupZcf1rAubia4jlEbHzJGNvGc9F2ruP4la1NQi824RgD95T9AAf8RVCREiKnoFGFH4VjKVjeMTD14NdTRW8WSkXKgDgt0H6AGki0vZFhjyRjP90e3vx1rV3RxqSi4Pc1BNKF6n3qHI15SvbaXEuOMAenetu0jt7cYQKPU44rmbzWobdTuYAetUI9Yvbre1laTSRoMlyMKOM9T/nketL3mVZHpcF1GCDuGB1qSXWlRPvgHtzXnCQeIJ5EWTybQNN9nO8liG8syZwMcYGOvWqOoWWqmSzhivFka5mljJ8ogIseQXPPqBx70+VvYn3FuepR+I4dv+sB989acmuxOvDj8DXjkdteurva3bPaBvKgdk5upB94r6IPXnpUI1XUrWOSYp59tGwQzIeGPHQdSMnGaPZz7j9w9q/thT/FSPqoxw1eSWniYSNtZyjg4KtwQfQ1rRaszKMNms3Ca3KtF7HdzaoMHmsbULzerDPGKwhflu55pPOMp9fxpK6BxOd8QQZlL+tcgT9j1SKYj92TiT6GvQ9Vg3x5x1Ga4nWLXIZWrspyurHBVjZ3NbVEMtlFKv8AroCFY9+Oh/EYqG2nCyBx/q3GcfzH5GmaFdfaLRVlOTjypfqPut+VQ3KG2LBukbYI/wBk5/8Ar1k4/ZZSfU2rmIXNsVxmSPoT39D+VYUgKN6Mpxnpn/PY1o6dc/MEY/MPlz6j1/z/APWpuq23/LRAM9GH+f8AP5VEXZ8rCSurlS2nCZWUHyZOH/2T6/n/AJ6Vft5WJ+zucSx/cb1H+f8APFZEMi7yj/dYY+n+P/1vUVKVcKAchkO1W9+w/qP/AK3FSjchM2JY0uo2DcBvvA/wN6/Q/wCfSubvrZrac7hhlOCPUVt210JvvfLMOoP8VS3Ma3UOD8syevp60qUnB2Ypx5loc2UB4XvyuD+ldn8P9TlXxNp7gkmYrbSgHG7spP5A/wDAa5LyvKco/G1vyq1ptzLpupw3UDFWRgQw42kHOf0rtg7M4px0PraE7ohU8TZUVlaFeR32mwXEJzHIgcfQjP8AWtOI/Mw/GvThqcLJqWm04UyR1KKZTqBDqfTKdTAWlpop2aACnU2ikA6lpKKAFpaSimAvvTqZS0gHUU2nUAFFFFABRRRQAUUUUALSUUtACUtFFABRRRQAUCigUAWG601qc3WmnpWkiURmmmnGmmsygoopKAFopKWgBKKKKACiim0AFFFFABSUUUAFJS0lABTaKU0AJ9KKM0lABRRRmgBKKKbTASkalpGoAQ0w04000AIaaTSk00mgBGqG4bC4HU8VJVC7m28nv09hSYHK+Lrvy+pwkKNI/PTsP614Fq03n3O4kkDGPrxn/D8K9N+IupttNvG+ZJzuZRzhRnoe5yP0ry3Uw0e/PB+51/P868ytK8jsoRsrmSBskaRs7enHU9sUu9mwrcBQD5a9M+p9T1/WmyN5eAevX6Uunp5jqzdzn8Kg6CUAPexRk/LGMn+Z/lWxaReVH5jf60oCcjoTk/zP6iqWlwebdTMRjzX2A+g//VWjJMC5lAwu4so9hz/WpYxtzLmQqhbk8ZPQDoP8+tT6FGWvnlUbjChZQO5xwPx5qjGMqzkcj9Sa3/BibZIXP8U6H8E/eH+RpdCjqdVAtpIbOI5W0jWFWx1OMZ/IZrttPi8m3ggA2lV5+v8AnH5VxWnKbnWrdZuWLGVx6Yz/AIH867i1YSzO6jP+Ax/WuaTNUit4ilzBKq4CttjA9B1b9CPyrmrXP9nknrJIWxj3rU1xxLGxz1kYBcf8Bz+QIqjna0SMPuqCf0rnkzoghso/fEdQoya5bxvMVvQuQCOB+C5/9nP5V1UYyszkcBP6GuI8dSZ8QS88JkdPcD+QqqCvMuTsZsF4ycqew6Va/tKROp61icoxB57im+Y02B19s4z7V28qZanZGpLrBLBEOW7c4qtDNqN9cNAkwt5Bg7WBOT6H/PaoLO3je5gR5Aom5iKkA59vQ+3Q81Hc6/brYOkIZdRQYiZVODz0PoPb27VcaavojN12tWzUjs57i3Esss6ywyhLiLcAVBPGPY9j3rUstJtpo4ZDeP5UgmK7nwfkjDAfXOQa5fWNQ1jUoYb5bb7PFEDF5oH+s3Y4b1/LuarzWGpuyeXcEtGSwz90bhgkfUE1r9WkzJ46CZ3FroCz+IJdMFxPEVgE6sHzjnBBOPenN4evY9QvbS01A+ZapGzeauQd+7A46YwB+dcjajXGu1urS7ma9CFQyr2649x/9b0oin8Vfa7i+W4dpZCFnAXOduQoIx2yaX1dpaieLUndHRy3Wq6YcX9szIp5kj+YVestUgu1BRwfxrKj8cah9ngt7qygafO1pSdmQPUev5fStS60GHUYxe6RKqucE7Puk+4rnnTtudEK3NsaCnK5B605ZDGwPesjT7qaGY294pjmXqD/ADFbO3egxzWOxrua2m3ClkPAZSK7PRJgYifU15akrW8o7V2nh2/D7QapNpmco6HoVqfl/wA8Vei7VlWEm5Rite3Ga6Is5ZEwFMkHFWQvFRyrVkJmbPwDWDqbDn3Fb13wDmuU1qbYrYrGbsaxVzC1C5WInbWO8jSsST74pLl2mmODwKGQpH0rmudUUQXE6xISx4x61zrXV1q915FhlUBw8uOF/wATWhLaXGr3RtoSVhX/AFrj09BVjVNQh0CG3ttMtftN2D8kMSFs9znHt/PNXFdhSdlcih8PaXaX81veXC/bmiaSLz/m3Ljkjtxg5H9Ky9T8f2f2K4sdKtzMZrQIpUHCScrz68BPWqfiPS9Yu7nTrnxEioZiwiiOMRrnBGfXkfpUb6XbaSHu5ExEo3MSOFAr0IYTS8zyqmO960Ro8VeIr64WaOyAEcsl2AeBnyyoHPUBecdc1iXOt+JmtpVmXAnDxlzgFd53kD0z/SvZvib4R0bQ9A0V7XVHkvNRO1AjcSDaCXjIHQZXr1zXm2v6XLb27w+bKVK7xvHKnbwc/jW6w8EtEZPFz6syZPFt5DFYpqmneTZ7VUFFI3xDqq5454yasWuux628EEGy3uJiSM8R2qZOW92wcDHTrXXeDdJi1TwebG8jWQozwneA2CGP+IrlPGPw3bTomu9NdkVQSc9OBn+hqHh10Oini5dS5eWlm7pbWKRrBFhhKf4UxksT6k5qGDbHIqQZOQu5WPKluAPqcH8q4iPWL+yhktMZZ25Gc72GAD74xxitvS2lSP8A0uU20bN5k88zbWc4ICr6cE8jJ9K55UmlqdscRF7HYW8m5cjkHp71qWMRbt+NZWmM12qvDA6Q/wALuu3d/ur1x9cdq6rTbUuQQuMetefU0djsjqrkF1aFoc46dq4vXLMjPHINerPZ/ucFea4/X7LAYgU6M7M56sbo8ytHFnqJ3/6ib5X9vQ1s3y+bD5r/AHlG2X/H+TfnWZrNtscgDhhkfWl0q/bIST5zt2kf3wP6jt+Ndk4395HHF20YQs0Uxjc/Oh49D7f1/Gt2K6Wa3+cHcowwz1HX9P8APWsPVbFtsckDblAzE47r6e2P6+lGm3ZZuWCNj5kI4PuPp/nrWMo3V0WnZ2Jbu38tyf4Ccgjt/n/PsiylQRIAy42sPUf/AFq0mMbR4KgKfX+E+mfT0NZUyNA/ThTjmlF30E1YWTgCRWJHZu49j/j/APXFXrS58zCv8sg6GqCHaxZBwR909x34o5OWiyMclO60OKYJ2NO8thOnTEy9vX0qkkXKmXhXGD2wfX9P5+tTWl4XxHLxIOFPrVieNZYm7Z65H3T/AIH+dXTk0+VmVWN9Ueq/BLWGewn0m44mtzuQHupPT8D/ADr1KNsSj3FfN3gfU30fxPZzzNsUN5UueMqcg5+nBr6LR/8AVn3r1aErxseZVjZl6nCmLThW5iOp+aaKUUxDhS02nUAOzS0yn0AFLSUtABTqbRQA6lpKP5UgFoopaACiiimA6im06kAUUUUAFFHeigAo/WiigApaSigBaKSloAKWkopgTv14plPamGqkShpptKaQ1BQlFFFABRRRQAUUUUANooooAKKKSgBaSikoAKKM02gAooooAKSlpKACkoptABSUUlABSGlphNACmmGg0hNMBGprUpNMNADJThcetYGsXPloSW2A8D2A5P8AKteZ+WI52jiuJ8UXLmGUJIMN+4XI9T8x/wA+lZVZWQ0rs8/1svf3V3fKMn/VxgDsSAMfkfxrgdVf9/5e7Kr79e38q9F11hZ2VvE+AyJvYeh6fzzzXmV+xJY9N3Un/PtXmzWtjuo6ozZWMrsc8Z5981es1Y7tgxhCR/IfqapsA8iqmRHnOfX3NamlqSjFeDI6ov0B6/nn8qHojYuBTBb7YxzIxRf5E/z/ADqOdgFVAcjGeR15JH+NIW8xsn7oTauPRuP/AEHP6U9TiUznldx2j1P+SDUFBdAxgoMEoACR3Y9f5Cut8OwRxQW4fJ3cEfXap/TdXKQrv+xl+TI/mNnv6fyFdjpQxKR1ESHI+rE/+y0paIFudHoChbi8u8cYKrz6nP8ASumsMxWDOTyQevtn+tYWlJ5el5GWLtyD2yAcf59617tjHZCLPVcf4n/PpXHJ6nQkY1+5e7ijXjyxwevTFVoyCszjIOcD8zTIZPNuZpN3GzJPoDz/ACJ/KpLcb41HC5Yd+vJrBs6IqxYAC2m3GNzAc+mQD/WvOvEQ+0apcOxyC5H64r0iYhEiLH5VUuf8/wDAq4F4GnmIxnqWx+v9a1oOzuNq5zc7iFR9qVlH9/HBP17Gs64v7ZBvWVVlU8EN159q627sLlIB5RBGcfMMmuUv9MjWWSSZVZgcEqmBmvQpyi2YzU0tDLMs+oMET5V3BizDvggkD6H9K7jwT4TRpvPdVyBldwySc9aztCsbO68uNp2gvt2YwTgN9K9R8M2ctviO6XBH3XUYH4110pR5rHJVhLluil4y0ma28MW0KRxeV5mG2/wt2/r+lYfg/RpL+1uSxx5SYK9xg+/1/SvWNW0/+0dDns3wvmJ8rDnB6g/mBXnvhG7bS9UmFxDyCY54mHA7Y/qPpXe5J6nluLQ/4deNI/h94g1O3vdFn1C2u0Vop7VVLxkZBXnscjPIxt6HOap2mqarqGva3rN3YJptpesTHakZIJYYP1wDk8Z9K6W4h06G9N1BuIYYCFRkH0689KoagwkLNcuIYVHze1ZyjoVGWpB4d8O2/iLxPA97DvtmWUyKSPmGwD+bKQaTXfDepeCrwzWDNPYse4yCP9oeo9RXd/DHRZ7cTX95btDJKoWJXXBROvTtnPT/AGa7bVYoJLORboIYSOd/SuWpTUoanZRrShPTU8VtJ9N8VQBQRDfJ0GRuH09RRDZz2rmC5X5h0YdGHrUfiTw0EuDdaSpgljc+WyHocZGceuDW14N1Ma3G1lqCbL+34cEcntkV5c1bY9qL5lcxdQs22ZxS6BctFPtPY13Gp6JshxjPHB9a4t7Vra+6d6XQV0z07RJt8a5PauqtRkCuG8OSfIoNd1YHKitqRzVdC/Gny1BcLgVdhHy1BdDrXRbQ509TB1A4U1wevyFmIFd1qhwrVxF/D5s2PeuWe50wMa0tC3zEZqW50+WZhFGCpPU+g9a6jS9PD44zUXilxplgRAMzycLisbHRF3dkcXrF2umwrp2lKHvJePoT1JPYVt+AvCSWudQvj59zISxkkAJJI/lUcekadY6WspmE17PgyTM65blcqPYDcR+PqK6mw1OO2QW5cT7Bw8f8Qrpw/LCV5HPioznC0DnPivZM+jW1ygyLaYb8dlbg/qBXNafa22saHJFMitLtKSIw6g16jfTWGpaZPFc48qRSjK/y5zXnH9jXumThYFa8jBwjoQsgGeAwJAP1zXpRrR6s8iWHn0Rx+heD7rTNejubu8lms7VWFtFI5YRFhg4B4HA7e3pW5q4+0yiSTABwqjgcdBWtczziLJsL53HQLbuc/Q4x+tN/4R291MeZqSnT7DHz+Y481xwQBgkKDzkk54xgZzVqrBLRkexqN6of8LrJl8LxSvwbiV5wCOgJwP0ANbPjKITaYbZYjJuA3DOBg+taP9raDpFt5Ant1ZAsccMRyQegUKvsOmO1crrHii6ufPtNLtmtBIpcTSplmxjJVenAwe5x2rKVeKWh10sNNu7PNNf0mAym2uPIjuMb0iZeo56D8P8APbM0fSkW6LJaoZkOcKN3HqAa25LGW81FzqTNK7MBJLwWTklWU+h6enFdHpOlHzDsA3ZBfA6E9GHsf0rjq1rI9GlQV9SXRLC4mcOSHUjoQev1zXd6bYFIxvAJ/wBnpUWl6esIDAYcjBZe/wCFdDDEFQYGD34rzX7zudcpWVijLB8mO1ctr9rlWPtXbTL8tc9rEWUIpbMz3R4z4gtsIfVTxXLoMScZx1Feg+JoAqv6deK4eGMCZlbsa9Om7xOGatIvWty4/dyrvDdhxv8AcejD9ffkGG/05GHnQfNu5ynceuOxHp/TBMjw/KY3zjsfSqX2p0kJlkbg5YgfMh/vD1B7j/Go5dboPUmsruS3AEy+ZCR972/z+orTkEc0AMTBlIwPX6H/AD3/ACz47mB2yZFSVu5HySD16cfj+VS/Z2VvlTyifUnB/GspLUpAV3qMcHGR/hVeQMjKyPt9TVwg5ww+Yn+Fhz/9f+dQTBhz/e6bjjNJSswaIAyyHBG1hWlaXPGycYY8ZPQ/X/P/ANbN2BjsbA9G9Ktwp0L8kcEHvVOKZnexfkXJ77k/PH+ePxH4+9eAtWOq+GLdnbNxAPJk+q9D+Iwa+foLxCVifAmB+QtxuHof5V6H8MNWWx1gwM22G6Gwqf4HHTP45H4114apaVpHJiIXV0e4RNuQMO4zUtVLFsxlT/C2Ks16ZwDhThTAaeKBC5p1NFOFACrTqatOoAWlpKKAFpRSCigB1FFFAC0UUUgFooooAKKKKAHUU2nfhTAKKKKQBRRRQAUUUUAFLSUUALRRQKYEhIz70Z9aQnmirkShppKU01qzKCiiimAUUUUgCm06m0AFFFFACUUUUAJRRRQAU2iigAoopKAENFLTfpQAtNopDQAUlFIaAAmmE040w0wA02lptADSaZIdqk040yQZH6/WgChdMY7diDhjwM+prgtXU3eq7EbAgXgkdDkEsfyP5Guz12ZYrf5uBz/n+Z/CuNsF/wBCmuZAV88s5z1C8/5/Guep70rFLRXOI8ZTbjOvCYKwKvUgABj/AIV5tfOPNJJyqngV3PjK633TZ+8BluO5OcfgCB9c1wUzYy5HA5+prgesmd1Je6RoD5oUnn70h/pW7CBb28S4+bywfxbp/Nv0rJ0+L5139WYbvX3/AErZuHZd0mDnASMDsSO36n8qmT6GqGSYLCMdidxx+f8Ah+HvUdxlllwOgCIo5570RhYkkIzkDAP86AfLjhYD+LPPtz/hUlF20izqSopz5ShR9AAo/Xmux0gK1nPNjG9+Dn+HqP5muS0EF3bA+Zm6/j/9jXbW0QWGC3ABV2AI/wBkcfyGfxqJvQcdzfscqyRsNojALfXGT/h+FTasx+zkZAcx4H+8f/rmobEl0lkJyZZCB9M4qHWZstg8gEEn0xk/4Vwyep1xRTgbMV5IMAFtqj2/yasQr80aHgBf8B/Wq0OPKhRhgcucf59/0q/CD87N1AAP61m2bINTbFlI5H+s4H0GT/Q1gaba7zvP3iM/rmtjXSVVYVPKpj8TgD+v50/T7cY4HYVUXZGkUU5bEMAcdBn8a4rxFp7tdRkLuG8pGmPvNg5P4EY/zz6qbbdHx6YrNudJ3sGdA7KMLmuilLlG4p6Hkx0qYzw4XLKwznpg9Sfyz+IrsPD+oazp1wILe4F4oVS8d2MqmfRuv4e9aV7pbCRXXqpLEY6/KRj+VSWsKR7nC7STuYg5z7/oK61V7EOkupqQePkdngm0xgYpPKDwklGYAEqDt6gfyNR6y+lalNbzyQ3tlezAKksIVickqqspPPI9jjviodKsXtbG2RgJZgd5yesjHcx/76NX4rESyHoQRtizzgYxu/HJP4CtfrEu5g8LTa2K1taRSNaAaspErbUkFowyeeSN/H3T+RrQk0nTrO8LPeXs2pQxebHKI0aFWJIU+WQecr0JPqMEAiI6Uy3mngOwjSVmkAc8oFIA/NhW1aW8EbSFvmDOCoYZK8dM9cd8e9DxErbkLB009jbsLyTzHjmmnJkPyscbmXtkLwD1B+nWrN3ZJeYEsksijkb3PFZUIiVtscXIJweRjJzWhbh94KEmsXJy3Zt7KMdtBi+FzJkpdTqrfw78j8iKqW/gaGx1MagJ2NwvQgAAj0PFdHa+auMHb61cmdmi+bkUeyujOVSSe5lS4ltyrDkVxOq2YNxkdjXazjaxx36isS6gDSk9qz5baDiyLQgUIrvNP/1YrjLCPbMK7LTT8q/StKWjJqamzEflFV7zpU0R+WoLrvXT0OVbnPapyDXOmHMhJ9a6TUhway1jz1rmktTpWxa08LHFnoe1XDYW17zOuQBn/GqkCkYArRh+6BRGKb1FKTWxQbSrC3yIrZF9CFxVWUxxKVEa4PU46mtiWIEY7VnzWZOStU4tbFQlf4mZss0Lw+Ug2r3+lUZBCjDypDEqsX2hT878Y3H0wCCD2OK0JrB/7oP0qobeSPPyHHYVN2aqKMzU5pbqZYXmcxKGkVkO0A8hQSvTOQeM/pWHBaX8l3NHfTm6tooYTCshySpZ8b/7zrtHzYycn146p4uc7OQeMjpVQ2xN1LIFYFkRSfXDMf8A2anzWHynK+JdJt9QulvGjzNGfnIOGZcg5B67l+8D1/OpXtJDG0JZTOmGjkxxnH3senUEdOvrXRnT3eQuq4zxipbfSdp6VHPJlWSONttKaeaCbyyjbCsinupOcfga6nS9LEeG2gHGM1s2+nBTkLzWhFbYA4qGm9w50tirb2+1farITHarKRYoKVDjYjmuU5lyKwdXX92eK6GYYFYWq/cNZNalI8x8UJ8j9q4GRAt4pPRuteh+KP8AVufauN1K12rE6+g5/CvQo6ROWqtR5XzLfGAZFFcpqu6KbzUyGFdeyGOGN05OOvWsDWIfNjY4xmrjoyJ6oyYpWVx8u6NgDtx0zW1bTvFE+0lcDJUcq35+1c+FOyHLYyCP1NbK/NICf44wD7+tFRIiDZZF6GYByB/s46/Q9uacbn5tq4Rz1Ugnd9R6/nWY6bJQT61Lv2KAwypOBjqtYuCL5mTpOTId6bGP5flWhG6RqrMNxOcgdD7Y6isaMZxk70PdeCK6Swtg2ntgjEZ3A454x/8AFfpVqJlKRXukSaz3I3MZy0ZHb1Hrg9e/TtwL3hV5ZJjEM/IAwbBLY6AY7/8A1qyyu3BYZYZwT3IP+GKsaOtwLjzLR5RIoyVQ4JA/r/hTRD1Po3wFqx1TTcyEGeP5JCP4iOh/EV1P868d+F+tpNrTYGwzgCRM8BvXHbJP869hWvToy5oXPPqKzFFOFNp1amYoNPBqMU8UAOzS03NLQA+lplOoAdRSUtABTqbTqQC/SikpaAClpKKYC0UUUgCnU2nUAFFFFABRRRQAUUUUAFLSUUALRRRTAd34pab35pc8VciYiGm0tJWZQUUUUAFFFFADaKKKAEooo/WgAoopKACiim0AFFFFABSUtNNAC000tNagAptLSfSgAammlNNoAKYaU01qYA1NalNMJoAQ1HMdsZPfoKfmq13Jtx3xz/hSYHL+KXeffDC3QCEnPKlsZ/Q1kaqVjghtlIUN97thB1/oK0JsSSyTtyqu2D/ePIz+ZA/AVh605f7c2MfILVCfVup/UGuaWzZfWx5f4omM26YkBpnLfQHn+XFck4MkmOw5OfX/APV/Kuj8Vz+Zfv8A3UGQP5f0rBhQng5wOWOK4T0aexasYwG3twApbpzz/Xj9amlYnyRkfdMjD0z/APWxUUjbY2XjLKGb2HYflUzg+eFx/BH3/wBkH+tSWMmH7kRfxEZH1pxffPgHIXj9D/hSuSGDqAWZsKD6Dqf8+9Ns0Xc/HbC4P1B/pSQHS+E7fcqyDhsqBnueOfzJrprVh9tJXHlwJge3AX+RrH0NPs0UeFGEi8w475//AFtWzYoRCxbnzCPrzn/CueszWmjbsAEhhGPujOPfFZupv5sxCk8uB+XH+fxrQRvlc8/d49utY6sXnVjzxuHtnP8AifyriudaRai/1jEchQBWjZ8+UAM5YsfoP8is+3AZDjgu+B+daNuRFHNKeBGm3H0GT/SluWZ96fPvTkdZNv4Af45rb0yHjP0rm7Yl7s7uqHB+vf8AWu00uPKjFaWNlsWYbfIFT/YwwIIq5bw8cVdjirWKM5M56bTc/wAOaqyaMrHO3B9q67yR6UfZge1bqBn7Ro40aQykbTwO2KsRadMGBHaurFqPSpVtgO1WoB7ZnNRafMTluvTNW4dKOcsOa6BIQO1PSKtFBEOszNh08LjPNXordVxjirSxCpAnNaqKRjKbZHHF0pJRhcCp8YHNQy+9EnoQk7mXcr1NZ0qdeK1pxWdcDrXOzZFe0GJPxrqdN+6K5m1Hz10umH5RVwFPY2YzgcVFdH5akjPy1Hc8pW/Qw6mFf9DVCFavX3eqUVYPc2RZiXDVdiHSq0dWoqcRSRNsBFNMeKnUDFLs/OtjKxSMWaie3Ddq0vLphj5qSkZbWa+lQmxHZa2fL9qTyxU8qKUmZAsgO1L9lHpWoUphSk4lXZRWACpPL9qtFKaVqWgRW2Y6VFItW2qvL0rGSNEULisDVeFNdBcnANc7rB+Q1izRHnPifmOX+tY+sQ+Xp4PA2qM/5/CtjX/3rhMZ3OF/MgVz/im63zLZwnd034/lXVHRIxerZQNyDDgDBKgYxVO7ikKFphhcZFa1jaiCWNpxncM9KZ4slRYtsQ5YACrUrkuNlqcUEUiLAyCx/DmtSFPliPocGqMSFXgUjB4z/n8a1oY/3T8dGNOozCBSuUPmAY61DtPlH1DGtG+i2k/7JzVEDa0y49DUrYpiW6lGK844OPxrpdCG9YkIO3B6HAztxz/4737Vz0Cn7QoPr/Kul05f9HATK/u25HHOAfyGKpGMyG6h3tKu0ggq+MdipOP8+lV7Qtb3MM0LFZQ3GD/KtG++U25IKyl94G3GFXhfw4NMv7TyWxtIAjU8+pz+nFOxFzehl+wX9lqsTAF3HmIDjB6nPP8AnivoKxuVurWGeM5WRQw/EV8+6TP9q0O7imyHUBgDz935d2T9B+dexeBJ2/ssWsx/ewgcexGf6114aWtu5y111OopRTRSrXYc48GnCm0CgB4pVpop1ACin0ylWgB9KKbQKAHCiiigB1FFFIBaKSloAM0UULQAtOptFADqKbRQA6iim0AOooooAKKKKAClopKYCd+Kfmo+9Pq5kxA0jUtJWZQUUUUAFFFNoAKKKSgAoopKACiiigAptFFABRRRQAlFFJQAU2iigBKSlNNNMBDTTTjTDQAhNITQTSGgBGphNKaaTQAhNYusTstu3ln95I2xP8fwGTWrcNhOOp4rDlzcXkjD/VxDy0+vc/yH4Gol2BGfdII4YIU+7kZ9gOf5gVxuv3TDexJAVTIR6sx2qPyz+ldjq0ogZnbgRxkY9SSMfy/WvPfFLtb20SP8zSYmbPrjbjH+elctZ6M1pq7POdZffcSknJZv0zx/Kq6IEKxEZYk7yOwHb/Pt6VJMTvaVhjqU/kKrMuyJ8dSAg+veuNHoLsAbesrHq5447Vozf6+YnIHCjHtj/Cs3b+7hX1Oavk7pZCeeec0mUhhJ/eSH+FcADsT2H6/nU1lGZYxGo+aQiNccYJwM/rUFyx8tc9ZG3H88/wBa2NCj/wCJhCz8i3QyP7EKf64oA6jGxGEfAZxGvsF/+uf0rSsVy8QYHAC/y4/mTWWP3dtBv6hCx+p4H9fyrXh+TC9/vY9OOP5/pXBWd2dNJaE9zLttXIyN3SqG7JY/gB+GP/ZqmumG1VxwMN9arJ1ZvQ46e5rnOlGhbLhVOeijjHc4/wA/jU99OIdPiUnG8l2PsOSfpnA/Goos7YkHVuTWZ4puPKhl2cBVWBMH3y36f+gmqhqxsk0NixDN95jk16BpS/IOxrzzw8dxUdMYNeh6UflFaPc3+yb9uvAq4i1WtjxV6OuimjnkASnotPAp4Ga6EYMYEx0p4T2qQCnha0RJEEqQJUgFOAqhDAvrTgMU8CgiqJIWHf0qvP3qy3vVWfpWcikUbg8VmXBzmtG5PBrKuH9awe5aC1P7z8a6TTDhRXL2Ry/410+m9u1awFLY2F6Uy4PyGnR/dqOf7hrV7GPUw789apwmrl+OtZ8JwcVg3qao0YTVuKqEJ6Vei5oTBl1OcVIBmoo6nWtkRYMUFPangUuKoREUphWpyKTFAFcpTSKsFajIqWWQFaY/FTnioXrNjRBJVSU9asymqcrdaykaopXTcVzWsvtjYj0reu34NctrjjyWGcZ71j1L6HA6zKRICn3gwIHvnik8P+G3mn8+6ySxyc1dt7c3WpLxkKcn8K6y3lEKhQOgxxWlSTWiM6avqcr4l05be33JxsHWuKuoTc3EaliVjUEn3rv/ABX5k9s23ox5riJv9HtbmbvggVVF3Jq6I52NfN1Djp5mB9OK2IYsLKOxOf6f0rN0WPN1AD3kH410UUWbi4H90Hj9aus9TCnsZmpxYcAj7wGPzFZYTEyk/wAQKmuj1yHZNFjg4/wIrFu0CHI7PkfSknoNlaFSZsAZIJH5j/8AXXUWw/dqPuqg5YgYUDAJP481z9soE+7BODu47/54ret0V4AN2d0aqRj+83T36D860izGoSQo11qfdTgJtYZ2rldo+vr/APXrd1WzN0Fi8sedNGUJY4OQQ3/sh/MelHhy1+0+fLIv3lbHHY8D/wBA/WtrV7cQ3UMncTLgZ/hI/wDrGtox925zSlqcbpE00FxaMGV0ZtjKTncAd2D9d36V7RoZ+zahbyL/AKucFGJ79wa8i1SyNlf3IQFBGRcRHpzz0+mT/wB816lpMn2jQIJ4/vKiyKPQ4DAf0qsPdNomrqkzu1p1QW0glgjkX+JQamFegcg4UoptPoAcKUUwU6gB9LTVpy0AOpaZTqQDqKaKdTAKdTaKAHUUUUgClpKKYC/WlpKKQC0UUUAFFFFABR9aKKAHUUUUwCilooAZ/FTx0qPvT6uRMQptOptZlBRRRTAKKKSkAUUUlABRRRQAU2iigAooooAKSikoAWkoptABSGig0AI1JmkoNMBppppSaQ0gEamtSmmGmAhppNKaaTQIpX0uxWbGdo4A7mqESiGPDc7Rlj6nqT/OrFy2+YL2zuqvOQImz0Y8/Qf/AKj+dZtlI5zWiLieO3cnCgPIQffp+dedePpg11MVYkgBMfUdPzya9CkywnnJDebyoxztP/1hXkviufffSEEkK3BJ6n1/WuKu9Dooq8jnrgjhQcjdgfQVVuTmONc9Ruz9f/11alX7qjrtxjPcmoLhd9wV4AYhc/jmuZHaPK7Wj9lBq2fldguA24bcj9ahQh3mfHQADjtn/wDXTpj++Ix8rRfzP+fzpdSuhCih7qIKcqAMDHb/APUK6XQxttb6UEbiqxDjrk5P/oP61iWsfzTyEY2A5+pyAP511fhi33RWKlch5HuG+i4A/XNKWiF1sakkRN/BA2MLgt7BQeP8+tX4WLyNJnBY4H05qhvJmuZv7x2Lj6jP6Y/OrIbahHZV/n/+o151R6nZTVkNmfeSwPGDg496ZFzsB/iPP8/60x8HCjgEDP581PEcs0jA5Ufr3/nWbN0X42AaWY/djHb8z/KuM8V3TefDbsSDExLY7sTk/wA2rqr2ZbPTAz8biHbPcdT+gNeam5a+jkuHzlptxPoDkCujDU7u5E5WO48OSfMPwr0fSX+QfSvKvDk3Iz37V6Vo8mUX1omrSOuOsTrrVunetGM+9Y9o/ArShbgc1vTOeaLympAKhjqaM10IwZMBTwKYpqVashigUuMUU+qEIRTTT8UjUAQNVSfpVyQcVTufunFZyGjKu2wDWHdyc1q6g+1TXN3U2X/GsWWjX0xSxBFdTYrtUVg6OgEYPtXQ2vStYEs0UPAqOU5FC9KJBxWvQz6mTfJwfesQtskrorpcqc1zeofu5fxrCRoi/bPmtOCsK0kxjmtu0O7HNKIMvRVZTpUEYqwordEMeBRSj1pegqxDaQ+9PphoAaeKiapTULGoZSI2qsxqZjVeQ+lQy0QStiqNw3FWZWzWfcyYzWMjRGfePwa5HX5cIRn6V0V/LgZJ49K4/W5NzY96zjrIc3aIeH7c7ZZjzuO0f1rYW2Zn4HWpdFtxHZxKR/Dk/U81rhUVeKiTuxxVomJdWQe1ZWArynxSnksbVe77mx2HFeta9qlvp1nLPcOERVJ6145NO2pXss8o2GX5tp/hXHT+Va0NNTGvtYi0WH/S7fdwfMJ/8d/+vXQWsf768J6bx/Wqmgwb9VXdglBuIA91B/lW3DDuaYYwXPTHTj/69FSWpnBaGRrq7dUt1PIjQZ/z+FYupW5VJAese0H8v/rV02vRk6nOwPAXHHbJH+NZuoR+Y16f70Mcn+P86cWDMOLcCAvX7uPbrWzbEoqsvBwzIc9P4R+oJ+uKyok2uHPqP8/pW7axfv4FbD5cAD/ZHzf41pF9DKa0Ox0a3WKzGxQRuESgjkAYH9Cava1CJFt97fvTGWbAyGwV/wDij+dJoaebHbbxjbGJh7luM/qa0tUi+eIADbIjKFx0+7/QGvQivcsebJ+8ct4sh8ya1kxnzo2gfjrkZA/9CrqfhzP5+iqhbdsyACPx/rWbrMKtp0M7E4hlV8kY284P5Aml+G8zQ3t5ZvgBTlV9j/8AWA/OlHSomW9YHo+hMRatEesTlfw7fpWmKx9Pby9SlTtImR9RWutdi2scz3HA04U1aUUxDhThTBTqAHrS0ynLQA6lFJTqQC0tJRTAWikpaACnU2ikA6iiigBaKPrRQAtFJRQAtFFFABRRRQAU6m06gBaKSimBGD6U6mjrzUlXIlDaKKKgoKSl/SkpALSUUUAFJS0lABTadTaACiiigApppaSgBDS0hpKACkpaTNAAaSim0wEpDQTSGkAtMalNNNACNTTQaQ0AIar3LER4Xq3Aqc1UkO6Y+iigCpI215Tj7oAFZ1+SVWJTy/y5Hp3NXJTuHP8AE+fy5/pVD/W3DOMgD5RzWTKRha/L5EEjKcbVz8vbqRj9K8c1VjLd4Y5YsD/n869Q8TzA28sjnO9RhPRc8D+deV3pzMz4yTwOe56frmuCu7yOvDrQpMB9o3D7obv6daqlsL6sR/n+VXdnysBgnawxjpyB/XFUpCIiApyx4Lf4f41ijqLES+Wmwjndlj64Gf8AGnyczqx/hQZH+frTYxk7e2MD9RT5/lG7uR6e3/16nqV0JI/k0w8kNK+PqB/9cmu4sFNlYNIAVkjto4R7Mfmb9WWuOtoPPuLC3ByGUE8f3mz/ACYV218d1rCqn/XSFz7r2/8AHQtTVlZWHBXYy2Hzoo42L+pP/wBcflViZsRHb/E2B9B3/nVa2PLPnp7d/wDJqViNyA/wjP8An8a86T1OyK0GMcyNz90VbtlZ2VD1J5/rVPhfvdC+T/n86v2zBIpJX9CT/n8KhmqML4hXu2wMUTfMw2AD6nP6cfjXH6Kgl0+5RcnarFfqvI/rVnxldvLe7G48shCPc5Y/qBR4OX5trcblUnrz0U/+hfpXq0Y8tNHFOV5mv4fnHmAjjJ/KvStFlBVef1ryTSibe7lgc42MQB+NejaJc5VfXuawrxszvoSvE9BspMgVqwNx6VzenzZA5xW5bPnB/lRTYpo1oj71YU1RhfNWo2rqiYMtoamBqvGalQ8VojNkwp4qNTTh1qiR1BGaKDQBE44+tUrnhTV9xVC74U5qJAjltZfBIrBnTEi565Fbd/8AvbvB6Dmsm/IEgPYHpWDNUdLpAzGozXR2y8AVzOhzIwXkV1tjggd81tTVzOWhMFNIyHHSriqvT2pJgu081vy6GPNqY1yuM1zOrqC4z61019Kq59q5jUZQ8nBHWueZtEI0/d5HWtjS33KM1mWpHlirlgQlwV/HFQhs6CIVOvSoIeVFWBW6JH0GgUmeKZINTCfzoJppOKAEY1C5pWNRMakoZIfSqkrVNI2KqzNUMtFeZsZrKu5OtXLiTrWNfS4BrCTNYmXqU2AcmuP1O5VZGaU4VQSWz2rc1Of5uTx715545u2i0S9dT95dvH+0cU6EeaRnXlyxO1tvF+mRQ72vIQgH3t4xWJrXxR0u2RltXa5l7LEMj8+leDQx7sn0rQW2wjH8q6FhIp6s5ni5NaI62/8AEF94klWa6+SLd+6gU5GfU+p61twQlY5GHO4lB744rB0W2dbizjQDPBxXXW9vuuLeEjIwN34VMrLRAm5asv8Ahe13TNJIAC6hgR2GSf14rSso993c8n/WEAY77VOKf4aXzbm/ZT8q4Ue2Bg1ftYQlz/20d8+u07f6/pXJN6m0djndeUC4uWIxwg/nVGaEtd4xxJYgZx/tVpa+CI52YDLFAv5kVHNHhlkJxstcg++f/rU4sJI5NYt7Mh/i+7n/AD71sWxYTRMo/wBYNoOfbH8v51RmTZNAQPlJPf3P/wBatTTEzcxLtPyHP5c/0q4asia0PQNPKq6hTldwQH1AP/161HQyX0W4ZWNCTn34H9aoadAEWzUYI4LHsTt/+tWtbfvJ52ByMhR9Bz/U17MNjx3uZGqW5awvrbu6MR/wIHH65rD8KzY162u3GBcoqnH97B/qBXWXa7mbp82B/Uf1ribAC0iDAY+wXw6n+HcOf1NZ1FZplwd00erE7Lm1k6YfB+hH/wCqtnNY0wzan1XkfhWtE26NWHcV1LcxZMKWmU4VRI4U4GmZp9ADhRQKKAH0uabSg0APoptOpALRSUtAC5ooopgFO+tNp1IApaSlpgFFFFIBaKSigBaKT/PNLQAU6m06gAoWm06gCMdeKdTR15p1XIlBSUtJUlBRRRSAKKKKAEooooAKbTqbQAUUUUAJSUtJQAU2iigBKSlpKAENIaKSgBDTaU0hoARqa1KaRqYDTTTSmmmkAhNZ8rlYmbHXJq5McRN9KpXH8K9s5P4UmBUujtiA74wP61nRgqoXOFAXJ756/wCFXLn5pWJY7RhB7knmqN2wgsnlbjcCT9cYH9KzZSOJ8aylreRRwzt17KAM/wAh+teb3bq1yfQtwPQAmu/8US7FjDHiNWc5/L/E153IcZcjjAIyenI5/SvMqu8zuofCV5AVi3DknkZ7E1WwDdKo6A8ZqxcKVAX+6ApP0qGMZnLY9/8AP5VJuWAD5ZY9TgD8TT3V28tFwZGQAD3IBx+lBBDRoeo4/I4NWCAkLzDliAkY98c/kD+oqVuUa+jRJNrdsIxhVlAB9Qgzn8QB+VbVy+Z4uPlSNVXHoF/wrJ8LIRcXDjkRxOBj1OF/qa1HwZZCecKAPz/+tXPWZpSRZtxiFeOScn+v8qQHdOW64HFOY+X/AMBXIqDlYWIOSf0ri3Z1oIhulXnOBnn/AD6mp9Rm+zafkc5wMevr+maS0Ujr6Zz+lZevzmRisZ4jjcD3+Uj+ZFVSjzTHJ2RwuoSNctvdss25ifcuP6E1saLiG6sgR/rGaP8AA4H9KzjGSd2MfL0/M/0qzPmC2tpAw+SVjn6EEfyr1vI4S/rCm31kS4/1yKx9jyCPzWuo0S4xgZ+nbNY3i633JDOg4DuBj3w4/RjTNGusAY7d/Ss6sbq514eVtD1TSrjcFHWuktHz35rgdGucYw2B3rrrCbOBnNc0dGdM9jo4X6Yq/E3GKxrZ+mDWjE/6V0xZzM0FNToapxuO9TxmtUzJlpTTwfeoEqUGqJJc04dKjFPHvTuA1+lZ+oHEZrRas7Ux+4Y98VEhI46SX/SpPyrJ1U5Ukd6r394YbqYDqGrD1rxAlrAXdWbA+6B1rC5uky/ZaxLYzDJO3Nei6Bra3EKtkdK+bpviHALjy7jTplj/ALyuCfy/+vXeeCfE1pdRk2s/mRZ+hU+hB5FaJSg7kvllse5JqAPO7iop9Rwp+auOt9VRl++D7Zpl1qyhCS3atPa6GfKT65rRWQqpyfasm2vGlcGQ15r488atYyGHTo/OnY4aVh8qe3ufauZ0HXPEt5dLsudwPJBjG2smpNczNYrofRFtcqF6gYq3Y3Ae9jANcBod9dPag3YAkx2711vhYNc3u/qq96hO7HKNjv7b/VirAFQwrhR61N06V0nOOamE0E000XGgJqMmnE1E5ouMR2qB2zTpGqvI1K4IbI+KoTPjvU8rVQuJMZzWbZaK11J1rA1CbGcHitG8lwDmuc1Gbg85Fc8mbIyNTlO3bu574rzb4jT7dLji3YMko49QB/iRXd3z7mO3n0rzP4iyeZeWkC87Iy/4sf8A7EV1YdWZxYmVzm7W33RxgdW5P86vmDzJNo6M+39aW3i2uTx8g2Y98Vfto/miDDsHP5D/ABreUjCKOg8L2wuNSLdQAAPpkD+hrrMJHqMzgABEbbzx2H9RVDwfblIJ7raPlztI5wQM/wCfpV2clDcIq8rGE4OepYf0rklLU6EtDZ8LQ7dDaT+KeQ4Przj+f861AB9tbK4CJgD3JzVjT7UW9lYQ4wFCk/UAn+YFNiUyTXDA/eOPpiuSTuzWJyniFTumB5GUGPTHP9aglXd5SniP7J/Nj/8AWq3qQ82+uEyT94/qBVW+JiRQp+c2qL+mf6VSeg3uc/MmBE5wSrdB9Tj+VaOnDMjFDjKjn3JA/lVe6X5NoHMfzfgSAP5mtDRUP2mFMfKSucDOP8kGtKOskZ1tInoOnjMkGMdMkY9v/r1csRwOMGQmT8//ANYrOszmx3qSSVwvtwP61sWuCpkHZdoHtXtx3PGYTQhi646qCPqDmuBnXF5rkGeZYFmUf7v+RXosvyyjHoa4WaPyvF8GcGOVZICD6DLD+VFboFLdnoOjTfatItpScl4wT9cc1q2DZtY/UcflXPeDmzooiJyYJHjP4H/A1u2Jx5qejZ/OtYbIiRdFOWmU9askctKKaKcKAH0opgp4oAdS0ynUgFpaSloAdS0ynUwFpaSlFABRRRQA6iiigApfrRRSAKKKKAFopKWgAooooAKKKKAEWlpKWqYkFJS0lIYUUUUgEopaSgAooptABRRRQAZpKU0lADTSU6m0AFIaKSgAptOpDQAhpKKSgBDTWpSaRqYCUw05qYaAENIaU000gIbn/Vn6/wBapTPtaR+yLVu5PyfiP51nSkFgp6Mct9KTApdZlVuCMuf8/U/pVHWiPKiTdj5t7fh2/WrsTFp5Wx6DrWfqDhrpjJ9yJN5Pp6fyz+FZPYpbnAeKZPNnmjP+ypI5xgZP9a4Q+p6ZVQP8/Suv1l2MdzKWwzfeHfLA5/QiuTkGPKUjAJy35/8A168uWsrnoU9inM/zKcBiWJwTweaIQouMYVRnJPPTPIpJeZ1z0Unj8afChPmFeWOAOPWg1RYVS5U9WcAAeuf/ANdJMQ0y4OY0Unn06/5+tSEbZAv8KjLjH5/h0psoJQuesh6egB/+sRUIbOk8JoRptxIersgJ+gLH+dW4UJkUnqzenpj+uaj0MGHQGJx8xYD3OQP5Kas2y7WJPIVRj8ef6iuWu9Too7CzHduGe4UVHJzKFz0xS5wynnlv/r0sK7mUc/MSTz2xXIdRPI4itSwHJ4A/z+dYd2CFkB6FADn65/8AZa174+ZIFA6fKPb/ADxVHVYsWu5QMDYf1P8ASt6GjM57HNrB5i7e+0gEd+Dio7/H2WMHGFbIH1UmtOyTDKDwc7eexLDj9Kq6lGVilAUAGMbcfTA/lXZGWpg46HTahAbnw7E45P2aOTP+0Yyp/wDQR+dcrpkgVmVTkA4Ge9drp483QLFmI/49JFHuRIMfzNcXLH9n1W7hPAEhKgDHB5H5ZrXeIqTtI7DR7k8DoRXbaVMCAMn3Ga8006Yqw5574712OlXWSvzYrkkrM9BO6O7tZegznFaUD1zdpNkDnH1rZtpMgVcZGMkbMTVajasyGTPWrkb1umZNF6NuBUynNU43qdGqrkMsA1IDVdDUgNO5LJGqleDdGRVkmoZRkUmM8g8ZW89nemeNCyn7yiuYkW21SI7CCehB7V7PrGmpdKwdc/hXnur+ERHcGe1zG/qvesHozeMlax5nf+DfOuMjGM+lJFo8mk3UdzafLInXHRh3Br0y1tJeElT5u59aku9DEsRIWq9s2rD5UncxIrqQ7XRjgin308ksXlxtyaRtOltzsAOB0rS0rTHmmUsOSe9K6EYFr4XjvYSkyDBORkd66Cy8PW2kW5ZFAI5ziuws9LWJRxyBUd3pTXbCM5C96OZ2sCscbZRy6jc+RaqQvdsdBXqnhvTVsrZVA6dfc1Bo2jw2cYVEGe/FdFEu1QBV0VrdmdWV9ETg07NRg07NbNmKAmkJoJqMmouUhGNRMaVzUMjUXGMdsVXkanSP6VVlfFS2UiOZ8Vm3UlWZn96yrqTrWTZSKF9LwcVzWoSnJbJOPUVrahJ1457e9c9dNkjnA7CoWrLbsjOuDnp1NeX+J5PtHiC4bqsbhB/wHAP9a9PuGEUcjscBQSxrykZuL0sx773+mc/zrto6I4KmrLlnF/q0I5IDMff/ACa0oUzvlHcED2/zmoreMsuU5aVgi/oP6mtCOHdNHBHzwoJ/DP8ASlJjiju/DEJttDh45kQsc98kEf0qvptt9sudxOfMnC/l/wDtGty6jS00csOAqBFHsFHP/j1ReErYrcQIVG6MbmP+1jB/Un8q4292b2Oquh5c2F/hjPbpyv8A9eqmmpujVj/EC2fY9P0IqzqBylw4B5UKv5t/hUbkWtq5GCIowvPsP/1VgUtjiyxa6uyDk+WrD6ncf8Kq+JkAuWQHblSox+KitC2jzfMeCjSwr/5EUfyNZ+v/APIQBf7qAZ56dT/OqiNlJVaaO+ccLvjVB7fMT/SrGjymPUliTknOfzx+mDTLTi1tYjgmWVpD7AHaB+hpujuW1eER9XkCtx6//tmuih8RjV+E7+yG2O3jBPzMCB6jGa2Yzs3DPX/CsOxlJvimP3canB9Of8MVuuv7vKjqpGK9mn3PIkTOCzxfXn8jXDeIv9H8QWsp4C3CM3srDaf5Gu7X7kRPtn8q43xzBxK44JgJB91IP9TTrfBcKfxWOr8ODyp7+EDC7kkA+owf/Qa2oDtuvZl/lXO6JceZqUMwOI7i1BUep4YfoTXQZxKh9GxVwehMtzRpRTAacK0IHrTlpq0ooAeKUGmilFAD6dTKWkA+lptLQAtOpq06gBaWkooAWiiigB1FNp1AB9KWkpaACikpaAFopKKAD9aWkpaACgUUUwEpabS02JBRRRUjCkoooAKKKbQAUUUUAFBopKAENFLSUANo+lDUlABSNS0ygApKU0lABSUhpDQAjUhoNI1MBppDQaQ0AIaa1KTTDSAr3wLW8gQ4bHBrPfDSHnqvH0rRuTiFvpWXMpW4bJ4Zfl/r/SpkBUi4ErHj52NZVy6i2u35zISOD/CB/wDWNaGSIQufvMRjHqT/AErOv8Lpd24/iLKOeR2rKT0LR5z4hJFoMH/WMWPPXJx/QVzV8CspAO4ghRxn/PQV0niMuZIYWGNiqAuc4JAP8v5VzNwSdzE8mQj/ABry5fEehS2KZAa4VQwb5jyO3NTW6hBv7b+Bj0qC1U+ZI3A4/wA/yq0OPLTsMsR6nP8A9akzRDgR5R39+WOew/xNNUh2iJXqSxHsP8im3OVjwp4Zv0H/AOqpY1wh/wBmP/D/AApDOuij2aPp8XTeNxH1Zj/7NUkWBFI47k4+mf8AACpL8G3MEZ6wIq49wv8AiKjk/dW4AGcDAx+VcFd+9Y6qK0IS37088KMfj/kVahPlxyyd8YH1xzVeMfMB1C8n3J/z+lSal8kMcHQsQD/M/wBfyrLqbi2kfmtuP3SOM9uRTdXhH2fGMFhjA+mf5g1o6bHmNuMfIBx/u8/ypupwny3xjIYAnpjof6mto6MzkcrbLgySY4AEg/r/AC/WptfhWFw5wY1YEcds5q5awfvGA+6V4B9DyP8APsal1W1FxFBGMEuVBJHX5cGtVK0hNXRLG32bQtCjBP7x2Q59GD/1xXNa6hF3Z3IH+tTy29iORn8z+Vb3iR2ttA0242nMM0bAe21X/wDZqo69BmC+jHzSW9wZk/3SA38t9dkdUc+zKloeevPbNdJpE+xhzj29a5a1bIGCOnStmxbaQeAO3NYTR2RZ3mn3O8YzyD+Vb9rLjGK4zT5/u88+tdLZzZUZ6H3rFaMpnQwyZwO9Xon7GsWGT0rQhk6c1spGTRqxtVhWyKzI3/KrUcuatSJsX0anhsdKqqwqQPVXIZYzTCaZvpC2adxDZVzVG4tlcHIq8eabxUS1DYwzpi+ZnAqwunAp07VqpHk8VcWEBc4pRhdg6hxt7pCs33f0qTTbARSAbRmup+zK2eM0z7IF+YDmn7Nh7QgjtRt6elEdsFatFEzHimOuKvlI5mRRqBipwaiH607NCAlB4oLVGWpnmetO4yUnNRlqYZOKiZwaVykPkb3qq8lEj4FVpJM96hyKQsj1Vleld+DVSVveociiG4fGe9ZN65wavTtWPduBk1DZSMy9bPDAYyM1kXB5zj6VpXTdcn8azJ/Q8d6qJMjD8RS+VpNyRwWUqCe2eM1wFrF9okEUYZYRzz1bH8R/Pp2z+fW+O5zFZIgPDHJH8h+v6VzumxlUVGJDS/ebuO5P5CutaROOWsi9ZKJLh5sfu41yox0GOD+tb/h6z+0apbIykmRgSPUZyf8Ax0YrHsVE/CjAmfnHGFz/AICuy8Ex79Wubl+YoFIB9CeM/kDWM3oaRRseI5g90IAPljK7snr1P/sprS8Lwq9kZUUgyLu9+SW/9mFYV8Gu2lRRtlnkUbh2B3D9Oa7HQYti4X7q4UcemP8AEVzPY1J9QH+lQxD7o2k/QZP+NZuryBNBYnrOyr/31gf1rQu3LvfMvUbY1+v+WFZPjZvJtYI9wAVw2PTaC3/xNLqCMTS1JuJX6/v+Pw2n+hrG1x/MuZ8AfO+OPYEVvaIf3ZLdPMfk98Fh/SsaVDLqyMq5XzeR9DyalPUtiRjGpsmeLdEQHp6f1NVdAJXWrUFvlzGxOOpIP9RSxEst5MCcyMrEegL/AOFR6LKItXUtgrF8zewDAf8As1dVHSRz1PhO80Eebe3EqkH5QDjoR/kVvRt+6A54ORn8P8a5/QWMN1dxnhSQRz09P5mtyMfNED3OP0r2KXwnkz3LpHzisLxlB5tnHjG5i8fPuhP9K248kruPIJqj4lTOnq39yRSPxOP61pLWLIj8SKXhZxJp2iTj+BPJP4Ap/MV1r8qfXrXEeDGzoABx/o05AH0cN/U13A7VnR+E0qaSLkZyoPtUgqC2OYhirFdBiKKWminA0APWnCmCnA0APpaaKWgB9LSUtIBaKFp1AC0U0U6gBaKSlpgFLmkopAFOptFADqWkooAWiiigApaSloAKKKKAGilooqmJBRRRSGJRRRQAU2iikAUUUUAFNNOpKAEpPpS02gApKVqSgBKbTqbQAGkoppoAQ0jUpppoAM0w05qYaYBTTSmmk0AI1MalNITQBBdf6lqoXw/c7+cx/Nx6d60Ln/UtVO+BFpNjrsOPypPZiMTcMg4ysfGPxz/I/rWdq6eXaRwE8sQD+GMn8xVy0X72zO1TnB7+/v2qnqL+deyqCP3cLcnpn/JrmlqjSO55nrsivcTSrkDOQM9M5wPyrn7v5QFI6Menc5Irb1gl5W5xucYz/n6fnWLcYknxngE84ry5fEejTWhFbABQD1J7e1LDy0j8DaM/zwf0p0ILZIPO3p7k/wD6qeBi3wMZY8H2/wD15pGpDKvzKmfu+1aOmQmW+tIm/wCW0kcZ/Fjn9CKov80zH0POK3vDah9WsyRkIxc/8BiyP1UUAbN+3n3meoeTI46jn/P402ThgeMIuT9cVGR/pinHAUkfy/z9Kkb7y/8AfR/p/IV5lR3Z201ZElogG5n6INzfy/z9KiCNcSu7ZyASQe2VP+OPxqa5UrZrEPvTHc2P7oqe1j/02SFuN6Y6d6IjbNHTY82kh/2QcfVc/wBafqkOY71ccfLj8qv6VbkWbBh/AOQOe9O1CILcXGR8uAfyI/xq0S9zlrWIMXB+VtvIx06f0zUkMbPCEUbjEcED2UHP8qs2iFLoA/xf1yKt2MAhhmkYHBX8cnOf6VSY9jn/ABcu7S5YgAVEKyLz/dkRT/46wqnDunjSRhujlsFLAfxNH1/RzWnrsO+ZYArMNqRHA4CyNs/moNZWkMf7Ith1eLev1DxOf5pXoQ+BHK/iMS0Uxs8TdY2K/X0rYtm3Yx2/OsqYbbvevKyorA+vT/61aFq/QdaiW50weh0OnSBSOfrzXS2cvqf/AK1cfathh27jJ6V0VhLwMZx0wf51hJGx1FtL0yKvxSY79RWJavnHatKJ+BzSTIZpxS4xzVtZeOTWQj4PPSplmw3NUpENGykvAqUTAVhveKnU1CdVjB+8Dj3rTmRm0dIJs08SVgwX4YdRT5dVgiGGkGapO4uRvY29+aUOB1OK5G58TxISIiPas+XXnlP3+Ko2jhpM9AW7gjI3OKuRX9q+BvxmvLf7Rdjw5pP7RdeQ/P1qk7Gn1NPqetfeGUIYexpJZIohmaRVx2zXl8HiCaIgCQ/nSTa08jfPITn3q7oSwLvqz0OXWLVPljy1RDVbd+pxXnH9oMxyG/WnfbXC9ffNQ2zT6lFHpKXMMn3XGacXweK8tfWZIT8rfrUsfiyaI8tke5qeYzlgpLY9KLkCoZJtvOa4m28awNxLgH61O3ia2mXEbgk9s0NmEqMo7nUG6AzzTPtIPcVwV74jVWwG4Pqas6frnnEDPLVjKdgUGdfJMD3qAvmqsMvmKDUw5qea5VrCu1VpG61LJ19arXDYWgRTuXxnP0rIuj6HnNaF0/HXNZVy3X17UDKFxjoenc1lzsCxzkVeunAB6/n1rG1G6W1tpZpOiKWPPWtaaM5s4rxJObzXSvHlQADcDxnr/M/p7UzKLaSSry0vyKuOijr+eOlZ4dn82SX5mJLH/bY/56VchUNeJG3PljLfp/8AWrpZzI29GiKXkSAZWKMsfrjGa7Lwf+58OXVzzvuZCq/TOP5k1ymlD/R7y4XO6T5PqMnkfnXZ6Yot7OwtT8ojhMzj3xg5/F8/hXNJmqRHpilrwylsqhwMjGP8767rRR5dj5gAPBYL7nkD9QK4rSARp6klvOkySvpkZ/qPyrvLQCO1VeuMsfw/yKx6lyKMI3SGMZIa7wPcLjn/AMcrl/iBcL9vKnDRxlVYD3x/RD+ddHormSXzG5AMs4P1c4/R64fxnMZblx0aS7CAg9cLt/nmhAtzV0Vd1oSR/CSeepIrEDbPtdxkZSNyPQZJ/oP1rf0YEQuw5Knp6cKf61zch3Qm3PH2hSMfiF/qaziasr2I2R3Xmf8ALOJOD2yD/hUWlDOrMygBW27h6jeCf/QKs8tHqDj7skwAI9sn/wBmqnpcuy6k5BDDYAB6kn88V1UtGc9XY7zRZBO1xdL/ABKMD8zXRw5ZYmb1H+f1rndG/dq0SAbX3ED6cf1retDvtMj04zXs0vh1PHnuXH+VvY1X1ld2mXGOSELD6jkVZKh0B9RTZP3tqQ3Axg1q+xK3OX8L5RdZtweMq4/4Ep/wruIm3xq3qua4Pwo+dYmgb+O0RiP9whT/ADruLQ5tYc9dgH6VjQfum1X4i5acIR6GrQqpbn5vrVoV0GA4U4U0U4UxDxS0ynrQA4Uopop9ADhS0ynj/OaAFpaSlpAOpaSigBaWkozTAWikpaACiiikA6im06gBfxopKKAFooopgLQKKKACkpTSUAFJS0lABRRRSAbRRRQAUUUlABRRSUwCmtTqbSAQ0lLSUAIabTjTaACmmnU00ANakNK1NamA0+1NJpxppoAQ00mlNMNACE03NKaaaAI7g/uW+lVL3DWkwOcMp6VakGVI9RVOVv8ARGJ/u/0pdBGFpuFic/xFicA8djis6b5p9Sfv5be+O39BWhpY2xyDOQW/wFY2qyCKDUH6ZAUfiTmuWbtFM0jueb6g+LrcRwCTk1juMsxPXkcjqTWzfY8yTLYOAASOhJH+FY+So3AZbgrn8815ctz04bDowTGWHzFmAGOuRk/1okIEmByqAD8u9SR/u9uf4FJx7/5IqEZYYHU9T/n6UixJABDyOcV03hhCJLqXtHBsH1Y/4A1zj4MiYPfPI9TXV6BiLSp5D955go46hQD/AFNTJ2TKirskiObqUnsMfTmrEaGSbI4BOM+nb+tV7MfJI59atRApGzHkhQAPc4rzZ7natiWMCWZpBkcbU/2RxirDx+Xqto4Hyk7Tx6g4/nUlpDvti49A30Oc/wBBVm8h2PDJjIWRX/lVRJZ0WmphJV69ev0z/U0ahEWuZMAH5CPr8p/rVjTI8SA44+Xr/wAC/wAKkvEKagQB8uM4x1+Uj+ta9DPqclNFi7iKsNy84+uf8/jV6ZT5VrEDzIS5A9Oo/wA+1LFBvn2AcsQD69/8R+VXLxN8vyKMshWMj16j+VKPcuRzevo5g/criby1IA5yVfd/Q1z2jALFDKoxCtygwf7rbiv6TKK7HWIicOgABXfk9VG1j/hXIaXAf+Ef1aBcma3bAPtFIefyUV3UneJzz3Ocu/3NvFuI/wBGlNs57DacfywatWrgEZxn0qHVR5suqJxtljjukGPT5G/kKoaTeGaLDH97Gdr+uR3/ABq5x0uXSlrY622cYHAFbdjKOMn8zXOWsu5QRz6mta1k/AHkcVzM6kddaSZAJPH861bds9O/vXN2E/IGefrW9auD7+9ZsTLo75pJCwyfyp6DOD1FTJHupMk5rW7mWGFiK4C58TtBcFZN8ZPTepA/WvaxpkU3LruHoRWdq3hTT76IrLCvpnbWlJr7QuZHlH/CYTmPEbgj2PWq0niG4lJLvnNauvfD6GCUtAilcknisSLwgPOK4wo6e/OK7Ixha6OqlFvYeNYcnlverdvq+G+Zs/hVu38DWvy72fJ5PJ4q7D4GtSQN0oB54Y07LodtOlfdkUesJ2fFSHVEKElsfWrn/Cv7dsBZJx9HNTR+AYl/5eLkj03mlys35IdzHj1GNh9/B+tKdRyx9B71rSeBUK/LNc5z1Lc1FB4BjViZLm6Kk8qJCP5UWZoowte5mvrKW0OSdzegPU+lRzeIk4w4B+tdbB4Q02IDFort2ZxuP61pW/h+3iwscESgnj5MZpWZD9meZy640n3MkewzmqU2oXDZxBMeeuw166dKgRtsqAdwcVXmsYUdZEQbQMEY7U+Uzco9DxyW9uy2FtpiScAYpbYa1M4FvbsmTgMx6f5zXrL6VbyXCuEGQMAgfrW1pWkwRnJQdcjihtI46s0kedaL8PNR1NBLq97cIOoER29/pXdaZ4aNiipuLhR1I5NdpbRqFwOnYU+RAB0rkn7x57qNsxYbfYBnjipCOwq1KgzxVd+Km1ib3IJePrVG5frVm4fAPNZty+B6VQFO6ftmsqd+OtWbmTOTWbdSYXg8d6aGUrmT5s1xPjW/xElqh+987/QHgfiT+ldJqV4sEckkjBQoJJJrzWW6bULo3MpIEsuQPRF/ya6aa6nNVfQmgO0wIfUMfw5P+fatO2jKxyzngu2AP1/w/KqVmpkuifQBR/U/59a1LRPOniR/urh3x6nn+v8AnFVJkRRsafFtNnalSN3LDpgnr+pNdVfEM2qSRjBjRLdPfPJ/DkVhaMA+tBjzs7n1Az/NhV4z7rWQltwkumOB/HjAxx2xiueRsjZ0CPdLCzDEahCDjr1b+X867S5mW10wzP8ALsj3Ejvnk/8AoP61y2jrh4lB45Jz/sqF/mTWv4nc/wBgTof+Wn7tfbKqv8yax6jY3QlMGniNj8yW0SHPqVYH9VrzzxFIbm+0/wDiMkn2gAD+828f+h1399ObfRtSnXhlQ7cHuEyP1evOtX/5Dcew5WBTs9sDH9BVBHc6+wASxuQMg4IB/CuZOGuC8f8AyzwOfcsx/wDQRXT2xAsLw54xz9No/rmuOjJS48rggKxOPZto/rWcTRjI3ItH3EFdzsMeo2gfyNR2Sf6RDsG1twbOcA4Ug/8AoVPh402Mxjdu3E57bsn+tOjVd1qP4d7kkehVuP8Ax39K6KW5z1djtdFKvJFImcBGBB6jLAk/rXQaYSFmj/uscfSuc8OMRCI9uFC49OOK3NPYi4bJBJXB98HFezR+FM8mpua1r/qQPTilxgsvqM021OGkX8RUsgwwNbEHHaRGIPFi7TxtnjP03BhXaWR/c49GYfqa46LMfi5Q3ygSEj3DIR/Ouwsjw4/2s/pWFHqvM3q9H5F2I42n3q2tU4+Y/wA6tKcjNdKOckFOFMFOFMRItLTBTxQA4GlFNWnCgB4opKKAH0uaSlpALTqbRQA6lpKKYC0tJRmgBaKKKAHUU2nUAFFFFIBaKKKYC0UUUgA0lKaSgApKKKACm06m0AFFFFACUUUUAJRRTaYBSUtJSARqbTqbQAUlFFACU00pppNMBDSNSmmGgBDTTTqaaAGtTGp7UxqAENRmnmmGgBrVm3eRZzKvXlfpk/8A160TWZqAJJjUfeIbj26/yqXsIyYCdgQDG1yvHbnP9a5zxQAqnccbmK7cdcHI/QmunfEU0+PQN+P+QK5Lxa3LBupICnGBkriuWvpA1payOC1Z8LLIMfOwGfTnP9azJl3XCqD/ABcf5/z0q9qDgOAfuKyn8cVXRSZFYZ+dgD7cH+ma8w9KOwSEFBkAbsnn8v6Ux/lCrwTt7f5/zmpMK0i7hhQvPsMU1WLOZG+83OMVJoKBmZeOcg8evNdVbL5OkWwPHDP+JJI/pXJhd+MZIOBnPc8n/PvXYSr/AKHaRn/nkvH4YFZVnaJcF7wRfLbKuMZOTj8/61cKs6hOh+83scj/ABqIFV2En5dxP4CrdhH5kRbuWJYenHArz3udZp6CnmQAY6phh+Gf5g1oXEBazHH3QM/y/pVfwspY7M9GZf8Ax7I/nW5LCPKmXA6HA+o/+tWsdiJPUn0rmFmPJUKf1z/WrWpR/wCkxt17cVV0UZjkUdWiyB74H+BrSvl3RxuOvX9K2WsTL7RhQxCGV5gOIxx7knA/n+lIiBrfd3Vxz6Dp/j+VXZV+e2RTwXZmA79v5Gq8KN5bxf8APQbvqDn+ppF3KWoReZarxk7QAc9eSD+mfzrj/D0G241y3dxiV3z64kUN/wCzGu+gUNCC3TKgjHTIGf8AGuWs7YweI7kY+WeBXBx1baU/+Jroosylsefxg+dYSuCIph9mfPfcuAP++0JriZ7htK1195/dPgSY7e/+feu51OMot/B0MF2zpj+EfOw/TNcb4pj+1Nb3WBi5jGcDjdtGf1FdsLPRmLutUdbptwGUHOQfQ1t20nPGB7V5n4T1baRaTn5hwhPcen4V3llNlcHrngiuarScXY7KU1JXOntJgMAY9we9dHYTFto54rjbWfkYJyK3tPlGQC3H161zM1OutpM454rRg61h2M2eDx/Ste3fGBUkM1oWwBRKpKnH/wCuoo2yBT93GD3qkQZV/GGzkCueuLVVm3FQAPautuot6nFYN7GUJyM4rWMrGtKry6GTby/6RyRtwBWnauC4xWTchefL61FFevE43cV0Rmj1KdRNaHa2zgtkYBxgg/Srloi+WXJBJ9fpXJ2uojA+atKG/wCu1gPTmr9oiZxbWh0R8vJ+6xY5+nOKih2G4+bBGeP0/wAax/txI4bHHrTPtf8AtfrT50ZqnKx0n7nzNp2gbenp82KoyTRjZk4CkYP+fesaXUCVI3dfeqct4em7ik5oI0mt2XdTu8swU8fyNZxkLsRnv0HvVZpC7fMf1qWN1DDHLelZyqo1lKMImhAORnpWxajeQAMAVlWELzEEjHtXR2sOxRmsHJyPLrVeZlyIbVFJIeKTNMJzQYkEp4qnKferUxqhcNjPvUMZTuXrIu5M8A/XFXb2QdBWLdS9cfnSKK1zLjPTj3rEvrkAnJ/HNWL6425weO9cP4u10WFuViObmThF9Pf6CtacW3YicrIy/GOreextIj8qcyn1PYVmQR7RCpH3Y/1PJrMtg0zlGJZmbknqSeprXUg+bKeAeOB6da7bcqscm7uXbM+UCxIIVN7ccE/5P6VtaWpiAaQ4ZVDtn1yP/r/lWPYD92PM6ykE/wC6K2I3aSNQf+WzBjx/CP8A9bflWMjWJsaK7Jb3M54O08Y7n/I/Orli+1LaNxwuHIPbOG/Xj8qyrct9jhTO0zSc84O3PP5AVq6UwluoD6orFfQYHaueTsjWJ1ehr/pxVmyY4lVh7k8/qKueI5wYNLiHSSUPg9hy39aztFZpPtcilQZOAQf4ucfqwqXxJIJdas4UP3QxUfU4FZLcch3iBymmxRNwJbqEcegdM/oDXCLJuurmQtuKqwP55/pXYeM5/LmT+7G4I56HY5/wrirYZF2wP3jkfm3/ANar6CR3NowOl3G7bgoD+O3J/nXFw5YTlhyW2jntjP8AOuvs2/4k9yT08tVyf9wf41x0TiC2kcjPIPPUfKD/ADJrOJfQbK6tDFk4QDYoA64AH64q0SSsGwFctIxIOdoPy4/Jqr3GfItV9Iw4+u3/AOvT0lZoz8wY7FXb04JU/wDshropbnPW2Os8LMFCBm5C4bnOTXR2IK3sit65Bz1BHT8x+tcroTFUgmJwCefYYH/1/wAq6mH/AJCEbHGWUj+Rr16Hw2PKq7mlF8km704/CrTDOKqpyGH4GrEbZjHqODXSZHJaxiLxJayn1X8w4/xrrbXiSUHjvXJ+KQyX1tKOCshx/wCOn+hrqIn23h/2lH8//r1zx0nJehvLWETTi4QVNCcrj04qFfuinw8Ow/GukwLC04U1acKYhwp60wUooAeKcKaKVaAJKKaKdQAtOWm05aAFpaSlpAOopBS0ALRSUv0pgLRRRQAUUU6kAUU2nUALRSUtABRRRTAU0lKaSkMSm06m0CCiiigAooooATrSUtFMBKKKbQAUhpWptIAplLQaAEpKWkoAbSNSmmmgBGpppzUymAhpppTTWoAaaaaVqaaBCGmGnmo2oAa36VQuGy5b/ZJq3Kc4Ud+v0qtIM72/CkBiz4F0voQV/rXI+KmJaJR05J9uw/ka6y9by0ySQEwTx1B4rkPFUmITxyWG3vnA4H5tn8K4sR8DNaXxI4HVCWaMKPvtk++TTCCsjY6Jk/px+v8AOnXnF5hTkIP8mkB/cs5xhz39sGvMPUWwgG7yxn+HJ/SmcnAX7zdMfy/OnKeZc8YGM/5/zzSkGKNs9cY5HT/6/P4fjwiiSJA8wjQ5CAgEd+5P6D9K625wtyg6iNAB74GP51ylgAkM8j/3QgA7Z44/Kupu2230xJ42/wAyKxrbWNaW4sZ3A99iY/Gtbw4nmKwPOxz09OlZdkP9GkkJ/hyf51t+Fl/fygYIPGfcGuKzN7mp4dQxX7KB12uP6/0rpDFu2Hsyjt07f1/SsKxj8rV4cnALFD+IJH8hXUmPMEowMqzY/L/69bQV0ZzepnaYDHcEcfKMEe2c/wAjWncjEadhxxVHbi6O0YDL1/l/StOYbrbcOQfWtYbNEPcypUMbBm5O/r7H/wDXj8KhRdssbPjAwOO+Dmrt0nmKe3GR7YP/ANeosZjyq474Htx/Sp6lFcJ5dw6DGGwR+eP6ise6ttt5ZS7cmORozjsCQV/9BWt65TZ5DdiNmaq6pb7jMqcecoZPqD1/lW0dGQzyPxCnleKZogfkucOPrt2f+zH8q4u9hL6Hcx4/eWNzkeyk/wCOa7zxjGBc6VfjIVZ8OcdFc5zXI38Zj1HXbc8Ca3Mij34I/ma7abMmef3SmG5l2Ego25SD+tdv4Y1g3UKxzEecB1/vVyOpx/6SDx+8jB/rT9GdlUFSQVbgjtW1SKlEilJxketWkuehx7+tbdhOegyfpxiuH0u/85QG4cdR610VjcBjwPpXmyjY9GMrne6dP0Ga37V+B/KuI065wwGc46e1dTYzjaOfrWI2b8TcDFTg1QgfpzmrkZpozY/Gar3VqJFNXAKlRMirSJON1DRydxTr2rnbu3u4SflLAHuK9UNsGHQVWl0xJOGUe3FPUuNVx2Z5M19cQ9bcn6UDX5YxzbtXpc3hmGX+GqMng9G6KPyqlI2WLkcGPFLjrbS/lR/wlJPW3l/Ku0PgoH+EflT18GAfwD8qfMX9bkcT/wAJC8nC20v4jFPj1C7mYeXb4/Gu8h8Hop+4PyrTtfDkcfRAPwpNvoKWLkzhrGxvbjBfIB9BXSaZo2zBYZPvXUw6WsY6D8qsrbBBgCpUNbs5p1XLcz7a1EajirO3FTlAKjYVdjK5EeKjkOPanv0qvIcVLGRTNWZcyY+tXLmQDOaxL6fHU/lUMtFK9mxnJz/SsK/uQAeamv7wDJyOK5XVL/rzk/zoirsbdil4k1lNPspbiTnaOFHc9AK8mlvJtSvWuZ2yx/JRnpXR+O5WfTwXOSZB/KuUsVxAx/CvSowUYXOGpJuVjXsSyxyyZGVP6mtSBc+VERwME/1qjagA28JXPPmN7+grQiO1JJu/Qe/P+Of8ilJlRRpRp5smxcDcBGvsOAT/ADrQLjzbhlA2ooRPYcg1naWNvmSMeI0H4Z/+sDVmPc9vtYfPKRx+H/16ykWjXU5azhHeLJI7Fs8/rW1psm1bi4C4ydiL/n/PFY0bp59zMu3aq7VHXGMf1/rWhCfLtQi9VTge+M/0rlmzeCOr8J4IUnn5genX7v8A8T+tRyyNN4qhyc42jH0XdTvDzbLWbbxtUqPwGP6VTtZM+KoycfefBH0K/wAqyuU0QeMZw9yoY5BlAx7Z2f41ztqSzuRgnav57QTVvxfKwuM5HzHPXp88h/qKghAS9YMBgsCcemc/y/lWv2STroCV094853EqPwA/wri9QP8AxL5dh6nIx3yP/rV1kMm6yiIOdzj/AMeP/wBeuV1P5RMB03soH+7WUXqadBbiUqsXl8t5QAA69KmiRBayt/djjyT/ABA7k/D71VpBnDAgMIlAOcfw1ZiIls7vb93yowenVWBP9fyrpo7nLX2Ok0f99pgZwORnjp/nrXR2ku6ezzwSeR77SKwfDA8zR41Vs8ccdK17VyGgZuGEnzfnz/OvUpO0UzyZ7nQJw/1FSD5Xx2YcfWo842npzT5Pu7h/DzXYZHO+LY8+QfUnH1//AFZrbjfPkP8A3lx+eD/SqHiJNy2mef3hA9sow/wqxZPutLJum0quM+ny1g9Kj87Gv2EdBGcmnqcSj3GKghbLMPpUoPzj2roMi0KeKjWnrQIeKWminCmA9actNWlFADhThTRSigB49qKBSigBaWkpaAFp1Np1ABS0lLSAWikpaYBRRRSAKdTaKAHUUUUwFoooWgAaihqSkMKbTqbQIKKKKACkpc0lABSUUUwG0UUlABSNQ1FACGkNJRQA00hpTSUgEakNLTWoAbTTSmkNMBppGoammgBGpppTTTQIaaa1KajmOEPqeKAISchm9elQS8QH/a4qaX7uBUE3LKM8DmkBi6oqkS/7nA/OuJ8UTbgh6fKSRjoSv+NdvqR2SknqV4HqeuK8+8SPsbG7OwYPHT0P5VwYt+6b0F7xyFycKxP8XHA9cH+lSBdykcDaMknsSB/UAfjRKrNKikgFuee3FMuTiNdnIZt2PX/IrzT00GRGQV+Yg/exxxzTJjlVPbqc9/f+tEmBtj7ADI9TUi8yBn+5GMn3/wD1/wBaBkm3b5EPTBDMc9z/APWrodYlKM0g53D+n+OK5+JiymRuWYlif5fzrob5DdTxrnhxkfTAb+lYT3NaZfsEAtCig9MfpWt4QAaaJkBIKncT3yAf5isyzG21fd8pKZ57Hk1oaDKsOtLFyArmNR+Y/wAPzFc9jU6a7QxXIkUfcKyAe4P/ANaunA3SSjqGQMP8/jWLqMeRn+8hA/n/AErX01vMtrOQ9CoUk9z0/mK0ho7GctitIuJLcjuxz+v/ANar0eWtjkdKiKZYZH3WBH04P9KltD94evP6kf0rSO5LKoGGX0OQfrniq4VlLLgAc9P8+1XLmPbkjqpyPaoJAGkzx868UmikxkqFrQ7cZQ5Htg5/xqOVd6wnt2/LI/p+VW4+WZWHDdv8/WokTFvIuOYzkfhz/LNUiWeY+NbLzLHVbQIOhkiUdTxuGB9cj8K4PUT5+s6bdsoxcWw3EdyVJP5ZWvUvFwWPUrZ/lHmfJnHbkD+debajafZV0xRn/Rr6S2YkdVJOD+W2uym9DORwOqxbIbdyOY8g/gcVV0lcGQehFbOuwgR3EfGQ7HA7BhuH65rJ0c5uGA74P6V039wzXxm/BlNrocHsa3rC+34zxIOo9aybePKYxUmwowK8EHrXI0mdSdjttPvPmGPr1rr9MvN23nJ74ry6xvSSAxxIP1rptIvtjAc+wzXNONjdO6PTrSfOOea1YXBxiuP0693BfmzXQ2k+RWaE0bkZzVqMVnQv6VfifIxW8TJlyJeKnSMHtUELfpVuM+9bJGbHLGPSnCIYxilFSitFBEjBEM0vlD06VIPrS59Kr2aC5GIxnpSGMVJ9aQmpcLAQso9KjdambrULGlYaIJOKrycVNIc1VlasmWQymqU0mKluJMd6x7+5CA8/WsWykRX1zhSM1zGp3uM/NS6vqQVTtb6VxuqakSTk9egqUm2Xsh+p6h7/AK1iHdK25sk/yoG6Z9zHPt6Vaji4+nNbpcqM78zOL8ejFjCvrJzz7Gub09QVjVzhc5b6Cum+II/d2wx1c1zlpGSOP42wPp/kV2w/ho5ZL32asA+Sab+J+APbtVyI/vIohyFGTjv/AJP86oiTEgUdEGfp6VeththLngt/n+lZM0SNW2k2afKV5aV8ADuB/wDXzVqFjHfLkjFvGWY579B+p/WqiARTRRtwLZQz/wC9kE04SD+z5nI/eXMmFHfaD/jj8qzZSNbT1eW2XkbpJBkD6Zz/AD/KtIOBcEZ+VMKT6cgH+tUNPJiw38MaA/Qn/wDU1S7yY9w6vz1/2l/xrllqzoirI7HR22aPI5OGcZH1x/8AXqppbZ8QsykHJbg/RR/jU0b+Ro69srjn2b/7GqnhshtUDdQw3/gd5H6CsV1KZzviaTzr9jj5cnB9zhv8amJ27pRhgXHT2Uf/ABVU9Wb99t7h16n2I/pVi2O/aOmSxx9MjP8A47Wz2ItqdNA+22hJxjcmB7jj+lc7q/yLLj/nq36tW3avnT0bOTnd9OAaydTXzfOz0VyfyGaxi7SNLaEdwuFVRwWh4H5D/GiyJNufnxGydfXof5A0lyzLcRLnqoB/Dn+tLbIHVYD/AM8wuT2wR/jXTSOavsdV4SfZbgNuBPO0Dp0/x/StmX/WttA+7uUj8v61zHhaRm+zsfkLEg5HHU8fnkfjXVyEb4CMH5trH/PvivUpfDY8ip8RuKwcIw6Eg1N3x2YflVa0ObWDHUKoqyDu/mK7VsZGXrn/AB4wv3SeMfm4X+tNsXxat/0zkJ/k9SeIV/4kV869Y1Mg+q/N/Sq0LcXCL0ZQ/wCalf8A2WsZ6TTNY/CdPFxJ+FTJyx+lQZ+dCO5/oami9+uTW5iWYzlRUq1BF3+tSimIkFKKQUopgOFPFR09aQDlp9MWlFMB9FIKWgBadTactACilpBS0AOooopALS0lFAC0UUUAFFFFADqKKKYC0tJRQANSUrUlIYU2iigQUlLSUAFFFJQAU2nU2gAzSGikoAKbTqbQAGmmlooASm0UGgBppGpaRqAGGmmnGmmmA1qY1Paoz0oAQ0w081GaBCNUUvLAe+alaoHOWbHYUAMfk1Xc/Ox9Bip3B57fSquQe5554qWMyNVb97ExAI5/9BPNea+InJlw/dsnvz/kmvSdaz5bEf3DjA654H+fevM9fc/a2DH7qlvz/wD1D8687FvQ6cP8RgSAszYPLHb/AIk/hTZQDN5YGAFAPt6mpIgWYHPckZpp6u27IGcZ788fyrzz0bDVIad3PAHbHTH/AOo/nTpGCqImGWbl+fyH6/y9KW2HlR73/hIZuOp5wKiDZjnmk64AJ9zQMuSgJZpnGW5P0/yTW1p7PJb2bLgMQY/phSB+grE1NCj20Q54TI9cf5/Wtbw5KA3lt/BKHH8j+mTWcloaRN4BTpMsijHB69sH/wCtRE5i8S+YvQoHz09//Zanto9un3kOPuZOPUEf/rqC2AefTZSc7gqtx16A/wAzWKRZ6bdJut1bspGfpUujknT5FPMkbZUfqP1zUWmP9o0iEnrtwfqOD/Kn6KSk5VuNygfiP8mhbkvYu8C4x1Dr8v0/yajhXZLFn3B/nT7v9yYX6eW3P06fyxS3I2urDpkH/P5VoQLMu7d2ziqWdrR+ob8v88VpSZGcjtVCVCrSDqQMiiQ0DLgPj/eX/P5UsZH2hW42yLjGO/8AniljO98gfeXgevGf6UzH7lsEFlbd9O+f51S0BnHePbZ4dPMqcSQNnd7ZH9M1514nUMbtCcmQxTp9VKxt/SvaPE0IubE7VUrMnf1wR/UV47qUIaGyuXHC3bW0gHYGUH/2T9a6aZmcRqabh5z/AHZEP4lX/wADXNaUvl6lJGexNdXqWUtnhfrBKSP93AFc3bRY1MMOMpx7nNdK+Fk/aR1lsmUzx0qcxZHNOsFyvPJ9KueVxxXHzWZ1ON0ZEkWDkcGrlpfGNgJjyOh6VJLD7ZqnLDjNXpJGd3FnY6PqW1trE12mmagG2/NnjnmvHLa6e3YBuVHT2rqdH1QjA3ZHY5rnnTcXc6IyUkev2lyGXOa1LeXgVwWkan5ijcfyrpbK7DAYOc0ovUlxOmjk4FXI34/GsKG455q/FMPWumLM2jYjfinhs1Qim4qbzPzrZMixc3UhftVUy0wy8VVxWL/me9MLVVEtDy/nQFiZ5Kgkb3qOSSq8kw5yazY0OkeqdxKFXrUc1wB3rJvr0Lkk8VhKRaQt/dhFPNcfrOqAZ+ana1qoXIDZ4rgdV1UySFYzlu57CsknJ6F3UUT6tqZZiAcsegrIjV5Xyxy38qbDGzNluSepNatrb+1b2UEZXcmNtoParhjxH07VZihwB396dJH8vNYuV2bKNjzP4hDH2Uj++f6Vz9oQOeyqfzJrqfiKhEds3o/9K5S1x5JBP3j+ld8P4aOOS99l+Hlh1yzbmrThO14Q/wB1TuIx2/zj86zLUb8v/eP6f5xV8tiM88ucZ/2eP8Kh7l9C9bF7iAnbma4kHf8AEf4U52WTUBHHnyocIp9cdT+JJpscrWVm044aGL5fZm+UfyY/hUGnpttyxPIxz6f54rN7XKW9jpY3J0uPZ/rJW49hjH/1/wAadB890ozkDnp0BJI/9BFR58nah5EMfIHsKs6cn74LgZJ2ceyAf4muR7M6UdJqE3k6YgzgrHn8cZ/rTNF/c6hHz9xNnPtG3+NQ6y++HP8AC7gY9sqD+hp1q3lz5b+67H8wv9axjsUzltTO67U9MyL+jf4MKt2jEJEUPSIs3udw/wDijVG8kO5WbBGcjPbP/wC7q7YDNuuOSyJ+Oc//ABNby+EzW5vAhbPBHHzAH6DH9aoz/Mt4GH3WU4H61PE2bGRV5IdwPx6VWkO+S7A/jT9MVz9TToVrrgqcEttOPyNT2Pz3W7tyGA7jb/iajI3Ojnoygn26D+tLY4zL5p42cEdR6/zroovU566902PDcXySw7xujk3AY6DH/wCuuvZg1qWQFcDdg9Rg5/TFclpEohu0f5cSqIDj++nU/wDoXftXVQfM7I3ST5h/X+letR2sePPc2tPO6BeOhb+dWU4IHoP61Q0hybb/AHSePwH+NaOMqD7V2x+ExGXUQmtZoXHyyKQfxGK5zSpGe1hLcym2UEf7S7R/NjXUScAfTFcrpf7u8eP+5PKuPq4f+RrKr0NafU7NTlFI9AaljPyg+wNV7UYUIeqoo/TH9KsR8Lj3xW5kWo+GNSCoI+GH0xU4piY8U+mClFAhwp60wU9aYC04U2nUAOFLTRTqACn0yloAfS02lpALTqbTqAFopKWgBaKSloAKKKKACnU2nCgBaKSlpgDUlK1JSAbRRRQAUlLSUwCkpaSgAptFDUAJSUtJSAKbRQaAEpDQaKAG0jUtNpgFMNOammgBppppxppoAYaaacaaaAGmmGlNNagBDUA6E+pqVz1qIfdFADJemPWqpOWPsKsSdT+VV8/KSep/QUgMHxA+2I7W53cZ9fSvL9YY/aLxhwMhQc16Pr0oW6jyQojVn59cdfr1rzPUxuU5Jyx3HPcdMn8QfzrycW9Tswy1uU4vljyD0XjI/wA+lQsrHaGX/WYwPUdanlPlxeobp70gfa4c8tjC+w7f41wnoJDLrlooUPAySfU9zUV38tvHGuP73PTn/wCtinyqIxuPcgdfQ8j+n1qAsRgyHnG4jHtQhmjfbfty7z+7QZbI+78p/wAKNBmMd5Cz/KGfJ/3ScfyNN1gbWcqOWbpnuFqKwHDndlgBEue5JH+FPeI0enWCFpF39JY9rDHVhz/LdWZtMMUkTYLQSErwMgA7v8fyNaOiy/aLZWJ581SM9uf6/wBaramu26MsmAJ1KMD0DA/ywG/OsbF9TuvCku+1ZOvQj+X9P1q5jyLkn+62R+PFc74QuWju445CcktGcnr6H9P1rqNTjK/MOpQj+v8ASktiepdv4xKhA6OpH8v8KgtmM9kpP3gNpHuP/wBVWIH86xjcc7ef8/rVO0Pl3k0WeHG9fr3/AMaskt53QhgBkCq1wMyjHQ9atKv3l9RkVXkwI1I52NyD7U2CK0DbDg8lTjHp3FPP+uKgDDf5/wAahI23WMYDLjOO/wDkVOfuB+CUO456/wCcUojZG0XnaXNAuN0edv8AMfzryLXIFKa9anAAH2lAeuShJ/UfrXr9u+y+KHGJE/Mj/wCsT+Ved+J7T7L4mt3dcwzqbRj6ZO9T+OCPxrpgZ9TyrW4vNvS+Nq3UJYfjj+lc1b/8fUWTysjKc+9dZrqGCG1hdgZraaSE45JGSQfyIrmZY/L1GUcYJWRSO/P+BJrojsJbo6zTkwOhzitER7hkCqumfPGCPx9q1o0zjiuGT1O1bFJosjpVSWHHatp4arywU4yM5RMCaH0FRRSvA2UOB3HrWxND1wKz5Yc1unfcx1RsaXq+1hliD3Wuz0vWAMHd7YrysqVb0Par1lqUkDASZYZ6jrWUqPVG0aiejPbrPUkkUYb861YLwevP1ryHTtZyAUfcBXS2etksvzdvWoTa3NOW+x6RFdZxzVpbodjXDW+sD1xV+HVlIHzA1qqhDidV5/vSG4HrXOf2oM8tzSf2mh/i/Wnzi5To/tI9f1pftPcmuafU1BwGHvUT6ugB+b9aOcOU6SW6APJqlPeYzziuautbXHB/HNY17r2N3z1m5lKB017qSID8361yesa4EDfOOnWuc1TxFuyqHJ9B2rmpp5bp8yMcdh2FChKW5MpKJf1LVJLtyIyRH0J9aq28JyKWCAnrWrbW/IrbSKsjHWTuxLW26YHNa0MGMZpbaDA5HNXo4u3WueUrm0UMji4yfwpsyfKe5xV7ZioZk+Wsrmp5j8So82MTAdJR/I1xMh2RbQegA/HrXo3xBhL6PMepUgj2+YV5nIdz4B7fqa9Kg7wRxVFabNqxULEuT0X9e/8AWrQBa4Veu3AwB3/yKgtsKRxnAH48jA/n+dXbFQ0jSSf6pTlsemf/ANdQ2WloN1+ULb2tqpyznzW59sKPywfxNWYThQvRRgk/kf6Vkl3vdbMkhGQSTjoOTWrOCttJj7zssa+ueM/1qZaJIqG7Z0kah7YygcyMAM+mMf1qxo0u28Rc5AJP4nk/kCBUUsgiVguMLj/0Fv64pvh0+ZPE54Jyx9s4rifwtnR1Ni9+dY0HZMn2O0/5/CrBcGdmGP8AVPj8t1UriTars393r+YqeJ/nYnA/cMB+K7f61kti2ctd584A8HC8evzY/wDZjWhpreVMpkH3dufcBjxVC+UbsnrsZgR26f1FXLQ+YxfIx1A9sg/1Nbyfuma3Ne2zH9oU42xyKw/kf5VBDxdFT2VR+RxUw/4+btT/ABJ/j/jUIG66JPG5M/jgGsC0Rn/VlO+0qP8AP4Uy04uNxbarE4HqAQcfyqaYhZJSR91iR+PH9aisjmZWIBCBjz/n1rWi/eRlXXus2YU2QsFGZrTE4BPVv4j9Ov511ts5kggmx6EZHPIH9P5VzFo5lkJQAGUAtj6E4/PFbugEvZ+WfmCMR9cHj9AK9ekeJM3dPOC69sZ/p/hWlbHMQB6jg5+tY9oTG0JP8TFWP6fzFbER+Y+5zXbAxZNIOF9jXL24I8TTxHgGUOP+/YH9K6aQ8r9awZV2eLoTj78YP4/NU1Vt6oqHU6UHE2f7w/X/ADmpx93NVyOUP+1ViPmP6it3uQTg/MKmWoE/hNTCgkkWnCoxTxTAcKcKaKcKQDxSrTKetAC04U2nUwHCiminUgHUtJS0AGaWkooAWnU2nUALS+9NpaAFooooAKdTadTAKKKKAA+9IaWkNIBKKKSgAoopKYBRRRSAbRRRQAlI1LSUAIaT6UUlMAppoNBoAa1JStSGgBtNNKaaaAENNalNMNACNTTTmphoAaaYacaaaAGScIfpUfRfoKWf7hpknAA9aBEUpxH9aglAC4PG41M53P7L/OoZQAp4yfU0gOM8STETXGSD+5wfbJx/n6155fHcw7Z4Gew/ya7HxbIf3hT7rYCkfif8K4yZgZuvAXaPpn/AV4mJl7x6WGjpcgl+8gIwAA2SOnFEhWMlsAsT8idMdhn0qUnLeYADIQSi449RmqcbYG5858wHnndjrXKdgyXmQbiSFX5zjv6fzpeZpN/GGG489B/k1ETnyozzuUseep9f8+1WUQNIE4C4BYn028/z/OmUT6tn7PBIp3blVuOOqgmoom8gQHGf35bH0OP6VbcJPY5ZcKjRsQD/AAjdx/KqETYexG7jeM++WGf601sB6PoUpSxRVwcMEX/eAAH6ir2pxLPJHt/1U5GDjocf1XP5D1rE0zJ0iSRPvJI7dO/DV0MyiawZIsCSJsRsQMAg/KfwIx+FZgQ6JK6ZY4E9uQ5/Ibf/AEGvTZ1W4to2XmN1yPpj/CvL9MkU6qsigiG5TjPXpuGfcKMfU16LoUpl0aME5Nu/ltn0HT9CPyqVuxSHaDIRC0b9UJBHsP8AJplynkXSt/zzOR7jvTbY+Rq8qY4cZH51dvY9yQSDnsfxH+OKaWlge5I/3lPbPWqzDLyp/eG4f1/pUkH7y1KZ5XK/T0P5VG7f6RE3ZuMelWSUbriOOUc4OefXP/1qnhkBkx1Vhke/+RSXaboZkIzg5FVrVyIomAxtxu+lTsyug6bMTQycfupRk+gPykn8CTWL40tvMuLfZwZnTDYztZWBB/nXQXybxLF/DIv/ANY/0rM1Zvtnh+K8XmWECbj+8OSP5iuiLM2eEeNSyWUV0QBKLiNnXupMS5BrnL5AfKmjH3cj6qRx+hruPiNZlF1KFDuEsEdyv1U7WP5Ba4bTW8yBUY/eQH8uK6No3CO9jrtJXdH1zjoRW3Au4YbisTQhiNQTyPlzXSQx+g56EGvOqPU7lsHlZ4xUMkXbFaQjyv8AOmSQ8ZoTEzEmhx9KoTQ9fSt+WL1FU5oMdBWqkYSic7NDVVkwa25ocE1Rli64FbqRnYojcjAqSpHQir1vqc8X3vnH5GoDGR0pCntTaT3BSa2NqLXQFGQymr0WvqBw+PbpXL+XShDmp9jHoX7eXU63+3+/mr+LUf28AMmVfpmuVCUbfrS9gu4/bvsdO/iAY/1n5ZqvLr+e7MPpWAUJ75/Cjaewo9kg9u+xoz63M+dinnuTWdNcTTf6xzj0pfLPWnCPNVyxiQ5yZXCZq1BBkjNSxQZPStG3hx257UOQkhLWDpxWva23Tjr2otbfoa0oYuBmsJSNUhIovbpVhUwOBUscfFTBKxbNEQbcVBcLxirpXb05NV5l4+tQUcV4xtzLpVyqjJZGH6V47bDdcIOuTXvOtQh7aTI7dq8OgiMOpTqwx5LEHPbBxXoYWXuM5qy95Gpv8rLZ+bPA/wA/jV2RvKhjiXgfeP5YrNg/f3UKn1yf5/41d1NvlkYdzt/z+dN72Gu5DpSYWa4PYA4Pqea1bFTJdWUbDO0mU+3p/T86z7T5YYIMY3tuYeoz0/KtbSuJppWOFWEKSew7/wAjUTZUEaVxMPs0hPBZm5z/ALv/ANlV3QUwuV7IoH6H+hrMu8/YwRgEkE/iMn9TWxpY8sR5PG7n/vkn/wBmrkn8J0R3Jb47reVfVcfrj+oqy522TSt0ZeT9GQ/yNVZfnj8zjiMHaPc5/pViYZs9rHKhXP6gf0rFFMwZW+fzH6bcAewOf6ip9LJaRUbkKqo2P1/lUF3/AKkpnkDj6nP+AqxacW4cDMhLg46AYwP1Y/lWzfumdtTTEg+3wPnKSIUzjHcn+lLykyjPQ4P0xUcQB8o5yyOH2gY684/WppfkXzT0LA59eBWLNERXK/e6Z4J/P/61V7aRkmiQ5HmtyPQZz+uauS7TMN3K9WHqOTj+lZdzIwvopO4beQBj0OBV0nqZ1VeNjqLM4YhCT/D7gcnP4cVt6GwjlnZB8m4E4PHIHP6GsCxTFx5ZIyT+ONxP8jW7pbiOf5jjH7kj19/p0r2qR4VXRm2IiYplxghjj271qWMglVWxgkcj0NZtsMSOCcggGrNmfKkwOSDn8CRXXF2MGaB/1gJrD1P934m01z/EpH/jy/41uE5ZcdO9YXiPMepaTMP4Ztp/HB/9lp1PhY4bnTH7o+oqa3Pyn2NQn/Vn6VNFw5HqK2IJ4/uipRUSdKkFMQ9aetRipFoAeKWminCgB60opgpaQD1p9MWlFAD6KKKYC06m06gBaKSlpALRRRQA6lpKWgBaKKBQAU6kFJQA6iigUwA02ntTKQwpKWmmgQtJS0lABTadTaACkpaSgBKbTqQ0ANpDTjSUANzSU6mUwBqQ0v0prUANNNNONMNACGmE05qY1ACGozTzUZNAhGprUpppoAjl5Xn1qCQndkc54FTS/d+pqGgBqcIP85qnqUvlWkrA84wv1PSra/drO1kg24B7Hd+X/wBfFTPSILc868USDzthOQBkn3P/AOquYuGxmVhn5uB6k1t67IHuSqgsruCPcDpWDKGaYIu3KjH/AAIjk/pXz9WXNNs9egrQRBNlWIyWKsWBIJyTxz796jkQtcADaAG74+Xv+NLcnLvsJVQDtJGMg45P4fzqOSTF1IrcjIDe4x/9aszcllw82YsfdCgA5J7YH5frUxAaN0B4jwXbj5jnAA/X8qR1WNTM2FLD5Qeg6gEj6dB9D6U6VxAoiU/Kj5ORjJXj9Mn8zQUOim3W9zFjMjRsAAOFwVbH/fKGqMoMMdsSuNi7sD6H/CrOnlY0E0pKh2wQOcgkAj8mNV9VykSsW5KbPxyR/jVREzu/DDF9LvlOMLI6j2yBWp4Zl82yieVsAsyEE9y5wfrxj/gVZHg8r9kvlz8rCM59SQwP/oIqxopK6Rd4HMcrsOcYA/8A11DQy/fqYIWIwZbaVJ1AOMqTuP0yd4x6Cu68J3CSXF5CrZWeJZlPbjj+oriZQbq0LHG5kaOTH97G7P6n/vqtrwxcraxaVMF+8qwHnnOWjOfxGaSJlsdTfgpqFjKOjk7v5itAr52nuo6gkDHbnj9MVFrMebYOo5Tkfzp2lSb1kQ/X86fWwdLlexl/0jPRZVBH16/1/Sn367enO1tw/nVTUM2yM6gEwybgPUdf6n8qvuRcQgryHHB9elV5C8yGUbvmyfmx+uf/AK1ZFq+Gli/ukj/P61qQndGFbjPyn2rDdzDqwyMK5wfY5z/n61DKibGcwo5/hbB57Zwao6YMpqdg3PlyFlH+y/zfz3VZhG+O4gY9Rx+P/wCqsqynKeIoWY4+1W20qB/Gpz/Jm/KtoESOF8Y2eIrCVgSokazdQP4XBUfqqfnXktpG1vKYn6xSEH/P4V7348shJYanbKP9YnmIQcfPjIH5x/rXjF9b771rgAKLmESqAOh4JH866L+6KPxG3pQCSbf73T611dqMqCeSB1xXKWYLQxsDllHX3rrNNPmRqw79q86od8di5COemOOac8f94fjUwj6cEYNPdD9fbFJEszZYsjiqksORWz5eecVWlhBzWiZDMGeDNZ9xBg4ro5oc1QuIBjnrWsWQ0YLw5phirUkg9Kj8rHFXzEWM7yqXyx6VoCHJ4o8j2qlIVih5fpR5RrS8jPagW/NPmFymd5XtSiM+laQgpREewpORXKZ4h9akSD2q8IemalWL2qXIfKV4Ya0rWD1pbeCtKCHGMjpWbZVh1vFgdKuRRetPhhFWQmOlZtlIjCU/Zgdam2e1KV4zUDRVZfaq8q4b8Pzq6QD0/GoJE9fXIqGaIxNRi3QtnuD2rw/Xo/s2u30a9JGDD8ef6175dplD/KvF/iDam31qKUjAkUr+R/wIrrwkveaMa60uZ2l/NdM3ZVyKdc/PLDGxxuOT+PP9abph2xznoCAPzNI7eZeH2HX0Gf8A61b/AGiPsly1AZwR1bCL7dK1uU02coPmkkEKD1wOf61StItjE44ijyR+H/1/0qxMWU2cXUovntjoC3zAn9KxlqzVaI0APMjYgZ5YKvuAf8DWrYNtVVP9/J59R/8AYmsvT23Lt7+VkH0JANX1JF4oHPz549Acf1rln2NolyLkFSBjdjnsOB/7NTkJeyBYEkqAPxjz/Oo+lqzxnPf/AMeP9AKsH5LUqvUhsfUMQP51kWY9xgKhIIjjUMFx1z3/APHafZKBYje37xt5bnGFGRj86jvzhvn+7uwMdwB/9epbZcwEt97aMgDuTn/GtX8JFtSxprZny3y/PvII9Sf8KuTAGKWI4G1z7dM/0xVeNQjRKByHUH8AP65qWPLycnjJBHr3/p+tYsqw5G3pARxknJ+nFUJ0IuMHA+6MkdOP/rVcjJUOjH7rAr9On9Kq3x230WRks4NVT3Jlsa9rK5uoXPJZEPI6fKD/AI1vy4jvQc/6wcADGD/kf+O1y1huNtbvKxJUZb2+U109tktC4+eNZcsSOcE/y+bP4V7NB3ieHXVpHSxNujSRRtyMlce2f8KmjbbLGV6FiCfx/wDrVXsWLKYsD5DnH1//AF/pUpXELDHzKcj+dd0djlNIfKvXoc/y/wDr1ieLxi1tJO6Tgj8mH8yK2IWEkO4dGAIrI8XD/iUhv7ksbf8Ajwqp/Awj8SOkQ7o8joRkVMnVTVSyObKA/wDTMfyq1HzGPpWsdiCytPFRrUgpiJBThTBTloAkFOFMBpwNMB4py0wU6gB60opopwpAOFLSUtMApaSloAdS0lLQAtC0UUAOpc0lFIBaWkpaACiiigB1FFAoADTacaQ0AJ/OmmnUlABSUUUAFNoooAKSiigBGpDStTTTADTaWkoAbSUppKQCGm0UlMBDTTSmkNADWpjU9qjNADTTDTzTDQAxqaac1NNAivcn5OKb6Us5+RqaDwfrxR1AZnGaw/EkzR2z7Bk7eB6nNbMjAbiTwBya47xLc7Mu2cAF/wAc8D9KwxErQKpxvI4a95vpTGchMIufX/OaoNhYnYEjJ8tTnn/aP+fUVZlcKCeSSxJJOMsRgf59qoX7HZHboCzbeg5O5ue3XsK8C92e1BWRRR97MWXrgqvTgdD9P89qvGNIpDK2GkkPyIB0GeGbH4YH58da0TJbTKBtkmUfdXG1cHI9jg/h9c067LL5hd90rPtyT39T7/40MtDo28+6wWDfPuY8c/jTbtCrKCcysoBHoT8x/Vv0qWOPyrWSRj98eWpz2GCT/L8/rS3CZvrcOyndtb5egGAf6/pSuUkRX58q1VVPTA49wpP6fypL9v8ARmPV7eTqe2QD/NW/Oo9RLTPAqrjzG3H8+P6flTYz59xODgiQY57Zbg/mF/AmriJnZeBHMkMidcxR7R64AP8AV62NJQpDqUTcDefTvgVgfD85bEm4NGwwMdfmCj9HP5V0dmB/aF502SFWGO4Of/rVEtxIboMzJfeS2G+0fKdxxsOW2n+X5itWMtBNDF0KyuqKT6Mzk/gWx9RWHax/8TmzBO0tJHuPTaoJJP5fyrbu547zWLe7QbV83Zg8Fcqf8/WgGejWE63+lxS9dyc/Udf5GqVg7QXMAPRgYyfpwP5VX8E3G+0mt2OTGQw9gw/xzU98nlMzj+B93+f1pva5C7FvVYt6Sr/z0Qj6Ef8A6z+VU9FlP9mIr4DQnaR7Dp+mK1bg+ba7k5IAYf5/z1rn9PcpdTRg5Vl8xc9Op/oRVdQ6GhJ8kzAdMZGPWsXWUxcErywG9R6kf5Fbco/dbhyYm/MVl6qP38DLyOVz+Bx+oFSykyS3lH24hR8rLgY7+/8AKsjWpPsdxaT7gggugZGP9xuv/of6Umjy7PsyyHfIpkU884DY/kKl8SxfabeVAcxTRc8ezHP8qcXqJljxJB5uxx/Euwj3yCp/TH/Aq8Pv4/KDRd7O5eIg9dhPH55x+Fe32sx1Hw8shOZjF8xIxiROv/jwIrybxFbY164wMR3kW7OP4l4H6ZP41sno0KC1ItNj24TPbt3roNL/AHU3l/wPyPr3rF00F40J+9W9DHuAPQ5yPY1wz3O9G0ifKO5qfZ7ZqK0fzUDdxwR6VdRf/rYpRIkVDGaikiz1rQdAeelRFPatDMyJYsDpVGeD06Vvyx+lUpIuuPxq0IwJIueaZ5Va0sPPSoTb+nStBFDyPypwh44FXhERjj8KkEOeRRcDO8g07yOORWl5Xt+FKYvQGncLGb5Bo8j+dafk8elHk496VxmaIcduc1KkGDzV3yRT1h9KlsCG3h5/HtWlFFmiKLp6Vdij9vypANjjwMfrU4TtUioeOw9qftx04pMCPbjrTWFTYpjjHTr7VD2KRAR6+tQuuc+n86sEev5U3bnrxisWaIz7lPl6Zryz4o2ebJJwv+qkBJ9jx/hXrk8fB+lcZ42043um3EPB3rgcdD2Na0Jcs0yZrmi0eS6eVW3w3R3Xn260W4zI8vVRk4/HOP1qrakrb7WypBxj06//AFqs2xAQKx4C7j9ew/lXoSWrMFsjYtgGjigY8zNuc/7AJ/8Arn8qd5++5urnkHacKOw7Afl+lQQzIGlbnBUKPZQB/wDWqWMtL5YUY86TceOBj+nH61z9TY2dGJW4Rm2nGAw7YGf0wBUyEpqUIPYYOT3x/wDWqrp5CzY3YxGwOe3GP6Gp4GLSxMP9Zgb89eD1/SueW7ZqjTi+5tboXC/lj/69TxbfJLvzhc/99Nn+lRRny1P8Sgs2QO+B/jUojZoSoHXGeOAFI4/Wudmhj3yECNWXJTLH9OP0qe3lzs2dchgD3wvH65/Oq95J56SyJxhwenUkk5qSFvJfHX5D07DOR/StvskdSzD2cHIyx+pzj+tWJDhiF6jBHvgVDbq22NTgcZPtxmpEblXPZuR7YrFmg7hpEbosg2/n/n9Ki1MESkjG9W4z9KecgtF1B+ZT796NTy0KzqclgM/5/P8AOnF2ZMloTWD5tcAKQo5+Xtg5/Q/oa6az3GBYGz8x35AHpniuU0ggzGJm4ccd8jPH6fzrpdI+eMbmJmhcEgHqOMD8elerhZXR4+LjZ3Oi09/3sTNgmVcNjuRj/wCy/KtDJLuoGNy8ex/z/Ksy1k8ySN1woLA8dOeCPzz+YrSAAmG7kEEH+depA85kunttiIJyAcHPbFVvFa50Sf2Kn/x4VZhwWlBGOcfWqniJt+hXGRggD9GqpfC15BD4ka+mHdp1v/1zH9Kvxfdx9azNFP8AxKrX/riv8hWmvX8P61pDZCluWAacKYpyKeKsgkFOWmCnCgBwqQVGKeKQDxSiminCmA8UtMp60APoFNFPoAKWkpaACnU2nUALS0lFIBadTaOlAD6KSloAWigUUwHUUUCgANNpxpppABpKKKAEptOopgNpKWkoAKSihqQDaSnGm0wENIadTTSAa1JStSUwEamGlNIaQCGmmlNNagBppppWpDTAaaYaeajagQ1qjPGaeajb7tAEEv3ce1N6oD7U+TrVfzQkZz/DxikBUvJP4QeP4vz4FcN4smxAiPu8yVsso9Ow/l/Ouwun7e+5hn/PFeeeIblrnUWxnMacE9v/ANfWvPxkvdt3OnDK8zDmkEbAg5CnAPqc8n9P1rOklMkJZA26RtmR6ADIH1yPwBqbVCsSEgjaoCoMHgnvj6CqUjsLdUVsbUwc9SSc/wAv5V5aXU9RDbbKxNKWjyo+XA6k9/fpViJPPEERwoVTuPpk5J/Kq86oqLE24BCc4HU9z/Sr+HS2d5cCRgOOyKcn9QPyNKRaQ2/mDLFGEZQx456Dnj9T+JNTSHEo5yI4iAT/ABBlwP1JqhbSDy5ByxkfaE684GOnf/PStIrDHZySNuGWCjIyEwN2c8evpUPQtGRNl7hWOSqoemMHt/7MPypJIiZLghtxRRkrxnBHTv6/lTy6xszPukUoGVdhXdjtnrjPp7jNQ4YTTu7ElHwwA4zsf/2bFaREzrfA8qNqUUuCFZsAepJc4/VT+FdQU8rVAXIIBwccYHykfoCK5PwLt/0Rx8hE6uc+gKf4GuqiYyXtxGBhkIUE4544P5lvyqZEmfr90llGGOWkuGMQUDooJ3H6HOPxrUugYYbxicFJI5F564wCfzB/OsDxvEXmgnGNsajaPry316D860opTfrZMMEXEJRj7qAT+qGnbQk7LwZd7dYiTdlZoyq/gSRn3wDXX38W4Tp1yoP6/wD168t0a8Np9jmcYa3mzIB1wG6f98ivWpR5kqkdHUr/AF/pVrVWIejuVNDm87T493LL8jf5/CsXUM2t3vA/1bf+O4P+OKv6C/l3VzAxwBLj8zx/X86g8RR7bqFugfKk/r/TH41PQrqSwzAXhVvuyrxjkE//AKqrain+isM/NE4YEemc/wAs1Sjn2WYf5WktWHHt2/T+RrS1Abl4wVcYJ9eMf1o6B1OMiufLvLSVmwPtLqc/7WD/AOzfpXTXIDQqpGWXoPXh8j8q4nWAUinj4ysjOPbBH9MV1On3P2uG0nkx8xXOPVhj/wBnpRZUkU/B8jJb6hb5z5cxkQHsCTx/46fzrn/FdkiygqufKlDJ6kEZx9eWrc0xhbeJLhekcgU8e5BP9ai8SQlgvXLKV47MvOf51TlYEtTj7GLaWxjr1H+elb9pHlcdc9R6VmWyYk+oBH41tWKEEYHNcktzr6Fi1/dTDd3wD7+hrXAzyKoGLegPOe9X7ViU+b7w4b396cSJEm3NRsnr1qyoyvHTv7Uu315FaoyuZ8seevFVZYs5rVeOq0sfFWgMiSLPUUzysds1ovH+fvTfKx+dMCiIBjpinCGr3lZqRIuxGadguUPKx2pfKx1FaHlflR5X86LBcz/KJpPK46VoGL0FIYef6UwuUBFUiw+o4q1sx9adHHnioAbFH2FWlTjmljjC1Oq4470ANC+3Q0pXP0/nUgXj+tBXB4qRELjjgVEw9asMOKiIHbk+tSy4kJHPp/WlKYXp1p6qT+NSlQcCs2aFOZPw71iapbBojkfSulZCSazr6LchqRnzx4rsTp+uTxgHypiJE/E8/rWdG4LqG4DPzz2Fel/EXRvtNl9oiXM9uS4x1K9x/X8K8q8wtL8vckD6cZr1KUueNznkuVmy8n7uGPo07AnjOBxVq1O6QHOVVf8ADNYxkLXDyj7qLhDjp7/zq/aTCOFudrStkf7IH/6qmUdCoy1N+EttMoIO9gp+mTn+tXIebjYoOVILepwf8GrLhbylCjnaMH2bYc/lkfnVyGbBEx4DtjI646EfqfyrkkjoizeYho5wOpJQge/p+f61PGSba4cj+EYA7ZP+GKqw4by1WXoNrHp3HzfqKlhdlW8KEDdtCj04zXJI2MqQO/mWycfIpAP6/qTToyrxCRV+Ux4P5AE/+Omml8NCU4y+xs9vm4/XJq5boIcRDnyXJYH+6DnH6j8zWz2I6kkTnzBExDZTex9zz/I0lqNmd3dgeR35H8qoWLF75WYgMWAP4girsgO/ap69PbuP61lItEmMOvcx4P1H+TUjqGtZoOuw/L9D0qOSQFYZM8MMHjv/AJzT7RtxiycBlK89iORSCxWsM5U5G5SAM9sc/wBP0rrNJkB1ABXxFLGCvoSOR+lcmAUmlTAGcke3b+prft5BAtncg5AdWbnnBHNejhJWZ5eNjodR/qmmVegIdfr1x+la8TCXyXQkAnOCPWs5Tv8AMjUfeP8AIVdsGLJFjpkDH44r2I6M8dluRdrkj0zVPxD/AMgS5I6bCf61ogHv6YqhrwI0O7VeB5ZwT9a2l8L9BLdF3QjnS7P/AK5L/IVqIflH0rI0DcNJsw3URL/IVqxnhadP4UEty1H938akFRRfdqRa0IJBSimCnigBy1IKjWnrQA8UopopwpAPWnLTVpaYDhTqYtPoAWiilFABTqbTqAClpKWgBaPpRRSAdSClopgOFFJSigApQaSigBTSGlNJSASkpaSmAU2nU2gBKKKSgApDS0maAG0hpaKAEptOptIBGpKVqa1ADT70004000AIajJp5phoARqaaU0hoAYaa1ONMNMQ01FIcY9zUhqKT734UAQTMVIOMj0qlcusQJOck8gdzVi4fdt29N3HvVW4dUUsxyByfeobKRjalL9nsZHn6yZBGe3f9BXnbs1w0suCfMcDHr2A/IkV1nja+KQ+Sp/ebSeOxxn/ACT/AFrj5/3Fp8oygUgAZHrk+/WvHxUuadl0O3DxtG5h6g3mT7X2nJyee3PX9fzpo2xymaQ8N/q1IyXz0IX8QfT61K8gT746/NjB5/2j68k4H/6qqSCSWXB3ZJ6fxOT0/nXId8S8iRhPPI5i6gsGJY9On0NLI+QsBJaV2JJB+82D/jjFK5+zxjPEcPAwfvSHqfwyBVCGXdcI0nMz/Kq/UYAqNzUfFb7rZdjZ27mckZ5PA/kP5Ve1JPs9uqK3IQcdcE9f6UyzgVGXecpbjMnTlucAfkPzNJqR3WrTvzkkFsdWI4/Q0Xux2sirI6oJclsRxqGb05BP1Of61nW82xWDZWLIKLzxkjnn2Wr0oK25hOC0hBYY6ccfq2KyT/qSSMcgYz09D/P9K2itCGdn4QLRqcKC3lk5wMDaf8ZBXbXUawazHgDMu1s567d39JB+VcR4aZTD5a4BcNkgnp8h/mldvqu5vEWlRKVCyK4xjnrH/hUdWS9zD8WDzXAjw0cqnbgdzFlT+QP5irHgeWOa1WNif9FlVxn0JCt+QZj+NU9clJa3jXcpBEbZ7jay/wAwPyql4Nl+z6qokb91OcMB2DZB/Krt7pPU6G73RX91CvcMw45ywzn9MV6p4WvPtvh2ynbmSLCPznJU7Sfx6/jXnOsxOmqWFwCD50aoxB4JIBH6kH8K6D4Z3oK6hpjED5vMQDrg8H/2X86qmiZ7G/KDba/Mg48yPcD7ggVP4oXzdLE6D7rK4/Oma8GW40+6Hdwj/Rh/jVmdPtOiXEfBIBwPryP5ipekmgWqTOP84RX4Zz+6lAR/bJO0/rj8624yW01UflovlJ/GuWvSJVKYBWSIAj/gP/xQP/fVbeiXP2jTd78sQRJ7sABn8cZ/GoZZyGtAm4nyBnLKfxXP9BWn4WnZ9NmjTGUy0fPtlf1X9KoeIRs1KYADBAb9cH9M1H4MuAt55ZJPJHoMfeH6ZFZ7GjV0ad4NuvF0x80ZCe/cf0q5rJEkUj4yI5gxGegIAP6Emqd5Htuoto/1b+WPYYwP0Aq5KRNLMo+7MgP+f0ob1FY50w7HHqjFT/Ota3j5BXj096rBMud3VlB/Hv8Azq5a8fhxWLOjoX4lBHHGafGhVw6jnpj19qdbr0x+NWAnzYA4amiCaMZG4dDTsZHA+tNh+Vxj7rfoaslOM1vHVGbKxTr6e1QOnpV4rnpxUbJ61ZJnNGD9ajMR79avvH60zy/xp2HcqBM8YqQJU+zNSeXx6VViblYLj3pwTvjmrAT04o8vsaBlVlx1/KmEeg5q75YpvljoKQyoIs9ealVP51NsA9M04JnGamwXI0SpUXHb8akA9BTtvNAiIjHA/HFIRUpGOlRNUsZDIPxzTdv5VKentQFJz/OoNENVfbFSBf1pwUBakC8VNguQOmeO561TuY88EcYrSIwfeoJUyMe1TJFJnJara7lOe9eL+NNAfSrmW6tkzbNkYH/LMn+lfQV7DuByM+1c1qunLOjK6hgcghhnNVRrum/IqUOdHz1CxSDY2fn5I9quWcm+4DvgZYNj0Uc/0FdR4m8Dyo7T6ZwMcwE/yP8ASuNiMlpI0EsZV8hWVwRt+or1IyjUjeJxuMoOzOjjuC0asJCCytK/uxOAP5fh+luWdFjSMOdqyZXHfH+OKxrV4t0XlbpFLgkZ5JAPHSrq489cfvPJVc4bgkdT+J/nXPOOpvCWh1emSGQzhlIjl+VSf4Rxk/zP51chkWdf3ZO0M3P97KsB/ICsS3uGispGT5nuNqBV/hUYJ79/6VZtbv8A0CS2hbJRW2OR2DAdev8AdGfc1wzp9TqUh6JhZ4GwZM5/PBH6k1ZgbNtNIwyZIySe2chf5c/jWfkyXKy4x5yHHY7s8frx+BrTZo3gjMRxudnVfXhevtuX070pDRmxExz+b/y0kxsXH3c9z+fH+c3+CsEgzjjOf8+1YrSEXSOSfmO4k+pP+NaVs5azKE8xnn2qZrS40y18rRzRgYxh19femxythvlwykSAe/eiFts0Tk8P8p/H/wCv/KoJv3EuePlbB9xWa10KLNyqi7ikJG1sc+2DzWnYM0tiY2UMUOT+n+FZMxElpt+8Yxlfoen+FW9Mm2OHyFBGx+fwP9D+FdOGlys48VG8TtNHmYiydSTGw2H2IB/w/WtmJhFuUYwDuyPwrm9Gl2s0HcPvH17/AM66JxuBYcnYTj1r3qTujwZrU14zktkf5/yKoeIh/wASW7B/uGrdrIJRuU5BUY/z9MVU8Rnbo1z7rj8yK6W/cbMuo/w+zf2fbLIS2Y/lJ9u1bMf3V+tZGlIf7KgxwyqGX+da1uweHcvfmnDRDZZi71MtQx8E1KKsgeKeKjFPFMB4NPWoxThSAkFOFNFOFAD1paZT6AFWlpKWgB1LSUZpgLS0lLSAdS0lLQAtFJS0AOooooAWlpKKYC0opKKAA0004/lSUgEptOptABSfSlpKYBSUUUANpKcabSAKKKSgAptFFACU1qc1NagBhpD7UpppoAa1NNOamNQAhpppxpppgMNManNTWoAaagkOW9qlYhRk1VklyCVGeevapbEQE/NwOF4FZV/MFzIPmUfdUfxEHOfzq/cuQVBOB0471zniG5Edqfm2gqScAcL/APX6VjWlyxbLirs5PUi2o6iclSob58jOQMc/mR/3yaytanSLchf5MkkDjdjpkfp+FdBDFttvNlKrK6GdiDjaCRgc/iR9K47VDJc3JBXLPyEXrtyf/r/qe9eRNcq13Z6NLVmdNKzuWYZk7Jjqfp6D/D6VYtFeL96V3SglRx95+5z6Afrim+UiXAKlXlVR0xtX8e4H6n9VupAp2qMRqNqDGN3qT/M/gK55PodsUV7q5WV1iQhoYxknHXt+uB+lSWEMkl0sqrliQsakY9f0B6/T8mxRKn72Y5LHKjHX6D/I+vSrszG3h8uHiX+P6/wqT/T2NS3bRFpX1HXsqrmOBw0UbEGQn/WSZyT9Of096r6iwDQwPwqAOw+g/wAQadp0YM8LuSY7dS27H8Xr+ZHFZ2sXImjLxjBlkxtBzjAHH6inFXeg3sV7mcTJNJnBOHx6VFcMJYTLux5gz06MDz/MH8RUV2+2S5QcA4x+YpLQGWORGHyvyh9GGcD8RkY9x6V0paGLZ2nhBQVDKQobcE49yR+jCu98QKY9UtpgOVyEYdgQT/7KK4X4e5eO3Z/mIlTgehZAP513WtNvi0yXIxvQsfXtj/x6sH8TBnNayVEct0B8sdwhB9Vyh/8AZmrGDmHxHtUYKy9QOgII/mRWvqce/RbyIdBbxKV9GXIb+lYF9IRqkNxnAKK3Hc5B5/CtoLQmR6LLIbzwszLjz7CUdf7vVfyUgf8AAah0C7/svxxbDOLeXbFx0IbIGf8Ax0/hVbwtOE8RXenTnEV/CUwR/Euf6BqpeKIGg+xPgCVP3L5PQrx/9ehaMT10PZ9dh+0aPMoHzLkj+YqHQ7jz4T0xJErY98f/AKqXQL/+19EiuDgmWNS+P72MN+tVNI3W9z5WMBXK/UHp+uKKujTM4bNHJ3qGHUFROSsrwNkdFJDA4+qqPxqTwvKyy3kJIKPtkXHv1/kKTxcfsupTSYwvyzH/AICyk/oDVbSPk1jlvvRHp3+bP8jWLN0tCPxEn7yGXOcFoz756f0rn9BlNtq0RJAX5AT2wS39DXTa4u/z1b7o2uPbnn9BXKQ/JdL/AHlbafYgf/qrNmsdjsdTGy6f3ZXB9MdabathbdyeCNn8x/Sl1L99d27nA8yLI9sj/wCvVckraNjG6NyR+ef61D3GloT3UYW4Bx0bt24H+FTQJgjHSpJV82MMOhAYf5/GpLden05FQ9ylsWbccYB96tAfKCOcc1BGuDxVlPu/4VSJZIF6j1qeMbgG79xiokH7se1TxYDEdjz/AJ/StYkMUx/hUbLnirOMD1ppXdWxFym6e1N2Z9M1aKDpTSnpQFyvtp4XHOal2c0uzFUIi20pTNTBaNmP8KYEBXNN28cVY2U3b7fpSZRAVx9aFXmp9vNLtx7VIEeAKUg96fjGf1pDz06UmBCVODmmEBenNSn9KjPPTpUMoj256U8DsKUDGPWpI1yeOlTYLiKnSpMU7bgCnFKq1hERXPWopF68Vax1OKjdM1DRojNnj71lXNvvU8ZroZU7VSkizWEkbRZzU1oDw44Ncz4k8KWmqQkSwgt/C44Zfof6c16BJb5zVeS1DqUPcc1MJyg7ot8slZnhWs+Gb3Srb/Qbd7pdp5jONuT/AHeDk+vPAFZFrMypNDIGwko80qSFB6KMeufbtXvt3YZ5wMZ5IFcp4g8KxalJvZisycoy8gHsSO+DXdTxaatMwlh3vA82llkZoisgAlmKkqeI1UdM+wOfxqSC+Bt8xEszJ85C884d8e+Qah8Q6BqWjW48pWntkyxmUc5YAHI7DAH+PYZXh68kt7uIuFdd3Clc5wR+fp+NdXJGUeZanNzyjKzO9s5BebYz+7JPmb1HCYX5iPb5T9d1NurthqcRU+XCQY0Uj7qgcfzH161WS9trWBbYsoaQ+WcYzuwDgH05Ue5z6VXZ3uojM/31I2nHQgcj+v4Yri9nqdfOJO21uTgA4yTjYfQ/r/kVf06bdMwIILgg+zD/APVXO3t49vcGPgqxJHA5z/T/AArRsJi5GxVGxh949PYn096KlJ8o4zVzX/gZTztbgen+f6Grl1EbhS4AMhUNj1x1/T+VUo5VWRwCfN+90OQR/XrTlnPylSCoGD2yMVw6p3N+hPC2MI5XcDtOGByD70+PcjNH3A3YAP0/nj8u/fNPErQnO1uY2HXPp71aDSSoso4nh+ZsjO5fX39/xrppx1ujnnJWszo9Gug21oj80fGen0P8vzruYZQ1qsij5cZwB26EfzrzLT7v7LeK8fEEvb2PUdfX/PBrudGlG4wA/LKC6Y/WvYw0rqzPExEbSOh0obVlTOdrcH1BAqt4qbGkMv8AedB/48Kl0pgyllIO5VJA7HpVbxH+8jtIh/FOCfoAa7W7U2cvU1tPXZZRL6KBVy1O12TseR/Wq9oP3I+rfzNTRDOD78fnWq2Qi9HUoqGE5XNTCqJY4U8UwU8UAOFOFNFOFADxThTRThQA4UtJS0AOpVpKWmAopRSU6gAFLSCloAfS0ynUgFpaSloAKdTadmgBaKSloAWiiimAGmGnmm0gG0UUlABRRSUADU2nNTaYAaSiikAhooopgNpCaWkoASkalphpAIaaadTTQA1qY1PamNTAaaYaeaYaQDWqOVti+pPAHrUjkAZPQVSuLqJEL7weOmaTYDZiOrkH69BUEz7M4BJzwPWmTXUZVf4juHA571UkvRltkTsScdMVLaHYiunYZ81QAcDjkn1/CuM1q5+3ahHCg4LZJ3EDaDj+ef8AIroNZvnhRmfKqq8hTznNcnZF2DTrGWD/ACnBK4B6Y9sn+dcGIqcz5UbUo21J9evSlpKqqud2N2Mgjb+Q7muHuZ5GLImUQn5x/Ewz3J/l0Ga3NfuX2KhcBlGcJ9wdvzHSuZlmw44+VDlh1y31Pv3rhqtuR30I2RNF+5VnAOVxtAHQnoffAyfwquZlDZZQ2OEU8g+5/Gnky+SqbQXxvIIP3mPAx34x+Zq3bxRWbo0wV5lBKJkDH+0T+tcspWO6MRsSfZo1kk+a9k+4CeIx/eP4dvx9qqysEkijzvDHJ9W9T7D3PtTrqY722kyyv68bvc+gqGyjE4kDyHdNnzJcfdjHLH8Tx/8ArpxXVjbtoXTOV0wtt/e3T7iFHRF6Y9ORj8K5u5lLtNk/6uT5fYc//Wq3qd9vklZPlVtkcaZJ2DOcf+Oj86zLXa1yy5DbxsGc8nH+OK6KdOyuZSkTzKxWZhjO0N/P/wCJqG0QyJw+BGPMJA79h+YH60hZ5IlRWzuHJ/Fsfz/WtOGE2luGH3owsn1cg7F/PrWuysTa7O48KSmDTbycooaGEzE4xhsFlH5jH/ARXWXH77RbSRvmMT5bGO0in+QNch4TDTaXfwuMqwtgWJ6gygMfyJrrrRi/hm7jfkqnAx04YGueSDcw5wzve28mCzJKCe/Utj8hXL3o8ywtJQMFcJ+Q2/zU11Ol/Pel3wBKpJGPVCn8wa5ibjRcPwRJn6dCP/QjWkWJ7mjc3rWmpWF/FyyMjjtn+LH8xXa+N7dbm086D5oZ189MDr03fmAtcDqEedLVh1jJHB6YY4/TFdx4cu/7T8E7H+eawcEgnJKen0xkf8BqhHQ/Cq/L6dJayNkxvkc9Ae2PqrfnW/eYt9QZjgDh/wAiM15r4DujpviARMQFY+Xn1zyP5D8zXpXiBSQrp1dWX8cZH8qmesPQhK0zn/iFBvjEgPLIy9OuVx/U1heHrgzG0kzksu0n3xgn8xXSeIn+16JDL3K5b8f/ANVcfop8iVo8bdjkj2Ga55PQ3itDZ1A7n+b+Ndp98g/4VzEilLwMOQ2Cfrj/AOsK6LVH/drKpxyp/Xn+dZNzHudDjIWQD9cis2zWKNwndZWMnB25Q/y/kKdCvy3CHuelMthnSipH+rdT+OMf41Yhybhv9sA/mai+w+hYsPmsUzyYzg/gcfyq5DH0x/8ArqtpS5E8fYNn860bdPkwecGqSuSKq/r+lORcVKFwPxpdvf8AlVWFcWE/KamjHzAE9agj4HFWF+8v1rSJLJ884P8A+ukIp6DI5pfY1qZkJH09qZjHXmpSMdOlJ0phYaFx0pwAx0o9qUHHSqCwYz0oxjpS9faj6fzoAYQe9Jjinn2ppHrSKI+mfWgZNSYyelH6dqkBnemmpcVEwwOetJgQP6DpTcDtT3OeBQF9ahlCKM9PWrEaAdqSNanVcChEtiYxgUY/Onhc9adjNVYLkRFNIqbFN2561NikysycVXlTr71oFfaoJI6zlE0izPkjx0Heo/Jx0q+U55pmzmsuU1TM2SAcjHFV/soZSGHOa2ZI+MjtUXl+1TylKWhzlxpwckY6dsda5rU/CllLObiO2iiu8MElCcqxH3sdCa9FaDLZqtLbhuo/GmpShsx6Pc+dtc8IavZTB0AukQlleM/MOc5IPOfz6VDPdnzPlBEUuHIxgxvg8H9fwr6CuNPVh0+nFcxr/hez1JCJ4l3Ho4GGH411LFX0mjH2CWsTxu+jMkCgEGUD5CP4hx09xkA1Fa3DKpj24ZkILDuQQef89q6TXvBl/aTStZs12jHdjOHXuPr9a5KVJ4piJYnVwxJRkIbpyDXTFxnGyZjJSi9jcgvfOUYciWPBz3Yf4/8A1qtW1yJAUIC7uR7H2rlYbh4wNzEOvAPcir8c+GEinjPIHY/4GsZ4dGsajOhLb0xnDg8Edj2/wp0d4Ypo7heufmXsPUf59qzILrzOG+V8YYHofQn3qxGw3MP7wyuezCsoLldmKequdPNZrJb+bbZMLjzIyBjBAyy/kMj/AHT1rW8OaswQRygb4j8nQEgdv89j7VjeErrzYZ7MjdNGRJCvcEHOB6HII/E9alkthFqUaRvsWZcwtjGfQ/0I5xz7V2RfLZo82avdM9H0ScfaJVUghlBBz7D/AOtU2okTalbqP+WYLH8cf/XrB8OX2WXcuwp8si9wfT17Ctq3w2rMz9FC5Ptkk/oK9CElKBxNWZ0Nt/qzn+83/oRqeIYj+hJ/WoIAVhQHrt5+tWLf7n4mutGRYh4LD8anFQRfy4qan0EOWnCmrThTAkFOFMFPFADxThTRThQA6lpop60gFpaSimA6nU2nUALRRRQAtOplLSAfRSUtAC0UlLQA6lplOoAdRSUooAaaQ0pooAa1JStSUwCkoopAFNopKACkNLRTASm06m0gCkopDTARqaac1MNIBDTTSmkNMBGqM04000gENRswUZNOJwKgkP8AEx4FAFe4zJ97kdlHT/69VZbaNnyUXAwOnX/OatMTnJHI6D+lQ3B2RDc2Bnn39hSsgI2Kq4VQBj0qhczLvPIJBx+P+c1PO2d2PlUHkjqfYVj6tcra2zSE4wMAcHn096yqNJXLirnOeIJ2vLkWsDEpndIQuT68jPb0pYo/LdVYkRohz0wrDj29/fkVFbAwrJcyEPOwLhG79h9OTWZrmrxCMwqwkmlyDg99oHI6D/8AX0ry3JK8mdUYN6I5/XpHMjytJmUnBGAOcnj8P89KzLaINhFiDuR8oPYA889s+v06Vakj3SKZGYqx+RVyGc9cdP59OarX935QFvbRq+Th9g+U9BgHqwHHtnJ964pT5nZHpUocq1Lhuo7QsyOGlJw85/h5/gH4/wCc1lXVxzyzKG+Ykjk+5J/p61WmMyiRxzCm7B+70xjHucjNVQ4YoXBdpCSqdQ3/ANYU40upq5E7zbxjkQty543Ef0q3fubSxCEATThWZVH3E/gT8fvH/gNSaXZHylvb1dy5zDFjJlYjv/sgj+nrRfR5vZpZZN0pY5bGQp7nPT6U1Jc1hcrsc9ckhgvLEDJx3NSWVv8AvhI/C7uCOpx2H6c1oGFEX92ny55d/wCQHc/5yOtTxw+Wq3EoKnBMajhmGMZ9h79euPUbc+lkQoDJbeO3ZeR+7UZJHAOCf0YkY/XFSSM0twgx/qUaQ5Pc4OT77iB+FJ5b3K+Yw+VT8iKOCT0H+ewAq/DaFkMXeQM0j47Yz/8AXpXHZnR+Dom/su93tkG2h3Z7Zy2PzWuv0tcWVxCeQ0K5Pocc/wCfesTw3DusL14wMOVVR9N2P0eugICX06N8qGN1x07H/Cs5O7FY53TyRgHBcxsQw6AhzgcexNYWswj+zRs5Z5Dx7AjFdFbrlozjAYHAHPBUp+HJrIuovMgt4nHzYU49ctTi9QaKs4LWNwv+2T784A/ka2/hjeLDqhtJv9VdqY2B6Z7f1H41jplknUDI+U9P9r/7KorAvaXqyRHa6sGUgdD2/UCrTBxujfvoGs9QPTzIZT1r1Nbkajo9nP3JUn2J4P8AM1wXiZRdSfaYh+6u4lmAHr6fqa2/Cl2ZdGeAuSQPlB7f5NZt2uiGr2ZYlO3SbiA4AicgD261ycSbb8Z4Enyn9RXXXJUyT9MSRBx6cZ/+tXLSAi4BYAsjqwGfoP61i9jSJfmPm2TjABUnPP41SjXLkFf+WgI/OrKciUDowB/nUQT5JCM5JJ6Z/wA//XrK5sjRtM+RcrjBKBvy/wD11YtVy0L57AfpTIQPPlA6Ohx/OpbMZgQ9wcfyoAt6YMXzjHDIDxWtCnzN1zWXaDbqqZPVCP5VuQj5zWsTOQzb6daCnHpU5TByMUhXFaWIIVHyjFPHBX60gUhfxp+PmX60IZMOoxTyKRelPxnpWhJGR170zHNSlcUhXIoAZjNGKdtzSYxVAFIR70u3nilxTAbTSDipMCm7aQBSAE/Sn4oA44pARnjpUMgzx3q0/FQuCahiRAQB25pUUk804Lk81Kq5qSmxUWpguaWNO9TBcDitEjO5FjH1oK1Lt70nTmqsCIiuaMU/HalI7ZqbFkW3IqN1xVjFMIyfapaLuVCvpTSg47VaK1GVrJotMh25qIp1A/Wrm3nHSmuvzA/nS5SrlfZ8oz6UjxAirIXnnvRs7HrScR3M+SEHqv6VBJbAj7n0zWs8dQvFzWbiUpGHPp+c4wM8njrWLfaDBcfM0QDAFQwHIHp9PauzMVQvb9QR2qeVl83c8tu/DFuNxuLWGUEglxEM8YJPTP4DvVeLwzo8wZXtVTcfvJIQfbI6Dv8AhXp01ll/asy+0qOdcMg+o4NQ3UWzHaLOHPgTSJLkPG9x5QIDtuwuAQCecnn+vHSo4vA1m00gW6uY4YmIbK5LYIPBwO3fpXSy6VNb5MGxjjgMoGDnk9OvPtVIXt3ayE3UYVXK/wCsGQMn5iT6f41hKpiFsx+zQmm+C9OhlV4bi781TlHDjnnk9P8AOKm1Xw6bvBgnhJDbl3Lswd2SOO/QY96zLzxkWulnUBQSpXec9OxGM9f8mu8sD9rtILoEKtwofqcg7cAZ5GT689Kj61iaWsnoYVMNBnDw2d7p94txNCyBW3eoYdxnv0H511GnyJcys0eTHKFBz2Byv8q2tvlIyShR/CMHoe4561DFaQxSFo9iNgEFRgN+GfT+delhc3htUVjgrYKW8WaYPzfhU9v9wfU1nCfC5Izx0HUVPb3UZ+XuD6+9e9TzHDz2mjz5YWtHeJoxfeNTrVBLqMHnNWlnQ966I4ilLaS+8ydKa3ROtKKYkiHowP408GtVJPYztYkFOWminLVCHrThTVpwoGOpRSUopALThTadTAWn0xaUUAOFLSUtAhRRSUtAwp1FFIBaWkpaACnU2nUALSClooAQ0hpTSGgBKSikpgFFFNoAU02lpKQBRRSUAFNp1NpgI1IaVqQ0CG000ppDQA001qcajNACNTTSk1G54oGMY5OewqBjlsn8B6e9LLIq8E59FqtLKT1YRj8yazlUjHdlRg3shZJFTrknsB1NVbl8fNIwDfwr12/h3NMubqK2UkkDOMsx9enNYl9q8CmVBNgjcPlGW4GTXFWzCjBayOinhakuhNfXvl/KBz0BkPf1IFcfrmoSfaIx88uW+XAOA3bjt6f41au9RFyMRJgblYtIMDBAI+vPFU5C80yESn77IhwPlBGe/oP8O1eJis2UlaKPSo5fbWRlXSXkoZ55PKiIGQGxjsuT9e3tVR7eKK3L8KhDEs4B4U+nc/XjtzW40KeXGwQ9BIpc4UMGJySeT07VE1oJZ4YVPMm53dscRg+mflBz+lec8VKe7O+NCMNjBu4gEaOAFMgKzZyQv93OOvIz2zVb+ypSsrRLyIvvY4Xt+fA/WujhgUMHdgNhd3yNo6Lxn8cVHLfIFmEeWDH5gi9PmOCx7DkeuaI15dDTkRjXeixRy+W82BHESAeBkt9eeMflUdvZpHJCFhG3nCY+dhgck9v/ANfStyy02e6uFMuEjDAfMQcDI+8x6gdD71px6etsqsVKYlyHkHLfKCDzyTk5z074qnieVWbD2RzU9vKrSy3EhiIIGV646bVHpiq8tjA0LFIgqgfLucZz247ngk8jFdlDpUSRtmEyNgZaU7gD1wo/Ln3P0qUQRSwmOLLykFVwnCgnOeowOh+hHrULF66B7NWPNok/efJF50o+VRIvAP0/H/PNWhp0t3eGLcX7vIxzkgcn9K6GLSGjkaOVwpjGAQD0xnj8DV6O2Cw7IQqKQNzY616cKt1dGXszBl05UZAMCBeh/vc9atyWojtcciWcjcP7qA8fngfkPWtZbYLmR/mVDwCPven0oggzcCScbmz5j/n/APWquYTjYvaJELe1CyDb+8CsAOmFVv51bfLXCy4yNyA8dMsAf0JqNFK3MMQHIkYuPy/xx+FTTDbFdBR/Dhc+pX/EGi+pkZW0peRKOGVWH0AG7+prIv1DQ2RHR3Axn0Zq6GRd2oTMPutGxH08v/69ZDLu+w552yZHHbI/xqkIziMTXS4wNjfkOf8A2WozFlg3rVgDdfHJ++xA/EY/rRACVHHOcEVVykjf0uQXOh+U3+stXyPdG6j8yas+GpjDNJH3HT3rJ0uT7POM/wCrYbH+h/zmrsGbXUhnoeDUSehDjZ2OnlfCxN2BKf4f0rnbhcXAY8cgE+vJ/wDrVsSOGIXs3I9jisy7UFm7nGQPx/8Ar1g5FRRLCNrhSeilf6/yp8IznuMn+lEeTKMDhuR+RFTWADNhs4HP1qN2X0LNqp/c9ztK/kP/AK1XbSPjH+0cfhiqeSrY7LIv5cVq2KfvDx0yardh0EQY1SA+zfyFb0SfOT7VjgY1G3B6/Mf0Fb8SYAPXtW1NasylsIV45qKROM1b2g1G6/lWzRBT2UAfMKsPHio8fPU2GPiGQKnAqNAO3WrAXNWiWR4pCvPpUu3FGzP4UxFcrSY9qsbfakMfpxV2Fcg255o2+1T7M0hjzRYZDt9aNufpU+yl2ZpWKINnNLszU+3ninbaViWyqUx1FQyD05q5InHeoHGM1DBFcD04qxEvtzTVXn1qzGlEUNgi4A+lSbM9aeFpcYFapGZDgkmkcYHHepmFNx0/rRYoj2k0mMjipMU0ikWMI/OmkYqSkxkikBCVz7U3b83rUxFJt5rNrUpMi20EZqTHNNx+dFirkSLhccnHrTtvGafjmkOKVh3G4phSpcZpe9TyjuQeXTSnNWCMc0mKXKNMqNEDioXgFX3XjPvTGUGocS0zMltQ3UVSn01SDxn61tsvpUbAY5FZuCL5meceJPClrcqziFY5QPvoMVseB4p4NAkjmyzJIyj3HBBGffIra1VQIDnvUenwiG12SqQMEEdRnjJ444z1ya48fJeysxrVksaIXCgDywdqvjOD2bOMZ/ziljgWVWcAIoU7On59O+CP8KZGN6Ki5BY5IOAvr6enGevFSTfdTAOGIXaScHv078Yx/nPjRfVlNAR8p3Dhs7vmyN3fHf8AGuf1gtukaNJd4YK4zjgOOvp09utbLBDtLOWDEsN2RwPr/SqNzFGZV2wk/Pj5OpUFj79OvXp+lc3UEu5mebOhKCZlKuwBbnd8uFA57ZPT0oh1G/hhZ42VlRDJtbkkkjAx1/pVmXYjGRTyJz1YHOdv+B4FRXMEZiyqyCJ1dcYHTrg44xVqqx8iJ11qZGnBIPlE7VPBb5c4Hrz/ADq7F4hULCzlo/NwBn+Y9e/NZBVFZmGGygcK+M9Vz/8AqpJY4mklRcJukOwEZIO0kYPStYYqrD4ZMzlRhLdHUWviCIkK1yiuclVbuAcZz9a1YNSDjIZHG4Lwecnp+dedqsbqAIAS8IKsi55ByBx2yPrToQI1EkDyg70baeuScccdiK7qecYiH2rmEsBSl0PTUv484KnpkY5qeO5hfo4rzFLm5th8k37oRuvzH0bj9D+FWoteuo59kmCQ+MsCcqCBn8jmu+lxDUXxxuc08qj9lnpYYHoQacDXB23iVUVBKGRmJHXoR1Bzj2/Oti18RwO20ydBk7hjvjH15r06Ge4efxaHHPLasdtTp1paz4L9HXcR8v8AeUgj/PNXIpUkGY2DD2NerSr06nwO5xSpSh8SJVpaSlrUgdS0lLQAUUUUwFp1MpaAH0UlLSAVadTaKAH0goopgKTTGpTSUgEpKKGoAbSmkoNMBKXvSUUAFJS0lABTaKKBCUhozTaAENIaguruG3UmRwMds1zep+LraEEQHecE4HJ4GT+lceIx9Ch8UtToo4WrU+FHUOwUZJxVSe9gi5kkUfU1wF34jvriY5HlxB0HQ87u31BIH51lmSe58kzzs8jSHvwoG78+leJWz/8A59x+89KnlfWbO9u/EdnBuzKuEGWPXA7/AICsq68UI0nlpnPAPqGOcfmBmuPSMNancTtNqxCABj87Z6dzjgCrbpm4ORy06HOeANnFeZWzfEz05rHZDA0o9DTm8TTbSIIhl0Z0J7gdiBz1I/Cs651LUJbgBp/KAkUOEA5BHTJ6kVDhRBCqcNJGU+T5iFOT2z6frTo1i3W0gTIYRsSF6YYLnn8cVxTxVST96TOiNGEdkVsTXVuXmmaUt5bEbuDztPTthaeLRIHlj2gEIyqSpztwuD69utPKOVl3btisoUdAB5h9evX9etWfs4jimPlKZFLKzFvQH1OTmsPaNmlkjPKo4O1SW2KQVUkkoePz5qUMVkJwcGZGBPII2+39KtNDtRlYjcodQik5PAIwAfRiPems2ZhuYZjYMAV5PABwfp/LrUuRZnyuxY4jOfmCrIQoCkA5wO4z9arRCadkkDncww2MLwOQMn15/L2rVktRDNK4DLt3hQAuTnHfoB/Qd6kgjCwBVD7S+1yhyCNnGc+gyMk1SqaaBYwV09FlZmcyYJO9gWLD2H5cmrwtIA1xG4KMrOdgXsOR3PcDt78VPLbp9nDsQ7NHkY5OQQeAME8YrQtIkhupUkjXa6gLuwqvjnHT1GPx/Gm6rHsJ5Z2ZtYl5i2MzYwMk9SMZx7dPxySNUkHybp2cgkjggcDBPQdunv7VZt4jcTFJWaXGMxop2Nkd8ZJIGeM44xVuB1+zLBGF/dHcNvBABxg84BJx168fSsXLuK/YzzpVxeLNvbCMdyRrgKTkZz06c9+vf1uxwRwRtHEiJE7BS6tj1J5HHUdufrUklul06vHK7u6EqRnaSeoPHHBxn8vWpI4xtZmyk4JQEfvCTjB5yc49TzSVR2sI56+tzHMszBeRtYZ7+vr/AJFQ4xb4LAnPJFbmoQiYNERtBXknIIOeCQenT69OPTmbkyQTbAnKjDDNezgq/PGz6EyJ4wAfmbhWyfwFSWW12Z5OEXLNnsozj9QPyqCRvLgjU8BvmY+1LeyG305Ylz5s5ywHZc//AK6746s55E2lkyXvmOcMxBYHsTyf61dlGY5W7lQSPfJFVNKAEuH/AOehX8l/+yNTyscOD/EhIP4imSMiX92zZ+7bEsf++B/U1ibfM+ysOFUYIx0ywP8AIGtwqBpcxHUx4PHT7p/mD+VZkZxHHvHCgY/75b/4pavoStzNZSJg2Puv1/GnRp+8kXqN2R+PNPPClvVg2P1oQZnOT1X+tK5qkTKOhxVuRzIit/EgH6f5/Sq4bt3zT7ZgZCv97tSexMkbSykxxsPQGmTcsT2GD+uaqWr5g2/3TirQIKkcZxj/AD+VcxKJYhtVfRTjj6//AFqu2q7ZSQMr04qlEd6nPPcVfhxuUexH60Lcomjj3pP6txitHTG37nH8Sg49O9VYh5cXP41Z0XmFwex2/lWi3RL2LkS7tUh5+6jH9VH9a3ox8gFYlj82oTHg7UUfmST/ACFbkXJ4rel1MpEm3j3pCmR061IvPFGMd63Miu69zUPl9ferj4PH50wjH0qWh3IokqygpqLg1ZRcjpTiKRCFGKTbzU+2l2VdhFcrSbateXS+X/8ArqrBcq7KNtWdg/Gjy6dguVtnrTtlWPL6mjZRYLlcJS7Kl20N0qbAVJRiq7jJFW5e/FQY/Ws5IpDI09BVqNMYqOJelWUH5U4hITGD9aUrkc04DBpCR+daEDCp71GRipTTD3zSKQwjApDSnr1pDyc0DI8fnQR6UpNNzUlB1zj9aToeD1o7UZzzSHYCKaRnFLuwM02kMTrSA9qXdTetIpC/zowPyppbFIWx0oGOzxRnFRGQVG82B1rNtFJExYVGzj61VkuAOKpz36L/ABc+grJyLUTQd+KgklUZycVlPeSy8IpA9TUckUzgmRiBUXuXYluZBcThOCi8tnPPtxUjuWXy42+YP2yMj3/yfwpsMLQxqpVm3HdlW9MZHT04/EVY2bpFluORsDBwhAHfgj6df5V4eLqOrOy2Ra0BA22NQwBA3kgkk8Y64/D+VRP+8YKjqYQPLBJ454OPwx3/AMakmmQxsWjbcQXCqfcHI7j0P19aZLMGddpYFRw0gwAQPujpgkHr71z6LQNStcBVw4y5C4ZZcHK+u4e+e9VpFjaSAnJJRmcM2RnABz2/CrN4zGz8tid0zADIOFXrkZ/mffmoI3droy+ZnIIU56gEc5PsRz61D0KWpUmjASTYxYZ3HcoBPJ56cf8A16a6qwlRFX729VVSeox2/DrU4jKlo2yQsZTODwd/px/nmlG5XTG8nBHp/dIH15/CpvqMqvaIIArHBMSEEgcEe34/rSRxSBtyqoDOjMmcbeduMdhz9KvhCs24HBLMNuM4G0kfrx6Uk0arBgMA3lRtzkZOAw/rWmq1C6ZnRRlFCOGUhXTLN0G7jp6GmmPdId/yZcAjBzuVuw9+avSbVllBVlDNJjAIJHHTr3NBmRblg3JJBwMn/lpg59uaSAz28tY4gdoU7TnkAhlww+uaE4t/mGQ0bEMW53Kc9+/AFTyHY8Sus2QHVT16OPw9f1pmx2hkZgSEkYNgq2QR6/4fnVAV7lBOTyGEhYjpkEoCOnHrUUijKMAyKVQkqccnIx9ASPzq15UnyYLFW8t1B6ZyF/XPeooovKBy4+WJjwCej/r/AIZq1qgHWlzcxAmFxggkjdjcSTk8eijv9PatGDxHNDIfMyCu5R747/kPxrOaIAtsBfD/ACjGOjA9fX5ulSG3z/qlH3ZPlY5KYPH8yMe9awqypu8XYmUIPRo7iw19JfMG8OUGQOhYeoz6d+K2ra/gmOA4DeleVi1G5hHvhD8dSAN23PPfr+Ga0dMuZFWCGSZEjZeGIBIXgDPP+ea9XDZ7WptKeqOCvltOSvHQ9NBBXg5HrTq5rSrqS2uRFM25W/ixwa6WvrcNiI4mHOjw61J0pWYClpPrS10GQUtJRQA4UtNp1AC0tNzS0ALSikopgL39KaaWkNIApuaWm0AFJRRQAUUUUwCkpaYaACkzQTUF1MIIWdj0FJtR1YEV3fRW7BCcyMeFHWuW1XxLKoQQIHEjMpKfNsx0z9TUtyZLhldC7byd/lnBUY6n1HNYepRuplLvLvlXKBk2gMCD78/KD09PSvkMyzWrJtU3aJ7mEwcI/HqzPu5bq7kH2mZ0G6RMDgldvYHuR/kVVNsgjBRRukHLuucbkHT15HSrm5hdI27bG8pJ+YdSg7VDDCwFu0oXMcnlne24/KcggfRjzXgOq5atnrciWwxZI8iRDvUpE3qQA3pjj1/OhlKRK/OzLHOPmbLj/GpY4CIissj4VRliu3btcHOP/wBZ60sluPLbdtC7XG7AwMNuGPy5JqeZIdiGRSI3jZm/1TxqpH3QCOfxHf64qbaVmLDIUzrtGOSMYGB/jSmEeY2wBgJMqJZdpyVGfwz/AICneQ0ckwAyEUMWC5LYxxk9P51LlcVrDbYKFg8tgfkTJWQjOG5PHHf3pkURjIjyYxiQKQoycZ455HPr71M0ZChRJjIYADaMBWDADJ9aURDMyPK/yzbQdxO4Ecjpz1/wpc1x2GTKsQfGAHRRvPYnB65xgHPT1psjefJIQjSbizrj5Rzjue/3hke9KsUStCAgb5FBJHBwce57nn/CnGIi3UF2YhGXaGHPbp154/KlzWHYYd6um5wg8wjai4zg859sEfl70sMQgugIlMe4NGFPzE44H1P+NSTIvmM4CgGQHC5BIIxxzUl0o3kFt21M8hRyD3PPUAfWlzMZXkQM6N8zzMjrg5BJ+o6d/TFG6OK1YuAEkYFQq/Mw6DBPPOKsXZCOpQfvSWZI8YyPm5I9MEcU22hcqr9ZnKkg9gPmJ9jk+nantuCItjRxEb9rLKQVTngHofU8+3Q1OY1gvR5SqA8e0OTz1xksev1+tOAXyyoBKsgCbRnHJ6Ec+mTUjM2xMgNlOOo5HIP8/XpwDU8wDgAby3cFssBF8q8juODzj9MGrpikAdozN5cj7pl8sbc8YPTAHOegHIxmqqtlduWVZAh4JBBwDk/gO/HtUizy3tscCGPBA/veWRxkgD8ePTijSwmmXlQqWj3MElcOkwI9eWA6ZP8Ak1BKkcE673C+YvzclT6cYGM/zxToI1nTcyojHjeSSRjHXv8Ah/8AWoaIOgOVilLghipGDjgY796lEobfKzLkqS+PmYArnrjjuevT+dYWpWe9hK5XcMK4UYye3H4etb7yO0czAHDjlSQATx2zx0JzVG6k83CoSQW8xweOfp2rtwl/aJoT2MkWiPOGb/VqPm9+nFZ11bTTXEk8nUg4GPu+ldGiKyFR1J6egz/9alkthsKY47176fY5jD0dWZpGI5UsSD75H+FTw5+YdTjGT/vL/QGtGK1WHzdq4PHTv/nFRw2yrGTjPB49OMf1qlqSylP8mlMDkM5KjH+f9qsrUJViMShgDgk8+rEfyVa6KaHetlH1Uy5I/wCBj+gNclqltLJcF0+7gDj2qhR1I3lBjZcg1Gkw3RHPsfyqCSGReoK+2KjdCMZOORRoa3NUzgbiDk+lOtn/AHgweTnn1rMTcMjB9zipImdTnPNSxbm7bONzjscH86tRt+9H6fkazbV8sCT1GKvxn51+tczeorFyyYEsOoxV62bMh6YIB/n/AI1m2Z/fe2Ku27AMfY4xSRRqg/ujz0BP1qbSGws4PaQ1nRTblOe461NYTCMTk92JrRS1RLWhu6by0sg4JfH4AD/69bET8ccVgafJi2jGeTyePXn+taccwHU1vCVkZyjc0wwPQ4pS/cmqH2gDvg0vn/NWvtDPkLu7B5oJz71T83NSLLmj2guUuLz+dWIxgCqUcmDxVmKQd6qMkS0yyPpShaYr5NPBya2VjMfspdlKh/OnAVohDNntRs4qbHNITimIi25prripHPpUMjikxoYeP603NRs+D1pjyVk2aWGy9c1GOKSSYHpUJl96ybRfKyyhwealDDpWf5/PanedxjNNSQOLL4bikz7/AEql5/vR5/PWq5ieUtO2OtNLZqsJweQfzphlHr3o5kVystF6jLY61AZvfFN88daOZD5SwTyDn8KjLVWM4A60wzjtUuRSiy0WGKQvVI3HcUw3GOtR7QvlLxcEYzSGXHes43QHf9aje7C96nnK9maYkppmC1iy6gq9WqtJqWeFBb8Kn2pXIbzzjjnpUEl2oPJFYRuLmU/Iu2lSymlxvYmpc2x8ttzQm1KNeN1VJL+SQ/uUJ9zU9vpQz0ya0oLADoP0qbSY7xRipb3M5y7EZ7CrttpQ7jNbsNoABkVajhA7dK0jRvuZur2MqLT1Qciq90EjbJZVEfzHJ7f571t3biCEsQTxwAMk1z9w8m19qtLvO1MqF68nPqBXLmFVUqfKuoUryd2VhF5lwRJsPlJnkfMPdV9TxTxIzOxMW52IyMFMrj0Pcc/5NCqwhhYRo0G4/wCsQgs3rk9/09KcjBEV5klEUZO3eAwXIHfqe/NfPpNI6GJMimRd7MrSfeAOAcYx79eKiuNpBkK7ZGJyduTjHTPOOOvX86IlkDB3j3tMvykIAyY79yf0pLkGOWGJ2UMV6sflPYkk8kY+nSptpqHUqBS0m+NychmVc53JjgnGeuTnp/SnRwhfmjZiUPOMHO0cdPU46VYkaIghvl3FQrt8ucevr3z7DrTLqb5WDh97Fshmwx+YD8P64qXZK9yk2ZwiYRlHzuIwFbJH+Sc/h2pdjxyFcHhMgjOemR+oz+VXw4FwzJ0DZOORwBgjt3HPvUMDEtI4kHCK/AORj6dOpqLa6FXKyZeYEMxQfM0gHoQBz/ujn8aYVfyzjIGV4HGPmIHr2q1Ah8qB5ioTIVckkseR/XpTpFlFvufe5YLnBLHAOcZGB/8AX79qdtAuioiBQGkRWZlwCe3zFjkk/wCzQ6MIWZHURsVYKuT1ww5+n54p0MMnkwtIV3Hex2sCc4x39ifQUXEBMjrvcguuzBOEAUD8+KEAyaEBdr79qlzgxhR1yM/nTJFRZpdpDfO+FxuHQDoOnWp5YR58YgO5G3jH88Zo5WRmTLxeW7HBJ5Y5zngVSEQLbny4wJHViFAwDyQ3PH1/Ko3gkEKLJIzM/wAmC2d2Vyfrz/nmrZBCjaOGkKLkN0DA5/nSkHaXcMGDj5S4yPmOMgDp269cUAZ80BOSXcBi5wfm5G3n37U2SJlLFW+USE+WRz83yn0HQg//AKq1ok8yJySWDNsHTAz6+3TiopEyQ6Bn3M+E2ZJ+XHTufr0q9dxplKMFI5FUbogEBwR65DZ9wB+daejxKpgHls4YnDx7eFIPUn19OOlV2jjZZcZUeXHwvdgATj0yT6f/AFrlq32afzWmBhkOwEfKwGcZ7enb+VKNr6hLbQ0wm9AsQRUX5RsOfmHX29K6LS7kzRbZP9avB9/esK0hH2G3MQZBgFl6Fh/ic9e9SxytDJ5sZJZTgj1x2r6TLMb7CaUtmeRjMP7SOm6OooqG1nS4hWSM8Hr7VNX2GktUeGFFKKSgBaKSloAdS0ynUALS0lApgK1NanNTWpANpKcTTaACiiimAUlFIaBC03NBNRSyLGpZjgUbDFkcIpZjgCuf1K6a6kCpxGMkc9SBT7u7a5faoJjXOVHX8fTpVTHSM5c8BlyQBk5656cf/qxXzeZ5omnSpHq4TCP45lO6j2MsmZdsnyEBiCg7844/nkiqd1BHBOYy0qrMnCNw3fb7ge/fnitW+QvamMyEbhhMdGPsB7jJPpVBwTBDhVjHmeUP3eGkYHsTyMY/X618vU966PXhoY8cflSABVyro4G3oMep7Uvkqss5DqxZWI2jOORznHUf0NWpEZo1c4QPEcnbu5HJJxx2689M47U/IM6s7MFd1OCcZJXnvz69Pyrl1R0XIJoWab92g82RcAyHrjABx69/xFMK4MbCQuVQ5C4GcnHBPTNSRsESAKqnb1IU4xuxnJ4zxUhjKrnftJBG1XDP8zHB4HHbpU3DqQFFRWEfC5jbKtyeMZx6e/qabLEHkHmDJaE8OwP1zzip5EZ0beD91lAK8Ahs9c9D+VMmjUoZE8g7VzjqQHI5PH5YqdUBFMIjbkKiKdzjIAz0+vp3qSMs+obgFHmmNlBbHb0/Dv1qx5brJOqBgd5Odo/u9z2/yKYkIKwOxJDBOQvHB7n6ZHtTvoBCpzNbspLqAUOCWz83rjHaiRWVpSGLsu8AZBzznA/I9OlTy7NvmIGO7Y45JPLHHAz1BwD7U6Vj5soAbJjzywJHzd8+mP0oEyGVBJHhjn92Qo2BicHjp/L8aUp8qFhgnaqg4HIyfpkj69amfbu+d9qtI47DHHqKgjjbbEAp85grE7CW5yOPTtTvYFqRRITErcGWRNrNncQG7nPA+6KniI8lWj2oFO4MX4Xg9QPwOevNT2axLHFuBbaucbck9Rg898mmxgRzGNsEKwZexz3578f/AKqNQIY13QjP7wkYxk5fg/w9O+P84ogLSW2cqShGFDEk9unbqKuxqw812dBkliPMzjHB5xn1pscErSbSGCt8rALxj5efXpzSsxpohjVWmMb4AZVYDIIHyjp27e/vSFvJwhZvnUJIu3k8feweTgn/AOtSmMLufKAKMBsAk85/Tr9Kfuj2h3O6Q53jIG88AA4PqDn60ICRneC5ZvmlZmxgg5HqQ2AM+v481ZS5WKNfOLZb5lZOO57+mdx6e1U7ZiYfLlRdibfLypO8cH0BXHT1x35qSEl5hClwo2YZAACDwNuc8n8uPyp67E2EuSotyyZTcuCwHX+8Dx16EfhxVLcA0kjqVY8sCwzk/wD6xVm/JS3If5sv82Rk8d8/8BqCNfPYrGUyTwpOMnv+Wcf0rsoS9muYl66CRlYniZjuLgHI7GrSLmMknPNR+UbkIjZDBmVh0J6DOOxyPypIpTnYcfXI/pXoYTEc3uszkhZPlkI9qaAVU/7oz+tOyDPkE9KdLxAcfSvQjuYyIUUb4D0wpb9D/jWf9j3qWI4OcitcD5W7YjxTfLxGBVMI6GFLY7e2RWdf2CtExHBAyMe1df5O5RkcVVuLQAEY4I70rdjS5yslhhAwGQf0pn2DC5x+VbkUJa3HrtA6dKRoMQjGelK1x6GRHEY2Aq7bjMg475FF4u3affFO08ZnGPWueatIRchixJ06H9KmMbeYcDj1q1BEGcKeMg5NXreDM0oI9KOUL2MyOEqrBvWiHLIy85Pb0rZNqCGA9KqRW4+0umPukfyz/WjkaGpXJoZsYHYYq0s/Qg0qWftU62mO1XZiuhiyn1zmpkkOevFCW57VKtv7U1cWgI5PepoyfWkEXtUqQkmqVydB6OwqxHLjvUIjK07bWiuiHZltJs96nST3rMDFalWXHQ1rGRDiascv5VMJB2rLWXipkmrZTMnE0BIB3ppkzVPzu9Near50LlLMsuB9arTSflULz8VUllJ6fnWcqpaiSyTe9Q+cTVctlueaeoLDArncmaqIM3vUTv3qykHc0pt/aps2VoUGkIHemmUjvVt4AM4FV3t/bNLVDTRH9oxzmj7RxTXgPaozAT7UrsrQebjFNa696j8g9xSG3o5pDsh5uT3NRtdH14pDbMab9jJ5OaV2Gg03WOhyajN2ADk1N9gzTk00dxR7w9Ck19nhcmoWuZG+6prZXTlHapksB2X9KLSY+aJzx+0SdBinJZzyfeY/hXTx2Sjt+lSpagdqpU2xe0RzUWlf3qvRaaqnp+lbgtx0qUQ8VaokOqZcVko7fpVhLYdhV8RjGOlOC9a0VJIzc2QRwAHpUqRge9SEYUUp4HWr5CL3FAp33RzTA3rWbqt/hfKixydrMf5D3qa1aNCDlIFFydkVNRvPOuAF+6D8pBHBHfqMZrMliDny3eaOLbkgZ3PnrjjJ6+nNTASlF/eE4PmBAM59AMfzI/KoI2PMksYKyMNxjYls9vfA56Z6V8nXrSrz5pHdBcq0JJSIgsbEQ7exYAtj0PTJyOf8hsqoiwK5ZJsgrk4Yc/qB059fepd0nmSO27YCTs4w/HU989e1V5lfZGib2kIGYBgcY9TyO3J5/lUtAtWOuAFiO8MG6NkZYsecAevT8qzykRmnjtzK+xSGO7KqcYxuPHGf89avTSAqwiVhgjzlyCT+vfj/AAoigEca7toZULYPJzg/Nk9sgVnJNvQpOy1IECo58vJPmjljwowOfQnn8801IHVVLKn7tSFwOrDBYnI9CatSKcEfPyCMqoJPcZ/E/lTZgwZguVYkvuAyM8HgY6k56etZuLW5VxJFQySh8eSwbAI6jPOeeO3fpSgBSA6ZXC8bDzlSenbPP4VEUmwSu4bjwGP3SfT8PT+tORfLLE5DBcEn6dffOfxoUtdhW0GNLIi5RHkyFxluvUcjsMim8fd37z5ifNg8YXk+gx/Wk8kvIsIZvMzgDGFU5HXrz1obiCbay4cFjnPQnr+GP50uZtFWQ6JWNsrZKZTO1UGVBBySc9yKZO2GjWQ5YliB3A7ck4HQH/Gpo02csn7sMTgLjoFGP/HvfrUAhKSK6r+9Mf32Xqx9CT229qfQOo+4kMcp2lmKhyFEg+nOR0/lxSvFGqzJgbVbauD6KMZ9qS7iGZY2bGUZRvTOSzdcfX2PrzTtrIzFxt+fG7jhQATz29Kq9gsRywxiWLCykozFcDBwP6dKbt2sWZcLvMhXZ2DH8uD+tLKoYZ+XqAFU56gMf8+1TyY+0iNzuUljgEnJO386V7sdivbp8rbjFkOSAwOV5H+H5ZqLafMwrKpWMr86k7ckZP8APir0cjLHlxuO0qAN2U5+7+Z9qbC5eXaSuxiHJEmA2SDj+XNHZB5laePEE6sGVXKhUAJAPUjb9NoPFWc+W6bCTtDAZGd43cjAUY5A4JPQ1BJuMmFb94GARFOAOCAfpwPSryRNLdKGbzIVHmNkDLHOc8Hrkn64q1rsJ+ZqxoYYo8nzY8BCVOPmxzyeOoBp0mVwSVLsCHI4Ax9Djv8A5yarzL5cyooTDHjzDg4z2/Hp+I9KsRhmWQSMO5X/AGj3579e/Nd8ZLY5WupJZXBtZyeTGx+cdcH1rfVg6gqcg9MVzgz5ZBZeQCTn1Pft7VPpl4bebyZG3RE4Deh9K+lynMLpUany/wAjycZhre/H5m7RRRX0B5gUUUUALTqbSimA6ikpaAA0lDUhpANooopgFFJRQIKbmjNNJwM9qBjJpFiQs5wBWBe3ZuZB18voBjI9s0arfedMFXmIHAA/iPpVeMtCv7tGZ1kx02jPT156183muZW/dU36nq4PC/bkO8tpCFYSsVbaQMKD16/h7+lSOxfDRrtXbtVs8BfUj9O5/WmuwChFKkn77YK/UfUkdM06Ty3Cucg7wrSYxu9gfx/wr5q56thiHa2UIcA8NnnGPy+g9ayZ0WC/kWFysRZSTtzgluRnGM5BOfrWkqHcPLYEEAg9yB6DHA5wCOvvUN0n2i3WIu8ZbnK7cKcEbcYJOPYflWcryRcdGZPlIvmReZvMcmUBboMYIJPHHOfpTo1jMyxeaWJVSdgwc46E9O/OfSnmT7SrSbYo4QrxvGHD898nPQnA79Call+XMQALRM/U59+cdOhP4VztamxFtaW3yeCAH2Btx4659wT07VJtaRCFDLE4bJCgAcBsce+ev5U8L5qbn+aGRic5wqdOCPTk02Nf3IkZQz5Ut8uFyeMjPt1wKWiFcriOMMVUKvzIw/d4P3fmx6D8KdscKoLsMxkAvIMDk9h7fpVqPbHdbi7SEpg/vOW7fT8/yzVc24iVRtJkCiTcQpAAPKk9QKhrQd9RiofMhJLIWLBsqFJxjrn24/I1FGgjjhLsJJUJz+8DbcAg+3pVpojHIQAF/eDKrkexznjHQ/T6UjoyQsTISDuB/eBurdeBzjH4VIEJtQITHMdzAjaXBJyFBAwKdcQx+dgsMEOD1xtBHOP6mnSKpkkyQGbcxDOUC845wT/k0/8A1SMTtLbTgqmCR0z6nkflT6BqQyKoYuUCyF1kwOoB7eg/SiOAiTbhXVVYE7CQedwPPpVol1kZ4zjLgfMSD1wOvfA/+vxTPmMalsMPLwEG4k/y44P5UWQXF+TzFZwQrMCoxjGBz39z+ApJP9ZHLiUMF+Yj7xPAGcDjpntx9ackJDSKAPkBZDsAwowevboPfFDSok25SDvc4DscH+nAx+dV01ENDO8kmxFySVUAcKem0fpxx2qHf0PzBlUOzM2OB34Hr6/h2qaQRrPuZS/lndz2HUkn0z6+opItgVhkANJ83AA+vA59Mfn0pO41YJCX3vIcKfmY7sqoP/6jyKhJAkUGIbgw3cg5yMnOOOx4qSKFY4mTKCVXwSyDIA9R7fj0pzwxBifMXy2UIuDgjOMZwOPyqWmwTQlxAGjBBDSKdwLknOeNvt3B/WoYmjkdpCiyKrAquwhuo4yOgGcVZkfykCujbtoGCRnBGcDpnrjt+tVuVX7oCquXjAxg8dPy6VrBczsTfQi1A4mhUKpJOWIAXP6VOWYRkRrtkQ4DOwAJ5P0zyMCq9sjzXUrIGIyU2g/N6H379OKdIq5VYy525kAYcKPr1zwenpWtV291CiriQ4VS8SO/AUr2ye4A9Oev5UTBY4Ys7dxJ2vkDPJz/AD9v0qyXmeUyKBJGxDIpZeOBlvU45qArFFMJgd524U45HPzHnH4f/WqacuWSaHuJbMZGLAY3rx9DippRkAdjlh/OmRHM5JAByeFOQPxpVbc2D6Y+g/ya+ioz5o3OWRPGMo+MdcCpI0ORjsOaQKQox6k1YjU8Y449a6EAGPCgD61HLGChP5Yq2FyuBwfSmOmVIPFUBiWsY2MOuJCP1qO9iwvHerkKYmuU9H3fmBSXKgoT6GpQXOb1Q7Y156vT7EbbsDjqDUOt8Nbrjq4q3bLm+hPqP/r1hUXvFLY6G1X96pPrWlYx5LtnnAqhAMYYDitW1XbB/vGrhuTIljjyc/lVfT4fNurtz/z02/kMVfTCpk9AueadoMObESN1kct+ta8t5JEc1k2TR22BTxAAeKvpHx+lLs9ua09kZ85R8kZpfJq95X4UCP2o9mHOU0gqxHEB261MiVKqVSpiciu0QI9ahkix0rR2cVBImOuKqVMSkZzpUe3HFXmj9KjeKsXFo05irkjp0pd+OtS+WRTTHntS1HdDTN+VNMn50/y/ajy8GjUWhCzFvxqIgvVwRZPNPSP2o5Wx3RUjh55FW4osipY4gKsRpmqjAlyGJCAOaUxDHFWAhxSlODxXQoKxnzFCSLNQvFnPFaLR/rUZiGahwGpGYYfSmmDH+NaOymeX/kVHsy+YofZ8nJ/Sk+z1oeX2/Wjy/Tr9KPZBzGf5A6YxSi29a0PLFGzNP2QucpCADtT1gFWwmKkCYqlSQuYqCADtTxF6CrO3HQ/WjH8ulXyIXMQ+WMdKXZjtmpRjvSZ61XIhXI9nTNIRjtSlsH69aazf/qpBqB4H403POKYx7E1G79cUiiTeN3NMLZ69KiJ+X9aguLgIuBy3YVM5KCuykiS7u/LQhD82PyHrWL+8ly6l87dwUNy7DuM8D6/lTZZS4DEZcsQDwQeOR+H9KjMQLqkQlE2Nw69SDgn0r5vGYp1p2Wy/r7zphCyEQ7NxuMruYNubhwCOu4Dt7/0qwZxGrO0mYRkqABlvpxx1+uaTzpoo3yy+YOMqPXP5ngVD5auypIFBz8zhSxIwTyB069PXPUVwXUdEabkLSBi0aA7upDEgZxnLZ6/pUssZhj2hmbLkRbicE+uO+MZOcYx0qQeWC0fKRKCSSO4OWAJ9Nvv9Kjj3Tz5DYV87DnLAepHPUY6jpipsURlJLa2jTOc5/eAsWJ7/AF7nmnRyOzOowAegztxn7vB69vyNPiRFkWR4XDKwC7OTuBHcDOOvX0p/yiIkhVG5jjIw3y9sfUf/AF6VpXuGhBKrTeZliYxuVenJx/gP/r0CKMSZMjPyXYNweBjA6YOf5e1KsSrtYkNuI+Xancd8/jUyRAXG8PjGCzIQMdBjGcdB/Oo16juhmZJm3Kc/MAh4K8cEn0OffPBpdoljKtzF5bOVDZA69ePTjPTio5FQyqqYdSxGw/NuPXPHHrx24q3dNk79pLY+TJ+9kZPfphuntVpXWonoVo0wzIY8yEE4H3cnOBx14yO9LNIqKRtLZKqMnK9x3/M4qaGVOpZwWxyTjcDgE5H9PXrQMuyuFZVRfl3AN057Hjv+XrT05dAvrqQRAeWpljw2NpDEHnJzwPbPUdfpThiN1EpKjcqh8Elh7d+/v+tStBuDjbuy/JzkZB7EfhyOOtR+SiJNHbIyZZsALnaAPy549cY7UuWw7jY2/exAI/ygr8rbtxHQH6cjn0qNI2kXD5O5iQucdMgdTnJ6/galEat8qM7My44JwCQAc89MY9OntSh8otv5IVQcDPA64PbB6frS30YehEYh5pkXJy5cAjqeenbt1x0p6K7XAlJRhkKACTkE8cnpUp3l4y4Cn72wkn05yOuAPfpT5JnXl1Pl5OFzkDpzzxjk8+h6U1BBdlWSI7dsgAXd25JY8bv0zQuUklkjQ5diCcbVJwME9fy/lTj5qwsy8hwQxcdD1xj0AGfYetDq7TYklVdxPljH3R7+n0z680rK9w16lfDQExuVRd/AC4LYz1P4Ht+lXtMijhuC8bsUmIUFhyR16nqOvXHQc1XlQuq/IzQv8yqB8zgnPPA55HPpV6KFv3r+YGbG1cjAbngtnOOvWtKS1uKWxLboDMJIXZQRwxOcAEce/wBD+dPjA24KglgWAYZY8+v0qEuBz5iiVud5GWBHXcR+XGKkMURkUspRowCADypyQOn0789K6b9EYkkjgPk7sAfKD1HT8OPWmyguCXYKpG4jrgZ4Oc1Ljf5jKRhhuwVGMdB/U/nUXmgOC7ZZgMYbocdPzOa2jzRs7kaPQ1dKuvNQxSf61P1FaNcuJWt5Y5xu4A3ZOeK6SNxJGHU5DDIr7TLsV9YpXe63PBxNH2c9NmPzS0lJ1ruOYdRRRTAfQtNp2aBBTac1NNIYlFFJTAKaTRSNQICaytZuyi+ShwzdfYVoTSCKJnY4AGa44zNdagZH28HqTwB278fjXnZli/q1LTdnXhaHtZ67Ico3Mg6ZALjcVVR6kj/9XIq/tZBldypGcfu1Aye/J7darRqVLbN3y5JUqMY4+Usc9z/nrU8e0nMgPqS6ZY5HQ8cdM/gM18VN3d2e/siSQAwkONyt/CMnI7fy57c1A4fadzfu9xBcnsPUd/x/XGKQGSRhIxHLbAOpYkdx69PwBNLc/eSEhxKxBY9enAIHTPfIrGXcpaaBN95WDhW++FyAqjA6nBwR1qJI4zHtZCwOVy67XY5HuOM8547U7biRZYyxAAARTnB4Ix7dskdjTJhIZYoWP7zjLZ445AA7Zxntx+dQ2rFK/Qz3AtZIztZVbl2Ee0BhtO49Opz+HrUgXy1RpQdrcqSSxwFAweeeWPHXNT3PlxMryMRN1YDBJPTPJ5z1wfYcCmzOPMyu58OVZnyPYenB/qetYyNEyKMuZJYgGJLAp0ywB6/XGOfenwosobc7vGE5OFPAweTz0ycetSTCOa6DMQVAGX5XHXoSR7jn6dqEUN5oC7Dgt8uFCjHTOPp04FSkr2C4xoyJYDIg80nlBEMnOOcZ6857VM6HZIw3AFsMFI2nOML7dc/Xvk1BLbxnaTlvLJJIUnJzkbj2444x/i5It0gUhjtfaCOMD0I+i/55oTSYDpQzQHzN3GCMoRzuznuT3xTNh3SKBnkgERjPIzjPQc9feljg2RFXVgOihugyOOAf1PvTiqo6MrEEjDM/BHQDqOvJ6Ub6gQYSPa4woKlmXbt5wOSew/z2pWOxmZyy7mODvwzZI7njGCaeIEj2hCWxxx0x83Oe4x/WiS3jaERksCxB5BB+7nGOv0P1qdUPQTzABJsPKuNwXByMdcnnpjn3qGKYnbmReVy25ifmIPGMe3T61YkgRk3FDtIwygAHk/XPT+XvSYQswVMR7gxbOEjHGPzznHv3p6i0KsZdLwMN5J2/I3J4HTPTt+nah4GYp8zHC5UkFQw7gZzn+tWY9xdUCgFRgsSWIGc4zj64571JNhC/mAoGO9fmJIHT3xkemaFG6uPm1K8gImkZ+N4wVCqxJzjv34HsKjEZWP5wQx+UuFA7D8z7j3qyAQzqvmrtUEY7kgd8ccn9earxb2hjCKeq5BzweOp6DjHT8qTWgIZN8mSzMybvmwCQvIxx9c0NKE3BywkWT5nbO4/N06Y6N+HrUsT78ITEw2AMxJO7pgd/b86ijWSSSNTg4UKpIz3HOPxpegyOWXAhjlZQrH5ssMjjhjjAyP8A9dRA/uQPL3YBOCBwcdv5enX6VK0PlT/K6gKQ49O5wQPbj2681WmjH2f5cAysByM8Z9/p9K3w8Xz3ZM3oI4dVDHc8fAdVznp97t0IP+RVlyscaywyqGbIJAyoxyccYU+9VLph53AXLNjBHzFQM7cA8dG7dverEMiuGt9gEa4PzHaUIwSPf86dZa3COwsoWQjywYzgEhwTj6L/AHevp1p8zCRIo3TbBF2U4JJHb/OKhkn/AHjP5q7DmPJYs75Pb19uTShY4zsi3dSpVs4C88An/wDXnHeojuN7EmXD5YAHJyPQ46UyMgSfLycAH86RP4cDjcMZ98f4U6Mgz5Gcdfwr26ErI5pGhF8wGD0z/Or0a5HT9KyIJcPnsAAT0wa3LUAgemK76NRTWhnLQBHzz6U1kwcn/wDXVzZgD9KbKmV471s0SmYQTbqM4I6xqf5io5kIhYdc1flQDU8jjMR/mKguU/dk+1SM4rXTi+sl9XJx9BWlYrvvofTBrM1znWLEZ5BYn8q19OB+0AjsP6Vzz1kaR2NyDg/Q/wBK1oV4jwazLdcyAZrWthl8+la0kRIdfsUspdvUjaB6k1t2UAgtoov7igVjkedfWcWON+9vwH+OK3wfzzXRSV5N/Ixm9EhwXn6elSbaF6U/H5V0WMbjNopdtSAUuKVh3IwPzp4FOApQKdguJjjFNkWpMY//AF0hGaAuVinpURj7VbKimFfSpaGmVStNMdWitNK569ajlKuVfL/nRsx0qxsHrTsY7Uco7lby89RUgjHepgvQCnBf50+VCuRBKmVeBijbUgB7VaRLYgHFBWnYNBHtVkkRHcU0r6VMRzTCPTrSsO5EU96QrUpHrSYpWHch2+1Jt9s1N9aCD2p2Ah29hT9vIp2PXilx+dOwhmO9IPTvTv8AOaaeetACdKT2pSfzphNIYjNjio5G5AB5pSSabj161JSG7jmo2bHHc0/uT0pmPWgoa/FRE4OakfpVO5uAnCctjoKyqTjTV5Mpahc3CxdTzWXJukkGQWDDcGUhceoJ9OOlRTuJvLLbmOQ3MZ+X16c4pssaIv8ArJkkdgzMQfl45HTg47d/1r53F42VWVlsdMKdhYlM0pe4IQ7yP3qZ4B6D0/n1qSVzCWzG7AkbArHBBGB0/LH500xNPIqzglVGGcevBB3fQ5HTqaro7IyiLc0khK7guCeeBg9eM8+5rzuZJaGlriPErRkPG+YvlDBPvYznap79RuqTbE0mYY3lDEkIgKFCMdORjHpn0pk0TRRwkSI45Bj3BB1PRuMYz/OnSs13clIz5YY/Pv8Av4BxgD3weM/l3m1iiBrhbktEVVYg4YIcfMw57n7pH8iTU3D3HzFoSyD5GwMjoR9ff6VYjWNpV8xN6r+7OF6H6k+ntxmmlQIl8sMwABYk5ycYwD3OMfjQ4yYXRFvk84ERqpzxvzwOmMcnpjpTrpNpVOkeNpYvkjnOPzH+c1LOf30Qc7zuJJcfmQCeOp609mUTLKzZKnaJNoIx375Pb8qLO1guVgFCFQm0bsLlSvGTjPr0PHXOKljMRVgQHYAhNiD6ZAxzyMU+LfEo3Rs02zH3ScNxgAZP+ANRxREABk2q7hlO3g/7xyeQM9u1O1gumSEwiQMGyc7jKBgLx9D/AC9ajk2mSJpCEyuQC2d3OCB1z361ZmLcSFSCo5DMMDnk4/HpxwT71WkYPJ9nMqsz/N5irgA5AznknH+cZ5JJgmEKxrAVi/1e75QgBJxjbz154NLHHGnlxW4JDYLPub5R6evf/JqSTaxUh3JUBtznABB6cfp/WpMy/M5K+WGJBYkccHp655xx+tCiFyEl2lMTshHJbDEYXnIx3J/maAkyqoZSVVd2CPmOAQPq3+NOw0bkDcowEJA+/knkf59+9NkSUsrI5IGQdxKL6gD6Y7nH1pWQ9R+9gGYBNjOdpDnGTyAB36dBmpI4wAvmYBByp4G/H3j6nOf58U1pNsrSOwADZ24xu6DIJ7cdPr6Go3DxsArkrjc5c9D1OB1Jz26YPIqrrcmxKjAbfLyFKlVx6dj9OP0qGE+dhifNyQdyActyeSOv0Ge1SSQRFPJSQhcggEnoVAPsSfQU91kMATrgnDHrx1OD6g0bhsRlJAzsGIAyMFgcZPc98UzarptEhbcDvDtkPlccgcdux6Dk+iugKEMzFth6ArtG3qx6H6fWpRGwULHgZJ2qTz+WDtHOfy9qAKpLPcReQpkYjlW+U9R0PQHp/OrTkGU85XIba44LEjJx9Qc96dbp5PllxEoZiWLL9/8ATOP88UiN+9KlsBFKhckNnAHXt371cU0hN3YuyRpvNuFT5SFwVyOv4dx16c1JM+0lI5C7NKSGJ+7wM+4/pURQvcyYBU8vhxnae3tnjp070HHlMxEeWKuVLcDdgqcnrgDPHbHpWuquQToWePZJuPJH3uuOvoT+H4UrFFUKYwq7sHI5J7n8qbt37fMxGFXICdR0GAf+A/4imxyfu8yfuwxwcnq3TI7Doc/5zqn1ZNuxHIrAEvjZgklcjI7Dj6f/AFua1fDtx5lu0R6xnA+nasyVxvUgbMYUEYxj69/6fnTdKuPK1deoSUbQSSc+nJr18pr+zrKL2ehxY2lzU79jq6dTaK+uPDHUtJS0xBS0CigBTTDS0UhjTSUZpKYC5ppNBphOKBGH4ovPKiWBCCz8lSeorDtpPN8tUDeeMhfl7Z54PWo9Zuzcau3zKADtQ55454HfoanhCyGOV4zjvKwBVeuQDnivjc2rurWaXTQ9/A0uSnd9SQH5VVpGUj94c4XJ9c4I9PUnFWgBGCGODvK4IKqPlPA7d/xxUXnL5W9Y+FyyqMbQvQg+nQEj3706JlcK2S/RQdpB67jknrgf5GRXjM7RXkUBmz8p6k8MqjAPXGO3/fVEYxzJJtJ/1gQfdBIGAMd8Hn6Ui5LbfuouUMmN345yOcDOfbr0qQ/6xTD977wPcHGAcD2we3fvzU63HpYjcfNI0jbtvLDHVsAenGMqOuOtNkMixszjLD7zg5G4jnJ9hjnOM4xSybtkQyPuhuV5246D68du3emy4B+dokckOcgDaew6D3/JfSod9ykJFEvmKwIId9yFxl/YYI5OOc9Bg0+OIxYKKqorYwCcjnGfQnHp71HLvVdqgqjModlbb2HbPfcOfU8U23Pko0kbMd33mAA2jocZA4Ge/wCHAqdEPVg6sXUKFQjlgp+9jqcdsYPUjnNWjgBgzKdyswUyYz7YPbgHqegB9mGFWkLqrSI2MhWAz6cdOoOeP608ptZt7MOTk5CKzYHQj0HpTUbCvcimCNGGuM4OAGAI35+g4HXoegHSkA86Bd3zb1Chwm7r1xkjgDv+lPws2CWZjjaWz8oA6njtkY59/wAWr5rxH7QkWUOO4wehGPf696h2YyL70jHaq+YA5LDZg+hJHQkdh79akYnytiEkyAEFSzH73bP+eg9qHEyyNKilyW64IyT0xnA4298+tKS2+UnGCSy5kZVHYZHX14/KkMRSXjLt8wfBKlehII5b069+M9Ogpc7x+8WUqAFcGPBPHOfXO7p7U2QNGCjNhARjLkDjGcD0BxjHrS+UqP8AeXEe5QWThMdyB7EE59qeoETvKLwKCmxjtUFs7gMenengRJdq/wArtnaCVPcDGT657fSnuAECuGGI+FKj5QMZHA9z+YNNuAVUyb0Ys5BbGOuO5HqCfc9zSs+oDZoN8XAcneGbc2GbPPTnB68f1ApgCxovygYcbmPykAccE/icip+schjDAFgQQwCge47cfy9aQIqxx7WycDYvU7iCc9M8Z/Wm11QrleQxx/63DsxOeCdg288469ee9OClZ4xKfmHyooTJ25xuyTx6+2KklijKBlLM5bcrLjJ2jGePw+tRFDKrFXJjJOcfwqcEg556Y9/Woas9R3EwBgsv7t8NjPXORkjoM1F5p8/dghWUBtw5Pbpn1B/LrQ8CqrZTzGcDlgSAMdPQ4IPT6UlwpiLBEkZVZcAJyx9Pf2GO3WldrYrRlaRTGjYOTgBuOVOSATxgcZqHHm3CgHbsBfjnB6c//rqzcMFiCBt0Sudueh+bsOfTH4VFFgyzOnABwpwCNwxz7fl+dbU3ypsmWrsQZwRuj3QgnbjGS27IIPfgH8hxSKrKwSNSf3gP3MY4AAAxwScdexqxCA0Y3FhkgKCe+3j/ADmo4IP3IicsNyr8pwMfNjj/ADx+FTzX3LQ/cLnZsIUMCzrsBOcdfpxiow2YV+bbJjeBno24k/8A6hUUsBdoQiqYFwochvkxnsMcjr1zmlkmZraGRywMrEbC3cZx+n8zVU0nJIT0Q7O2GPGRub86mztkZj2x+GKhABeEA/xZ/KpSfLEhUg4yAO5+n616z9yFzm3Y+OTaWjMbtkZzg4Az/Lj05zWnpzyQRRvKG+bgr/d/w7VnxQgoFBdhG28sxC4UZwCcZJ56ZxzVmLBlVZukXYA4fvn6YNebSrypzumauKaOjjYOuRzmlKgqfWsOxuHWQ4yRtzsHJPP6cZrVtrlZVyvHqDX0OGxca8ezOWUHEq3S4voz6ow/lVW4GYz9OlW705u4D7MP0qrMdsfHpW/US2OD1N/M8QW/sSoP/ASa6DTFzJuP8IwT+Vc5KS2sW0h6NI5+o2kV1mmJiMt144/SuW92bbI0bVcPnFadsAAPbrVC0HzDnoOa0EOyJnPGBmuiFlEyluWNLUyXk8390CNf5n+lbUfPSszTozFaqG+8fmb6mtOLpXRSVomMtWTqc9R/9animJj6VIDzx1rcyHfrSjv3+tJ9KX60CF+lL0+tIPypQeuOKYDh+XNNI4p2fWm57mgAI5puPSnduKQilYBmPSkI49Kf+lBpWKI9voKTaPpzUh9aTANAxMdKXGaUD8qXGe+KBCDpxS0Y9DS0xA1IT+tL07Z+tGaoQhHvSD26A0p9+tNoGB5pmM9qfTT6D0oAbmj6Uuf5U3p0pDAf1oNHej3oAQ+3Apv04pT70h5+lADDzTSM8Cnn9ab/AEpDGMOgphGB+PapOlIelAyIr0/Wo5OBntT5ZFRcsQKxb7UGLKIhuBPIGST+XTvXNiMTToq8maRi5bEt5dj5ljILKpJ4zj61ls28xM4mHc4ABHTq3TBpjxqWjkuY8j+B4mwW9sDvj19PXiiSZyoxtGMqsiqFwO4IJ5HvXzeJxUq7u9jrjFRHbBLcDc24gYWVHHOOqkZ5HH0/lUZCxqXCrNFvG1lXaQR39ccfzFF9IE224txswN28/Kfbjv8ATk+lMhf7MPMWIscE/Op+U5ycA4OBwCf/ANVcUmrmi1Q0pHIPL2+XAOWmK/MxHJAB69e3TB6VMsYEBR1kMSsRg8sOgwD2yc98nFNjcxRK8W6RduHjU5Zf/rc9O34VGjm4H+jsDbocfN1fvtySCBnjJ9/elyqwaj7FJL25jaN826NleAS+MH6kemfX60+VmS4uMPhkXqCQVAB6egyP5VJG/Ty0LKylkAJ+7nPHYducdetQJGrCMNGGAKuWABG3PPfPNVKySSEtwedGcsylfnBZmQDaV7AH2/rTbgb/AC1d281stncOeOw9KnhtwkSqeowFLLnIPBwMcdAPwpQkLXEcm395j5BkZHTByDUvmasVomQSbSyOfvK2QTkZ68D/ACM0/e5aQBpS5b+73HOScYGAPyxzUsiLKgZFUqxL8HdjqfpnFP24UMSg4ICliThiR+H9Md6XK7hdFeOF1mJKnAyu5tx3H1PtwBxU00nkyKAjbicOT2/2PYc4xUsingSfMEAJ4wAA2PT0PX2NMDsbzd82FK52gck498A4zx2GaqzjoK9xtypEyq6qVIJYljyeO/c5IGf/ANdK0iiQ79wYBtsjA88559M4H0GaWVysqsHYyAYAC5LHjPsB0Gf5U07FkZFZmkckqy5KtnjJ7Y+7n6fhSvqNbEu7LONrYwzMp3Lu5BIIx3+XgfSlaQeYsmG+Vd24Nnue/YHnkdh61CVEsLCQ7S3A7Ak+/J9D27U6FYxBF8q7m+8+zGQQe/8ATnt+LUmKyHRuJHwhLR8lc5yBzyTjpzwPelkSQQCMj95n5lTcvQdfbPA/qaYi71ZQuMNtAflRgjr2Y9fU8EUH5ZGSJTuJOCM5JB/Inpz0z+VF9AJQhiXa6IjZGSuBnGepA6j5ePU/Sptoz5ncsZNuMfMDxg9j7HsKrpGW8rD8YBAf0znsORk46/XrTjGTkfNukBZVYjPpyep4I/EfjVqwmOwpViCZct0jOCAQMEH8M/44FEkm9WLFvKC4LKCMnAOD+Hrmjc0m8M8jEE48zkDnGenOM/Tmki3pGyv8sgOxpJG3DOenPX8OKq62QrDVzHC4C4B3M3mYC7uTwvpjOfSnM3lQs8nAjHB3ZBPYZ/Dt3P1p7fKyDlTkMIy3HTknB6cHHamXEIdg8jHCg7XPBOO+c8ZGfTORjFFrPQLogiR41lbmQycj5STt65cg4zjH8qklRdjBf3XlsWEjnG7rnOOO5446U/PAdR5j7M9iuTxtHoM4Oc9jzTYyuFY4MYKgFRu3AAj5cdOMdBTtZBfUawAGRncRnLfLyQQB29P51IZmDFxhVJbG8YwjEevPccVBGPKiUqFDKu1eoYHhsY57dh/+qY4cH7pclsEDuQoz+A/LFEWDQgRmhK7yXZA7LwSCeOv5dePlo2Dc21Mcq2R3GMDntntyfpTJWG5gfmzknepGSScjHbgde2aZcyM2fILODIc7QDk4Ugjp649ODVNpC1Y6UL5khk2bFI3FcnBHOP0PT3qlcNJF5cp4KNkDnjk/l2q1LIQ0pBOUUhAeSOnbvy2OKoyxk7izFlJO3OR+BPTv+FdOHnyzTRlUjeNju7eQSwpIvRlBFS1leHZfN0mDJ5UbfyrUzX30Jc0VLufMzVnYWlFNpc1oSPopuaUGgANIaDTSaQwzSZozTCaYhSaqajOLeymkP8KmrJNYPjCcxabsUjLnHJrOtPkg5di6ceaSRy0JYy7iHYZyVQ4x6Hkdc1oQoRIy5wWHzowIKt0x14H14rJslaCTIjZouWZMA7Wzxjv79+1acL7F+eQccoGycnkKPl9OOO3Wvga7vJs+npqysidIphFM0khMoAJAbjPHccgDp17U6NZI4xuxkNx95mbHQn2x/Q0yGf8AeMHYuU2gbSee3bI5IH5g9qctw7wISVdUCfLESATzxnkHjjn161yWRpqSFnMm3aM7mRCHG3jjA4xgD86eM7cea5DEMpIwAOuffp+dRLL5jo7SK7BQcoCwXJI4wB69f508TeTuYLkrhQqnI4xkf+Onr0H1qfNgLtcSq6syRjOwScAnPAx+Q9eetIBLHMgWPMoj/d4bHf5fr2yPT8ab5q+WOd0kY2sqvjBCk9OnUjjp27U8zLACTzIxYbsBQxIDdccgA/kD68Csuo9SMuTIFRMw8qFX5iTyDz3PrzgZ602Fg7hUkQuCMHcCEyuD6k5+bjI71DdKhXaFO9RlkJ+6VB7E9ePT9MCpdmJZI9yyJ/y03bfkwSdvTnv+oqdyuhP5cbv+7SUbDlmIZc4PG7jHP4dutTKojJZREyFGAkRB/d+Y57enp16VWt51e1jkdPM2qqo4diOc+vQ9e/rmpI2a5wxDeb94sQUPJGQeMH2xn/FuyJ1J1IHlykDaAcYLbWx0KgZ65Ix+fWoN0hAXsCrfIMdeMjPAHXnr2xTw6GYMXkEitu3dSijPHv3HJ6557U5zm4BlQGULtVUHzLnoe2O/tS0GKqv1jfzAHO3AHy5xzz7ng9eDUKkDdGpQRhgVYEAkdc9fQ8+nHvTgN0hfYMsxKgYxkn+FsdhjnnGcA1JIsj5Yl1w+RtAYLgZHzD8R9aJagmMYuLgFTN9xmcDHGeefTGO4+nrTMFsxgEqrMCfvAcY4bPPFAUuANxDcLjaPkPPtwOM+vA/BskK+YBGpCsNw8wt8nUjnHXnGDUXuOwjozSl183YxKlG689D2x1NE480hXmfheedvzcj1478E1OqmWQ/NuAO4c4A4GCOxyAenNMCMrfJICAu0MRkqpOOvToR09eh7NrQQ1I8Yd0/1g+YMAuT9AR6dSOxpJWAY+c581vnZUyWGck+nqPypdiyfKc434AznPHQHGOg6j8+lRhiZiuEiCqVBIOO/OBwRkHuaEktAEcoP7q8kCQLhSu7HQdfx9KWR2G0wqwJyQrbs7TwDg9Px/nikAdpAxIU4C7yASW645PT6etEix+dKjDA3l9mCS3B9AABnrxioGEvloQnzYAA2KSWAGcnP/AqiuHDRqzKVOQGYMNuPl7ew4wfSpD5rIA/yrhThWyDgE46YwOnGfpRLlpBnMsfA+UDaAD0OfoATTV2LYpXUaKFMhKnfnnoRk/4Hp6CljSNfZ1GNqqMk+nv2/TpT70Yh3KhJ83IwBhuevTP8vxpsXEJKYYbjsVW7HHBHPt7eladA6kcaAwGMEMxbG4NgkgE9c9/8+5xC2VyIiAyjtnd0A6DkCpoo1P8ArGcorjliORjPXr61Xa1RfmIJVzuII+UgMM/hx09+9YO6ZWjIb9FkjeKKLeyYVRjIPUHPrgj2Hy96hiZHhhYL8iOQpZe2G5z68dP51ZmURzFdyqwTy1w4yoHXr9R9cCq8lslvDFGFVSrMMA5xz09sV0YXWogl8I+FS0gOACFz/L/GhxkhNwDPwuM5Lde35enNPJwWKj+6vH5/4U2O48q6i3P5YY7QzggAg/XuGPNd2LdoWMYassWxzZkWzNHIGKsN3OM4PH4Z96tEBo1iKsIduCSMYyRyfQ4HSmeRuuAGjmiwCobO3vyD68n6jrUkLo53EH9428qFKY6DOfp39q8pXsasWUNDGJI1XzZOXCnpwDnHryenvTIhIkcKv+6ZSSdrbsKenQ9c8Ae9OlH+kBPP2sR8rLyffA5wOaayLHGxlHluygAcgJ8uOxwOpP41aq8r0FuPe/jNwm4/u4yVMh6EkcUmqyhLOVx/dNUxCiW9v9oJSR5wB0AIAxn8+Pbt3rE1e6dLOSIFgsmMbu1evQxsmuWfUzdNX0KiRbrzTxjkKWb8SP8AGuvsQFtowRyV5/SuYtcTXxK9FjCr/wB9KK6xR+7yD24x/n6V1wtcll6yXKg8c+9XHUN5UXUMwB+g5P8ALFV7BMAZ7DNXrZd0zP2UbR9ep/pXUtrGMi/HVyMfzqrH1GPxq0nTiulGLJh/9enj0qMHj3pwNaEkoODz+VGfT8ajz+YpQadxWJPpS7qZSZ9u9O4iTP4UZ/Cm9KM5PNFwsP8Ax5pP0pM0bqAHH9KTkdaT6UufpSGHb2o/X+lGaCc9OKBB+OcUv1pM+lGeaYC/hRTeB9KPpQA7NJnNJmjNMBfwppI60H/PNJn0oGKab+gpST+tJRcBD6Umfaj/ADzSZpXGHakpaTOOnr0pgHX6U09vWlNJnHSgBp4pppWbtVW7vIraMtIwArOpUjBXk7IaTexOx49qoXuoRwg4O45AwKz77U5Du8sHEZ5QH5mxjj+dZMhZlPBI3AHcuE5/Hr0/A9K8fFZpb3aP3nTToX1kWLq8e6jIyAdxUHsD6Y6nr7VWLFmBkdgB91NxB9eTjAA9/TmnMguWQ7BlPlLkbue6lT06/h6esjOmzCxkEH93Ge+M5x6e/pn3FeHOc6j5pM6NFoiO4JiIjC+cxHzLn956YBHp1HP50NcookB3Pt+Ty8fNgjnJ+nHY+9QShLhwwkaGXzRkhc49icYHXv8AiOKkDO8bJHhD96RpOQSB6Djp+H61Db6DsJDCkMj/AGeOWWRmIMbJ8u3kYBIHTPQnH1pyzmSRZZWMSnKKhXLA+xz1B/l3ApN0cEBNwgWNTjcTlVyeNvc4x16fXmmEzXjOp3Ro+Nx6l+/A7YGADwevHrOqHuRTEzyNE5YZPzE/3fQZ6Ecg54p0kgR0RFCybCOCFDYGBj14/X6VZCxmSMdQuEXeAOc9eR7+nf1zQ8cckitMibCoVSTkt+fbBx/Wp5WVdEMaq1wql38vhlLnofQnvwMfj2pyRzM20qPvEhiTnHHY9f5H882CDIoUbDIQAQDuCjP/ANf9KTcSwO1SAwJZYyVAz26+vr37Yp8uoXHzqwU4JOWB+cEbsnKnjAxkg1Cdzs3CrjK7WbJOTncenr655FWhwjFs7WGNu0qQCScdfX3HGOvdJlcsrgsOckMoTJ9M555yfw+laNEJjbpRuhLyZHUnORkkdz/j26VIreXJsXO0nhVfORgdOBn1z7+tQSoYGEpdvvbVyc8Z6knPHI9P1qS2UCNt8pywI4ZSznj0BPpTUmmFtCFAHvSVBJz8w64IPQcjoMe1S7UiuhIrMGySxIPIJ6dPfrwKftCt+8zE6glpNoGOSOo47g4OOlMBZGkcKpXecp5m0JnB57evHbFTtuV6AqltwOQqvgjceMc4x64/LmkgZmDXDOrkJx8uQoxn8OhPP69Kd5cqEIAhwoBcqAw5IJyRgDOfqDTo98SbNxIVgV2gvgDHfA9PUdaSvcBZBtt5U2lgflIKkktzzjHGfl5OP5UnmkZySZOgG1lABORk9xnJBz6024IRcT7o4mk27lUDy+gz365HPX2FSHOIk2xxADKA/wAZwMkDjJwe/wClO2oug1kOZEznO1nTHHXnJxjuenGByMGhIUuPK8yP5FyNrDcfwGTge/f17VIrlCwUKTkgN1J5GT9M9s0wKse1AWjkBBK54H+9xgcY/D8DV2VxXJCysFdBkdIyycLn8T2J6dOB2pGRZJ0M27OBhQ2TznuOx569aJo2kIV1YIh+9GT8uOhyfpx/Wn7gqyGBA+cIhRiA3HPTrgdeP51XXUkRxscjaqybyykYwpzjpxzg9vU03E0iAnAK7TgZIDZyTjOD17fnRHxFuSUDdhQVG0hT3wOepz247miXy0ZUm2/NkBSeQmeMD/vnJ7c88Ut0Mb0bZEynblTsJznrye3foR7e0ZhVpoEmKny1JMYbcrDgcjHP6flU0sw8z955qqHBBJxtJHQ59OuMH156iAXDbnCsDuP7s4wCmefwxjnrzT0BXEnfYGYrjLZDMQCCVGe+Txz1449ORpCZMuHEm/GSduO2Rjtgg8+vc1HzIoYE+UI8IevJJwADnntkj04pZtpbakpO1pCu0ZJ7c4znvxyeaWvQdkPIxGcuzfIRlflPBC8+gH9T0pZP9ZJl12uWIOAuOcY798f/AKzwjxsZMylgrNg8ghgRuyT35H6VGjKGSXK7/lJ4wCSe568HP4Gm3qMexUSDIL4wwZhklcjnHuc49aZM0m1gWUgNjBJznjHHfJPP1PpSs4TBjSUgAKuOrLz37kEHnp6elQSyyPjaUGMR70wcYw2Oe4wfzzQ7CRPKzxoQdiNsP8J3Hgkd8A98e5NU7yREi2uMtlVVN2SPYZ9uuBjik2L5QQZyWGYyfu8YHPbj35xUdxs8sKqANkkHaeBnnP4//WrelIzmjovBzk6fKh/gkIx6V0Ga5fwS5a3ucnPzg101ffYN3oQfkfNYhWqMdS5plOrpMR1Lmm0ooAU0wmlamE0hiGkzQTSE0xCE1x3jqbdLbw7sDOTnoTXYE1wPi2bdraqSCFXoRnNcOZS5aEjqwivVRUt0ZGDFwp34PJ+bPJGDn1/T3q5E537WGfI+XrtIwOSR6cA/j7g1TtyqeUsqTBh8oYnBHABK59MEjGeK0gAdu9QxRsAhQFHIBz+BHBr4ee59CttSWRGkjIZ5dwwQc5AJO7Az+Azx7daYGaIrHBkhSfLJyeQSo/Dn+WKWItu37CG2hkVCSCAchfy49BmnCXCvjtu6IAW24wQCe5Pf86y5epV+hI03mPnaTyVAjb1xj5R2IP8AP1NPkbzQd5ZUwQArj5yWxgAewPGeg7VGPKaRU2KIlYY/hJxn6DHy5+vFNjB+VmDp9zhV2nhQcH88HOP1qZN9QRNIRM7D7/zOwTzAOnGMj69D65600iIlVlx5voV2hRjJP0O0jn3pjoJFWKR/MGwIqKVAyx5xn2Gfw4p8G93Mm3IyJsouVI28A47YJ57ke9Tux7ELoocFd7RZyyoPnBOSu3jII4Hb8aRxvchVBUHK7lBUEgYJPY5J+UD8PUhZ/wDWAEllUKdxIYnPVQPb8gPWmuMXCB55Y2BGBHgl8sG3cDryeD6deKXTQrW46GT7Peq6qwZf3bBx8zcZJK9RjPtz0zirLNHFIwD/ACxEDJYIBzuJbPpx2Pas/ZvjzKViVkI2ryq52kAYz7E56VcspRLCpim+baFx3GOeSw/L6jvSbHYtYdlYFdrPzHk7lYt1OBxnAJwP8aXBWBo2j2hH2o7H5V568f1/M9RA7JvnjV5TKvdjyoAPAPTPI/rmpbiORJFKhmJZsLgqBuBwBgYPOckjHtzmlYQXOI3CySlGfLAsBg8HIJ5yDzg44z+FIBnfMU3Fuwb5mz67fcdfpnpUpR14IxGEAdIe47gnGOcY5xj1qMK2ZyZFZgcM4I7Ieo4yMnj/APXkYCKfMtQhBjUZXMjHJA4O0Y9Pp19aWSNpB+8V0YkMRLh8YOAABz3PemxiTlYpFIc5ByCSevI9jjvjkcVJLDic5ZpMDbtc/Lg8AEgY4/H1xSvdBsLw5ES481wco7lsDoR0J9Rjj6VFM+URpZGjUjcGkJARjtAORg8fj0p0saxqE80+UAodd4VSx+XPOcHH496CQ7F/MZmjDKHyCV/DHsff+lXstReaGs+zLeXKN2WGTsxznLdiOh4Hao9o24zK8jjlgepbjjnHbrwKdHFErRbXO4KPXA4xnufQdu3pTyzFmk8vbyW2u20DHTg/Ums99yitdBvM4ZCQwI3sAuTz06dP51NChEe5SBvIXaq4OP8AexkZA4/nzTvLaTCyMzr5mAVXnIydw5GPx9etRbQ+7B3ZIZeTlMjJGSPfqOTmlZoLpoRzsijJLj5goXnPTkbe3Hrnge9QStkxgqVYYCApjg/w4znpj3/lU0jKNwVQu1yikH7mBxjk8/MKjNxtLPFs8t/mOWJOM9OO/A496G0NFa/GdmCD85OZNuCM56Z9v8951TccFHHzqRx1wB+f8vzqG6LJGCWGdwb5SRjJ9fr+QqUsGXACjLIeOp5POe+Tn6/hRzCIY4gYFLCFpGJY9fmPQH8+9Eqs0hBHDB+dnX/gOOf89akXKruMhPHZuo3nBAHt/T3pkgQ7d6hV/eKRzg9O/f8ArUXRSI5vMMcpijyud6gPhlHqfrgjiqgw7RANnC565xnvVwoBGFLOFZ2UqOPl6Yxj/dNV48STyOc4BLZPp/k12YKN6lyKjtEJwFEgGeWwABknoOB36VTiJDBoTvEjFTE3OWwQCM9O/B4OferF+G/cpx8xywJIJPXj3yaZFgXO518wrIwVsE7SAMYycA9s/wD6q1xs7ysKktC7bxpGA1uGKE4lXf8AOpyMDGMqQTzz0FXIbiORsMTuJKiFhgr36e3PUcmqMcZRDIWiAUFmRwGBPPAzwCNvUVNbBogLWaVfNUAb0XB25GQo59Byex74NcC1LaLEkDxopeYsu/OducY9/c8fjSSybJom+ZNrDaBhC3HAOenU/hTJDEzsUMU+SQWRsMASfrkAenoaGczySCOdwAdzeYMH6k/4DvS9BepUuQ8ckSuQSI5GfDjPJABBJ4rl9Y5WEIy/KdxUZOf8/wBa6S/yG3oWLPCFVcgKACD68cjHPp61zF6EkvIkjLMobCk8jr29Bx/9euzDayQS2NfSocWksinJVRn3OTj+Q/OtWyuGMUYJ3IGPzN2A/rnFQ2kLReH2YDiWTHHouB/OM0GIrDEihgH+csW+6cg49q7q03BpoyVmdTbTxmHep7ZAPXoO35VpWqbI1Hfqfr1NczdpJbW8cfPBBdufvYwPYc/yq3Z6hNDIFfdJGqhcbDktxwD+NbUswhF2mZyptq6OpiHpU68YrKstTglVScqCM5I46VqxFXGVYEH0r1KVaFRXi7nPKLjuTd6UH1qMU/BNbXJHZ/KlzTM/lS/SncVh2fWj8abSjP50xDs+tLmm9aXr9aYDs0Z+tN5zzQKAHg0Z9aTrSfzoAdn86M/nR0ooAM/5FHekyfSjFACBvSlz6U3PFJnFILDs/nSE8c0nWkz7UwsKT6CjJxSH2oyc0rjsLn60UmaM+nFFwDtSZ9KQnmk3UXCwvoaaW64pkkgUFmYD1rPudUt4x8rh88KQeCeOM/jWdSvCn8TsUoN7GiW/DvVe4uooVzI4H1rBl1iaWOU48oqdjY52E9+etZkkqvIsEsu6RzktgcDpnnp+teVXzaK0pK5vHDvqbd1rHzNHH8jY+UsOT+Hpnv71lS3LSsQSokDBSD95uOnX8jyKiKySqFlUFZCyBSfmIz17Y9cfSiWIKiifbKobK5BGM5O7PJB/+v0ryauIq1tZs3jGMdhJECsqrlpD8xjkbGTjn3z0OBwc04ytK6RIHKRt9xMrjpjvyKScpHajzVEkpGThxwB09z6evNNneSTbiHdtUOqEkEAZGcYxjjGOuSPesNi9x10CoA2tI6gF0TILkdDj1z+dQSBrtd0c7WyhMSA/dQjvnjnOffg80sfmLcYOY3kAbmPgdgMYwD2J9fWlmjeNeCJLlPm553FjyM9sDvile+oWsPZra3lMkriSaQlkDDIcE9wM89OfoaiMyxvJI7Misu57dx8xxgcjvuwR07Gkn8iF2KxL56qu1AoXZzgt04HIOabHC0M5zMZJ2XLMykn5uy46AdvTmldWGkOEJlujK6q8YQGONiSqrjJPTGegyeualXJI3I0gG5BIuCAc8emfr7GmyxqQu0uhbBGOgXjqBzzk9eaaLfaCHLhiw2swyRyf069fX8KV9dg6E7mQvI0YZuqAltu4E+me+Tjn+dOk3pdRMGmyqjdhQOenT6Z7+lRyK6zLHIRuYl8Z2qGJB/MZ9Ofx4mMeYyodgi8ZxtGOueB7U9dgFEyqSyhnHVUGGxwCMdT2PFRxyFpG3BSSNysSB9OCe23881LGoeEhXIV8qF+UBucDJ6+3X0p33m3ksTnkBSvbpyeBxnP15p6snQhmkmjmMcZ24O8mTd07Ej1OOOnt0FWSGbYxK7hhdsePkJ7kdcdOPeoHjMmwIzLuJ6sOARk+/f0FPnWSCMupYr8/DHBA55yAP8kChN7j0JCpY+UA33MOBznsRk+nHP1pYdqoV38D5mkG0BT1H8x26CowjAK0gLhWCjjIY8dRk9hjHHrjvTt0camVjjk5ZeOeoG489P5/SqukLoMBZCXRMqASuGIyc8AKOPTqfSlWVllEcuS6NkCUgjuBz0Ht+fWnW8vmZaLa7su4sGJznGOfTr27UJuLqWbeFXJCqRknJPp79e5+tZ37FepJKX8nADNvOBncSTz948d8D8KUCR4h5jKGdlbah3EA9Tn2AOensaLj/VqJSEMh3AMxGOfU9euOlElwqbpFwV3FDl8Ip/UE9evPuK0W+pPoPAk+7JL5ahcsV52nPHJ4zjH8+9CpHHGw5UfPvO37zZA4P19AOtQxDdGimQRhTtJXgZHfGfbnjt9afuSOfzNgHO0FhhQOmN2OfT3+gp36hboDQB5FzucHlkL5AwQPu9ByAMfpTwyx7di5D/dQkkKo457Y98ev1pNzBCMFFUBQ5OVHHB56nJGOvGOvNJGV3F0UNl8ZOTgZABPoeceuMdapW6C3EciSeRAdsqDfkEEvkcnHU8Z6/lUjgGSUB5wC2d277uR75zxQGUTyE480qACuMZ7HAOee3tTXMjRuwZACTlxkqxOM8fjgAE9SPek2hWDYsWUg3Mu9dpZSy8cAe5yfw/CmIiiVZMlFwwAU4H4kfj/LtSyNsHz7kDHqzABQc4HPPcdOfemSxwx+YFVld8sTtKgjHcccdee+evcJ7jQhji8s5jAJIaME44weOpxwM1FMyiRgwHyudysuRuUFgT2A+vYii+LWsDMhG6RyFXOBGMc9O+AOncio3BLDy3VVIWFMHKnByT6nGOeRnFOyKEZkbd5URXHzEbd2FABI7dSfpzUjMyZJk3Rqp+QnPOeB057DA64xmo5CG+YFVL5YbsHlmAX1yeC2ak+YyNsUkiRsqOV5Hpk8DaDk+vqaaTExwzDIGcE4YnIPLHAB5z6Y/XOKjEvThjtKEMoPPyk8+p56U1drtltzFgHbgjq27Ofov0A60okU+X5Jxhlwcg/jz7HHqcdPQ6iCOEsVEuGOUyAwOR054xkZPGeu3GKVwrPl1QnJKxkcEg5wM+o6fyODUSuQqbGBJRQF3ZOCT1b27YIHHc0hysR27XLN8ueFBHBcn1yOh9ec5qopA7jJZQqMAqbGBYeYP9oH5h269PeqhO1IyCW4wDyQeOp/PjHP1qxMIYWIKB3Q7QxGOByT6cfh1qCRiI8Mr+XgHt2H1zjOTgcf13itTJ7Gt4GGyK5UnPI5Jrq81yXgeXzlupM53EH+ddWK+6wP+7w9D57E/wAVj805ajBpwNdZgPFLmmrSigQE0w05qjNAwNNJpSabQIaa828RSk63OfL3x7grKD1/DuK9IY8V5jqEjPq93tIB3llHGTjtntXl5s/3NvM7sAv3lx1siHylAZ1AJG0E9O+PfB61onaZJOAAzMBtByuFHT8wD16jPI4o2pUoEBXOdzlzjaACCD+daHmlWkwrjcBuBPCo316jj06Gvjpbnuod5aAKsRlEjbTjPGcY49OTjP8ALvKJCuWQYDDDNFGAEJcHqfQH9Kkhk8p8kPtRt33ugUggEZ54JPPanMrDbgOo46nI+XjGF9R/k1m1Yd7jd+5TcYICsGDLuJk+Yt0Gc5Hr6mgv+5I3KZZFIKnbkM5x1I56e/t0puxC2AuCgIUNwXbgAkHnse/GeKmRpDMJsAndlEEoCKAN4HfPU8dcAetTcBsrMnmuOA/mSDDHHVRkYz0z39frSMI0cqI/uMxUOuG4+QZ6E/l1pTBscK58yNMRhSAF4JbOTz/DnNN8orEpVhiQAkbeSWfI9R3NZSuUkh4wixKzMSCmSh+XOfmxg459Rk8ioJJJEhUOz7mKnbgYXII59j09znr2mDPiSRCANrkHzCed/r068/yqOYZbYyFMhyx2gEAH5SPTGO571WtihnmmeFUMjEYDEtFgLhhk9eTxx2p9lN92OSXJU7kZo+GAzknHXk5/XmmQksD8yspXGwYO1jgk/iSBnnP0pg+RhMjkS7gwYtjP97dnBOTyfTPuaTHY1JHxcfvMIpAlwSSRzjG0kgZ9gScinlhHGcDbF8yrJjKgYBDcnnnPT/69Q3LATKEY9Qc7cjB68fd/HHYU5FfbjYv2gttITfhiBzliB/nHNTe2widmjyPNyrDLNsQjJOMjjnGSOe5/GgfvAsjxNECCVOQSBwcnOf15BHao5pFEwVm2u0m8KCMEnIPBOCT9PfHemmRpGAIYE5GMn5e7DG0e344oclsybPcWIgRgFWJO1txiKgsB0z1PQfieakIO7jcF6neduAOQCe5Gen0zzSFEaUKsrvxkqeR2I5xwMgdD6+9QCMwuHjd3HRS3GwZ6Zx17d8c9qWxW45oRBIEi3HA3EOxKLzkE+hzx+VCrHuCSKkgDhVLjJOOhwAff06+9SPvacDkrjC4I2lehODx+n4YqAdyCRwQgJwcEDnI6k9fT8qTsG5MFCBQAFD5cDJwOmMHgDp+vtTJJQMYGHbBOGxk4BI55HHoB+NMYSpMrorn5shnXpg/kew4H54p8jeVcZDhAI8LxwOepz7j2ou7ANkaRHdZGAKtz0PXgcYzjH0/XFQeUrSeUJWkDOOrAsONpI/T+VSmYRiXKOVVsjjq2eCT36n16etRByYtyuflUHaCGLDPX6859azbKQkjsyZVhknB+YNgHt6AcAfhSuF3sd6kbdy9sfN2z0pJxt8xm3Nht3AIUcAHtx3/KnPKzxs0YURgAkkjgjPOOnOD096lW6jI5I2kjw24BSUYMBk8gDnqeh9hmoLVDtjQoS+4AhU+bKnrnn2FSrzCoZh5bL90sQScZz+uOhpio0ZjZyGV2wxDEDIwc+nJz1+prTRkjxHt3I+C33fu4A5BXn046/XrSSJGke/JfHIx6Ejj9GpVXELeYqiUAsu1RkDOB1AGP8adcAR2yrM7+Xuwpzx0IyB9Men4gipUVvYq5XlkXy1aEt8uWOTu75P49vwqCzQlOmCx/IA8/yA/GpJfmgy/MkhGW79cf0NSyKLVJGxnyowoz3PH8+K9XBwUIuTOeo7uxmTb2vcgMVHAK9sdePz/SrVvGHG0sNibskEdcAjH4jqfyqtaIrygybzsGcsM4z6cYwRnqe9XYoNomVyrENncTwNv0HP8A9evOry5pXN4qyJnVvLiik+YurKRsyQB+Oeg9qBGr7jGzhnI4bjGT1PHog71JJFDg4iWRVztY44P+Sfxp2CkxcxhombI2nqMcDr35Pc1ktQKknmWTKy/IsKeVszkEDkjB7Y6t7rTYTvLOiq7D5jbMo3JjPTjkZ5/mKsXESy27RA5aVQNwYdT16fXt6VDJbA6c0LxhkG7cAACOOgb3bP61olzAzL1OVlnZpPkZVI2797EE547DJyMDjj64yLcPLdFpAPOB3Mfc5GPzJ/WrF9cGWRyGJAcAsQDlsYLZ/CpEgRIB5ZJmlyFXOQBnIP1+715612YaNmKex0c8GzTNLjyBmPzGH1+Y/wDoRp9nEzXcWOSCc8dOeBx7AevWrHiHEF9FEu0RxxhACfvdcgfhioNL3i1mldGYlQuNy/Me4A46478Vpin+8t/WhjD4biySNJeSHYzqg465PQDAz9773HJwaFjC24l3su07ujDLkDd14xnJzxgZHtVeF1jDLJgbnEmdn3EBJ5wPUAf4VdaQPIqfLtABO7hs7RtPr07kcn6157fNuzbYabUQQEYAhbAZXXJVsY6/41P509q6eXK+9nCsQwPGPT8jzio5WDxwhCwVRvIxuLZGBgDPUkD35+tSZKtMyozDy8bFwRjbwM9eTnpxzVqXK1ysjfcvQa7cm4CFUZQvJHdufy6fpWjFrsIwtwuw5KkjkZHX+dc3Im+WUfvhsCuyEhsHO4L0AHfPI/nUkbPbxechLKrFySxAUbuDg5557f1rsp4+tDd3IdOL6HZRXdvMoaOVWHY5qcEHvXAKfs6LtWUkHfktnK8E+w54p8V/cWsLJGbl9iZJUdx1xnP65712082W04mbodmd9nFGM1x8Ov3CGEMdyuzAsV54bHHt05q3B4hm/eebFEQoP3T/ABDqPwFdcMyoyM3RkdNjHAox3NYY17aSJbZxjptIORnH9RU8ev2riM4l+cgLx1z0rdYyi9OYj2U+xsY9KMVmRa5YuM+YVHqw68Z/lViPUrN03LPHj3OO+K0VelLaS+8nlkuhcxiioY7mF1BSVGB6EEGpPMU9GH4GtFOL2J1HYoxSb1/vCk3D1FO6AdRmmbh60hkUZyy+/NHNEB+KSq73lupAaaIE9PmHNRnUrUHiUMemF5qXVgt2irNlpqQms6XWbRHRFZnZyVG0dCPWqsmuBSwFtKQM4PZun+NYSxdGP2ilTk+htZpM1zsmvuTIEjRSGKjcc5wM5x6dqovrl1LbmXzEQ7N+1QDge/vXNPM6Edrv5GioSOvLAdTVS41K1hXc8y4/2Tnvjt9a5Ka823FuZpyxl5yXyR6AHp/ER/hVYTl2WNHESyM33k3BmGAOg4+nvXLUzZr4Ymiw/c6m51rZuEUDvgcEnAJzgis6611wSFki53OoTk7VPP8AkZrHlhZ1jeZ5grlgQTnAzkE+hzg/p3o+zxwpGgjBEbA8AnIxg/icfoK4qmYV59bGiowRZlu5p1lLyZK5U4bhgV3KfUdhkVV3h4AVZjI6g4x7YcEY47c/5E0EKEeWQp+XaCpxhM/ezn07/Wn7TuZjEQMhwMk4Hpx1yQf1rjblUd5M0ukRuN0671HlgLvRkyQ2emc8856/WnBFjkliWPMikszKME46D1x0pt3cpAzSxB2U4Djj07j/AD1qN3SJ4maRngK/KCMscgjaSenvz3NHuoNSYnc4d3zC7btxAxj29DyP1qOOcxyMpEok+4rlSA6d8kg8jPfH61CryedJbvOyzkjBkX5FIPB44weQOtTTeX8iSzNCwH3Yjgjnnrwc47nsKLu1wsNj2Qkia5z8wUByVKjd/EQe/QZoLSJ8yCVUJ2DlQxA6BeOeOM+2fekjlVIEuZwscyqFjmdcYz0BBBJH19+tRvPKUxCmxGbafOXliWHOOD0Oefpip6D6kly6LcRfaXO5zjyV6ucEgnsc+uAD3PFR23nG3lM8gVnjAVF6ruHHPX9ABzUyWyW00aqsso2DLHgscj5we55+nuakjyjI0oITbtKgZAHOOAPbP4e9GzC+hXijSCFYLZFVAoGI0zk9cj3wOtSbOA8aF2+Vht3AEHgg++MDqOhpqEfZoFbKchQSxTJByTjnipZWkbYHbYTjK7gWzwf5fz9anTqMUyqpgZQzRY4AycjgDtzx/k1IZWXduVyASCinO3pjjHB5qEiFpIpHXLgMeXHAx39uMY+tSRoqu7FcjeclT8qnHcdMdf071SbRLsSRliWc9MtnI4QZye/Jx+tKoLLzkqwy2V65PPfk4A9hUEbgIFB4KBivICgYBJ9OKQo6tu+b7xAOSc4+np9TS5rILDJFEW4uCoLB2RgwCjsCfqalDsxY8fKS6nafTGQOAByPpg1NIRGCIV+bbhT0B55OO/X0qKFA8MRIRjwqqBvwOueuM+/6803GzsgvoMhEkTR7iqLwN/qeh4PXGP5VPLIYvKG5QVGfmPt14GM9fypspB5ICSuCwUDJGcZ3H8+OKsGNfljeFioYDZgY288kds8+/NJJrRDbW7INwiYxSNlmYgM3yswyCTnJPTHAqxlHkw4YBeqgBtp+uACSCc9etVZLYfaFLeUA3SPYTuXJGO2Bz/8Ar4qy+PLPmrhN2Af74xjHHY7QcD8u1NX6idgij3WrJ8yI3PCnkZ9T1OBzQkG2CNAoYqwLKFAOcjk9u+eO9OjWZYWEsSxMxwSozhunIx0/E9KdkllPzOSc44J3evHAwCOatRQrjPJj82NizsQBuUhjwTwDx0HP14NP8tnn3OMqAeQoYKc8g7h16j0pqyRqjOFVs5ZSPmAbPQDGO/15/NqM8iKrsrE7WAXjb3/X9c0tA1J4dvGI3IAwPM6HBJHOODyOgPX8o94DSsA7FlyOAFz2z6njHGTx9BSyrGVCOzKz4LSbQGAx7dM+v86SPKW7Ix2NtDGNVAYDgHGOOx6dOevWqu72FZbhGHkJEo+ZiMOxJL89RgAZPTI7fWno7i4weWVz8pdmI6+g64z16D65qOME+UQ+8sAv3CVHzDjjjoe3fjns4cbSMMNoXCHKn6MRyfU+w6U9kAhbAAcnEmQgEgXcD0+X06H147dASxlmKtMz7SCWHAVcjuMYB49e9NkGJkG9o5/75xuYc5wAcHnnFP3Ny25UeRsqMBst/P8AmBjrQHoRxK0iuWCqfvHncxbg/dx1IAH8hUgXIXKiM7jgR8EfTv8AjnqeMnoxiqkLI+07QArk7hj1I4AzjpzgdRTJCyxkKMYYlV3MC5AyBg4JxnoPXA64qdEMrymWaVmG6ONSUZMcqDxjP8+TwMY702RljLggtyVJXKovG0AnJ9c9aUqzNtYHarEBgO38RHucgdD3pI1jdo1cLyybiOAGGfXnrnOKevQY3cquBFIpALYyOWIGFIAOTyeh4xSiTzNrAmO2cAF3JO75s+3PTvjoKcoCIFkd2zgbccHKtweCTjOPwoAi2oqwKRsRiwBUsB79SOD0HrTV2AhKLIVVFU7sBVP3QWIAO04Axu5460skhCKw3CNzj5yATkFQMYz0FDuY1ZpSNqHALA/KARgYHfDDrUQR7eGKP7xTghU6sOTn05I6VXMRYkky7AFm2ghwxYYI2jnHPJ7Z9fU0y4cyAL8w+UtjknII6DHGSOB6UzZsdREWkMbgkHPUr69Acjr7j0pzQrHIFfYItvyggNkEtwOnr2PT6UrtqyK0RGd8iTSJMrbo+q/x4A74wvXt37VVlwsmcEkYCuMAlR1JIPPOKnvnwoJiaRwgHzrlWPBzj2B/+vVOZZVlkaQp5jNgENzn1Ptx/nvvDczZs+BePtnGORXW5rkvBnE15znkYJ+prrFr7vAf7vE+cxP8Vjs0oNNzSg11mA8U7NRg04GmIDTSaUmmk0hiGmGnNTM0xDZDhT9K8qmZHv5TKquPO7kc8n/Dk16jdNthkPopryeHJlLq3V8nnG056k+nOK8fOX+7ij0MuXvM1LY/u2zlRjJVsDnkDHpxjk+h/C8UBllbyyTuLfMNxHy9c9Op61QgOfkXJUsynKcDjoSc4GeuPwq0P9dKEO7cUwhGDnPOB2OR+Xp3+QqHuIuRpHNPHEiYjDAbRkEjdtGeff8AUU7YrrHtH3gAQy85IA47Zzk9u9RQSrGm/eoU8nbkqOS+OnPb8qsRsyXCuUYjcMqSWbAZz1z6EfTisOVNju0MMxlO5Qw+YsF5IBIJ+6Ov3jnOKml+RlQAmRwwACAHlSvsT939OvSoraIiMEM8g2hMDBJPQ4X6qOanij3THO352JOUBOMqScDOBjJHbn1o5WPQZK/lH5WLAlztHUjaBgZzjqen401J3ikKhWTDDgtkMq4xjrxz+ozRIXzk58x0GDncpyCxwOB9Rj29akmTbHMZFJX58M4xjoecdAfX270tXqh6dSOR2CJGpxvAXGCWHzA9cD8fqOKGTAjbaFi5CgjPXPbPXaP5VI5jjkaQIr/MflznowIPXj73T1qIuwaaMjBzgAgt2254H0PPvU+o/QfFG4ZlUvycKQfw9OgPPXoM8kGo5gXdzgdCDsGPmAA69gCc9uwpAjsvyTMZWXIQ4IDe/pyo7/zNLd2+6SSN/k6YYNgoBjAU9uV4+tV0DqWoZA8VtslhZWG0eacgjGfXnGO3FSxs8kgxueMHYARt+UYPI4wfunI9frVW2ZDFIhhlYyHMbFN20Z2jPY9CQcVadJUXJVxhlVQxy2FPt2Bx1PrSswFB2Dey5Zht3gYGOpPY8e369aJSu07cIC+GchQOmRkZ6DjjPb2NIgQSZh/eq5yioQNvooPQ9+OBzz1qUqhkUhlC4KogXK4z8316Ht2pWJCJZGk28HduyVAXC9QdvOec4z6CoUdxCzK4wyDD7+hA54PHcdPUe5qw7RYUhMqmCoJBLDkfU8KMDrxSclWCgRyg5IxksBwM+3em/ULlcRKpWRwGxgguMhRu4Xkc8n049anKLtYeUWLkkK5GW564HQdvoTUcqoHPlsxLOSAAcgjHzdeMkD/69QSKBMu5WEchyQ52gdOpH+6RknqM/TJuxW5ZEytIhEmZeNudx4zjH8v14qOERyRhAucISqn7y9jwe3X6cd6AX3SGRgitndHk8DA4GOvpz+HemsplmCzojxg/wEfdyex6YIPX1ouAbIv3e4BsYJBHAw3U56Ac+nSofKAaTJAjXjJUDcc5IJ68VNGxGCI1ZsbUER+UY9enQHH4cUz5tpacEhidx27sNhs/l0465qWl0HqJIke1zhDEoITsBwOwGevY+lLGqrDGZYe4B3Lgk+3+R1pvlCTHlqivJyAyls9sevHH4+9AhxHlxjA8vlASDyBj24Hp0o1uAJIpEeGL5w+IhgscHn14HP8A+qq++KW0lJBUqwYZ6Ht9ex9f8J5EUpu2E4GB/TPTvu5P/wBaoIY8tEgZgzAr83RTnP3ccjrTcm3YaSsPjUN53l/uy2WzkZA5655/h96iuXWeSFEKRqvBAGQD0/Hrj19qtQqpTYpLRIxZlydoweB+DH+dOt1yTO2GJ3M3HDHPGM/h+dVTi5tRFe2pF5JNxGpbKwJuPHoR/jVPVJGSBUbPztluMjsSD6ckVqRLtsWkJ5mYDPsDk/nz+lY0rFrp23AqCUBHIyB3/X9OuK9PES9lSsuphD3paiRlI4w8gZACRktt3DoMccjB/nzVrzGSNdys75PzFuMcd+59vrVgQKJA7mbzA23HBG75sk+mAcZqFljKo/yneDuIOTjBx+OP8a8iV+p0qzJwH3yO+xMEqGjbIU8etMiKLAfuvMeWbIJ4Htx7UFh++OwBHBBAXPPTAyOOo59z9aSOZjHKDC+RJwpJG059PTGPehNWFYfdARtKoO2FGJBLHC469OuOPaszU7nMCwx8SuWxn+AYHJHbofrxTtRuniVQzYDEMMdV/Tr2/wD11l3bIsBJCgzHLAceWg7deP59auGpSRWlCyBEjjUxMxbBG44Hb06Dmtbw3p4bU7KMZA83eyEfdxyRn8D+dLZWyRMJHdlOwbl242qxJP8A46P/AEKug8MIEu3llG1YYsuSOQW/+sK9HCRvNIwrT91mZrc0V1rk8TTDeHCorDKsQB8uMccg1bguIYdJhcooM3ztGrFtufmySM4H145rH2Lc3zNgiSRzJIcdTnOD+J+oOD6Vp63ADLFCZzGioFyjbSTyDj64H6VlXlzScgitEh1leW93GpVkZpARtU4KjHT/AD/WiW0RmJuGC7NxUKAM+nTjGSOPrVS6S4itwCsUzMxDNGPLkQ55J9sjOfU+9MjuHtZRKzSoQPnWaMlQ3uwPJz6j3riaRp6GgkbxbZQ0rzADbGQCMYzjkDntzUcn7rznmUt8uWfsmc5LEjqNv04HBpn2g3WYynmMqFXaNgGGe+Dgjg46VYeVFjMaSFFPLKybSnXsfbn6UrWQx0UscaswLI0rBE78Dv6k8fy6UwXJkt4yj7VcFdrMCzEYz3JPANLtJjO6RV3cEgZ+vGODn1OcD8KWSJpVYRhREEyMgnBAz19xVcztYmy3JpXzczttLbI8jPI5PBPp/wDWNQyHMoDfMSQiNjjOM4yPfrgVHFg+W8bSliBuGfug4PPGMf064pIkmSQtkyAkshXnGAOvX1/nTU77oXLYmeRpJHdo/l2lRk5AyflBA55JPHWiQQZn8yMKpaThhgZxj0GOp/yKrb3QSW8cit5TBj0yT/8AXNPefylaBiifKUxglVJ6nI9wenrT500FmSJaxSeey+bGnlBgFY8HGTgZ/wD1UyKHC226WVeUCgMcrjPfn0qWC7EYkdkJDDAA6Egn068fypIruNIbZZiWaNhkYKkEAHPT6e/NF1bQeoG3leSVVlPlq5CFxnb8uPy68ChlkIV40Ro3x/ezkNuP6AfpU0TfMqO+9S0bFguCCG5z78/rTLCYRAqg3Kj4GGAGQOnvRzCZGFKOqsrABWcKh4UB+D+R7VGGlVGjAn8zyioBHfd9epx+VWYwyxgORt2Yz6BiAMc9f5VJKpjLMVKmR8jaCSBkflwPXuKab6Bcg3sk7O4uHRtpVQevzZ/TIpIZZoba2Lm4DkqGBYcHBGcc+nv+tWpQBhGJXBKA4+6fz/2aZEoZYwxIBCkALz1GTz/Sr5pLZi0K3mTuVMTTfMEAUkEn5juHX0P/AOvpTjLIGXykd96nA3j7xbjHPt/OrSx7FPzFtrYBHQ5xx646j2qPyhFAwbcQrcbmweOPb8PY0uaXUNCKLezyuI1YMBtDycJ0yAAPX600R3JtoJE8rarK2eSWAwAc++c56dKmQCGadGIC/Kx55Axz+VErxQQzO/MattODwDx1+nP5VPM31Ahmt5VkKSXLoZdwUjs2QTz6DApJIUE25pZd/mA7SfurgZHoB/nirErrIphXgY2B8cEjBBHHPHsO9Rtdo8SypGzRPgGIA4zjI59uffp9KLLqwuxI40ikVGCOyLsX1J6g80vlBV3SkeXltqsmc4AOD/Q/jUZud/kSwiUEL80hGcADkYPX/wCvTWeVRMYhkOdybm2n688Y/Ci8R6kywqhnRIvmUYRiMbuAev1xUZjjby3URvEyglyvfjH07fQfo2WST7UmJniz8uHPOSc+v160+RJWaYbduw5wAPpyO/B//XQ2rWQK5JuM+7JzDIgyT0HTjPTt+ZBpiMYfmn3cEKrH/lr1xkdunfpnt3gICb1muQjMxUtsADHPXGcEev0zinSO3mF/MLqByvmAKeMYHYjgnj86XMx2ElldfLSJiYiuVk6kLjoc+/T+lPB+0btq+bNnHzq6rwRnI5FJMwSYJDKAzEl4P4lPUkEZAI/L65pt1cQGH/VS3C2vJG/G0+mcADpxnn2pWXcZNCWhEpwB5bFiCVU5JHbuMH3pvmvtPlxhmJBIL8gYPp0A6/XtVO0uoUzLBm7kjTMZh4RhnjpwccZ5/CktoLsxuN8SmRAzIgBIyMFc9PfpnOaB2LBk3LG92xjVThdww54B6Yye3r6d6r2Ess0apbRYRmBDzHJ3ZGGA6+n5+1PihRWklXdLI6bSZASSfXP0x9M/hUoOVLRueRjAA9uMdqhS10DoQC3ZriSS4kaRmQAFhu2tySB2Az+A96sTEy+WHI3SZwF7ds8cnoO2ePSkjQJHGodt2Q67M4XA+8amkxGkQm8pFOGA2+5HbHsfbHSl7zHcCjBcLKXkUMijZ97/AOtwOTimJbuiiIy7yQB+Hckj61aSRUYkOuORjkZycDHbsOSPXFMRwLdtis4VBkJzjGckDPrjFU0mTdldYZFCqcB/lUHkYwc9DnA4/UUXAcRfvT+9ZgTtHBJOeo5xgD/PFSvcsZGZn/d+ac7WHPGcE8np6VXIUJzljuBwAcZHCjn/AHaTsloNX6khXEkQdyDljnKrn1HH+fWmNJ+5mUYBZjgb8eg64Bx0NPkhYTRkgkLx90Dk8nAx6UksblQHZWMk3IB3ZPPc+4FTqMljBFspPU4CqQCuM89P93/6/elmZi6qwbzZORuySvI7A8Dr+fWiUB5DlWJ3E7mUZ468+hyOMHNIoQMhEQ+8FDHJyM9evr+WKewkTzNsLgEL8gGAMYB6Dnn8O1QzRZmw28bmOAxCgDA/qfrTlmLnKZcHLghsDp1PbrninJjzXIfK5HIbB45PPfp+tU9SVdCSj/SkRQVKnI3HbwORtA6dT7/lUkIEuSHJ3nfu29h9Bxx71FE+Jt2RgqWJCqcAcZJ7Dg8fzqWNlaQOVLrgcDk7to546cds8YprVh0FSSRBMI8KBkYA4XpgY/z+VEQdtrhs5AUA/NtOOeeAAOfTkCmRMpVWAUw7sr8nTjg5I9wB7ipjKu4r+9YK/UHG1R2Bx3yPz61XzAUqkPlhl6YKIy7io4G4469DzSxKrqIsAQMhYt3btuHb36d6rrM22RGjRGJ+UAY2sCMZB7cirEY82cRzlJDkeZhvlB6HPvxjGO3PFCaewnfqNRItxYIRJIAzNtII9/bgcHrUk5bylYoAo+cIF3gEkgnA/Q0RttgXemF9RkL0/lj8KWR51ikkUqBneuRk47d+/NUkrDHYKbDHgRL8oyvIPrz0HPp6/Wmy4EIjPziTlY1JbC49Mc9uo6n8afuMka+U5MZPybCAAOxP0z096NirIFHGRxsBDKvqT1BOT6VXoSJIyrMF6qzZCMcDtgY6cY6ck464qGZSZAHlZQ/PJG0n0zz3HQenPerDgHAZf3jnOwkjt/Ee/GOOfTmhyrL8/MSLu+VchgD+J/HpxxTab0FcQKkcakuVw4XGPvnjk+vT646kc0wxhAdrseRIUJBLHPUHnHI57frT5JAGO0N7rz0HOc9gBge3vTC25V/hjIBO1gQccAc/XrzwKNA1I0ZxOwKsdrBRubCxjJx+PQkc/wAqguZHjKxrnDk9WZt2OW5PQHgbv/rVb2sB85Z1BOTu4zjk/ngcelVXkYzGSLcflPzBeQT0HUe359epotbQdyGeOMoFL8ALhmB+fJJx9Oh46fQU55ZftBZBKvzcxqx3NnPIA7c9c9/WnSSYaUovzfdXpgMCFHHY4HAByKjGFh/cxK5UFS3XJAIJP0P4809thCRYjRVAVcKBsUcoS+BhuO2fp605gqKpmYJCxyM5XgMCO545GPT2zSk7JOd0aq5++CAuFBHAPrnOfQ+9MlQJH8rEKV2AhsYG3JI4B65wf5UXsg3EDvP86nY3BKmPadzc8cen+c0/JZm8vcWw+Qxyc7sjOD0AAP5cVDM6xyNukwOXX95wuMAc5OOMdKWfmRgxKrl8KEHzDHA6ZPAz71Ldh2LEeRMQNy4y27Hy5z14P/685qsW/dqrLsP91uN2O3oScjIp4WPeWI2xhtuSGwBtwPx7d/TtVWSNV6JExAHy5O4jJJBzjnByR6+lVfQLElyRHGu/IBQlc/Pn179OnPtz0qmcRb1UbGIVcg9R1P5k8VYCfu2UDywuTECOnAxyT05B96oEYjZg/mSHIAJ3YPUFvzxWlNq5MlobPgUsftJYFWOMqTkiutzXJ+DsC5ugucbVwT3HOP0rqga+9wP+7xPm8T/FZJmlBqPNKDXYc5LmnA1GDTgaAFNMJpxqMmgYGmk0E0maBFe/OLObH9w15bZCRwXjzndhc4ABzyM9fT869N1Y4065PpGf5V5bYceS2QMttzIvHf2xj3NeJnXwxXqellu8jVtoyPLAZkLAkh8gnjqMfiM81pQzOko3lUO4fLk8MOuMdev0NZ9rKTFHwUhVuDgHBzkd88cH8KvxSr5PIB2sdpxnB3L756Z/ya+Tlo7ntEsURaOJH4l/djLKUI65A59vTvzTI0jEA37ZFdNpO5WZiwGB0GCAppYpArSsm44fPyN1AJzn2+bpUqyrDZAs58yMfe8wc8H/AB6exrKyYXY6N5JJN4R1hJ3DhsBc7hjBOTgkZNJK+yFnXZEFBXcTgO23I7Ak4Of84pHCMxSMny13ggAnOEC7uMY4PNPK7ZwkUjjLfKZTu7gdOSfun8DUu97DXcLguBJuzHuY8ycHgrgg854B59hSFJmkIZFB3kEB+5JH5kLn8D60hMqOG2rF8px82Dg/Xocv9Papod/2wmRjIVk3ERvuUDkfj09euaSs3qVsiITF7YvJIyYBwMgnOCcn6Y/AGnjcJ281dwAc8KASeOevGeuSexqumxlhQYGCgIA5U8gjOOvGPXr0oj2+Yp2r5YUHI3HeSuTkjjBx0FTfQdiYuS2XBYFwyjLfMec/Xnd+nNJb+Zja8YCAAABiqsckqVwBzjv75+igsswZ2Kq2NuWYZOwY4xz16H25NMhdvI3So7eWykf9NSCV6knP0xxRfQB8LG1uY227jGxWRiCTu6ZOD9DjnG4dKtsSzySAMob7zu64PGcZ7YzkgfjmqbIRFwfMKx5RmJ67gScnGeDg471bunFwkcseUZtreYWBXuduTkk59Mdar0E9xY2RWwCQ3mFnYDDAEcKD0zj3p9wfLysrly6kllBJXnpx9SAf6VBFnzC+1kDkMBnrkDkg+2OP5Zqw6OI2ZZlLAK7sAMEZ4OPUjv8AqetZtNvQY997HcXdZQcMcgnOevHPr19evNCRxcL98lTsB54PUnHGM5qFI2YZJiVVcE5G4E+u7jn35qULhCsY2hslGzjaMg5xjj8P8aEu4iQJsOwIAoOI1wSMc89OnA45pskgYqQYvKz9/rt5IBPPft+FVhhkJdS2WBJJzk9eD/u/h79g8vsuMkZckHa4+UjAPA7DA4/nRzIOUezBFJRS0jDepxs3Eg5wDyBjNRPLIVCD5FKnO4nC4HPAHAzgfmeaWP8Ad3H3neUnaqke/bsTj69aSIPyCwWMKU2hlIYgD7zVL1DREUm/eVfLegGCduencDJx6Uecizc7OBliQeeTxkjk+p9uwqZA0hJLs5KncCRjPB/Dt0z6UwRvtOGkZW+Yg445yAOQeeP1qeVlXQ5ztyzh5NpBBBJyo7+vWoSVWdkA3PncAccEYyevB7YwOtK3k+bvDNIdpO0sSBwOn/fJ9aaUXIJUOu7JVl75UHjrnPrj9KblqCRNuzlVLbhtZWchyw7Y9euM+h4plq5jZQqszI5zleccAZ/xJOPakIMjz7ww5AXCkN24HoMZ9exqDJRuYNp3kgcBT1Hf8vWqT1uFhSz2t3KQECNKQQc/LySOMdMH6fWrepRGCKGKH5ZH2/KDkbuMY7cU6K1MmprMRwDlCPoD+HJpbIC61QzAkqmXIJ4JPyr+gH45ruoU/efm7GMpaDdTZLeNYiQFjTJz3H+R+tYEe5iimQuVw5DMBtwTwf6CtPUpfPuWZCGUuRzzgAfe/AKPzqCOLy7pXw7MsY5VO5PBIGfT+VYY2bnUsi6CtHUkCSIo/eKdwzhucZ/wx/TvTysi7STtESHgtn07fiPyNSF2YTkKCqlsjcAB2wTj/e6mppJHRUUYKsSBtGS3TkZwOmPyrk5TS5EVkSIkj+IbAy85AHX261n3cy2sJaY7xnI4AyR8oIx9M/lUmoXEawhnPmIw6cZkyMcH6Dk+v5HKVZby5DyE7gQAB29vqMVVkUriKHvmaR+GkbbnHT1+vAP5ip4YWutQJIVoVH3QcfKuDjjgZNXYIUtvK/jMcY7dMqefbk/zqS1kWC2llynmsTtUgH1x/j/+urjYUpdiMQB7qTdtx5hO4H7wGM8/RSOOOD61qRSLa+HrmVtu64LLjHY/L/IMazUUshIAYk+WqkHg+n6AfiaueIcJDaWqZCx4bpnOPlH8j+Zrvw8uWEp/1qc81dpFLT4vNuUkx8rfK4ViF4bOP1yQPbmp5AzajKUKDJIBLctxt4zx0A/l15qTTIzCXkbJZVyzKoBJ/E/gPUAUlrvU+b85TgbgAxI6/j0GenWuSpK6L2Y0tH5ErFM55DN2JOeT7AevH6UXruFBYld288EHjGz07A9B/KpYz+7mHy7mxuYDBHfHTjpgdeRTi2yZN6vhUxyMk/hn3H+HesU2h9ShFZRmAR/LLLuBAGPkXPViSc5yB7YFDRvbrY29nIA2QGEoLq+RjkHAzx29auSL1U4MSEE/P8mQMY9zkn/HiofJKupBCiZgRggtz2x6Zx6/4PboO99yGNEjdvNtpSEkOZImDjqCRtbJH0x6VFp9+lys7Wk6lUH7xpBsYJgbWzwMe+PTp20o4wIDhVAUqXXHK5xk4988moZIV/eq7gLKuyRSecD8uoJ6fWnddQEMsk0gijiEtsxJDJIG743Z4zjJPt7U0XkAU+Yr2sinDDaVZR/e56jnPJqrHpsNuylEVbkFX3KmPlyvDHoen60/MongijndUDu2JVZhJnOd3fA4wAeKTcWMvvHHJIpG6TYRl4lw3JJODnjt7DmppcbiyxDAdigVuCeRtOevJz+J61hnzjDHIsVszSuS7tuj/HHJ9+uDj3qcMi3GxRIgj5DrMcADO4HJycAcYH8VFgsXyHjQGWdRuxtMo2k4HQt2HUdM5AqMyujgzEusRypDN8uGwOhweM5yfX1qnHeo1xgT3kUKttxJbHaVbHGdo7nGT0p0WqoWmtvtltHLu2R718sMFyCc5OQTwe/5UnBvYZYzE24+Sssbltvlkg9gOPXkZ64yPcVMjoq5xOJWGN24leBgMcdvlx29KjDsrsiTQP5mWbbIMtweOhOMDr7Z60ESSSSFYFKrlkKT47DGOB19frUWd7BoIPKWAEysVdS/RlO0Lkj8Tg0gRW/dIH3xoHRyxGSQDx+B+uKsSSSQeaPs9wMsWwsoIBPI4z79fUUea/2jzJopVDc7gCV4yMnB75HvxVcrTFcIWxNKEz5QfarE8k4xyMfN0z+P1qMqYGUPcSlRglpMALngjpyM1WuWjVZRBEwZSqriAlvmOSR79SQfSrbsph8+RHyB5QUIwZh7nqePwo1DYiiM0ICPJL908HGflztPPXqOecCl3SWc7bJTjhZI8k4cDqD7ZH+TRHcebZecsc3mu20GRCpB+9nHBPfpn09DU4DF23WJYKC5bcCpOBxye+fzFNKQm0tyIpK8wZBK45jBDA9R6dCcjNN8olpBBMUZP3YCyAhu3Xt17cUzMqsN1kV4AYtcYJPy4x16D6dPwo+0Smcs5tsISwZ5FOG4z79ifXvSs+o0wZYlmVcSv56jzQn3s5Ayd3y+3AFTSs3nExtPL5RwqxqG28ZIyB1x/Lrmqv2yWSaRo7m1EG7C9WwoBz6An7p9OPemS3qzLGvmvHKsmfPBVSRkKSeW9DjvV2Qal6UGFTs3OxYlAWMfQDAA4yO3TH61HPKqJvJzIM5iDhWI4yAOM4HPvVGHUI34l3R28TqqhVKbsgclsjs2c4HXrT5BJZ20S2tusk7uNy5ZgqZ9z2Hb8qWmwJNblpngS08lVlBbJzKhYJx04wew6ZNMUuxWcQIJmGfnIOCemMA49xnr6UjR4e4SGRo/MKH5VAbHOei4xx+H45p0WnRPI6vI84mcf6zMm3GOF3Z7np06ULXYCOS9ZboL9pRoowoEEcZd8j1wTgZIqtJc+ZarFbK87kFhNcP8o2sBjCd+/GDg55rVk2uxJOJdmHVRkE5xge4Ax7UzyBDBEVTES4UAsMZx/wDqPP8A9eh3QJop3a3d1btCsrQM+G37QxTGOM8ZwRg/UCpxFHFuZmlkP+r3tzuxnGCenJ/WrBAESg/OhUtjaB27/r6/hUUcucFSGREZWO3OPxPTkn9eOtTrew90ARsRYViuApYL16f5/EUCHczFmIdid2cHJ57gdOc54FPkbyvs7M4AYnA67gf1/wDrCiNQySKNzSM3GABk5GSf/wBefzptaiKkSsi+Vggo5YluNozzyOff1q1v3H95tJLblRcn5jxu9uee/FOQndks0pVcnHUdjgE8cZojZnkLq5w7ZJPfOMenfPbjmpSsAr/uiVEZEOSMBjjnIHHp1I9KgeSQxsQhAlbqXK56Y/TPfPc9aBFiNVkG88MWfkAnjB9TkDt9aaEgZkAd/mUHOMbcDGWPpyPyzQ5MaSJBO3mQIXUhT2yASPTJ6Hn6/hTZt2xVJP3d3zNngYP9f1xTCjK4IG3ncSVA3HPXAHI/xP0qSdTJcqI8OMHPTAB69jzj9ai8mOyQ/KrGoABZnLF2C4UZHX8x+dISiLEGbBkkDAEYIznnk8cmpJYHycSH5m3kDHBHQnv3H5GmwxmJVMe7Ockbg3y84+mePxP41aixXQTSrGdoG0M/ALYGPXn8cdafEZGWIlsDtgHAwvAJP1/KkSNWmCsQ7KcSAxlskkZ9PT/CpGbAlbZknIJBzk7QMdOSM/401uLoRJ89wuwgknKFgcnk9B+P+eKjgRhFEH2mUsMcHBznnAzn/PNWh+6kIiXqdp2jOOM4PP1/OmqSAC8mFXByTkr83Tt2xScdB3IY4E8mNlU+awXdkYx1xntj5hUh3jeGKnzT1yQcntjvUqHaqAybRI/yAnA4J7Z9McUFgfMCgqynO/GNpz6j1GfwFNRC9yMwuyiOR2b5doKdgTjJ/TjrxSRQ5lkaYq23OAcYB5Axzg+tP3uGLwqrqCwxnHHUjn36DPam73WPk/MjE8sCMjnuc8gc+n40OwaiyIRNKsTMQq7guR1wAMH26cU3yXVGHHzjYo3H889TjHX2FLHNJGS5+8x6FSxPXHP+P/6pjceTk4Yr1xjp0A69M4z+NFosWqIVjby/MlDDBH3skNx6f4+xqbzJdzKEDc4YqeGIwTlT7A8egFMSbDbAPm387gOc8n8wKkN0rY37sZy+TgLnqD19MemDRG3Rg7iiQyTbQS4LbTlDgAc/zxnnuealctJGh+d5H+6Acr/9cYx2pu+Mt99fMAwhfJ2jtxnj60hUTY80u3yhgVB+6MEdO5yK0i9BD5FIwu+ZsHdvYdsnGCR16e9JIN3TKKXwqnHIznOD05BP0pkaJu5U7SRsYqABzke+ef8AGnCNmaRFm3AZI3AbskcfhyaAFkSJUy67gDne6Zx3JJ7ngewxRM2xYyqSsQuNw4Mf+evTAx+YBMjjgsSQVZmH/wCvH19aa7EOVX5UVeQOWHHXnjpx37UczS2EPkkZ22YZEDDIyrZPB4/nmmxoqBTbhsSAjccnA+p569PrSRbn6KdwyCrN8w55OBnnp6fpgyeY02QQcspTjByehHPp0NXHV6iehWkcsWSAKIlUrjfyxHbjngnHPXPeoboIm6PHyjegJONxwO+OnGST/Tie5kKs42NuLZ4Qjhe2TjkggevWqssm+ZUXzWidm3MpIAGRkEn+EZA+tN9gQ98ozNyCGCqxOMjcDux3yPfpVcncy7+Y9hzvXdtUvzkj1/lSk7+qnb5mVI4wNxB547Ac9aZBH+7XzGR5iuUJUALuDHpjnGM81nq9EUlYcJMTMUDFghyFB3AlcYyB/j0NOm80zkqinLEglumCF98A561ImZWiYt1eP5t+3IxuOB1Jw3fnvUWWaKN+iMqoFEeMdScnHqMnp+ZqktLBdXFMUjTM7yZibcoKL9B1I6j1+tSbk3Mh2rvL4IIBGSB1HX1zUb5DYKMm4sShjyxAYH7oOO3U+tPIIdo3cqN6sPm3F8ZYAcenXpjFWtwFZxDJ5jZXcchW6rk4H9fpk01t/l7hu8kIU2eZyM4/rx1/nUQBit1CoUlI+clT12sMY5/XrTEcFwYom28Fdw6nJBznrk5PHOfrRdNE2JJkXa+4oeuJNgOepyD3+6Tj3FUrtB5IUggBl8tX5O7HJ9B3/wDrVNI0qNu+XG/aNp3ZbuB7EnPPp3xxSlQZ/ifOEDOD07nPfH/6/bSDSZLTNbwWxa4uyQwOB8rdQK6zNcl4O/4/Lz6DvmuszX3mX/7vA+cxX8Vjs0oNMzTga7TmHg08GohTgaAJDUZNPaoyaBiZppNBNMJoEUtabGl3X/XNv5V5jp0vygEYzkZzyvGOB+PvXpusH/iW3OP+eZ715npyOQo3AHkqWXI69Bz/AJ5rws62ienlu8jYHlSCJXj2S5w+B0XOCePf19varPlxOu1/NQBf9Xk55ORwfqDj6VRiR1iw0bSLIdz7DuJzkHtzjj+XHSrtvLvIzsb5juDqSTtxkDA6cHPHbvXystz2kWJISI5ShRom3biVwfvKB0+h/GpQGe4BbHlliNqH7oMq4Iwf7pGfbPHNRIWjADMxUFcssmFO1dxByf8Aa6deDUySeXCiu5JVcAKQRuCY5yv94DvWbsIcoUyx+YXkZl43fLsDbjgAgemfyqWAtJLG+8MQY2f5wAflye/qSMHnNQtGd7LBsiiz1U87QE/uk8YLf5FSyTeUrMoMcWHYE5JIxt6Yz24zU35Q32I43Kww7HJ+VFVAD3BbliOfuijAyJJCPJLIRvQfLyWxgHPAPT2+tOAX7Qf32+AOcg/ewABwMnHX0qKBJvL3gkW+1ETcuMEqB2UdMdf09Zt3KHo+yGJh+7BCHAkxjPtj8z3yMd6VEd0VccDavzfNxkr+HHf06ZzSTBpJZBHnL+ZtyN2PnGDknBwB9elPS2tzL5QBAEzZJbIYdSB69AP/ANWKmxVxS5SN2cknnAcZOd+emT2XPbr1qrMI/MyIzuWQsWwDgAkYJHrgjHTjnNTRoxKyJ5jmPAXdwck54HT1Gff2NSPD5cwYOrKysVyNx9/TuT0x6Urj2K/lzR7cyB0yUV1GMDBGD/eO7AGO9WLLe2mld0ThDgiTjhSfvdN3b8+vaoyihYgUaNlORkYJ+Ufz4HXpjIpdNkZJZo9+9gVf7/RivORt68EjHT1oWu4nsInz3ChQWmTCIzJvAHUZGNvOO5zV1bhIow4iJlZflI+YFR3z3xxntx+NY000lreW8BVQhYghm2kEE4Y9yTycd8+9bceFlLxkvsA+bI+7gZPuR79PWtbNRuiXqIrny40H3lITLA8d8dTyccfWnSkPHsLODKe7E8ep7HtyT6D6u2B5drfdQHClc7sE5P4g/rmoJ9vkfMFG85IGQq/Q/gemOaxk2lqNWbFUubeEvuWPIA3c7hjksT07cU64j86SJHONmGLKMBT06k/SoSXKl23qeOWXee3HHA6dfTAqRYfIWRMYCuB5h6ZBxnnt2Pr6VK1QxZ5NpKCIsZjuy3AGe/PsM9KGViUBJRQBuC4XZyB157+lKFbcN+8KVxlflKgnjjrnHemF1DA24UEHAP3VJzzzznPXj0561WgC+WgYswx5hOQ5APtyOn8+RTpuOSzDYA53cDvnPvn0pkkTPIoO/eD5nC8KOuPfP09KLqBYJFClvKCgck4b078dKV7LYBY1OGOQQQxxtz8vQZH4d/yomT/WBQ4JyuCBzjAH0+vvUbTZGHHysQyZI6E/j1PPrRlnlMYUhejMx+8SByeuTz0oug1HMkSAtkrtzsBAXA7Z9Rx+lQmMJJnO5gRyXbr16jpyeOtSMmwnYzncpwjH7vYZH4foRTrt0jwGdVQMfvjjPU7R+nrRYaZaiZltZbjeA7RiFSeOR0/mPyotnFvpjuq7dw3Lu7KOBn8hUKKLzTYET5C8udrrkY6cj8vpT9VKm0VY9yiQhEAx90Dr+o/SvUoyajz+RzyV3YxoSJbxkUg4VQAGIJDDP4nA/DFWJP4vIlC8Fmdm45IOABUgSKS5eQsu1AU4B7nr2Pbr+NLGVMLM6qxJwPM6EnnI9On615NW7mdKtYjuZRDDvYtKq5J2sOpx+Xtyf8Irq7aEM9wC0sjNhABukDHG3A7dCf8A9Ypt9qHlFLeJd9wW3BT/AMsz3z6dcdTVBYHU+bcsXuGG/kE9O2BznP6fiaENILaOS/kNxMQq9VcsQo9/wwT+Bxmr5SKKEeav7pxwmMNjHT+p+oz3p9qoKRIkZy77iSdoGD6Dt7CmNB50xWY7ixwxRcBlGeMZz15+n1FF7oG9RIIjLHLPM4w/zsG6KSMj26EfmfQVZjSP7Ogk2ruYZfbzwucAEe/NMusRxNIQWVSQCQR3/lgZ/wCA1OZiD5vlkmTk7gF+b+FQPoBxVJIl3JoV33AwADEPmB5wf8n9DVJ5GuL6SYu3koccdSAPfH/6/WprljZ2LGRf3snJz6np/Pke9V7eDEcQBZy3VG6gEdvTjPB9OldUnywUV6mcVd3HzSeRZrER87fNgA+gzke/XiocFoAGyMsRtPfqeDgjBGD/AI1PLgybN58sHbkfwenHf6+1SY8sxBy20AnD44+U5yfTOa453voaIbyYrjzZN2egD++eOc84x707y/lhVZWG0grxnaOep7cH9KbGvyMA2Q0fXBBHB/E8U9TtVCzbJFYA7m+53xyOnPUevrUrbUHuNihKt+9G/BJAfoMZ5J+o4706baAr+aTGUAcFs5wRxznHX36UkiuI0Qj97uLklgAOBx6Hof171Bcotswddw3llzk5C9OPbnH1xVbaILXLIbiVmCcHJJIIGAMfhjn3x1oi2lG2FgNuWKkqCeTgDHJwcZ9wKhjQeXMpYKwHQNhmHXPH+PbtTY4iNyws23goW/h+vcDqMfTrQpdwsSybPKEqljMPmynBznvj6cHI60GEeRGuFHJUBeDgk5HHsM/gadMGKBcgrtyFJYAZxg5J7enpjrQ0jhlkXcWZt4UHg9cAD8ec07IRCcPGzyKCrMCW2nnHJx6ZGD2zSmAJJKzEeYBhwRkfL0PIwAc9B6in2z7Rtzlg24hQQTg53EjjGCOtMjZSAuMiNQJF2hdvOeef9nn8OaXQAWJmhVDx0UFkBJ5HP5io5LQALKhYFflDH7wDHnp34FWSMQ7i+3ftI4PJLZxioScqQCvzEg8A45zn9D+dDGiP+zbby5AwQ7gMF4VOzdnHQemAB9etRzaXDLMpWOOGOJmPlmMAkbgT256dPw4qzM6mVpQcblHUlWA685xgdvrnrmojIxnZvL+YrufkEZIzjJ69Pp0ocgVxlrYx28paMIXV22sCM52heT36D3znrUVvZCxDeTcyGJ41XDljsyPUn9P9mrkTgwyAfNGcg85wME7skDrkf54pAU3KUDYZl5GUGMe3PXOB6Z6daOdj1IJIrprhpIbieNcMVRsjsAC3cnHtTrWKSO6CR3sphUAgO5IPsPUYx9M1Y3/IruqMzoFLEZK+me54PtTgQVWRU3rtVepI78Y4Hvz707i6FMW0qKMz3Dxxr8u1iucfKOePYjtwT0pItIiCHEksfnNkgOSVIHX26n8+atwvIWDMuCinCscsCAe2ePqfenlMScKTgbFDru2kHjBzzjjtinG9rhdrQgnsUuViaXDtHhQGQYPzEnC/5x+lSpbQANGkFsFRskYUNtA4H1Ofwpt0VckANgRfKWYcYHfrg4PftU4/1wVH+eQE4JYDB+voF6c/pVC1KqWMcQXblUHKIi4BODkcdsYHPbAxgU4WkQxCVXZkEllxkAk8/p+lSKeQSSWV9i4OcHr1574pxJTdszIrMWVV56r064rNpdR3ZWitRGVeUA+YcMQSpwOemDjgDn1qRFZSqttUsCAxHU88Yx14qSKQtM22QANGMkt0OAAehJ/z9Kji3pCDubOOnduT6f19PeiyC7E3Ewlgd3JOM/dPA7Dg4Gc+o9qbM6RxtiI+nKHjpkY/4D+RzTzbiORQWMp35UOMhQOPp3/On+UhhdkyNuCMHPbHOPofTrRZhdEEUrNcgoIlIIjGONxAznI+vGCPWrCDzZRtmKr92Ld064754GDnnkVCNjbeAScKW2fKWzk5wDx1/M06RtsyNJGBnlUPPBwB9BgdqE7bjfkE0US4eRTnyieueMcE44HGfx7UmUDmTaoUPuAA3bQD93A45prjPleaDHlc47Y7HA+v40scZEIDyNuZclSP5ntz2qb66B0FmJEibS2VODgj5jjk4H8sGkSMLHOvmszDOMvyemcd+305pJkjbYGlY57gjgfh7n/69LIyIpUScSE45IHb8/8A69LW7bGQwhkXgYbABdlOB2zk8HAx+NWcoWBZtitt5HTOd2Mk9BnH1I61GkaqyNvKSFMBT1x7n/PSkMbDcIyGyQwYt155Oeg/z9KNUD1FkU+V+8YLJjPzL33E5+uB/wDqohILEfdi8ssG4IJIzwOg/wAijc3lPjbG28Ip3k4KnHH4UseZH3blkAIOM5BA7kcc/U96aYdAmyJIllY7mBY7j9z1PTI5yf8A62KfMoZpDkbh0+XapIOcep7cU8bUuDIhwBGQMrndyO2cn8aCjK0mRl2dQHJzjnkD8jxn8abWpNxHES+XE+xJpMMqsduCMcdefT608SZQD96YwRhGbJORwMYxge/+NKipt8x42HGAXI6DJGfTgH8+afIqqu/GWZuN/A3EcEdegA61YrgJN8gXY3yAoHJwCwxg89e3P6VEULunmTOpZecLg88bce4yf/1Uy5EaiL5iJJlzjIC8jr6dT14701FTy13vgP8AMdnBJz3wB9fwqZS1sNLqidAFZnztDHO4/wAKcnJPfj3796ZAjLBF99gXDYQEDqOfrz1zTSmyUseCW+WMKdy8jOO/t+dPlmTdvbdtyAo5Cjgcnjk8Y575pIYIGM8RLyu0eAApIwCB/nsKSNt8w6IH+YlzgNk8+x7DGSKWRzsCb9z7mUZzycdSPr2x6+lRIgkVdzmQglduQM4I46Z6f40PR2DcueWRkRhvunYeuMnB6jgj0poRFkZYsHa2DtA3NznJ9qgiO1iAxGTglQTwenpjrjqO9L5QjuZGDyNMVBPJYDpgYx9R+NHMmFieWKOKTe8g+bnIwpJ4weP88U21TafNJcgthDgknByMcn0FRKcsWZfmkJ3hUPAA9foB+fWpDIobeRwc4dRk9fXt0z/WhNXDWwgDtIWYJ5SZO3J4GTnjjk+/rVoATYWTB5Oe+7jaD7iqomVyMDCMQx24IOTwcfXj8KZHEJHLBizKGAJPyD0wfw/TpTT7CafUnt4ljmChSWYZfBOBycD6Y/n0p5uGP7wo3nM24dQEJHUnr0B7+tEsUmcbywB84HhR3/AdunrT42f+CMIud6mTJzwMH9Rz9aqKa0ELcYliUuChXoAf4iPTp0x+Z9KIQ2ULPCu5gdin68nH8unHoKmJXYTu3R9zgkZz9e+e3pT5MhicS+avU7SBkn/9YH41ry63I5uhF58gUMqkgYVQDkHqP6flil3xqVkkA6bznrkkc/j+FNU+aNzrkjr0AUA9/wAR0ppKK7oMKOrFjjC9seg/w/GndtCsOYhFZmjMjbicEn5icHgHkjrzim+WyksSHaM7UCDAzgDpnnHPYfpSFceVGD5RYDCg9+h56n04/wDr1G8qnDKpGGO0DkjgDIOeDzn8e5qtAIrqOESNuCFdvlqWGVxtY5JPXAz7VXmIMjO52x55LIMKmAxHHtnnk+2arXFz1cP+6dgcdgOgA7+/aobKQGFTcMznIXaDzH+7OcEcbjk475PX1zuuhpZlggi3L7d7On3QpJyTjALZHXOMe/vUm4pI+1C0SnlScLwVGD6A5PGOai85o4gZPlY+WXbaz4P91f6gdOfWpLX5YovOUFd8Z+YdcZYjJOc8f55pLcAj3JjZM3llSuQygt/BgD+EdDz+VBjSOEAJhQQVdi21cDaMevIxgDnvQN8cURbcAFQkYxgqSxwTg+g9uRjmknR0t9iZYyMeUUnA3A4B4AwPw4PXNPQCdiilmTYdokBK4BChcnv165P4Zp+5Ys7sELhMAn+70H54zzn8KbMrGVkYZVWIGGJDNgAg5PsD+Zx3LdpLGQM75wRGV4BwQBjH+9+matbkgFyVztJC7Rkg7iDnH+1jpjjv1qOT5lIf5cKQCQAMgDkep5647UvmMsgjOfMxsJ3cgBeCP16flTRJtk+4ECklSflCL3GPXkdPQUK3UNQmVgjlUbDHdnuM98DjOBnj371nzSAP8y4RWypI3Af7Oc9if169BU8hZElEzsZpFG7t1BGPzx09aqyxiRmw+5vvAgkAkdcgdvT861jYlo1PBpYz3TNySBXVZrlPBpBkuSOc85znvXU5r7zL/wDd4HzmK/iyH5pQaZmnA12HMSCnA1GKeKAHtUZp7GmE0ARk0hNBppNAFHWj/wASy55x+7Nea6f8jRMCSxzjccccnk8ds4r0nWD/AMS647/IePWvNrCMuoUyMpY7hkfdGccnHTOa8HO9onp5bvI17VGznLJucshYjocHOT9B+f0zc80MR8kbLIu6Ndvtgjn6jp6d6oQtJGsJkXazAMGBG38hxyevf09a1MCWdXCs5iGf3bEHHJH49/8AGvl2tT2RQI2hX55UlkG3qPl3Ltzg4/u/nUzLJM5lQrNCzbuFIwCwPUe26oYcLdbJT5ah9o3LvLbMH16dT+VPmWZQiSRujEADYcZOzaeOO7Y/Csn2ASEMoAJzIwCiMMGwTuBx9MUQwSukQjKgOUPlbNrclSOfrn9RU8cpmQy5HksCUyPn55A4U9jjrSBwjHfvEa52KyliwAbHOeOMfj74qOUfMKWcNErb13AZV3Iw2WIBwOeg/SlGTJEwBMe5MH7wcAk8gHpgc5yfanxtsYD5UVMBhvAVgAoPHOM59ufrVLegUllMzspOMnAHl9gMetK9mNE0h3RqZnZm8tVG9QATkMBk89sEflSiYw+c4GSCxVfM6ngYwD3649utQFfPLCNZUXooJ4PAUY6+46Gq324wyBtmxGyElBA3M54IJ7Db7dKnUo17ZG3QRtJuK8jbjK/e5+o4HGepBqtEHkhLb2OSAI8HI6/598elR2t5FOsjq4XeQxySQCSx55GeMkZPTtWiPm8zycYDBtxOOmCpJz1O70zz+NDiwuVpkjVFMchK/MAuMgADkfTGP88BsZEdzFiMuzIyA5B4GGBzn+ftVmZXl3LMwUOoK8c5HACg89gOnaqtxnZ5jqsjCXeVGWXJOc4AwO/ueKXwyK3RS1kEWwdVAI+cqAAoxggk56EA47nt1rW0zD2sblkO4gjeOM44Gc46k8dsL+ObfsPNnj2fLIuVAHvn2AyRzg9uRnFM8LzSnT+SPOjfYQmCR1GcZxn863WsPQyZshZIydu5pASpUsRuP949sYHtx0oPyxzbnYnlU6nI+YfL/X6UsZVXPkyDDDbl2BLd8nr2+mOeelKxPmFQQ+Cc/NyRyRn8fxrlafQu42M5twjFiz/fPQ8YySc+319qe/mjhDt2gcH7q88cYGSBSTKwRUUq3ycY4baMceo7/wCNNA8yOPyhtXcNhA4brkkc5Pt7Ve2gt9RXVDNsLnMhD7WOWUnGPp1GBnmnny3LN821V+VmP4A8dOtRod8kZi2qoIVVclS3A6Drn3qSMhbcyFSI9uByNpU+g+vOOOtCs2xPQbI7hyJFxn5Ds43cnJxjj69OlTEhicKWHcLjOSfy4x+HNMXaJGG45ZhkjnPUkY9fl98AUxz5kW9gwwflZj971PT3PJ/Sm9EAhkEbs7EszNyN2FzyT7nHXP8AhURUGdWJ5jcttI7YPfHA/wAKfJHEZf3mXK5YcdQADzjtjvSJGvCrtVWbJZVzkDtn/OaxbezKVhvlhYmRbgmRgADt3HH0pI4WDgtuXncxc5J4wQOepx+XFN4KfuvnVMglQQenBz9eOpq1L5yQvwfOcBTk42846+35cnrVwjd3G3YtAAWZCHMhOxB3XJH/ANc1n6pMZLr7PF5JjiXYPUEEZHt2GfY9elXbTEGnGdQSsaF1XODnkDn8aoSxCB5bi/lcebz5fV5eh9eOa9GrdU0l1MY/EMZ/m8wqG4LFic7BwMnt1FUrmaaZAtsxKZIM4HPqQozn1/OrUyyXIED5jgdcJEoyc9cn178e340ssiPGiRbo1GWjGMZ+Xpz6E59ea812voboraZZbVikKjczfKdufoc556jjsR35q7HbIbuWXczW+Qxbfnfj7owB1yO3qafFAiiBQGUcNhuSSNwHXPXpxnvzzSBmhmO1SzA7QQcZ7c56AY6emOuaPUTbYrHZAPMONxHIJyMgdT7ZOe351XiaVpmLKYxGPJ2hTlRx7jg54/lSSyb5PmlZgowZABkc/wAIOf8APSpEg8qLDttk2DZnoScHJwOTwPoQaV77BbuPcZkiiUnbnOSmMkgAn6cfrVmKLzWZmO+NDl1wOW5GB9TmoooZpNjbt5c7Uj2jJGMg/nmrl3IttCIgSQgJLZ++epPvgZ/KumnG3vSM5PojKv5PtF+qMf3MZBdgOAT/APq/SpEVhOWDKzgkbum8AdAMHuD0Pc8cU2wt1aOSY5V2Pz46xqTjPXHHzflUkTmSQEMpEY2lMBscZ6nueaiTbd2VsrFGeNAg5cMRnnvjjJ/Pv9farLjbcQwxFMYxhV/Dt3xnmo+GkiK8FugAOR0J75HQ+nH5VPvP2pCnzDbjJy2Bnk84xXKaCWxYK5ZlxgqRjOMY69u38+OKgkBURncViCHknKkjgHnjPbsas2zZaNX3Mo+cDaDjsce359feoDHiCTbkfPuwOD6gdOvI9Kp6IOopfzQrNIAWIQBX3bQT0BP15H6mnK2ZYy2flBLYcEDPb6c5/LikD/u12yElcAKX4QE5HHf/AOtRtDniUMARtPf15P0J9/pSTYh0JTayHfhkA2hsnPvjufX3OeaTerW6GVnMbAg/whTnHHBH8RJJ9aewfyXVzKBkDJ/3m4/n9c1Xkgi8zZG+IirEcAgnr1/H9DVai0bLMzFkZ5see2RycjcSpwMY7H9O1LMEZ03BhsVm3EAY5BBOOOetU5I1kUkEqW+6zH+g9Qe4qULllZvlUHaCDjnOcAen4HqKOYdiW3yBNuOQ6bjh+eVBOOffr/Ko3EJZR3YJgAng9D069MUuTtKSHHPBGMAgcHPfk/pTIQx3TLtJwR07dec/j+NPm6Ct1H7P3CnOSqgkEgYAOeR/TmljhDQ7BIzqrY5fPQ8Y9ef0pZiUijQnKsvBbnuMZ9cYHamFWIKozZJOAegzngg+w7/0pW1EOkTbDKrhjD5I++oHO7qf079abPGpnXO3/VkdcA9Qf8//AF6YJ3MJX5cZ2goc/nxx/wDWqxKc3Q++FK44ILdc9/r16UXVh6ogt0RvPJ2LvCtkADggd+n5VEIlEMJBPBQnHJ6n8hz9atRHDbejleM8EDA789KiJbydzOwDAbTzjO/rz/h+dFguNMZUDLBl+8WfqrZ/I8j369OKkEhZXOWYKTjcc7flPJB557fX3qS4X/SVEhOTkfMuARuH1qJUby33qVLbtpYcngHv/LqKHFp6BdMXYf3ygyiMADjjHy9fXOBUco3rGSWLkEqCc4wRgYHbnHOPwpRKyysAvOOMHggLzgD09PXFDFhCqs67iPLTAJLDqMZ+g/yKXSxSJ5Ej88E7GAhO3BJPUHORzSyS4kkZ8gqxJYHGPlCkdce5PODTJiryRRsGIdCFxjnpx7jntQiIwSSQEtv2gAKUznoD2HJ56ZFaXd9CNOpCYxkGMn5pc44wRtyCBnjoOv8Ad96s+QvnmWXecB9u1gFx1x6dPr071GI9iqRkblGW4GTgjnPOP/r8UpcmWHe2S5YkOoJ7D19z7d6nV7jb7E0RUuNu1GI2nnIxjgfo1V3IMJZCobgH/Z5z/nmnbwAWRmZFOAQe2MZPt/UjrVcNvhhBflSOwAUfqe/f3ok0CRYuN28ZfCsuM5OByMfz9+lPRowsxUcMCFwPmHTp+nSoT88wxK2RyCR74we3Ix3qTywvmbZDhuD0BbjAx+I6/ShNti6CGTeE3KexBYjkjJ4z1/8Ar0Q+YyB2O3cRu2/w4HY9O4wevWkEcAiC5BDEE8gBRwDk+nH61KQTLufOSSoXePkxz1x7/wCetNeYehA5P2r5TF6kYPBOBjpx2FIxIcY6ZCITyMD09eg/yamiZHmjJIZSpZ/u4J9cZ/Dv9e9RW0SiGLqWYkkgk47Yz+VS4sdxsjFpEAOxvu5YNnGPb14/AU+YkyAMhOwAMvXqAO/PYe3SkE7FpNqhVJzhjgLnIzjp1pzrvjUKPnRQfLL54yPmzx2Hr2pIYCUKvmPHvEhMiqDnPTjHfHr79ahlfznG/lmY5+fkY5xj8D19xWgigyMoVihj6h/XsT3PTmoBbqhyMlsFwEVRgjA5PfnNXKMhKSEwiLIZGLMoZUDbcgHP49vy9KURKQBI+Fy24gAZIAA6f71NypWXDDduAHXAG7+WKRQjyrtEXllCxBToe/HsQe9QmPUSESsVkO5wUycLwRzn17/zpkbTMu7zGIBzkZ4x1GfUk1KMLtwh/drnKj3I6ZPvTIjIbeFcqCWUjDHJ5/8Arc0uqGPTzGkba29S5+7kA54Gew6fp05pxiBCfOWZ8BN2CQc9x+A6iovMk+0ASMhdCdwJP3uew9zmraSLEx2BiFb+E53YY5P69elXG3Ul3RDFGNobCFdpXAON3c9vT19uRS+cJEzuXDEFhjI3EnOO3SmLPstSqljKpIypGAcZ5H4/oKiV9tvD+8ZtuG3F/ujjgAcnr/OpvHoO1y0bmNSNm7yiu0KM7jwSAfwpgLEAEEKX3H5O24geuRzn86RXmZi/3sscbX2qOOOvP4ev1qqgdgRkMgcqMEEkkk56dvT1NDkNRLO9WRX3ABuTkZILcfU9R+HeiOUCcBlIC8qMHPQDAA//AFVFJFuSXbKWV2yBkHO4gfz/AMnNOigCoZPMJDvuwP4QM9vXAP51F3e47KxEHXzGCPyxD5DfKOOv64/KpXmMb4OFXcXALbQmeg4zzU6QsZld3WNDu+RiflGOeOO3X8ODU8dttj2qmW3MQWGWc4GG575/nVKLYnJIpjzGcgAg9GUdCxA5IPWnweWf3srGUDacH6AemAMk/lVoWStICNjfIHBbBI+bOPw561IYY1Xy3YKCQ+zj5Rk4JzjgZ6+1Wqcr6i549ChHbqboeYokTcSAqnLHOck/4+1WIy5jbABkQbgcgkk9OnJwM/lVgIrMB/HkoEZhlVx1Ax6EUnlxKreUwC87do52gYxx1yfSqVNolzuRRm4iUySrwflBUkk9cEk5x9OetWC3zcksDkImMcfj19fy+pgOwHbGDkgFlYZKenUYHTHvmpD5UjRSo4QgZVwCM8Y+nbmrjfYljzG6sfL5UnJRh/FnIOe307fzQCIykKpkwcKBz3689cc+uKR5tzFgThjiNV53H1469D3/AMQp2TTKzpkqBll5wewP5/jkVrZPYnUkWTcJNpAY5xj068dc8D8xUBUhsvIcx7gpJH54PPT+tPDM2VXCsx6HkoxwPpnBHAqGUqFzsVVOUA2j5jk/p+HOfpmmtBJjNqQ3AO1E2x5AbJxjHJPt6Cobph5MoLLnYTmTjP3sjGOO3b2pyum85wP3YUkn5lJOBn17/l71m6pc5zCrEiRfMVvunB/L/a5PeokkkWtWMXzGHzMpAkUE7FIb5Bkk9uCfXr1qCIRqkO9wpIVzGDkp24J4B6fT8c1XmkaXcWYkF9zBWB5JYYUeuAR+HvirdnbusUWU2DaE3+XkD5v1O7pn09qy0NS3bRxtaqxjVnVSSDlgg2enfHTsOauSSqkcikMzSM7cHBJA5Pr37DtxUUixhBFHuAdjkthckuOnfPB5/Oo5G2yjGRCVc/ugdrbjwMg+3PT1qr2RG7LEIQGP5VVUZf3wBwcehPsfwLepqJZuPOiGz5VUZJ5HOME9OmMe9V870ZWEQkkKctnJJHzAr/dwvpTVZ/MJeRgV+dCzFRtHC/TjPp071PMNRL+5ZImy+2N14cgseXBGCevGP04IGKWJisxCLlfMAG3BAGSMcfU5H40kseJpdgyd2wlgSMLjPc+uOfXnNR7f3Q3zyjEas4zg+mOB75xz0FUm0TuMwTGAXbywhHKDcV7jJ4xzgUpMSb/LQYJLDH3QFBHHc9ccD/GnMoEeFVY4yW2tnGPuj39B19fyLoZkH8Ua7t2X5/Pj0x/LNNAyrMdihC7FcFG9jjAB7dAM/rUFwzSN90jaAoBJ3HGCenT/APUcVdnWNfODqoUcLyMnGBwOn5881mSx7l3FySwOVQDB5OT6Dvx/k9EFZkPU0/BrbprwhtwzwfxNdTmuV8HBVnvAvQYGc5z+NdRX3eA/3eJ83iv4rHinCmCnLXYc48VIKjFPFACk1GTSmmGgBCaYTTjTCaAKOs/8g25/65mvNbB5Hj2rlX5yM5IA5zj06frXpOsf8g24x/cNeb2O3CecBkEEZB6ZPTH+eteFnW0T08t3kbFpkbfnCgZyXPzKOAeeB6YIz0+lWAHh8wTErg4jA5GT7Hr1P4VWt2PmSFkbBYkpjLEnjA444zz71ehuI5WUliMshJJJzjHPX0J65r5WR7JMHBtn3HyopEcD94eAQFz7nHPNSrM37yQk+UzMQ2zJON7YyfoP0qEbEhw0Y3hATuHQgHoOuPlH51OIIeUkiMnOOcjHPHXp/FWLv3BWIWSFZvLYMQpwXzjIyFOc9chDxzTo98oCBonHy5ydoz8vfA9z171J5DsI2/1nIKqr8DlSOnX/AFhp3W1M8jn5UztYD5cgn2JPT8utZ6su6EJmihwMKWHyqZA+Mknpx044+g+rTsAJdmTJPJXqfMXHJJ7KfzqYKAXb5hlmBZ06Y2gDj6/mQajIa2kkEJ2lcgFechR1Oc5+907/AK0mmnqCIlfZGCTvQOrFgOT87H+Q7+9Z91FHKqosZRVyD8o3YUnOOcHt9K1HkV0UMxEStjPU8DHOcY5Y+vWn+WsSjcFkyUyjqOpbB4z6fXAx7UXvsVscVdvJYTAIFGMb0DD5BjH3sHjBPfv7VraTq2VXzSWiwrEfdycsCCQfVTg9FGKn1PSzPAqqY9u31YDk56nPGAfc57VxrRtp94oCgK5Gx35BxxkZwP8A6xx3roglONnuGzPVEm86UnEq7fmBSQABV6fMe3I/HpTJow6sucr5Zx5Zwue2Pbnr7Hp3wtGuPMtmeNn8vKb1Cjb3GSOSBx19Bx1roDIJmimlAy4BkUgD5RyOOTjOOp5B+tc7bvZitYzJf3tusqM0rABAwUck9fXnOOvqexrN8OJs1O5tXzsDBmyFC5bHQc8kjHbp2NTS+bHe3cbSKqliUU/eBOQBjoe3p196yoZUtvEytDJCsToAoC8Zz1HHpx37100Xe6YpI7QsiQyF8Mz8hk4UEdwe2MkdOgpJJi+4NhZGPrtBAwd2TkHjnimyBQh8uQRqoIy+OAcD5T+Hai2V/ssa/K8ihQytg4Y4JBIHoOv/AOusZb2Ql3JYVKtsZgsZYr83Bxx2PQkEflUcUaj5du7ByxU9VxwM9s0MBhWJJBb5S/BY885HOB9PftTpckybjjcQDzhug7evFZu6eo9ySSRYjJMoAUkBto6+w7Y4/X61AbpjPuj3AYOGKcA8dMdRn360ghEe77QQS52Bm/x/AVIDFIf3bfuwOmD8rA9D+B9eeaG5BoNEw2tCJPlBOMNwFxgnHfOB+tMKjcpVmEu0diQx6YAx1/z3NSRuHcNlRGoyMjOADkEjOQM80mQqSMkZf5vukdPTr0PDH8anWWrDYTyXEgxhAVxtGCDzj6Ci5jQZkmchgQA5+X5iM9OnUfjxSFvM+R/vMSMFvvHPPHsSeeKnt0+zszk+WpBIZjlh9D7dv8mnGHNsF7BCoihUt80ODtJPAPHGO5AOfxqS6g89SZG2wjGySQDPXOQPU8UG5EZ/drvOcGQ9yeBgf/q6VFGjyajCsspZ48yMRglRn5QBzg8c++cYrqpqLaitSHfcnubiS0sYzZqQXHyBhlzxnPp3/WqNpC0m52lZ2mbmQ/Mc54APfgA9OoNXtUjTzSDkgKIyBzyRkAZ9x1qpcOXRTIcYQkyLzg7RyMgdOmf608S/eavsENrjA0QuZCc7SNreZyAcjPPb15/+vSGdPL3upIlbdsz6kDHH48D/AAqNY1Koyx7C7ZXapB6dT+BPp2qSTLXSoHfczPk5BIOcY9B/n61wudzVIn8wA4VZcBSHVSQT05IPpkdeKgEgSFmnLFWTJ2njluMc8nk/pSSuiQs5GGY5CnpgY4xgdAAT/TrUaxO8avceV5jPlc8sB/8AXznGPSk5NhYbaWjNGJyoXcwLBhkhgc5BwT7dauqzLIpx9wYGRtKLkc56k8/WgKsQG3KKAAqghV3Y68H6/wAu+TbtYiqiaccqxMaHAPoT+GM+g/GuihScmRORIm60RrmUlGYYbLfcXsoGeCRz+Xc1kXUrTxoiYbzQFAB+6BjjP48n656827396ZDMzqEfLbQcA/5HXvUcVuIjLNsLADAULjk/1zn9a1qT5nyrYUVbUjul8tBDEvzDAK7vuYHXp33fn+qP5SmNXiU7Ru3soOOefX0NIAJJQXDPty4Jfa3pyR074FRl1WbdsaTccJtBGflA/H+XSuWUryNEtBSUFzkkKd/RTjGSOp6UblM24qGbDEszA469+M8Z6Uit5TbR95S+W4IJx3I/3Rx70kkhZS+7JKtltwBOT2A+vUDvWXkUCxoW8vMw2kZG5mA+Xp/n+lSSkeXMA2FJbgED9O2cGlyd2ZA5kOMEkDJ2Hpk/mPT0zTJW8x1V0dSoLkbcsc85+hJP58UdA6iwojBFZ4m4xg8Ac9PU9P8APauibWKb13M4whBwR9B2xn6DNWjOyyruWVSVDEY5HzZGff3/AEqOT/pmAQ54LnAI5HB+uM/U1bSEmyF5JGMXIyeVLnhuc9x9QB7VOpZn3BlKgbSd2Cfpntzj8aQKWAMyBpNuOB/u4yT09O3ah1ZpC52ksTuyM7WyM9f8kforASjcrbgpdSwwNxUcLwSD9QfWo42JjBaSUewIxwoP9Rx+FIIULbWUtJjrnpkfePP+1TQEDEQ7fLVSVTg5GAPfHTHPvTuw0CeTYw/eFBhiyl/lVcHHOPr+NOS4YqGaT92MfwggkAFT6/hTZUPBDrtAbjdnP5d+DREnl/KdpYpw3AIyBnPH+NK7b0CysIyyM0LK5X584BJPBxjgdenWpI5HaTdIzeXu5GCcnGD/ACPXpz7U2RJC8RJYBue7Y5BI7dPT2qVNoXnbnKnoBg5J6j0o1QnYg8o+UMIV2qpKEnj5sdPTnv7U7YEXDFC7DllQhjngH6jH86Arx/ePysgCkZx97/63Wp7nmWBZCwLc4Hy9CDzz6k8UJXC4RH95JJtxGASB0A4A/Dr79qrBAbdAHYE4YADAIyBz+tSWxzCJgqDcBk7cgEk889cADn6VJhRG4bcF8sYyfmJ3YBI7cY9etULZjVZ4Zld05RcEKpIBAyf5YxU8EjLJISNzAksN+dpI47+g6/41ExIkjMo3fKwKnuN3Tr70yEx7pZG2sdxwcdSe/wDOqTaYrXRISAkrkNwSzOzDgjP0PYH8KJVLmRghPLNjBz0wAOvPGf8A9dQ2qFYAWbq2A20Dv1Pv16flSZRLwbNx5AVVfJP16+h60r6DtqLJBFDKMDG0lyBwTxnHXjofypkcAE6iUhCWBIZjxwCMHtx3q0w4ZmkU5JJGF2gsARz29+v+CZaRlJD/ADMCMKATx9eR9eOufeXHXQabKZRVkJOD8/3QDjoCR69vr0qZ1CSRfKMAkAjjJ4B5J/z6Uzd+7JVmMWVXcxGGGBn6gY7/AP16kud3lIz8ZDH51PHT3/rStoU2NAykryOM43MC2c7gOADyeQBnP40FBNGxc4IGFBYZ3EAjP5nH1/Gh5ctclDtXeW3Ark9D1PfntTgrLACsgQ8HZ149+P0PYepoumtSSCBXO7j5hkHcmBz3J78D65qdpGExG3JJDBck89s8c5OTk+vapLbMW5SowuSwK5Odx5/Sq8QcQkg/NIcqo4IwcZJ+vP8AnlxVloD1Y65LqqkZ2qAMOwJOeffpnH406UN5kUJGSVyWHJY8c9OT3zSXLs0hYMWy+P7uOThevXqTUxcfaXy2FWMfvB/Dzx3PP50+rDoRbUMhlVMFeCnfOBj8ee/rQMrGuGPlhDgkn5MZyTx9OKTDKzLnISRS53cLgDOM9f8A69SwkeQCWLK6Asy4G3g+v8/ehWvoHQgiyXheRMFflAZBxzncOfqc1PI6OGaQEFwAqhSGAJxgY9Mfme1Qqm9sPGGYpkjy8n0wccd/59qcF2zkj5VZcAjPy8A+n/1ulLbQe4onV8naSMFQwjOeRwOep6/rSxfNPJKFYKAMggHb8vP06AcVVjVfLhQliox/ETtwce+Bz7VIyvCNxAaNifvAbs+mO/AFLmY+VDCAVjUvL5gYbVBxj5up/KrIddw8uWcgjlj/AAdCe34flVaMt5fVFCKQBuwCQd2cDkevbrU0pYbdyZXazbQMsc5Geefzx/OkNj5W/dgNkAgMQwI+v0696b9o8tlbcyxqRtBY/MFGQccZ6/pUm9t85AWQvklA2cdCPbH51FFDkIJGIAI+XI+VSOW/IHqe9PXoTp1AMgl2KWMY2kAMOTwOfXvx/WnnErIs2XZceYCc4+Y9fTJ7Ux4JWkBIT5Om4dRnpjnHY06U4jDRAsWbICsWPXPbvgg/hS961mPToOdI1Y7mcKFIRiuMc9vTj/POadIoR9+x5FZwQBkdNuB7n/PcUnmTGNiFZA0gO1jtIHfI+lJ5kjQx5LYXBJBDZ44J9ePp2qrRuLUckiNJIeoDHzC4yw9D3IFIImflMclfl2kZ6D8DwandSL04Q/OmA4AIHJ9eP19KG+5ukJAKIQxUnODwO2f/AK9PlQkx0oc4Xco3DY+6QHByMf0PpS+WR5inOMtt+XB6cdenXHXvSnO07125UE/KBn739f8APNRXMmJYowrMru4z15wDn/PA9q0tEnXYWSVSwUKz52swJA4xtJ56fXr7VCbgRtFufdKsm0HPHA69OeMD8BwKiTeckYCozQxgKCDzxjk9Djn2plyqvHIFjLROWkO7gquME+g6569u9JJsegsmoi3Uq8jDdyqgEsBwG4HfPFKNQf7QiwBv3Um2U8AfKMnJ46HHI9ax7mKYLOkSyx+ZmQELkD+7jt/Dz0rOvDMvmJOGAYMgUDbubAzkADOMjrxkZ5q1HXcNDpVvhLE7rOCsa/O+ckk9W68AA+vPt0py3piJXeJjGzII2cABPcnucDjr/M8Rc3F1FDEgzCFYDafuuM/eAxg429evA96zv7TuI2CiVyrE7mBOCepOMY9sn0raNFtaCbR6WL4DFuWeJY9r7nwzHpxz0/8AretWYLtCCQolLZKGNsp/vegGCPpz9a8vTWZlVBHLhUY7FbO5DnHUDrg9eB1+lakOtuGVZJDCpG1htDbiDg8sc+o3E9uOlV7KS3J0O9W4ilT98wky28NFzvUDtj8OlCzASlYwMtwpxjaOnHtgdPY81zltqQMMbyfu8n93jlQPl6E9QMfTnOavR3om8pgpEbgY28/MRgc9ScZ6YAyKmzQ7GlgsSRIsm7cqsccH14x7e/Xp1qK7kWSSOMu0ZznHTGD057+3ftTZ7nEcQUbYwASwAABXoOT27+naseO8Xa7pOHRjkR9eM4HXv+GMZ/C+UlGsj4glKRZ7Aoo+Ujd6fUdOhPXsMWZo3iLIEyziRscLkdEyepOR0HbkU6+uXjXNySSuSQhyGJ5GMfQjHPT88uS8lkk+SRX8sNEpHLEHPzHHTpn+R7VMkaRTL1tva4Kop2q5Rw0nf+eMkjjFatuykAEbjtU7FToAp5J5OM9vpmsvSbfzVA2tIAoC7vlAHUNnsM5Pv6DGa6D7OkQITZGrRheOC3GevH6VzSdmWxq7owh+ZUjK/IjbgNsZ6+nJAPvUPli1hjZyXlWEZDHAU7SMDOAOT/LpxVs/NkhQrMcbWXJ5Yds9wp6VSWeON4pAAd237wK7vnBxz7HhfrTi77ka9CQwIIJQjbF2uCwYFiMAcE9O/GfenoNtxlE2fOp+RMMCcc5H4nOMfrVaZ/OnEQdjDtcGQlX5LfNgHgn+XSp4pEhuZJZMBVZygkwMALgH5T75odrhrYllchgN+4SLwMHJ3PwefZfWmmT95lCsgzuwik878jA6dB3pYyI1PmcKWTcS5UsQh456knrQJGNsiu4xsRQ21iWbaeF+p/kaV7hYdIjguCcblKkEhmA3EfMT0HT+VNdSxZcZBDYIzxyc49f/AK/HHNADZOFAYsxCtnvgbiP94EdR149aryok0oR5X8tV/g4A3BQOe/T/ADzm9BbjZBErqrQAvgA7lIOTzjnvgN/LpVOc5xyTGo4c9CAeee+SOfw9RmzdEqSoXeZMsiswVR6fhgk455zVLZhQWlHyDduB+72yCPcf4YFdFLciWxp+C+Vu2JDEtziupFcz4MH7i4IGPmHFdKDX3uB0w8T5rE/xWPBp61EDUgrqMB61IKjWnCgBDTCac1MNADCabmlNNzQBT1fJ064x/cNea2H/AB7sGXcSCMqev5nqMfrXpWqDdYTjp8h5rzOzABGQoYcgMoORkgj6H/Pt4edfDE9LLd5GxH5nl+WUaN1ztTcMZA689ePT1H0q1Gjwyyxp8+8YZx8vtj6fh24qvGZ0X540YAl+H6c5/wDrY74q3JNsVSqDDFirEjgnjPqOc+9fJzPbRZilyodXUmTIIUE43MDk5GOlWBJhzIuN20uSTgZOcdO/z/1qCKUtPIW253kHLHAwvHHfp3p6JGIo0fLKNpzjGfkz256qKi/Zk2HzFVXcykqucEfMThWGRz1+QfpUcJxKCiwyfMirhRxwO/GBnP4EinpHEUJA8zKL8xJ689Cfcn8PpShlwZLgK8SEupVuAFbcBnp0bk+n4VCZew7zN2xbd90TKdw3NhctwSfb6+noKdHMHZljIYbsDngfOe54Awvtj0qKZNp8p4QAhCkyyc/KBk/jhvyp4R/L4RAy5ysEuG6KuOB1yTU3e49CoYWt0HlqzNkOq7c443AZzwME447e/EguWlc7w/zksCwJ3ORgkZ47jnH86nhdpm3Pub5l4BLBSQQQcHjI9c1WikV1jRm3P5a43DBHzYwQOew/ycVLVldFBdyxLJvjlCDBKrtxt2r8oH4Z56/lisTxVpxvLR5mHzBiVIBznsA2c+/4jmuk3RTzfPHCTuYnPB+8Mde/OaS9toiJkRBtf7yoMn7xAA4x/n1FOMnGV0Gj0PPNDuVilEc5/crn7zbfn6Y4wfxzxk13mnzhGYhudrHfHwuB/PgenH5E+ea1anS9Q3rl14yyHaG469CMfT+tdPoN+jWsMmV84BQQeSVC/ewenTtjgdOedsRDmjzoa7F3WJHiurK4PycdN2c+vXtnAzu9awr+QR6pZAORslKszhsEkDryQBjHGeMnHQ43fFMazaeJSiiRP3mMkZ655PPoe3euW1q482zEoVXeIIw5+XryuSeOMdj149qwuthS2O+024E0Sgpu2sC7r1Y7hg9PQfhU7S8BCysc7gB/ExzhiM8Dp/8AWrltGnZeTucsQSisAzdOe3GAP8a1S0TXUc83IzuRhnLcDgH2A4B/xy5xaehldGhJJDcBWnciAgE4zx6D+vUdKf5jKrowLM7gttyPXj6gfpkis2S5RHld3X5nyVBIxnj6jHHP19akjlaNTIcoduXjzwpXBxxjgjPNZtJblFre0sisxJG3Ln7ygEg88dcc8c9OlA2FWMYbco3CVkbjpj9ADVaOQRpFtbdsYuA4Iy2eQD04BPHA59hU3nblWRYXkXADE4BYkdcdzhR/nri7MrYsCMRu0S78EjHcEdeAOcY49vzqUqpmVE2BWHyCNckZ79OvXtioystw2DID1ZVzn5srwT2/xFTOiebGzMCrZWQZ+8w7k+uQ3+NNRZPqReeFiAtxtOR15P0x+v501iST5m8kKSSx4HuPY/16jNWCoWVmlk8qNW6MACT1znsT7+9KgQruCPIwRVyoK4z/APWpWlezY7pB5TGQRhgrA8kbvlLZxnpgc5x3554NXtO2tcTTFSkUYyOO2McAey5x3zVM7WkgEqp5IO4Ko+UYxnJ78/XvwealkPlacEUgNO2cZxwMdPyH4GunDWi3J9Nf8jOeqt3Kzs8l2FwpflmVACdx78njnP5VCIgtzAoZlAUYY5wTxnJ/u/l+lS+Yi3Xy7/lAVmx1IbPB9cEfT15NMjZSxaLb8zEKG6Nu549sj+dc1Rcz1NFoRwoQ5XyeCOAeMcAD65z71YgJCmZmJX7mNuMDjHGfX/OadbOEkVmbLKCpDYXsDx69z/8ArFQpKoUASAqzb1HPyrnocdjgY5HWs1FLcbdyaWLEI8w4YEMoYED7vbODzjP0oXO4+UUJJJLNwB06EcAc/jUYlRBiHegVcj5toB98jPGO2T61ZSPyM3E3y8koo/p+Q+ma2p0uZ6Et23HJGIwHkUg790achi3AH4+w4/lRe3TRI0xOJW+VQCOOOFHPsTSkPueSY/vVUjp8qH8/r+nrVaeUPJAseDsBfcTySDz0I54HXpn8a3nNRjyxJUbu7Kx42+XhgdrEMGB3Hn5vYjAx/wDqpbo+XHHGUYt1ZByST/I4BP45z3p+7cd7n90vIXcQRwMEKM898n19qZHIVbfJIckjABxtJJwvGTiuVs0HDe5lbMuEJAJIw4HBx6cYwB+dQSZaS3Z2Jmk52sR6A47Z7/jTAIVTbCWVWbdkt/Dkk9D9TjrTwETZJtU7VYpGQucflx9TWd7j2Ekw7bUc8M20sykKTwc9ug6U8QBjOTIzFiCn8JJOMkY5/wD11IqK1wFG1eRjb91sA8VHCcYK5YZ2/K3YDrgd+nX0H0peoEUcO2OFFLFm2kk5O0fyJJPepIgfKGSgOMs45wQMAEYxj1H500JtiAZjuUhNvHGevJ64wKWWPdchXVyWJzlcE4PGQPXHei3UbHyDYirM2xmKkFm+6ckHnoOvTBpQzK+drDA2sFcMy+gJI+tQeT+5z5Y3bMlsncx74PXAweRUtuAty3mFMqQeQRzt7DoO/WnfUQ2L7hXB2kELgfebknpx3B6/XnBqW4DPG+1weAQwz1/DoeB9Oagjjj2RuxyRJktu5IHUHH0PFPLqzD7QjMeMKRzj8+D3z7ii6sHUcGByV3EM29ecAdDzn8Px/SIFYSroSpYhjx8oB55P49u36J5cQ8hmzuXCk7sY/iyP6AdOelTyFN6+b8shD8HHPOB2p3uGwzzMrvZsSFvu5BC57dOvHt/KiVXMYDKdxwwG0Etgc5x16CiKJVdT8qjI3dMngHn8R+hpkUW5y20D51BAB+VeDj2H5daOgaEVwqxTRjLcHAy+cAdOMeo/QVPGzfvJD5RCn5Mt0ySMY/PiiJD5ocMViOR97HU5OfT/AOtT0Em3OSV+UsAcMD35x1xg/nUpO429BscbiAb23thcKFH909/rU0gKyKsb7TsIXgHPXj/61VXVzbbwdxx3YjbzjJH1JAwPelnTE4JVAGxknjkjAA4zgZH61V7IVrj9qhcFpeSDgg5JxkY4yORg+2aNoNsCckqflDNjGBnkf40kLl7mVkYFGbACttUsBjpnnv0/TrTbd2ezRWb5A207XHzc4z/k8VLB3JhFCLkFRyobHOFXkHrn3/WnRRECTDBd2d3A/u5A/X9fwqK4uDDOPMOJWVnIDAY6DqffHPtURmcRAElmB6Bs5IBH4dO/p707pMEm0TkDcGb/AJabshhzjpnPX3qO5DeYzKWQFsFnGDjcOQAeMEfrSq4W4hf7/ljBYnBJIA4GeOoP41ILhXLfeMWeVAOODwCPqe//AOprlY9UISjPt2xKFkx8wGQPTGOO/wCHvUezayGdVwzKTweePwHI/wA80vn7dyBHPltx8uDwM+vr/M+9MjZw2WH7zeMlWyW7fh/9apdg1C2UfIZGUFmUgEYJ455/zxUWcbcgAbgQeRwM9Pfg8VPG7GPexycdVcg8cYA+mMfSkjDjyi+FEfCgDvjOecUulhiksrSNIQSNxwTk7uB39On0+lSShgYeobkKGGeN2eBn0A6VDMYwm9cMGf5Tuwo6EAfrz14FPcDzLcYAUDghAvpjPU9x/hTXYRKSCqo5+ZlwokB65JwR2x0x6nvSQyNnKhmUE8DJBGT2zjoQfwqONleaSRc+VklgpK4HbPQde3T8aZCSzS8hYQcnbg4B6j17dBjtzVJ66Cew3dug8zdkkg4IPXIJ5xjn+tMhlY/OcBwQNh+nQ5yD275qaSNERwY2HmHcADtwvbk454x+OBSplIIT8kfI4GCeR1znH6VFmVfQgaKRmMQJQ4Hz7xluM5/xqySIlfG0MFXZ8wGAR1zyexPtTJjtdU5QuC5VjwOhIzz6/lT5VMolVXY5cZDEKMdevXHbt+FOzQr3K8Q/0aIkxMzfeIboDjqSfTtUsbAXO4j5h8pUtgk4zx0x+PrUkQ2kb3Y7ExkYG7jp9entzUQjZJ5g0pcbd+4YyTzxnHQUWe4xCzSBSXVmVh1Ytkdc+gznNWfu3B27m+6Qd2Rn2z079D2FQy/vWdweWbIGfu4Ix9TjNOlUCQjO47SQ2V3dhkk/l1/WkgZGm2JmRNpJUY3AAAYxz7Z3HihYyLhS7+Y+RyzgY9u3OTzmpViiTdjylKQ8bVAHb8/84pJQQ0LbsZY8SEbRnGRwff696JJ2BMlRYy0o37yR1IXnOOp59fp0qDcVkIG5UZiygHaoHQY9amiI3SMGDSZJTdIeTx7c4P8A9aosFmiysrNtyThQQPrnqecfhR6AvMWVpdzSDruBZVfPBPTHfp19+tNKBkhBlz5aglFOc8jHbj6f/rpxZt02yUuFO8kEdRj+ZpyhwpQupGCCq45Zuf5fhTYIk2KrTKFcp8xbBDDpxg9uCelMkRd8jYVGdQTkdPlBOeDwev1xSlGWSFmlz5inBYAkZHTPp/8AXqMEI5SNs8uEQcjoBjP4/wCetJgiwjBbxW25IXB/eZbr3z/KkQqiNt2/c+VtwwDgjt2yPf8AWmyKQXQMxCncQUx0Ht6H8B71PvQpvDlSWAYHBIbt1561STE9Btsp+yw/LukJCkhPw5J69+BSyRfM3zMVZWYsVwBkDr268+tPeAO25mc7ckOQCDgg9Bkc+/8AWmw+YVyqqjGQFQCTjPUeg4/CrsT5kE1nuLAecSxDABuG+YgEk5BHr7/Sp4rRIrYbo087GBlcqMHn2znn37dM1NEj+XEilQG/6aEnjsP1z6U9I2437gZPmCOwDc4JGR16/hVRXUTdyu8afejiZ23fKeMggcHH19aaLeNpceUIyAwzuyEO4/hzkn8Pbi/IrM0rbnXqCAB8vGRzSfM+QQPLXj5cHI64OfWtiDIn0uzYNui+VlO3dxgnryD/APqrMv8AQ45ATBEi9FPybjgDoB785PB+vWuoaRIssUyGORt4BPbHSmSCN2V2ChurHrznn8eatya2Yup5jqPhl5FMiHYXILbT0HHXHHXPFcxNBJZyhJIzt6E9gc9c9f8AJr2xoNzSD/VncCo6Ffw/AVx/ijRFnUhWKuhyC3uMH6/yrWnVktJA0jmbHYsu+3m3lcFY2OcKfyOVxXSWt7IFDRhfNmIZY93I9935nGe3I4rhIpXtpSjHyzu+Zw+OeowPb24re09pJZIhCZZOd+1sOpbueuM5I479PrpVixo6C7mMkZUs6sQFCg9R0/h4GMemMfqz7RHGy3DyZ3EhAqj94ckfLjjPQ5x39eazZpkRY7h1z/BHEigbiD7YzyOevrnNVYr8TQpPL+83SLzGPlCddo6gc/l1+sKLtcryLt3NcXrAEBuGVV64+8Dk9QAR164HAqQDLRx4LMxyHA5wCDxjrk8/jVKMj7ODIrl3AYbegwT0Pf09930rd0C3Z75pdztEDuZ1A2yAkHofc9MckDrWVR2RotEbWm2rgKMBG4fcAM7RngDpz1/GprqVE2qsnmyNlhIG3AAdGz0GemfeppYWt7do97FkGShyCwPp+vHsOmMVXuXWHHzhfLj2Z6g5zz15O3BHc4wM4rh3YeZR1e42RGEbguWbcEwMc59z1PtnBpLS1kjYs0pcbl3bI9vCKDnoeDx/I5qk7RyTs8Ui5yAQHI5PL5/2cZ7j654rQt9yqXHOVbJ5YcsQe+O4P5Gt7cqC5PDbbod1wXk+QIvPCjDNx09Op71Z2IsfnJDEBtYx4j3EggEDjrnH5flSRTQxT5QLtU5TCkk/KBkAewJz0+lJGxnZHdCSWj2EuN20AjoBnnHf1qdGLUkLLEWZfmZmZcOd/OOcAD/aZsCmo33ZCx2NtC43LtyQBjqO3GPU1LtczbWdliQHb8wBYHPIHGP8B361IgDBpBHvwu4ZJIVck4zyOgxjn1zRGLbFdEMpIfbIMKMZ7gDJzwOp56n1BquksnlR7T8m4ZXJ+Q4zkkgc5/qKkS38tFaZA5OFAYHA/DPJ6ntSTFAxmCeau4MoAB+Y4HToPYD86tJ7k3RXlB3Yl+aPZjEYzwM5x+B9e/rVK4OxZpWSV8ADbyNox7nJHPvVmSRnhD7QGZgxLqRnDYPQ5wMHrVGZiVVU3kYJDZG9sdD1HHP8q3paMiS0Nnwbk2c7M24s+Sc9a6MHmue8HjGmsfVvzroBX3+D0ox9D5rEfxGPFPFRg04V0GJKKeKjBp4pgNamGnPUZpANNNNKTTWoArX/ADZzD/ZNeX2JMbA52ZO3GMdTg5PpzXqF3/x7v/umvMbFgHkHfkEMcgnqAR0rxc5+CPzPRy74pGrbnAXCyhUfKgZ6qD3BHQAcd/UdK1QyyWx3R5/gyCOT15znnr26/Ws+EPJF5UW0qoDBgduDgg5HOT09evvVmxDsEBGCinnPIUdcr+OfY/WvkZbntouRPtaR4xuGTllQPxtyOc/5FLIEibIXeQfmwnTG0Yx+JPHfNIoV/NABYRgbCxDbhjAzxnHI/lmptkka/N5rDkr8nIw+fX/Z/lWTXUaDziZlIVyhcFTIcKRu6EdD94DFI/75EfzG8ny9gkyuXJwOOOOBT49/n5mzKFLYUxgZw+fp2+vP0pWt4lfyyrofuhAcjldmAPqP61Mm9hqwBGuWYJPlWc7WyTuyTnp/vf49aZb4kVdzZdguf3gxydx4H+770GMNdh8qkOS27cAEHyjqB64/Op13LuUZyp+UgAKV+YY9TjjGD7jqajQexQSK4iXc+12OOg4Py7s4/X+VQxtsQRmQqAVUjjKfMeQMjHTr7DJHSta3XbbMNjFVOGJXjhCDk54ORVKW3WOT/SdhmJXBKnJPUk8fT370W0LTGxTSmMrKnO5Sr7MYLMR69fl9+lX9oi8zz3wdmd2eAd/U8n2/OsVofJRRCWGSAcSDGBggn04JBz+R7a4YLbmCaVkMf7sZAI4I9uOduenHTPdA0YvjHT11GxfKhSjEqD94j2z/ALwOPpzXBaDdNZXEsbsYQwzlRkv0IwPXjvx+lesXBiWQnz/M3l2APygL05x9Dn6CvO/G+k/Y78TQnJwWG3pnP0I4yB+Irrw80702T5nZWji5sjFOT+8G5lDFlOfvY7EfmO56Zrj7lN0FxbTkRPCGX5xkLgnkegwf5nvVnw5eLcRrGHQzoAWDZxg8Y9FwRxjrUfieBorhZcrEJkwIsfdcf49OnbtzgpRcKnKynqjP0q48sQzvNzDw4A34A4Ax0PU+vBrZgvHFz5DF5RId3mI+ODxySvbOM+3vmuPhcRXiNI6nzATuIz8x7fp+Y4q15rLAwiLrGj/OeGBwf59a7alO7OdaHWx3YmWaISlkwUUkgY2kZ79M9/XnPNTRXFqixeSGKmQkZzzjdgDPUdePfnoa4+G4l8uaQuqBzzuO4scZK4Pfnrnjj2q3Z3Fx5QberRlRucjIG8EdT06nj8fesZUNCuY62PUIhuEbK/O5skDywMjlu3TPHrV2K/aJSAQBHIF3gZyCPcZ4HBODjjpXJWmoGGDYskcZdiyucEqpOOgPHb8gelaCTGaRVXfbxIPnQvudh2HBBbrx7d+KxdJIo6e2mLWYySiLtVjjKqQPlIPHHPp6Y9KtF9/K78s4YAZIUZPXOee3JHQ1h2E/2cF1EwjRSJA6knJ5GWGOSfp0FX7a4aVdqZkG7I6naBzwOg6dMk/kawkx2NCNJBb7G2qVOH28YIwSx7nsPxqXZmTClvLGSiqudvPfI6gfy6cVBcAmNELeYjDn5SAfcj885/pTAZ5pgXAjduBuZjkEZx6cDk8nnPtUOy0FruXDtMatGisxYKDj7w7AcA8d+nU9addHddxJsKomEQgkZIwc/wCew70sYaKQyEl1gTBOc/N04Hb+Q9aryMUJAkUGThGHGfXr17cnuaty5YW7/p/wRWuyOZ/3T5QmWR9xIJC8jkZJ5/yaIgWVFkeVmU4U7htzwBjv3z/9allAM8YSdlbYBnPQenQ479PakBBjbZk+aeFXJx0wSAfYVy8zua6WEt42a1jMRYKxypZCNqjPb+pzVgKEz5T4By2c4Ckk88Dng9f50RIEjHysuPnAZgAT0yR7c8fSpiq2xVyfnkb5UIweuMn0A4+la06Tk9SZSEdVt3FxLu3ueE7nt+XT2FOy5aUykmYA5I5289F/I/p61AsjEsZSWk+6zD+HPHBHbPoPTpmonZmjkSJB98gcgY55575A+mc/ju6iirR2IUW9wuZ84jh4mf5sg8IBjjOeB0yR/Wmlwqu5kVjuCjDY44OO5OPwzgdaEBWSKSSWUbk4VsEKMg4985I/Go5X81ZXR0Bfqqt2Zj0xwO4465/A8sm2zREsKGC2WNyZGl5bjkjv3/P60wIJNrb9sar5h2KduQf09/r7Zp1yxBCOyopQnDD5fbPrx6Y6E/SNj/y0RhnzNq/N82cDP0Py9PpQ7CS6jJIzGw+ZcmMKAvRAfcfj0FOuSDGmRjzXJAUkDrnP+fWpDvxGitMIsHjd7HrnnGMdgeveiTIZWiwWG4jAB3ccHAx9eanYoTzTHcSzv91cg7X+mPqDnqcVDbxbxFvYg5OF4PJ4HqeemPxpxPEqmTnGd7DjJP49v6daVHJXMYKqHBGGwuBk5P58dOlF9dREWWWcEELEzF13E8Yxnp169qeGKSRBUZSBgxrnK56nt2Jxn0pqN5cSyZdv3ZJJdRgYz/Tr06e9TxMTcKxy2F7c7eB7+55OaEkNkQ4i3D/VMAMAkgHJH48fzqQOpYyOSBx3Gc7c8849aht0RY4UzubeCRknjd364/TNOhRRtkuCQpTcBsAxnPqOuAf/AK+aWoC27B0QfMQOAS/B/Xn738jUcMaiNDIFknbBDFAcAnr+eD60gVRIsTP85UN8vUAccZ5PHf2NCgNDwFztVRhQpB3cjjPsf8KPUZLKqeUHXcDgsoZcAYxx1z2/OpM7WCNtXaGHC8jnAPbHrTJArxw4dMDcRt4zg/5/H9K0duu4SKDvjXChM8/xDJ+hp6J6C3LsbFXw3mhVcsynJxjn8sn0xzVcFkeSQjCr8wOSRzx6e3r2/CmQ/vdxZtrLyQyn5Dwcn15/rVmZGXzN/Bwd2Rxnd+gxn9KNWgsViGSJY5n7gFV9fw+tJartIdVBONoBO4yEnAGPzq5cofOUFGaRo9uAAO/GOp6/gOKhhjVbk+YNrdCQPvcdj379scZp8jUg5tBsiFIW53YAQHOQMHPJPbkDGT/isqEiI8sMMQCSM8ggZ54wPp0qGJHNvLkr8h+XLkkYBIwD7AY69+tTbj9mhZW2sSnG72/zwaTGELsk0qyNtwcZO7Bxg9BnsRn9BUYhEcPDkEfMVJ6dvwPGevY8VPEG8yUOVVdpxnAwCMg+gPP+cU48W0pSRQPLyCcgLknnFFrhcb9mG1ZCoIzub5OO2MGkt4C0auW2hsBV+8xJ4Jzg9j9KmkcNE7FCd2NoCnHqCSOB1P8AnFJGJWijeQE4C5Qv02jI9uc9PbOPR8quTdiPAzYjdBllYlFXJ54BAHGM84p0a4uWbDBVbKqzZPAPOPz9emKhiZBgk75WIXhjkc5JzknAA746VOkuQMspV5CwVWOMYzngZOOwP+NVG24nch8gjzVQZXI4bI9ug4/D3NMiLuysGVgBhQpxtYdzx6n+dWA2DcfxHLE4bhenbPA9/aoIwfJiVXDxEqVHTGMde2P/AK/0pWW40x53FCsYbLNlO+QOmPr79jSRL+8Lj58sQuGHc/lyelE0a+aA537VO4E5z6fd6dKCWt5t3lqGU7NpHQ4GQPTAHr3ourh0EmiYOAZifukFiOTjGMfj/wDrpksIWQYZcA4/egDg9wByOQf0pTGxkjaNsHGdxkHB4GTjtz/h0p5aVWYMofKFsj7qknP5/h/OnZMeqFQCO4ZmGRvIAZMjP1HTkAZ/WmJEVZhl9rBWKkhTnGf8OnrQsu1olwRJhcDYRzk8n14xSqQLkeUGCcKw3f7Prnp071OlwGQqiwpHuOWZSxXO4cnv26UuzbHGS25jGAy4+YD8AMHPT8euOEiJNpGzlJCrjGMjjII6jn/P4vlBMESyNL+8Xb82Mdj/AJ78e9NL3Q6jw+w7lwPLVgOc546/oOv50FWTJ39xk4A/g6D/AD2qOVX84RtIMsHDZAGOcf59xSBmhaQ7mKHBO4dx8v8APH50XtowFRflUNtJxGBg/Xj/AOtjvSRRmWbzNuIwPLA2qSRnqOn1pI5NscLFyAjKSeOMZyOP5mo0cSqDuGR94seBkccdscdfXpzUprqPUluGyocsCZcMpKg4PGRjPQUSq0hlUttLj5Vx0GQck9c+3tSSOoaORRhUAwzHnOQe3br+XtkySu/zblOHOWRX+5kADcB+P/1qPdAj2S+dFk7ldGyN2OepGegPOM49c0XJbyQQ+RlhiNjjBJB7e444/SpPNOYmKsCxYDDg8nP58Y9vyqR1l8udcu2WzwQfw5x1/pQ9dhXE6NcKd/lAszldozwOMjpzzx06VWK74TM2xRnnnJbPQgdV56VLGgWfDM2zywxLAegHUdP/AK3apDJskaXZLt3Yxj5QDjaMH+dK3cd7CtEXP3Qq4w4cBipPOeTnFBQeYFVfvPnfIOCAuTgDt9MVXgAZtgXeyv8AKHHQZ65/p79Kl+zw+ZCEYgxqAox0+Y/eb8x7fhT3EL8rrCY1UhycHnn0x9PXNSeWWdiADtyitnCxnJ4wT7+lPmTFuxCP5aFSq5OQMds9KiMu9tuwozDkbcAdOvHOccH6cU9FuF77E/mrGxlC/uyWKNjC44PA649hUcKmNxiIhvvFwMBB2znjsPzpkkLHDeZMQrfLtx0A9M/UfnTi29JE6c56d8ehPp360cwrEoULCxCIMgBeDhRgdeefp06VLHP+6kEZY7M7Ruz045GeuVz+FVfIjJyWlLEjccHsep7d8fn+NiONvPZX2ktgHJK898enrnPfiqTfQHYeZHJGzc5wA5PAOT2/X8+RTgXd4huCbVGCuPlOf/1cUhJcF2BG5zgY+96Ed/fPvTbiNzyh2uDuKk8c+31PX+tVdk6ExJQPudlUDHOAzDj0xzSmZ1XY8fyggfKe/piq8cQEQY7I8nr6jpnJ544/KrHmbWZ/mERzhCcs3Tnn1/lVxb3JdiSUq21WLpuGAc4x24qMogiCwODglhuGc8Y/z6VFE5bJZsgDlAfm6d/w6Z9aJ18qFQ2Ow55CjJx3/StL31JsKZQmF2sSgIVmAx9SfYf1rKuWDxkK2/zAQWJ6cnPNXpfLdEEg2wA4+dMAn+nXj/69YmtXiQwluNznK7SQAD0Hpj3rRXbA4bxhAYrkTIQxHDLggnPfH4+/FY1rOfL/AHazbQNpcdcDuPbr+XetfV7x7iaXzWbLA7lC4JY8f4isK0b5l3glYyMjZ0HTn8fbmu6C93UEatxcFkiDs4VRnJO7p0xkjpjHU4yfSrELErDt/dMoEjOi7jvI4wAOPvDn/DNZUjhvKX5vNc/MhBCnB6Y6gjHt/WteJPLYPGPLIUBJFzkng5JH3sHOM+h54qJ+6i1uXkjdrg7Ts24AZOB+BPJ7NjjrXb6BaiBY0k4mf7u4/e425GDgYOAP6Yrl9EtSo3su2HuOPlJGOx4yOAe549q677X9nt5A4VDtDKu7o38Kjnp8ynP59K86pJXNJXtZFnUb1YULiRgFG9dzA8KCcc98nHHeuO1nUWS3WIvmWQhXAJI7HJAHqSPw6Du7WtTEMsIdsjzC7ZBAYKSAcdDklv8Avnr6ZFhaPfXW9gY4m+6CAMr/AHsdOpJ7jIINFODfvSElbQ1dJhlcQAtiJCSrE4XoeQCOcgHHHXNbkMCwBPtIaVlAIDZOcISAAP8AePXryafDC1nDsRc435Kp34xgk8/j+lWG2CXBJJkZ8NsJIIC/l3yehzRJ31AS3QIhyvfkKR64HH1LehyBTIJWEB2yKikpnB5xzwcjJOfU1M7tHujlDGMtu+YkAAMeoI6DP4npSxLKi7Sx6bhk429Rux9c4zjrWVn0F6kVqGEUSq+5yFCoBhcnIBJxz1xzz7CpCfL+ZGGNw2EMMYwQPmzn1JFS3C/Z3DPncGAwWzk44zxj0PHfP409yBQ5kdioHRBgHDHPPfkn8qvVC3CKXMQx/dU79xBP8WPToc9e/wBKJnXbJ87lV3YBfPT174wR+metI8cXGclQBgHHPbBx7duKik2kseDGS3UZUfMPT6j86avYOpDN5O4o24nLkbsLk9O2OORzmqFzsBZI1ADKB8ozk85+o4/lV65UOkiAFZSG2nbyeR6fQfr61lXJ2qcE/OvytjAIz7dP/wBf4dFFXZE9EdP4S/5BCkcZNbYNZHhtdukw+/Nawr9CoK1OK8j5eq7zbJFpwpgp4rUzJAaetRA1IKAEeojUr1EaAGtTWpTTDQBBd/6h/wDdNeY2ioWzIu7DYG3oeSfw/wAK9Nuv9RJ/umvLbXKSyYXdlj0ypU565/z0rxs5+CJ6GXfEzbtrd1zHFIVLn7hfGByOCP6dRV+2U7miIw0oYMD3IJAPJx6fgfqazoZkZQInby2ySBjcnBI65Pr+n1rQtpEV43cqMlSAAV2k/j7dcd/z+Rlue4tieZPLbzpOEyCcqRt+6R6Y54x7fjTwxbZEp/dF1U+XuO35mzx646k+471GZoyNrOnzDYu45H+s6Yz7j8+1TeZE0G9Ce5BO4jJQgDH1HT+vFYtFdCRQpSMFkYumCp+XGV3dx03BjwcfWpYnZ7mP5tyl0bAYAD5i3rzjpTZV8ydkjkJjD4XecYO7A4AyAACPzFIlz5BQtGwxghQR83ycc45zzzn1qNndh0Df5YLeduTy8dcbQQxyxII7DNTRHdMykCUFgMnJYZcH1OOMnB9TUIfM2zLkIRtUEknCYAHUe3PrTkZvKKq+NmxSd3GRxgZHPIPelpYepFayFbTzSgyWfAKMpYEHov4Z/DPU06QSQyYUoQHGFfnlcA8fjgY9cUW7kxjLABdiqVfB2njvk4HPbp+NTyI24b0aQlZMArg8txjrx9PwxRsMyr2eTcwMXlswzgDbnGAVGcjt3wODU8MjKN+5Zvm3ld+8jcxycdP4QAfp06VJdIJwyCNQPNYbsYBII5/UgketUNsxwznkhXwzkAYcDGMEYz0PIGT6cplrY1GKRrNGUZYmhKxMIjldrZ4Oc9gT6ZBqprtg19p+WK/I5c712gA4A69u+emadBmCFW8xXVX2bRIfmyM+xyVPfr9ani2bFTYw82PCDeMHvnJxnkckc8GknaV0I8qjLaZfPbbcRTMGXrgnPB/Tjt0611t0iatYmLzgHcmRQ3JVs53cZC++M8N9apeNNJUR/aYvn+bqThsYx1696paNe5iK7lXByvXcpA55H3Rjn1zXoSftIKot0JaaHKX7YfMXVTnytvQjqMHvx/nNSCQyDjay7M5J9e3t0/lV/wAa2bwTC9gxiXAlRRwr9N2PQ888Vl6HDJeqYVwzIQflXOR2/wA+1ehGSlTUzmkmpWJkWQ5T5QM/KCcoTjjJP49elXbdGRxlXRgCq8kEH0I6d8YrVsPD7nEgUrHgOSFJ291H8uOnNdFYeH1tvKebczLgluDk8jAOfcYx9a56leKGkY9lErRTmRN0e0GRu2QDx04yR+p61qWSAeUkETRlSCBIvyg+5PXrjHXnvitWz0kiS52Lgs+4PkdeoAHbtn2HOavJYvFhoiVVf3jblznPbk9OT3/lzxVKlzRFG2TEsXnDCxjYE2Fskg8cjj09var8UbrtQJgqDGpXkZ6AY54ztGT7joKl+yPHkw42IrIN2fnAx2/GkEcwJAJcLwOAc9GH06d81jdFFoIwY8s67cFOM8/dBzwT9cdafERs3bWJQBdwbOCPTjvnt05qIJI0hUsC7ZyqjbjIBBP5D8MVYdPLaKMFTtGX3ng9hj8zU7iHGFtrI2UkZg5UngHPIx/+uojHycsFYDZ93PH8z0/WpZHbEmHCDOF3Hg+mB+J5z7UkUJKoXLbSR8pUEk84PPTp/Ok43YJ2GusUjRY5JO8ybQOw4HQA/wCeasRo0aiNFzgI2Mnr2I4+vtzQIsHKKo3SZCjnPTken3s8UpdY2AQ/vWYsuRjfnjP6evGDxzVqKTuxN30FlfyZVZctM7fKOi46A+w/z71URpZGOSzyMcM+7HcDA+h7Y7fhUjsIyDMWdiMudpJY8DHXp+VNj/d52vtd1xtUjHOeB7DHX3pSk5aLYaSWpCGf7PNHAw8wHaBv5bkZJGT35/8ArDiGa2VlDzliwXCjB+RQevHvjj9KtfZAoIdmlA6BjnjIJ5z9fwzUUk4W4kh2bRu+eQjKjAyAcdO3+PU1g4tfEUnd6CTJHFuuY/NiJIAyNoA9MHnn5h16+1KzpALZnys2AEic/Ln/AOtkUryldu6Ng3YM4OT65POBnFJ80cjyOrO0eVD5xkBuuT0+uB9KFZbD9SKV8SxIWLY25LEqM4BxnB9z+nFPyyIJcuQ7EKPM6g5AIzzTgrGSU/MzIhGVAKsemMH6dahdBuAkZfNkwVLnHTAPIIJ6D8aTT3HdbEk2TJHwFlYsSuf4emF/L079+KjaRfNh8v8AdxImSxIzgnnjoen0pu1iR5eAHcbQoHTg5PGffr3FLGqOGEYCMSG5GNo7dO/PP86luXQdhLZAm8qxYtyAzc5GRnHf8qbAmyOM7i5IBUfKSCDgZ79T3NSxSMVZjInlqCh2yjkjvwPrUUzshAfcMnIXkDgDAHXjk80WDVsWVBHOqq6hmyvJBCjIwOc5/wDr08xxyzSqmQCQpzjJ47e/HWop42Dnyvv4xhGAwC/bjqD1P/6qnhzulVmIUhiSGOAc4445/pngU9A6FeNy0SbGUKMk/OScD0UDjk1LJtjLHC43EAEgcDjA7j7woOAxK/LG4ClVbG0cdu2cHn0FLcq5uInKYhUbVUyZLc5HqSe/0pW0DqBCJMsjICyr1AyRyCTx06flTB+8Un5F+ZTlm75PJOOPSrMbrJNIzqTyflTpxwM9s4+tVgzfYl7gnAxg849c8nr+NOQkyeRyqgKXxtYH5+cEbsZPpjke3eiP51QEky7hgYIx8vOcZ4546ZNQXKRtdK0jr+8YnDgAEjAAPB9cGiGP/SJAQqhickAqT3BHQjoBT1uFtCSxbbbr9qO1lyRvz+Pf0BHbrUc8rDY8i5LDeSenB+bvx/npUkDt5K4JAYspXoCTjnA7devXikKEbiCzLkgHHDLjp1yfbPX8aWrQdQkZ1uoXYysoOSQNvdffPHfrmi3mAywDCJm4CttHQ49Pf8x71Yk3EzHax3DaybfvDjHfr1z/AFqpCxMYyCxTB6Fghx35/ljoRRdpho0OhkE0LKzcbsMykHOfbr68Z79KaAyW6b2IkB46ZAI6/rnt269KZbBfMIjY/vjuMZ425Pqeh68UjZiX5yA5AXCkAYI7Ae/P4etJ3sVbUsMJGmyG+WQbsbgdvXvj0J5/yCNWkthGW8wFQVIYYPTHuOucf41HMXtVgZwhGOowpGRg5/PpUhk8u36Bwr7c45x0xkcHt3PP0od0xdBCrDy9sgkJ2sN3UDGOQD9Ovvz2qbGxxu3EI2ACckHGMcnJOST370x7lUUIweRf4mPyhtvGQR0HQ8ensaVnVY4vnVtzHacdfmBHf0J78U9thaiG22Qne67TwVIBAJ75z068ehHpSRYbLeaJIgM4ZQCOT1OD69vU08gfaHz90N5hBOR0yD64ye2ajtnR0YxlXLIg2Y6DGOe/GPyp6IWrFW3eMMzPmPaR8wXjpg4H5/WpJmby1ZSBuYYXzM4Hp+p71B56srbfnOFXceg4PqeD0yfU+1S3NwrpEoLEYypJJ7j6c9RTukgs2x7fKrMp/eK2VCkbT68Y5646fjUM+WKq/wArEkqWUDgY5znofwpPPI3sGPByOg3cfLx1PQGq5DrdJsMrHbnGCNpHIHHUcen8uVKURxTLcgAjuChVxl1yCOO+eh4yD0/PtToRGk7BudyAtkYY55PAI78456GqPmOJFOCFYk/PyR046E8DI7U7DiabY7nevTvj+nrxSU0mDi7EmxWjVnZkByCOASc9R6456elMK4kAilx5hITKA7SD39cf5x0p0cB8ss2HVgxUtgkDt/Prin4liWLd8zZycZGc57/iOvoKEna7QXtoQEMokX7oLFgxIycY3DpyfTr2pZMCIL8mUw3IPTPTn0wam27p3z5jgMdy4yBnr1xjjB+hpTGSrRAsgMYj2sQCDz+A789cfSm1bYExpycfOvynbw2OSDxj2zQMoT5gJwcFQBzycj8/5UAO0cPmFg4IwAvcZ9Pf8OtAjfj94C4KkMwwAOcj/P61GoxsMW2CJSuWXBOQBtHuTyetPhgzlZHDAdwMHnsRx/ez9RTIo3YGPplR8vBPcgfjxSWqEKVkWN5shWKgkAHoWx/npTt5A7iRRSDByx2kbVx3HU7uxx0H4VLuDwmTczZw5P3RyQMkeny/SpAoYxEgnadoUqWbp046Ak9aiGXs2R/mKMwySOMD8D26e1FrIL3FkEZIMjn5gxwy4OQcdvw/L3pDDGLiRQ+0PHzknuBn+valdFWG3kAiXkH7nXv/AE+lLuCMBtaUuCEBkyCMY6/i35UJahfQhhMYELl1LYOV+bsBwfQfT1NPUbJMDlmYBPl56/e/Idu1OZGaMonkkod3JJBP9eAc+maQxh1TzEGd2VWJ/m5HGD25H6ilylXRPGZLpVZX3CPLHC5Bbpz/APWpJJBEokVWIZtyKCeD7+5649x7mmF3E3I+UZO+NCNvQ555/A5pxYrJy4Xa4K7iSemN2CMjr0//AF1V9CLagmUn+/KpPKsepPHJHPenKVC7HyYlYso6kEHHI79e4xSlGjIk3qzK53jocccY+lPK/wCkOm0HcPddoJPv6/maVrBdDItyx5BYOzbipBIBz/Tj1zUrDzZ/3q5VF4KnO0Dn/P8ALmnvsWR3cncgKnoDwAPr61Gk37qPyhsycKS4Cg7fb/PFacttCb31RLG26F5SMgtk7QRjOQSSeuP609GWWGTIKSJn5GA+Xpg/ofpzTo2aQn5Nwckc9Y+mAQefT9OeaLZGW0Al+aPgPtYjOR79P/rD6VZJBsE2HZ2IPykHr1ODx04H8qmEhh2BIlBJyuV6Dtz9Dknmp/Lz5YaT93gHA/hOOuetEu5XjeVMED5uMn9OnSjlaQXuV9jhcbV2Egbc9Dng+3SnvbociRdzDAOPbkY/lTkdo1lZVVju+bB7nB+nApwZjxg/KcKWOPrn1/CqUUK7IpLhTgBTuzkNzjHt+GaR5MMrFg3JJHXaB1788n/9VWZGQgLhcjAbsBz0Pvn+dJMgyvy4XaNv7vG3r1z61fLLuToZlzC0UhaMbZjk7mGQc54x6fy4rA1S2eSAAJ+7U5B6g9genHQHNdaxAjztO37q5PQdaqSWr7jK4TGduVGSR29q1jdPQVzyDVIngkO5f3gOFBP0Pb/P9cqDOzbMWTed5GOQPUdBzx+Vdz8QtO/1d1C2G3AOi8/jXATMfLGSTMQG5GFAHp/nFehT95AjRslL3jSmQqqjYJT8wGeN3PQf4da2rOA3k/yBmldssh/iJx39R6eg681jabGkEeXbyyhHzqDwexHqeT1wOK7TwrYeREJ5/ujhWABC5288Hn+ncVzYiVjohtc3LG3aHYkEUkip8zFmG4k55wRjg8d+/tVfUb7yFYNJ5asBtY5G3IALHI+vYck0l1exJYSyySsZ2QsCSV2+g47Db0rjrxjcXZhtRNtJ2spHy7e/P4Y/TtXFCkpu7Btjsvq2oZDkhpMEcnCk89Ovv9frXb6Zam1VVctHlUUsdu08E89yBx6Vn+HNNjijgLttAOCyDHmdQckAn1Pb0rYEjImDlCDkb8qSNp6jknG3j/IpzmtlsKzDau7KkuHKEO7dDjj5up9OPQ+gqQvFDMWBKxsNwwW3E9ePyP8A+oYpkEbrbRNIZWLLkLjI+6RknAyck+3b2px2xTzNGdwk3dGxjAAHTp19OKwv1H1JVYom9kiDLjccEYJG4gk/iSfapRcM3zblERHG+XjJwRkc5O3NV8MJpFTczF5DGMsqr065znrnv+tWdrfamjM48st1IAwOcDpyTwPoauN+hErDWJMnEbGUEnaxGSevb/gPGO4pkgwqwxoNoAXDLnLZOMD0/wACKaXeR23KpB+Ur8xyWOcEe/pk8GnynEm44BzlOdxySRnIJwORz1/OqTEyOYqgJfe5X7oIwU+cYOOuetQzN5WSXPl/N1XnJYDGD06fX+dEzcjcdqoRzgcqMHnHTr79agIO1FbfkAADaQBjHqD3zRzDSFlmMfmHDkO2QMnp6enbJ9jWRfcQy9ANnzBWzg88cfh/nk6ZGy33DYWZdu/JyBhsfSsrUgRCxIxhcIpB469vxHX2rrw795GdTY6/Qf8AkE2+OPlrSFZ2hcaXbj/ZrRFfoNP4EfLT3Y9aeKYtPFWSSCniohUi0AIaiNSGo2oAjJppp7VGaAIbn/UyfQ15fbM8nnx+hIHTIHPHPTk/zr1C4/1TfSvL4Vb7U24qp37lOAc4J/HqMV42c/w4noZd8TNaJVJXKg7VOVK42Lg8HHv0/wAir8e1bg+WAg3AEbTwAfT8P1H4U4WI8tZomBwI2QPyT06d8cCr28oDEjb8o4wcHOcfMRj26e1fIS3ue4iysaxwjoSIRtDJwOAegHrnvT1ETzFkj2TBiqnbwACuAAM+pFMh8l2GzyjknkIcgbh+XQn8c1J9r8gruldWXByWyDjaO3bBH55rJ2sPUlg3CMszMWIBEm8BfuFh9ev8qEQmIsHKKFGzgAkjLdec8YqO1bEh+QgFAAMcnAKnG49Plp0kIPR8nOcZ47gZ9fu8/j14qN0NXuPKFCAys4UybCVyTzkDAP8Aj+dAJSQnGRhN6qM4O3PHpkk1WAkjIYw5kRSSDk8bfyA/HOM1eiAQjJGcgBTkkYUDOf8AgfFSnd3KtZFVVYQwldzEJG2wKOz+v16DGOtMk8xY4UZGki3H7gZcDeB354yMnmrKyiF9zl2JIHAYEfMePwx+B+tNjuDsEoDSRsh24ViWyCce/Qf5NJ2GIJNrMCNyM2TgPwMkHOenIH4gYFQXMQbdgltxO992Ofl5G08cdP1FWZgHXDBXViu9WYj+7yR9c/jSbP8ARmE6QAqSpCHrgZ4/EDrxxS1GihDKW8l+EZhhWOD84PQZzg9iBjGce9WJMrb74nWGaUHLSMBs4zjHY5B/E1CFhBI8mIbCGJBUb/l6knseOR6+1XfIHkkFw2RnAYAL8ucYPTI4z6iovqVoUpoVMFxauhZdoQcYzwOQD0znv7HFebywNp+oNGw2orZ+U8t3B5GOuRXqjwsxEzO25fmYNwQeMYI9wfU8VyXjHTGmRpym54iN8a9MDsec/jx3rsw1TldnsyXqitGsd5o08Nwd0T9UYbipZvvBs47jJI6+mKwvA0SaZr99BetmSMgEEdR1z9Dn171Npdx5MgkbOFG0lWAboeRxgAceuex9Mfxe0tjdQalaSo8qfu5to+/7nAGRn+Yr0aMW26Se/wCZnLa56t5/yzMirtYEso7g4Axx79PwrRtLfzmBLs5b5twXbj6Drj/PNeVaN4zMyxKsgMqqWww5yD+vrXV6f4gyqozBeTjey4IHbPb/APVXFWwlSL1BSi1ode8M0i5jfAOWBXHzH1HsaAs0csYXzQ3QdDgenH06/jVHT9VSQDMqo24gNzyPU46frWyGEkwALE5y3p26+neuV05Mq9iMMUG1nVGc8FeSnpn8h0qTJaWNEDKFw2RwRx0H5f8A1qHcDa+8EHgPjG7j/JzTdq5H7spsUFsHnOOhI9jmmnJaE2T1HxKI1VXIHGCoP6D16HmkIKFnIBwMFiM49QPXjjHT3qQRNkMhYg8DeOWH0/xpBFvnHOF24Vc5wPfI4z/IU9bWEMtjvYlEPB+Y5+bI9ycd6nkCR4LEEOAGA4zxg9fw4796dGnC5+TaMp3z654PuKaCkO7ClVGeAwG3A9Pz5/2uaqPurUT1YyJpT5srAqU+VQxAb6HjoT/LvRHAyRbpSxdhlmI+b1AHJxz2pDNtOGO8k5PlgjGT0+nA555pkhKyLvO44BDY6nPt/P0NRKaKSYoKrLEQcTD5mYL0zgDnsMjP4e+aZLOudyBtrkquw9M+pz16/h0601WO7dCMlssq4IJHrtx0yT/k0jR+ZI0UxeQK3DZxn1P4kdf55qFJvRD5e4zzE2NI4wAMFl5C4H3VI7nI9+eKbGAdwdgoJy6DaAMjJB787QAP8adCFLtIuWAGQGHzZycc9B0GPpQpEcPJJZBu+8OW/AZxjnJ4xWerepY98tLK6OCqjbhmGWJOec9Blv51BLEXEcUoZnIcFpFwRz2we+M806JHt4wFG4IFbbwQT0U5Huvc/wD1q4R3uoivzk4d2eMkbiRyPTAHvj9Km+gWJgV86W4giZBt2qCpyeBz+vf9ahhhcLC6MxLlcKTyoyM9884/pmnsuyOZUADEYdTxjJbI/UDFLIGDqChEjSb1UnoBwMAdT/jQncYFi94W+UqPk/vcnOR2/HnoKf0jIckw7wQewC8Z6n+7xTY28tpW5wqZwR27cjv06e9RSbxGvmFnGQeUOBggfl6YwabatcEtSzGNkCgcEsrD5/u56DHI7en4DioZMicNtYFV7MoJ6fnjIyT19KkuCSzYBLHIHIXaMDJz1+n45qF4yJ8Sl9qhhkxjAHGcDHOQT6daba6CQ8ExGTbI7xFmBKNuOT0HTJ6e3T3psqgY3J8zxAYEZD9sceowf09KjjUidnGSzDJLkAgkfn/+qn2HyPyTnA3oGHbpnnpyePap5l1Haw68uVNuPJJcFtwJbaCTnntk84/Cng5vG2DEeck7d2Bg5/U9M/hVTy9sCBiCSgT5hzgdR06ZxwPxqxc5fUEXaArEZzuXI54/Lj16dKL6g1YghiiuJipXJKIGEhxgnBwB+HT2qREAtFODnqvC4x689Bx6Z5p9tEY5mV12lV2jb8uAOMY+tVwjxRxsp3KOWwfu8gemPX36/WjRag9WWHgaO53DeVG8jagHYc7RwfXHtTocC7cxsxUucjKk44/L6D1FRPA5ulUFWhZSCCx4Bx3z2+n8s05GkDlRuA3EnJI2gj1xnjB/OqW4iCEFIUCkZLDA6FSOxPOc+nrTpIlScqu7MmQvJAY8AH2796sRB/LU5Aj425XIPPJyeewP+NLK7q0W4H5icrjkZAHr+me1Ll0uwvqRfZy5kCHaGYH5mKjvng8kflxSLGDBDvWKRiwCkgkHg/yOelTFyxmMWcbzwjjA6dex6j8ajt38u3iZjnA4JcYPAPuemf0paD1FtnAd2WMtzuHPyqQSRnGeeM+tMk2nGQ2WAXecAA54Ayc9PfvTPJ3KF8sptypbBzjafQY/pxUhhSFm2yZiJGTv54A5+pxjPPQ0r6WCyuTuAY7ZihZVHVBnIOOAM/8A1qiRkhmKvgsMgjbgsSeSOcnHPJ9qiMbLKGkcgBsgDJGMA49T1P5fjUxOdQZgu85AXDdD0HU8HqOapyTFaw7yRI0itvwPlVTxu75x0J4HrUX2eRwucERjAKj5SAQOBxnqM5H8qt2kuGVxgll3t0IHTjr6bef0qFHdlUBT8oBB525z9OeB1/8Ar03FWFdhcxhZC0WxYmVlVo8ZHAz1B5xgAUyFTHHKH3LGy5XPOPlA/PntzUkksyyYIAxuOCxyc4APTvjIqNC8UsgDFlPyjcCTnAHb3/zxmh2uCvYS1jzHEGJeMSDAPRe/OTjqc4FRQxCPyd43McZEi5wM8/Uce/BqfEyKD+6JXB3NnLAZHA69BSBiIw+CIlGwgsTxzxnv/wDXqGtCrsdLFlsRHDZUgN8ox0xjtg96ZIERQ+CxTld3zjGQD78Vc8zZI3J+6A2cEAgZPHHf+dRRgR/KxwyqD8w4PGf54z9KtxXQm7KZ2RvHKgIAb+MHCjsSeoGM8/4VLJIy3RwCD5Yypx69z0/U/jSqimNQCScqcEDGckc984p5dUdZCAW2sCcIAcY5ycDtzmp6D3IkTAwZN4wOC2Qx2gge/TBqKNDCq/dy7qwIblhnjgew5xVmNdrlhnZ5nzAMOm3p2/8ArfWoyjRq6rIcjZnAHYdSc9c/pVX0BDnCi4+fysFPky3uBn6nj3oKnfkkRnLY6DBU/wD18d+tLcqFljdHILMVPzKdoJ4B+v51GVkE4RiVmzkgHPc5yMDA9qUtAELmNg/fnq20kZJ6n6dP05qXLqrF8EuxGBICBnG3OR7/AM/ameXuXzCSP3m4EkY/h9O+D+FTwov2jeocEnJ3MuW7Z/EkH8KUWDsRl9vLZcqMH5RycDGDn1zz6VEmx1ikdC6YEYY7fmzjGO5706OIecDIV4OQCudp29M4689fSlEeYZI4y3yu23AI3HBxnHbjufajcYtuNjKzLsBkxgP8oOe3HI7elKFlVpRgFT8wIBxkDBwOc9OPwpiqyQxyBWViuRtBwOfvE4HXkYqYr86MWO5lO05GDk5I/LI/CmBBhocRttWQEJvB4ZcEH34H86sCbdtY7QQh2sSDuGO2PY8+lRvGjH50cAM2wqQCMkDr9R9frmlDAXDESfIQSwYAjAOMZ4x/9ekD1HRgCZY/L3KY8Mvl8kdOB26GmxuWhgaQgFsIMgrgjvn27YHah4tsyGNizLIWIIzuHHX0BqPyFE4EcjAcrudfl3Dj6dMDPvTuFi7I6+YVMUrNsOFPJPBJJ/Dv6VF+93nccfvAqJgEtyO5PTrUUMY3kzbVwp2hyfm4yA3OfTil2qrMrFSQBs3H2B47Dvx7mnzC5SR4gbc7S54JACdFznB4pEjXeoOSHUFNz9SMHGevoPzqUspk2fJH8+4YO35cDoB7cVFEvmRKBub7rhkPUHjv07D06etKVrgr2FCxbORuXfggrjqPfqMipxFsRlRVV1YLyn3uAB24zxUbLI6zGL5c/MNh6+hx2OB68c+9KIV87aZFxKCwBOMHAz9RzkfSktOhJIREoUMyyKwYsSM8DpwOeAQetPJ83ICBmjG0jqc55IJ+ufxHrUKhFhGMmQANyoARlwc9PQY/CnCNftR4GG5Zt2CncFT0xwR+FWnfULEr5VS65duQ20HLHHf2pyOJbfO7Plj5VyM9P1B5/wAilUE7t5Cs+7Ax8w4GTn6HoenFTRxvHuLMSGJ5HBIweT75qlzNiukRRq+drFvNP8TD7v6e3vUhgWWTbKeFG0qhwB37496cVfYMPlVIw2MA8cZ/TkUpAf5Qm9gMdsAZxkH2rWMVaxDYpRi/GCCdw3DOR+HTimSRg28gwVJ+YqT34pzRROdrBv8AadVII555/GpFXCsi/wC6eOcjqa2S0I2IDgQFs7uQOR/kdPSq92DvKckoTg4ByR0NTqjRp8oDA42cYJ9v51l6rIImGH2iPkH0HIOfXpVR2H1MPxZLEtjOjOMuhKg9c/SvH4Gee6JYI5ztBz8ufX36ZrZ8eazLJcx2kbNubO7OBwMjIHbOKqaJa4ZVjfPzYUEZUHtkngY689ePw9GEPZ0+Z9RR1lY6DS7N5JoooV3JDw+89M9v0578mu1upI7C1jtjIImXIYt94D3b0PcZ6CqGmRR6bbqX++AGkYNnfg88575JH4CszUtQH2ad45N3mDykj2ZXgjGOOc4Pv715kr1JHW9EQ6/qTuwRJSZGJA5+8uee/wDez6dvWrvhzSdjeZMH3hcsNudqgEjr1BJ5PsaqeHNKNzcm6uixVsnPoRjkHPXqRXVW3+rRdvllQTjyymSwJ3HHbgDnmpqzUVyRJSvqX4oyNqbzkbQeRwNuOuORnPAwfr2bGH8sF2JVgyqWBwNzEDofp+A602GV/vfvGlc5JG7ILHnkgkfdzjnk9ahiikbmR1LHDdWYjALdAeM46e35czkgsy3LLB52WIJZg+0KdwGVC8DnGcnv1oztaTG5QQ4EjPsxzjb69Rj8utCWxQLDGDGpBUNjJJxkE56DimzIsJIDMkeHIBypK8ED8SSf8Kb0VxaPQnlkJWUMOAXG4jHyhScjJ4+7weQPXtSiZImG5sgOSyg4AJA/mQe56fhVUREOed4Rj8wXIGNo4A5JwfXqam2SNIqlnCcNuJyRxjIA/H8s89aFNvYTiOaZjl3VmbYu0lsKQoXIGcZHXgc8VAY2wokdnwFJCsAB2CjHB5wcfT6VIY/JyUckNgZfI6jAH1+T6dT2pjB/MU/MMk/MSGY5PBH0P9Kd21qK1hq26eXhtoH3R5ZHzEgLx3yPr606UyeaCAUy27BOejHnOffr7jrTGjBUqG29MZJUAbuhPfvSSRxjEfkK5JCO2w+px1J/M5657U47hqVRJGsO5wrDAI4PPHQDp16Vk3jr5cplKgqeMsfzx35/zzWlNsKk4aQsEyFVsg5weOM9z+FZOpA+UyuVBAwo2jK/5GDXZhvjRFX4WdtooxpkH+7WgKo6Rxp1v/uCrwr9Cp/Cj5We49actNWnLVkjxUg4qMU8GgBGqJ6mfioXoAjNMNOc0wmgCKf/AFbfSvLVz9quVDEszkBfx9fSvUpclT9K8w85BqE8bDd85X73uevp3ryM4/ho78v+NmlC4VpMiUA8lQDgHjr2OCeBWkZANwEjFedoY54UYHbjg9/6VmwRjyI1jb5k+XaVDBsjHXHIq/GnG98N5gyHQnCk7QMH8/avjqm57sS+pcDJ2vgZKk4P3AD6Z606Ux4ZsZC79h3jjgkf+gg1Ch2l3C5GC/Krgc559B8nr3p0kbgHEvyKWGRFn+D3/wAmsZSuWtyaNIYp9/Jbc3Q5x3HX6mp3Em4u75GSQc8A/Nz/AI/j0qDyTlcuxw4x8nTCj+i4z70u7FqpZ3+7hsqOmzP8sn8T061ndIp6k0iBfLyX2KQcEYHAXHfr/wDW64qsfKt7vcrbgpcDLkgds8c5OKm2l8Eyb15ONnqnX9MfVqc25rgMNyw4dsD5zzg44wM89Pb05pNoERQo0XPmKhGzAdmXHy/Xt6fSnxqiWMYCqGGFDhQCDgjrnPGe3r1606Mgu3y5Cld20t8+Ezj3zkDt1FJE22Lc24mF1wQwbBIGMDHy88c459alLuNjpRi3bzNpySyncAvBDfr6+1NDbZHLAEIzY2lQCOgPPt6fjT5YWcmJZP3RLDITJC7McHPuP69KreUGYnzJMkbmwq4yyAdxxgA9fT1qWxoV0kSPenzR4K4BHAwOc/QU2UuHfeHVGHzkIDs7ZPbGMfkfTJdCvmGQxzbom3bTtJwCvAOO3I9MHt1qZUkaPywh8ggAtyeAflGMnnn9OvqrpDILmYlXZ5CjfNgAA/3ucA4Pfk8fWoblcyNGxOHRQBIhODk8txzj2weO9XdPtWZEjdN0bYZmX5SeOCPU8g9D19iacbRpYSrhCGU7CCeCduRk8jr36c0KTtcLxTseXa1p/wBn1B1TPkuQwGOckjKgdj6g9vwrPvQtxaASrlJwVcfwg9sDscKeTknA9K7rxRp8tzaCTmMjABkUhg2OBnsfk6cde/WuCnhEqr1TczJ97lSRkH8P6GvYwtXnSfYzkrHAXEbWV48bD7p4OOo7Vc0zU7iGbyC7PAw5UnOBjt6VJr0RLJIcbuEYZ9qTSbTKiZ/4sdfSvoLxlTvI4HdSsjstH1SWAB0w2W+QZyD7kHOeM/TNdvpOtMJVWYfv5CxP7w9cAAso+h4HJz24rhtP0+VXiiSNv3hCKh/iyMg/y59K7zTdAMaqkqhWjVZMnqwLcjOPRR+R9c14teMLnRGTOq0/UI5g8kiOFwp8wjJAwCOemT147fjVm2lEyqc5j7oD0znOT24OPrWLY2O9hHHH+5YcMQQccfNjuT79sccVsxypC0aqrZ2khSQDkHGcngZ57150kaaFvJMpZyxCt8pBG3169eacEMQm5G7k72OQOeg74zj/ACarRygeYVXzZUcE5zuJxnOMe/t2qUB33nc+eAQFLHJwcqAM54/I4qHNLULDjJ8wHJO35iT0z0yOnccUyPcAAyg56uQQSOOuevbp/Sp1YyNFui2QgrgB92707/8A6v1pCHa22huXwUxyOeT746DtUay1GRGYmQoVTaWOOO2eT27nPrVcRHzJt+0EgkEnp1AyfT29vbmcZW0JjjEQILAFDgqB7evXv74NJcoSjqplRjkog+YAAY6dD1Heok76sa0IL5vLG1mcNI4kKpxnJ7dMDpSeYVSTb5uEG1Ryvy8EA8cYz9frUg/dLIzIE8teWJOAcdc+g455H5UlyhEkMZZSzHJBUbW6HB6Z6H/JpXurlabECEtDCh4BI2x4ByOuT0P/AOrOfVZcmGNRtZZJcEYA3YPUfp6YqZyPKK4aQRvkK5I3YPAIPUfgAOaR12zxGR2WWJWA6hQex9Mfn61F1YaK1xKihVZ4nDP12YA5bnH1x/j1pQ5+YRhhEJCMxsRg4xx+f6fWpZZyGllSMYG5lzncnAPfIHQ9T3oV/wB4mVBEchOBnA5PY9fukdOR+Io0HdEUrJHkFTtUrsBOOR0A6HoO/TJphjijlVXXzdqfO7ZJwCM+2OOtDrkl/wDbxgjkY3ZJP0/yasuu5XZlPlqvO4ktngnr14A5/LNQmrj2KjbUcSOSpZUJU5BXJx26jH5midAqKJfvHgBySMZxjH4e1XXDO/zuEVlQM3zcDIGc9sAH8aildTFEVD4c5JPJ5Yd8duPb0zQ0gTKt3FHukCADIL7lOScHj6cg0sKsW3/Jt6neSC3YjpjHAyB/Ortyi/aWjZm8spglsnGW+hznntjFNUwRXYdkbzVQMGGcnhflx1yfw7etVy3e4c2hWtQSrF+UC4BJOBj8ckdT/wDrp9uhSzhOFIxiTCDOBnqegH61JayRIr7s53KcKeD8ufoDjjr/AD5QXcb7Qd8rMmV5GFVceuBk8+9VFLqJttjZlC2e99oZgu0lSoAzyMnn/wDX7UiMhmWNS3zHYVXcCBjOPUcYH/66dHOoE2fm25VMseOPXr04zxzQr4vCWy4A3bVJXDYwRj14Pb+Wah2ASNlV2UEbAcPnJwSO447joPwqPP8Ao4KkeaY8YHf5vr7D0/xdGFjkuC7sqs6sdv3Rxk9vb6VEDutT5hZo9qKFDE45xz2+vXGab1BE8zOyDALK0Z6DPH5+n8vyeCv2lmO47mJHzeijt378CopcOIEL5VlYcKuDnj+q02FVN0SsspQtuXOAQMDv9cVSlZk9BtsvyxoVbO8ZVd3Tpn26d/emiIvcxbDuHTcWHHTtn/PenR5EYcAY3AlycYJxtAHTufTk1OY0lmjdBiYtgtsDIGHUY/XHsSM1CV1Yq9tRsnyNJtznaAqFVzk5OB9Pp2FRoHEBWRWIUnlcEkYx1x69xUw+TbMyMTlcImSTxjBP/fXtVaNDGXVpJGy2wDA9M9euMnPUdCKcrIFqKApSPAXeSuVx36cZx1/kPxp43KvyGVty/d3EcE8+npj/AOvSRHfGEGWCEmNQ/YEYzng/p3zRy/n7G2AAcFc4IBwBxnGMDH0/DO6GOuCHUEFckqQcDnnp1/3uv9aamRcLu+QchlMYYqAc+/TPX3p80mY8GMopbccScKx9Oe3PJ6CpBMGZgyZXeCAc4HGcAd+w/Lmq0bFfQbDkyMdpJ7jZ1PABHHB6/wD1qhhYeTBujyxfJyDlhwOM9jx0qS1kd5lE0a+bsABC9MgHkd/vdqYi4tFaQDy0wcAHPUk9O4Gex/pVX7DJZpAQNwOJDnczEZ+6M469unXmiW5JuA5XJjBJCsCcfXt0/wA5qO5GYQzEKd4OAvH8I7/XHNFwivdssjFldWBXGSBxyOO+e2M/jTcmFkSLMgaXOGXoMc8AgYHHr+FR7dlqjvvLBQoJUDAz6n6HH1p6v+/m2yyjID7e/P3cH9M+3WoIgxtwzKSxZVO0nOcAAYA4545J7cUnLTUEkWZY/nyZJVkG752xgjjrnIxgURhfOuMFirDAYOATx9eevao5CzGEF1wxcr5afw7cDr9fw70ROxupQcM3Kk9d3THJ6/h9KXMuYVtAhO6IAuRhgBggj1/xpu7KwSKcysc43DIz9eB/n61FAWSCWTAyhHOwE9cnnoMDH5daszfKgYEDEildoJ4yQOT7nv7dO4pO1h2sMQujzq7BfmIOGDEEjj8sH/HNOY77hxkgGM870GD79h9aQxELKCF24OQAcnkYOen/ANbNLNgPbOWCjbjhODkcc9uR6U1JCsPaTNsGVsupzw+c/N2H+eopJcPdBpAyKy7ifow7jHb0/rSD55J4xgLIzADPT5hkjJ/M5PWo/M/0ePBbdhcdSR6qB75H+NHPdaisPRDJ5wZWw+1shRjHJ/p/+vrTycQxSABNwAxhRjPGe/sKjDkFcgZdQN+chexOTn/Joj4tYxgApyzFAMYBIz7f5zSco9AsTEESJkMoGSFJGduAPyPPemZEd0wjK+WSH4fGcH07/T2pko2yq0Q3sgVcHqeD0x0Pyg/55mm2/bBIWd48bW3N/ezkAHt15PH1qrphsQwr++ZSSVVyVJbj7vByTyMH3/M02OMiFAkm7942Mke4z64xz7Z9BVlBtaQsoj2uyDYCp/hAHPQD/E+lFtxLIi7gA5O0Occ4x15Iwf8A9dK/Qq5B8iwqwVACAjDHTGc/j/8AXo/d7CW2M4UdyAeMk+3THr0p9sdo+cB8ONpBHzZGcHJHrjJP8+FidWDIjOyxoVBY5PYgfn/LrSdrAGNsX3Mrs+Zl+XaQevTP/wCukklYlD97cPnznOCc+3pSwAI07ykMyqQHI4HHBx9Oc9OeuadImyaKNvn6ECPs2AM88cnJ5544oWqFpcaZBHN5i7tu45ycZbP88Y9f6VHIEcSF+WP7wdeOD3784/Op5GSRvLGcAuFY8FT0AJPbjH4Y9CXRplWhdMu+DwcYJwWC57gn/OaGm9EGiG+TGqzK8CllA2jbkr9R14BzUhMbNIHBCOeD6EYO32PJ6+tMAGFuCqttUcAZ3ggfKV/BuD64zTpY1mhYQy5jZgy7sEnC5H8wKewhZJUYgeWzuqA4UEYJJPPpx+lPLpFgEHbHuK5IJIIOCDnjoKZGBJa4+Zd+GycbRxwuPxA6DrT1RWYM/wAvmYblcdAFCY685wfpTjK4rIkBCMGlDnaynJx1I6fmTx/KmrIAm1SYpVYKQ2D8oJ/EjvQqKmB5bJJguBuOB09OO+ByevPtIFjm8plcyEg7SfbGQfqSMj3q4u60FZDXfyfkJCyyYJOcAA8emP8A69Cs6iVGkCFU2nOAe2D05zmpooP3YDIqyj592zODjpjv9RmnPCyRpnDPneFJA3HGMZ9en+FUuZ6oWmxF++UZPzc4CgdB9ccHpTxGhPmyblkXG4jjJHoPYj8asbTgRscGM4QN0bjjk8jGfpSmAFA7gltqjIHzk5yfXPf8utVyO19yeZBJJ80jFCXK5wOg6Yz+lNQs20yKyEfIuTj68U8QKr7mYtEzH5QMjGM4z2HP4U0x+Y2CzE44J49Mcit7yvqRoNkQFiTzk8ew9v0rA16NntZCmOedpXJ9jmt3yi+GKs4245GCT/nv/Oq9zGSMrk/LgHHfqT+tbwXMTsfOviK1mPiItdKyqR8pPf6fjmur8P2KW86zSMu7aSod1HXOCDn2z07/AJ7vjrTY45I7tl3kP3B4z34/z9eaxVuzYwHy323BO8DG3nGcEjPqR16keldVao5xUUa0opamtrWqeTbGG3kaMtkuxY/MCMHIz6g9c8kVkafZtqd0kkhma3XCpzgOo6EE/j29qq2dvJqsgz8wdx84Ukg435AHoBzgdD+I9C0TSxbW4lRIh5JIJKHcAAGOcc9Bxx0A6DmuKrJUY8q3NXqLp9rH5UKLtIO0AhyMkDkYxxk4yOlaClVkkKw7GQMoBIyoyDnOR/eyf500EC4tg0ofzFf5TxwcOefXBPHTP51FMCZWTLRndJkKOv8ACo5GevPPHHNcKfcrctx/L5QzhQ4AwvCYUe/pgfnUBZRGVwxXAwQQg5APJ6cf1qGMAsZI0YyqyknOeducc9cZ7duOaUQpGxVJQ0zMSrOvLjYRk/of/wBdJsViwJ8tIcjG5vm8w4JwBn1Jx27Umxwsihd3m8EsSMnAyM+gJ7f/AF6kwX5jRt0hO3ccsARkgjGRnnoPQcU0u223kGzypN7IAeWGAy4Yfh06Y5HWjVhoSAyDl3Qnax2jrjqD7DpxS5IYZU7d3yBjjGMjBA69f/1Uza7SMsWd5ZowFGc98rnB4/P8qYyRkhmDbRgEcnHzjGB9FOfzqr2VyWiVJRvjkAlboCrLnPHUenOfxBFU4W2je43Rx4I/dhmJycfMf8+gqYDknbtVWDBQAQMFz+PGPXrUbxIEYEloxjHy4PAGP5fnRzXBDfL+VkPDHGRtPTcew+tIGAVGmVQ28MFYEAHp6+3bgY/GpJlUQ7BuGWwoXGOoxnjHr+v4wMd0AjXhU6klsfLuwcZ55x7U7pMCKTfI+IxKo2qocLzgdSPyxWRqknygYYbgBuGdp7/z/wD11pYVYCzJ0HPy4PHGP19hxWbqCbISchQFx8uQCc9/0/Ku7CSXOjGt8J2umDFhbj/YFXBVXT+LGD/cFWga/Qoq0T5ST1HCpFqMU8VQDxUgNRA1IKAP/9k=\\"}},{\\"attributes\\":{\\"align\\":\\"center\\"},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"In this place we can type\\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\" almost \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\"},\\"insert\\":\\"everything \\"},{\\"insert\\":\\"with \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"background\\":\\"#ffff00\\",\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\"Quill Rich Text \\"},{\\"attributes\\":{\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\".\\"},{\\"attributes\\":{\\"header\\":2},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"\\\\n\\\\nIn this place we can type almost everything with Quill Rich Text .\\\\n\\\\n\\\\nIn this place we can type\\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\" almost \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\"},\\"insert\\":\\"everything \\"},{\\"insert\\":\\"with \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"background\\":\\"#ffff00\\",\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\"Quill Rich Text \\"},{\\"attributes\\":{\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\".\\"},{\\"attributes\\":{\\"header\\":2},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"\\\\n\\\\nIn this place we can type almost everything with Quill Rich Text .\\\\n\\\\n\\\\nIn this place we can type\\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\" almost \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\"},\\"insert\\":\\"everything \\"},{\\"insert\\":\\"with \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"background\\":\\"#ffff00\\",\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\"Quill Rich Text \\"},{\\"attributes\\":{\\"font\\":\\"serif\\",\\"bold\\":true},\\"insert\\":\\".\\"},{\\"attributes\\":{\\"header\\":2},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"\\\\n\\\\n\\\\n\\"}]}","html":"<p class=\\"ql-align-center\\">In this place we can type almost everything with Quill Rich Text .</p><p><br></p><p><br></p><h2>In this place we can type<strong> almost </strong><span style=\\"color: rgb(230, 0, 0);\\">everything </span>with <strong style=\\"color: rgb(230, 0, 0); background-color: rgb(255, 255, 0);\\" class=\\"ql-font-serif\\">Quill Rich Text </strong><strong class=\\"ql-font-serif\\">.</strong></h2><p><br></p><p><a href=\\"http://www.Google.com\\" rel=\\"noopener noreferrer\\" target=\\"_blank\\">Google</a></p><p><br></p><p>In this place we can type almost everything with Quill Rich Text .</p><p><br></p><p class=\\"ql-align-center\\"><img src=\\"data:image/jpeg;base64,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\\" width=\\"454px\\"></p><h2>In this place we can type<strong> almost </strong><span style=\\"color: rgb(230, 0, 0);\\">everything </span>with <strong style=\\"color: rgb(230, 0, 0); background-color: rgb(255, 255, 0);\\" class=\\"ql-font-serif\\">Quill Rich Text </strong><strong class=\\"ql-font-serif\\">.</strong></h2><p><br></p><p><br></p><p>In this place we can type almost everything with Quill Rich Text .</p><p><br></p><p><br></p><h2>In this place we can type<strong> almost </strong><span style=\\"color: rgb(230, 0, 0);\\">everything </span>with <strong style=\\"color: rgb(230, 0, 0); background-color: rgb(255, 255, 0);\\" class=\\"ql-font-serif\\">Quill Rich Text </strong><strong class=\\"ql-font-serif\\">.</strong></h2><p><br></p><p><br></p><p>In this place we can type almost everything with Quill Rich Text .</p><p><br></p><p><br></p><h2>In this place we can type<strong> almost </strong><span style=\\"color: rgb(230, 0, 0);\\">everything </span>with <strong style=\\"color: rgb(230, 0, 0); background-color: rgb(255, 255, 0);\\" class=\\"ql-font-serif\\">Quill Rich Text </strong><strong class=\\"ql-font-serif\\">.</strong></h2><p><br></p><p><br></p><p><br></p>"}
\.


--
-- Name: app_content_filler_cfrichtext_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfrichtext_id_seq', 2, true);


--
-- Data for Name: app_content_filler_cftext; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cftext (id, key, value) FROM stdin;
6	about_us_page_title	Lingocept (about_us_page_title)\r\neducation theme, built specifically for the education centers which is dedicated to teaching and involve learners.
1	site_description	(site_description) Lingocept is Hub of Linguae\r\neducation theme, built specifically for the education centers which is dedicated to teaching and involve learners.
4	site_slogan	(site_slogan) Speak a foreign language like your native language
7	about_us_our_goal	(about_us_our_goal) We are here to give you an amazing experience in a new language learning  journey.
8	about_us_about_portal	(about_us_about_portal) How promotion excellent curiosity yet attempted happiness Gay prosperous impression\r\n                        had conviction For every delay death ask to style Me mean able my by in they Extremity now\r\n                        strangers contained.
11	about_us_content3	(about_us_content3) Happiness prosperous impression had conviction For every delay in they Extremity now strangers\r\n                        contained breakfast him discourse additions Sincerity collected contented led now perpetual\r\n                        extremely forfeited
10	about_us_content2	<b>(about_us_content2) </b> How promotion excellent curiosity yet attempted happiness Gay prosperous impression had\r\n                        conviction For every delay death ask to style Me mean able my by in they Extremity now strangers\r\n                        contained breakfast him discourse additions Sincerity collected contented led now perpetual\r\n                        extremely forfeited
12	about_us_title3	(about_us_title3) 35,000+ happy students joined with us to achieve their goals
9	about_us_title2	(about_us_title2) About Lingocept Portal
13	about_us_item1	Setup and installation takes lesstime
14	about_us_item2	Professional and easy to use software
15	about_us_item3	Perfect for any device with pixel-perfect design
16	about_us_item4	Setup and installation too fast
17	site_slogan_0	Limitless learning at your
18	site_slogan_highlight_word	fingertips
\.


--
-- Name: app_content_filler_cftext_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cftext_id_seq', 18, true);


--
-- Data for Name: app_content_filler_cfurl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfurl (id, key, value) FROM stdin;
1	site_url	https://www.Lingocept.com/
7	pinterest	https://www.pinterest.com/Lingocept
6	linkedin	https://www.linkedin.com/lingocept
5	instagram	https://www.instagram.com/lingocept
4	dribbble	https://www.dribbble.com/lingocept
3	facebook	https://www.facebook.com/lingocept
2	twitter	https://www.x.com/lingocept
\.


--
-- Name: app_content_filler_cfurl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfurl_id_seq', 7, true);


--
-- Data for Name: app_meeting_enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_meeting_enrollment (id, cost, session_id, student_id) FROM stdin;
\.


--
-- Name: app_meeting_enrollment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_meeting_enrollment_id_seq', 6, true);


--
-- Data for Name: app_meeting_period; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_meeting_period (id, day, "time") FROM stdin;
\.


--
-- Name: app_meeting_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_meeting_period_id_seq', 1, false);


--
-- Data for Name: app_meeting_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_meeting_review (id, rating, comment, create_date, last_modified, student_id, tutor_id) FROM stdin;
\.


--
-- Name: app_meeting_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_meeting_review_id_seq', 1, true);


--
-- Data for Name: app_meeting_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_meeting_schedule (id, date, day, start_time, end_time, tutor_id) FROM stdin;
\.


--
-- Name: app_meeting_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_meeting_schedule_id_seq', 6, true);


--
-- Data for Name: app_meeting_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_meeting_session (id, status, start_time, schedule_id, tutor_id) FROM stdin;
\.


--
-- Name: app_meeting_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_meeting_session_id_seq', 5, true);


--
-- Data for Name: app_pages_contactus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_contactus (id, name, phone, email, message, create_date, is_read) FROM stdin;
4	Ali Tweist	07911123456	socialavr@gmail.com	sdfsadfsaf	2025-03-19 16:55:19.414905+03:30	f
6	Ali Payam	079111-4123456	socialavr@gmail.com	Hiiii, hello	2025-03-19 23:58:48.836531+03:30	f
5	Ali Tweist	07911123456	socialavr@gmail.com	dfgsdgsdfgfg	2025-03-19 17:32:18.59736+03:30	t
3	Hasn Gholi	35135131	sdfasf@gasdf.df	sdfasfa	2025-03-19 16:33:22.160562+03:30	t
2	Hossein Rezaei	151313515161-245@	ho@g.com	Hello this is hosseion	2025-03-19 16:31:34.826911+03:30	t
7	Mary	089-7596-24	mary@g.com	Hi, This is Mary from New York. I'm an English native speaker but I can teach French well. so I have a request to check my resume and accept my request to be one of your tutors in the Lingocept big company. Thanks	2025-03-20 02:58:26.5838+03:30	t
1	Ali Tweist	07911123456	socialavr@gmail.com	hello. this is Oliver fron Clifornia. \r\nHow are you.? \r\n\r\nwhat are you doing?	2025-03-19 13:48:26.099209+03:30	f
8	Hasan Bhrami	54543543543	sdfasdfd@g.com	dsfsadfasdfsdfsa\r\nasdfasdf\r\nsadf	2025-03-23 23:23:21.680953+04:30	f
\.


--
-- Name: app_pages_contactus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_contactus_id_seq', 8, true);


--
-- Data for Name: app_pages_contentfiller; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_contentfiller (id, data_title, name, logo, url, phone_1, phone_2, email_1, email_2, address_line_1, address_line_2, site_description_1, site_description_2, site_slogan_1, site_slogan_2, text_1, text_2, text_3, text_4, text_5) FROM stdin;
1	site info	Lingocept	photos/logo/logo1_4wGfUd0.png	http://www.Lingocept.com	+49 265398-8596	+1 589-4253-1526	support@Lingocept.com	info@Lingocept.com	Germany, Berlin	US, Washington	Hub of Linguae		Speak a foreign language like a native speaker		lingocept@				
2	social_facebook	facebook		http://www.facebook.com/Lingocept															
3	social_linkedin	Linkedin		http://www.linkedin.com/Lingocept															
4	social_x	X		http://www.x.com/@Lingocept															
5	social_insta	Instagram		http://www.instagram.com/@Lingocept															
\.


--
-- Name: app_pages_contentfiller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_contentfiller_id_seq', 5, true);


--
-- Data for Name: app_pages_page; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_page (id, content, page_type) FROM stdin;
1	{"delta":"{\\"ops\\":[{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a \\"},{\\"attributes\\":{\\"background\\":\\"#0066cc\\"},\\"insert\\":\\"Richtext \\"},{\\"insert\\":\\"by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"attributes\\":{\\"background\\":\\"#ffc266\\"},\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"background\\":\\"#ffc266\\",\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"attributes\\":{\\"background\\":\\"#ffc266\\"},\\"insert\\":\\"you\\"},{\\"insert\\":\\"\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"color\\":\\"#ffff00\\",\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\"},{\\"insert\\":\\"hello booby. how \\"},{\\"attributes\\":{\\"color\\":\\"#e60000\\",\\"bold\\":true},\\"insert\\":\\"are \\"},{\\"insert\\":\\"you\\\\nI this really a Richtext by \\"},{\\"attributes\\":{\\"bold\\":true},\\"insert\\":\\"Quill\\"},{\\"attributes\\":{\\"header\\":1},\\"insert\\":\\"\\\\n\\\\n\\"}]}","html":"<p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a <span style=\\"background-color: rgb(0, 102, 204);\\">Richtext </span>by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p><span style=\\"background-color: rgb(255, 194, 102);\\">hello booby. how </span><strong style=\\"background-color: rgb(255, 194, 102); color: rgb(230, 0, 0);\\">are </strong><span style=\\"background-color: rgb(255, 194, 102);\\">you</span></p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong style=\\"color: rgb(255, 255, 0);\\">Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><p>hello booby. how <strong style=\\"color: rgb(230, 0, 0);\\">are </strong>you</p><h1>I this really a Richtext by <strong>Quill</strong></h1><h1><br></h1>"}	contact
\.


--
-- Name: app_pages_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_page_id_seq', 1, true);


--
-- Data for Name: app_staff_staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_staff_staff (profile_id, "position") FROM stdin;
\.


--
-- Data for Name: app_student_student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_student_student (id, major, session_count, tutor_count, profile_id) FROM stdin;
1	\N	0	0	1
2	\N	0	0	2
3	\N	0	0	5
\.


--
-- Name: app_student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_student_student_id_seq', 3, true);


--
-- Data for Name: app_student_student_interests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_student_student_interests (id, student_id, subject_id) FROM stdin;
1	1	1
2	2	2
\.


--
-- Name: app_student_student_interests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_student_student_interests_id_seq', 2, true);


--
-- Data for Name: app_student_subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_student_subject (id, name) FROM stdin;
1	Math
2	Physic
\.


--
-- Name: app_student_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_student_subject_id_seq', 2, true);


--
-- Data for Name: app_temp_languagelevel2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_languagelevel2 (id, name) FROM stdin;
1	A1
2	A2
3	B1
4	B2
5	C1
6	C2
\.


--
-- Name: app_temp_languagelevel2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_languagelevel2_id_seq', 6, true);


--
-- Data for Name: app_temp_session3; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_session3 (id, start_time, end_time, subject, tutor_id) FROM stdin;
1	2025-01-29 10:27:49+03:30	2025-01-29 11:28:05+03:30	Math	2
2	2025-01-29 10:28:44+03:30	2025-01-30 12:28:45+03:30	Physics	3
3	2025-01-29 10:29:00+03:30	2025-01-29 10:29:02+03:30	Piano	2
4	2025-02-02 10:29:57+03:30	2025-02-02 12:29:59+03:30	Cooking	2
\.


--
-- Name: app_temp_session3_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_session3_id_seq', 4, true);


--
-- Data for Name: app_temp_session3_students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_session3_students (id, session3_id, student3_id) FROM stdin;
1	1	1
2	1	2
3	2	1
4	2	3
5	3	3
6	3	4
7	4	2
\.


--
-- Name: app_temp_session3_students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_session3_students_id_seq', 7, true);


--
-- Data for Name: app_temp_skill2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_skill2 (id, name) FROM stdin;
1	Persian
2	Italian
3	Piano
4	Korean
5	Chinese
6	German
7	French
8	English
9	Turkish
10	Swedish
11	Russian
12	Japanese
13	Ukrainian
14	Physics
\.


--
-- Name: app_temp_skill2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_skill2_id_seq', 14, true);


--
-- Data for Name: app_temp_student3; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_student3 (id, major, session_count, tutor_count, profile_id) FROM stdin;
1	\N	0	0	5
2	\N	0	0	2
3	\N	0	0	1
4	\N	0	0	15
\.


--
-- Name: app_temp_student3_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_student3_id_seq', 4, true);


--
-- Data for Name: app_temp_student3_interests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_student3_interests (id, student3_id, subject2_id) FROM stdin;
\.


--
-- Name: app_temp_student3_interests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_student3_interests_id_seq', 1, false);


--
-- Data for Name: app_temp_subject2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_subject2 (id, name) FROM stdin;
1	Math
2	art
3	Psychology
\.


--
-- Name: app_temp_subject2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_subject2_id_seq', 3, true);


--
-- Data for Name: app_temp_tutor3; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_temp_tutor3 (id, bio, profile_id) FROM stdin;
2	Hello	3
3	dfs	6
4		7
5		8
6		4
7		9
8		10
9		11
\.


--
-- Name: app_temp_tutor3_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_temp_tutor3_id_seq', 9, true);


--
-- Data for Name: app_tutor_languagelevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_tutor_languagelevel (id, name) FROM stdin;
1	A1
2	A2
3	B1
4	C1
5	B2
6	C2
\.


--
-- Name: app_tutor_languagelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_tutor_languagelevel_id_seq', 6, true);


--
-- Data for Name: app_tutor_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_tutor_skill (id, name) FROM stdin;
1	Persian
2	French
3	Turkish
4	Ukrainian
5	Piano
\.


--
-- Name: app_tutor_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_tutor_skill_id_seq', 5, true);


--
-- Data for Name: app_tutor_tutor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_tutor_tutor (id, video_url, video_intro, cost_trial, cost_hourly, session_count, student_count, course_count, create_date, last_modified, profile_id) FROM stdin;
1			1.00	10.00	95	24	2	2025-01-25 22:35:38.075534+03:30	2025-01-25 22:37:08.75072+03:30	3
2			0.00	5.00	0	0	0	2025-01-25 22:55:06.928389+03:30	2025-01-25 22:55:06.928389+03:30	4
4			10.00	50.00	14	12	1	2025-01-25 23:30:18.43916+03:30	2025-01-26 12:26:55.317955+03:30	7
5			0.00	0.00	157	45	4	2025-01-25 23:30:26.781637+03:30	2025-01-26 12:27:25.46468+03:30	8
3			0.00	0.00	48	29	3	2025-01-25 23:30:06.531479+03:30	2025-01-26 12:27:40.33153+03:30	6
6			2.00	20.00	96	18	7	2025-01-26 12:36:46.246624+03:30	2025-01-26 12:36:46.246624+03:30	9
7			0.00	40.00	87	69	9	2025-01-26 12:38:45.400439+03:30	2025-01-26 12:38:45.399439+03:30	10
8			3.00	37.00	159	82	4	2025-01-26 12:40:21.770388+03:30	2025-01-26 12:41:59.470976+03:30	11
\.


--
-- Name: app_tutor_tutor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_tutor_tutor_id_seq', 8, true);


--
-- Data for Name: app_tutor_tutor_language_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_tutor_tutor_language_levels (id, tutor_id, languagelevel_id) FROM stdin;
1	1	1
2	1	2
3	2	3
4	3	2
5	4	1
6	4	3
7	5	2
8	5	3
9	6	3
10	7	5
11	7	6
12	8	1
13	8	2
14	8	3
15	8	4
16	8	5
\.


--
-- Name: app_tutor_tutor_language_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_tutor_tutor_language_levels_id_seq', 16, true);


--
-- Data for Name: app_tutor_tutor_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_tutor_tutor_skills (id, tutor_id, skill_id) FROM stdin;
1	1	1
2	1	2
3	2	1
4	2	3
5	3	3
6	4	2
7	5	1
8	6	2
9	6	4
10	7	3
11	7	4
12	7	5
13	8	2
\.


--
-- Name: app_tutor_tutor_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_tutor_tutor_skills_id_seq', 13, true);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group (id, name) FROM stdin;
1	student
2	staff
3	admin
4	tutor
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_id_seq', 4, true);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add user profile	7	add_userprofile
26	Can change user profile	7	change_userprofile
27	Can delete user profile	7	delete_userprofile
28	Can view user profile	7	view_userprofile
29	Can add language	8	add_language
30	Can change language	8	change_language
31	Can delete language	8	delete_language
32	Can view language	8	view_language
33	Can add content filler	9	add_contentfiller
34	Can change content filler	9	change_contentfiller
35	Can delete content filler	9	delete_contentfiller
36	Can view content filler	9	view_contentfiller
37	Can add language level	10	add_languagelevel
38	Can change language level	10	change_languagelevel
39	Can delete language level	10	delete_languagelevel
40	Can view language level	10	view_languagelevel
41	Can add skill	11	add_skill
42	Can change skill	11	change_skill
43	Can delete skill	11	delete_skill
44	Can view skill	11	view_skill
45	Can add tutor	12	add_tutor
46	Can change tutor	12	change_tutor
47	Can delete tutor	12	delete_tutor
48	Can view tutor	12	view_tutor
49	Can add subject	13	add_subject
50	Can change subject	13	change_subject
51	Can delete subject	13	delete_subject
52	Can view subject	13	view_subject
53	Can add student	14	add_student
54	Can change student	14	change_student
55	Can delete student	14	delete_student
56	Can view student	14	view_student
57	Can add schedule	15	add_schedule
58	Can change schedule	15	change_schedule
59	Can delete schedule	15	delete_schedule
60	Can view schedule	15	view_schedule
61	Can add review	16	add_review
62	Can change review	16	change_review
63	Can delete review	16	delete_review
64	Can view review	16	view_review
65	Can add session	17	add_session
66	Can change session	17	change_session
67	Can delete session	17	delete_session
68	Can view session	17	view_session
69	Can add enrollment	18	add_enrollment
70	Can change enrollment	18	change_enrollment
71	Can delete enrollment	18	delete_enrollment
72	Can view enrollment	18	view_enrollment
73	Can add period	19	add_period
74	Can change period	19	change_period
75	Can delete period	19	delete_period
76	Can view period	19	view_period
77	Can add subject2	20	add_subject2
78	Can change subject2	20	change_subject2
79	Can delete subject2	20	delete_subject2
80	Can view subject2	20	view_subject2
81	Can add language level2	21	add_languagelevel2
82	Can change language level2	21	change_languagelevel2
83	Can delete language level2	21	delete_languagelevel2
84	Can view language level2	21	view_languagelevel2
85	Can add tutor2	22	add_tutor2
86	Can change tutor2	22	change_tutor2
87	Can delete tutor2	22	delete_tutor2
88	Can view tutor2	22	view_tutor2
89	Can add schedule2	23	add_schedule2
90	Can change schedule2	23	change_schedule2
91	Can delete schedule2	23	delete_schedule2
92	Can view schedule2	23	view_schedule2
93	Can add skill2	24	add_skill2
94	Can change skill2	24	change_skill2
95	Can delete skill2	24	delete_skill2
96	Can view skill2	24	view_skill2
97	Can add student2	25	add_student2
98	Can change student2	25	change_student2
99	Can delete student2	25	delete_student2
100	Can view student2	25	view_student2
101	Can add session3	26	add_session3
102	Can change session3	26	change_session3
103	Can delete session3	26	delete_session3
104	Can view session3	26	view_session3
105	Can add student3	27	add_student3
106	Can change student3	27	change_student3
107	Can delete student3	27	delete_student3
108	Can view student3	27	view_student3
109	Can add tutor3	28	add_tutor3
110	Can change tutor3	28	change_tutor3
111	Can delete tutor3	28	delete_tutor3
112	Can view tutor3	28	view_tutor3
113	Can add language level	29	add_languagelevel
114	Can change language level	29	change_languagelevel
115	Can delete language level	29	delete_languagelevel
116	Can view language level	29	view_languagelevel
117	Can add skill	30	add_skill
118	Can change skill	30	change_skill
119	Can delete skill	30	delete_skill
120	Can view skill	30	view_skill
121	Can add tutor	31	add_tutor
122	Can change tutor	31	change_tutor
123	Can delete tutor	31	delete_tutor
124	Can view tutor	31	view_tutor
125	Can add subject	32	add_subject
126	Can change subject	32	change_subject
127	Can delete subject	32	delete_subject
128	Can view subject	32	view_subject
129	Can add student	33	add_student
130	Can change student	33	change_student
131	Can delete student	33	delete_student
132	Can view student	33	view_student
133	Can add period	34	add_period
134	Can change period	34	change_period
135	Can delete period	34	delete_period
136	Can view period	34	view_period
137	Can add schedule	35	add_schedule
138	Can change schedule	35	change_schedule
139	Can delete schedule	35	delete_schedule
140	Can view schedule	35	view_schedule
141	Can add review	36	add_review
142	Can change review	36	change_review
143	Can delete review	36	delete_review
144	Can view review	36	view_review
145	Can add session	37	add_session
146	Can change session	37	change_session
147	Can delete session	37	delete_session
148	Can view session	37	view_session
149	Can add availability	38	add_availability
150	Can change availability	38	change_availability
151	Can delete availability	38	delete_availability
152	Can view availability	38	view_availability
153	Can add appointment settings	39	add_appointmentsettings
154	Can change appointment settings	39	change_appointmentsettings
155	Can delete appointment settings	39	delete_appointmentsettings
156	Can view appointment settings	39	view_appointmentsettings
157	Can add appointment setting	39	add_appointmentsetting
158	Can change appointment setting	39	change_appointmentsetting
159	Can delete appointment setting	39	delete_appointmentsetting
160	Can view appointment setting	39	view_appointmentsetting
161	Can add skill level	29	add_skilllevel
162	Can change skill level	29	change_skilllevel
163	Can delete skill level	29	delete_skilllevel
164	Can view skill level	29	view_skilllevel
165	Can add notification	40	add_notification
166	Can change notification	40	change_notification
167	Can delete notification	40	delete_notification
168	Can view notification	40	view_notification
169	Can add notification	41	add_notification
170	Can change notification	41	change_notification
171	Can delete notification	41	delete_notification
172	Can view notification	41	view_notification
173	Can add bill	42	add_bill
174	Can change bill	42	change_bill
175	Can delete bill	42	delete_bill
176	Can view bill	42	view_bill
177	Can add p notification	43	add_pnotification
178	Can change p notification	43	change_pnotification
179	Can delete p notification	43	delete_pnotification
180	Can view p notification	43	view_pnotification
181	Can add c notification	44	add_cnotification
182	Can change c notification	44	change_cnotification
183	Can delete c notification	44	delete_cnotification
184	Can view c notification	44	view_cnotification
185	Can add contact us	45	add_contactus
186	Can change contact us	45	change_contactus
187	Can delete contact us	45	delete_contactus
188	Can view contact us	45	view_contactus
189	Can add admin profile	46	add_adminprofile
190	Can change admin profile	46	change_adminprofile
191	Can delete admin profile	46	delete_adminprofile
192	Can view admin profile	46	view_adminprofile
193	Can add staff	47	add_staff
194	Can change staff	47	change_staff
195	Can delete staff	47	delete_staff
196	Can view staff	47	view_staff
197	Can add cf boolean	48	add_cfboolean
198	Can change cf boolean	48	change_cfboolean
199	Can delete cf boolean	48	delete_cfboolean
200	Can view cf boolean	48	view_cfboolean
201	Can add cf date time	49	add_cfdatetime
202	Can change cf date time	49	change_cfdatetime
203	Can delete cf date time	49	delete_cfdatetime
204	Can view cf date time	49	view_cfdatetime
205	Can add cf decimal	50	add_cfdecimal
206	Can change cf decimal	50	change_cfdecimal
207	Can delete cf decimal	50	delete_cfdecimal
208	Can view cf decimal	50	view_cfdecimal
209	Can add cf file	51	add_cffile
210	Can change cf file	51	change_cffile
211	Can delete cf file	51	delete_cffile
212	Can view cf file	51	view_cffile
213	Can add cf image	52	add_cfimage
214	Can change cf image	52	change_cfimage
215	Can delete cf image	52	delete_cfimage
216	Can view cf image	52	view_cfimage
217	Can add cf text	53	add_cftext
218	Can change cf text	53	change_cftext
219	Can delete cf text	53	delete_cftext
220	Can view cf text	53	view_cftext
221	Can add cfurl	54	add_cfurl
222	Can change cfurl	54	change_cfurl
223	Can delete cfurl	54	delete_cfurl
224	Can view cfurl	54	view_cfurl
225	Can add cf integer	55	add_cfinteger
226	Can change cf integer	55	change_cfinteger
227	Can delete cf integer	55	delete_cfinteger
228	Can view cf integer	55	view_cfinteger
229	Can add cf char	56	add_cfchar
230	Can change cf char	56	change_cfchar
231	Can delete cf char	56	delete_cfchar
232	Can view cf char	56	view_cfchar
233	Can add cf email	57	add_cfemail
234	Can change cf email	57	change_cfemail
235	Can delete cf email	57	delete_cfemail
236	Can view cf email	57	view_cfemail
237	Can add cf float	58	add_cffloat
238	Can change cf float	58	change_cffloat
239	Can delete cf float	58	delete_cffloat
240	Can view cf float	58	view_cffloat
241	Can add cf boolean	59	add_cfboolean
242	Can change cf boolean	59	change_cfboolean
243	Can delete cf boolean	59	delete_cfboolean
244	Can view cf boolean	59	view_cfboolean
245	Can add cf char	60	add_cfchar
246	Can change cf char	60	change_cfchar
247	Can delete cf char	60	delete_cfchar
248	Can view cf char	60	view_cfchar
249	Can add cf date time	61	add_cfdatetime
250	Can change cf date time	61	change_cfdatetime
251	Can delete cf date time	61	delete_cfdatetime
252	Can view cf date time	61	view_cfdatetime
253	Can add cf decimal	62	add_cfdecimal
254	Can change cf decimal	62	change_cfdecimal
255	Can delete cf decimal	62	delete_cfdecimal
256	Can view cf decimal	62	view_cfdecimal
257	Can add cf email	63	add_cfemail
258	Can change cf email	63	change_cfemail
259	Can delete cf email	63	delete_cfemail
260	Can view cf email	63	view_cfemail
261	Can add cf file	64	add_cffile
262	Can change cf file	64	change_cffile
263	Can delete cf file	64	delete_cffile
264	Can view cf file	64	view_cffile
265	Can add cf float	65	add_cffloat
266	Can change cf float	65	change_cffloat
267	Can delete cf float	65	delete_cffloat
268	Can view cf float	65	view_cffloat
269	Can add cf image	66	add_cfimage
270	Can change cf image	66	change_cfimage
271	Can delete cf image	66	delete_cfimage
272	Can view cf image	66	view_cfimage
273	Can add cf integer	67	add_cfinteger
274	Can change cf integer	67	change_cfinteger
275	Can delete cf integer	67	delete_cfinteger
276	Can view cf integer	67	view_cfinteger
277	Can add cf text	68	add_cftext
278	Can change cf text	68	change_cftext
279	Can delete cf text	68	delete_cftext
280	Can view cf text	68	view_cftext
281	Can add cfurl	69	add_cfurl
282	Can change cfurl	69	change_cfurl
283	Can delete cfurl	69	delete_cfurl
284	Can view cfurl	69	view_cfurl
285	Can add cf rich text	70	add_cfrichtext
286	Can change cf rich text	70	change_cfrichtext
287	Can delete cf rich text	70	delete_cfrichtext
288	Can view cf rich text	70	view_cfrichtext
289	Can add Page	71	add_page
290	Can change Page	71	change_page
291	Can delete Page	71	delete_page
292	Can view Page	71	view_page
293	Can add wish list	72	add_wishlist
294	Can change wish list	72	change_wishlist
295	Can delete wish list	72	delete_wishlist
296	Can view wish list	72	view_wishlist
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_permission_id_seq', 296, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
5	pbkdf2_sha256$260000$aKPX2fVAwJTEQgb1BGMBDu$vGAfomLh72OIPO8mk4F/PqFFwtHqZjZfUGRSr+0GgV4=	2025-03-17 17:37:49.735586+03:30	f	Cynthia	Cynthia	Austin	Cynthia@gmail.com	f	t	2025-01-25 22:33:01+03:30
1	pbkdf2_sha256$260000$VcBS43kQeETFgzbzbmADLX$wXrqn802zHmKVYfNsEusPLTiRVLq71wUQpJubSW7kx4=	2025-01-25 22:21:14.995169+03:30	f	test15			test15@g.com	f	t	2025-01-25 22:21:14.581145+03:30
7	pbkdf2_sha256$260000$3tXt1ujoVcFNMVt8F5lkdI$5gkgvSbfJmlbn79DcqL9zmCoDn5Cu4yGvgB1UzYI8rk=	2025-03-23 18:47:32.472366+04:30	f	Reza	Reza	Rezaei	rez@g.com	f	t	2025-01-25 23:20:44+03:30
15	pbkdf2_sha256$260000$cnQTz0MrUW2QxqzFnVF5bT$qJpD1S9BIFWIIExe0tD+oSXvHYhWCMsXH2LXHYEq7xU=	2025-02-25 01:21:15.389427+03:30	f	Lori	Lori	Stevens	Lori@gmail.com	f	t	2025-01-25 23:26:10+03:30
23	pbkdf2_sha256$260000$AVIqePSrRgXwZ5xb2p1jH9$jTAP9B4Bbc1iPNkkJPxHvNA0GTId3NLIFYTODE52bA4=	2025-03-17 20:11:26.859571+03:30	f	Frances	Frances	Guerrero	Frances@g.com	f	t	2025-01-30 19:59:12+03:30
8	pbkdf2_sha256$260000$8Eqms5syvkWcpSujW25WZt$qAUIMsmISBtPi1z5ItIcoOqLUihaBXKyk156PPa/FWA=	\N	f	Mike	Mike	France	mike@g.com	f	t	2025-01-25 23:21:26+03:30
9	pbkdf2_sha256$260000$4seQ37BAiC2DRnSIMWcSug$y+xhDnnxr0/IPexM2PbRcGDsCDXgr5Oa5wsySrUcDlI=	\N	f	Philip	Philip	Veber	Phi@g.com	f	t	2025-01-25 23:22:04+03:30
10	pbkdf2_sha256$260000$xNzUSAS9BuY7sn8PrTjsLB$hjfu+1KqZzkBjQj3YhFArKB8WG4lWodJX0xY2pOVwlY=	\N	f	Sara	Sara	Smith	sara@g.com	f	t	2025-01-25 23:22:37+03:30
11	pbkdf2_sha256$260000$DEhxGpvoRrrsMg5xtD3e4H$k9PeHdXUrIZMWLbp9Fx6NOEBfaoHH0D1Sl7x8lc31MY=	\N	f	Nazila	Nazila	Farhadi	nazila@gg.com	f	t	2025-01-25 23:23:12+03:30
12	pbkdf2_sha256$260000$QfvZ8nlbugomnsAl1Jiay2$NJG3ZQsPiNFamcTXgddUE/5lKc+36TxdXXe38QmhQT8=	\N	f	Dennis	Dennis	Barrett	Dennis@g.com	f	t	2025-01-25 23:24:28+03:30
13	pbkdf2_sha256$260000$CEJGTeDcVMMJl16RvmoTyi$TB2ACRWf6SNwEK4Yiy10cjBc8Ns42WLco10Nyhs7aKU=	\N	f	Jacqueline	Jacqueline	Miller	JacquelineMiller@gmail.com	f	t	2025-01-25 23:25:02+03:30
36	pbkdf2_sha256$260000$U6aPdC3V22zHn6vFvx1FUg$Q8xxgMer/oME7D//HvqSfzN9VkbcZdjvcinzK/o/Ec4=	\N	f	martinsavannah	Cassandra	Higgins	jose66@example.net	f	t	2025-03-18 14:42:44.007548+03:30
14	pbkdf2_sha256$260000$o37euaC8E9T1xN4QYkk1qC$bqKol5fq3phYCa2X3mNw2Jq04tQ89J35wNevyB9bTWs=	2025-03-13 22:40:00.586936+03:30	f	Louis	Louis	Ferguson	LouisFerguson@gmail.com	f	t	2025-01-25 23:25:34+03:30
19	pbkdf2_sha256$260000$Y5VBvO325Fj4PKVKQwSwnI$ok6WW8V2Sd6ZkN8WsoP6oT98eRU7cNZSGG/CSfPCVLM=	\N	f	Joan	Joan	Wallace	Joan@g.com	f	t	2025-01-26 12:39:07+03:30
2	pbkdf2_sha256$260000$vfVxVZu12azHS2YyI8zxJk$Z+XnXSmAeu2NrNQPDxkLiiSvZZP0rrCY/5fvC+DAvVE=	2025-04-01 00:14:35.871811+04:30	t	lucas	Lucas	Valipour	lucas@g.com	t	t	2025-01-25 22:23:03+03:30
37	pbkdf2_sha256$260000$vKmvyOSMS46bfotRAXQ2Ab$TAGy9PNcqUb3LZi6xyFIi7eXJnBzjTQDE3kfyaOJdDU=	\N	f	jdaniels	Jessica	Hall	hgeorge@example.com	f	t	2025-03-18 14:56:35.593112+03:30
20	pbkdf2_sha256$260000$MgyfhB7lEYUdVdMfUGZMgL$YqP9kGnllSwD1c8b3AlprrbtkKk29hYRxclyBNmmE6w=	\N	f	Billy	Billy	Vasquez	Billy@g.com	f	t	2025-01-30 19:47:23+03:30
26	pbkdf2_sha256$260000$5gF9RwrMErzuC7jcuidNfz$V1WvPTEyLryuz7kAEGXjual+xCD6aM6DOFFJg2Da43g=	2025-03-17 20:15:22.39757+03:30	f	Mary	Mary	Clerk	mary@g.com	f	t	2025-03-15 21:15:31.257763+03:30
22	pbkdf2_sha256$260000$zX7XxhqHRHYgeMwyvMvist$akUIEIsadwbAzSRtAgr/Nd38zofbhnFa9HH3hh8o/Es=	\N	f	Larry	Larry	Lawson	Larry@google.com	f	t	2025-01-30 19:58:19+03:30
4	pbkdf2_sha256$260000$kccFGL6NNqGWQx5tadvIto$Egg77ZdM4SbVMQ7gpqb0TuC/zqjTay6GpCDbTgZPydQ=	2025-02-26 15:32:03.558728+03:30	f	Gholi	Gholi	Gholipour	gh@g.com	f	t	2025-01-25 22:28:15+03:30
3	pbkdf2_sha256$260000$bd938dxBuY0YBpgvFoJvQX$iiYkOiA20UonknEb72sTsNXETNnn+tG5ncv1Qx3VeN8=	2025-03-25 01:16:46.514682+04:30	f	Hesam	Hesam	Mogata	h@g.com	f	t	2025-01-25 22:24:55+03:30
27	pbkdf2_sha256$260000$spqnNqX0RuQ2NrhJNvvPdP$5vWz2waCONOGbjGnWpdijcHBKwMHp0wHeESRRhHzD5E=	\N	f	andrewpham	Steven	Williams	johnsonlance@example.net	f	t	2025-03-18 14:07:42.346739+03:30
38	pbkdf2_sha256$260000$ja4OqdVvXuXtBAzzN37ldI$rIGM0VC5JWJDFJ+amRO10NzPQnyl+58f3feVPEYFG6o=	\N	f	annaadams	Erin	Jackson	matalawrence@example.org	f	t	2025-03-18 15:07:38.429024+03:30
39	pbkdf2_sha256$260000$u7VNcxN3xjAtjuNljOBF8F$NSTNtu5hpu9bqVyqoBM9lxzUOLymJvT0lCpDVQAcy+w=	\N	f	millskathleen	Steven	Ray	katherine80@example.org	f	t	2025-03-18 15:38:04.140392+03:30
28	pbkdf2_sha256$260000$zquTuADl2gQYYu0Q9p05RZ$quQMGL9qkVtTZxaRHpvC8fh3q9usuneBmrzDH4ABkBs=	\N	f	jason70	David	Mccormick	matthewsexton@example.com	f	t	2025-03-18 14:07:42.665758+03:30
40	pbkdf2_sha256$260000$JwgZT1UkPZJ1qFSF6S4z9w$CeQWDALp7b42jhdbU/Y18TdglTQoCt3VZP7GdVkdBcw=	\N	f	dominic80	Jose	Goodman	katherinemartin@example.com	f	t	2025-03-18 15:43:15.849221+03:30
29	pbkdf2_sha256$260000$CpIP3WHCkO9PukDKPcEsal$HJYmOoykmg38GTIVk36s8q7C9fAK+fW9SBdtfb1vbAA=	\N	f	tkim	Danielle	Cooper	michael99@example.org	f	t	2025-03-18 14:07:42.966775+03:30
30	pbkdf2_sha256$260000$bS13UdbXC1h69x9CBdtN0V$/sJuVhcKFT5oxuW5GI/1OQdRQEp0/GtXwHSWxXzbPBE=	\N	f	vstephens	Lynn	Phillips	chanscott@example.com	f	t	2025-03-18 14:11:32.4449+03:30
21	pbkdf2_sha256$260000$5Gx4vqYqKshf2PvUzbI1o5$C9I30+pBFhugC/vxn5BK0OEf2tkZnDXU9Wns+a0Aq58=	2025-03-17 17:37:23.757137+03:30	f	Carolyn	Carolyn	Ortiz	Ortiz@g.com	f	t	2025-01-30 19:57:21+03:30
16	pbkdf2_sha256$260000$lVd15jx1I8p0TJMrnOwOfh$x+YSIiM+cqsFPAb5u2py5au6oSv5D/7IEUTW2QydT1Q=	2025-01-30 01:45:34.996594+03:30	f	Franco	Franco	Guerrero	Frances@g.com	f	t	2025-01-25 23:26:40+03:30
31	pbkdf2_sha256$260000$R6vG7Pfn2ClIcE72XR9JMl$NpHiArWdJZxibb0+Eg2cxdQa0DM3crETgG7s6IHdwf4=	\N	f	tmarshall	Charles	Patterson	amygutierrez@example.org	f	t	2025-03-18 14:11:32.750918+03:30
32	pbkdf2_sha256$260000$yCDGi26LioQlRNBIiXsYNH$dOAgoBKg1caL6KBmpM304qOA0z2GMhEAZ7Zyya6z3MI=	\N	f	davisjames	Brenda	Whitaker	brownmichael@example.com	f	t	2025-03-18 14:11:33.053935+03:30
18	pbkdf2_sha256$260000$wHXCLFzis82O1ZuRDC1MGc$WoPx+XoYqR1mvxk4AzuNoXdtXA+/0Pu6nb9M0n5F4Vs=	2025-01-30 02:37:17.890729+03:30	f	Samuel	Samuel	Bishop	Samuel@g.com	f	t	2025-01-26 12:37:24+03:30
33	pbkdf2_sha256$260000$ioIZHlsuuAQhcMfYxiSzKy$/hc9NQYqw23QCYp8i4KSPwZhm2GTvHAgYKKmjna1VIs=	\N	f	laurarodriguez	Amy	Banks	nathan12@example.net	f	t	2025-03-18 14:11:33.351952+03:30
24	pbkdf2_sha256$260000$sxNYqnt8n76ZXur2CMBNHn$k17ddmcZu5zfobn/oTUhvzv+58R6U8ynID9B/YjNAfc=	2025-02-25 01:24:26+03:30	f	Durove	Durove	Napalli	Samuel@g.com	f	t	2025-01-30 20:01:28+03:30
25	pbkdf2_sha256$260000$d1OdqqiTikc9iJTqtlAceH$mxAvtpugqCn2LrTtbuyYOps/StTyJd6NbjGk90FsbIU=	\N	f	test			Samuel@g.com	f	t	2025-03-07 16:33:11+03:30
34	pbkdf2_sha256$260000$VOGVSdkmCRnj30ImgHQVVY$QPdlt0FmF2/TeUbzaqzpdeQ8smezhMmB/VfccfgBGAI=	\N	f	tammyflores	Matthew	Davis	sadams@example.com	f	t	2025-03-18 14:11:33.654969+03:30
35	pbkdf2_sha256$260000$XHiZt2PIs9QGLaDEzBIMGW$QQSqB0fNHRhRPr/kT5tv3Tvux+JeveSci57xcKBeyek=	\N	f	nunezdavid	James	Khan	lewisluis@example.org	f	t	2025-03-18 14:42:43.70053+03:30
41	pbkdf2_sha256$260000$9vqcHLkmVkN4UrH0mDPwau$OnCV2woSNfV3qoOoXy3ETXUCl520TNiEq/63F0534wI=	\N	f	chicks	Leah	Nguyen	lmitchell@example.com	f	t	2025-03-18 15:43:27.126866+03:30
42	pbkdf2_sha256$260000$38TthpzOdflI3V2SQs1Zwc$bWnLXYI0TFtsys8kzK7MBspq16K/1MXsZcd6y/fGOhY=	\N	f	cassandra84	Richard	Nguyen	jillsimmons@example.net	f	t	2025-03-18 15:58:01.274865+03:30
43	pbkdf2_sha256$260000$BbdSDASRUeBYhw7daLN1Tx$YBAgAGilT7+pLGmkEAQMxask9/85fub2g2kyfUVjCfs=	\N	f	simonthomas	Laura	Smith	harriskristi@example.com	f	t	2025-03-18 15:58:04.432045+03:30
44	pbkdf2_sha256$260000$Z8X1EcDQYiYWRWbcxgJTjI$4Q4qa9SYPtle1bqJXoeMwZ78aAfdWjO/v/FCOduSHS0=	\N	f	mark58	Patrick	Houston	heather22@example.com	f	t	2025-03-18 15:59:12.273925+03:30
45	pbkdf2_sha256$260000$faYq1X8VjM2tohkFiBgIQZ$XgSDGzNfzIBfmCmwF44MjQytH5SmE9YxqDxsUxmpkLg=	\N	f	hbrown	Jeremy	Jackson	priceandrea@example.com	f	t	2025-03-18 15:59:14.960079+03:30
46	pbkdf2_sha256$260000$dMgx6C90OMr0044poN6uuZ$QH0Cxl9iSYna1THtMk8xlFVFjHYC5f6u7Qq30NtCpX8=	\N	f	acostajames	Joseph	Morales	lopezrobert@example.com	f	t	2025-03-18 16:38:22.455348+03:30
47	pbkdf2_sha256$260000$TnEgRXntHyVaoxylV0R6O5$D+I2OzLEnOAD1+ZCSBO2H4EtwtK8/6fTDaP//V6GRyo=	\N	f	ifuller	Rhonda	Reese	hdelacruz@example.com	f	t	2025-03-18 16:38:25.819541+03:30
48	pbkdf2_sha256$260000$4KKZwi2W72vDRHyzgxrkrU$q1sedal0zkSp7QPJYz6ce/vOYyZNfUbd6nc864sI23I=	\N	f	toddcummings	Lucas	Rivers	ernest14@example.net	f	t	2025-03-18 16:42:54.821927+03:30
49	pbkdf2_sha256$260000$lTYBwPPi82qZEK1sqE42dA$MNUds4cRLJPqS0hN0EVe5pgsaFB3h4pU8Unz+8X4XPU=	\N	f	michaeltorres	Robin	Zimmerman	rcooper@example.net	f	t	2025-03-18 16:42:57.935105+03:30
50	pbkdf2_sha256$260000$M18yu0SBbDol42JGXvx6iO$oLVVXNu+YPqnjxTS3ylkqqQRQDh1/IYb6VDgYcrwRS8=	\N	f	stephanie90	Vanessa	Medina	reyesbenjamin@example.net	f	t	2025-03-18 16:43:00.894274+03:30
51	pbkdf2_sha256$260000$TX9heFKOlOL4fKwdHg2zOr$h4DsiDxhpJ3s7ItBqBX3s+y264UA/iNzs1HxkhuBauE=	\N	f	patrickwhite	Michele	Rodriguez	james30@example.net	f	t	2025-03-18 16:43:04.066455+03:30
52	pbkdf2_sha256$260000$FjjV09RzobdIcF8uvPzton$WDyRofbcqSrqdGCg/H414TqhVpmq76cMTKJY47LdRy4=	\N	f	reedtyler	Jeffrey	Jackson	gclark@example.com	f	t	2025-03-18 16:43:07.141631+03:30
53	pbkdf2_sha256$260000$oedERqR3qG6TTiJKKtVfmb$SiaU10xjDk+MwytGwLKtHLXYhB47v7t4ORdL+jyRK24=	\N	f	schmidtjoseph	Amy	Mendez	david13@example.org	f	t	2025-03-18 16:43:10.26581+03:30
54	pbkdf2_sha256$260000$S19hTMHcMGQP7Q78jM6KdV$jlUeO77JZI/Kk/fec0OWqSJ8rzs9s5zzc3FiehJXCjQ=	\N	f	francisjustin	Becky	Olsen	evanskatherine@example.org	f	t	2025-03-18 16:43:13.140974+03:30
55	pbkdf2_sha256$260000$KATrBFJGzfghxupVKL5uOd$RFVqqWLcdHCWh9gmN6OqmBRDrGW7pn3eWFFJX7sXEIM=	\N	f	coxpatrick	Stacey	Hernandez	susanarnold@example.net	f	t	2025-03-18 16:43:16.03314+03:30
56	pbkdf2_sha256$260000$z8ASinuZud2v3TRJ2VBliW$4ueBD3XMpkZDv0kecRKwY/ey7LSE7DuipDB0JeoI7QI=	\N	f	williamsonemily	Kenneth	Vaughn	drogers@example.org	f	t	2025-03-18 16:43:19.208321+03:30
57	pbkdf2_sha256$260000$HzIJtEKTIM0hYNllkPP3XN$/+m6Ra574IcedUIgC+OqE3r/7i08DH62vV2AOydrWJA=	\N	f	jennifer57	Joseph	Carroll	whitemichael@example.com	f	t	2025-03-18 16:43:22.526511+03:30
58	pbkdf2_sha256$260000$TeMdmNwRPjgyQuP0XiB1Ud$oVNsp+IrW4/E6mWJVCdMnPkg5gePAZs7O2WjeLg1qnY=	\N	f	paceemily	Heather	Gardner	dawsonrachel@example.com	f	t	2025-03-18 16:43:25.379674+03:30
59	pbkdf2_sha256$260000$SzbKtHN9wOTN44uMbbWPCM$HOBNyZFdxleGsBqHSHGZYMM/TOmo6UjcUXVl5+IwN/Q=	\N	f	smedina	Bonnie	Rodriguez	gilbertemily@example.com	f	t	2025-03-18 16:43:28.516854+03:30
60	pbkdf2_sha256$260000$ZYg6GVcksosXDCjFM38zUD$UEtJol/6td7RTVZaVNrA5L4BCJBzPr+Bo2T8ybDGvQE=	\N	f	ruben41	Cassidy	Brady	kingchristina@example.net	f	t	2025-03-18 16:43:31.540027+03:30
61	pbkdf2_sha256$260000$1sV8a4Ha7eMu021qzgzGy3$GJEHq84jp1GVbaaPfFGPsUOF5nBQPbDP1Z42hV1olHc=	\N	f	huynhjacob	Joshua	Collins	laura82@example.net	f	t	2025-03-18 16:43:34.707208+03:30
62	pbkdf2_sha256$260000$cC6AhCbZZEGD9Pu6C6jztz$WaeZArF5MY723IPGYVnmgQn3k2klAIZjEjm//k2T2f0=	\N	f	ryan20	Amber	Moore	njones@example.net	f	t	2025-03-18 16:43:40.031512+03:30
63	pbkdf2_sha256$260000$K57ZpuBIsfGDDg1jKtMiz2$HDRokfiIyYS8zaYAWGOLqvsgEvxH2uJMiJZQbjXQH7U=	\N	f	melvinperez	Erika	Allen	janthony@example.net	f	t	2025-03-18 16:43:43.022684+03:30
64	pbkdf2_sha256$260000$HmmlJFgTnN1gAz5gneJNqp$GUsN6Tfq1Kx/zDA9yTbIMKG6aeXdG/detXFEZmD5IEs=	\N	f	dthomas	Kelli	Campbell	hnorton@example.org	f	t	2025-03-18 16:43:45.951851+03:30
65	pbkdf2_sha256$260000$4VeOd7gO2VUNxQGcnl0WqT$f8pJ8BQt/2fc02EycRIwmajJVTZUQjfZTMP4IYOGSzs=	\N	f	april82	Janet	Wood	oking@example.com	f	t	2025-03-18 16:43:48.752011+03:30
67	pbkdf2_sha256$260000$FwalJxv64ab3WPAvo1bKiF$l1z4GzCCjseA9y9vns6nHdZEfj/gZiOdSH13vc/CGvo=	\N	f	piercemegan	Joseph	Benson	christina67@example.com	f	t	2025-03-18 16:43:55.277384+03:30
68	pbkdf2_sha256$260000$aMvI86dSX1AFl7eph4cx9U$S63upGwPXeZJT9njg7RLWC/q1TxcUVtrxWVIljXhs+w=	\N	f	susan85	Amanda	Warren	steven97@example.net	f	t	2025-03-18 18:36:57.676805+03:30
69	pbkdf2_sha256$260000$3DnwZuBe7tNNEegxs5ux9Z$WO13+2OhXYpZ+XQawjDlOecRBSMk9OON6/mAz76T9u0=	\N	f	andersenbrenda	Christopher	Peterson	krandolph@example.net	f	t	2025-03-18 18:37:00.454964+03:30
70	pbkdf2_sha256$260000$hQnyOFVL4i8Mud62y0iNhl$zeDJvGKnc55vqpmocAAAYCOaYZOrzOWUjcFg/TLJQWo=	\N	f	davisdonald	Tony	Miller	amanda41@example.net	f	t	2025-03-18 18:37:03.431134+03:30
71	pbkdf2_sha256$260000$K8oF4WxVBJerQATXYXkFiK$T3zGUuPsZoLJVDCmr3yIVXdiW4Dq74OvGXFimrGA84E=	\N	f	plee	Justin	Wilson	cgay@example.org	f	t	2025-03-18 18:37:06.15929+03:30
72	pbkdf2_sha256$260000$XBxWxo9Rey1JQsuzu7IgIL$F5ZJXl5+GA4IqvLECSteLFEyOIyzqkOgO4RJVotFSXk=	\N	f	christopherlee	Desiree	Washington	hinesdaniel@example.com	f	t	2025-03-18 18:37:09.012453+03:30
73	pbkdf2_sha256$260000$k6LbUVC1Adc3kOAH8LZdbc$oCin3Zs4fluC0O21sZ/+w9LTTnd2GNZ94BlqmySC8V8=	\N	f	cameroncorey	Sheila	Thompson	newtonstacy@example.org	f	t	2025-03-18 18:37:11.837615+03:30
74	pbkdf2_sha256$260000$JuZ7q8KqlCbKEEjQLbdetD$f+stzjLCmc5R5syUbGqghYnw91Ucmo0Pl3DLS10ysfk=	\N	f	greentheresa	Jennifer	Bowen	kristin59@example.com	f	t	2025-03-18 18:37:14.710779+03:30
75	pbkdf2_sha256$260000$fb4fNbbq2mENVszuylde9P$YEuaWKGqJ+4AE4VtYYA3ZK10BQgTi81Ixrrjkaez0D8=	\N	f	millerlaura	Brian	Hernandez	ywilliams@example.org	f	t	2025-03-18 18:37:17.409934+03:30
76	pbkdf2_sha256$260000$UCUJjX09EmWlZ93WUe9rH5$VUNM75+R6Z6UAwNeSWsKMkEvx2dGZ3iScHiVZOGUgeU=	\N	f	benjamin27	Christopher	Allen	jacqueline42@example.org	f	t	2025-03-18 18:37:19.996082+03:30
77	pbkdf2_sha256$260000$KugK3MO7Dv6HIGbxUZmzNd$BcYrdTcoNq9zmS3PgWd531yvtSR2WHF5/Sd4fdWGoaM=	\N	f	josephraymond	Gregory	Montoya	tammy12@example.com	f	t	2025-03-18 18:37:22.813243+03:30
78	pbkdf2_sha256$260000$yESbbUlIPBcQlDAZQP9E6o$vAIXKuJr2ZyDD3vc1TVtARTeyhDaXZh83F/QQ8M1zOw=	\N	f	brownemily	William	Ibarra	mharmon@example.org	f	t	2025-03-18 18:37:26.500454+03:30
79	pbkdf2_sha256$260000$7rjVfIDojNC3nVws6Y1q2N$eHmN5kCSkInotPh5CWpBwOvBZl02/yqqHNevlBASVw8=	\N	f	ytaylor	Nicholas	Lutz	xmunoz@example.org	f	t	2025-03-18 18:37:29.253611+03:30
80	pbkdf2_sha256$260000$h3GJOwiio4kS1sca2iB0Ex$EgUPyH8700085Opu46We7E202XWBME26LraqSWbdT+A=	\N	f	lindsey57	Douglas	Robinson	thomasstewart@example.net	f	t	2025-03-18 18:37:32.21078+03:30
81	pbkdf2_sha256$260000$r2ojPLzWbt1RmW0uGLCv29$oUD2RGUenbBIjrUEdCQ0lHUutGqcUs5vATHUQKvbng8=	\N	f	samuel33	Cameron	Lewis	bjones@example.net	f	t	2025-03-18 18:37:34.888933+03:30
82	pbkdf2_sha256$260000$G6LPjLtwGeAfCZR5fOu3Rb$3tF1HAYVJ6Dh1WetloImyhveiKU/iOMKJHVl7rKlCcc=	\N	f	clinevalerie	Andrew	Robinson	sean81@example.org	f	t	2025-03-18 18:37:37.63109+03:30
83	pbkdf2_sha256$260000$ivprLwGxQRLIS0EBCi5n0p$wbAQpmFbWpp+lZAcy/LWQFn1xaBuNf1Vs8Lt7ppLue0=	\N	f	martinezjason	Haley	Wells	floresrhonda@example.org	f	t	2025-03-18 18:37:40.126233+03:30
84	pbkdf2_sha256$260000$XCuhLEfJqGeo9ZbHQNrwGY$qavGCM8QFJf93wpkBBmFuFMvJAxsFyKyX/2uEET1aHg=	\N	f	brodriguez	Mary	Lutz	charleswatts@example.com	f	t	2025-03-18 18:37:42.970396+03:30
85	pbkdf2_sha256$260000$sIVRY8dGvpTgFCKcEdKrgf$jbgd+qB2EfVo4usD+nDh6/m81X0BI47IKzzY/DYEdGc=	\N	f	joshuahutchinson	Julia	Spencer	walkersheila@example.org	f	t	2025-03-18 18:37:45.797557+03:30
86	pbkdf2_sha256$260000$KTzgt1w9AEx8GOxYp9V1zm$kMJtGqlR2t4AWWOgwJ1qUug1xzWgIzeXWPdE5uLVYH0=	\N	f	lauren47	Rebecca	Lewis	smithjessica@example.org	f	t	2025-03-18 18:37:48.46771+03:30
88	pbkdf2_sha256$260000$09ghSN6kJyv04zqsW7oKi0$flygy72lQqIZPRRpd0+TWKVykqOFLYTUEh1rDVlPAzw=	2025-03-18 22:08:25.835387+03:30	f	Martin			martin@g.com	f	t	2025-03-18 20:44:03.680808+03:30
87	pbkdf2_sha256$260000$3FfRKLn4Rj6c084ldYtEAK$wXNpV/Pn9OfQnEoUNTfj8mRnLAgMfARjad9ocO65tN0=	2025-03-21 23:57:32.171034+03:30	f	alyssa24	Connie	Oliver	joan04@example.net	f	t	2025-03-18 18:37:51.217867+03:30
17	pbkdf2_sha256$260000$3s1BdVTGj6yD95gx0yzZdw$pu1ApH+wlUEIycW9MNjO7ovjmNdIHgRPd47PhP6UXu4=	2025-03-24 16:05:46.313316+04:30	f	Amanda	Amanda	Reed	Amanda@g.com	f	t	2025-01-26 12:35:32+03:30
66	pbkdf2_sha256$260000$W0kdEs7ObsvCiwtMSkVkNE$fJ4+sUzUZ8dtCm0Bo42RuwGWBu3mUUicXp3jURjnU5s=	2025-03-24 23:40:41.293322+04:30	f	jonesmichael	Kenneth	Romero	wmitchell@example.org	f	t	2025-03-18 16:43:52.009198+03:30
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
1	3	1
2	4	1
3	5	4
8	16	1
9	13	4
10	15	4
11	14	4
12	12	4
16	17	4
17	18	4
18	19	4
20	2	3
22	7	1
26	20	1
27	21	1
28	22	1
29	23	1
30	24	1
142	25	4
146	26	2
157	27	4
160	28	1
163	29	4
165	30	2
168	31	4
171	32	4
174	33	4
177	34	2
180	34	4
182	35	1
185	36	4
188	37	1
189	38	4
191	39	2
192	40	4
193	41	4
197	42	4
201	43	1
205	44	1
209	45	1
213	46	4
216	47	1
220	48	4
223	49	1
227	50	1
231	51	4
234	52	2
237	53	1
241	54	1
245	55	1
249	56	1
253	57	4
256	58	4
259	59	1
263	60	1
267	61	2
270	62	1
274	63	4
277	64	1
281	65	4
284	66	1
288	67	4
291	68	4
294	69	4
297	70	4
300	71	4
303	72	4
306	73	4
309	74	4
312	75	4
315	76	4
318	77	4
321	78	4
324	79	4
327	80	4
330	81	4
333	82	4
336	83	4
339	84	4
342	85	4
345	86	4
348	87	4
351	88	1
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 366, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_id_seq', 88, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2025-01-25 22:23:44.226704+03:30	1	Dutch	1	[{"added": {}}]	8	2
2	2025-01-25 22:24:55.405775+03:30	3	Hasan	1	[{"added": {}}]	4	2
3	2025-01-25 22:25:25.429493+03:30	3	Hasan	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
4	2025-01-25 22:26:08.053931+03:30	1	student	1	[{"added": {}}]	3	2
5	2025-01-25 22:26:13.933267+03:30	2	staff	1	[{"added": {}}]	3	2
6	2025-01-25 22:26:24.956897+03:30	3	admin	1	[{"added": {}}]	3	2
7	2025-01-25 22:26:39.885751+03:30	4	tutor	1	[{"added": {}}]	3	2
8	2025-01-25 22:26:54.231572+03:30	1	Hasan	1	[{"added": {}}]	7	2
9	2025-01-25 22:27:27.796492+03:30	2	Persian	1	[{"added": {}}]	8	2
10	2025-01-25 22:27:37.340038+03:30	3	English	1	[{"added": {}}]	8	2
11	2025-01-25 22:27:42.410328+03:30	4	Spanish	1	[{"added": {}}]	8	2
12	2025-01-25 22:27:51.218831+03:30	5	French	1	[{"added": {}}]	8	2
13	2025-01-25 22:28:15.719233+03:30	4	Gholi	1	[{"added": {}}]	4	2
14	2025-01-25 22:28:42.878786+03:30	2	Gholi	1	[{"added": {}}]	7	2
15	2025-01-25 22:33:01.651587+03:30	5	Cynthia	1	[{"added": {}}]	4	2
16	2025-01-25 22:33:58.233823+03:30	3	Cynthia	1	[{"added": {}}]	7	2
17	2025-01-25 22:35:05.30466+03:30	1	Persian	1	[{"added": {}}]	11	2
18	2025-01-25 22:35:09.413895+03:30	2	French	1	[{"added": {}}]	11	2
19	2025-01-25 22:35:15.755257+03:30	1	A1	1	[{"added": {}}]	10	2
20	2025-01-25 22:35:20.134508+03:30	2	A2	1	[{"added": {}}]	10	2
21	2025-01-25 22:35:38.085535+03:30	1	Cynthia	1	[{"added": {}}]	12	2
22	2025-01-25 22:36:04.186027+03:30	3	Cynthia	2	[{"changed": {"fields": ["Photo"]}}]	7	2
23	2025-01-25 22:36:58.966161+03:30	5	Cynthia	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
24	2025-01-25 22:37:04.063452+03:30	3	Cynthia	2	[]	7	2
25	2025-01-25 22:37:08.756721+03:30	1	Cynthia	2	[]	12	2
26	2025-01-25 22:37:38.842441+03:30	4	Gholi	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
27	2025-01-25 22:42:22.510666+03:30	3	Cynthia	2	[{"changed": {"fields": ["Rating"]}}]	7	2
28	2025-01-25 22:51:27.849858+03:30	1	Cynthia - TUE (19:21:22 - 20:21:22)	1	[{"added": {}}]	15	2
29	2025-01-25 22:51:56.021469+03:30	2	Cynthia - FRI (09:21:38 - 10:00:00)	1	[{"added": {}}]	15	2
30	2025-01-25 22:52:39.376949+03:30	6	dennis	1	[{"added": {}}]	4	2
31	2025-01-25 22:54:38.020735+03:30	4	dennis	1	[{"added": {}}]	7	2
32	2025-01-25 22:54:53.392614+03:30	3	Turkish	1	[{"added": {}}]	11	2
33	2025-01-25 22:54:58.73592+03:30	3	B1	1	[{"added": {}}]	10	2
34	2025-01-25 22:55:06.936389+03:30	2	dennis	1	[{"added": {}}]	12	2
35	2025-01-25 22:55:28.875644+03:30	3	dennis - SAT (07:25:19 - 11:25:21)	1	[{"added": {}}]	15	2
36	2025-01-25 23:20:44.656342+03:30	7	Reza	1	[{"added": {}}]	4	2
37	2025-01-25 23:21:07.035622+03:30	7	Reza	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
38	2025-01-25 23:21:26.493735+03:30	8	Mike	1	[{"added": {}}]	4	2
39	2025-01-25 23:21:43.882729+03:30	8	Mike	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
40	2025-01-25 23:22:04.3509+03:30	9	Philip	1	[{"added": {}}]	4	2
41	2025-01-25 23:22:24.263039+03:30	9	Philip	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
42	2025-01-25 23:22:38.191835+03:30	10	Sara	1	[{"added": {}}]	4	2
43	2025-01-25 23:22:52.973681+03:30	10	Sara	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
44	2025-01-25 23:23:12.996826+03:30	11	Nazila	1	[{"added": {}}]	4	2
45	2025-01-25 23:23:38.956311+03:30	11	Nazila	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
46	2025-01-25 23:24:28.996173+03:30	12	Dennis	1	[{"added": {}}]	4	2
47	2025-01-25 23:24:47.718244+03:30	12	Dennis	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
48	2025-01-25 23:25:02.839109+03:30	13	Jacqueline	1	[{"added": {}}]	4	2
49	2025-01-25 23:25:19.362054+03:30	13	Jacqueline	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
50	2025-01-25 23:25:35.273964+03:30	14	Louis	1	[{"added": {}}]	4	2
51	2025-01-25 23:25:53.253992+03:30	14	Louis	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
52	2025-01-25 23:26:10.863+03:30	15	Lori	1	[{"added": {}}]	4	2
53	2025-01-25 23:26:26.516895+03:30	15	Lori	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
54	2025-01-25 23:26:40.913718+03:30	16	Frances	1	[{"added": {}}]	4	2
55	2025-01-25 23:26:55.664562+03:30	16	Frances	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
56	2025-01-25 23:27:36.901921+03:30	5	Frances	1	[{"added": {}}]	7	2
57	2025-01-25 23:27:55.929009+03:30	6	Jacqueline	1	[{"added": {}}]	7	2
58	2025-01-25 23:28:18.395294+03:30	7	Lori	1	[{"added": {}}]	7	2
59	2025-01-25 23:29:07.80112+03:30	8	Louis	1	[{"added": {}}]	7	2
60	2025-01-25 23:29:25.98616+03:30	4	Dennis	2	[{"changed": {"fields": ["User"]}}]	7	2
61	2025-01-25 23:30:06.54048+03:30	3	Jacqueline	1	[{"added": {}}]	12	2
62	2025-01-25 23:30:18.44616+03:30	4	Lori	1	[{"added": {}}]	12	2
63	2025-01-25 23:30:26.788638+03:30	5	Louis	1	[{"added": {}}]	12	2
64	2025-01-25 23:30:34.69409+03:30	4	C1	1	[{"added": {}}]	10	2
65	2025-01-25 23:31:37.28767+03:30	4	Dennis - FRI (10:01:21 - 12:01:22)	1	[{"added": {}}]	15	2
66	2025-01-25 23:31:52.220524+03:30	1	Session for Dennis on 2025-02-25 (20:00) - pending	1	[{"added": {}}]	17	2
67	2025-01-25 23:32:10.269556+03:30	2	Session for Jacqueline on 2025-01-25 (20:01) - confirmed	1	[{"added": {}}]	17	2
68	2025-01-25 23:36:08.702194+03:30	1	Math	1	[{"added": {}}]	13	2
69	2025-01-25 23:36:11.006326+03:30	1	Hasan	1	[{"added": {}}]	14	2
70	2025-01-25 23:36:20.639877+03:30	2	Physic	1	[{"added": {}}]	13	2
71	2025-01-25 23:36:23.310029+03:30	2	Gholi	1	[{"added": {}}]	14	2
72	2025-01-25 23:36:28.060301+03:30	3	Frances	1	[{"added": {}}]	14	2
73	2025-01-25 23:37:50.818035+03:30	16	Franco	2	[{"changed": {"fields": ["Username", "First name"]}}]	4	2
74	2025-01-25 23:37:53.836207+03:30	5	Franco	2	[{"changed": {"fields": ["Photo"]}}]	7	2
75	2025-01-25 23:38:02.317692+03:30	2	Gholi	2	[{"changed": {"fields": ["Photo"]}}]	7	2
76	2025-01-25 23:38:09.491103+03:30	1	Hasan	2	[{"changed": {"fields": ["Photo"]}}]	7	2
77	2025-01-26 00:21:36.926239+03:30	3	Session for Cynthia on 2025-01-25 (20:51) - confirmed	1	[{"added": {}}]	17	2
78	2025-01-26 01:46:00.127725+03:30	5	2025-01-25 - FRI - (21:15:54 - 22:15:55)	1	[{"added": {}}]	15	2
79	2025-01-26 01:46:22.374997+03:30	6	2025-01-25 - FRI - (21:16:18 - 22:16:18)	1	[{"added": {}}]	15	2
80	2025-01-26 12:26:55.330956+03:30	4	Lori	2	[{"changed": {"fields": ["Cost trial", "Cost hourly", "Session count", "Student count", "Course count"]}}]	12	2
81	2025-01-26 12:27:25.481681+03:30	5	Louis	2	[{"changed": {"fields": ["Session count", "Student count", "Course count"]}}]	12	2
404	2025-03-03 00:31:13.091033+03:30	8	Louis	2	[{"changed": {"fields": ["Bio"]}}]	7	2
82	2025-01-26 12:27:40.341531+03:30	3	Jacqueline	2	[{"changed": {"fields": ["Session count", "Student count", "Course count"]}}]	12	2
83	2025-01-26 12:35:32.560409+03:30	17	Amanda	1	[{"added": {}}]	4	2
84	2025-01-26 12:36:17.370972+03:30	9	Amanda	1	[{"added": {}}]	7	2
85	2025-01-26 12:36:26.104472+03:30	4	Ukrainian	1	[{"added": {}}]	11	2
86	2025-01-26 12:36:46.257624+03:30	6	Amanda	1	[{"added": {}}]	12	2
87	2025-01-26 12:37:24.334802+03:30	18	Samuel	1	[{"added": {}}]	4	2
88	2025-01-26 12:37:49.232226+03:30	6	Japanese	1	[{"added": {}}]	8	2
89	2025-01-26 12:38:04.284087+03:30	10	Samuel	1	[{"added": {}}]	7	2
90	2025-01-26 12:38:14.540674+03:30	5	Piano	1	[{"added": {}}]	11	2
91	2025-01-26 12:38:19.359949+03:30	5	B2	1	[{"added": {}}]	10	2
92	2025-01-26 12:38:23.109164+03:30	6	C2	1	[{"added": {}}]	10	2
93	2025-01-26 12:38:45.42144+03:30	7	Samuel	1	[{"added": {}}]	12	2
94	2025-01-26 12:39:08.092174+03:30	19	Joan	1	[{"added": {}}]	4	2
95	2025-01-26 12:39:33.100604+03:30	7	Swedish	1	[{"added": {}}]	8	2
96	2025-01-26 12:39:52.555717+03:30	11	Joan	1	[{"added": {}}]	7	2
97	2025-01-26 12:40:21.779389+03:30	8	Joan	1	[{"added": {}}]	12	2
98	2025-01-26 12:41:43.928087+03:30	19	Joan	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
99	2025-01-26 12:41:54.234677+03:30	11	Joan	2	[]	7	2
100	2025-01-26 12:41:59.480977+03:30	8	Joan	2	[]	12	2
101	2025-01-26 12:42:46.39866+03:30	17	Amanda	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
102	2025-01-26 12:43:03.408633+03:30	6	dennis	3		4	2
103	2025-01-26 12:43:28.102046+03:30	18	Samuel	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
104	2025-01-26 13:56:18.680142+03:30	2	lucas	2	[{"changed": {"fields": ["First name", "Last name", "Groups"]}}]	4	2
105	2025-01-26 14:04:45.452106+03:30	12	lucas	1	[{"added": {}}]	7	2
106	2025-01-29 08:54:11.124685+03:30	1	Persian	1	[{"added": {}}]	24	2
107	2025-01-29 08:54:14.988906+03:30	2	Italian	1	[{"added": {}}]	24	2
108	2025-01-29 08:54:20.65323+03:30	3	Piano	1	[{"added": {}}]	24	2
109	2025-01-29 08:54:22.92136+03:30	4	Korean	1	[{"added": {}}]	24	2
110	2025-01-29 08:54:25.127486+03:30	5	Chinese	1	[{"added": {}}]	24	2
111	2025-01-29 08:54:27.002593+03:30	6	German	1	[{"added": {}}]	24	2
112	2025-01-29 08:54:29.276724+03:30	7	French	1	[{"added": {}}]	24	2
113	2025-01-29 08:54:45.974679+03:30	8	English	1	[{"added": {}}]	24	2
114	2025-01-29 08:54:55.715236+03:30	9	Turkish	1	[{"added": {}}]	24	2
115	2025-01-29 08:54:59.095429+03:30	10	Swedish	1	[{"added": {}}]	24	2
116	2025-01-29 08:55:06.071828+03:30	11	Russian	1	[{"added": {}}]	24	2
117	2025-01-29 08:55:10.003053+03:30	12	Japanese	1	[{"added": {}}]	24	2
118	2025-01-29 08:55:13.175234+03:30	13	Ukrainian	1	[{"added": {}}]	24	2
119	2025-01-29 09:33:50.241302+03:30	14	Physics	1	[{"added": {}}]	24	2
120	2025-01-29 09:34:08.90337+03:30	1	A1	1	[{"added": {}}]	21	2
121	2025-01-29 09:34:15.545749+03:30	1	Cynthia	1	[{"added": {}}]	22	2
122	2025-01-29 09:34:24.943287+03:30	2	A2	1	[{"added": {}}]	21	2
123	2025-01-29 09:34:27.455431+03:30	2	Jacqueline	1	[{"added": {}}]	22	2
124	2025-01-29 09:34:36.567952+03:30	3	B1	1	[{"added": {}}]	21	2
125	2025-01-29 09:34:38.504063+03:30	3	Lori	1	[{"added": {}}]	22	2
126	2025-01-29 09:34:52.693874+03:30	4	B2	1	[{"added": {}}]	21	2
127	2025-01-29 09:34:54.336968+03:30	4	Louis	1	[{"added": {}}]	22	2
128	2025-01-29 09:35:07.992749+03:30	5	C1	1	[{"added": {}}]	21	2
129	2025-01-29 09:35:08.805796+03:30	5	Amanda	1	[{"added": {}}]	22	2
130	2025-01-29 09:35:19.468406+03:30	6	C2	1	[{"added": {}}]	21	2
131	2025-01-29 09:35:20.961491+03:30	6	Samuel	1	[{"added": {}}]	22	2
132	2025-01-29 09:35:42.79074+03:30	1	Math	1	[{"added": {}}]	20	2
133	2025-01-29 09:35:44.861858+03:30	1	Student2 object (1)	1	[{"added": {}}]	25	2
134	2025-01-29 09:35:57.558584+03:30	2	art	1	[{"added": {}}]	20	2
135	2025-01-29 09:35:59.247681+03:30	2	Student2 object (2)	1	[{"added": {}}]	25	2
136	2025-01-29 09:36:06.357088+03:30	3	Student2 object (3)	1	[{"added": {}}]	25	2
137	2025-01-29 09:36:22.765026+03:30	3	Psychology	1	[{"added": {}}]	20	2
138	2025-01-29 09:36:25.041156+03:30	4	Student2 object (4)	1	[{"added": {}}]	25	2
139	2025-01-29 09:40:21.368673+03:30	15	Reza	2	[{"changed": {"fields": ["Country", "Lang native", "Bio", "Rating", "Reviews count"]}}]	7	2
140	2025-01-29 10:26:43.126704+03:30	2	Cynthia	1	[{"added": {}}]	28	2
141	2025-01-29 10:26:47.809972+03:30	3	Jacqueline	1	[{"added": {}}]	28	2
142	2025-01-29 10:26:50.719138+03:30	4	Lori	1	[{"added": {}}]	28	2
143	2025-01-29 10:26:53.483296+03:30	5	Louis	1	[{"added": {}}]	28	2
144	2025-01-29 10:26:56.357461+03:30	6	Dennis	1	[{"added": {}}]	28	2
145	2025-01-29 10:26:58.869604+03:30	7	Amanda	1	[{"added": {}}]	28	2
146	2025-01-29 10:27:01.375748+03:30	8	Samuel	1	[{"added": {}}]	28	2
147	2025-01-29 10:27:03.86089+03:30	9	Joan	1	[{"added": {}}]	28	2
148	2025-01-29 10:27:16.533615+03:30	1	Franco	1	[{"added": {}}]	27	2
149	2025-01-29 10:27:23.286001+03:30	2	Gholi	1	[{"added": {}}]	27	2
150	2025-01-29 10:27:26.157165+03:30	3	Hasan	1	[{"added": {}}]	27	2
151	2025-01-29 10:27:28.984327+03:30	4	Reza	1	[{"added": {}}]	27	2
152	2025-01-29 10:28:20.197256+03:30	1	Math session with Cynthia at 2025-01-29 06:57:49+00:00	1	[{"added": {}}]	26	2
153	2025-01-29 10:28:54.298206+03:30	2	Physics session with Jacqueline at 2025-01-29 06:58:44+00:00	1	[{"added": {}}]	26	2
154	2025-01-29 10:29:51.952504+03:30	3	Piano session with Cynthia at 2025-01-29 06:59:00+00:00	1	[{"added": {}}]	26	2
155	2025-01-29 10:30:28.77561+03:30	4	Cooking session with Cynthia at 2025-02-02 06:59:57+00:00	1	[{"added": {}}]	26	2
156	2025-01-29 12:38:26.963302+03:30	1	Franco	1	[{"added": {}}]	33	2
157	2025-01-29 12:38:30.350491+03:30	2	Gholi	1	[{"added": {}}]	33	2
158	2025-01-29 12:38:36.308822+03:30	3	Hasan	1	[{"added": {}}]	33	2
159	2025-01-29 12:38:39.348992+03:30	4	Reza	1	[{"added": {}}]	33	2
160	2025-01-29 12:39:03.963373+03:30	1	A1	1	[{"added": {}}]	29	2
161	2025-01-29 12:39:08.621633+03:30	2	A2	1	[{"added": {}}]	29	2
162	2025-01-29 12:39:13.479907+03:30	3	B1	1	[{"added": {}}]	29	2
163	2025-01-29 12:39:17.288122+03:30	4	B2	1	[{"added": {}}]	29	2
164	2025-01-29 12:39:21.398349+03:30	5	C1	1	[{"added": {}}]	29	2
165	2025-01-29 12:39:25.9236+03:30	6	C2	1	[{"added": {}}]	29	2
166	2025-01-29 12:39:28.835766+03:30	1	Cynthia	1	[{"added": {}}]	31	2
167	2025-01-29 12:39:34.217064+03:30	2	Jacqueline	1	[{"added": {}}]	31	2
168	2025-01-29 12:39:39.522363+03:30	3	Lori	1	[{"added": {}}]	31	2
169	2025-01-29 12:39:44.178626+03:30	4	Louis	1	[{"added": {}}]	31	2
170	2025-01-29 12:39:49.129902+03:30	5	Amanda	1	[{"added": {}}]	31	2
171	2025-01-29 12:39:54.560209+03:30	6	Samuel	1	[{"added": {}}]	31	2
172	2025-01-29 12:41:20.759046+03:30	2	Math session with Cynthia at 2025-01-29 09:11:15+00:00	1	[{"added": {}}]	35	2
173	2025-01-29 12:41:35.264868+03:30	3	Math session with Cynthia at 2025-01-29 09:11:20+00:00	1	[{"added": {}}]	35	2
174	2025-01-29 12:41:42.594279+03:30	4	Cooking session with Jacqueline at 2025-01-29 09:11:35+00:00	1	[{"added": {}}]	35	2
175	2025-01-29 12:41:50.119697+03:30	5	Piano session with Louis at 2025-01-29 09:11:42+00:00	1	[{"added": {}}]	35	2
176	2025-01-29 12:41:57.781124+03:30	6	Physics session with Amanda at 2025-01-29 09:11:50+00:00	1	[{"added": {}}]	35	2
177	2025-01-29 12:42:05.366548+03:30	7	Math session with Samuel at 2025-01-29 09:11:57+00:00	1	[{"added": {}}]	35	2
178	2025-01-29 12:42:14.180049+03:30	8	Cooking session with Amanda at 2025-01-29 09:12:05+00:00	1	[{"added": {}}]	35	2
179	2025-01-29 13:14:11.956272+03:30	1	Cooking session with Cynthia at 2025-01-29 09:43:44+00:00	1	[{"added": {}}]	37	2
180	2025-01-29 14:14:10.917395+03:30	1	Cooking session with Cynthia at 2025-01-29 09:43:44+00:00	2	[{"changed": {"fields": ["Session type"]}}]	37	2
181	2025-01-29 20:42:22.985915+03:30	2	Math session with Louis at 2025-01-29 17:12:11+00:00	1	[{"added": {}}]	37	2
182	2025-01-29 20:48:08.266663+03:30	3	Cooking session with Samuel at 2025-01-29 17:12:35+00:00	1	[{"added": {}}]	37	2
183	2025-01-29 20:48:33.852127+03:30	4	Cooking session with Amanda at 2025-01-29 17:18:08+00:00	1	[{"added": {}}]	37	2
184	2025-01-30 00:01:40.102462+03:30	1	Site info	1	[{"added": {}}]	9	2
185	2025-01-30 00:02:33.961543+03:30	1	Site info	2	[{"changed": {"fields": ["Site slogan 1", "Site description 1"]}}]	9	2
186	2025-01-30 00:03:08.940543+03:30	1	site_info	2	[{"changed": {"fields": ["Data title"]}}]	9	2
187	2025-01-30 00:06:01.808431+03:30	1	site_info	2	[{"changed": {"fields": ["Phone 1", "Phone 2", "Email 1", "Email 2", "Address line 1", "Address line 2", "Site description 1", "Site slogan 1"]}}]	9	2
188	2025-01-30 00:07:09.997035+03:30	1	site info	2	[{"changed": {"fields": ["Data title"]}}]	9	2
189	2025-01-30 02:41:32.995062+03:30	21	Physics session with Amanda at 2025-01-29 23:11:08+00:00	1	[{"added": {}}]	37	2
190	2025-01-30 02:41:51.83114+03:30	22	Piano session with Amanda at 2025-01-29 23:11:33+00:00	1	[{"added": {}}]	37	2
191	2025-01-30 19:47:23.921651+03:30	20	Billy	1	[{"added": {}}]	4	2
192	2025-01-30 19:56:12.516885+03:30	16	Billy	1	[{"added": {}}]	7	2
193	2025-01-30 19:56:40.016458+03:30	5	Billy	1	[{"added": {}}]	33	2
194	2025-01-30 19:57:22.236873+03:30	21	Carolyn	1	[{"added": {}}]	4	2
195	2025-01-30 19:57:52.746618+03:30	17	Carolyn	1	[{"added": {}}]	7	2
196	2025-01-30 19:58:00.055036+03:30	6	Carolyn	1	[{"added": {}}]	33	2
197	2025-01-30 19:58:19.793165+03:30	22	Larry	1	[{"added": {}}]	4	2
198	2025-01-30 19:58:50.981949+03:30	18	Larry	1	[{"added": {}}]	7	2
199	2025-01-30 19:58:54.935175+03:30	7	Larry	1	[{"added": {}}]	33	2
200	2025-01-30 19:59:12.8592+03:30	23	Frances	1	[{"added": {}}]	4	2
201	2025-01-30 20:00:22.927208+03:30	19	Frances	1	[{"added": {}}]	7	2
202	2025-01-30 20:00:41.255256+03:30	8	Frances	1	[{"added": {}}]	33	2
203	2025-01-30 20:01:29.23+03:30	24	Durove	1	[{"added": {}}]	4	2
204	2025-01-30 20:02:18.462816+03:30	20	Durove	1	[{"added": {}}]	7	2
205	2025-01-30 20:02:22.072023+03:30	9	Durove	1	[{"added": {}}]	33	2
206	2025-01-30 20:03:06.989592+03:30	24	Durove	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
207	2025-01-30 20:03:35.307211+03:30	21	Carolyn	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
208	2025-01-30 20:03:57.582486+03:30	23	Frances	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
209	2025-01-30 20:04:24.997054+03:30	20	Billy	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
210	2025-01-30 20:04:45.202209+03:30	22	Larry	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	2
211	2025-01-30 20:05:34.368021+03:30	22	Larry	2	[{"changed": {"fields": ["Last name"]}}]	4	2
212	2025-01-30 20:06:00.031489+03:30	15	Reza	2	[{"changed": {"fields": ["Photo"]}}]	7	2
213	2025-01-30 20:06:01.720586+03:30	4	Reza	2	[]	33	2
214	2025-01-30 20:06:49.799336+03:30	3	Hesam	2	[{"changed": {"fields": ["Username", "First name", "Last name"]}}]	4	2
215	2025-01-30 20:06:57.976804+03:30	1	Hesam	2	[]	7	2
216	2025-01-30 20:07:00.031921+03:30	3	Hesam	2	[]	33	2
217	2025-01-30 20:07:18.048952+03:30	3	Hesam	2	[]	33	2
218	2025-01-30 20:07:19.633042+03:30	1	Hesam	2	[{"changed": {"fields": ["Photo"]}}]	7	2
219	2025-01-30 20:08:08.861858+03:30	1	Hesam	2	[{"changed": {"fields": ["Country"]}}]	7	2
220	2025-01-30 20:08:09.901917+03:30	3	Hesam	2	[]	33	2
221	2025-01-30 21:39:06.271004+03:30	18	English Class session with Amanda at 2025-01-06 11:00:00+00:00	3		37	2
222	2025-01-30 21:39:06.274004+03:30	17	English Class session with Amanda at 2025-01-01 11:00:00+00:00	3		37	2
223	2025-01-30 21:39:06.275004+03:30	16	English Class session with Amanda at 2025-01-31 00:55:00+00:00	3		37	2
224	2025-01-30 21:39:06.276004+03:30	15	English Class session with Amanda at 2025-01-31 00:55:00+00:00	3		37	2
225	2025-01-30 21:39:06.277004+03:30	14	English Class session with Amanda at 2025-01-06 11:30:00+00:00	3		37	2
226	2025-01-30 23:00:39.423876+03:30	27	English Class session with Lori at 2025-01-31 00:55:00+00:00	3		37	2
227	2025-01-30 23:00:39.432877+03:30	26	English Class session with Lori at 2025-01-04 11:30:00+00:00	3		37	2
228	2025-01-30 23:00:39.433877+03:30	25	English Class session with Lori at 2025-01-31 00:55:00+00:00	3		37	2
229	2025-01-30 23:00:39.435877+03:30	24	English Class session with Lori at 2025-01-31 00:55:00+00:00	3		37	2
230	2025-01-30 23:00:39.436877+03:30	23	English Class session with Lori at 2025-01-31 00:55:00+00:00	3		37	2
231	2025-01-30 23:09:33.195406+03:30	32	English Class session with Lori at 2025-01-30 19:38:42+00:00	2	[{"changed": {"fields": ["Students"]}}]	37	2
232	2025-01-30 23:11:09.659924+03:30	32	English Class session with Lori at 2025-01-30 19:38:42+00:00	3		37	2
233	2025-01-30 23:11:09.667924+03:30	31	English Class session with Lori at 2025-01-30 19:36:55+00:00	3		37	2
234	2025-01-30 23:11:09.668924+03:30	30	English Class session with Lori at 2025-01-30 19:36:14+00:00	3		37	2
235	2025-01-30 23:11:09.669924+03:30	29	English Class session with Lori at 2025-01-30 19:36:00+00:00	3		37	2
236	2025-01-30 23:11:09.670924+03:30	28	English Class session with Lori at 2025-01-30 19:35:31+00:00	3		37	2
237	2025-01-31 01:14:39.388235+03:30	35	English Class session with Samuel at 2025-01-31 00:55:00+00:00	3		37	2
238	2025-01-31 01:14:39.396235+03:30	34	English Class session with Samuel at 2025-01-30 21:44:02+00:00	3		37	2
239	2025-01-31 01:14:39.398236+03:30	33	English Class session with Samuel at 2025-01-30 19:41:45+00:00	3		37	2
240	2025-02-01 17:11:30.544693+03:30	1	site info	2	[{"changed": {"fields": ["Logo"]}}]	9	2
241	2025-02-01 21:59:09.040165+03:30	1	Cynthia available from 2025-02-01 18:29:01+00:00 to 2025-02-01 20:29:02+00:00	1	[{"added": {}}]	38	2
242	2025-02-02 19:18:11.161987+03:30	53	Piano Class (Test) session with Cynthia at 2025-02-04 08:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
243	2025-02-02 19:18:21.343569+03:30	56	Piano Class (Test) session with Cynthia at 2025-02-06 12:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
244	2025-02-02 19:18:37.213477+03:30	57	Piano Class (Test) session with Cynthia at 2025-02-08 12:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
245	2025-02-02 19:19:30.463523+03:30	57	Piano Class (Test) session with Cynthia at 2025-02-08 12:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
246	2025-02-02 20:46:05.92723+03:30	12	Cynthia available from 2025-02-05 08:00:00+00:00 to 2025-02-05 18:00:00+00:00	2	[{"changed": {"fields": ["Start time", "End time"]}}]	38	2
247	2025-02-02 22:09:49.852683+03:30	12	Cynthia available from 2025-02-07 08:00:00+00:00 to 2025-02-05 18:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc"]}}]	38	2
248	2025-02-02 22:10:25.039695+03:30	12	Cynthia available from 2025-02-07 08:00:00+00:00 to 2025-02-07 18:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["End time utc"]}}]	38	2
249	2025-02-03 00:29:15.80225+03:30	11	Cynthia available from 2025-02-04 00:00:00+00:00 to 2025-02-04 23:59:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc"]}}]	38	2
250	2025-02-03 01:07:55.664349+03:30	8	Cynthia available from 2025-02-08 01:00:00+00:00 to 2025-02-06 07:30:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc"]}}]	38	2
251	2025-02-03 01:40:17.774573+03:30	13	Cynthia available from 2025-02-08 05:09:49+00:00 to 2025-02-08 22:09:50+00:00 in UTC time.	1	[{"added": {}}]	38	2
252	2025-02-03 01:41:04.394239+03:30	13	Cynthia available from 2025-02-08 05:00:00+00:00 to 2025-02-08 22:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc"]}}]	38	2
253	2025-02-03 01:43:46.720524+03:30	14	Cynthia available from 2025-02-07 00:00:00+00:00 to 2025-02-07 07:00:00+00:00 in UTC time.	1	[{"added": {}}]	38	2
254	2025-02-03 01:45:02.296846+03:30	15	Cynthia available from 2025-02-06 02:14:41+00:00 to 2025-02-06 05:14:43+00:00 in UTC time.	1	[{"added": {}}]	38	2
255	2025-02-03 01:46:08.892655+03:30	13	Cynthia available from 2025-02-08 01:30:00+00:00 to 2025-02-08 06:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc"]}}]	38	2
256	2025-02-03 14:28:17.372824+03:30	16	Louis available from 2025-02-03 10:00:00+00:00 to 2025-02-03 15:00:00+00:00 in Iran time.	1	[{"added": {}}]	38	2
257	2025-02-03 14:31:28.154336+03:30	17	Louis available from 2025-02-04 11:01:03+00:00 to 2025-02-04 17:01:05+00:00 in UTC time.	1	[{"added": {}}]	38	2
258	2025-02-03 14:32:02.061275+03:30	17	Louis available from 2025-02-04 11:00:00+00:00 to 2025-02-04 17:01:05+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc"]}}]	38	2
259	2025-02-03 14:33:45.628199+03:30	18	Louis available from 2025-02-10 11:00:01+00:00 to 2025-02-10 14:00:02+00:00 in UTC time.	1	[{"added": {}}]	38	2
260	2025-02-03 14:34:10.189604+03:30	18	Louis available from 2025-02-10 11:00:00+00:00 to 2025-02-10 14:00:02+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc"]}}]	38	2
261	2025-02-03 14:46:20.617382+03:30	19	Louis available from 2025-02-13 18:15:59+00:00 to 2025-02-13 12:16:00+00:00 in UTC time.	1	[{"added": {}}]	38	2
262	2025-02-03 14:47:28.158245+03:30	19	Louis available from 2025-02-13 08:15:59+00:00 to 2025-02-13 12:16:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc"]}}]	38	2
263	2025-02-03 15:44:34.885809+03:30	19	Louis available from 2025-02-13 08:00:00+00:00 to 2025-02-13 12:30:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc"]}}]	38	2
264	2025-02-03 16:12:29.361239+03:30	20	Louis available from 2025-02-08 06:00:00+00:00 to 2025-02-08 07:00:00+00:00 in UTC time.	1	[{"added": {}}]	38	2
265	2025-02-03 16:14:22.934735+03:30	20	Louis available from 2025-02-13 06:00:00+00:00 to 2025-02-13 07:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc"]}}]	38	2
266	2025-02-03 21:33:52.387999+03:30	20	Louis available from 2025-02-13 06:00:00+00:00 to 2025-02-13 07:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Status"]}}]	38	2
267	2025-02-03 21:34:12.930174+03:30	20	Louis available from 2025-02-13 06:00:00+00:00 to 2025-02-13 07:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Is available"]}}]	38	2
268	2025-02-03 23:29:15.354887+03:30	94	Piano Class (Test) session with Louis at 2025-02-03 10:30:00+00:00	3		37	2
269	2025-02-03 23:29:15.362887+03:30	93	Piano Class (Test) session with Louis at 2025-02-03 10:00:00+00:00	3		37	2
270	2025-02-03 23:29:15.363887+03:30	92	Piano Class (Test) session with Louis at 2025-02-04 11:30:00+00:00	3		37	2
271	2025-02-03 23:29:15.366888+03:30	91	Piano Class (Test) session with Louis at 2025-02-04 11:00:00+00:00	3		37	2
272	2025-02-03 23:29:15.369888+03:30	90	Piano Class (Test) session with Louis at 2025-02-04 17:00:00+00:00	3		37	2
273	2025-02-03 23:29:15.371888+03:30	89	Piano Class (Test) session with Louis at 2025-02-04 16:30:00+00:00	3		37	2
274	2025-02-03 23:35:07.069004+03:30	96	Piano Class (Test) session with Louis at 2025-02-03 10:30:00+00:00	3		37	2
275	2025-02-03 23:35:07.077004+03:30	95	Piano Class (Test) session with Louis at 2025-02-03 10:00:00+00:00	3		37	2
276	2025-02-03 23:35:07.079004+03:30	88	Piano Class (Test) session with Louis at 2025-02-04 15:30:00+00:00	3		37	2
277	2025-02-03 23:35:07.081004+03:30	87	Piano Class (Test) session with Louis at 2025-02-04 15:00:00+00:00	3		37	2
278	2025-02-04 01:48:34.328988+03:30	102	Piano Class (Test) session with Louis at 2025-02-04 13:00:00+00:00	3		37	2
279	2025-02-04 01:48:34.336988+03:30	101	Piano Class (Test) session with Louis at 2025-02-04 12:30:00+00:00	3		37	2
280	2025-02-04 01:48:34.337988+03:30	100	Piano Class (Test) session with Louis at 2025-02-03 10:30:00+00:00	3		37	2
281	2025-02-04 01:48:34.338988+03:30	99	Piano Class (Test) session with Louis at 2025-02-03 10:00:00+00:00	3		37	2
282	2025-02-04 01:48:34.341988+03:30	98	Piano Class (Test) session with Louis at 2025-02-04 11:30:00+00:00	3		37	2
283	2025-02-04 01:48:34.343989+03:30	97	Piano Class (Test) session with Louis at 2025-02-04 11:00:00+00:00	3		37	2
284	2025-02-04 01:48:43.522514+03:30	106	Piano Class (Test) session with Louis at 2025-02-04 15:30:00+00:00	3		37	2
285	2025-02-04 01:48:43.530514+03:30	105	Piano Class (Test) session with Louis at 2025-02-04 15:00:00+00:00	3		37	2
286	2025-02-04 01:48:43.531514+03:30	104	Piano Class (Test) session with Louis at 2025-02-04 17:00:00+00:00	3		37	2
287	2025-02-04 01:48:43.533514+03:30	103	Piano Class (Test) session with Louis at 2025-02-04 16:30:00+00:00	3		37	2
288	2025-02-04 01:48:43.533514+03:30	86	Piano Class (Test) session with Louis at 2025-02-13 11:00:00+00:00	3		37	2
289	2025-02-04 01:48:43.534514+03:30	85	Piano Class (Test) session with Louis at 2025-02-13 10:30:00+00:00	3		37	2
290	2025-02-05 02:50:18.441514+03:30	21	Cynthia available from 2025-02-13 02:00:00+00:00 to 2025-02-04 03:00:00+00:00 in UTC time.	1	[{"added": {}}]	38	2
291	2025-02-05 02:51:21.935117+03:30	21	Cynthia available from 2025-02-13 02:00:00+00:00 to 2025-02-14 03:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["End time utc"]}}]	38	2
292	2025-02-05 02:52:29.919005+03:30	22	Cynthia available from 2025-02-20 05:21:49+00:00 to 2025-02-21 03:21:50+00:00 in Iran time.	1	[{"added": {}}]	38	2
293	2025-02-05 11:16:13.086841+03:30	23	Lori available from 2025-02-05 11:00:00+00:00 to 2025-02-05 12:00:00+00:00 in Europe/Berlin time.	1	[{"added": {}}]	38	2
294	2025-02-05 11:20:57.514109+03:30	24	Lori available from 2025-02-06 07:49:37+00:00 to 2025-02-06 10:49:39+00:00 in UTC time.	1	[{"added": {}}]	38	2
295	2025-08-01 10:52:56.212259+04:30	22	Cynthia available from 2025-02-27 05:21:49+00:00 to 2025-02-27 21:21:50+00:00 in Europe/Berlin time.	2	[{"changed": {"fields": ["Start time utc", "End time utc", "Tutor timezone"]}}]	38	2
296	2025-02-08 11:05:37.57019+03:30	25	Cynthia available from 2025-02-17 07:35:23+00:00 to 2025-02-17 17:35:24+00:00 in UTC time.	1	[{"added": {}}]	38	2
297	2025-02-09 00:17:04.847979+03:30	20	Louis available from 2025-02-13 06:00:00+00:00 to 2025-02-13 07:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Status"]}}]	38	2
298	2025-02-09 00:17:37.107824+03:30	78	Cynthia available from 2025-02-08 07:00:00+00:00 to 2025-02-08 08:00:00+00:00 in Asia/Tehran time.	2	[{"changed": {"fields": ["Status", "Is available"]}}]	38	2
299	2025-02-10 22:08:36.446784+03:30	1	Persian	1	[{"added": {}}]	30	2
300	2025-02-10 22:08:41.348064+03:30	2	Chinese	1	[{"added": {}}]	30	2
301	2025-02-10 22:09:05.033419+03:30	5	Amanda	2	[{"changed": {"fields": ["Skills", "Cost trial", "Session count", "Student count", "Course count"]}}]	31	2
302	2025-02-10 22:18:40.257125+03:30	132	Piano Class (Test) session with Amanda at 2025-02-12 14:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
303	2025-02-10 22:19:00.876304+03:30	130	Piano Class (Test) session with Amanda at 2025-02-11 23:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
304	2025-02-10 22:19:19.126348+03:30	129	Piano Class (Test) session with Cynthia at 2025-02-09 22:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
305	2025-02-16 11:46:09.930146+03:30	261	Amanda available from 2025-03-02 00:00:00+00:00 to 2025-03-08 00:00:00+00:00 in UTC time.	2	[{"changed": {"fields": ["Start time utc", "End time utc", "Tutor timezone"]}}]	38	2
306	2025-02-16 11:47:11.788685+03:30	261	Amanda available from 2025-03-02 00:00:00+00:00 to 2025-03-08 23:30:00+00:00 in UTC time.	2	[{"changed": {"fields": ["End time utc"]}}]	38	2
307	2025-02-16 11:47:37.676165+03:30	261	Amanda available from 2025-03-02 00:00:00+00:00 to 2025-03-08 23:59:00+00:00 in UTC time.	2	[{"changed": {"fields": ["End time utc"]}}]	38	2
308	2025-02-16 20:38:53.943904+03:30	1	Amanda Timezone: US/Aleutian, Session Length: 2,  Start day of week: 3.	1	[{"added": {}}]	39	2
309	2025-02-16 20:49:21.663836+03:30	2	Lori Timezone: UTC, Session Length: 2,  Start day of week: 5.	1	[{"added": {}}]	39	2
310	2025-02-16 20:49:48.877877+03:30	3	Lori Timezone: UTC, Session Length: 2,  Start day of week: 0.	1	[{"added": {}}]	39	2
311	2025-02-17 20:18:09.765968+03:30	1	Amanda, Timezone: Pacific/Kosrae, Session Length: 2,  Start day of week: 2.	2	[{"changed": {"fields": ["Provider timezone", "Session length", "Session type"]}}]	39	2
312	2025-02-17 21:40:07.048826+03:30	1	Amanda, Timezone: Pacific/Kosrae, Session Length: 3,  Start day of week: 4.	2	[{"changed": {"fields": ["Session length", "Week start"]}}]	39	2
313	2025-02-17 23:24:10.986757+03:30	7	Cynthia, Timezone: Pacific/Truk, Session Length: 6,  Start day of week: 5.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
314	2025-02-17 23:25:07.479989+03:30	2	Lori, Timezone: UTC, Session Length: 2,  Start day of week: 1.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
315	2025-02-17 23:45:55.48925+03:30	2	Lori, Timezone: UTC, Session Length: 2,  Start day of week: 3.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
316	2025-02-18 00:06:50.970936+03:30	2	Lori, Timezone: UTC, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
317	2025-02-18 00:07:03.759667+03:30	2	Lori, Timezone: UTC, Session Length: 3,  Start day of week: 5.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
318	2025-02-18 00:54:48.670263+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 2.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
319	2025-02-18 12:41:46.660542+03:30	3	Lori	2	[{"changed": {"fields": ["Language levels", "Cost trial", "Cost hourly", "Session count", "Student count", "Course count"]}}]	31	2
320	2025-02-18 12:42:29.841011+03:30	7	Lori	2	[{"changed": {"fields": ["Rating"]}}]	7	2
321	2025-02-18 12:42:52.295296+03:30	7	Lori	2	[{"changed": {"fields": ["Rating"]}}]	7	2
322	2025-02-18 15:11:22.570859+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 3.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
323	2025-02-18 15:12:06.529373+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
324	2025-02-18 15:36:14.681202+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 5.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
325	2025-02-18 17:20:51.088356+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 3.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
326	2025-02-18 17:42:56.012138+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 6.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
327	2025-02-18 23:35:37.985092+03:30	283	Lori available from 2025-02-17 22:30:00+00:00 to 2025-02-18 00:30:00+00:00 in Iran time.	3		38	2
328	2025-02-20 23:16:18.991158+03:30	2	Lori, Timezone: GMT, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Week start"]}}]	39	2
329	2025-02-20 23:19:59.056745+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Provider timezone"]}}]	39	2
330	2025-02-22 16:57:06.135261+03:30	2	Lori, Timezone: Europe/Berlin, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Provider timezone"]}}]	39	2
331	2025-02-22 16:57:43.564402+03:30	2	Lori, Timezone: UTC, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Provider timezone"]}}]	39	2
332	2025-02-22 17:26:15.737332+03:30	2	Lori, Timezone: Iran, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Provider timezone"]}}]	39	2
333	2025-02-22 17:57:24.488219+03:30	2	Lori, Timezone: UTC, Session Length: 3,  Start day of week: 1.	2	[{"changed": {"fields": ["Provider timezone"]}}]	39	2
334	2025-02-22 21:16:48.282571+03:30	2	Lori, Timezone: UTC, Session Length: 4,  Start day of week: 1.	2	[{"changed": {"fields": ["Session length"]}}]	39	2
335	2025-02-24 18:59:15.40994+03:30	2	Lori, Timezone: Iran, Session Length: 4,  Start day of week: 1.	2	[{"changed": {"fields": ["Provider timezone"]}}]	39	2
336	2025-02-24 20:07:14.920855+03:30	157	Piano Class (Test) session with Lori at 2025-02-28 01:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
337	2025-02-25 01:23:43.328889+03:30	1	Review by Durove for Lori	1	[{"added": {}}]	36	2
338	2025-02-25 18:45:53.163386+03:30	1	Review by Durove for Lori	3		36	2
339	2025-02-25 22:28:13.5645+03:30	64	Piano Class (Test) session with Cynthia at 2025-02-15 00:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
340	2025-02-26 13:41:27.848717+03:30	84	Piano Class (Test) session with Louis at 2025-02-11 14:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
341	2025-02-26 13:41:43.992641+03:30	83	Piano Class (Test) session with Louis at 2025-02-11 13:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
405	2025-03-03 00:34:16.44452+03:30	1	site info	2	[{"changed": {"fields": ["Name", "Text 1"]}}]	9	2
342	2025-02-26 14:11:46.705558+03:30	111	Piano Class (Test) session with Louis at 2025-02-04 16:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
343	2025-02-26 14:12:14.297136+03:30	112	Piano Class (Test) session with Louis at 2025-02-04 17:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
344	2025-02-26 14:12:22.378598+03:30	109	Piano Class (Test) session with Louis at 2025-02-04 15:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
345	2025-02-26 14:12:32.137156+03:30	110	Piano Class (Test) session with Louis at 2025-02-04 16:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
346	2025-02-26 14:13:10.656359+03:30	125	Piano Class (Test) session with Cynthia at 2025-02-07 15:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
347	2025-02-26 14:13:18.895831+03:30	126	Piano Class (Test) session with Cynthia at 2025-02-06 03:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
348	2025-02-26 14:13:27.697334+03:30	122	Piano Class (Test) session with Cynthia at 2025-02-07 05:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
349	2025-02-26 14:13:34.770739+03:30	124	Piano Class (Test) session with Cynthia at 2025-02-07 10:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
350	2025-02-26 14:13:48.814542+03:30	123	Piano Class (Test) session with Cynthia at 2025-02-07 08:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
351	2025-02-26 14:13:56.263968+03:30	120	Piano Class (Test) session with Cynthia at 2025-02-07 01:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
352	2025-02-26 14:14:44.525728+03:30	20	English Class session with Louis at 2025-01-06 11:30:00+00:00	2	[{"changed": {"fields": ["Tutor", "Status"]}}]	37	2
353	2025-02-26 14:15:06.159966+03:30	12	English Class session with Louis at 2025-01-06 11:00:00+00:00	2	[{"changed": {"fields": ["Tutor", "Status"]}}]	37	2
354	2025-02-26 14:15:31.890437+03:30	13	English Class session with Samuel at 2025-01-01 11:30:00+00:00	2	[{"changed": {"fields": ["Tutor", "Status"]}}]	37	2
355	2025-02-26 14:15:52.38361+03:30	11	English Class session with Jacqueline at 2025-01-01 11:00:00+00:00	2	[{"changed": {"fields": ["Tutor", "Status"]}}]	37	2
356	2025-02-26 14:16:14.894897+03:30	8	English Class session with Amanda at 2025-01-06 11:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
357	2025-02-26 14:16:22.11631+03:30	10	English Class session with Amanda at 2025-01-06 11:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
358	2025-02-26 14:16:29.469731+03:30	7	English Class session with Amanda at 2025-01-01 11:00:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
359	2025-02-26 14:17:04.700746+03:30	19	English Class session with Cynthia at 2025-01-01 11:30:00+00:00	2	[{"changed": {"fields": ["Tutor", "Status"]}}]	37	2
360	2025-02-26 14:17:14.586311+03:30	9	English Class session with Amanda at 2025-01-01 11:30:00+00:00	2	[{"changed": {"fields": ["Status"]}}]	37	2
361	2025-02-26 15:33:24.961365+03:30	2	Math session with Louis at 2025-01-29 17:12:11+00:00	2	[{"changed": {"fields": ["End session utc", "Status"]}}]	37	2
362	2025-02-26 17:47:55.13039+03:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Rate tutor", "Status"]}}]	36	2
363	2025-02-26 17:54:53.235227+03:30	6	Review by Gholi for Louis	2	[{"changed": {"fields": ["Rate tutor", "Message", "Status"]}}]	36	2
364	2025-02-26 18:33:19.716221+03:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Last modified"]}}]	36	2
365	2025-02-26 18:33:29.261236+03:30	7	Review by Gholi for Cynthia	2	[{"changed": {"fields": ["Status", "Last modified"]}}]	36	2
366	2025-02-26 18:33:43.21926+03:30	6	Review by Gholi for Louis	2	[{"changed": {"fields": ["Last modified"]}}]	36	2
367	2025-02-26 18:33:51.630273+03:30	5	Review by Hesam for Louis	2	[{"changed": {"fields": ["Status", "Last modified"]}}]	36	2
368	2025-02-26 18:34:02.576292+03:30	4	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Status", "Last modified"]}}]	36	2
369	2025-02-26 18:34:11.242307+03:30	3	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Status", "Last modified"]}}]	36	2
370	2025-02-26 18:34:17.482316+03:30	3	Review by Hesam for Cynthia	2	[]	36	2
371	2025-02-26 18:34:29.195335+03:30	2	Review by Durove for Lori	2	[{"changed": {"fields": ["Status", "Last modified"]}}]	36	2
372	2025-02-27 01:36:56.077379+03:30	17	Carolyn	2	[{"changed": {"fields": ["Gender"]}}]	7	2
373	2025-02-27 01:37:11.682272+03:30	11	Joan	2	[{"changed": {"fields": ["Gender"]}}]	7	2
374	2025-02-27 01:37:22.597896+03:30	9	Amanda	2	[{"changed": {"fields": ["Gender"]}}]	7	2
375	2025-02-27 01:37:37.216733+03:30	7	Lori	2	[{"changed": {"fields": ["Gender"]}}]	7	2
376	2025-02-27 01:37:46.556267+03:30	6	Jacqueline	2	[{"changed": {"fields": ["Gender"]}}]	7	2
377	2025-02-27 01:38:00.60707+03:30	3	Cynthia	2	[{"changed": {"fields": ["Gender"]}}]	7	2
378	2025-02-27 01:38:08.162503+03:30	19	Frances	2	[{"changed": {"fields": ["Gender"]}}]	7	2
379	2025-02-27 17:58:17.061358+03:30	3	Math	1	[{"added": {}}]	30	2
380	2025-02-27 17:58:23.762742+03:30	4	Piano	1	[{"added": {}}]	30	2
381	2025-02-27 17:58:35.244398+03:30	5	Physics	1	[{"added": {}}]	30	2
382	2025-02-27 19:38:32.283369+03:30	6	German	1	[{"added": {}}]	30	2
383	2025-02-27 19:38:37.247653+03:30	7	French	1	[{"added": {}}]	30	2
384	2025-02-27 19:38:43.330001+03:30	8	Turkish	1	[{"added": {}}]	30	2
385	2025-02-27 19:39:30.046673+03:30	6	Samuel	2	[{"changed": {"fields": ["Skills"]}}]	31	2
386	2025-02-27 19:40:22.901696+03:30	6	Samuel	2	[{"changed": {"fields": ["Skills", "Cost trial", "Cost hourly", "Session count", "Student count", "Course count"]}}]	31	2
387	2025-02-27 21:27:27.270901+03:30	3	Lori	2	[{"changed": {"fields": ["Skills"]}}]	31	2
388	2025-02-27 21:27:39.14258+03:30	2	Jacqueline	2	[{"changed": {"fields": ["Skills"]}}]	31	2
389	2025-02-27 21:27:56.62358+03:30	4	Louis	2	[{"changed": {"fields": ["Skills", "Language levels", "Session count"]}}]	31	2
390	2025-02-27 21:28:07.904225+03:30	6	Samuel	2	[{"changed": {"fields": ["Language levels"]}}]	31	2
391	2025-02-27 21:28:27.74836+03:30	9	Spanish	1	[{"added": {}}]	30	2
392	2025-02-27 21:28:32.493632+03:30	10	English	1	[{"added": {}}]	30	2
393	2025-02-27 21:28:34.859767+03:30	1	Cynthia	2	[{"changed": {"fields": ["Skills"]}}]	31	2
394	2025-02-27 22:14:18.211678+03:30	6	Samuel	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
395	2025-02-27 22:14:57.958951+03:30	5	Amanda	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
396	2025-02-27 22:15:09.550614+03:30	4	Louis	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
397	2025-02-27 22:15:17.294057+03:30	3	Lori	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
398	2025-02-27 22:15:24.151449+03:30	2	Jacqueline	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
399	2025-02-27 22:15:33.110962+03:30	1	Cynthia	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
400	2025-02-27 22:32:24.013688+03:30	11	Hindi	1	[{"added": {}}]	30	2
401	2025-02-27 22:32:26.859851+03:30	2	Jacqueline	2	[{"changed": {"fields": ["Skills"]}}]	31	2
402	2025-03-02 00:33:58.085152+03:30	4	Louis	2	[{"changed": {"fields": ["Cost trial", "Cost hourly"]}}]	31	2
403	2025-03-02 21:49:16.141413+03:30	4	Louis	2	[{"changed": {"fields": ["Cost hourly"]}}]	31	2
406	2025-03-04 19:43:08.356518+03:30	8	Louis	2	[{"changed": {"fields": ["Lang native"]}}]	7	2
407	2025-03-04 19:46:10.891959+03:30	8	Louis	2	[{"changed": {"fields": ["Lang speak"]}}]	7	2
408	2025-03-04 19:52:48.590706+03:30	4	Louis	2	[{"changed": {"fields": ["Skills", "Skill level", "Cost trial"]}}]	31	2
409	2025-03-04 20:16:22.420572+03:30	8	Louis	2	[{"changed": {"fields": ["Bio"]}}]	7	2
410	2025-03-04 23:11:04.149979+03:30	14	Louis	2	[{"changed": {"fields": ["First name"]}}]	4	2
411	2025-03-04 23:11:18.072776+03:30	8	Louis	2	[{"changed": {"fields": ["Gender", "Title"]}}]	7	2
412	2025-03-04 23:30:06.1783+03:30	4	Louis	2	[{"changed": {"fields": ["Skill level"]}}]	31	2
413	2025-03-05 01:30:17.168697+03:30	4	Louis	2	[{"changed": {"fields": ["Skills", "Skill level"]}}]	31	2
414	2025-03-05 01:37:50.828645+03:30	8	Louis	2	[{"changed": {"fields": ["Lang speak"]}}]	7	2
415	2025-03-05 02:29:07.840986+03:30	4	Louis	2	[{"changed": {"fields": ["Video url", "Cost trial"]}}]	31	2
416	2025-03-05 02:38:09.701983+03:30	8	Louis	2	[{"changed": {"fields": ["Url facebook", "Url insta", "Url twitter", "Url linkedin", "Url youtube"]}}]	7	2
417	2025-03-05 02:41:42.047536+03:30	8	Louis	2	[{"changed": {"fields": ["Url facebook"]}}]	7	2
418	2025-03-05 18:07:47.437426+03:30	9	Amanda	2	[{"changed": {"fields": ["Is vip"]}}]	7	2
419	2025-03-05 18:10:21.040211+03:30	8	Louis	2	[{"changed": {"fields": ["Is vip"]}}]	7	2
420	2025-03-05 18:10:49.483818+03:30	8	Louis	2	[{"changed": {"fields": ["Is vip"]}}]	7	2
421	2025-03-05 18:52:31.231574+03:30	8	Louis	2	[{"changed": {"fields": ["Photo"]}}]	7	2
422	2025-03-07 16:31:16.765678+03:30	8	Arabic	1	[{"added": {}}]	8	2
423	2025-03-07 16:32:05.532467+03:30	24	Durove	2	[{"changed": {"fields": ["Email address"]}}]	4	2
424	2025-03-07 16:32:14.782996+03:30	24	Durove	2	[]	4	2
425	2025-03-07 16:32:16.328084+03:30	20	Durove	2	[{"changed": {"fields": ["Lang speak", "Bio"]}}]	7	2
426	2025-03-07 16:33:11.868261+03:30	25	test	1	[{"added": {}}]	4	2
427	2025-03-07 16:33:31.363376+03:30	25	test	2	[{"changed": {"fields": ["Email address"]}}]	4	2
428	2025-03-07 16:34:27.787603+03:30	21	test	1	[{"added": {}}]	7	2
429	2025-03-11 01:31:06.150369+03:30	1	Billing for Reza - Total: 0.0	1	[{"added": {}}]	42	2
430	2025-03-12 15:10:23.56463+03:30	1	Billing for Reza - Total: 0.00	2	[{"changed": {"fields": ["Bill id"]}}]	42	2
431	2025-03-12 15:11:57.775018+03:30	1	Billing for Reza - Total: 135.00	2	[{"changed": {"fields": ["Sub total", "Tax", "Total"]}}]	42	2
432	2025-03-15 01:41:26.840365+03:30	1	site info	2	[{"changed": {"fields": ["Url", "Email 1", "Email 2"]}}]	9	2
433	2025-03-15 01:45:45.534161+03:30	2	social_facebook	1	[{"added": {}}]	9	2
434	2025-03-15 01:46:10.761604+03:30	3	social_linkedin	1	[{"added": {}}]	9	2
435	2025-03-15 01:46:44.022506+03:30	4	social_x	1	[{"added": {}}]	9	2
436	2025-03-15 01:47:13.155173+03:30	5	social_insta	1	[{"added": {}}]	9	2
437	2025-03-15 21:15:31.55278+03:30	26	Mary	1	[{"added": {}}]	4	2
438	2025-03-15 21:17:48.043587+03:30	22	Mary	1	[{"added": {}}]	7	2
439	2025-03-17 21:47:57.249061+03:30	1	Cynthia	2	[{"changed": {"fields": ["Session count"]}}]	31	2
440	2025-03-17 21:48:28.950874+03:30	1	Cynthia	2	[{"changed": {"fields": ["Student count", "Course count"]}}]	31	2
441	2025-03-18 14:13:34.48188+03:30	29	tammyflores	2	[{"changed": {"fields": ["User type", "Lang native", "Bio"]}}]	7	2
442	2025-03-18 14:13:52.194893+03:30	28	laurarodriguez	2	[{"changed": {"fields": ["Lang native", "Bio"]}}]	7	2
443	2025-03-18 15:44:47.903486+03:30	31	martinsavannah	2	[{"changed": {"fields": ["Photo", "Bio"]}}]	7	2
444	2025-03-18 15:44:53.877828+03:30	30	nunezdavid	2	[{"changed": {"fields": ["Photo", "Bio"]}}]	7	2
445	2025-03-18 22:18:14.180899+03:30	56	jonesmichael	2	[{"changed": {"fields": ["Bio", "Is vip"]}}]	7	2
446	2025-03-20 00:32:23.725215+03:30	5	Ali Tweist contacted us at 2025-03-19 14:02:18.597360+00:00.	2	[{"changed": {"fields": ["Is read"]}}]	45	2
447	2025-03-20 00:32:23.728216+03:30	3	Hasn Gholi contacted us at 2025-03-19 13:03:22.160562+00:00.	2	[{"changed": {"fields": ["Is read"]}}]	45	2
448	2025-03-20 03:10:24.354854+03:30	2	Hossein Rezaei contacted us at 2025-03-19 13:01:34.826911+00:00.	2	[{"changed": {"fields": ["Is read"]}}]	45	2
449	2025-03-20 03:16:17.502053+03:30	7	Mary contacted us at 2025-03-19 23:28:26.583800+00:00.	2	[{"changed": {"fields": ["Is read"]}}]	45	2
450	2025-03-20 14:31:54.064396+03:30	1	Ali Tweist contacted us at 2025-03-19 10:18:26.099209+00:00.	2	[{"changed": {"fields": ["Message"]}}]	45	2
451	2025-03-20 18:40:28.489294+03:30	1	site_name	1	[{"added": {}}]	53	2
452	2025-03-20 18:41:25.748569+03:30	2	site_slogan	1	[{"added": {}}]	53	2
453	2025-03-20 18:42:31.534331+03:30	1	linkedin	1	[{"added": {}}]	54	2
454	2025-03-20 18:42:49.87238+03:30	2	instagram	1	[{"added": {}}]	54	2
455	2025-03-20 18:43:20.131111+03:30	3	dribbble	1	[{"added": {}}]	54	2
456	2025-03-20 18:43:34.690944+03:30	4	facebook	1	[{"added": {}}]	54	2
457	2025-03-20 18:43:52.438959+03:30	5	twitter	1	[{"added": {}}]	54	2
458	2025-03-20 18:44:03.622599+03:30	5	twitter	2	[{"changed": {"fields": ["Value"]}}]	54	2
459	2025-03-20 18:45:03.626031+03:30	1	site_logo	1	[{"added": {}}]	52	2
460	2025-03-20 18:46:42.445683+03:30	3	phone1	1	[{"added": {}}]	53	2
461	2025-03-20 18:47:00.253701+03:30	4	phone2	1	[{"added": {}}]	53	2
462	2025-03-20 19:05:03.445656+03:30	1	phone1	1	[{"added": {}}]	56	2
463	2025-03-20 19:05:11.280104+03:30	3	phone1	3		53	2
464	2025-03-20 19:05:25.939943+03:30	2	phone2	1	[{"added": {}}]	56	2
465	2025-03-20 19:05:30.373197+03:30	4	phone2	3		53	2
466	2025-03-20 19:05:58.57581+03:30	3	site_name	1	[{"added": {}}]	56	2
467	2025-03-20 19:06:09.432431+03:30	1	site_name	3		53	2
468	2025-03-20 19:06:50.490779+03:30	1	email1	1	[{"added": {}}]	57	2
469	2025-03-20 19:07:07.001723+03:30	2	email2	1	[{"added": {}}]	57	2
470	2025-03-20 19:07:38.681535+03:30	5	address_line1	1	[{"added": {}}]	53	2
471	2025-03-20 19:08:02.652906+03:30	6	address_line2	1	[{"added": {}}]	53	2
472	2025-03-20 19:08:47.691483+03:30	7	site_description	1	[{"added": {}}]	53	2
473	2025-03-20 19:10:14.325438+03:30	4	site_prefix	1	[{"added": {}}]	56	2
474	2025-03-20 19:11:08.519537+03:30	2	site_logo_dark	1	[{"added": {}}]	52	2
475	2025-03-20 19:25:16.853636+03:30	1	site_logo_light	2	[{"changed": {"fields": ["Key"]}}]	52	2
476	2025-03-20 19:54:43.411864+03:30	6	site_url	1	[{"added": {}}]	54	2
477	2025-03-20 20:00:06.464341+03:30	2	site_slogan	2	[{"changed": {"fields": ["Value"]}}]	53	2
478	2025-03-20 20:00:16.179897+03:30	2	site_slogan	2	[{"changed": {"fields": ["Value"]}}]	53	2
479	2025-03-20 20:39:13.739144+03:30	1	site_name	1	[{"added": {}}]	60	2
480	2025-03-20 20:39:30.880124+03:30	2	phone1	1	[{"added": {}}]	60	2
481	2025-03-20 20:39:52.080337+03:30	3	phone2	1	[{"added": {}}]	60	2
482	2025-03-20 20:40:52.096769+03:30	1	site_description	1	[{"added": {}}]	68	2
483	2025-03-20 20:41:08.497707+03:30	2	address_line2	1	[{"added": {}}]	68	2
484	2025-03-20 20:41:23.171547+03:30	3	address_line1	1	[{"added": {}}]	68	2
485	2025-03-20 20:41:37.04334+03:30	4	site_slogan	1	[{"added": {}}]	68	2
486	2025-03-20 20:42:06.219009+03:30	1	site_logo_light	1	[{"added": {}}]	66	2
487	2025-03-20 20:42:37.583803+03:30	2	site_logo_dark	1	[{"added": {}}]	66	2
488	2025-03-20 20:43:08.30056+03:30	1	site_url	1	[{"added": {}}]	69	2
489	2025-03-20 20:43:18.62315+03:30	2	twitter	1	[{"added": {}}]	69	2
490	2025-03-20 20:43:27.658667+03:30	3	facebook	1	[{"added": {}}]	69	2
491	2025-03-20 20:43:36.518174+03:30	4	dribbble	1	[{"added": {}}]	69	2
492	2025-03-20 20:43:43.955599+03:30	5	inst	1	[{"added": {}}]	69	2
493	2025-03-20 20:43:50.057948+03:30	5	instagram	2	[{"changed": {"fields": ["Key"]}}]	69	2
494	2025-03-20 20:44:00.873567+03:30	6	linkedin	1	[{"added": {}}]	69	2
495	2025-03-20 21:51:50.742546+03:30	1	site_description	2	[{"changed": {"fields": ["Value"]}}]	68	2
496	2025-03-20 23:33:30.778448+03:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Status"]}}]	36	2
497	2025-03-20 23:37:57.292692+03:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
498	2025-03-20 23:37:57.312693+03:30	7	Review by Gholi for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
499	2025-03-20 23:38:26.197345+03:30	5	Review by Hesam for Louis	2	[{"changed": {"fields": ["Is published"]}}]	36	2
500	2025-03-21 19:12:12.640998+03:30	7	Review by Gholi for Cynthia	2	[{"changed": {"fields": ["Status"]}}]	36	2
501	2025-03-21 19:14:38.935366+03:30	3	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Status"]}}]	36	2
502	2025-03-21 19:16:31.550807+03:30	4	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
503	2025-03-21 19:16:45.920629+03:30	3	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
504	2025-03-21 19:17:11.949118+03:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
505	2025-03-21 19:52:21.512978+03:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
506	2025-03-21 21:13:37.379939+03:30	5	Amanda	2	[{"changed": {"fields": ["Cost hourly"]}}]	31	2
507	2025-03-21 21:13:49.837652+03:30	2	Jacqueline	2	[{"changed": {"fields": ["Cost hourly"]}}]	31	2
508	2025-03-21 21:14:31.359027+03:30	34	alyssa24	2	[{"changed": {"fields": ["Discount"]}}]	31	2
509	2025-03-21 22:21:29.345505+03:30	33	lauren47	2	[{"changed": {"fields": ["Discount"]}}]	31	2
510	2025-03-21 22:21:29.353506+03:30	32	joshuahutchinson	2	[{"changed": {"fields": ["Discount"]}}]	31	2
511	2025-03-21 22:21:29.358506+03:30	31	brodriguez	2	[{"changed": {"fields": ["Discount"]}}]	31	2
512	2025-03-21 22:21:29.363506+03:30	30	martinezjason	2	[{"changed": {"fields": ["Discount"]}}]	31	2
513	2025-03-21 22:21:29.369507+03:30	28	samuel33	2	[{"changed": {"fields": ["Discount"]}}]	31	2
514	2025-03-21 22:21:29.376507+03:30	26	ytaylor	2	[{"changed": {"fields": ["Discount"]}}]	31	2
515	2025-03-21 22:21:29.382507+03:30	25	brownemily	2	[{"changed": {"fields": ["Discount"]}}]	31	2
516	2025-03-21 22:21:29.387508+03:30	24	josephraymond	2	[{"changed": {"fields": ["Discount"]}}]	31	2
517	2025-03-21 22:21:29.392508+03:30	13	april82	2	[{"changed": {"fields": ["Discount"]}}]	31	2
518	2025-03-21 22:21:29.397508+03:30	10	jennifer57	2	[{"changed": {"fields": ["Discount"]}}]	31	2
519	2025-03-21 22:21:29.401508+03:30	9	patrickwhite	2	[{"changed": {"fields": ["Discount"]}}]	31	2
520	2025-03-21 22:21:29.409509+03:30	8	toddcummings	2	[{"changed": {"fields": ["Discount"]}}]	31	2
521	2025-03-21 22:21:29.416509+03:30	7	acostajames	2	[{"changed": {"fields": ["Discount"]}}]	31	2
522	2025-03-21 22:21:29.42251+03:30	6	Samuel	2	[{"changed": {"fields": ["Discount"]}}]	31	2
523	2025-03-21 22:21:29.42851+03:30	5	Amanda	2	[{"changed": {"fields": ["Discount"]}}]	31	2
524	2025-03-21 22:21:29.43251+03:30	4	Louis	2	[{"changed": {"fields": ["Discount"]}}]	31	2
525	2025-03-21 22:21:29.440511+03:30	3	Lori	2	[{"changed": {"fields": ["Discount"]}}]	31	2
526	2025-03-21 22:21:29.446511+03:30	2	Jacqueline	2	[{"changed": {"fields": ["Discount"]}}]	31	2
527	2025-03-21 22:21:29.452511+03:30	1	Cynthia	2	[{"changed": {"fields": ["Discount"]}}]	31	2
528	2025-03-21 22:21:54.230929+03:30	19	christopherlee	2	[{"changed": {"fields": ["Discount"]}}]	31	2
529	2025-03-21 22:21:54.239929+03:30	18	plee	2	[{"changed": {"fields": ["Discount"]}}]	31	2
530	2025-03-21 22:21:54.244929+03:30	15	susan85	2	[{"changed": {"fields": ["Discount"]}}]	31	2
531	2025-03-21 22:21:54.24993+03:30	12	melvinperez	2	[{"changed": {"fields": ["Discount"]}}]	31	2
532	2025-03-21 22:21:54.25493+03:30	11	paceemily	2	[{"changed": {"fields": ["Discount"]}}]	31	2
533	2025-03-21 22:22:47.433972+03:30	31	brodriguez	2	[{"changed": {"fields": ["Cost trial", "Cost hourly"]}}]	31	2
534	2025-03-21 22:23:28.567324+03:30	31	brodriguez	2	[{"changed": {"fields": ["Course count", "Rating"]}}]	31	2
535	2025-03-21 22:25:28.983212+03:30	74	brodriguez	2	[{"changed": {"fields": ["Gender", "Bio"]}}]	7	2
536	2025-03-21 22:31:07.986602+03:30	74	brodriguez	2	[{"changed": {"fields": ["Rating"]}}]	7	2
537	2025-03-21 22:54:09.742638+03:30	34	alyssa24	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
538	2025-03-21 22:54:09.748639+03:30	31	brodriguez	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
539	2025-03-21 22:55:33.713441+03:30	34	alyssa24	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
540	2025-03-21 23:03:00.05397+03:30	34	alyssa24	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
541	2025-03-21 23:08:17.473126+03:30	34	alyssa24	2	[{"changed": {"fields": ["Discount"]}}]	31	2
542	2025-03-21 23:55:12.812154+03:30	34	alyssa24	2	[{"changed": {"fields": ["Discount"]}}]	31	2
543	2025-03-22 03:30:45.072037+04:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Like count", "Dislike count"]}}]	36	2
544	2025-03-22 03:57:33.450031+04:30	34	alyssa24	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
545	2025-03-22 03:57:33.459031+04:30	33	lauren47	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
546	2025-03-22 03:58:10.095127+04:30	6	Samuel	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
547	2025-03-22 03:58:10.103127+04:30	3	Lori	2	[{"changed": {"fields": ["Discount deadline"]}}]	31	2
548	2025-03-22 04:37:41.919787+04:30	1	test_richText	1	[{"added": {}}]	70	2
549	2025-03-22 14:29:58.935609+04:30	9	Review by francisjustin for Amanda	1	[{"added": {}}]	36	2
550	2025-03-22 14:33:27.204522+04:30	9	Review by francisjustin for Amanda	2	[]	36	2
551	2025-03-22 14:33:55.022113+04:30	9	Review by francisjustin for Amanda	2	[{"changed": {"fields": ["Last modified"]}}]	36	2
552	2025-03-22 14:47:23.757166+04:30	10	Review by ryan20 for Amanda	1	[{"added": {}}]	36	2
553	2025-03-22 14:49:27.27223+04:30	10	Review by ryan20 for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
554	2025-03-22 15:00:58.33572+04:30	11	Review by jonesmichael for alyssa24	1	[{"added": {}}]	36	2
555	2025-03-22 19:38:01.245981+04:30	1	Home	1	[{"added": {}}]	71	2
556	2025-03-22 19:38:43.397392+04:30	1	Home	2	[{"changed": {"fields": ["content"]}}]	71	2
557	2025-03-22 19:45:37.170058+04:30	1	Contact Us	2	[{"changed": {"fields": ["Page type", "content"]}}]	71	2
558	2025-03-23 11:49:53.531847+04:30	2	abuot_us	1	[{"added": {}}]	70	2
559	2025-03-23 11:56:06.094618+04:30	2	about_us	2	[{"changed": {"fields": ["Key"]}}]	70	2
560	2025-03-23 23:04:58.03234+04:30	2	about_us	2	[{"changed": {"fields": ["Value"]}}]	70	2
561	2025-03-23 23:05:22.803757+04:30	2	about_us	2	[{"changed": {"fields": ["Value"]}}]	70	2
562	2025-03-24 16:38:58.339117+04:30	1	email1	1	[{"added": {}}]	63	2
563	2025-03-24 16:39:14.432037+04:30	2	email2	1	[{"added": {}}]	63	2
564	2025-03-24 16:39:47.801946+04:30	3	gmail	1	[{"added": {}}]	63	2
565	2025-03-24 16:42:38.130818+04:30	4	phone3	1	[{"added": {}}]	60	2
566	2025-03-24 16:44:25.33295+04:30	5	address3	1	[{"added": {}}]	68	2
567	2025-03-24 16:45:21.470161+04:30	3	phone2	2	[{"changed": {"fields": ["Value"]}}]	60	2
568	2025-03-24 16:46:18.62243+04:30	5	address2	1	[{"added": {}}]	60	2
569	2025-03-24 16:47:48.171552+04:30	2	phone1	2	[{"changed": {"fields": ["Value"]}}]	60	2
570	2025-03-24 16:48:32.7301+04:30	6	address1	1	[{"added": {}}]	60	2
571	2025-03-24 16:48:56.232445+04:30	7	address3	1	[{"added": {}}]	60	2
572	2025-03-24 16:49:14.659499+04:30	5	address3	3		68	2
573	2025-03-24 16:49:35.805708+04:30	3	address_line1	3		68	2
574	2025-03-24 16:49:35.807708+04:30	2	address_line2	3		68	2
575	2025-03-24 16:50:49.643931+04:30	2	email2	2	[{"changed": {"fields": ["Value"]}}]	63	2
576	2025-03-24 16:52:59.568363+04:30	6	about_us_page_title	1	[{"added": {}}]	68	2
577	2025-03-24 16:53:04.993673+04:30	6	about_us_page_title	2	[{"changed": {"fields": ["Value"]}}]	68	2
578	2025-03-24 16:54:51.07074+04:30	6	about_us_page_title	2	[{"changed": {"fields": ["Value"]}}]	68	2
579	2025-03-24 16:55:31.072028+04:30	6	about_us_page_title	2	[{"changed": {"fields": ["Value"]}}]	68	2
580	2025-03-24 16:56:51.135608+04:30	1	site_description	2	[{"changed": {"fields": ["Value"]}}]	68	2
581	2025-03-24 16:57:03.343306+04:30	4	site_slogan	2	[{"changed": {"fields": ["Value"]}}]	68	2
582	2025-03-24 16:59:07.478406+04:30	7	about_us_our_goal	1	[{"added": {}}]	68	2
583	2025-03-24 16:59:48.188734+04:30	7	about_us_our_goal	2	[{"changed": {"fields": ["Value"]}}]	68	2
584	2025-03-24 17:00:29.349089+04:30	7	about_us_our_goal	2	[{"changed": {"fields": ["Value"]}}]	68	2
585	2025-03-24 17:00:57.900722+04:30	7	about_us_our_goal	2	[{"changed": {"fields": ["Value"]}}]	68	2
586	2025-03-24 17:02:47.223975+04:30	8	about_us_about_portal	1	[{"added": {}}]	68	2
587	2025-03-24 17:05:11.929251+04:30	9	about_us_title2	1	[{"added": {}}]	68	2
588	2025-03-24 17:06:31.272789+04:30	10	about_us_content2	1	[{"added": {}}]	68	2
589	2025-03-24 17:06:51.520948+04:30	11	about_us_content3	1	[{"added": {}}]	68	2
590	2025-03-24 17:07:51.780394+04:30	11	about_us_content3	2	[{"changed": {"fields": ["Value"]}}]	68	2
591	2025-03-24 17:08:02.383001+04:30	10	about_us_content2	2	[{"changed": {"fields": ["Value"]}}]	68	2
592	2025-03-24 17:08:29.936577+04:30	10	about_us_content2	2	[{"changed": {"fields": ["Value"]}}]	68	2
593	2025-03-24 17:10:10.114306+04:30	12	about_us_title3	1	[{"added": {}}]	68	2
594	2025-03-24 17:10:29.036389+04:30	9	about_us_title2	2	[{"changed": {"fields": ["Value"]}}]	68	2
595	2025-03-24 17:12:53.904675+04:30	13	about_us_item1	1	[{"added": {}}]	68	2
596	2025-03-24 17:13:01.962136+04:30	14	about_us_item2	1	[{"added": {}}]	68	2
597	2025-03-24 17:13:15.742924+04:30	15	about_us_item3	1	[{"added": {}}]	68	2
598	2025-03-24 17:13:26.737553+04:30	16	about_us_item4	1	[{"added": {}}]	68	2
599	2025-03-24 17:17:00.640787+04:30	17	site_slogan_0	1	[{"added": {}}]	68	2
600	2025-03-24 17:17:57.018012+04:30	18	site_slogan_highlight_word	1	[{"added": {}}]	68	2
601	2025-03-24 17:20:47.121741+04:30	18	site_slogan_highlight_word	2	[{"changed": {"fields": ["Value"]}}]	68	2
602	2025-03-24 17:21:18.843556+04:30	18	site_slogan_highlight_word	2	[{"changed": {"fields": ["Value"]}}]	68	2
603	2025-03-24 17:25:52.71722+04:30	7	pinterest	1	[{"added": {}}]	69	2
604	2025-03-24 17:26:42.474066+04:30	7	pinterest	2	[{"changed": {"fields": ["Value"]}}]	69	2
605	2025-03-24 18:04:52.790034+04:30	12	Review by Hesam for Louis	2	[{"changed": {"fields": ["Is published"]}}]	36	2
606	2025-03-24 18:11:13.350801+04:30	12	Review by Hesam for Louis	2	[{"changed": {"fields": ["Status"]}}]	36	2
607	2025-03-24 18:18:32.287907+04:30	11	Review by jonesmichael for alyssa24	2	[{"changed": {"fields": ["Is published", "Status"]}}]	36	2
608	2025-03-24 18:18:41.486433+04:30	11	Review by jonesmichael for alyssa24	2	[{"changed": {"fields": ["Status"]}}]	36	2
609	2025-03-24 18:18:52.019035+04:30	2	Review by Durove for Lori	2	[{"changed": {"fields": ["Is published"]}}]	36	2
610	2025-03-24 18:19:29.782195+04:30	12	Review by Hesam for Louis	2	[{"changed": {"fields": ["Is published"]}}]	36	2
611	2025-03-24 18:19:29.791196+04:30	11	Review by jonesmichael for alyssa24	2	[{"changed": {"fields": ["Is published"]}}]	36	2
612	2025-03-24 18:19:29.799196+04:30	10	Review by ryan20 for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
613	2025-03-24 18:19:29.809197+04:30	9	Review by francisjustin for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
614	2025-03-24 18:19:29.821197+04:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
615	2025-03-24 18:19:29.829198+04:30	7	Review by Gholi for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
616	2025-03-24 18:19:29.838198+04:30	5	Review by Hesam for Louis	2	[{"changed": {"fields": ["Is published"]}}]	36	2
617	2025-03-24 18:19:29.849199+04:30	4	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
618	2025-03-24 18:19:29.857199+04:30	3	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
619	2025-03-24 18:19:29.8652+04:30	2	Review by Durove for Lori	2	[{"changed": {"fields": ["Is published"]}}]	36	2
620	2025-03-24 18:21:47.225056+04:30	11	Review by jonesmichael for alyssa24	2	[{"changed": {"fields": ["Is published"]}}]	36	2
621	2025-03-24 18:21:47.234057+04:30	9	Review by francisjustin for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
622	2025-03-24 18:21:47.249058+04:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
623	2025-03-24 18:21:47.259058+04:30	7	Review by Gholi for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
624	2025-03-24 18:21:47.268059+04:30	3	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
625	2025-03-24 18:22:11.283432+04:30	9	Review by francisjustin for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
626	2025-03-24 18:22:11.303434+04:30	8	Review by Gholi for Amanda	2	[{"changed": {"fields": ["Is published"]}}]	36	2
627	2025-03-24 18:22:11.319435+04:30	7	Review by Gholi for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
628	2025-03-24 18:22:11.340436+04:30	6	Review by Gholi for Louis	2	[{"changed": {"fields": ["Is published"]}}]	36	2
629	2025-03-24 18:22:11.355437+04:30	5	Review by Hesam for Louis	2	[{"changed": {"fields": ["Is published"]}}]	36	2
630	2025-03-24 19:39:32.869064+04:30	121	Piano Class (Test) session with Cynthia at 2025-02-07 03:00:00+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Status"]}}]	37	2
631	2025-03-24 20:30:25.963691+04:30	13	Review by Hesam for Cynthia	2	[{"changed": {"fields": ["Is published"]}}]	36	2
632	2025-03-24 23:42:35.533856+04:30	160	Spanish Class session with brodriguez at 2025-03-27 19:11:01+00:00 - cost: 10	1	[{"added": {}}]	37	2
633	2025-03-24 23:43:54.769388+04:30	160	Spanish Class session with brodriguez at 2025-03-28 19:11:01+00:00 - cost: 10.00	2	[{"changed": {"fields": ["End session utc"]}}]	37	2
634	2025-03-24 23:44:12.515403+04:30	160	Spanish Class session with brodriguez at 2025-03-28 19:11:01+00:00 - cost: 10.00	2	[]	37	2
635	2025-03-24 23:45:39.343369+04:30	161	Online Dance session with lauren47 at 2025-03-30 19:14:12+00:00 - cost: 0.0	1	[{"added": {}}]	37	2
636	2025-03-24 23:53:01.343433+04:30	161	Online Dance session with lauren47 at 2025-04-02 19:14:12+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Start session utc", "End session utc"]}}]	37	2
637	2025-03-24 23:53:41.11765+04:30	161	Online Dance session with lauren47 at 2025-04-04 19:14:12+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Start session utc", "End session utc"]}}]	37	2
638	2025-03-24 23:54:01.278803+04:30	161	Online Dance session with lauren47 at 2025-04-05 19:14:12+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Start session utc", "End session utc"]}}]	37	2
639	2025-03-25 00:30:58.372541+04:30	161	Online Dance session with lauren47 at 2025-04-02 19:14:12+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Start session utc", "End session utc"]}}]	37	2
640	2025-03-25 00:32:17.583071+04:30	161	Online Dance session with lauren47 at 2025-04-07 19:14:12+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Start session utc", "End session utc"]}}]	37	2
641	2025-03-25 00:34:02.046046+04:30	161	Online Dance session with lauren47 at 2025-04-07 19:14:12+00:00 - cost: 0.00	2	[{"changed": {"fields": ["Status"]}}]	37	2
642	2025-03-25 00:34:45.573536+04:30	160	Spanish Class session with brodriguez at 2025-03-28 19:11:01+00:00 - cost: 10.00	2	[{"changed": {"fields": ["Status"]}}]	37	2
643	2025-03-25 00:39:58.661443+04:30	14	Review by jonesmichael for brodriguez	1	[{"added": {}}]	36	2
644	2025-03-25 00:46:46.970797+04:30	14	Review by jonesmichael for brodriguez	2	[{"changed": {"fields": ["Is published", "Status"]}}]	36	2
645	2025-03-25 00:58:43.093757+04:30	7	pinterest	2	[{"changed": {"fields": ["Value"]}}]	69	2
646	2025-03-25 00:58:51.848258+04:30	6	linkedin	2	[{"changed": {"fields": ["Value"]}}]	69	2
647	2025-03-25 00:59:06.110074+04:30	5	instagram	2	[{"changed": {"fields": ["Value"]}}]	69	2
648	2025-03-25 00:59:18.183764+04:30	4	dribbble	2	[{"changed": {"fields": ["Value"]}}]	69	2
649	2025-03-25 00:59:29.032385+04:30	3	facebook	2	[{"changed": {"fields": ["Value"]}}]	69	2
650	2025-03-25 00:59:40.581045+04:30	2	twitter	2	[{"changed": {"fields": ["Value"]}}]	69	2
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 650, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	app_accounts	userprofile
8	app_accounts	language
9	app_pages	contentfiller
10	app_tutor	languagelevel
11	app_tutor	skill
12	app_tutor	tutor
13	app_student	subject
14	app_student	student
15	app_meeting	schedule
16	app_meeting	review
17	app_meeting	session
18	app_meeting	enrollment
19	app_meeting	period
20	app_temp	subject2
21	app_temp	languagelevel2
22	app_temp	tutor2
23	app_temp	schedule2
24	app_temp	skill2
25	app_temp	student2
26	app_temp	session3
27	app_temp	student3
28	app_temp	tutor3
30	ap2_tutor	skill
31	ap2_tutor	tutor
32	ap2_student	subject
33	ap2_student	student
34	ap2_meeting	period
35	ap2_meeting	schedule
36	ap2_meeting	review
37	ap2_meeting	session
38	ap2_meeting	availability
39	ap2_meeting	appointmentsetting
29	ap2_tutor	skilllevel
40	ap2_tutor	notification
41	ap2_student	notification
42	payments	bill
43	ap2_tutor	pnotification
44	ap2_student	cnotification
45	app_pages	contactus
46	app_admin	adminprofile
47	app_staff	staff
48	app_pages	cfboolean
49	app_pages	cfdatetime
50	app_pages	cfdecimal
51	app_pages	cffile
52	app_pages	cfimage
53	app_pages	cftext
54	app_pages	cfurl
55	app_pages	cfinteger
56	app_pages	cfchar
57	app_pages	cfemail
58	app_pages	cffloat
59	app_content_filler	cfboolean
60	app_content_filler	cfchar
61	app_content_filler	cfdatetime
62	app_content_filler	cfdecimal
63	app_content_filler	cfemail
64	app_content_filler	cffile
65	app_content_filler	cffloat
66	app_content_filler	cfimage
67	app_content_filler	cfinteger
68	app_content_filler	cftext
69	app_content_filler	cfurl
70	app_content_filler	cfrichtext
71	app_pages	page
72	ap2_student	wishlist
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_content_type_id_seq', 72, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-01-25 22:15:06.755106+03:30
2	auth	0001_initial	2025-01-25 22:15:06.833111+03:30
3	admin	0001_initial	2025-01-25 22:15:06.858112+03:30
4	admin	0002_logentry_remove_auto_add	2025-01-25 22:15:06.869113+03:30
5	admin	0003_logentry_add_action_flag_choices	2025-01-25 22:15:06.881114+03:30
6	contenttypes	0002_remove_content_type_name	2025-01-25 22:15:06.907115+03:30
7	auth	0002_alter_permission_name_max_length	2025-01-25 22:15:06.918116+03:30
8	auth	0003_alter_user_email_max_length	2025-01-25 22:15:06.930117+03:30
9	auth	0004_alter_user_username_opts	2025-01-25 22:15:06.941117+03:30
10	auth	0005_alter_user_last_login_null	2025-01-25 22:15:06.953118+03:30
11	auth	0006_require_contenttypes_0002	2025-01-25 22:15:06.955118+03:30
12	auth	0007_alter_validators_add_error_messages	2025-01-25 22:15:06.966119+03:30
13	auth	0008_alter_user_username_max_length	2025-01-25 22:15:06.98412+03:30
14	auth	0009_alter_user_last_name_max_length	2025-01-25 22:15:06.99512+03:30
15	auth	0010_alter_group_name_max_length	2025-01-25 22:15:07.008121+03:30
16	auth	0011_update_proxy_permissions	2025-01-25 22:15:07.018122+03:30
17	auth	0012_alter_user_first_name_max_length	2025-01-25 22:15:07.029122+03:30
18	sessions	0001_initial	2025-01-25 22:15:07.041123+03:30
19	app_accounts	0001_initial	2025-01-25 22:15:24.015094+03:30
20	app_pages	0001_initial	2025-01-25 22:15:24.027094+03:30
21	app_student	0001_initial	2025-01-25 22:15:24.075097+03:30
22	app_tutor	0001_initial	2025-01-25 22:15:24.144101+03:30
23	app_meeting	0001_initial	2025-01-25 22:50:59.952262+03:30
24	app_meeting	0002_auto_20250125_2319	2025-01-25 23:19:23.68471+03:30
25	app_meeting	0003_remove_schedule_tutor	2025-01-25 23:34:57.834141+03:30
26	app_accounts	0002_alter_userprofile_lang_speak	2025-01-26 14:29:14.122106+03:30
27	app_accounts	0003_alter_userprofile_availability	2025-01-26 14:32:16.200515+03:30
28	app_meeting	0002_period	2025-01-27 14:37:52.692652+03:30
29	app_temp	0001_initial	2025-01-29 08:53:08.647112+03:30
30	app_accounts	0002_alter_userprofile_last_modified	2025-01-29 10:25:06.753269+03:30
31	app_temp	0002_auto_20250129_1025	2025-01-29 10:25:07.109289+03:30
32	app_meeting	0002_auto_20250129_1111	2025-01-29 11:11:15.085232+03:30
33	app_tutor	0002_alter_tutor_last_modified	2025-01-29 11:21:46.625847+03:30
34	app_meeting	0002_schedule_tutor	2025-01-29 11:27:38.32156+03:30
35	app_accounts	0003_alter_userprofile_bio	2025-01-29 12:37:56.941636+03:30
36	ap2_tutor	0001_initial	2025-01-29 12:37:57.015641+03:30
37	ap2_student	0001_initial	2025-01-29 12:37:57.067644+03:30
38	ap2_meeting	0001_initial	2025-01-29 12:37:57.159649+03:30
39	ap2_meeting	0002_auto_20250129_1313	2025-01-29 13:13:20.712341+03:30
40	ap2_meeting	0003_auto_20250129_2041	2025-01-29 20:41:57.502457+03:30
41	ap2_meeting	0004_session_status	2025-01-30 19:14:51.199111+03:30
42	ap2_meeting	0005_auto_20250131_1625	2025-01-31 16:25:16.002423+03:30
43	ap2_meeting	0006_auto_20250202_2050	2025-02-02 20:51:05.664374+03:30
44	ap2_meeting	0007_auto_20250202_2100	2025-02-02 21:04:22.272937+03:30
45	ap2_meeting	0008_rename_user_timezone_session_students_timezone	2025-02-02 21:04:22.304939+03:30
46	ap2_meeting	0009_auto_20250202_2114	2025-02-02 21:14:52.661283+03:30
47	ap2_meeting	0010_auto_20250202_2122	2025-02-02 21:23:07.021559+03:30
48	ap2_meeting	0011_alter_availability_tutor_timezone	2025-02-03 14:25:30.011256+03:30
49	ap2_meeting	0012_availability_status	2025-02-03 21:25:43.471034+03:30
50	ap2_meeting	0013_alter_availability_status	2025-02-09 00:16:18.451325+03:30
51	ap2_meeting	0014_auto_20250216_2034	2025-02-16 20:34:39.726304+03:30
52	ap2_meeting	0015_auto_20250216_2038	2025-02-16 20:38:21.77483+03:30
53	ap2_meeting	0016_alter_appointmentsettings_tutor	2025-02-16 20:52:34.40152+03:30
54	ap2_meeting	0017_rename_appointmentsettings_appointmentsetting	2025-02-17 15:40:41.692381+03:30
55	ap2_meeting	0018_alter_appointmentsetting_session_length	2025-02-17 21:38:13.080307+03:30
56	ap2_meeting	0019_alter_appointmentsetting_session_length	2025-02-17 21:39:45.254579+03:30
57	ap2_meeting	0020_alter_appointmentsetting_session_type	2025-02-17 22:35:48.562488+03:30
58	ap2_meeting	0021_session_rating	2025-02-20 19:26:45.499665+03:30
59	ap2_meeting	0022_auto_20250225_0120	2025-02-25 01:20:45.72673+03:30
60	ap2_meeting	0023_alter_review_session	2025-02-25 17:19:52.099432+03:30
61	ap2_meeting	0024_alter_review_session	2025-02-25 17:45:07.820126+03:30
62	ap2_meeting	0025_auto_20250225_1749	2025-02-25 17:49:38.87563+03:30
63	ap2_tutor	0002_tutor_rating	2025-02-25 17:49:38.902631+03:30
64	ap2_meeting	0026_auto_20250225_1845	2025-02-25 18:45:08.267819+03:30
65	ap2_tutor	0003_alter_tutor_rating	2025-02-25 18:45:08.30182+03:30
66	ap2_meeting	0027_auto_20250226_1337	2025-02-26 13:37:52.458398+03:30
67	app_accounts	0004_userprofile_gender	2025-02-27 01:35:56.63498+03:30
68	ap2_tutor	0004_auto_20250227_2149	2025-02-27 21:50:13.487044+03:30
69	ap2_tutor	0005_auto_20250303_2238	2025-03-03 22:39:20.293279+03:30
70	app_accounts	0005_alter_userprofile_availability	2025-03-03 22:39:20.321281+03:30
71	app_accounts	0006_auto_20250305_1805	2025-03-05 18:05:21.17106+03:30
72	ap2_meeting	0028_auto_20250310_2353	2025-03-10 23:54:04.797712+03:30
73	ap2_student	0002_notification	2025-03-10 23:54:04.878717+03:30
74	ap2_tutor	0006_notification	2025-03-10 23:54:04.93472+03:30
75	payments	0001_initial	2025-03-10 23:54:04.994723+03:30
76	payments	0002_auto_20250311_0127	2025-03-11 01:28:07.046124+03:30
77	payments	0003_alter_bill_date	2025-03-11 01:28:32.32657+03:30
78	payments	0004_alter_bill_client	2025-03-11 01:30:10.811203+03:30
79	ap2_student	0003_alter_notification_type	2025-03-11 22:23:07.733883+03:30
80	ap2_tutor	0007_alter_notification_type	2025-03-11 22:23:07.767885+03:30
81	ap2_student	0004_auto_20250311_2236	2025-03-11 22:36:52.223042+03:30
82	ap2_tutor	0008_auto_20250311_2236	2025-03-11 22:36:52.269044+03:30
83	app_accounts	0007_alter_userprofile_phone	2025-03-19 11:40:11.071327+03:30
84	app_admin	0001_initial	2025-03-19 11:40:11.144332+03:30
85	app_pages	0002_contactus	2025-03-19 11:40:11.160332+03:30
86	app_staff	0001_initial	2025-03-19 11:40:11.200335+03:30
87	app_pages	0003_contactus_is_read	2025-03-20 00:14:16.952055+03:30
88	app_pages	0004_cfboolean_cfdatetime_cfdecimal_cffile_cfimage_cftext_cfurl	2025-03-20 18:34:34.603053+03:30
89	app_pages	0005_cfinteger	2025-03-20 18:37:43.938882+03:30
90	app_pages	0006_cfchar_cfemail_cffloat	2025-03-20 19:03:41.455967+03:30
91	app_content_filler	0001_initial	2025-03-20 20:37:34.391461+03:30
92	ap2_meeting	0029_review_is_published	2025-03-20 23:36:13.732768+03:30
93	app_pages	0007_auto_20250321_0036	2025-03-20 23:36:13.772771+03:30
94	ap2_tutor	0009_tutor_discount	2025-03-21 20:55:43.77897+03:30
95	ap2_tutor	0010_auto_20250321_2351	2025-03-21 22:51:46.655316+03:30
96	ap2_meeting	0030_auto_20250322_0329	2025-03-22 03:29:36.741128+04:30
97	app_content_filler	0002_cfrichtext	2025-03-22 04:35:51.390465+04:30
98	app_pages	0008_page	2025-03-22 18:28:20.292397+04:30
99	app_pages	0009_auto_20250322_1900	2025-03-22 19:01:13.265692+04:30
100	app_pages	0010_alter_page_content	2025-03-22 19:44:00.965556+04:30
101	app_pages	0011_contactus_message2	2025-03-22 20:02:11.82795+04:30
102	ap2_tutor	0011_alter_skilllevel_options	2025-03-24 19:29:52.303858+04:30
103	ap2_student	0005_wishlist	2025-03-24 19:29:52.411864+04:30
104	ap2_meeting	0031_auto_20250324_1929	2025-03-24 19:29:52.587874+04:30
105	app_pages	0012_remove_contactus_message2	2025-03-24 19:29:52.609875+04:30
106	ap2_meeting	0032_session_reviews	2025-03-24 19:46:06.897602+04:30
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_migrations_id_seq', 106, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
6owm8yffcx70risrtgg8p78723p7z6gy	.eJxVjEEOwiAQRe_C2hBgCohL956BMMwgVUOT0q6Md7dNutDtf-_9t4hpXWpcO89xJHERRpx-N0z5yW0H9EjtPsk8tWUeUe6KPGiXt4n4dT3cv4Oaet1qgDQM2hsNXCxbz-ghhABYIFFGhY4dseOsbAkelXHKEQIT6jNunvh8AeU5ODk:1tdHKl:0qHUY5LGyOWY5DXQOz9oFSxPv-_eeBMuEwhKV24EJCE	2025-02-13 02:48:59.006573+03:30
658y9xg6hg3l4jip3f5fq8m0csfpka71	.eJxVjDsOwjAQBe_iGlmOP2ubkp4zRLvrFQ4gW8qnQtwdIqWA9s3Me6kRt7WO2yLzOBV1Vl6dfjdCfkjbQblju3XNva3zRHpX9EEXfe1FnpfD_TuouNRvTUiJC0cRshQ9mThEYw0UK8HE5IbkEbhkCCjOWWfBZcsAkUOA5LN6fwDsyjcY:1tnG71:uso2wzMQNtTS88mSculVh950aO_hpAH6TWQ2ERM-F0I	2025-03-12 15:32:03.560728+03:30
zjhc148rc1la9stqmouyyneailmz8n58	.eJxVjDsOwjAQBe_iGlnrX2wo6XMGa-1d4wBypDipEHeHSCmgfTPzXiLitta4dV7iROIinDj9bgnzg9sO6I7tNss8t3WZktwVedAux5n4eT3cv4OKvX5ro2zyBjydMSA79qYExaARwqAsADptjE0hM7hgWecBsqeSUuFCTpF4fwDLtDfy:1tfaPS:5FB9Z9-BycorsbrP-xKJLs-apuRXi5VbzoAlW1aVW5k	2025-02-19 11:35:22.620829+03:30
bdgxtn61qio0oywn5us3u6qoina7ecdp	.eJxVjDsOwjAQBe_iGlnrX2wo6XMGa-1d4wBypDipEHeHSCmgfTPzXiLitta4dV7iROIinDj9bgnzg9sO6I7tNss8t3WZktwVedAux5n4eT3cv4OKvX5ro2zyBjydMSA79qYExaARwqAsADptjE0hM7hgWecBsqeSUuFCTpF4fwDLtDfy:1tfap6:N-PRxdz0RNnJ_gA9E_IRTLkn2BqG7Yi1a847OS_SEYA	2025-02-19 12:01:52.043393+03:30
wouwxy1g37rgz13dm07mku7mskofhtvm	.eJxVjMsOwiAQRf-FtSG8BsSl-34DGWCQqoGktCvjv2uTLnR7zzn3xQJuaw3boCXMmV2YY6ffLWJ6UNtBvmO7dZ56W5c58l3hBx186pme18P9O6g46reWYIxKSWuRUWlb1NlKUcAQFY1QEEwxKkqfHIA2yRMoxOy0JZm9E4K9P9GvN2k:1tcfXv:SyTA-opqFnsM1ZmpLp_BgVKyE8YpGzJ-ORy05m23sj0	2025-02-11 10:28:03.03266+03:30
na7btel12f84eee4ycxmw7lipkuk7ioh	.eJxVjEEOwiAQRe_C2hBgCohL956BMMwgVUOT0q6Md7dNutDtf-_9t4hpXWpcO89xJHERRpx-N0z5yW0H9EjtPsk8tWUeUe6KPGiXt4n4dT3cv4Oaet1qgDQM2hsNXCxbz-ghhABYIFFGhY4dseOsbAkelXHKEQIT6jNunvh8AeU5ODk:1trxzs:Iaa3gZw-AokOxCKnzbs8JN-Z5vF9BCkoYCwB-aM8ZWo	2025-03-25 16:12:08.209414+04:30
ftjdtwfjyrl0s0y1r4yhnkljbclfg1cq	.eJxVjEEOwiAQRe_C2hBgCohL956BMMwgVUOT0q6Md7dNutDtf-_9t4hpXWpcO89xJHERRpx-N0z5yW0H9EjtPsk8tWUeUe6KPGiXt4n4dT3cv4Oaet1qgDQM2hsNXCxbz-ghhABYIFFGhY4dseOsbAkelXHKEQIT6jNunvh8AeU5ODk:1tji4c:UbpGXrwByJGs6dJVOn-k0j53qQ3asqknDYiZU3Am4Cs	2025-03-02 20:34:54.823344+03:30
d7me8nnpwsa86yj3lz2khd8j8xg1sn73	.eJxVjEEOwiAQRe_C2hBgCohL956BMMwgVUOT0q6Md7dNutDtf-_9t4hpXWpcO89xJHERRpx-N0z5yW0H9EjtPsk8tWUeUe6KPGiXt4n4dT3cv4Oaet1qgDQM2hsNXCxbz-ghhABYIFFGhY4dseOsbAkelXHKEQIT6jNunvh8AeU5ODk:1tzL3j:8YrymzcYqwHCN8advnrl-Q69jXgdron-Q4j8W6M15aI	2025-04-15 00:14:35.876812+04:30
\.


--
-- Data for Name: payments_bill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY payments_bill (id, appointment_id, client_id, provider_id, bill_id, date, status, sub_total, tax, total) FROM stdin;
1	1	4	1	257812456	2025-03-11 01:31:06.133368+03:30	unpaid	125.00	10.00	135.00
\.


--
-- Name: payments_bill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('payments_bill_id_seq', 1, true);


--
-- Name: ap2_meeting_appointmentsetting ap2_meeting_appointmentsettings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_appointmentsetting
    ADD CONSTRAINT ap2_meeting_appointmentsettings_pkey PRIMARY KEY (id);


--
-- Name: ap2_meeting_appointmentsetting ap2_meeting_appointmentsettings_tutor_id_9489e9d0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_appointmentsetting
    ADD CONSTRAINT ap2_meeting_appointmentsettings_tutor_id_9489e9d0_uniq UNIQUE (tutor_id);


--
-- Name: ap2_meeting_availability ap2_meeting_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_availability
    ADD CONSTRAINT ap2_meeting_availability_pkey PRIMARY KEY (id);


--
-- Name: ap2_meeting_review ap2_meeting_review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_review
    ADD CONSTRAINT ap2_meeting_review_pkey PRIMARY KEY (id);


--
-- Name: ap2_meeting_review ap2_meeting_review_student_id_session_id_c1b5c723_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_review
    ADD CONSTRAINT ap2_meeting_review_student_id_session_id_c1b5c723_uniq UNIQUE (student_id, session_id);


--
-- Name: ap2_meeting_session ap2_meeting_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session
    ADD CONSTRAINT ap2_meeting_session_pkey PRIMARY KEY (id);


--
-- Name: ap2_meeting_session_reviews ap2_meeting_session_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_reviews
    ADD CONSTRAINT ap2_meeting_session_reviews_pkey PRIMARY KEY (id);


--
-- Name: ap2_meeting_session_reviews ap2_meeting_session_reviews_session_id_review_id_eb9a2769_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_reviews
    ADD CONSTRAINT ap2_meeting_session_reviews_session_id_review_id_eb9a2769_uniq UNIQUE (session_id, review_id);


--
-- Name: ap2_meeting_session_students ap2_meeting_session_stud_session_id_student_id_9373f9b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_students
    ADD CONSTRAINT ap2_meeting_session_stud_session_id_student_id_9373f9b0_uniq UNIQUE (session_id, student_id);


--
-- Name: ap2_meeting_session_students ap2_meeting_session_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_students
    ADD CONSTRAINT ap2_meeting_session_students_pkey PRIMARY KEY (id);


--
-- Name: ap2_student_cnotification ap2_student_cnotification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_cnotification
    ADD CONSTRAINT ap2_student_cnotification_pkey PRIMARY KEY (id);


--
-- Name: ap2_student_student_interests ap2_student_student_inte_student_id_subject_id_31cf2783_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student_interests
    ADD CONSTRAINT ap2_student_student_inte_student_id_subject_id_31cf2783_uniq UNIQUE (student_id, subject_id);


--
-- Name: ap2_student_student_interests ap2_student_student_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student_interests
    ADD CONSTRAINT ap2_student_student_interests_pkey PRIMARY KEY (id);


--
-- Name: ap2_student_student ap2_student_student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student
    ADD CONSTRAINT ap2_student_student_pkey PRIMARY KEY (id);


--
-- Name: ap2_student_student ap2_student_student_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student
    ADD CONSTRAINT ap2_student_student_profile_id_key UNIQUE (profile_id);


--
-- Name: ap2_student_subject ap2_student_subject_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_subject
    ADD CONSTRAINT ap2_student_subject_name_key UNIQUE (name);


--
-- Name: ap2_student_subject ap2_student_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_subject
    ADD CONSTRAINT ap2_student_subject_pkey PRIMARY KEY (id);


--
-- Name: ap2_student_wishlist ap2_student_wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_wishlist
    ADD CONSTRAINT ap2_student_wishlist_pkey PRIMARY KEY (id);


--
-- Name: ap2_student_wishlist ap2_student_wishlist_student_id_tutor_id_421709e6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_wishlist
    ADD CONSTRAINT ap2_student_wishlist_student_id_tutor_id_421709e6_uniq UNIQUE (student_id, tutor_id);


--
-- Name: ap2_tutor_skilllevel ap2_tutor_languagelevel_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_skilllevel
    ADD CONSTRAINT ap2_tutor_languagelevel_name_key UNIQUE (name);


--
-- Name: ap2_tutor_skilllevel ap2_tutor_languagelevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_skilllevel
    ADD CONSTRAINT ap2_tutor_languagelevel_pkey PRIMARY KEY (id);


--
-- Name: ap2_tutor_pnotification ap2_tutor_pnotification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_pnotification
    ADD CONSTRAINT ap2_tutor_pnotification_pkey PRIMARY KEY (id);


--
-- Name: ap2_tutor_skill ap2_tutor_skill_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_skill
    ADD CONSTRAINT ap2_tutor_skill_name_key UNIQUE (name);


--
-- Name: ap2_tutor_skill ap2_tutor_skill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_skill
    ADD CONSTRAINT ap2_tutor_skill_pkey PRIMARY KEY (id);


--
-- Name: ap2_tutor_tutor ap2_tutor_tutor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor
    ADD CONSTRAINT ap2_tutor_tutor_pkey PRIMARY KEY (id);


--
-- Name: ap2_tutor_tutor ap2_tutor_tutor_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor
    ADD CONSTRAINT ap2_tutor_tutor_profile_id_key UNIQUE (profile_id);


--
-- Name: ap2_tutor_tutor_skill_level ap2_tutor_tutor_skill_le_tutor_id_skilllevel_id_f53250cd_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skill_level
    ADD CONSTRAINT ap2_tutor_tutor_skill_le_tutor_id_skilllevel_id_f53250cd_uniq UNIQUE (tutor_id, skilllevel_id);


--
-- Name: ap2_tutor_tutor_skill_level ap2_tutor_tutor_skill_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skill_level
    ADD CONSTRAINT ap2_tutor_tutor_skill_level_pkey PRIMARY KEY (id);


--
-- Name: ap2_tutor_tutor_skills ap2_tutor_tutor_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skills
    ADD CONSTRAINT ap2_tutor_tutor_skills_pkey PRIMARY KEY (id);


--
-- Name: ap2_tutor_tutor_skills ap2_tutor_tutor_skills_tutor_id_skill_id_ed3f1b8c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skills
    ADD CONSTRAINT ap2_tutor_tutor_skills_tutor_id_skill_id_ed3f1b8c_uniq UNIQUE (tutor_id, skill_id);


--
-- Name: app_accounts_language app_accounts_language_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_language
    ADD CONSTRAINT app_accounts_language_name_key UNIQUE (name);


--
-- Name: app_accounts_language app_accounts_language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_language
    ADD CONSTRAINT app_accounts_language_pkey PRIMARY KEY (id);


--
-- Name: app_accounts_userprofile_lang_speak app_accounts_userprofile_lang_speak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile_lang_speak
    ADD CONSTRAINT app_accounts_userprofile_lang_speak_pkey PRIMARY KEY (id);


--
-- Name: app_accounts_userprofile app_accounts_userprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile
    ADD CONSTRAINT app_accounts_userprofile_pkey PRIMARY KEY (id);


--
-- Name: app_accounts_userprofile app_accounts_userprofile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile
    ADD CONSTRAINT app_accounts_userprofile_user_id_key UNIQUE (user_id);


--
-- Name: app_accounts_userprofile_lang_speak app_accounts_userprofile_userprofile_id_language__c8bc863e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile_lang_speak
    ADD CONSTRAINT app_accounts_userprofile_userprofile_id_language__c8bc863e_uniq UNIQUE (userprofile_id, language_id);


--
-- Name: app_admin_adminprofile app_admin_adminprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_admin_adminprofile
    ADD CONSTRAINT app_admin_adminprofile_pkey PRIMARY KEY (profile_id);


--
-- Name: app_content_filler_cfboolean app_content_filler_cfboolean_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfboolean
    ADD CONSTRAINT app_content_filler_cfboolean_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfboolean app_content_filler_cfboolean_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfboolean
    ADD CONSTRAINT app_content_filler_cfboolean_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfchar app_content_filler_cfchar_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfchar
    ADD CONSTRAINT app_content_filler_cfchar_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfchar app_content_filler_cfchar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfchar
    ADD CONSTRAINT app_content_filler_cfchar_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfdatetime app_content_filler_cfdatetime_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfdatetime
    ADD CONSTRAINT app_content_filler_cfdatetime_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfdatetime app_content_filler_cfdatetime_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfdatetime
    ADD CONSTRAINT app_content_filler_cfdatetime_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfdecimal app_content_filler_cfdecimal_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfdecimal
    ADD CONSTRAINT app_content_filler_cfdecimal_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfdecimal app_content_filler_cfdecimal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfdecimal
    ADD CONSTRAINT app_content_filler_cfdecimal_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfemail app_content_filler_cfemail_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfemail
    ADD CONSTRAINT app_content_filler_cfemail_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfemail app_content_filler_cfemail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfemail
    ADD CONSTRAINT app_content_filler_cfemail_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cffile app_content_filler_cffile_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cffile
    ADD CONSTRAINT app_content_filler_cffile_key_key UNIQUE (key);


--
-- Name: app_content_filler_cffile app_content_filler_cffile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cffile
    ADD CONSTRAINT app_content_filler_cffile_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cffloat app_content_filler_cffloat_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cffloat
    ADD CONSTRAINT app_content_filler_cffloat_key_key UNIQUE (key);


--
-- Name: app_content_filler_cffloat app_content_filler_cffloat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cffloat
    ADD CONSTRAINT app_content_filler_cffloat_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfimage app_content_filler_cfimage_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfimage
    ADD CONSTRAINT app_content_filler_cfimage_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfimage app_content_filler_cfimage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfimage
    ADD CONSTRAINT app_content_filler_cfimage_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfinteger app_content_filler_cfinteger_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfinteger
    ADD CONSTRAINT app_content_filler_cfinteger_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfinteger app_content_filler_cfinteger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfinteger
    ADD CONSTRAINT app_content_filler_cfinteger_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfrichtext app_content_filler_cfrichtext_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfrichtext
    ADD CONSTRAINT app_content_filler_cfrichtext_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfrichtext app_content_filler_cfrichtext_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfrichtext
    ADD CONSTRAINT app_content_filler_cfrichtext_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cftext app_content_filler_cftext_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cftext
    ADD CONSTRAINT app_content_filler_cftext_key_key UNIQUE (key);


--
-- Name: app_content_filler_cftext app_content_filler_cftext_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cftext
    ADD CONSTRAINT app_content_filler_cftext_pkey PRIMARY KEY (id);


--
-- Name: app_content_filler_cfurl app_content_filler_cfurl_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfurl
    ADD CONSTRAINT app_content_filler_cfurl_key_key UNIQUE (key);


--
-- Name: app_content_filler_cfurl app_content_filler_cfurl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_content_filler_cfurl
    ADD CONSTRAINT app_content_filler_cfurl_pkey PRIMARY KEY (id);


--
-- Name: app_meeting_enrollment app_meeting_enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_enrollment
    ADD CONSTRAINT app_meeting_enrollment_pkey PRIMARY KEY (id);


--
-- Name: app_meeting_period app_meeting_period_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_period
    ADD CONSTRAINT app_meeting_period_pkey PRIMARY KEY (id);


--
-- Name: app_meeting_review app_meeting_review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_review
    ADD CONSTRAINT app_meeting_review_pkey PRIMARY KEY (id);


--
-- Name: app_meeting_schedule app_meeting_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_schedule
    ADD CONSTRAINT app_meeting_schedule_pkey PRIMARY KEY (id);


--
-- Name: app_meeting_session app_meeting_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_session
    ADD CONSTRAINT app_meeting_session_pkey PRIMARY KEY (id);


--
-- Name: app_pages_contactus app_pages_contactus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_contactus
    ADD CONSTRAINT app_pages_contactus_pkey PRIMARY KEY (id);


--
-- Name: app_pages_contentfiller app_pages_contentfiller_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_contentfiller
    ADD CONSTRAINT app_pages_contentfiller_pkey PRIMARY KEY (id);


--
-- Name: app_pages_page app_pages_page_page_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_page
    ADD CONSTRAINT app_pages_page_page_type_key UNIQUE (page_type);


--
-- Name: app_pages_page app_pages_page_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_pages_page
    ADD CONSTRAINT app_pages_page_pkey PRIMARY KEY (id);


--
-- Name: app_staff_staff app_staff_staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_staff_staff
    ADD CONSTRAINT app_staff_staff_pkey PRIMARY KEY (profile_id);


--
-- Name: app_student_student_interests app_student_student_inte_student_id_subject_id_d3d56e12_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student_interests
    ADD CONSTRAINT app_student_student_inte_student_id_subject_id_d3d56e12_uniq UNIQUE (student_id, subject_id);


--
-- Name: app_student_student_interests app_student_student_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student_interests
    ADD CONSTRAINT app_student_student_interests_pkey PRIMARY KEY (id);


--
-- Name: app_student_student app_student_student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student
    ADD CONSTRAINT app_student_student_pkey PRIMARY KEY (id);


--
-- Name: app_student_student app_student_student_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student
    ADD CONSTRAINT app_student_student_profile_id_key UNIQUE (profile_id);


--
-- Name: app_student_subject app_student_subject_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_subject
    ADD CONSTRAINT app_student_subject_name_key UNIQUE (name);


--
-- Name: app_student_subject app_student_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_subject
    ADD CONSTRAINT app_student_subject_pkey PRIMARY KEY (id);


--
-- Name: app_temp_languagelevel2 app_temp_languagelevel2_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_languagelevel2
    ADD CONSTRAINT app_temp_languagelevel2_name_key UNIQUE (name);


--
-- Name: app_temp_languagelevel2 app_temp_languagelevel2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_languagelevel2
    ADD CONSTRAINT app_temp_languagelevel2_pkey PRIMARY KEY (id);


--
-- Name: app_temp_session3 app_temp_session3_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3
    ADD CONSTRAINT app_temp_session3_pkey PRIMARY KEY (id);


--
-- Name: app_temp_session3_students app_temp_session3_studen_session3_id_student3_id_13bdd2ef_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3_students
    ADD CONSTRAINT app_temp_session3_studen_session3_id_student3_id_13bdd2ef_uniq UNIQUE (session3_id, student3_id);


--
-- Name: app_temp_session3_students app_temp_session3_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3_students
    ADD CONSTRAINT app_temp_session3_students_pkey PRIMARY KEY (id);


--
-- Name: app_temp_skill2 app_temp_skill2_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_skill2
    ADD CONSTRAINT app_temp_skill2_name_key UNIQUE (name);


--
-- Name: app_temp_skill2 app_temp_skill2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_skill2
    ADD CONSTRAINT app_temp_skill2_pkey PRIMARY KEY (id);


--
-- Name: app_temp_student3_interests app_temp_student3_intere_student3_id_subject2_id_5aa48d3a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3_interests
    ADD CONSTRAINT app_temp_student3_intere_student3_id_subject2_id_5aa48d3a_uniq UNIQUE (student3_id, subject2_id);


--
-- Name: app_temp_student3_interests app_temp_student3_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3_interests
    ADD CONSTRAINT app_temp_student3_interests_pkey PRIMARY KEY (id);


--
-- Name: app_temp_student3 app_temp_student3_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3
    ADD CONSTRAINT app_temp_student3_pkey PRIMARY KEY (id);


--
-- Name: app_temp_student3 app_temp_student3_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3
    ADD CONSTRAINT app_temp_student3_profile_id_key UNIQUE (profile_id);


--
-- Name: app_temp_subject2 app_temp_subject2_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_subject2
    ADD CONSTRAINT app_temp_subject2_name_key UNIQUE (name);


--
-- Name: app_temp_subject2 app_temp_subject2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_subject2
    ADD CONSTRAINT app_temp_subject2_pkey PRIMARY KEY (id);


--
-- Name: app_temp_tutor3 app_temp_tutor3_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_tutor3
    ADD CONSTRAINT app_temp_tutor3_pkey PRIMARY KEY (id);


--
-- Name: app_temp_tutor3 app_temp_tutor3_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_tutor3
    ADD CONSTRAINT app_temp_tutor3_profile_id_key UNIQUE (profile_id);


--
-- Name: app_tutor_languagelevel app_tutor_languagelevel_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_languagelevel
    ADD CONSTRAINT app_tutor_languagelevel_name_key UNIQUE (name);


--
-- Name: app_tutor_languagelevel app_tutor_languagelevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_languagelevel
    ADD CONSTRAINT app_tutor_languagelevel_pkey PRIMARY KEY (id);


--
-- Name: app_tutor_skill app_tutor_skill_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_skill
    ADD CONSTRAINT app_tutor_skill_name_key UNIQUE (name);


--
-- Name: app_tutor_skill app_tutor_skill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_skill
    ADD CONSTRAINT app_tutor_skill_pkey PRIMARY KEY (id);


--
-- Name: app_tutor_tutor_language_levels app_tutor_tutor_language_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_language_levels
    ADD CONSTRAINT app_tutor_tutor_language_levels_pkey PRIMARY KEY (id);


--
-- Name: app_tutor_tutor_language_levels app_tutor_tutor_language_tutor_id_languagelevel_i_de2bce38_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_language_levels
    ADD CONSTRAINT app_tutor_tutor_language_tutor_id_languagelevel_i_de2bce38_uniq UNIQUE (tutor_id, languagelevel_id);


--
-- Name: app_tutor_tutor app_tutor_tutor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor
    ADD CONSTRAINT app_tutor_tutor_pkey PRIMARY KEY (id);


--
-- Name: app_tutor_tutor app_tutor_tutor_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor
    ADD CONSTRAINT app_tutor_tutor_profile_id_key UNIQUE (profile_id);


--
-- Name: app_tutor_tutor_skills app_tutor_tutor_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_skills
    ADD CONSTRAINT app_tutor_tutor_skills_pkey PRIMARY KEY (id);


--
-- Name: app_tutor_tutor_skills app_tutor_tutor_skills_tutor_id_skill_id_c8fdec7d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_skills
    ADD CONSTRAINT app_tutor_tutor_skills_tutor_id_skill_id_c8fdec7d_uniq UNIQUE (tutor_id, skill_id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: payments_bill payments_bill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments_bill
    ADD CONSTRAINT payments_bill_pkey PRIMARY KEY (id);


--
-- Name: ap2_meeting_availability_tutor_id_536f53a5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_availability_tutor_id_536f53a5 ON ap2_meeting_availability USING btree (tutor_id);


--
-- Name: ap2_meeting_review_session_id_901619a8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_review_session_id_901619a8 ON ap2_meeting_review USING btree (session_id);


--
-- Name: ap2_meeting_review_student_id_b4086e4e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_review_student_id_b4086e4e ON ap2_meeting_review USING btree (student_id);


--
-- Name: ap2_meeting_review_tutor_id_cfdd4e27; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_review_tutor_id_cfdd4e27 ON ap2_meeting_review USING btree (tutor_id);


--
-- Name: ap2_meeting_session_rescheduled_by_id_56a2826a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_session_rescheduled_by_id_56a2826a ON ap2_meeting_session USING btree (rescheduled_by_id);


--
-- Name: ap2_meeting_session_reviews_review_id_a14efe44; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_session_reviews_review_id_a14efe44 ON ap2_meeting_session_reviews USING btree (review_id);


--
-- Name: ap2_meeting_session_reviews_session_id_5396ede6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_session_reviews_session_id_5396ede6 ON ap2_meeting_session_reviews USING btree (session_id);


--
-- Name: ap2_meeting_session_students_session_id_e86bfe0e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_session_students_session_id_e86bfe0e ON ap2_meeting_session_students USING btree (session_id);


--
-- Name: ap2_meeting_session_students_student_id_afbd929e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_session_students_student_id_afbd929e ON ap2_meeting_session_students USING btree (student_id);


--
-- Name: ap2_meeting_session_tutor_id_eb69ba90; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_meeting_session_tutor_id_eb69ba90 ON ap2_meeting_session USING btree (tutor_id);


--
-- Name: ap2_student_cnotification_appointment_id_604ebe24; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_cnotification_appointment_id_604ebe24 ON ap2_student_cnotification USING btree (appointment_id);


--
-- Name: ap2_student_cnotification_client_id_d43fa20d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_cnotification_client_id_d43fa20d ON ap2_student_cnotification USING btree (client_id);


--
-- Name: ap2_student_student_interests_student_id_732202b9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_student_interests_student_id_732202b9 ON ap2_student_student_interests USING btree (student_id);


--
-- Name: ap2_student_student_interests_subject_id_6b17d328; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_student_interests_subject_id_6b17d328 ON ap2_student_student_interests USING btree (subject_id);


--
-- Name: ap2_student_subject_name_fbfee393_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_subject_name_fbfee393_like ON ap2_student_subject USING btree (name varchar_pattern_ops);


--
-- Name: ap2_student_wishlist_student_id_645d0c3e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_wishlist_student_id_645d0c3e ON ap2_student_wishlist USING btree (student_id);


--
-- Name: ap2_student_wishlist_tutor_id_6ea2a607; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_student_wishlist_tutor_id_6ea2a607 ON ap2_student_wishlist USING btree (tutor_id);


--
-- Name: ap2_tutor_languagelevel_name_e22f991f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_languagelevel_name_e22f991f_like ON ap2_tutor_skilllevel USING btree (name varchar_pattern_ops);


--
-- Name: ap2_tutor_pnotification_appointment_id_e1755209; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_pnotification_appointment_id_e1755209 ON ap2_tutor_pnotification USING btree (appointment_id);


--
-- Name: ap2_tutor_pnotification_provider_id_e03bac78; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_pnotification_provider_id_e03bac78 ON ap2_tutor_pnotification USING btree (provider_id);


--
-- Name: ap2_tutor_skill_name_35deefdf_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_skill_name_35deefdf_like ON ap2_tutor_skill USING btree (name varchar_pattern_ops);


--
-- Name: ap2_tutor_tutor_skill_level_skilllevel_id_618c6025; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_tutor_skill_level_skilllevel_id_618c6025 ON ap2_tutor_tutor_skill_level USING btree (skilllevel_id);


--
-- Name: ap2_tutor_tutor_skill_level_tutor_id_677bb182; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_tutor_skill_level_tutor_id_677bb182 ON ap2_tutor_tutor_skill_level USING btree (tutor_id);


--
-- Name: ap2_tutor_tutor_skills_skill_id_20cbe374; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_tutor_skills_skill_id_20cbe374 ON ap2_tutor_tutor_skills USING btree (skill_id);


--
-- Name: ap2_tutor_tutor_skills_tutor_id_e256b030; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ap2_tutor_tutor_skills_tutor_id_e256b030 ON ap2_tutor_tutor_skills USING btree (tutor_id);


--
-- Name: app_accounts_language_name_0c2f80e3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_accounts_language_name_0c2f80e3_like ON app_accounts_language USING btree (name varchar_pattern_ops);


--
-- Name: app_accounts_userprofile_lang_speak_language_id_0a7df939; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_accounts_userprofile_lang_speak_language_id_0a7df939 ON app_accounts_userprofile_lang_speak USING btree (language_id);


--
-- Name: app_accounts_userprofile_lang_speak_userprofile_id_9897a15d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_accounts_userprofile_lang_speak_userprofile_id_9897a15d ON app_accounts_userprofile_lang_speak USING btree (userprofile_id);


--
-- Name: app_content_filler_cfboolean_key_218debea_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfboolean_key_218debea_like ON app_content_filler_cfboolean USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfchar_key_0bf8096d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfchar_key_0bf8096d_like ON app_content_filler_cfchar USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfdatetime_key_a11a0525_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfdatetime_key_a11a0525_like ON app_content_filler_cfdatetime USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfdecimal_key_6ed18cfc_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfdecimal_key_6ed18cfc_like ON app_content_filler_cfdecimal USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfemail_key_db779f40_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfemail_key_db779f40_like ON app_content_filler_cfemail USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cffile_key_e919892b_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cffile_key_e919892b_like ON app_content_filler_cffile USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cffloat_key_26e4a954_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cffloat_key_26e4a954_like ON app_content_filler_cffloat USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfimage_key_6154116a_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfimage_key_6154116a_like ON app_content_filler_cfimage USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfinteger_key_bf361c61_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfinteger_key_bf361c61_like ON app_content_filler_cfinteger USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfrichtext_key_f7be7938_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfrichtext_key_f7be7938_like ON app_content_filler_cfrichtext USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cftext_key_bc083477_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cftext_key_bc083477_like ON app_content_filler_cftext USING btree (key varchar_pattern_ops);


--
-- Name: app_content_filler_cfurl_key_08fabed1_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_content_filler_cfurl_key_08fabed1_like ON app_content_filler_cfurl USING btree (key varchar_pattern_ops);


--
-- Name: app_meeting_enrollment_session_id_e622aa29; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_enrollment_session_id_e622aa29 ON app_meeting_enrollment USING btree (session_id);


--
-- Name: app_meeting_enrollment_student_id_a01e191e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_enrollment_student_id_a01e191e ON app_meeting_enrollment USING btree (student_id);


--
-- Name: app_meeting_review_student_id_559dd9de; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_review_student_id_559dd9de ON app_meeting_review USING btree (student_id);


--
-- Name: app_meeting_review_tutor_id_a623b4b5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_review_tutor_id_a623b4b5 ON app_meeting_review USING btree (tutor_id);


--
-- Name: app_meeting_schedule_tutor_id_c1e2b00a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_schedule_tutor_id_c1e2b00a ON app_meeting_schedule USING btree (tutor_id);


--
-- Name: app_meeting_session_schedule_id_e9185c79; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_session_schedule_id_e9185c79 ON app_meeting_session USING btree (schedule_id);


--
-- Name: app_meeting_session_tutor_id_e9741192; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_meeting_session_tutor_id_e9741192 ON app_meeting_session USING btree (tutor_id);


--
-- Name: app_pages_page_page_type_68119e8f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_pages_page_page_type_68119e8f_like ON app_pages_page USING btree (page_type varchar_pattern_ops);


--
-- Name: app_student_student_interests_student_id_3fc41ad8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_student_student_interests_student_id_3fc41ad8 ON app_student_student_interests USING btree (student_id);


--
-- Name: app_student_student_interests_subject_id_33ab5680; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_student_student_interests_subject_id_33ab5680 ON app_student_student_interests USING btree (subject_id);


--
-- Name: app_student_subject_name_01cc4a23_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_student_subject_name_01cc4a23_like ON app_student_subject USING btree (name varchar_pattern_ops);


--
-- Name: app_temp_languagelevel2_name_c49e8e99_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_languagelevel2_name_c49e8e99_like ON app_temp_languagelevel2 USING btree (name varchar_pattern_ops);


--
-- Name: app_temp_session3_students_session3_id_085535f9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_session3_students_session3_id_085535f9 ON app_temp_session3_students USING btree (session3_id);


--
-- Name: app_temp_session3_students_student3_id_7d2a8f1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_session3_students_student3_id_7d2a8f1b ON app_temp_session3_students USING btree (student3_id);


--
-- Name: app_temp_session3_tutor_id_4fc6d356; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_session3_tutor_id_4fc6d356 ON app_temp_session3 USING btree (tutor_id);


--
-- Name: app_temp_skill2_name_4ed674ca_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_skill2_name_4ed674ca_like ON app_temp_skill2 USING btree (name varchar_pattern_ops);


--
-- Name: app_temp_student3_interests_student3_id_d80fa819; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_student3_interests_student3_id_d80fa819 ON app_temp_student3_interests USING btree (student3_id);


--
-- Name: app_temp_student3_interests_subject2_id_25564b8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_student3_interests_subject2_id_25564b8b ON app_temp_student3_interests USING btree (subject2_id);


--
-- Name: app_temp_subject2_name_a0b60508_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_temp_subject2_name_a0b60508_like ON app_temp_subject2 USING btree (name varchar_pattern_ops);


--
-- Name: app_tutor_languagelevel_name_8a29f09b_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_tutor_languagelevel_name_8a29f09b_like ON app_tutor_languagelevel USING btree (name varchar_pattern_ops);


--
-- Name: app_tutor_skill_name_80501746_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_tutor_skill_name_80501746_like ON app_tutor_skill USING btree (name varchar_pattern_ops);


--
-- Name: app_tutor_tutor_language_levels_languagelevel_id_2e62024f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_tutor_tutor_language_levels_languagelevel_id_2e62024f ON app_tutor_tutor_language_levels USING btree (languagelevel_id);


--
-- Name: app_tutor_tutor_language_levels_tutor_id_6778a259; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_tutor_tutor_language_levels_tutor_id_6778a259 ON app_tutor_tutor_language_levels USING btree (tutor_id);


--
-- Name: app_tutor_tutor_skills_skill_id_57460ce4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_tutor_tutor_skills_skill_id_57460ce4 ON app_tutor_tutor_skills USING btree (skill_id);


--
-- Name: app_tutor_tutor_skills_tutor_id_e8749dea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_tutor_tutor_skills_tutor_id_e8749dea ON app_tutor_tutor_skills USING btree (tutor_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: payments_bill_appointment_id_071decf1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payments_bill_appointment_id_071decf1 ON payments_bill USING btree (appointment_id);


--
-- Name: payments_bill_client_id_2b30d4be; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payments_bill_client_id_2b30d4be ON payments_bill USING btree (client_id);


--
-- Name: payments_bill_provider_id_4bcbdfbd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payments_bill_provider_id_4bcbdfbd ON payments_bill USING btree (provider_id);


--
-- Name: ap2_meeting_appointmentsetting ap2_meeting_appointm_tutor_id_9489e9d0_fk_ap2_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_appointmentsetting
    ADD CONSTRAINT ap2_meeting_appointm_tutor_id_9489e9d0_fk_ap2_tutor FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_availability ap2_meeting_availabi_tutor_id_536f53a5_fk_ap2_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_availability
    ADD CONSTRAINT ap2_meeting_availabi_tutor_id_536f53a5_fk_ap2_tutor FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_review ap2_meeting_review_session_id_901619a8_fk_ap2_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_review
    ADD CONSTRAINT ap2_meeting_review_session_id_901619a8_fk_ap2_meeti FOREIGN KEY (session_id) REFERENCES ap2_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_review ap2_meeting_review_student_id_b4086e4e_fk_ap2_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_review
    ADD CONSTRAINT ap2_meeting_review_student_id_b4086e4e_fk_ap2_stude FOREIGN KEY (student_id) REFERENCES ap2_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_review ap2_meeting_review_tutor_id_cfdd4e27_fk_ap2_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_review
    ADD CONSTRAINT ap2_meeting_review_tutor_id_cfdd4e27_fk_ap2_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_session_reviews ap2_meeting_session__review_id_a14efe44_fk_ap2_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_reviews
    ADD CONSTRAINT ap2_meeting_session__review_id_a14efe44_fk_ap2_meeti FOREIGN KEY (review_id) REFERENCES ap2_meeting_review(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_session_reviews ap2_meeting_session__session_id_5396ede6_fk_ap2_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_reviews
    ADD CONSTRAINT ap2_meeting_session__session_id_5396ede6_fk_ap2_meeti FOREIGN KEY (session_id) REFERENCES ap2_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_session_students ap2_meeting_session__session_id_e86bfe0e_fk_ap2_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_students
    ADD CONSTRAINT ap2_meeting_session__session_id_e86bfe0e_fk_ap2_meeti FOREIGN KEY (session_id) REFERENCES ap2_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_session_students ap2_meeting_session__student_id_afbd929e_fk_ap2_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session_students
    ADD CONSTRAINT ap2_meeting_session__student_id_afbd929e_fk_ap2_stude FOREIGN KEY (student_id) REFERENCES ap2_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_session ap2_meeting_session_rescheduled_by_id_56a2826a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session
    ADD CONSTRAINT ap2_meeting_session_rescheduled_by_id_56a2826a_fk_auth_user_id FOREIGN KEY (rescheduled_by_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_meeting_session ap2_meeting_session_tutor_id_eb69ba90_fk_ap2_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_meeting_session
    ADD CONSTRAINT ap2_meeting_session_tutor_id_eb69ba90_fk_ap2_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_cnotification ap2_student_cnotific_appointment_id_604ebe24_fk_ap2_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_cnotification
    ADD CONSTRAINT ap2_student_cnotific_appointment_id_604ebe24_fk_ap2_meeti FOREIGN KEY (appointment_id) REFERENCES ap2_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_cnotification ap2_student_cnotific_client_id_d43fa20d_fk_ap2_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_cnotification
    ADD CONSTRAINT ap2_student_cnotific_client_id_d43fa20d_fk_ap2_stude FOREIGN KEY (client_id) REFERENCES ap2_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_student_interests ap2_student_student__student_id_732202b9_fk_ap2_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student_interests
    ADD CONSTRAINT ap2_student_student__student_id_732202b9_fk_ap2_stude FOREIGN KEY (student_id) REFERENCES ap2_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_student_interests ap2_student_student__subject_id_6b17d328_fk_ap2_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student_interests
    ADD CONSTRAINT ap2_student_student__subject_id_6b17d328_fk_ap2_stude FOREIGN KEY (subject_id) REFERENCES ap2_student_subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_student ap2_student_student_profile_id_81c7487e_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_student
    ADD CONSTRAINT ap2_student_student_profile_id_81c7487e_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_wishlist ap2_student_wishlist_student_id_645d0c3e_fk_ap2_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_wishlist
    ADD CONSTRAINT ap2_student_wishlist_student_id_645d0c3e_fk_ap2_stude FOREIGN KEY (student_id) REFERENCES ap2_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_student_wishlist ap2_student_wishlist_tutor_id_6ea2a607_fk_ap2_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_student_wishlist
    ADD CONSTRAINT ap2_student_wishlist_tutor_id_6ea2a607_fk_ap2_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_pnotification ap2_tutor_pnotificat_appointment_id_e1755209_fk_ap2_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_pnotification
    ADD CONSTRAINT ap2_tutor_pnotificat_appointment_id_e1755209_fk_ap2_meeti FOREIGN KEY (appointment_id) REFERENCES ap2_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_pnotification ap2_tutor_pnotificat_provider_id_e03bac78_fk_ap2_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_pnotification
    ADD CONSTRAINT ap2_tutor_pnotificat_provider_id_e03bac78_fk_ap2_tutor FOREIGN KEY (provider_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_tutor ap2_tutor_tutor_profile_id_c5c16ab8_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor
    ADD CONSTRAINT ap2_tutor_tutor_profile_id_c5c16ab8_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_tutor_skill_level ap2_tutor_tutor_skil_skilllevel_id_618c6025_fk_ap2_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skill_level
    ADD CONSTRAINT ap2_tutor_tutor_skil_skilllevel_id_618c6025_fk_ap2_tutor FOREIGN KEY (skilllevel_id) REFERENCES ap2_tutor_skilllevel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_tutor_skill_level ap2_tutor_tutor_skil_tutor_id_677bb182_fk_ap2_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skill_level
    ADD CONSTRAINT ap2_tutor_tutor_skil_tutor_id_677bb182_fk_ap2_tutor FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_tutor_skills ap2_tutor_tutor_skills_skill_id_20cbe374_fk_ap2_tutor_skill_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skills
    ADD CONSTRAINT ap2_tutor_tutor_skills_skill_id_20cbe374_fk_ap2_tutor_skill_id FOREIGN KEY (skill_id) REFERENCES ap2_tutor_skill(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ap2_tutor_tutor_skills ap2_tutor_tutor_skills_tutor_id_e256b030_fk_ap2_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ap2_tutor_tutor_skills
    ADD CONSTRAINT ap2_tutor_tutor_skills_tutor_id_e256b030_fk_ap2_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_accounts_userprofile_lang_speak app_accounts_userpro_language_id_0a7df939_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile_lang_speak
    ADD CONSTRAINT app_accounts_userpro_language_id_0a7df939_fk_app_accou FOREIGN KEY (language_id) REFERENCES app_accounts_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_accounts_userprofile_lang_speak app_accounts_userpro_userprofile_id_9897a15d_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile_lang_speak
    ADD CONSTRAINT app_accounts_userpro_userprofile_id_9897a15d_fk_app_accou FOREIGN KEY (userprofile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_accounts_userprofile app_accounts_userprofile_user_id_14050081_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_accounts_userprofile
    ADD CONSTRAINT app_accounts_userprofile_user_id_14050081_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_admin_adminprofile app_admin_adminprofi_profile_id_c80fd45d_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_admin_adminprofile
    ADD CONSTRAINT app_admin_adminprofi_profile_id_c80fd45d_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_enrollment app_meeting_enrollme_session_id_e622aa29_fk_app_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_enrollment
    ADD CONSTRAINT app_meeting_enrollme_session_id_e622aa29_fk_app_meeti FOREIGN KEY (session_id) REFERENCES app_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_enrollment app_meeting_enrollme_student_id_a01e191e_fk_app_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_enrollment
    ADD CONSTRAINT app_meeting_enrollme_student_id_a01e191e_fk_app_stude FOREIGN KEY (student_id) REFERENCES app_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_review app_meeting_review_student_id_559dd9de_fk_app_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_review
    ADD CONSTRAINT app_meeting_review_student_id_559dd9de_fk_app_stude FOREIGN KEY (student_id) REFERENCES app_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_review app_meeting_review_tutor_id_a623b4b5_fk_app_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_review
    ADD CONSTRAINT app_meeting_review_tutor_id_a623b4b5_fk_app_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES app_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_schedule app_meeting_schedule_tutor_id_c1e2b00a_fk_app_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_schedule
    ADD CONSTRAINT app_meeting_schedule_tutor_id_c1e2b00a_fk_app_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES app_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_session app_meeting_session_schedule_id_e9185c79_fk_app_meeti; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_session
    ADD CONSTRAINT app_meeting_session_schedule_id_e9185c79_fk_app_meeti FOREIGN KEY (schedule_id) REFERENCES app_meeting_schedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_meeting_session app_meeting_session_tutor_id_e9741192_fk_app_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_meeting_session
    ADD CONSTRAINT app_meeting_session_tutor_id_e9741192_fk_app_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES app_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_staff_staff app_staff_staff_profile_id_b8f9b55a_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_staff_staff
    ADD CONSTRAINT app_staff_staff_profile_id_b8f9b55a_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_student_student_interests app_student_student__student_id_3fc41ad8_fk_app_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student_interests
    ADD CONSTRAINT app_student_student__student_id_3fc41ad8_fk_app_stude FOREIGN KEY (student_id) REFERENCES app_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_student_student_interests app_student_student__subject_id_33ab5680_fk_app_stude; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student_interests
    ADD CONSTRAINT app_student_student__subject_id_33ab5680_fk_app_stude FOREIGN KEY (subject_id) REFERENCES app_student_subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_student_student app_student_student_profile_id_81ff6e28_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_student_student
    ADD CONSTRAINT app_student_student_profile_id_81ff6e28_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_session3_students app_temp_session3_st_session3_id_085535f9_fk_app_temp_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3_students
    ADD CONSTRAINT app_temp_session3_st_session3_id_085535f9_fk_app_temp_ FOREIGN KEY (session3_id) REFERENCES app_temp_session3(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_session3_students app_temp_session3_st_student3_id_7d2a8f1b_fk_app_temp_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3_students
    ADD CONSTRAINT app_temp_session3_st_student3_id_7d2a8f1b_fk_app_temp_ FOREIGN KEY (student3_id) REFERENCES app_temp_student3(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_session3 app_temp_session3_tutor_id_4fc6d356_fk_app_temp_tutor3_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_session3
    ADD CONSTRAINT app_temp_session3_tutor_id_4fc6d356_fk_app_temp_tutor3_id FOREIGN KEY (tutor_id) REFERENCES app_temp_tutor3(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_student3_interests app_temp_student3_in_student3_id_d80fa819_fk_app_temp_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3_interests
    ADD CONSTRAINT app_temp_student3_in_student3_id_d80fa819_fk_app_temp_ FOREIGN KEY (student3_id) REFERENCES app_temp_student3(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_student3_interests app_temp_student3_in_subject2_id_25564b8b_fk_app_temp_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3_interests
    ADD CONSTRAINT app_temp_student3_in_subject2_id_25564b8b_fk_app_temp_ FOREIGN KEY (subject2_id) REFERENCES app_temp_subject2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_student3 app_temp_student3_profile_id_b0363cc2_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_student3
    ADD CONSTRAINT app_temp_student3_profile_id_b0363cc2_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_temp_tutor3 app_temp_tutor3_profile_id_3e27edf2_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_temp_tutor3
    ADD CONSTRAINT app_temp_tutor3_profile_id_3e27edf2_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_tutor_tutor_language_levels app_tutor_tutor_lang_languagelevel_id_2e62024f_fk_app_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_language_levels
    ADD CONSTRAINT app_tutor_tutor_lang_languagelevel_id_2e62024f_fk_app_tutor FOREIGN KEY (languagelevel_id) REFERENCES app_tutor_languagelevel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_tutor_tutor_language_levels app_tutor_tutor_lang_tutor_id_6778a259_fk_app_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_language_levels
    ADD CONSTRAINT app_tutor_tutor_lang_tutor_id_6778a259_fk_app_tutor FOREIGN KEY (tutor_id) REFERENCES app_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_tutor_tutor app_tutor_tutor_profile_id_9682da3d_fk_app_accou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor
    ADD CONSTRAINT app_tutor_tutor_profile_id_9682da3d_fk_app_accou FOREIGN KEY (profile_id) REFERENCES app_accounts_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_tutor_tutor_skills app_tutor_tutor_skills_skill_id_57460ce4_fk_app_tutor_skill_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_skills
    ADD CONSTRAINT app_tutor_tutor_skills_skill_id_57460ce4_fk_app_tutor_skill_id FOREIGN KEY (skill_id) REFERENCES app_tutor_skill(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_tutor_tutor_skills app_tutor_tutor_skills_tutor_id_e8749dea_fk_app_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY app_tutor_tutor_skills
    ADD CONSTRAINT app_tutor_tutor_skills_tutor_id_e8749dea_fk_app_tutor_tutor_id FOREIGN KEY (tutor_id) REFERENCES app_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payments_bill payments_bill_appointment_id_071decf1_fk_ap2_meeting_session_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments_bill
    ADD CONSTRAINT payments_bill_appointment_id_071decf1_fk_ap2_meeting_session_id FOREIGN KEY (appointment_id) REFERENCES ap2_meeting_session(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payments_bill payments_bill_client_id_2b30d4be_fk_ap2_student_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments_bill
    ADD CONSTRAINT payments_bill_client_id_2b30d4be_fk_ap2_student_student_id FOREIGN KEY (client_id) REFERENCES ap2_student_student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payments_bill payments_bill_provider_id_4bcbdfbd_fk_ap2_tutor_tutor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments_bill
    ADD CONSTRAINT payments_bill_provider_id_4bcbdfbd_fk_ap2_tutor_tutor_id FOREIGN KEY (provider_id) REFERENCES ap2_tutor_tutor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

