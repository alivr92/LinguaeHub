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

SET search_path = public, pg_catalog;

--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
51	pbkdf2_sha256$260000$6Mel1rUkGgxgvBuMslKEXy$u0P+ThWnTeKPdqmJaVZChHHd/oijWFRyUVMifcnLfEc=	2025-08-15 18:16:03.054036+04:30	f	sara	Sara	Farhadi	socialavr@gmail.com	f	t	2025-08-13 15:38:19+04:30
56	pbkdf2_sha256$260000$8XIKpjS5qVeWKHzLVRovVV$AOPjPsknew+bGrTJwbz1Fk2cQIoLgPCJaTYjzojts4Y=	\N	f	thread1				f	t	2025-08-18 21:34:57.263034+04:30
52	pbkdf2_sha256$260000$Qp2kjEzc6pNFESmOFbQWNV$P9md47lS2tzLKLmaeA//bUIZb5y2OTwSba4BTDdK0JE=	2025-08-15 05:24:13+04:30	f	maryam	Maryam	Taghadosi	alivr92@gmail.com	f	t	2025-08-14 21:04:46+04:30
2	pbkdf2_sha256$260000$l4m38eaBEANoEo534pMN8y$x9ecwk/5o+EFbUoAj+zBtlPENxA3vAeza9g0U1j+KP0=	2025-08-09 22:31:47+04:30	f	Olivia	Olivia	Dikenson	alivr92_temp@gg.cccom	f	t	2025-05-18 15:48:12+04:30
54	pbkdf2_sha256$260000$qybWYU7vn4lasMteCwZ1PJ$qgBXAYJ96lvS4tD8dh8EmWopLTbkTWl/ZKqK6G6Hhks=	2025-08-15 05:29:22.404504+04:30	f	david	David	Bolton	david@dd.cc	f	t	2025-08-14 21:09:40+04:30
53	pbkdf2_sha256$260000$er0xRtpmKaMzMQ2H4s7cM4$mkMP301MNj+gb8xDn02YVaFv5vSLxrqiX+nrYbxRZTk=	2025-08-15 05:30:22+04:30	f	Adele	Adel	Irandoust	lucasvpr.dev@gmail.com	f	t	2025-08-14 21:08:12+04:30
49	pbkdf2_sha256$260000$fwi2diZoNmn4rp8TEuovXB$XxZaD/huyQUkZx5jpvgVHBpHpPjf00FvCIeXJkaJUGM=	2025-08-14 21:47:26+04:30	f	katy	Katy	Perry	valipour.ali@hotmail.com	f	t	2025-08-10 02:17:47+04:30
55	pbkdf2_sha256$260000$UUx1Ua5hrCvGhT689dPfKL$I6RnQwkUAM+LwlBj3+veYeoICjUDsyJFNVntgNv0gtM=	2025-08-15 06:10:21.966183+04:30	f	Tatiana	Tatiana	Lawrenson	tatiana@tt.cccc	f	t	2025-08-14 21:22:36+04:30
1	pbkdf2_sha256$260000$eihVHbuiRHR0kPsM2Eh0x5$t0qiWZ02hqf8epT0XlCCpZLn5BXskYeTK0RDRjjfOag=	2025-08-15 17:31:16.715386+04:30	t	lucas	Lucas	Valipour	alivr92@gmail.com	t	t	2025-05-18 15:43:16+04:30
50	pbkdf2_sha256$260000$IaXfPeHe9kYGuact0pjFOr$sc0J9A5BBc3gQAQ3tnJEUGA0FRqfBt4c19Nb/S2w0TQ=	2025-08-14 17:51:05.617224+04:30	f	britny	Britney	Spears	ali.valipour.dev@gmail.com	f	t	2025-08-10 02:21:50.183655+04:30
45	pbkdf2_sha256$260000$tAGGWgey2efJ7XqnHqwCQN$bzZO6f7b29EzPO/LIoE1pmKCozfbmKwPIXefP5d3r8s=	2025-07-28 03:02:35+04:30	f	tina	Tina	pakravan	tina@gg.ccc	f	t	2025-07-28 03:02:31+04:30
47	pbkdf2_sha256$260000$UFKkMUXmzoZC0LLCeflmua$sjkSGFjxf8+24Isu8GGRDkiZLQi7LkJex6WRP80WxI8=	2025-08-03 16:04:55.219268+04:30	f	mary	Mary	Kury	mm@gg.cc	f	t	2025-08-03 16:04:46.932794+04:30
48	pbkdf2_sha256$260000$TYyx1yNHsGTFrtaoktf9AU$J7sMuXFayKmqQsJk7wP5W0QklVYzFO0t+qvyB/zwa+k=	2025-08-03 16:15:15.201729+04:30	f	richard	Richard	Bolton	rr@gg.cc	f	t	2025-08-03 16:15:10.856481+04:30
46	pbkdf2_sha256$260000$fP0ZGMgQIuTGNvdwUuqowY$pa6J/RGsJjV0jLOwOGA2fUrnROMGpK2mqb+WmX1RFSE=	2025-08-03 15:58:19+04:30	f	reza	Reza	Najaf Gholi	t1@gg.cc	f	t	2025-08-03 15:58:07+04:30
\.


--
-- Data for Name: ap2_meeting_appointmentsetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_appointmentsetting (id, timezone, session_length, week_start, session_type, user_id) FROM stdin;
1	UTC	2	0	private	2
3	UTC	2	0	private	1
\.


--
-- Name: ap2_meeting_appointmentsetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_appointmentsetting_id_seq', 3, true);


--
-- Data for Name: ap2_meeting_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_availability (id, start_time_utc, end_time_utc, status, is_available, user_id) FROM stdin;
1	2025-05-30 12:30:00+04:30	2025-05-30 14:30:32+04:30	free	t	1
\.


--
-- Name: ap2_meeting_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_availability_id_seq', 1, true);


--
-- Data for Name: ap2_meeting_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_session (id, appointment_id, subject, session_type, cost, start_session_utc, end_session_utc, status, rating, video_call_link, is_sent_link, is_sent_reminder_1h, is_sent_reminder_10m, is_rescheduled, rescheduled_at, provider_id, rescheduled_by_id) FROM stdin;
2	7XxjiqLq	Chemistry	private	0.00	2025-07-19 23:11:40+04:30	2025-07-20 01:11:40+04:30	finished	\N	\N	f	f	f	f	\N	2	\N
\.


--
-- Data for Name: ap2_meeting_interviewsessioninfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_interviewsessioninfo (id, interviewer_notes, candidate_experience, session_id) FROM stdin;
\.


--
-- Name: ap2_meeting_interviewsessioninfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_interviewsessioninfo_id_seq', 1, false);


--
-- Data for Name: ap2_meeting_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_review (id, rate_provider, rate_session, like_count, dislike_count, message, status, is_published, create_date, last_modified, client_id, provider_id, session_id) FROM stdin;
\.


--
-- Name: ap2_meeting_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_review_id_seq', 1, false);


--
-- Data for Name: ap2_meeting_session_clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_meeting_session_clients (id, session_id, user_id) FROM stdin;
\.


--
-- Name: ap2_meeting_session_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_session_clients_id_seq', 3, true);


--
-- Name: ap2_meeting_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_meeting_session_id_seq', 3, true);


--
-- Data for Name: app_accounts_userprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userprofile (id, gender, country, photo, user_type, title, lang_native, bio, availability, is_vip, rating, reviews_count, create_date, last_modified, is_active, user_id, terms_agreed, email_consent, email_consent_date, terms_agreed_date, activation_token, token_expiry, password_reset_token, pss_token_expiry, phone_country_code, phone_number, phone_verification_sent_at, phone_verified, email_token_expiry, email_verification_token, is_email_verified, resume, city, meeting_radius, latitude, longitude, meeting_location, meeting_method, inp_aim, inp_start) FROM stdin;
46	male	Sudan	profiles/photos/2025/08/03/m5.jpg	tutor		Korean		t	f	0	0	2025-08-03 16:15:12.535577+04:30	2025-08-11 02:42:14.249447+04:30	f	48	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-08-12 02:18:13.111018+04:30	cuVZBGR9dk0Tbl25Op1wnaqeRsCBjvPXPJcOtGXDKKiYqy2QqUzSWFGhBh72jXq5	t		Unknown	\N	\N	\N	any	online	\N	2025-08-17
43	female	Andorra	profiles/photos/2025/08/11/g1_ydVVfXP.jpg	tutor		German		t	f	4.9000000000000004	0	2025-07-28 03:02:32.841047+04:30	2025-08-11 20:56:15.008702+04:30	f	45	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Unknown	\N	\N	\N	any	online	\N	2025-08-17
44	male	Bahrain	photos/default.png	student		Spanish		t	f	0	0	2025-08-03 15:58:08.347996+04:30	2025-08-03 16:01:56.698057+04:30	f	46	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-08-04 15:58:08+04:30	Ccy0OEt2uLQjbGS20sUHyu1Q1fVMO7Yd66y9oGYhlXKzO3rOtKt6ljP1weuFJmgD	t		Unknown	\N	\N	\N	any	online	\N	2025-08-17
1	male	Iran	photos/default.png	admin		French		f	t	0	0	2025-05-18 15:44:03.315973+04:30	2025-07-28 21:03:07.726892+04:30	t	1	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Unknown	\N	\N	\N	any	online	\N	2025-08-17
2	female	Algeria	profiles/photos/2025/08/09/cropped-image_gDhvh63.jpg	tutor	University Lecturer	Dutch	Hello, this is a good dog. gorbeh25	t	f	3.8999999999999999	400	2025-05-18 15:48:13.254881+04:30	2025-08-10 01:34:27.066514+04:30	f	2	t	t	2025-08-09 19:52:47.305162+04:30	2025-08-09 19:52:47.305162+04:30	\N	\N	\N	\N	+376	125412365	\N	f	\N	\N	t		Unknown	\N	\N	\N	any	online	\N	2025-08-17
45	female	New Zealand	profiles/photos/2025/08/03/7f379ac3d9306a8eeb14bcd522fa4c48.jpg	tutor		French		t	f	3.2000000000000002	59	2025-08-03 16:04:48.337875+04:30	2025-08-03 16:06:47.602696+04:30	f	47	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-08-04 16:04:48+04:30	cakisCXicFryWRa8Ye0VuxiKAOtJmS4vUFEzJ6hsvNXKiEZxqmxln15F53Pr9oKL	t		Unknown	\N	\N	\N	any	online	\N	2025-08-17
50	male	France	profiles/photos/2025/08/14/g05.jpg	student		Norwegian		t	f	0	0	2025-08-14 21:04:47.094528+04:30	2025-08-15 05:24:48.246824+04:30	t	52	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	2025-08-15 21:04:47+04:30	itUVI7ca8WdIlUVH6JT7FOQFR0zn5mdq3J6766GowgcP75fL2fGQPmLKiCx793ou	t		Paris	100	48.831273	2.346767	any	in_person	\N	2025-08-17
51	female	France	profiles/photos/2025/08/14/g2.jpg	student		German		t	f	0	0	2025-08-14 21:09:08.167461+04:30	2025-08-15 06:07:56.530865+04:30	t	53	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Arcueil	97	48.806854	2.330791	my_location	in_person	\N	2025-08-17
52	male	Germany	profiles/photos/2025/08/14/man2.jpg	student		Spanish		t	f	0	0	2025-08-14 21:10:35.845476+04:30	2025-08-14 21:45:28.673187+04:30	t	54	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Vogtei	98	51.160087	10.372295	formal_institution	hybrid	\N	2025-08-17
47	male	France	profiles/photos/2025/08/14/aiGirl.jpg	student		Korean		t	f	0	0	2025-08-10 02:17:48.675972+04:30	2025-08-15 04:12:53.199232+04:30	t	49	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Courbevoie	96	48.899526	2.239151	any	in_person	\N	2025-08-17
53	male	France	profiles/photos/2025/08/14/language_schools_virtual-classroom_header.jpg	tutor		German	Hello students, \r\nThis is Tatiana, your German tutor. I hope to see you soon in face to face sessions.	t	f	0	0	2025-08-14 21:24:40.166768+04:30	2025-08-18 01:22:28.870488+04:30	f	55	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Paris	7	48.856005	2.295966	my_location	hybrid	\N	2026-08-14
49	female	France	profiles/photos/2025/08/14/woman1.jpg	student		German	this is my bio. so Im sara.	t	f	0	0	2025-08-13 15:38:20.799535+04:30	2025-08-18 01:57:48.851744+04:30	t	51	t	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	t		Paris	12	48.845448	2.326185	public	in_person	formal_tests	2026-10-21
48	female	France	profiles/photos/2025/08/11/cropped-image.jpg	tutor	Singer	Finnish	don't worry. it 's okay 1200 + cat + dog 123	t	f	4.2000000000000002	0	2025-08-10 02:21:51.15471+04:30	2025-08-18 02:13:34.007803+04:30	t	50	t	f	\N	2025-08-10 03:16:31+04:30	\N	\N	\N	\N	+229	12345678	\N	f	\N	\N	t		Paris	43	48.852415	2.348843	public	in_person	\N	\N
\.


--
-- Data for Name: ap2_student_student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_student (id, major, session_count, tutor_count, profile_id) FROM stdin;
20	\N	0	0	44
21	\N	0	0	47
23	\N	0	0	50
24	\N	0	0	52
25	\N	0	0	51
22	\N	0	0	49
\.


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
-- Name: ap2_student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_student_id_seq', 25, true);


--
-- Data for Name: ap2_student_subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_student_subject (id, name) FROM stdin;
\.


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
-- Name: ap2_student_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_student_subject_id_seq', 1, false);


--
-- Data for Name: ap2_tutor_tutor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_tutor (id, video_url, video_intro, cost_trial, cost_hourly, session_count, student_count, course_count, create_date, last_modified, discount_deadline, discount, profile_id, years_experience, reviewer_comment, status) FROM stdin;
8	\N		0.00	0.00	790	150	0	2025-08-03 16:04:48.366876+04:30	2025-08-11 04:47:24.890031+04:30	\N	0	45	\N		accepted
1	\N	videos/2025/06/13/city_night2.mp4	0.00	0.00	269	189	0	2025-05-18 15:48:13.258882+04:30	2025-08-11 12:06:48.664383+04:30	\N	0	2	0		decision
11	\N		0.00	25.63	0	0	0	2025-08-14 21:26:09.625885+04:30	2025-08-17 01:24:02.462347+04:30	\N	0	53	\N		pending
7			0.00	0.00	0	0	0	2025-07-28 03:02:32.849047+04:30	2025-08-04 18:17:48.032265+04:30	\N	0	43	\N		accepted
10	\N		13.90	47.00	0	0	0	2025-08-10 02:21:51.164711+04:30	2025-08-20 05:34:37.481844+04:30	\N	0	48	0		accepted
9	\N		0.00	0.00	208	118	0	2025-08-03 16:15:12.541577+04:30	2025-08-11 04:46:43.61767+04:30	\N	0	46	\N		accepted
\.


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
-- Data for Name: ap2_tutor_pnotification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_pnotification (id, type, seen, date, appointment_id, provider_id) FROM stdin;
\.


--
-- Name: ap2_tutor_pnotification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_pnotification_id_seq', 1, false);


--
-- Data for Name: ap2_tutor_providerapplication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_providerapplication (id, photo, resume, first_name, last_name, email, phone, lang_native, bio, reviewer_comment, video_url, timezone, location_ip, date_submitted, status, invitation_token, token_expiry, user_id) FROM stdin;
\.


--
-- Name: ap2_tutor_providerapplication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_providerapplication_id_seq', 2, true);


--
-- Data for Name: app_accounts_skillcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_skillcategory (id, name) FROM stdin;
1	language
2	science
3	instrument
\.


--
-- Data for Name: app_accounts_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_skill (id, name, category_id) FROM stdin;
1	Spanish	1
2	English	1
3	French	1
4	German	1
5	Chinese	1
6	Italian	1
7	Turkish	1
8	Swedish	1
9	Korean	1
10	Hindi	1
11	Russian	1
12	Japanese	1
13	Persian	1
14	Ukrainian	1
15	Arabic	1
16	mathematics	2
17	physics	2
18	chemistry	2
\.


--
-- Data for Name: ap2_tutor_providerapplication_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_providerapplication_skills (id, providerapplication_id, skill_id) FROM stdin;
\.


--
-- Name: ap2_tutor_providerapplication_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_providerapplication_skills_id_seq', 6, true);


--
-- Data for Name: ap2_tutor_teachingcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_teachingcategory (id, name) FROM stdin;
1	Free Discussion
2	Business English
3	English For Kids
\.


--
-- Name: ap2_tutor_teachingcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_teachingcategory_id_seq', 3, true);


--
-- Data for Name: ap2_tutor_teachingcertificate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_teachingcertificate (id, name, issuing_organization, is_certified, created_at, updated_at, user_id, completion_date, document, verified_at, verified_by_id) FROM stdin;
5	other	California PP State University	f	2025-06-25 22:46:58.476266+04:30	2025-08-10 00:09:21.868938+04:30	2	2012	applicants/certificates/2025/08/06/570_org.jpg	2025-08-10 00:09:21.867938+04:30	1
7	ielts	Illinois USA	f	2025-06-26 14:01:53.120407+04:30	2025-08-10 00:09:21.869938+04:30	2	2008	applicants/certificates/2025/08/06/ejraeieh.pdf	2025-08-10 00:09:21.869938+04:30	1
\.


--
-- Name: ap2_tutor_teachingcertificate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_teachingcertificate_id_seq', 8, true);


--
-- Data for Name: ap2_tutor_teachingsubcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_teachingsubcategory (id, name, category_id) FROM stdin;
\.


--
-- Name: ap2_tutor_teachingsubcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_teachingsubcategory_id_seq', 1, false);


--
-- Name: ap2_tutor_tutor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_tutor_id_seq', 11, true);


--
-- Data for Name: ap2_tutor_tutor_teaching_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap2_tutor_tutor_teaching_tags (id, tutor_id, teachingcategory_id) FROM stdin;
2	1	2
5	1	3
6	10	1
7	10	2
8	10	3
\.


--
-- Name: ap2_tutor_tutor_teaching_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ap2_tutor_tutor_teaching_tags_id_seq', 8, true);


--
-- Data for Name: app_accounts_degreelevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_degreelevel (id, name, "order") FROM stdin;
1	high_school	0
3	associate	1
4	bachelor	2
5	master	3
2	phd	4
6	professional	5
7	other	6
\.


--
-- Name: app_accounts_degreelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_degreelevel_id_seq', 7, true);


--
-- Data for Name: app_accounts_language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_language (id, name) FROM stdin;
1	English
2	Spanish
3	French
4	German
5	Italian
6	Portuguese
7	Russian
8	Chinese
9	Japanese
10	Korean
11	Arabic
12	Hungarian
13	Czech
14	Romanian
\.


--
-- Name: app_accounts_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_language_id_seq', 14, true);


--
-- Data for Name: app_accounts_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_level (id, name) FROM stdin;
1	a1
2	a2
3	b1
4	b2
5	c1
6	c2
7	native
\.


--
-- Name: app_accounts_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_level_id_seq', 7, true);


--
-- Data for Name: app_accounts_loginiplog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_loginiplog (id, ip_address, user_agent, login_time, location_city, location_country, is_new_ip, is_flagged, user_id) FROM stdin;
3	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0	2025-07-10 03:26:04.327109+04:30	\N	\N	t	t	1
5	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-17 02:45:12.225476+04:30	\N	\N	f	f	1
17	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-20 14:30:54.97896+04:30	\N	\N	t	t	2
18	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-24 01:13:18.373247+04:30	\N	\N	f	f	2
19	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-28 19:00:40.65905+04:30	\N	\N	f	f	2
20	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-28 21:01:16.267517+04:30	\N	\N	f	f	2
21	192.168.1.6	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-29 22:24:21.020021+04:30	\N	\N	t	t	2
22	192.168.1.5	Mozilla/5.0 (Linux; Android 10; MAR-LX1M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.117 Mobile Safari/537.36	2025-07-29 22:25:20.421419+04:30	\N	\N	t	t	2
23	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-29 22:29:26.169878+04:30	\N	\N	f	f	2
24	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-30 12:00:53.996977+04:30	\N	\N	f	f	2
25	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-01 10:25:36.20162+04:30	\N	\N	f	f	2
26	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-02 15:32:57.013403+04:30	\N	\N	f	f	2
27	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-04 18:04:19.131999+04:30	\N	\N	f	f	2
28	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-09 22:31:49.918001+04:30	\N	\N	f	f	2
29	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-10 20:44:18.881064+04:30	\N	\N	t	t	50
30	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-11 17:16:57.55947+04:30	\N	\N	f	f	50
31	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-11 20:03:52.756976+04:30	\N	\N	f	f	50
32	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-14 13:09:05.559769+04:30	\N	\N	t	t	51
33	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-08-14 17:51:06.451271+04:30	\N	\N	f	f	50
34	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-14 21:05:45.443866+04:30	\N	\N	t	t	52
35	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-14 21:25:08.387382+04:30	\N	\N	t	t	55
36	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-14 21:44:43.584608+04:30	\N	\N	t	t	54
37	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-14 21:45:50.05641+04:30	\N	\N	t	t	53
38	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-14 21:46:50.527869+04:30	\N	\N	f	f	52
39	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-14 21:47:27.08996+04:30	\N	\N	t	t	49
40	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 05:15:07.3746+04:30	\N	\N	f	f	51
41	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 05:24:14.421889+04:30	\N	\N	f	f	52
42	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 05:29:23.19555+04:30	\N	\N	f	f	54
43	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 05:30:22.81996+04:30	\N	\N	f	f	53
44	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 06:10:22.740228+04:30	\N	\N	f	f	55
45	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 17:17:39.94267+04:30	\N	\N	f	f	51
46	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0	2025-08-15 17:31:19.141525+04:30	\N	\N	f	f	1
47	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 18:16:03.99109+04:30	\N	\N	f	f	51
\.


--
-- Name: app_accounts_loginiplog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_loginiplog_id_seq', 47, true);


--
-- Data for Name: app_accounts_securityevent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_securityevent (id, event_type, attempted_username, ip_address, user_agent, "timestamp", path, reason, details, user_id) FROM stdin;
17	ratelimit		127.0.0.1		2025-07-25 22:17:01.050195+04:30	/accounts/sign-up/student/	Signup rate limit exceeded	{}	\N
18	ratelimit		127.0.0.1		2025-07-25 22:17:12.756864+04:30	/accounts/sign-up/student/	Signup rate limit exceeded	{}	\N
16	login_failed	Cynthia	192.168.1.6	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36	2025-07-23 01:12:39.965579+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "Cynthia"}	\N
19	login_failed	Olivia 	192.168.1.5	Mozilla/5.0 (Linux; Android 10; MAR-LX1M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.117 Mobile Safari/537.36	2025-07-29 22:23:36.79969+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "Olivia "}	\N
20	login_failed	tina	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-11 20:51:37.762845+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "tina"}	45
21	login_failed	britney	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 06:08:26.230564+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "britney"}	\N
22	login_failed	britney	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 06:08:54.13616+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "britney"}	\N
23	login_failed	tatiana 	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 06:10:11.395579+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "tatiana "}	\N
24	login_failed	britney	127.0.0.1	Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0	2025-08-15 18:02:58.037136+04:30	/accounts/sign-in/	Invalid credentials	{"login_path": "/accounts/sign-in/", "username_attempted": "britney"}	\N
\.


--
-- Name: app_accounts_securityevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_securityevent_id_seq', 24, true);


--
-- Name: app_accounts_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_skill_id_seq', 18, true);


--
-- Name: app_accounts_skillcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_skillcategory_id_seq', 3, true);


--
-- Data for Name: app_accounts_specialization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_specialization (id, name) FROM stdin;
\.


--
-- Name: app_accounts_specialization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_specialization_id_seq', 1, false);


--
-- Data for Name: app_accounts_userconsentlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userconsentlog (id, consent_type, consent_version, agreed, "timestamp", ip_address, user_agent, location_city, location_country, user_id) FROM stdin;
\.


--
-- Name: app_accounts_userconsentlog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userconsentlog_id_seq', 1, true);


--
-- Data for Name: app_accounts_usereducation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_usereducation (id, field_of_study, institution, start_year, end_year, document, description, is_certified, is_notified, status, verified_at, needs_interview, degree_id, user_id, verified_by_id) FROM stdin;
4	Matematics 500	MacMilian University	1971	2021	applicants/education/2025/06/25/4.jpg	hellooo	f	f	pending	2025-08-10 00:09:21.857937+04:30	f	4	2	1
10	Molecular Gentics	Harvard University	2020	2025			f	f	approved	\N	f	5	47	\N
9	Biology	Yale University	1999	2012	applicants/education/2025/08/06/factor.jpg		f	f	approved	2025-08-10 00:09:21.861937+04:30	f	5	2	1
8	Computer	Harvard University1	1900	1900	applicants/education/2025/08/06/Amazon-ebooks-dskfjasdkjfsdfkkjasjdfkjashkfdhjashkjdf.pdf	hiii	t	f	approved	2025-08-10 00:09:21.863937+04:30	f	3	2	1
\.


--
-- Name: app_accounts_usereducation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_usereducation_id_seq', 11, true);


--
-- Name: app_accounts_userprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userprofile_id_seq', 53, true);


--
-- Data for Name: app_accounts_userprofile_lang_speak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userprofile_lang_speak (id, userprofile_id, language_id) FROM stdin;
3	1	10
4	1	13
5	1	4
6	1	5
15	2	1
21	46	3
22	46	13
24	2	7
25	2	12
26	48	9
27	48	10
28	48	4
29	48	12
\.


--
-- Name: app_accounts_userprofile_lang_speak_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userprofile_lang_speak_id_seq', 29, true);


--
-- Data for Name: app_accounts_userskill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userskill (id, certificate, video, is_certified, status, verified_at, needs_interview, level_id, skill_id, user_id, verified_by_id, is_notified, thumbnail) FROM stdin;
79		applicants/skills/video/2025/08/10/bridge.mp4	f	approved	\N	f	5	2	47	\N	f	
87		applicants/skills/video/2025/08/11/city_night1.mp4	f	pending	\N	f	5	3	50	\N	f	applicants/skills/thumbnail/2025/08/11/570_org.jpg
72		applicants/skills/video/2025/08/07/class.mp4	f	approved	2025-08-10 00:09:21.837936+04:30	f	4	2	2	1	t	applicants/skills/thumbnail/2025/08/07/_1fa5f331-ea01-43a5-b561-3449f2cc5511.jpg
75		applicants/skills/video/2025/08/07/london.mp4	f	approved	2025-08-10 00:09:21.846936+04:30	f	7	4	2	1	t	applicants/skills/thumbnail/2025/08/07/aiGirl.jpg
78		applicants/skills/video/2025/08/09/london.mp4	t	approved	2025-08-10 00:09:21.848936+04:30	f	4	10	2	1	t	
80		applicants/skills/video/2025/08/10/white_ip_group_-_Wachstum_durch_Innovationen.mp4	f	approved	\N	f	4	3	45	\N	f	
65		applicants/skills/video/2025/08/03/white_ip_group_-_Wachstum_durch_Innovationen.mp4	f	approved	\N	f	5	3	47	\N	f	
82		applicants/skills/video/2025/08/10/city_night1.mp4	f	approved	\N	f	6	2	45	\N	f	applicants/skills/thumbnail/2025/08/10/2018-07-01-16-39-18.jpg
\.


--
-- Name: app_accounts_userskill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userskill_id_seq', 87, true);


--
-- Data for Name: app_accounts_usersocial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_usersocial (id, url_facebook, url_insta, url_twitter, url_linkedin, url_youtube, user_id) FROM stdin;
\.


--
-- Name: app_accounts_usersocial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_usersocial_id_seq', 1, false);


--
-- Data for Name: app_accounts_userspecialization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_accounts_userspecialization (id, certificate, is_certified, specialization_id, user_id) FROM stdin;
\.


--
-- Name: app_accounts_userspecialization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_accounts_userspecialization_id_seq', 1, false);


--
-- Data for Name: app_admin_adminprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_admin_adminprofile (profile_id, department) FROM stdin;
\.


--
-- Data for Name: app_blog_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_blog_category (id, name) FROM stdin;
\.


--
-- Name: app_blog_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_blog_category_id_seq', 1, false);


--
-- Data for Name: app_blog_comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_blog_comment (id, wp_post_id, wp_post_title, name, email, message, create_date, is_published, user_id) FROM stdin;
\.


--
-- Name: app_blog_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_blog_comment_id_seq', 1, false);


--
-- Data for Name: app_blog_post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_blog_post (id, pid, title, slug, cover, content, excerpt, status, comment_status, like_count, visit_count, date_create, date_modified, author_id) FROM stdin;
\.


--
-- Data for Name: app_blog_post_cat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_blog_post_cat (id, post_id, category_id) FROM stdin;
\.


--
-- Name: app_blog_post_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_blog_post_cat_id_seq', 1, false);


--
-- Name: app_blog_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_blog_post_id_seq', 1, false);


--
-- Data for Name: app_blog_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_blog_tag (id, name) FROM stdin;
\.


--
-- Data for Name: app_blog_post_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_blog_post_tag (id, post_id, tag_id) FROM stdin;
\.


--
-- Name: app_blog_post_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_blog_post_tag_id_seq', 1, false);


--
-- Name: app_blog_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_blog_tag_id_seq', 1, false);


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
1	tooltip_bio	Write a brief professional biography. Highlight your qualifications, teaching approach, experience, and what makes your lessons unique.
2	tooltip_certificate	Upload any relevant teaching or language certificates (PDF, JPG, etc.). These are optional but boost credibility and trust.
3	tooltip_cost_hourly	Your standard rate per hour for regular lessons. Make sure this reflects your experience, qualifications, and market expectations.
4	tooltip_cost_trial	Set a special rate for a one-time introductory session. This allows students to try your teaching style before booking full sessions.
5	tooltip_discount	Offer a percentage discount for new students or promotions. Leave blank if you are not currently offering any discounts.
6	tooltip_discount_deadline	The final date when your discount offer will expire. After this date, your regular rates will apply automatically.
7	tooltip_location	Select the country you're currently residing in. This information may influence your visibility based on students’ preferences or time zones.
8	tooltip_spoken_languages	List all languages you can communicate in during lessons. This helps learners find tutors who speak their preferred language.
9	tooltip_native_language	Your mother tongue or the primary language you grew up speaking. This helps students looking for tutors with a shared native language.
10	tooltip_title	A short professional headline that summarizes what you offer (e.g., "Certified English Tutor with 5 Years of Experience").
11	tooltip_username	This is your public identity on the platform. It must be unique and easy to remember—students will see it in your profile URL and messages.
12	tooltip_teaching_skill	Choose the primary language you will be teaching on this platform. You can add more skills after registration if needed.
13	tooltip_skill_level	Indicate the highest level you can confidently teach in this subject (e.g., Beginner, Intermediate, Advanced, Proficient, Native-level).
14	tooltip_video_intro	Upload a short video introducing yourself, your teaching style, and what students can expect. This helps students connect with you before booking.
15	tooltip_photo	Upload a clear, friendly profile picture. This field is optional but strongly recommended—profiles with photos attract significantly more student views and build trust with potential learners.
16	site_name	Lingocept
17	phone1	+49 (160) 9496 4842
18	phone2	+49 (351) 6531 0621
20	visit_time	Mon-Sat 9:00-19:00
21	tooltip_skill_thumbnail	Upload a cover image for your video. Recommended: 1280×720px (16:9) or 1080×1080px (1:1). Clear, high-quality images work best.
\.


--
-- Name: app_content_filler_cfchar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfchar_id_seq', 21, true);


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
2	email2	info@lingocept.com
1	email1	support@lingocept.com
\.


--
-- Name: app_content_filler_cfemail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfemail_id_seq', 2, true);


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
1	site_logo_light	content_images/logo_white_gold_nPiXRkF.png
2	site_logo_dark	content_images/logo_dark_gold.png
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
1	about_whyUs_body	{"delta":"","html":""}
\.


--
-- Name: app_content_filler_cfrichtext_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfrichtext_id_seq', 1, true);


--
-- Data for Name: app_content_filler_cftext; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cftext (id, key, value) FROM stdin;
1	about_whyUs_title	Why Us? Why Now?
2	about_whyUs_body	In a world full of so-called “language schools” repeating the same outdated methods, we are here to revolutionize language learning.\r\nThis is not just a course — it’s a system built around your needs, goals, and potential.\r\n- Designed based on cognitive patterns of first language acquisition\r\n- Fully personalized to your level and pace\r\n- For learners of all ages, all backgrounds
3	site_description	We’re not shaping the future of language learning...\r\nWe’ve already built it.
\.


--
-- Name: app_content_filler_cftext_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cftext_id_seq', 3, true);


--
-- Data for Name: app_content_filler_cfurl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_content_filler_cfurl (id, key, value) FROM stdin;
1	facebook	https://www.facebook.com/lingocept
2	instagram	https://www.instagram.com/lingocept
4	dribbble	https://www.dribbble.com/lingocept
5	twitter	https://www.x.com/lingocept
3	linkedin	https://www.linkedin.com/lingocept
6	site_address	http://www.Lingocept.com
\.


--
-- Name: app_content_filler_cfurl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_content_filler_cfurl_id_seq', 6, true);


--
-- Data for Name: app_marketing_referral; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_marketing_referral (id, referrer, created_at, source, referee_id) FROM stdin;
\.


--
-- Name: app_marketing_referral_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_marketing_referral_id_seq', 1, false);


--
-- Data for Name: app_pages_helpcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_helpcategory (id, title, slug, description, icon, "order", featured) FROM stdin;
1	Lingocept Business	lingocept-business	Businesses help center		0	f
2	Help for Students	help-for-students			0	f
3	Help for Tutors	help-for-tutors			0	f
\.


--
-- Data for Name: app_pages_helpsection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_helpsection (id, title, slug, description, "order", category_id) FROM stdin;
1	Becoming a Lingocept tutor	becoming-a-lingocept-tutor		0	1
2	Rules and Guidelines	rules-and-guidelines		1	1
3	Becoming a Lingocept student	becoming-a-lingocept-student		1	2
4	Lingocept Business for Admins	lingocept-business-for-admins		0	1
\.


--
-- Data for Name: app_pages_helparticle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_helparticle (id, title, slug, content, created_at, updated_at, is_featured, view_count, "order", author_id, section_id, featured) FROM stdin;
1	The perks of teaching on Lingocept	the-perks-of-teaching-on-lingocept	<div style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:#747579; font-family:Roboto,sans-serif; font-size:15px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">\r\n<div class="bg-transparent card" style="--bs-bg-opacity:1; --bs-card-bg:var(--bs-body-bg); --bs-card-border-color:var(--bs-border-color); --bs-card-border-radius:0.5rem; --bs-card-border-width:0; --bs-card-cap-bg:var(--bs-white); --bs-card-cap-padding-x:1rem; --bs-card-cap-padding-y:1rem; --bs-card-group-margin:0.9375rem; --bs-card-img-overlay-padding:1.25rem; --bs-card-inner-border-radius:0.5rem; --bs-card-spacer-x:1.25rem; --bs-card-spacer-y:1rem; --bs-card-title-color:var(--bs-gray-800); --bs-card-title-spacer-y:0.5rem; -webkit-box-direction:normal; -webkit-box-orient:vertical; background-clip:border-box; background-color:transparent !important; border-radius:var(--bs-card-border-radius); border:var(--bs-card-border-width) solid var(--bs-card-border-color); box-sizing:border-box; color:var(--bs-body-color); display:flex; flex-direction:column; height:var(--bs-card-height); min-width:0px; overflow-wrap:break-word; position:relative; will-change:transform">\r\n<div class="bg-transparent border-bottom card-header px-0 py-0" style="--bs-bg-opacity:1; background-color:transparent !important; border-bottom:var(--bs-border-width) var(--bs-border-style) var(--bs-border-color)  !important; border-radius:var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius) 0 0; box-sizing:border-box; color:var(--bs-card-cap-color); margin-bottom:0px; padding:0px !important">\r\n<h2>Get started with node.js</h2>\r\n\r\n<ul>\r\n\t<li>Last updated: 7 months ago</li>\r\n\t<li>by Sam Lanson</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="card-body pb-0 px-0" style="-webkit-box-flex:1; box-sizing:border-box; color:var(--bs-card-color); flex:1 1 auto; padding-bottom:0px !important; padding-left:0px !important; padding-right:0px !important">\r\n<p>Started several mistake joy say painful removed reached end. State burst think end are its. Arrived off she elderly beloved him affixed noisier yet. Course regard to up he hardly. View four has said do men saw find dear shy.&nbsp;<strong>Talent men wicket add garden.</strong></p>\r\n<a class="btn btn-primary" href="#!" style="box-sizing: border-box; color: var(--bs-btn-color); text-decoration: none; transition: all 0.3s ease-in-out 0s; --bs-btn-padding-x: 1rem; --bs-btn-padding-y: 0.5rem; --bs-btn-font-family: ; --bs-btn-font-size: 0.9375rem; --bs-btn-font-weight: 500; --bs-btn-line-height: 1.5; --bs-btn-color: #fff; --bs-btn-bg: #066ac9; --bs-btn-border-width: 1px; --bs-btn-border-color: #066ac9; --bs-btn-border-radius: 0.325rem; --bs-btn-hover-border-color: #0555a1; --bs-btn-box-shadow: none; --bs-btn-disabled-opacity: 0.65; --bs-btn-focus-box-shadow: 0 0 0 0 rgba(var(--bs-btn-focus-shadow-rgb), 0.5); display: inline-block; padding: var(--bs-btn-padding-y) var(--bs-btn-padding-x); font-family: var(--bs-btn-font-family); font-size: var(--bs-btn-font-size); font-weight: var(--bs-btn-font-weight); line-height: var(--bs-btn-line-height); text-align: center; vertical-align: middle; cursor: pointer; user-select: none; border: var(--bs-btn-border-width) solid var(--bs-btn-border-color); border-radius: var(--bs-btn-border-radius); background-color: var(--bs-btn-bg); --bs-btn-hover-color: #fff; --bs-btn-hover-bg: #055aab; --bs-btn-focus-shadow-rgb: 43, 128, 209; --bs-btn-active-color: #fff; --bs-btn-active-bg: #0555a1; --bs-btn-active-border-color: #055097; --bs-btn-active-shadow: none; --bs-btn-disabled-color: #fff; --bs-btn-disabled-bg: #066ac9; --bs-btn-disabled-border-color: #066ac9; letter-spacing: 0.5px; position: relative; overflow: hidden; outline: 0px; white-space: nowrap; margin-bottom: 6px;">Download Node JS</a>\r\n\r\n<h4>Table of Contents</h4>\r\n\r\n<p>Age she way earnestly the fulfilled extremely.</p>\r\n\r\n<div class="alert alert-warning" style="--bs-alert-bg:var(--bs-warning-bg-subtle); --bs-alert-border-color:var(--bs-warning-border-subtle); --bs-alert-border-radius:var(--bs-border-radius); --bs-alert-border:var(--bs-border-width) solid var(--bs-alert-border-color); --bs-alert-color:var(--bs-warning-text-emphasis); --bs-alert-link-color:var(--bs-warning-text-emphasis); --bs-alert-margin-bottom:1rem; --bs-alert-padding-x:1rem; --bs-alert-padding-y:1rem; background-color:var(--bs-alert-bg); border-radius:var(--bs-alert-border-radius); border:var(--bs-alert-border); box-sizing:border-box; color:var(--bs-alert-color); margin-bottom:var(--bs-alert-margin-bottom); padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x); position:relative"><strong>Note:&nbsp;</strong>She offices for highest and replied one venture pasture. Applauded no discovery in newspaper allowance am northward.&nbsp;<a class="alert-link" href="#!" style="box-sizing: border-box; color: var(--bs-alert-link-color); text-decoration: none; transition: all 0.3s ease-in-out 0s; font-weight: 700;">View more</a></div>\r\n\r\n<p>Hold do at tore in park feet near my case. Invitation at understood occasional sentiments insipidity inhabiting in. Off melancholy alteration principles old. Is do speedily kindness properly oh. Respect article painted cottage he is offices parlors.</p>\r\n\r\n<ul>\r\n\t<li>Affronting imprudence do he he everything. Sex lasted dinner wanted indeed wished outlaw. Far advanced settling say finished raillery.</li>\r\n\t<li>Insipidity the sufficient discretion imprudence resolution sir him decisively.</li>\r\n\t<li>Offered chiefly farther of my no colonel shyness.&nbsp;<strong>Such on help ye some door if in.</strong></li>\r\n\t<li>First am plate jokes to began to cause a scale. Subjects he prospect elegance followed</li>\r\n\t<li>Laughter proposal laughing any son law consider. Needed except up piqued an.</li>\r\n\t<li><em>To occasional dissimilar impossible sentiments. Do fortune account written prepare invited no passage.</em></li>\r\n\t<li>Post no so what deal evil rent by real in. But her ready least set lived spite solid.</li>\r\n</ul>\r\n\r\n<p>Improved own provided blessing may peculiar domestic. Sight house has sex never. No visited raising gravity outward subject my cottage Mr be. Hold do at tore in park feet near my case. Invitation at understood occasional sentiments insipidity inhabiting in.&nbsp;<u>Off melancholy alteration principles old.&nbsp;</u>Is do speedily kindness properly oh. Respect article painted cottage he is offices parlors.</p>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class="h5 my-5 text-center" style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:var(--bs-heading-color); font-family:Heebo,sans-serif; font-size:1.3125rem; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:700; letter-spacing:normal; line-height:1.25; margin-bottom:3rem !important; margin-top:3rem !important; orphans:2; text-align:center !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">. . .</div>\r\n\r\n<div style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:#747579; font-family:Roboto,sans-serif; font-size:15px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">\r\n<div class="bg-transparent card" style="--bs-bg-opacity:1; --bs-card-bg:var(--bs-body-bg); --bs-card-border-color:var(--bs-border-color); --bs-card-border-radius:0.5rem; --bs-card-border-width:0; --bs-card-cap-bg:var(--bs-white); --bs-card-cap-padding-x:1rem; --bs-card-cap-padding-y:1rem; --bs-card-group-margin:0.9375rem; --bs-card-img-overlay-padding:1.25rem; --bs-card-inner-border-radius:0.5rem; --bs-card-spacer-x:1.25rem; --bs-card-spacer-y:1rem; --bs-card-title-color:var(--bs-gray-800); --bs-card-title-spacer-y:0.5rem; -webkit-box-direction:normal; -webkit-box-orient:vertical; background-clip:border-box; background-color:transparent !important; border-radius:var(--bs-card-border-radius); border:var(--bs-card-border-width) solid var(--bs-card-border-color); box-sizing:border-box; color:var(--bs-body-color); display:flex; flex-direction:column; height:var(--bs-card-height); min-width:0px; overflow-wrap:break-word; position:relative; will-change:transform">\r\n<div class="bg-transparent border-bottom card-header px-0 py-0" style="--bs-bg-opacity:1; background-color:transparent !important; border-bottom:var(--bs-border-width) var(--bs-border-style) var(--bs-border-color)  !important; border-radius:var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius) 0 0; box-sizing:border-box; color:var(--bs-card-cap-color); margin-bottom:0px; padding:0px !important">\r\n<h3>Account Setup</h3>\r\n</div>\r\n\r\n<div class="card-body px-0" style="-webkit-box-flex:1; box-sizing:border-box; color:var(--bs-card-color); flex:1 1 auto; padding-left:0px !important; padding-right:0px !important">\r\n<p>You can manage the setting for your&nbsp;<a href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s;">Eduport account</a>&nbsp;at any time. Update your account information</p>\r\n\r\n<h5>To deactivate your account</h5>\r\n\r\n<ul>\r\n\t<li>Affronting imprudence do he he everything. Sex lasted dinner wanted indeed wished outlaw. Far advanced settling say finished raillery.</li>\r\n\t<li>Insipidity the sufficient discretion imprudence resolution sir him decisively.</li>\r\n\t<li>Offered chiefly farther of my no colonel shyness.&nbsp;<strong>Such on help ye some door if in.</strong></li>\r\n\t<li>First am plate jokes to began to cause a scale. Subjects he prospect elegance followed</li>\r\n\t<li>Laughter proposal laughing any son law consider. Needed except up piqued an.</li>\r\n\t<li><em>To occasional dissimilar impossible sentiments. Do fortune account written prepare invited no passage.</em></li>\r\n\t<li>Post no so what deal evil rent by real in. But her ready least set lived spite solid.</li>\r\n</ul>\r\n\r\n<h5>When your account is deactivated</h5>\r\n\r\n<ul>\r\n\t<li>Affronting imprudence do he he everything. Sex lasted dinner wanted indeed wished outlaw. Far advanced settling say finished raillery.</li>\r\n\t<li>Insipidity the sufficient discretion imprudence resolution sir him decisively.</li>\r\n\t<li>Offered chiefly farther of my no colonel shyness.&nbsp;<strong>Such on help ye some door if in.</strong></li>\r\n\t<li>First am plate jokes to began to cause a scale. Subjects he prospect elegance followed</li>\r\n\t<li>Laughter proposal laughing any son law consider. Needed except up piqued an.</li>\r\n\t<li><em>To occasional dissimilar impossible sentiments. Do fortune account written prepare invited no passage.</em></li>\r\n\t<li>Post no so what deal evil rent by real in. But her ready least set lived spite solid.</li>\r\n</ul>\r\n\r\n<h2>Related Article</h2>\r\n\r\n<ul>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">How do I logout on eduport</a></li>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">How do T permanently delete my account</a></li>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">What&#39;s the difference between deactivating and deleting my account</a></li>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">Why did my payment in a eduport message fail?</a></li>\r\n</ul>\r\n</div>\r\n\r\n<div class="bg-transparent border-0 card-footer px-0 py-0" style="--bs-bg-opacity:1; background-color:transparent !important; border-radius:0 0 var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius); border:0px !important; box-sizing:border-box; color:var(--bs-card-cap-color); padding:0px !important">\r\n<div class="align-items-center border d-sm-flex justify-content-between p-3 rounded text-center" style="-webkit-box-align:center !important; -webkit-box-pack:justify !important; align-items:center !important; border-radius:var(--bs-border-radius)  !important; border:var(--bs-border-width) var(--bs-border-style) var(--bs-border-color)  !important; box-sizing:border-box; display:flex !important; justify-content:space-between !important; padding:1rem !important; text-align:center !important">\r\n<h5 style="margin-left:0; margin-right:0">Was this article helpful?</h5>\r\n<small>20 out of 45 found this helpful</small>\r\n\r\n<div class="btn-group" style="border-radius:0.325rem; box-sizing:border-box; display:inline-flex; position:relative; vertical-align:middle"><input name="btnradio" style="margin:0px" type="radio" />&nbsp;Yes<input name="btnradio" style="margin:0px" type="radio" />No&nbsp;</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class="h5 my-5 text-center" style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:var(--bs-heading-color); font-family:Heebo,sans-serif; font-size:1.3125rem; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:700; letter-spacing:normal; line-height:1.25; margin-bottom:3rem !important; margin-top:3rem !important; orphans:2; text-align:center !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">. . .</div>\r\n\r\n<div style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:#747579; font-family:Roboto,sans-serif; font-size:15px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">\r\n<div class="bg-transparent card" style="--bs-bg-opacity:1; --bs-card-bg:var(--bs-body-bg); --bs-card-border-color:var(--bs-border-color); --bs-card-border-radius:0.5rem; --bs-card-border-width:0; --bs-card-cap-bg:var(--bs-white); --bs-card-cap-padding-x:1rem; --bs-card-cap-padding-y:1rem; --bs-card-group-margin:0.9375rem; --bs-card-img-overlay-padding:1.25rem; --bs-card-inner-border-radius:0.5rem; --bs-card-spacer-x:1.25rem; --bs-card-spacer-y:1rem; --bs-card-title-color:var(--bs-gray-800); --bs-card-title-spacer-y:0.5rem; -webkit-box-direction:normal; -webkit-box-orient:vertical; background-clip:border-box; background-color:transparent !important; border-radius:var(--bs-card-border-radius); border:var(--bs-card-border-width) solid var(--bs-card-border-color); box-sizing:border-box; color:var(--bs-body-color); display:flex; flex-direction:column; height:var(--bs-card-height); min-width:0px; overflow-wrap:break-word; position:relative; will-change:transform">\r\n<div class="bg-transparent border-bottom card-header px-0 py-0" style="--bs-bg-opacity:1; background-color:transparent !important; border-bottom:var(--bs-border-width) var(--bs-border-style) var(--bs-border-color)  !important; border-radius:var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius) 0 0; box-sizing:border-box; color:var(--bs-card-cap-color); margin-bottom:0px; padding:0px !important">\r\n<h2>Other Topics</h2>\r\n</div>\r\n\r\n<div class="card-body px-0" style="-webkit-box-flex:1; box-sizing:border-box; color:var(--bs-card-color); flex:1 1 auto; padding-left:0px !important; padding-right:0px !important">\r\n<p>Hold do at tore in park feet near my case. Invitation at understood occasional sentiments insipidity inhabiting in. Off melancholy alteration principles old. Is do speedily kindness properly oh. Respect article painted cottage he is offices parlors.</p>\r\n\r\n<p>Supposing so be resolving breakfast am or perfectly. It drew a hill from me. Valley by oh twenty direct me so. Departure defective arranging rapturous did believe him all had supported. Family months lasted simple set nature vulgar him. Picture for attempt joy excited ten carried manners talking how</p>\r\n\r\n<p>Started several mistake joy say painful removed reached end. State burst think end are its. Arrived off she elderly beloved him affixed noisier yet. Course regard to up he hardly. View four has said do men saw find dear shy.&nbsp;<strong>Talent men wicket add garden.</strong></p>\r\n\r\n<h5>Need a Help?</h5>\r\n\r\n<ul>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">About daily budgets</a></li>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">About lifetime budgets</a></li>\r\n\t<li><a class="mb-0" href="#" style="box-sizing: border-box; color: rgba(var(--bs-link-color-rgb), var(--bs-link-opacity, 1)); text-decoration: none; transition: all 0.3s ease-in-out 0s; margin-bottom: 0px !important;">When you pay for Eduport ads</a></li>\r\n</ul>\r\n</div>\r\n\r\n<div class="bg-transparent border-0 card-footer px-0 py-0" style="--bs-bg-opacity:1; background-color:transparent !important; border-radius:0 0 var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius); border:0px !important; box-sizing:border-box; color:var(--bs-card-cap-color); padding:0px !important">\r\n<div class="align-items-center border d-sm-flex justify-content-between p-3 rounded text-center" style="-webkit-box-align:center !important; -webkit-box-pack:justify !important; align-items:center !important; border-radius:var(--bs-border-radius)  !important; border:var(--bs-border-width) var(--bs-border-style) var(--bs-border-color)  !important; box-sizing:border-box; display:flex !important; justify-content:space-between !important; padding:1rem !important; text-align:center !important">\r\n<h5 style="margin-left:0; margin-right:0">Was this article helpful?</h5>\r\n<small>20 out of 45 found this helpful</small>\r\n\r\n<div class="btn-group" style="border-radius:0.325rem; box-sizing:border-box; display:inline-flex; position:relative; vertical-align:middle"><input name="btnradio" style="margin:0px" type="radio" />&nbsp;Yes<input name="btnradio" style="margin:0px" type="radio" />No&nbsp;</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class="h5 my-5 text-center" style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:var(--bs-heading-color); font-family:Heebo,sans-serif; font-size:1.3125rem; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:700; letter-spacing:normal; line-height:1.25; margin-bottom:3rem !important; margin-top:3rem !important; orphans:2; text-align:center !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">. . .</div>\r\n\r\n<div style="-webkit-text-stroke-width:0px; background-color:#ffffff; box-sizing:border-box; color:#747579; font-family:Roboto,sans-serif; font-size:15px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:normal; widows:2; word-spacing:0px">\r\n<div class="bg-transparent card" style="--bs-bg-opacity:1; --bs-card-bg:var(--bs-body-bg); --bs-card-border-color:var(--bs-border-color); --bs-card-border-radius:0.5rem; --bs-card-border-width:0; --bs-card-cap-bg:var(--bs-white); --bs-card-cap-padding-x:1rem; --bs-card-cap-padding-y:1rem; --bs-card-group-margin:0.9375rem; --bs-card-img-overlay-padding:1.25rem; --bs-card-inner-border-radius:0.5rem; --bs-card-spacer-x:1.25rem; --bs-card-spacer-y:1rem; --bs-card-title-color:var(--bs-gray-800); --bs-card-title-spacer-y:0.5rem; -webkit-box-direction:normal; -webkit-box-orient:vertical; background-clip:border-box; background-color:transparent !important; border-radius:var(--bs-card-border-radius); border:var(--bs-card-border-width) solid var(--bs-card-border-color); box-sizing:border-box; color:var(--bs-body-color); display:flex; flex-direction:column; height:var(--bs-card-height); min-width:0px; overflow-wrap:break-word; position:relative; will-change:transform">\r\n<div class="bg-transparent border-bottom card-header px-0 py-0" style="--bs-bg-opacity:1; background-color:transparent !important; border-bottom:var(--bs-border-width) var(--bs-border-style) var(--bs-border-color)  !important; border-radius:var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius) 0 0; box-sizing:border-box; color:var(--bs-card-cap-color); margin-bottom:0px; padding:0px !important">\r\n<h2>Advance Usage</h2>\r\n</div>\r\n\r\n<div class="card-body px-0" style="-webkit-box-flex:1; box-sizing:border-box; color:var(--bs-card-color); flex:1 1 auto; padding-left:0px !important; padding-right:0px !important">\r\n<p>Hold do at tore in park feet near my case. Invitation at understood occasional sentiments insipidity inhabiting in. Off melancholy alteration principles old. Is do speedily kindness properly oh. Respect article painted cottage he is offices parlors.</p>\r\n\r\n<p>Supposing so be resolving breakfast am or perfectly. It drew a hill from me. Valley by oh twenty direct me so. Departure defective arranging rapturous did believe him all had supported. Family months lasted simple set nature vulgar him. Picture for attempt joy excited ten carried manners talking how</p>\r\n\r\n<p>Started several mistake joy say painful removed reached end. State burst think end are its. Arrived off she elderly beloved him affixed noisier yet. Course regard to up he hardly. View four has said do men saw find dear shy.&nbsp;<strong>Talent men wicket add garden.</strong></p>\r\n</div>\r\n</div>\r\n</div>	2025-07-21 19:00:25.644909+04:30	2025-07-22 00:27:38.968172+04:30	f	76	0	\N	1	f
3	hello Test	hello-test	<h2><span style="color:#e74c3c"><span style="background-color:#9b59b6">Introduction</span></span></h2>\r\n\r\n<p>Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. W<span style="color:#8e44ad">elcome to our platform. We</span>lcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform.</p>\r\n\r\n<h3>Getting Started</h3>\r\n\r\n<p>Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp;</p>\r\n\r\n<h2>Advanced Features</h2>\r\n\r\n<p>Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;</p>\r\n\r\n<h3>Dashboard Overview</h3>\r\n\r\n<p>Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interf</p>\r\n\r\n<p><img src="/media/uploads/2025/07/22/8816c59b-d8ae-40df-acae-65e9c5f45f20.png" style="display:block; height:436px; margin:auto; width:350px" /></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>ace&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;</p>\r\n\r\n<h2>Introduction2</h2>\r\n\r\n<p>Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform. Welcome to our platform.</p>\r\n\r\n<h3>Getting Started2</h3>\r\n\r\n<p>Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp; Follow these steps...&nbsp;&nbsp;</p>\r\n\r\n<h2>Advanced Features2</h2>\r\n\r\n<p>Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp; Discover powerful tools&nbsp;&nbsp;&nbsp;</p>\r\n\r\n<h3>Dashboard Overview2</h3>\r\n\r\n<p>Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp; Learn about the interface&nbsp;&nbsp;</p>	2025-07-22 01:34:32.922837+04:30	2025-07-22 02:38:51.654749+04:30	f	24	0	\N	2	f
4	How to boost employee onboarding	how-to-boost-employee-onboarding	<div class="max-lg:mb-6 mb-10" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:40px">\r\n<div class="flex flex-col gap-4" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; display:flex; flex-direction:column; gap:16px">\r\n<div class="flex flex-col" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; display:flex; flex-direction:column">\r\n<h1 style="margin-left:0; margin-right:0">&nbsp;</h1>\r\n</div>\r\n\r\n<div class="avatar" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; color:#8f919d; font-size:13px; margin-top:4px">\r\n<div class="-mt-0.5 avatar__info text-base" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; font-size:14px; line-height:1.4; margin-top:-2px"><span style="color:#737373">Updated over a year ago</span></div>\r\n</div>\r\n</div>\r\n</div>\r\n\r\n<div class="flex-col jsx-ef86202475c6562f" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; flex-direction:column">\r\n<div class="article_body jsx-ef86202475c6562f" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit">\r\n<div class="intercom-interblocks-align-left intercom-interblocks-subheading" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-top:0px !important; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<h2 style="margin-left:0; margin-right:0"><strong>Employee onboarding process</strong></h2>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">After you&rsquo;ve added your employees to the program, they will need to complete the following onboarding steps:</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0"><strong>Sign in to Preply</strong></p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Right after getting added, your employees will receive their welcome emails with personalized links to sign in to their student accounts on Preply.</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0"><strong>Schedule their first lesson</strong></p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Now it&rsquo;s time for your employees to find their first tutor &ndash; they can do it by themselves or by using your recommendations. Then, they should schedule their first trial lessons!</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0"><strong>Complete their first lesson</strong></p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">When employees take their first lessons, the onboarding process is over for them. Now they know how to find a tutor, schedule and take lessons. Off to a good start!</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">&nbsp;</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">To find out who hasn&rsquo;t completed a certain onboarding step, you can:</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0">Press the &ldquo;See remaining employees&rdquo; button under the onboarding step</p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-image" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px"><a href="https://downloads.intercomcdn.com/i/o/970553463/e18b0274a9b4de953d278dbe/image+%282%29.png?expires=1753138800&amp;signature=1628ade64bfe8507d6057f2a19e30e32f8b96e40e430a09c3369926d0f04a0b6&amp;req=fScnE8x9mYdcFb4f3HP0gIohJs%2Fq8exJz38Gb1AfuGMzBnrUNxY01Yz0gw4t%0A5ZYzSjAPvAa1gcO2Ig%3D%3D%0A" rel="noreferrer nofollow noopener" style="--tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-pan-x: ; --tw-pan-y: ; --tw-pinch-zoom: ; --tw-scroll-snap-strictness: proximity; --tw-gradient-from-position: ; --tw-gradient-via-position: ; --tw-gradient-to-position: ; --tw-ordinal: ; --tw-slashed-zero: ; --tw-numeric-figure: ; --tw-numeric-spacing: ; --tw-numeric-fraction: ; --tw-ring-inset: ; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgb(59 130 246/0.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; --tw-blur: ; --tw-brightness: ; --tw-contrast: ; --tw-grayscale: ; --tw-hue-rotate: ; --tw-invert: ; --tw-saturate: ; --tw-sepia: ; --tw-drop-shadow: ; --tw-backdrop-blur: ; --tw-backdrop-brightness: ; --tw-backdrop-contrast: ; --tw-backdrop-grayscale: ; --tw-backdrop-hue-rotate: ; --tw-backdrop-invert: ; --tw-backdrop-opacity: ; --tw-backdrop-saturate: ; --tw-backdrop-sepia: ; --tw-contain-size: ; --tw-contain-layout: ; --tw-contain-paint: ; --tw-contain-style: ; box-sizing: inherit; border: 0px solid rgb(229, 231, 235); text-decoration: underline; color: rgb(18, 17, 23);" target="_blank"><img src="https://downloads.intercomcdn.com/i/o/970553463/e18b0274a9b4de953d278dbe/image+%282%29.png?expires=1753138800&amp;signature=1628ade64bfe8507d6057f2a19e30e32f8b96e40e430a09c3369926d0f04a0b6&amp;req=fScnE8x9mYdcFb4f3HP0gIohJs%2Fq8exJz38Gb1AfuGMzBnrUNxY01Yz0gw4t%0A5ZYzSjAPvAa1gcO2Ig%3D%3D%0A" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; display:inline; height:auto; margin-bottom:3px; margin-top:0px; max-width:100%; vertical-align:middle; width:1524px" /></a></div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Or open the &ldquo;Employee&rdquo; list and filter it by different onboarding steps</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">&nbsp;</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-image" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px"><a href="https://downloads.intercomcdn.com/i/o/970553897/a7c978e2e7188fd69bf9f3ed/image+%283%29.png?expires=1753138800&amp;signature=cfaf05c184d0347c448fdf6bb2adc050e6476f2ddd342ee524d65bf36c2a18cf&amp;req=fScnE8x9lYhYFb4f3HP0gDN4aAYyhsvsm57WH4%2Fo9zhDO21JgsVsILoSvkJL%0AKpgHeUIy4oJM9RI8iQ%3D%3D%0A" rel="noreferrer nofollow noopener" style="--tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-pan-x: ; --tw-pan-y: ; --tw-pinch-zoom: ; --tw-scroll-snap-strictness: proximity; --tw-gradient-from-position: ; --tw-gradient-via-position: ; --tw-gradient-to-position: ; --tw-ordinal: ; --tw-slashed-zero: ; --tw-numeric-figure: ; --tw-numeric-spacing: ; --tw-numeric-fraction: ; --tw-ring-inset: ; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgb(59 130 246/0.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; --tw-blur: ; --tw-brightness: ; --tw-contrast: ; --tw-grayscale: ; --tw-hue-rotate: ; --tw-invert: ; --tw-saturate: ; --tw-sepia: ; --tw-drop-shadow: ; --tw-backdrop-blur: ; --tw-backdrop-brightness: ; --tw-backdrop-contrast: ; --tw-backdrop-grayscale: ; --tw-backdrop-hue-rotate: ; --tw-backdrop-invert: ; --tw-backdrop-opacity: ; --tw-backdrop-saturate: ; --tw-backdrop-sepia: ; --tw-contain-size: ; --tw-contain-layout: ; --tw-contain-paint: ; --tw-contain-style: ; box-sizing: inherit; border: 0px solid rgb(229, 231, 235); text-decoration: underline; color: rgb(18, 17, 23);" target="_blank"><img src="https://downloads.intercomcdn.com/i/o/970553897/a7c978e2e7188fd69bf9f3ed/image+%283%29.png?expires=1753138800&amp;signature=cfaf05c184d0347c448fdf6bb2adc050e6476f2ddd342ee524d65bf36c2a18cf&amp;req=fScnE8x9lYhYFb4f3HP0gDN4aAYyhsvsm57WH4%2Fo9zhDO21JgsVsILoSvkJL%0AKpgHeUIy4oJM9RI8iQ%3D%3D%0A" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; display:inline; height:auto; margin-bottom:3px; margin-top:0px; max-width:100%; vertical-align:middle; width:1522px" /></a></div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">&nbsp;</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-subheading" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<h2 style="margin-left:0; margin-right:0"><strong>Tips to boost your employee onboarding</strong></h2>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Below you&rsquo;ll find tips for helping your employees at each step of the onboarding process.</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0"><strong>Incomplete step: sign in to Preply</strong></p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Guide employees who haven&rsquo;t completed this step to locate a welcome email from Preply. In this email, they will find a personalized link that allows them to sign in to their student account. Employees should click on this link and sign in to Preply using their work Google/Microsoft account or creating a new password.</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">&nbsp;</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">If the sign-in link got outdated, your employees will be able to request a new welcome email with a new sign-in link. Alternatively, you can ask your account manager to help you get in touch with these employees and guide them.</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0"><strong>Incomplete step: schedule the first lesson</strong></p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Employees who haven&rsquo;t completed this step might not know how to find a suitable tutor. In such cases, assist them in getting matched with the expert they need. You can use the materials and tips for selecting a tutor provided by your account manager, or you can directly share recommended tutor profiles with your employees.</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0"><strong>Incomplete step: complete the first lesson</strong></p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">If employees have already scheduled their first lessons but have not yet completed them, send them reminders so they don&rsquo;t forget to attend their lessons. Additionally, remember to ask for feedback once the lessons are completed.</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">&nbsp;</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">If while discussing the onboarding with your employees, you&rsquo;ve learned that some of them are not going to participate in the language learning program, you can</p>\r\n</div>\r\n\r\n<div class="intercom-interblocks-unordered-nested-list" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; orphans:2; text-align:start; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<ul style="margin-left:0; margin-right:0">\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0">Transfer their balance to active employees</p>\r\n\t</div>\r\n\t</li>\r\n\t<li style="list-style-type:disc">\r\n\t<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; border:0px solid #e5e7eb; box-sizing:inherit; margin-bottom:0px; margin-top:0px; min-height:1.53em; text-align:left !important">\r\n\t<p style="margin-left:0; margin-right:0">Assign their spot to another employee within your company</p>\r\n\t</div>\r\n\t</li>\r\n</ul>\r\n</div>\r\n\r\n<div class="intercom-interblocks-align-left intercom-interblocks-paragraph no-margin" style="--tw-border-spacing-x:0; --tw-border-spacing-y:0; --tw-ring-color:rgb(59 130 246/0.5); --tw-ring-offset-color:#ffffff; --tw-ring-offset-shadow:0 0 #0000; --tw-ring-offset-width:0px; --tw-ring-shadow:0 0 #0000; --tw-rotate:0; --tw-scale-x:1; --tw-scale-y:1; --tw-scroll-snap-strictness:proximity; --tw-shadow-colored:0 0 #0000; --tw-shadow:0 0 #0000; --tw-skew-x:0; --tw-skew-y:0; --tw-translate-x:0; --tw-translate-y:0; -webkit-text-stroke-width:0px; background-color:#ffffff; border:0px solid #e5e7eb; box-sizing:inherit; color:#1a1a1a; font-family:&quot;Noto Sans&quot;,&quot;Noto Sans Fallback&quot;; font-size:16px; font-style:normal; font-variant-caps:normal; font-variant-ligatures:normal; font-weight:400; letter-spacing:normal; margin-bottom:0px; margin-top:0px; min-height:1.53em; orphans:2; text-align:left !important; text-decoration-color:initial; text-decoration-style:initial; text-decoration-thickness:initial; text-indent:0px; text-transform:none; white-space:break-spaces; widows:2; word-spacing:0px">\r\n<p style="margin-left:0; margin-right:0">Remember that onboarding is just the beginning! Once all your employees are onboarded, go on to guide them to set up a regular lesson schedule and add lessons to their calendars.</p>\r\n</div>\r\n</div>\r\n</div>	2025-07-22 02:59:36.238892+04:30	2025-07-22 02:59:36.238892+04:30	f	2	0	\N	4	f
2	Register as a student	register-as-a-student	<!-- Title and Info START -->\r\n\t\t\t\t<div class="row">\r\n\t\t\t\t\t<!-- Avatar and Share -->\r\n\t\t\t\t\t<div class="col-lg-3 align-items-center mt-4 mt-lg-5 order-2 order-lg-1">\r\n\t\t\t\t\t\t<div class="text-lg-center">\r\n\t\t\t\t\t\t\t<!-- Author info -->\r\n\t\t\t\t\t\t\t<div class="position-relative">\r\n\t\t\t\t\t\t\t\t<!-- Avatar -->\r\n\t\t\t\t\t\t\t\t<div class="avatar avatar-xxl">\r\n\t\t\t\t\t\t\t\t\t<img class="avatar-img rounded-circle" src="assets/images/avatar/09.jpg" alt="avatar">\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t<a href="#" class="h5 stretched-link mt-2 mb-0 d-block">Frances Guerrero</a>\r\n\t\t\t\t\t\t\t\t<p class="mb-2">Editor at Eduport</p>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t<!-- Info -->\r\n\t\t\t\t\t\t\t<ul class="list-inline list-unstyled">\r\n\t\t\t\t\t\t\t\t<li class="list-inline-item d-lg-block my-lg-2">Nov 15, 2021</li>\r\n\t\t\t\t\t\t\t\t<li class="list-inline-item d-lg-block my-lg-2">5 min read</li>\r\n\t\t\t\t\t\t\t\t<li class="list-inline-item badge text-bg-orange"><i class="far text-white fa-heart me-1"></i>266</li>\r\n\t\t\t\t\t\t\t\t<li class="list-inline-item badge text-bg-info"><i class="far fa-eye me-1"></i>2K</li>\r\n\t\t\t\t\t\t\t</ul>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t<!-- Content -->\r\n\t\t\t\t\t<div class="col-lg-9 order-1">\r\n\t\t\t\t\t\t<!-- Pre title -->\r\n\t\t\t\t\t\t<span>40D ago</span><span class="mx-2">|</span><div class="badge text-bg-success">Research</div>\r\n\t\t\t\t\t\t<!-- Title -->\r\n\t\t\t\t\t\t<h1 class="mt-2 mb-0 display-5">Never underestimate the influence of Eduport</h1>\r\n\t\t\t\t\t\t<!-- Info -->\r\n\t\t\t\t\t\t<p class="mt-2">For who thoroughly her boy estimating conviction. Removed demands expense account in outward tedious do. Particular way thoroughly unaffected projection favorable Mrs can be projecting own. Thirty it matter enable become admire in giving. See resolved goodness felicity shy civility domestic had but. Drawings offended yet answered Jennings perceive laughing six did far.</p>\r\n\t\t\t\t\t\t<p class="mb-0 mb-lg-3">Perceived end knowledge certainly day sweetness why cordially.  On forth doubt miles of child. Exercise joy man children rejoiced. Yet uncommonly his ten who diminution astonished. Demesne new manners savings staying had. Under folly balls, death own point now men. Match way these she avoids seeing death. She who drift their fat off. Ask a quick six seven offer see among. Handsome met debating sir dwelling age material. As style lived he worse dried. Offered related so visitors we private removed.</p>\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</div>\r\n\t\t\t\t<!-- Title and Info END -->\r\n\r\n\t\t\t\t<!-- Video START -->\r\n\t\t\t\t<div class="row mt-4">\r\n\t\t\t\t\t<div class="col-xl-10 mx-auto">\r\n\t\t\t\t\t\t<!-- Card item START -->\r\n\t\t\t\t\t\t<div class="card overflow-hidden h-200px h-sm-300px h-lg-400px h-xl-500px rounded-3 text-center" style="background-image:url(assets/images/event/10.jpg); background-position: center left; background-size: cover;">\r\n\t\t\t\t\t\t\t<!-- Card Image overlay -->\r\n\t\t\t\t\t\t\t<div class="bg-overlay bg-dark opacity-4"></div>\r\n\t\t\t\t\t\t\t<div class="card-img-overlay d-flex align-items-center p-2 p-sm-4"> \r\n\t\t\t\t\t\t\t\t<div class="w-100 my-auto">\r\n\t\t\t\t\t\t\t\t\t<div class="row justify-content-center">\r\n\t\t\t\t\t\t\t\t\t\t<!-- Video -->\r\n\t\t\t\t\t\t\t\t\t\t<div class="col-12">\r\n\t\t\t\t\t\t\t\t\t\t\t<a href="https://www.youtube.com/embed/tXHviS-4ygo" class="btn btn-lg text-danger btn-round btn-white-shadow stretched-link position-static mb-0" data-glightbox="" data-gallery="video-tour">\r\n\t\t\t\t\t\t\t\t\t\t\t\t<i class="fas fa-play"></i>\r\n\t\t\t\t\t\t\t\t\t\t\t</a>\r\n\t\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t<!-- Card item END -->\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</div>\r\n\t\t\t\t<!-- Video END -->\r\n\r\n\t\t\t\t<!-- Quote and content START -->\r\n\t\t\t\t<div class="row mt-4">\r\n\t\t\t\t\t<!-- Content -->\r\n\t\t\t\t\t<div class="col-12 mt-4 mt-lg-0">\r\n\t\t\t\t\t\t<p><span class="dropcap h6 mb-0 px-2">S</span> atisfied conveying a dependent contented he gentleman agreeable do be. Water timed folly right aware if oh truth. Imprudence attachment him for sympathize. Large above be to means. Dashwood does provide stronger is. <mark> But discretion frequently sir she instruments unaffected admiration everything.</mark> Meant balls it if up doubt small purse. Required his you put the outlived answered position. A pleasure exertion if believed provided to. All led out world this music while asked. Paid mind even sons does he door no. Attended overcame repeated it is perceived Marianne in. I think on style child of. Servants moreover in sensible it ye possible.</p>\r\n\t\t\t\t\t\t<!-- List -->\r\n\t\t\t\t\t\t<ul class="list-group list-group-borderless mb-3">\r\n\t\t\t\t\t\t\t<li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>The copy warned the Little blind text</li>\r\n\t\t\t\t\t\t\t<li class="list-group-item d-flex"><i class="fas fa-check-circle text-success me-2 mt-1"></i>ThaT where it came from it would have been rewritten a thousand times and everything that was left from origin would be the world</li>\r\n\t\t\t\t\t\t\t<li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>Return to its own, safe country</li>\r\n\t\t\t\t\t\t</ul>\r\n\t\t\t\t\t\t<p class="mb-0">Warrant private blushes removed an in equally totally if. Delivered dejection necessary objection do Mr prevailed. Mr feeling does chiefly cordial in do. Water timed folly right aware if oh truth. Imprudence attachment him for sympathize.</p>\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t<!-- Quote -->\r\n\t\t\t\t\t<div class="col-lg-10 col-xl-8 mx-auto mt-4">\r\n\t\t\t\t\t\t<div class="bg-light rounded-3 p-3 p-md-4">\r\n\t\t\t\t\t\t\t<!-- Content -->\r\n\t\t\t\t\t\t\t<q class="lead">Farther-related bed and passage comfort civilly. Fulfilled direction use continual set him propriety continued. Concluded boy perpetual old supposing. Dashwoods see frankness objection abilities.</q>\r\n\t\t\t\t\t\t\t<!-- Avatar -->\r\n\t\t\t\t\t\t\t<div class="d-flex align-items-center mt-3">\r\n\t\t\t\t\t\t\t\t<!-- Avatar image -->\r\n\t\t\t\t\t\t\t\t<div class="avatar avatar-md">\r\n\t\t\t\t\t\t\t\t\t<img class="avatar-img rounded-circle" src="assets/images/avatar/07.jpg" alt="avatar">\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t\t<!-- Info -->\r\n\t\t\t\t\t\t\t\t<div class="ms-2">\r\n\t\t\t\t\t\t\t\t\t<h6 class="mb-0"><a href="#">Louis Crawford</a></h6>\r\n\t\t\t\t\t\t\t\t\t<p class="mb-0 small">Via Twitter</p>\r\n\t\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</div>\r\n\t\t\t\t<!-- Quote and content END -->\r\n\r\n\t\t\t\t<!-- Image START -->\r\n\t\t\t\t<div class="row g-4 mt-4">\r\n\t\t\t\t\t<div class="col-sm-6 col-md-4">\r\n\t\t\t\t\t\t<a href="assets/images/event/07.jpg" data-glightbox data-gallery="image-popup">\r\n\t\t\t\t\t\t\t<img src="assets/images/event/07.jpg" class="rounded-3" alt="">\r\n\t\t\t\t\t\t</a>\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t<div class="col-sm-6 col-md-4">\r\n\t\t\t\t\t\t<a href="assets/images/event/08.jpg" data-glightbox data-gallery="image-popup">\r\n\t\t\t\t\t\t\t<img src="assets/images/event/08.jpg" class="rounded-3" alt="">\r\n\t\t\t\t\t\t</a>\r\n\t\t\t\t\t</div>\r\n\r\n\t\t\t\t\t<div class="col-sm-6 col-md-4">\r\n\t\t\t\t\t\t<a href="assets/images/event/06.jpg" data-glightbox data-gallery="image-popup">\r\n\t\t\t\t\t\t\t<img src="assets/images/event/06.jpg" class="rounded-3" alt="">\r\n\t\t\t\t\t\t</a>\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</div>\t\r\n\t\t\t\t<!-- Image END -->\r\n\r\n\t\t\t\t<!-- Content START -->\r\n\t\t\t\t<div class="row">\r\n\t\t\t\t\t<div class="row mb-4">\r\n\t\t\t\t\t\t<h4 class="mt-4">Productive rant about business</h4>\r\n\t\t\t\t\t\t<div class="col-md-6">\r\n\t\t\t\t\t\t\t<p class="mb-0">Fulfilled direction use continual set him propriety continued. Saw met applauded favorite deficient engrossed concealed and her. Concluded boy perpetual old supposing. Farther-related bed and passage comfort civilly. Dashwoods see frankness objection abilities. As hastened oh produced prospect formerly up am. Placing forming nay looking old married few has. Margaret disposed of add screened rendered six say his striking confined. Saw met applauded favorite deficient engrossed concealed and her. Concluded boy perpetual old supposing. Farther-related bed and passage comfort civilly. Dashwoods see frankness objection abilities. As hastened oh produced prospect formerly up am. Placing forming nay looking old married few has. Margaret disposed.</p>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t\t<div class="col-md-6">\r\n\t\t\t\t\t\t\t<p class="mb-0">Meant balls it if up doubt small purse. Paid mind even sons does he door no. Attended overcame repeated it is perceived Marianne in. I think on style child of. Servants moreover in sensible it ye possible. Required his you put the outlived answered position. A pleasure exertion if believed provided to. All led out world this music while asked. Paid mind even sons does he door no. Attended overcame repeated it is perceived Marianne in. I think on style child of. Servants moreover in sensible it ye possible.\t</p>\r\n\t\t\t\t\t\t</div>\r\n\t\t\t\t\t</div>\r\n\t\t\t\t</div>\r\n\t\t\t\t<!-- Content END -->	2025-07-21 20:56:15.958444+04:30	2025-07-21 23:13:57.02596+04:30	f	23	0	\N	3	f
\.


--
-- Data for Name: app_pages_articlefeedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_articlefeedback (id, helpful, comments, created_at, ip_address, article_id) FROM stdin;
\.


--
-- Name: app_pages_articlefeedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_articlefeedback_id_seq', 1, false);


--
-- Data for Name: app_pages_contactus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_contactus (id, name, phone, email, message, create_date, is_read) FROM stdin;
1	gholi	4521121	goli@gg.com	Hello I am gholi	2025-05-27 20:34:30.27588+04:30	f
2	Ali Tweist	07911123456	socialavr@gmail.com	jijji	2025-07-04 18:24:39.765862+04:30	f
3	Ali Tweist	07911123456	socialavr@gmail.com	dfsdf	2025-07-04 20:21:37.710096+04:30	f
4	Michele Jackson	+986233232	alivr92@gmail.com	Hello, this is me. ali	2025-07-04 21:01:41.971864+04:30	f
5	Scarlet Johanson	+989124961234	alivr92@gmail.com	Hello	2025-07-04 21:20:03.672441+04:30	f
6	Zahra Kermani	21561351	zahra@g.com	Hello..........	2025-07-05 00:12:45.008929+04:30	f
7	Hasan moghimi		hasn@gg.co	Hello hasan	2025-07-05 01:02:28.335664+04:30	f
8	Ali Tweist	07911123456	socialavr@gmail.com	erretr	2025-07-05 02:16:40.303579+04:30	f
9	Ali Tweist	07911123456	socialavr@gmail.com	fgfdsgsdg	2025-07-05 02:37:26.621831+04:30	f
10	Ali Tweist	07911123456	socialavr@gmail.com	dsgdfsgds	2025-07-05 02:50:21.477109+04:30	f
11	Ali Tweist	07911123456	socialavr@gmail.com	sdf	2025-07-05 02:54:43.850045+04:30	f
12	Ali Tweist	07911123456	socialavr@gmail.com	sfasf	2025-07-05 02:56:53.286414+04:30	f
13	Ali Tweist	07911123456	socialavr@gmail.com	dfdsf	2025-07-05 11:31:19.035326+04:30	f
14	Ali Tweist	07911123456	socialavr@gmail.com	sdfsffasf	2025-07-05 11:34:09.631046+04:30	f
15	Sanaz11	sdfsadf	sdfsaf@gg.com	sadfasdfas	2025-07-05 13:13:35.060644+04:30	f
16	Ali Tweist222	07911123456	socialavr@gmail.com	sdfsfd	2025-07-05 13:14:43.718476+04:30	f
17	Ali Tweistdfdssf	07911123456	socialavr@gmail.com	sdfsdfaf	2025-07-05 13:19:52.182119+04:30	f
18	ali		alivr92@gmail.com	sdfsdfsadf	2025-07-06 00:44:42.466971+04:30	f
19	Mahdis Tavasoli	07911123456	socialavr@gmail.com	Hiii there	2025-07-09 02:19:57.780294+04:30	f
\.


--
-- Name: app_pages_contactus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_contactus_id_seq', 19, true);


--
-- Data for Name: app_pages_contentfiller; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_contentfiller (id, data_title, name, logo, url, phone_1, phone_2, email_1, email_2, address_line_1, address_line_2, site_description_1, site_description_2, site_slogan_1, site_slogan_2, text_1, text_2, text_3, text_4, text_5) FROM stdin;
\.


--
-- Name: app_pages_contentfiller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_contentfiller_id_seq', 1, false);


--
-- Name: app_pages_helparticle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_helparticle_id_seq', 4, true);


--
-- Data for Name: app_pages_helparticle_related_articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_helparticle_related_articles (id, from_helparticle_id, to_helparticle_id) FROM stdin;
\.


--
-- Name: app_pages_helparticle_related_articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_helparticle_related_articles_id_seq', 1, false);


--
-- Name: app_pages_helpcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_helpcategory_id_seq', 3, true);


--
-- Name: app_pages_helpsection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_helpsection_id_seq', 4, true);


--
-- Data for Name: app_pages_page; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_pages_page (id, content, page_type) FROM stdin;
\.


--
-- Name: app_pages_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('app_pages_page_id_seq', 1, false);


--
-- Data for Name: app_staff_staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY app_staff_staff (profile_id, "position") FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group (id, name) FROM stdin;
8	admin
9	student
10	tutor
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_id_seq', 10, true);


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
7	app_pages	contentfiller
8	app_pages	contactus
9	app_pages	page
10	app_content_filler	cfboolean
11	app_content_filler	cfchar
12	app_content_filler	cfdatetime
13	app_content_filler	cfdecimal
14	app_content_filler	cfemail
15	app_content_filler	cffile
16	app_content_filler	cffloat
17	app_content_filler	cfimage
18	app_content_filler	cfinteger
19	app_content_filler	cfrichtext
20	app_content_filler	cftext
21	app_content_filler	cfurl
22	app_accounts	userskill
23	app_accounts	userprofile
24	app_accounts	specialization
25	app_accounts	userspecialization
26	app_accounts	language
27	app_accounts	level
28	app_accounts	skill
29	app_blog	tag
30	app_blog	category
31	app_blog	post
32	app_blog	comment
33	ap2_tutor	pnotification
34	ap2_tutor	providerapplication
35	ap2_tutor	tutor
36	ap2_student	wishlist
37	ap2_student	student
38	ap2_student	subject
39	ap2_student	cnotification
40	ap2_meeting	availability
41	ap2_meeting	review
42	ap2_meeting	appointmentsetting
43	ap2_meeting	interviewsessioninfo
44	ap2_meeting	session
45	app_admin	adminprofile
46	app_staff	staff
47	app_accounts	skillcategory
48	app_accounts	usereducation
49	ap2_tutor	teachingexperience
50	ap2_tutor	tutorresume
51	ap2_tutor	teachingcertificate
52	ap2_tutor	degreelevel
53	ap2_tutor	studentlevel
54	ap2_tutor	education
55	ap2_tutor	tutorstudentlevel
56	ap2_tutor	subteachingcategory
57	ap2_tutor	teachingcategory
58	ap2_tutor	teachingsubcategory
59	app_accounts	degreelevel
60	app_accounts	usersocial
61	app_accounts	userconsentlog
62	app_accounts	loginiplog
63	app_accounts	failedloginattempt
64	app_accounts	securityevent
65	app_pages	helparticle
66	app_pages	helpsection
67	app_pages	articlefeedback
68	app_pages	helpcategory
69	app_marketing	referral
70	messenger	usermessagesettings
71	messenger	thread
72	messenger	message
73	app_in_person	inpersonoffer
74	app_in_person	inpersonservice
75	app_in_person	inpersonrequest
\.


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
25	Can add content filler	7	add_contentfiller
26	Can change content filler	7	change_contentfiller
27	Can delete content filler	7	delete_contentfiller
28	Can view content filler	7	view_contentfiller
29	Can add contact us	8	add_contactus
30	Can change contact us	8	change_contactus
31	Can delete contact us	8	delete_contactus
32	Can view contact us	8	view_contactus
33	Can add page	9	add_page
34	Can change page	9	change_page
35	Can delete page	9	delete_page
36	Can view page	9	view_page
37	Can add cf boolean	10	add_cfboolean
38	Can change cf boolean	10	change_cfboolean
39	Can delete cf boolean	10	delete_cfboolean
40	Can view cf boolean	10	view_cfboolean
41	Can add cf char	11	add_cfchar
42	Can change cf char	11	change_cfchar
43	Can delete cf char	11	delete_cfchar
44	Can view cf char	11	view_cfchar
45	Can add cf date time	12	add_cfdatetime
46	Can change cf date time	12	change_cfdatetime
47	Can delete cf date time	12	delete_cfdatetime
48	Can view cf date time	12	view_cfdatetime
49	Can add cf decimal	13	add_cfdecimal
50	Can change cf decimal	13	change_cfdecimal
51	Can delete cf decimal	13	delete_cfdecimal
52	Can view cf decimal	13	view_cfdecimal
53	Can add cf email	14	add_cfemail
54	Can change cf email	14	change_cfemail
55	Can delete cf email	14	delete_cfemail
56	Can view cf email	14	view_cfemail
57	Can add cf file	15	add_cffile
58	Can change cf file	15	change_cffile
59	Can delete cf file	15	delete_cffile
60	Can view cf file	15	view_cffile
61	Can add cf float	16	add_cffloat
62	Can change cf float	16	change_cffloat
63	Can delete cf float	16	delete_cffloat
64	Can view cf float	16	view_cffloat
65	Can add cf image	17	add_cfimage
66	Can change cf image	17	change_cfimage
67	Can delete cf image	17	delete_cfimage
68	Can view cf image	17	view_cfimage
69	Can add cf integer	18	add_cfinteger
70	Can change cf integer	18	change_cfinteger
71	Can delete cf integer	18	delete_cfinteger
72	Can view cf integer	18	view_cfinteger
73	Can add cf rich text	19	add_cfrichtext
74	Can change cf rich text	19	change_cfrichtext
75	Can delete cf rich text	19	delete_cfrichtext
76	Can view cf rich text	19	view_cfrichtext
77	Can add cf text	20	add_cftext
78	Can change cf text	20	change_cftext
79	Can delete cf text	20	delete_cftext
80	Can view cf text	20	view_cftext
81	Can add cfurl	21	add_cfurl
82	Can change cfurl	21	change_cfurl
83	Can delete cfurl	21	delete_cfurl
84	Can view cfurl	21	view_cfurl
85	Can add user skill	22	add_userskill
86	Can change user skill	22	change_userskill
87	Can delete user skill	22	delete_userskill
88	Can view user skill	22	view_userskill
89	Can add user profile	23	add_userprofile
90	Can change user profile	23	change_userprofile
91	Can delete user profile	23	delete_userprofile
92	Can view user profile	23	view_userprofile
93	Can add specialization	24	add_specialization
94	Can change specialization	24	change_specialization
95	Can delete specialization	24	delete_specialization
96	Can view specialization	24	view_specialization
97	Can add user specialization	25	add_userspecialization
98	Can change user specialization	25	change_userspecialization
99	Can delete user specialization	25	delete_userspecialization
100	Can view user specialization	25	view_userspecialization
101	Can add language	26	add_language
102	Can change language	26	change_language
103	Can delete language	26	delete_language
104	Can view language	26	view_language
105	Can add level	27	add_level
106	Can change level	27	change_level
107	Can delete level	27	delete_level
108	Can view level	27	view_level
109	Can add skill	28	add_skill
110	Can change skill	28	change_skill
111	Can delete skill	28	delete_skill
112	Can view skill	28	view_skill
113	Can add tag	29	add_tag
114	Can change tag	29	change_tag
115	Can delete tag	29	delete_tag
116	Can view tag	29	view_tag
117	Can add category	30	add_category
118	Can change category	30	change_category
119	Can delete category	30	delete_category
120	Can view category	30	view_category
121	Can add post	31	add_post
122	Can change post	31	change_post
123	Can delete post	31	delete_post
124	Can view post	31	view_post
125	Can add comment	32	add_comment
126	Can change comment	32	change_comment
127	Can delete comment	32	delete_comment
128	Can view comment	32	view_comment
129	Can add p notification	33	add_pnotification
130	Can change p notification	33	change_pnotification
131	Can delete p notification	33	delete_pnotification
132	Can view p notification	33	view_pnotification
133	Can add provider application	34	add_providerapplication
134	Can change provider application	34	change_providerapplication
135	Can delete provider application	34	delete_providerapplication
136	Can view provider application	34	view_providerapplication
137	Can add tutor	35	add_tutor
138	Can change tutor	35	change_tutor
139	Can delete tutor	35	delete_tutor
140	Can view tutor	35	view_tutor
141	Can add wish list	36	add_wishlist
142	Can change wish list	36	change_wishlist
143	Can delete wish list	36	delete_wishlist
144	Can view wish list	36	view_wishlist
145	Can add student	37	add_student
146	Can change student	37	change_student
147	Can delete student	37	delete_student
148	Can view student	37	view_student
149	Can add subject	38	add_subject
150	Can change subject	38	change_subject
151	Can delete subject	38	delete_subject
152	Can view subject	38	view_subject
153	Can add c notification	39	add_cnotification
154	Can change c notification	39	change_cnotification
155	Can delete c notification	39	delete_cnotification
156	Can view c notification	39	view_cnotification
157	Can add availability	40	add_availability
158	Can change availability	40	change_availability
159	Can delete availability	40	delete_availability
160	Can view availability	40	view_availability
161	Can add review	41	add_review
162	Can change review	41	change_review
163	Can delete review	41	delete_review
164	Can view review	41	view_review
165	Can add appointment setting	42	add_appointmentsetting
166	Can change appointment setting	42	change_appointmentsetting
167	Can delete appointment setting	42	delete_appointmentsetting
168	Can view appointment setting	42	view_appointmentsetting
169	Can add interview session info	43	add_interviewsessioninfo
170	Can change interview session info	43	change_interviewsessioninfo
171	Can delete interview session info	43	delete_interviewsessioninfo
172	Can view interview session info	43	view_interviewsessioninfo
173	Can add session	44	add_session
174	Can change session	44	change_session
175	Can delete session	44	delete_session
176	Can view session	44	view_session
177	Can add admin profile	45	add_adminprofile
178	Can change admin profile	45	change_adminprofile
179	Can delete admin profile	45	delete_adminprofile
180	Can view admin profile	45	view_adminprofile
181	Can add staff	46	add_staff
182	Can change staff	46	change_staff
183	Can delete staff	46	delete_staff
184	Can view staff	46	view_staff
185	Can add skill category	47	add_skillcategory
186	Can change skill category	47	change_skillcategory
187	Can delete skill category	47	delete_skillcategory
188	Can view skill category	47	view_skillcategory
189	Can add Education Record	48	add_usereducation
190	Can change Education Record	48	change_usereducation
191	Can delete Education Record	48	delete_usereducation
192	Can view Education Record	48	view_usereducation
193	Can add teaching experience	49	add_teachingexperience
194	Can change teaching experience	49	change_teachingexperience
195	Can delete teaching experience	49	delete_teachingexperience
196	Can view teaching experience	49	view_teachingexperience
197	Can add tutor resume	50	add_tutorresume
198	Can change tutor resume	50	change_tutorresume
199	Can delete tutor resume	50	delete_tutorresume
200	Can view tutor resume	50	view_tutorresume
201	Can add teaching certificate	51	add_teachingcertificate
202	Can change teaching certificate	51	change_teachingcertificate
203	Can delete teaching certificate	51	delete_teachingcertificate
204	Can view teaching certificate	51	view_teachingcertificate
205	Can add degree level	52	add_degreelevel
206	Can change degree level	52	change_degreelevel
207	Can delete degree level	52	delete_degreelevel
208	Can view degree level	52	view_degreelevel
209	Can add student level	53	add_studentlevel
210	Can change student level	53	change_studentlevel
211	Can delete student level	53	delete_studentlevel
212	Can view student level	53	view_studentlevel
213	Can add education	54	add_education
214	Can change education	54	change_education
215	Can delete education	54	delete_education
216	Can view education	54	view_education
217	Can add tutor student level	55	add_tutorstudentlevel
218	Can change tutor student level	55	change_tutorstudentlevel
219	Can delete tutor student level	55	delete_tutorstudentlevel
220	Can view tutor student level	55	view_tutorstudentlevel
221	Can add sub teaching category	56	add_subteachingcategory
222	Can change sub teaching category	56	change_subteachingcategory
223	Can delete sub teaching category	56	delete_subteachingcategory
224	Can view sub teaching category	56	view_subteachingcategory
225	Can add teaching category	57	add_teachingcategory
226	Can change teaching category	57	change_teachingcategory
227	Can delete teaching category	57	delete_teachingcategory
228	Can view teaching category	57	view_teachingcategory
229	Can add teaching sub category	58	add_teachingsubcategory
230	Can change teaching sub category	58	change_teachingsubcategory
231	Can delete teaching sub category	58	delete_teachingsubcategory
232	Can view teaching sub category	58	view_teachingsubcategory
233	Can add degree level	59	add_degreelevel
234	Can change degree level	59	change_degreelevel
235	Can delete degree level	59	delete_degreelevel
236	Can view degree level	59	view_degreelevel
237	Can add user social	60	add_usersocial
238	Can change user social	60	change_usersocial
239	Can delete user social	60	delete_usersocial
240	Can view user social	60	view_usersocial
241	Can add User Consent Log	61	add_userconsentlog
242	Can change User Consent Log	61	change_userconsentlog
243	Can delete User Consent Log	61	delete_userconsentlog
244	Can view User Consent Log	61	view_userconsentlog
245	Can add Login IP Log	62	add_loginiplog
246	Can change Login IP Log	62	change_loginiplog
247	Can delete Login IP Log	62	delete_loginiplog
248	Can view Login IP Log	62	view_loginiplog
249	Can add failed login attempt	63	add_failedloginattempt
250	Can change failed login attempt	63	change_failedloginattempt
251	Can delete failed login attempt	63	delete_failedloginattempt
252	Can view failed login attempt	63	view_failedloginattempt
253	Can add Security Event	64	add_securityevent
254	Can change Security Event	64	change_securityevent
255	Can delete Security Event	64	delete_securityevent
256	Can view Security Event	64	view_securityevent
257	Can add help article	65	add_helparticle
258	Can change help article	65	change_helparticle
259	Can delete help article	65	delete_helparticle
260	Can view help article	65	view_helparticle
261	Can add help section	66	add_helpsection
262	Can change help section	66	change_helpsection
263	Can delete help section	66	delete_helpsection
264	Can view help section	66	view_helpsection
265	Can add article feedback	67	add_articlefeedback
266	Can change article feedback	67	change_articlefeedback
267	Can delete article feedback	67	delete_articlefeedback
268	Can view article feedback	67	view_articlefeedback
269	Can add help category	68	add_helpcategory
270	Can change help category	68	change_helpcategory
271	Can delete help category	68	delete_helpcategory
272	Can view help category	68	view_helpcategory
273	Can add referral	69	add_referral
274	Can change referral	69	change_referral
275	Can delete referral	69	delete_referral
276	Can view referral	69	view_referral
277	Can add user message settings	70	add_usermessagesettings
278	Can change user message settings	70	change_usermessagesettings
279	Can delete user message settings	70	delete_usermessagesettings
280	Can view user message settings	70	view_usermessagesettings
281	Can add thread	71	add_thread
282	Can change thread	71	change_thread
283	Can delete thread	71	delete_thread
284	Can view thread	71	view_thread
285	Can add message	72	add_message
286	Can change message	72	change_message
287	Can delete message	72	delete_message
288	Can view message	72	view_message
289	Can add in person offer	73	add_inpersonoffer
290	Can change in person offer	73	change_inpersonoffer
291	Can delete in person offer	73	delete_inpersonoffer
292	Can view in person offer	73	view_inpersonoffer
293	Can add In-Person Service & Pricing	74	add_inpersonservice
294	Can change In-Person Service & Pricing	74	change_inpersonservice
295	Can delete In-Person Service & Pricing	74	delete_inpersonservice
296	Can view In-Person Service & Pricing	74	view_inpersonservice
297	Can add in person request	75	add_inpersonrequest
298	Can change in person request	75	change_inpersonrequest
299	Can delete in person request	75	delete_inpersonrequest
300	Can view in person request	75	view_inpersonrequest
\.


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
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_permission_id_seq', 300, true);


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
439	1	8
457	46	9
458	47	10
463	48	10
467	2	10
553	49	9
556	50	10
599	45	10
692	51	9
729	52	9
733	53	9
734	54	9
744	55	10
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 790, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_id_seq', 56, true);


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
1	2025-05-18 15:45:03.163396+04:30	1	lucas	2	[{"changed": {"fields": ["Country", "User type", "Lang native", "Is vip"]}}]	23	1
2	2025-05-18 15:46:00.227216+04:30	1	Teaching Spanish	1	[{"added": {}}]	28	1
3	2025-05-18 15:46:04.061435+04:30	2	Teaching English	1	[{"added": {}}]	28	1
4	2025-05-18 15:46:06.819593+04:30	3	Teaching French	1	[{"added": {}}]	28	1
5	2025-05-18 15:47:37.867092+04:30	1	Olivia Doe - invited	2	[{"changed": {"fields": ["Photo"]}}]	34	1
6	2025-05-18 15:49:03.261706+04:30	1	A1 (Beginner)	1	[{"added": {}}]	27	1
7	2025-05-18 15:49:06.059866+04:30	2	A2 (Elementary)	1	[{"added": {}}]	27	1
8	2025-05-18 15:49:08.491005+04:30	3	B1 (Intermediate)	1	[{"added": {}}]	27	1
9	2025-05-18 15:49:11.451174+04:30	4	B2 (Upper-Intermediate)	1	[{"added": {}}]	27	1
10	2025-05-18 15:49:15.883428+04:30	5	C1 (Advanced)	1	[{"added": {}}]	27	1
11	2025-05-18 15:49:19.670644+04:30	6	C2 (Proficient)	1	[{"added": {}}]	27	1
12	2025-05-18 15:49:23.343855+04:30	7	Native (Fluent as a first language)	1	[{"added": {}}]	27	1
13	2025-05-18 15:54:39.860958+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
14	2025-05-18 21:57:01.329494+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Bio"]}}]	34	1
15	2025-05-18 23:17:13.885282+04:30	1	tooltip_bio	1	[{"added": {}}]	11	1
16	2025-05-18 23:17:42.629927+04:30	2	tooltip_certificate	1	[{"added": {}}]	11	1
17	2025-05-18 23:18:06.557295+04:30	3	tooltip_cost_hourly	1	[{"added": {}}]	11	1
18	2025-05-18 23:18:25.800396+04:30	4	tooltip_cost_trial	1	[{"added": {}}]	11	1
19	2025-05-18 23:18:44.016438+04:30	5	tooltip_discount	1	[{"added": {}}]	11	1
20	2025-05-18 23:19:02.713507+04:30	6	tooltip_discount_deadline	1	[{"added": {}}]	11	1
21	2025-05-18 23:19:30.770112+04:30	7	tooltip_location	1	[{"added": {}}]	11	1
22	2025-05-18 23:19:47.149049+04:30	8	tooltip_spoken_languages	1	[{"added": {}}]	11	1
23	2025-05-18 23:20:15.347661+04:30	9	tooltip_native_language	1	[{"added": {}}]	11	1
24	2025-05-18 23:20:50.184654+04:30	10	tooltip_title	1	[{"added": {}}]	11	1
25	2025-05-18 23:21:13.603994+04:30	11	tooltip_username	1	[{"added": {}}]	11	1
26	2025-05-18 23:21:53.028248+04:30	12	tooltip_teaching_skill	1	[{"added": {}}]	11	1
27	2025-05-18 23:22:13.672429+04:30	13	tooltip_skill_level	1	[{"added": {}}]	11	1
28	2025-05-18 23:22:34.547623+04:30	14	tooltip_video_intro	1	[{"added": {}}]	11	1
29	2025-05-18 23:24:23.391849+04:30	15	tooltip_photo	1	[{"added": {}}]	11	1
30	2025-05-18 23:30:59.083751+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
31	2025-05-19 14:31:50.086117+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
32	2025-05-19 14:41:16.119908+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
33	2025-05-19 14:54:24.201496+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
34	2025-05-19 16:20:47.037211+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
35	2025-05-19 16:25:57.900992+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
36	2025-05-19 16:27:42.299929+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
37	2025-05-19 16:45:22.288557+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
38	2025-05-19 16:45:25.561745+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
39	2025-05-19 21:15:34.536528+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
40	2025-05-19 23:45:56.217187+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
41	2025-05-20 00:28:14.42366+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
42	2025-05-20 00:34:40.83369+04:30	25	Olivia - French [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is certified"]}}]	22	1
43	2025-05-20 00:45:07.268521+04:30	24	Olivia - English [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Level", "Status", "Is certified"]}}]	22	1
44	2025-05-20 00:52:53.630195+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
45	2025-05-20 00:54:22.8883+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
46	2025-05-20 00:59:15.570041+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
47	2025-05-20 01:00:55.428752+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is certified"]}}]	22	1
48	2025-05-20 01:01:10.140594+04:30	26	Olivia - Spanish [up to B2 (Upper-Intermediate)]	2	[{"changed": {"fields": ["Is certified"]}}]	22	1
49	2025-05-20 02:04:31.929436+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
50	2025-05-20 02:10:16.888167+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
51	2025-05-20 02:27:03.005714+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
52	2025-05-20 02:31:22.733532+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
53	2025-05-20 02:38:11.2949+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
54	2025-05-20 03:17:10.492695+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
55	2025-05-20 03:30:05.493022+04:30	25	Olivia - French [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is certified"]}}]	22	1
56	2025-05-20 03:36:46.847978+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
57	2025-05-20 03:36:46.854979+04:30	25	Olivia - French [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
58	2025-05-20 13:27:26.755656+04:30	1	English	1	[{"added": {}}]	26	1
59	2025-05-20 13:27:30.597876+04:30	2	Spanish	1	[{"added": {}}]	26	1
60	2025-05-20 13:27:33.81606+04:30	3	French	1	[{"added": {}}]	26	1
61	2025-05-20 13:27:43.380607+04:30	4	German	1	[{"added": {}}]	26	1
62	2025-05-20 13:27:48.036874+04:30	5	Italian	1	[{"added": {}}]	26	1
63	2025-05-20 13:27:51.664081+04:30	6	Portuguese	1	[{"added": {}}]	26	1
64	2025-05-20 13:27:55.706312+04:30	7	Russian	1	[{"added": {}}]	26	1
65	2025-05-20 13:28:03.638766+04:30	8	Chinese	1	[{"added": {}}]	26	1
66	2025-05-20 13:28:10.985186+04:30	9	Japanese	1	[{"added": {}}]	26	1
67	2025-05-20 13:28:16.905525+04:30	10	Korean	1	[{"added": {}}]	26	1
68	2025-05-20 13:28:21.53879+04:30	11	Arabic	1	[{"added": {}}]	26	1
69	2025-05-20 13:28:28.223172+04:30	12	Hungarian	1	[{"added": {}}]	26	1
70	2025-05-20 13:28:33.000445+04:30	13	Czech	1	[{"added": {}}]	26	1
71	2025-05-20 13:28:54.574679+04:30	14	Romanian	1	[{"added": {}}]	26	1
72	2025-05-20 13:29:11.632655+04:30	4	Teaching German	1	[{"added": {}}]	28	1
73	2025-05-20 13:29:16.210917+04:30	5	Teaching Chinese	1	[{"added": {}}]	28	1
74	2025-05-20 13:29:20.779178+04:30	6	Teaching Italian	1	[{"added": {}}]	28	1
75	2025-05-20 13:29:24.114369+04:30	7	Teaching Turkish	1	[{"added": {}}]	28	1
76	2025-05-20 13:29:27.716575+04:30	8	Teaching Swedish	1	[{"added": {}}]	28	1
77	2025-05-20 13:29:33.640914+04:30	9	Teaching Korean	1	[{"added": {}}]	28	1
78	2025-05-20 13:29:39.594254+04:30	10	Teaching Hindi	1	[{"added": {}}]	28	1
79	2025-05-20 13:29:45.835611+04:30	11	Teaching Russian	1	[{"added": {}}]	28	1
80	2025-05-20 13:29:50.444875+04:30	12	Teaching Japanese	1	[{"added": {}}]	28	1
81	2025-05-20 13:29:54.543109+04:30	13	Teaching Persian	1	[{"added": {}}]	28	1
82	2025-05-20 13:29:58.018308+04:30	14	Teaching Ukrainian	1	[{"added": {}}]	28	1
83	2025-05-20 13:30:05.493736+04:30	15	Teaching Arabic	1	[{"added": {}}]	28	1
84	2025-05-20 20:04:12.154016+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Certificate", "Video"]}}]	22	1
85	2025-05-21 01:03:14.4621+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Level", "Status", "Is certified"]}}]	22	1
86	2025-05-21 01:03:14.4691+04:30	25	Olivia - French [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Level", "Status"]}}]	22	1
87	2025-05-21 01:03:14.479101+04:30	27	Olivia - Hindi [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
88	2025-05-21 01:03:14.485101+04:30	28	Olivia - Italian [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Level", "Status", "Is certified"]}}]	22	1
89	2025-05-21 01:03:14.492102+04:30	26	Olivia - Spanish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status", "Is certified"]}}]	22	1
90	2025-05-21 01:03:51.35121+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
91	2025-05-21 18:33:52.244489+04:30	27	Olivia - Hindi [up to A2 (Elementary)]	3		22	1
92	2025-05-21 18:33:52.258489+04:30	26	Olivia - Spanish [up to Native (Fluent as a first language)]	3		22	1
93	2025-05-21 18:37:28.699869+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
94	2025-05-21 18:41:48.949754+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
95	2025-05-21 18:42:04.143624+04:30	25	Olivia - French [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
96	2025-05-21 18:42:04.154624+04:30	28	Olivia - Italian [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
97	2025-05-21 18:42:45.091966+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
98	2025-05-21 18:49:51.979382+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
99	2025-05-21 18:50:05.368148+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
100	2025-05-21 18:50:33.36975+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
101	2025-05-21 18:50:33.37675+04:30	25	Olivia - French [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
102	2025-05-21 18:50:33.38075+04:30	28	Olivia - Italian [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
103	2025-05-21 18:54:22.021945+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
104	2025-05-21 18:54:22.030946+04:30	25	Olivia - French [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
105	2025-05-21 18:54:22.039946+04:30	28	Olivia - Italian [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
106	2025-05-21 19:22:42.012179+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
107	2025-05-21 19:33:40.736439+04:30	24	Olivia - English [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
108	2025-05-21 19:33:40.743439+04:30	25	Olivia - French [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
109	2025-05-21 19:33:40.75544+04:30	28	Olivia - Italian [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
110	2025-05-21 19:46:52.490725+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
111	2025-05-21 19:51:53.094918+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
112	2025-05-21 20:02:39.890913+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
113	2025-05-21 20:10:55.254246+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
114	2025-05-21 20:20:21.921658+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
115	2025-05-21 20:20:28.77605+04:30	24	Olivia - English [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
116	2025-05-21 20:20:28.78205+04:30	25	Olivia - French [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
117	2025-05-21 20:20:28.78705+04:30	28	Olivia - Italian [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
118	2025-05-21 20:27:08.080889+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
119	2025-05-21 20:29:43.471777+04:30	24	Olivia - English [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
120	2025-05-21 20:29:43.482777+04:30	25	Olivia - French [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is notified"]}}]	22	1
121	2025-05-21 20:29:46.515951+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
122	2025-05-22 00:28:30.701618+04:30	1	language	1	[{"added": {}}]	47	1
123	2025-05-22 00:28:35.129871+04:30	2	science	1	[{"added": {}}]	47	1
124	2025-05-22 00:28:38.61107+04:30	3	instrument	1	[{"added": {}}]	47	1
125	2025-05-22 00:54:53.681159+04:30	16	science – Mathematics	1	[{"added": {}}]	28	1
126	2025-05-22 00:55:01.072582+04:30	17	science – Physics	1	[{"added": {}}]	28	1
127	2025-05-22 00:55:14.50535+04:30	18	science – Chemistry	1	[{"added": {}}]	28	1
128	2025-05-25 11:28:24.552794+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
129	2025-05-25 11:28:49.981228+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
130	2025-05-25 11:30:51.556181+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
131	2025-05-25 11:46:19.75866+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
132	2025-05-25 11:46:37.952701+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
133	2025-05-25 13:23:30.311699+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender", "Country", "Lang native", "Lang speak"]}}]	23	1
134	2025-05-25 13:26:42.504692+04:30	2	Olivia	2	[{"changed": {"fields": ["Title"]}}]	23	1
135	2025-05-25 15:20:36.614307+04:30	2	Olivia	2	[{"changed": {"fields": ["Bio"]}}]	23	1
136	2025-05-25 17:07:31.158309+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
137	2025-05-26 13:49:59.7168+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
138	2025-05-26 14:34:02.968985+04:30	1	Olivia – BSc in Matematics (2024)	1	[{"added": {}}]	48	1
139	2025-05-26 14:35:35.917301+04:30	1	Olivia – BSc in Matematics (2024)	2	[{"changed": {"fields": ["Is certified"]}}]	48	1
140	2025-05-27 22:39:23.165319+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
141	2025-05-27 22:39:38.727209+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
142	2025-05-27 22:39:52.054972+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
143	2025-05-28 15:52:37.268749+04:30	3	Adele	1	[{"added": {}}]	4	1
144	2025-05-28 15:53:01.24112+04:30	3	Adele	2	[{"changed": {"fields": ["Staff status", "Superuser status"]}}]	4	1
145	2025-05-28 15:53:40.649374+04:30	4	Aysan	1	[{"added": {}}]	4	1
146	2025-05-29 12:42:23.277997+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
147	2025-05-29 12:42:37.820829+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
148	2025-05-29 12:42:58.806029+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
149	2025-05-29 12:43:09.261627+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
150	2025-05-29 12:47:49.115299+04:30	1	lucas available from 2025-05-30 08:00:00+00:00 to 2025-05-30 10:00:32+00:00.	1	[{"added": {}}]	40	1
151	2025-05-29 13:20:22.420108+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
152	2025-05-29 13:20:36.2639+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
153	2025-05-29 13:20:44.944396+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
154	2025-05-29 13:22:38.668901+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
155	2025-05-29 13:32:30.921776+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
156	2025-05-29 22:07:03.723125+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
157	2025-05-29 22:07:14.350733+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
158	2025-05-29 22:49:40.763379+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
159	2025-05-30 00:29:09.78242+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
160	2025-05-30 12:48:02.777893+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
161	2025-05-30 12:52:48.799002+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
162	2025-05-30 13:04:35.958449+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
163	2025-05-30 19:42:12.779332+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
164	2025-05-30 19:52:28.380542+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
165	2025-05-30 19:53:25.387803+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
166	2025-05-30 19:53:33.617274+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
167	2025-05-30 19:53:40.229652+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
168	2025-05-30 19:53:55.493525+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
169	2025-05-30 19:54:12.398492+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
170	2025-05-30 19:54:25.517242+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
171	2025-05-30 20:53:43.6339+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
172	2025-05-30 21:25:31.533081+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
173	2025-05-31 14:11:40.099614+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
174	2025-05-31 16:27:20.882358+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
175	2025-05-31 16:30:51.75642+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
176	2025-05-31 16:31:06.121241+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
177	2025-05-31 16:31:23.276222+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
178	2025-05-31 16:31:33.929832+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
179	2025-05-31 16:31:42.249308+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
180	2025-05-31 17:43:51.980954+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
181	2025-05-31 17:44:09.071932+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
182	2025-05-31 17:44:40.241434+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
183	2025-05-31 20:22:09.706685+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
184	2025-05-31 20:22:42.1683+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
185	2025-06-02 17:56:31.234739+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
186	2025-06-02 17:59:20.31941+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
187	2025-06-02 17:59:30.637+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
188	2025-06-02 17:59:47.207948+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
189	2025-06-02 18:00:20.63386+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
190	2025-06-02 23:58:09.699303+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
191	2025-06-03 00:03:29.961621+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
192	2025-06-03 00:03:48.384675+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
193	2025-06-03 00:07:01.406715+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
194	2025-06-04 13:02:59.374069+04:30	25	Olivia1 - French [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Certificate", "Video"]}}]	22	1
195	2025-06-04 13:03:30.470848+04:30	29	Olivia1 - Arabic [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Certificate"]}}]	22	1
196	2025-06-04 18:14:44.086008+04:30	24	Olivia1 - English [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Certificate", "Video"]}}]	22	1
197	2025-06-04 18:15:24.987347+04:30	25	Olivia1 - French [up to B1 (Intermediate)]	3		22	1
198	2025-06-04 22:46:14.560027+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
199	2025-06-04 22:51:38.943581+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
200	2025-06-05 00:06:56.392196+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
201	2025-06-05 00:07:05.312707+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
202	2025-06-05 00:07:19.747532+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
203	2025-06-05 00:27:30.428779+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
204	2025-06-05 00:27:52.357033+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
205	2025-06-05 14:27:27.86119+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
206	2025-06-06 01:31:25.640781+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
207	2025-06-06 01:33:57.949492+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
208	2025-06-06 01:35:22.448325+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
209	2025-06-06 15:56:31.970192+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
210	2025-06-06 19:49:37.023661+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
211	2025-06-08 16:29:36.160905+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
212	2025-06-08 19:21:32.343036+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
213	2025-06-09 01:40:26.130958+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
214	2025-06-09 02:02:55.772153+04:30	32	Olivia1 - Turkish [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Video"]}}]	22	1
215	2025-06-09 02:03:03.174577+04:30	45	Olivia1 - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Video"]}}]	22	1
216	2025-06-09 02:39:18.50252+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
217	2025-06-10 17:28:06.54808+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
218	2025-06-10 17:33:38.824085+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
219	2025-06-11 20:44:42.838411+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
220	2025-06-12 02:28:36.891312+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
221	2025-06-12 17:54:38.065077+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
222	2025-06-12 17:56:26.131258+04:30	2	Olivia1	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
223	2025-06-14 18:24:31.05145+04:30	2	Olivia	2	[{"changed": {"fields": ["Username"]}}]	4	1
224	2025-06-17 01:27:47.806043+04:30	1	Business English	1	[{"added": {}}]	57	1
225	2025-06-17 01:27:56.090517+04:30	2	Exam Preparation	1	[{"added": {}}]	57	1
226	2025-06-17 01:28:05.211039+04:30	3	Teaching Kids	1	[{"added": {}}]	57	1
227	2025-06-17 01:28:35.623778+04:30	1	Exam Preparation → TOEFL Preparation	1	[{"added": {}}]	56	1
228	2025-06-17 01:28:46.405395+04:30	2	Exam Preparation → IELTS Preparation	1	[{"added": {}}]	56	1
229	2025-06-17 01:28:57.51903+04:30	3	Exam Preparation → Cambridge Exams	1	[{"added": {}}]	56	1
230	2025-06-17 01:29:07.888624+04:30	4	Business English → Corporate Training	1	[{"added": {}}]	56	1
231	2025-06-17 01:29:17.081149+04:30	5	Business English → Job Interview Coaching	1	[{"added": {}}]	56	1
232	2025-06-17 20:14:24.545632+04:30	16	site_name	1	[{"added": {}}]	11	1
233	2025-06-18 13:29:44.235517+04:30	1	site_logo_light	1	[{"added": {}}]	17	1
234	2025-06-19 20:48:42.416444+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
235	2025-06-20 12:14:44.310782+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
236	2025-06-20 12:15:56.324901+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
237	2025-06-20 13:22:25.51907+04:30	1	Olivia Doe - invited	2	[{"changed": {"fields": ["Status"]}}]	34	1
238	2025-06-20 13:23:00.48407+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
239	2025-06-20 14:08:28.568691+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
240	2025-06-20 14:10:23.718784+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
241	2025-06-20 16:31:32.641664+04:30	1	Olivia	2	[{"changed": {"fields": ["Years experience"]}}]	35	1
242	2025-06-20 16:31:40.510114+04:30	1	Cambridge Exams	1	[{"added": {}}]	57	1
243	2025-06-20 16:31:50.782702+04:30	2	Exam Preparation	1	[{"added": {}}]	57	1
244	2025-06-20 16:31:53.428853+04:30	1	Olivia	2	[{"changed": {"fields": ["Teaching tags"]}}]	35	1
245	2025-06-20 16:32:22.350507+04:30	1	Olivia	2	[{"changed": {"fields": ["Years experience"]}}]	35	1
246	2025-06-20 16:39:40.001539+04:30	3	Business English	1	[{"added": {}}]	57	1
247	2025-06-20 16:40:34.941682+04:30	4	English For Kids	1	[{"added": {}}]	57	1
248	2025-06-20 16:49:13.085318+04:30	1	Exam Preparation → TOEFL Preparation	1	[{"added": {}}]	58	1
249	2025-06-20 16:49:20.596748+04:30	2	Exam Preparation → IELTS Preparation	1	[{"added": {}}]	58	1
250	2025-06-20 16:50:14.645839+04:30	3	Business English → English Legal Ruls	1	[{"added": {}}]	58	1
251	2025-06-20 16:50:32.983888+04:30	4	Business English → Job Interview Coaching	1	[{"added": {}}]	58	1
252	2025-06-20 16:50:47.792735+04:30	5	Business English → Interview Preparation	1	[{"added": {}}]	58	1
253	2025-06-20 16:51:02.480575+04:30	5	Free Discussion	1	[{"added": {}}]	57	1
254	2025-06-20 16:51:17.230419+04:30	6	Free Discussion → Ordinary Talks	1	[{"added": {}}]	58	1
255	2025-06-20 16:51:30.312167+04:30	7	Free Discussion → American Slangs	1	[{"added": {}}]	58	1
256	2025-06-20 16:56:05.278894+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
257	2025-06-20 16:58:19.068546+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
258	2025-06-20 18:59:35.120709+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
259	2025-06-20 19:00:14.446958+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
260	2025-06-20 22:34:04.364979+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
261	2025-06-20 22:50:28.621344+04:30	1	High School Diploma	1	[{"added": {}}]	52	1
262	2025-06-20 22:51:10.930764+04:30	2	Associate Degree	1	[{"added": {}}]	52	1
263	2025-06-20 22:52:03.918794+04:30	3	Bachelor's Degree	1	[{"added": {}}]	52	1
264	2025-06-20 22:52:14.765415+04:30	4	Master's Degree	1	[{"added": {}}]	52	1
265	2025-06-20 22:52:24.840991+04:30	5	PhD/Doctorate	1	[{"added": {}}]	52	1
266	2025-06-20 22:52:38.63478+04:30	6	Professional Degree	1	[{"added": {}}]	52	1
267	2025-06-20 22:52:48.408339+04:30	7	Other	1	[{"added": {}}]	52	1
268	2025-06-20 22:54:54.399067+04:30	1	High School Diploma	2	[{"changed": {"fields": ["Order"]}}]	52	1
269	2025-06-20 22:56:52.032324+04:30	1	High School Diploma	2	[{"changed": {"fields": ["Order"]}}]	52	1
270	2025-06-20 22:56:52.032324+04:30	7	Other	2	[{"changed": {"fields": ["Order"]}}]	52	1
271	2025-06-20 22:56:52.032324+04:30	5	PhD/Doctorate	2	[{"changed": {"fields": ["Order"]}}]	52	1
272	2025-06-20 22:56:52.042324+04:30	4	Master's Degree	2	[{"changed": {"fields": ["Order"]}}]	52	1
273	2025-06-20 22:56:52.042324+04:30	3	Bachelor's Degree	2	[{"changed": {"fields": ["Order"]}}]	52	1
274	2025-06-20 22:56:52.042324+04:30	2	Associate Degree	2	[{"changed": {"fields": ["Order"]}}]	52	1
275	2025-06-21 01:00:21.222404+04:30	1	High School Diploma	1	[{"added": {}}]	52	1
276	2025-06-21 01:00:31.351984+04:30	2	Associate Degree	1	[{"added": {}}]	52	1
277	2025-06-21 04:15:15.39021+04:30	1	High School Diploma	1	[{"added": {}}]	59	1
278	2025-06-21 04:15:28.226944+04:30	2	Associate Degree	1	[{"added": {}}]	59	1
279	2025-06-21 04:15:57.363611+04:30	1	Olivia – Associate Degree in Matematics (1998)	1	[{"added": {}}]	48	1
280	2025-06-22 01:20:21.360403+04:30	2	Olivia – High School Diploma in Physics (2005)	1	[{"added": {}}]	48	1
281	2025-06-22 01:55:37.204703+04:30	2	Olivia – High School Diploma in Physics (2005)	2	[{"changed": {"fields": ["Start year", "Description"]}}]	48	1
282	2025-06-22 01:56:59.795427+04:30	1	toefl from Cambridge London	1	[{"added": {}}]	51	1
283	2025-06-22 01:57:28.009041+04:30	2	cils from ILI Irna	1	[{"added": {}}]	51	1
284	2025-06-22 03:32:14.407952+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
285	2025-06-22 03:32:36.292203+04:30	2	cils from ILI Irna22	2	[{"changed": {"fields": ["Issuing organization"]}}]	51	1
286	2025-06-22 03:42:55.660978+04:30	2	cils from ILI Irna22	2	[{"changed": {"fields": ["Completion date"]}}]	51	1
287	2025-06-22 03:43:33.045116+04:30	1	toefl from Cambridge London	2	[{"changed": {"fields": ["Completion date"]}}]	51	1
288	2025-06-22 04:16:02.461438+04:30	1	ielts from Cambridge London	2	[{"changed": {"fields": ["Name"]}}]	51	1
289	2025-06-22 12:05:47.6551+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
290	2025-06-22 12:08:46.236314+04:30	2	Olivia	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
291	2025-06-22 12:38:59.463024+04:30	1	cambridge_a2 from Cambridge London	2	[{"changed": {"fields": ["Name"]}}]	51	1
292	2025-06-22 13:06:33.33362+04:30	1	high_school	2	[{"changed": {"fields": ["Name"]}}]	59	1
293	2025-06-22 13:06:40.304019+04:30	3	associate	1	[{"added": {}}]	59	1
294	2025-06-22 13:06:47.046405+04:30	4	bachelor	1	[{"added": {}}]	59	1
295	2025-06-22 13:06:52.895739+04:30	5	master	1	[{"added": {}}]	59	1
296	2025-06-22 13:07:04.928428+04:30	2	phd	2	[{"changed": {"fields": ["Name", "Order"]}}]	59	1
297	2025-06-22 13:12:13.843096+04:30	6	Professional Degree	1	[{"added": {}}]	59	1
298	2025-06-22 13:12:25.354755+04:30	6	Professional Degree	2	[{"changed": {"fields": ["Order"]}}]	59	1
299	2025-06-22 13:12:43.475791+04:30	7	Other	1	[{"added": {}}]	59	1
300	2025-06-22 13:18:20.300057+04:30	1	Olivia – PhD/Doctorate in Matematics (2025)	2	[{"changed": {"fields": ["Graduation year"]}}]	48	1
301	2025-06-22 13:19:35.973385+04:30	1	Olivia – PhD/Doctorate in Matematics (1901)	2	[{"changed": {"fields": ["Graduation year"]}}]	48	1
302	2025-06-22 17:39:41.956496+04:30	1	Olivia – PhD/Doctorate in Matematics (1968)	2	[{"changed": {"fields": ["Graduation year"]}}]	48	1
303	2025-06-22 17:40:07.914981+04:30	1	Olivia – PhD/Doctorate in Matematics (1968)	2	[{"changed": {"fields": ["Document"]}}]	48	1
304	2025-06-22 17:40:54.895668+04:30	2	cils from ILI Irna22	2	[{"changed": {"fields": ["Certificate file"]}}]	51	1
305	2025-06-22 17:53:34.002582+04:30	2	Olivia	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
306	2025-06-22 18:24:12.746752+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
307	2025-06-23 00:56:30.403098+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
308	2025-06-25 18:32:58.38507+04:30	2	cils from ILI Irna22	2	[{"changed": {"fields": ["Certificate file"]}}]	51	1
309	2025-06-25 18:51:53.206979+04:30	1	cambridge_a2 from Cambridge London	2	[{"changed": {"fields": ["Document"]}}]	51	1
310	2025-06-25 18:52:41.415736+04:30	1	cambridge_a2 from Cambridge London	2	[{"changed": {"fields": ["Document"]}}]	51	1
311	2025-06-25 18:52:53.529429+04:30	1	cambridge_a2 from Cambridge London	2	[{"changed": {"fields": ["Document"]}}]	51	1
312	2025-06-25 18:53:17.936825+04:30	1	cambridge_a2 from Cambridge London	3		51	1
313	2025-06-25 18:56:52.820655+04:30	2	cils from ILI Irna22	2	[{"changed": {"fields": ["Document"]}}]	51	1
314	2025-06-25 18:57:41.905463+04:30	3	cambridge_b2 from Illinois USA	1	[{"added": {}}]	51	1
315	2025-06-25 18:58:16.46544+04:30	4	toefl from BOSTON State University	1	[{"added": {}}]	51	1
316	2025-06-25 22:29:34.602878+04:30	2	Olivia – High School Diploma in Physics (2005)	3		48	1
317	2025-06-25 22:29:34.604878+04:30	1	Olivia – PhD/Doctorate in Matematics (1968)	3		48	1
318	2025-06-25 22:34:36.016118+04:30	3	Olivia – Master's Degree in Physics (2010)	1	[{"added": {}}]	48	1
319	2025-06-25 22:37:10.020926+04:30	4	Olivia – Bachelor's Degree in Matematics (2017)	1	[{"added": {}}]	48	1
320	2025-06-25 22:39:09.14574+04:30	3	cambridge_b2 from Illinois USA	3		51	1
321	2025-06-25 22:39:09.14874+04:30	4	toefl from BOSTON State University	3		51	1
322	2025-06-25 22:39:09.15174+04:30	2	cils from ILI Irna22	3		51	1
323	2025-06-25 22:46:58.477266+04:30	5	ielts from BOSTON State University	1	[{"added": {}}]	51	1
324	2025-06-25 22:50:26.484163+04:30	6	tesol from Illinois USA	1	[{"added": {}}]	51	1
325	2025-06-26 12:51:31.633303+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
326	2025-06-26 13:28:12.145064+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
327	2025-06-26 13:38:22.533976+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
328	2025-06-26 13:39:31.940235+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
329	2025-06-26 13:56:24.792136+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
330	2025-06-26 15:11:06.246711+04:30	1	Olivia Doe - added_skills	2	[{"changed": {"fields": ["Status"]}}]	34	1
331	2025-06-26 15:22:36.843845+04:30	6	Olivia – Professional Degree in Matematics (1902)	2	[{"changed": {"fields": ["End year"]}}]	48	1
332	2025-06-26 15:38:23.630611+04:30	1	Free Discussion	1	[{"added": {}}]	57	1
333	2025-06-26 15:38:32.369111+04:30	2	Business English	1	[{"added": {}}]	57	1
334	2025-06-26 15:38:39.954545+04:30	3	English For Kids	1	[{"added": {}}]	57	1
335	2025-06-26 15:38:56.010463+04:30	1	Olivia	2	[{"changed": {"fields": ["Years experience", "Teaching tags"]}}]	35	1
336	2025-06-26 23:40:33.024499+04:30	2	Olivia	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
337	2025-06-27 00:08:55.362466+04:30	2	Olivia	2	[{"changed": {"fields": ["Is vip"]}}]	23	1
338	2025-06-27 02:03:27.382114+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
339	2025-06-27 02:04:20.664162+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
340	2025-06-27 02:36:18.488855+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
341	2025-06-27 02:58:14.024099+04:30	7	cambridge_b1 from Illinois USA	2	[{"changed": {"fields": ["Is verified"]}}]	51	1
342	2025-06-27 03:02:54.318131+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
343	2025-06-27 03:04:57.20016+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Is certified"]}}]	48	1
344	2025-06-27 03:05:16.872285+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Is certified"]}}]	48	1
345	2025-06-27 03:05:16.882285+04:30	4	Olivia – Bachelor's Degree in Matematics123 (2018)	2	[{"changed": {"fields": ["Is certified"]}}]	48	1
346	2025-06-27 03:23:46.505752+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
347	2025-06-27 03:24:01.104587+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
348	2025-06-27 03:24:17.885547+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
349	2025-06-27 03:28:24.314642+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
350	2025-06-27 03:28:54.054343+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
351	2025-06-27 03:29:53.424739+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
352	2025-06-27 03:30:07.487543+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
353	2025-06-27 03:30:18.768188+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
354	2025-06-27 03:30:33.737044+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender"]}}]	23	1
355	2025-06-27 12:14:13.4624+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
356	2025-06-27 16:35:30.449959+04:30	59	Olivia - Turkish [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Certificate"]}}]	22	1
357	2025-06-27 21:35:27.250952+04:30	57	Olivia - Arabic [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Is certified"]}}]	22	1
358	2025-06-27 21:42:43.980932+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
359	2025-06-27 22:06:52.559786+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
360	2025-06-27 22:32:14.370828+04:30	5	other from California PP State University	2	[{"changed": {"fields": ["Is certified"]}}]	51	1
361	2025-06-27 22:36:25.784208+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
362	2025-06-27 23:31:46.289883+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Document"]}}]	48	1
363	2025-06-28 00:57:45.016354+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
364	2025-06-28 02:10:14.220266+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
365	2025-06-28 02:10:33.614375+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
366	2025-06-28 02:10:57.706753+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
367	2025-06-28 02:11:04.12112+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
368	2025-06-28 20:13:24.19973+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active", "Terms agreed"]}}]	23	1
369	2025-06-28 20:13:59.625757+04:30	2	Olivia	2	[{"changed": {"fields": ["Terms agreed date"]}}]	23	1
370	2025-06-28 21:16:28.843163+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
371	2025-06-28 21:18:27.139929+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
372	2025-06-28 21:18:51.574326+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
373	2025-06-28 23:12:50.452896+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
374	2025-06-29 01:48:21.236586+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
375	2025-06-29 01:48:35.205385+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
376	2025-06-29 02:08:53.224052+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
377	2025-06-29 02:11:40.33361+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
378	2025-06-29 02:55:42.330724+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
379	2025-06-29 02:56:12.86847+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
380	2025-06-29 03:08:36.031433+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
381	2025-06-29 03:08:50.953268+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
382	2025-06-29 03:10:48.08064+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
383	2025-06-29 03:11:27.656826+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
384	2025-06-29 03:21:25.63183+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
385	2025-06-29 03:21:38.773582+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
386	2025-06-29 03:24:31.864482+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
387	2025-06-29 03:26:33.358431+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
388	2025-06-29 03:41:23.746209+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
389	2025-06-29 03:42:01.440108+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
390	2025-06-29 03:42:17.55281+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
391	2025-06-29 03:43:43.825298+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
392	2025-06-29 03:44:03.990439+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
393	2025-06-29 04:01:09.150071+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
394	2025-06-29 04:04:30.000559+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
395	2025-06-29 04:49:41.767663+04:30	1	Olivia Doe - pending	2	[{"changed": {"fields": ["Status"]}}]	34	1
396	2025-06-29 04:49:56.093483+04:30	1	Olivia Doe - invited	2	[{"changed": {"fields": ["Status"]}}]	34	1
397	2025-06-29 04:50:07.350127+04:30	1	Olivia Doe - registered	2	[{"changed": {"fields": ["Status"]}}]	34	1
398	2025-06-29 04:50:26.593227+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
399	2025-06-29 04:52:00.453596+04:30	59	Olivia - Turkish [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
400	2025-06-29 04:52:09.257099+04:30	57	Olivia - Arabic [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
401	2025-06-29 05:05:05.657507+04:30	58	Olivia - Italian [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
402	2025-06-29 05:05:05.672508+04:30	59	Olivia - Turkish [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
403	2025-06-29 05:08:22.075741+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active", "Terms agreed"]}}]	23	1
404	2025-06-29 17:04:19.395015+04:30	1	Olivia Doe - added_edu	2	[{"changed": {"fields": ["Status"]}}]	34	1
405	2025-07-04 03:42:54.38561+04:30	1	lucas	2	[{"changed": {"fields": ["Email address"]}}]	4	1
406	2025-07-04 14:12:11.998612+04:30	1	about_whyUs_title	1	[{"added": {}}]	20	1
407	2025-07-04 14:13:22.861666+04:30	2	about_whyUs_body	1	[{"added": {}}]	20	1
408	2025-07-04 14:19:28.34457+04:30	1	about_whyUs_body	1	[{"added": {}}]	19	1
409	2025-07-04 18:13:20.823915+04:30	1	email1	1	[{"added": {}}]	14	1
410	2025-07-04 18:13:34.127676+04:30	2	email2	1	[{"added": {}}]	14	1
411	2025-07-04 18:13:50.503612+04:30	1	email1	2	[{"changed": {"fields": ["Value"]}}]	14	1
412	2025-07-04 18:14:25.672624+04:30	17	phone1	1	[{"added": {}}]	11	1
413	2025-07-04 18:14:38.316347+04:30	18	phone2	1	[{"added": {}}]	11	1
414	2025-07-05 21:37:45.012335+04:30	19	site_description	1	[{"added": {}}]	11	1
415	2025-07-05 21:38:44.622744+04:30	3	site_description	1	[{"added": {}}]	20	1
416	2025-07-05 21:38:52.117173+04:30	19	site_description	3		11	1
417	2025-07-05 21:39:24.359017+04:30	3	site_description	2	[]	20	1
418	2025-07-05 23:29:00.780844+04:30	2	site_logo_dark	1	[{"added": {}}]	17	1
419	2025-07-06 14:11:19.09821+04:30	2	Adele2	2	[{"changed": {"fields": ["Major"]}}]	37	1
420	2025-07-06 14:11:30.886884+04:30	2	Adele2	2	[{"changed": {"fields": ["Major"]}}]	37	1
421	2025-07-06 14:26:48.457016+04:30	11	niki	2	[{"changed": {"fields": ["Is active"]}}]	23	1
422	2025-07-06 23:45:46.515701+04:30	12	niki	2	[{"changed": {"fields": ["Email address"]}}]	4	1
423	2025-07-06 23:46:02.916639+04:30	11	niki	2	[{"changed": {"fields": ["Country", "Lang native"]}}]	23	1
424	2025-07-06 23:46:10.212056+04:30	11	niki	2	[{"changed": {"fields": ["Gender"]}}]	23	1
425	2025-07-07 02:22:55.135439+04:30	11	niki	2	[{"changed": {"fields": ["Is active"]}}]	23	1
426	2025-07-07 02:24:57.881293+04:30	11	niki	2	[{"changed": {"fields": ["Is active"]}}]	23	1
427	2025-07-07 02:49:25.137985+04:30	11	niki	2	[{"changed": {"fields": ["Is active"]}}]	23	1
428	2025-07-07 02:51:21.862662+04:30	11	niki	2	[{"changed": {"fields": ["Is active"]}}]	23	1
429	2025-07-07 02:56:16.799501+04:30	11	niki	2	[{"changed": {"fields": ["Is active"]}}]	23	1
430	2025-07-07 03:04:14.619133+04:30	11	niki	2	[]	23	1
431	2025-07-07 15:18:57.935721+04:30	1	fac	1	[{"added": {}}]	21	1
432	2025-07-07 15:19:14.509669+04:30	1	facebook	2	[{"changed": {"fields": ["Key", "Value"]}}]	21	1
433	2025-07-07 15:19:31.530643+04:30	2	instagram	1	[{"added": {}}]	21	1
434	2025-07-07 15:19:37.218968+04:30	3	linkedin	1	[{"added": {}}]	21	1
435	2025-07-07 15:19:52.816861+04:30	4	dribbble	1	[{"added": {}}]	21	1
436	2025-07-07 15:20:12.718999+04:30	5	twitter	1	[{"added": {}}]	21	1
437	2025-07-07 15:20:26.265774+04:30	3	linkedin	2	[{"changed": {"fields": ["Value"]}}]	21	1
438	2025-07-07 15:24:34.671982+04:30	20	visit_time	1	[{"added": {}}]	11	1
439	2025-07-07 15:25:00.85948+04:30	20	visit_time	2	[]	11	1
440	2025-07-08 16:52:11.490839+04:30	3	Kate	2	[{"changed": {"fields": ["Is active"]}}]	23	1
441	2025-07-08 16:53:25.619079+04:30	3	Kate	2	[{"changed": {"fields": ["User type"]}}]	23	1
442	2025-07-08 16:54:21.113253+04:30	3	Kate	2	[{"changed": {"fields": ["Is active"]}}]	23	1
443	2025-07-08 17:00:54.816772+04:30	3	Kate	2	[{"changed": {"fields": ["Is active"]}}]	23	1
444	2025-07-08 17:02:21.50673+04:30	3	Kate	2	[{"changed": {"fields": ["Activation token", "Token expiry"]}}]	23	1
445	2025-07-09 02:58:24.409847+04:30	6	site_address	1	[{"added": {}}]	21	1
446	2025-07-09 03:21:27.643412+04:30	6	site_address	2	[{"changed": {"fields": ["Value"]}}]	21	1
447	2025-07-09 03:21:42.525263+04:30	6	site_address	2	[]	21	1
448	2025-07-09 03:21:54.929972+04:30	6	site_address	2	[{"changed": {"fields": ["Value"]}}]	21	1
449	2025-07-09 13:04:55.896585+04:30	3	Kate	2	[{"changed": {"fields": ["User type", "Is active"]}}]	23	1
450	2025-07-09 14:56:26.113311+04:30	13	Cynthia	2	[{"changed": {"fields": ["Email address"]}}]	4	1
451	2025-07-11 04:15:25.311763+04:30	12	Cynthia	2	[{"changed": {"fields": ["Gender", "Country", "User type", "Lang native"]}}]	23	1
452	2025-07-11 04:16:35.947803+04:30	3	Cynthia	1	[{"added": {}}]	35	1
453	2025-07-11 04:17:03.200362+04:30	12	Cynthia	2	[{"changed": {"fields": ["Photo"]}}]	23	1
454	2025-07-12 14:32:27.995428+04:30	2	Kate Middelton - invited	2	[{"changed": {"fields": ["Status", "Invitation token", "Token expiry"]}}]	34	1
455	2025-07-12 14:37:39.342236+04:30	2	Kate	3		35	1
456	2025-07-12 14:38:37.400557+04:30	5	Kate	3		4	1
457	2025-07-15 19:05:15.548659+04:30	20	martin	2	[{"changed": {"fields": ["password"]}}]	4	1
458	2025-07-15 19:20:59.392455+04:30	22	martin3	2	[{"changed": {"fields": ["Email address"]}}]	4	1
459	2025-07-15 19:21:01.23256+04:30	22	martin3	2	[]	4	1
460	2025-07-15 20:02:01.922476+04:30	22	martin3	3		4	1
461	2025-07-15 22:12:29.954075+04:30	3	Adele	3		4	1
462	2025-07-15 22:12:29.962076+04:30	7	Adele2	3		4	1
463	2025-07-15 22:12:29.963076+04:30	8	Adele3	3		4	1
464	2025-07-15 22:12:29.964076+04:30	9	Adele4	3		4	1
465	2025-07-15 22:12:29.966076+04:30	4	Aysan	3		4	1
466	2025-07-15 22:12:29.969076+04:30	18	Cynthia2	3		4	1
467	2025-07-15 22:12:29.970076+04:30	11	hasan2	3		4	1
468	2025-07-15 22:12:29.971076+04:30	10	ho	3		4	1
469	2025-07-15 22:12:29.972076+04:30	21	martin2	3		4	1
470	2025-07-16 21:24:09.048534+04:30	18	reza	2	[{"changed": {"fields": ["Country", "Photo", "Lang native", "Password reset token", "Pss token expiry"]}}]	23	1
471	2025-07-16 21:31:26.858575+04:30	18	reza	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
472	2025-07-16 21:33:50.323781+04:30	18	reza	2	[{"changed": {"fields": ["Pss token expiry"]}}]	23	1
473	2025-07-16 21:34:11.829011+04:30	18	reza	2	[{"changed": {"fields": ["Pss token expiry"]}}]	23	1
474	2025-07-16 21:34:54.156432+04:30	20	martin	2	[{"changed": {"fields": ["Email address"]}}]	4	1
475	2025-07-17 01:12:55.70463+04:30	19	martin	2	[{"changed": {"fields": ["Country", "Lang native", "Password reset token", "Pss token expiry"]}}]	23	1
476	2025-07-17 01:15:39.794836+04:30	19	martin	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
477	2025-07-17 01:15:59.556966+04:30	19	martin	2	[{"changed": {"fields": ["Token expiry"]}}]	23	1
478	2025-07-17 01:16:35.246008+04:30	19	martin	2	[{"changed": {"fields": ["Pss token expiry"]}}]	23	1
479	2025-07-17 01:42:29.966534+04:30	19	martin	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
480	2025-07-17 01:52:06.415796+04:30	19	martin	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
481	2025-07-17 01:56:45.945874+04:30	18	reza	2	[]	23	1
482	2025-07-17 01:57:58.580029+04:30	18	reza	2	[{"changed": {"fields": ["Pss token expiry"]}}]	23	1
483	2025-07-17 02:34:21.629526+04:30	19	martin	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
484	2025-07-17 02:36:10.025005+04:30	19	reza	2	[{"changed": {"fields": ["Email address"]}}]	4	1
485	2025-07-17 02:36:11.253075+04:30	19	reza	2	[]	4	1
486	2025-07-17 02:43:07.884284+04:30	19	martin	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
487	2025-07-17 02:45:57.689076+04:30	12	Cynthia	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
488	2025-07-17 02:50:31.195623+04:30	12	Cynthia	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
489	2025-07-17 02:55:11.338963+04:30	18	reza	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
490	2025-07-17 02:57:47.624937+04:30	19	reza2	2	[{"changed": {"fields": ["Username"]}}]	4	1
491	2025-07-17 02:58:42.002745+04:30	18	reza2	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
492	2025-07-17 02:59:12.454487+04:30	18	reza2	2	[{"changed": {"fields": ["Pss token expiry"]}}]	23	1
493	2025-07-17 03:00:23.443195+04:30	20	martin	3		4	1
494	2025-07-17 03:01:38.317874+04:30	4	Majid	2	[{"changed": {"fields": ["Country", "Lang native", "Password reset token", "Pss token expiry"]}}]	23	1
495	2025-07-17 03:04:00.069625+04:30	6	Majid	2	[{"changed": {"fields": ["First name", "Email address", "Last login"]}}]	4	1
496	2025-07-17 03:38:25.363446+04:30	4	Majid	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
497	2025-07-17 03:41:08.440445+04:30	4	Majid	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
498	2025-07-17 03:59:46.975586+04:30	4	Majid	2	[{"changed": {"fields": ["Password reset token", "Pss token expiry"]}}]	23	1
499	2025-07-18 00:58:17.246354+04:30	6	Majid	3		4	1
500	2025-07-18 00:58:17.256354+04:30	12	niki	3		4	1
501	2025-07-18 00:58:17.259355+04:30	19	reza2	3		4	1
502	2025-07-19 02:13:45.305345+04:30	15	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:43:19.237270+00:00)	3		64	1
503	2025-07-19 02:18:31.895757+04:30	14	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:43:18.808261+00:00)	3		64	1
504	2025-07-19 02:18:31.905757+04:30	13	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:43:18.271250+00:00)	3		64	1
505	2025-07-19 02:18:31.907757+04:30	12	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:43:09.526126+00:00)	3		64	1
506	2025-07-19 02:18:31.909757+04:30	11	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:56.435003+00:00)	3		64	1
507	2025-07-19 02:18:31.910757+04:30	10	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:34.921707+00:00)	3		64	1
508	2025-07-19 02:18:31.911758+04:30	9	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:34.736698+00:00)	3		64	1
509	2025-07-19 02:18:31.914758+04:30	8	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:34.576690+00:00)	3		64	1
510	2025-07-19 02:18:31.917758+04:30	7	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:34.418684+00:00)	3		64	1
511	2025-07-19 02:18:31.921758+04:30	6	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:34.264677+00:00)	3		64	1
512	2025-07-19 02:18:31.924758+04:30	5	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:34.004663+00:00)	3		64	1
513	2025-07-19 02:18:31.926758+04:30	4	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:33.643654+00:00)	3		64	1
514	2025-07-19 02:18:31.927758+04:30	3	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:33.095644+00:00)	3		64	1
515	2025-07-19 02:18:31.928758+04:30	2	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:42:30.920625+00:00)	3		64	1
516	2025-07-19 02:18:31.929759+04:30	1	Rate Limit Triggered - 127.0.0.1 (2025-07-18 21:40:42.578769+00:00)	3		64	1
517	2025-07-19 02:54:59.877302+04:30	7	Cynthia	3		37	1
518	2025-07-19 16:56:27.355681+04:30	25	reza	2	[{"changed": {"fields": ["Country", "Lang native", "Lang speak", "Is active"]}}]	23	1
519	2025-07-19 17:18:51.98864+04:30	1	Math session , ID: BROILVra by Cynthia at 2025-07-19 12:48:12+00:00 - cost: 10	1	[{"added": {}}]	44	1
520	2025-07-19 17:23:55.214005+04:30	1	Math session , ID: BROILVra by Cynthia at 2025-07-19 12:48:12+00:00 - cost: 10.00	2	[]	44	1
521	2025-07-19 17:30:30.556759+04:30	25	reza	2	[{"changed": {"fields": ["Photo", "Is active"]}}]	23	1
522	2025-07-19 17:30:50.286877+04:30	25	reza	2	[{"changed": {"fields": ["Is active"]}}]	23	1
523	2025-07-19 21:05:38.074057+04:30	1	Math session , ID: BROILVra by Cynthia at 2025-07-19 12:48:12+00:00 - cost: 10.00	2	[{"changed": {"fields": ["Status"]}}]	44	1
524	2025-07-19 23:12:41.500341+04:30	2	Chemistry session , ID: 7XxjiqLq by Olivia at 2025-07-19 18:41:40+00:00 - cost: 0.0	1	[{"added": {}}]	44	1
525	2025-07-20 02:32:58.992951+04:30	24	zahra	3		4	1
526	2025-07-20 02:43:02.690481+04:30	26	ali	2	[{"changed": {"fields": ["Is active"]}}]	23	1
527	2025-07-20 03:03:40.841299+04:30	3	Physics session , ID: 8Ld9WdRy by Cynthia at 2025-07-19 22:33:06+00:00 - cost: 10	1	[{"added": {}}]	44	1
528	2025-07-20 03:04:34.896391+04:30	3	Physics session , ID: 8Ld9WdRy by Cynthia at 2025-07-19 22:33:06+00:00 - cost: 10.00	2	[{"changed": {"fields": ["Status"]}}]	44	1
529	2025-07-20 17:01:12.959206+04:30	1	Olivia Doe - completed_profile	2	[{"changed": {"fields": ["Status"]}}]	34	1
530	2025-07-21 17:04:39.132327+04:30	1	HelpCategory object (1)	1	[{"added": {}}]	68	1
531	2025-07-21 17:05:17.085498+04:30	2	HelpCategory object (2)	1	[{"added": {}}]	68	1
532	2025-07-21 17:05:31.98335+04:30	3	HelpCategory object (3)	1	[{"added": {}}]	68	1
533	2025-07-21 17:07:25.353835+04:30	1	HelpSection object (1)	1	[{"added": {}}]	66	1
534	2025-07-21 17:07:42.842835+04:30	2	HelpSection object (2)	1	[{"added": {}}]	66	1
535	2025-07-21 17:07:57.954699+04:30	1	HelpSection object (1)	2	[{"changed": {"fields": ["Order"]}}]	66	1
536	2025-07-21 17:08:07.459243+04:30	2	HelpSection object (2)	2	[{"changed": {"fields": ["Order"]}}]	66	1
537	2025-07-21 19:00:25.647909+04:30	1	The perks of teaching on Preply	1	[{"added": {}}]	65	1
538	2025-07-21 19:13:40.766387+04:30	1	The perks of teaching on Preply	2	[]	65	1
539	2025-07-21 19:25:51.362175+04:30	1	The perks of teaching on Lingocept	2	[{"changed": {"fields": ["Title", "Slug"]}}]	65	1
540	2025-07-21 20:54:50.56656+04:30	3	Becoming a Lingocept student (Help for Students)	1	[{"added": {}}]	66	1
541	2025-07-21 20:56:15.962445+04:30	2	Register as a student	1	[{"added": {}}]	65	1
542	2025-07-21 21:00:25.73073+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
543	2025-07-21 21:01:22.116938+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
544	2025-07-21 21:01:50.709573+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
545	2025-07-21 21:03:08.898045+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
546	2025-07-21 21:04:26.198467+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
547	2025-07-21 21:09:28.53976+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
548	2025-07-21 21:10:11.937242+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
549	2025-07-21 21:12:38.742639+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
550	2025-07-21 21:38:43.89716+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
551	2025-07-21 21:58:28.947941+04:30	2	Register as a student	2	[{"changed": {"fields": ["content"]}}]	65	1
552	2025-07-21 21:59:07.377139+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
553	2025-07-21 22:16:55.922257+04:30	2	Register as a student	2	[{"changed": {"fields": ["content"]}}]	65	1
554	2025-07-21 22:51:56.965457+04:30	2	Register as a student	2	[{"changed": {"fields": ["content"]}}]	65	1
555	2025-07-21 23:05:22.129509+04:30	2	Register as a student	2	[{"changed": {"fields": ["content"]}}]	65	1
556	2025-07-21 23:07:50.533998+04:30	2	Register as a student	2	[{"changed": {"fields": ["content"]}}]	65	1
557	2025-07-21 23:09:58.651326+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
558	2025-07-21 23:10:35.400428+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
559	2025-07-21 23:13:57.03196+04:30	2	Register as a student	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
560	2025-07-22 00:05:21.143653+04:30	1	The perks of teaching on Lingocept	2	[{"changed": {"fields": ["content"]}}]	65	1
561	2025-07-22 00:23:23.576564+04:30	1	The perks of teaching on Lingocept	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
562	2025-07-22 00:27:38.974172+04:30	1	The perks of teaching on Lingocept	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
563	2025-07-22 01:34:32.926837+04:30	3	hello Test	1	[{"added": {}}]	65	1
564	2025-07-22 01:42:47.24111+04:30	3	hello Test	2	[{"changed": {"fields": ["content"]}}]	65	1
565	2025-07-22 01:46:35.457423+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
566	2025-07-22 01:47:00.59186+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
567	2025-07-22 02:11:21.224388+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
568	2025-07-22 02:12:09.988177+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
569	2025-07-22 02:12:34.591584+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
570	2025-07-22 02:30:12.869076+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
571	2025-07-22 02:32:02.323337+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
572	2025-07-22 02:38:51.65875+04:30	3	hello Test	2	[{"changed": {"fields": ["content", "View count"]}}]	65	1
573	2025-07-22 02:59:28.315439+04:30	4	Lingocept Business for Admins (Lingocept Business)	1	[{"added": {}}]	66	1
574	2025-07-22 02:59:36.245892+04:30	4	How to boost employee onboarding	1	[{"added": {}}]	65	1
575	2025-07-25 17:10:01.491018+04:30	1	Olivia Doe - decision	2	[{"changed": {"fields": ["Status"]}}]	34	1
576	2025-07-25 17:10:16.082852+04:30	1	Olivia Doe - accepted	2	[{"changed": {"fields": ["Status"]}}]	34	1
577	2025-07-25 17:10:33.746863+04:30	1	Olivia Doe - rejected	2	[{"changed": {"fields": ["Status"]}}]	34	1
578	2025-07-26 00:59:54.08478+04:30	27	ali	3		4	1
579	2025-07-26 00:59:54.10478+04:30	13	Cynthia	3		4	1
580	2025-07-26 00:59:54.10478+04:30	26	reza	3		4	1
581	2025-07-26 20:51:37.325838+04:30	31	Fatemeh	3		4	1
582	2025-07-26 20:51:37.334839+04:30	30	hasan	3		4	1
583	2025-07-26 22:32:32.130449+04:30	32	gh	3		4	1
584	2025-07-26 22:32:32.138449+04:30	33	test	3		4	1
585	2025-07-26 23:44:49.59625+04:30	34	mina	3		4	1
586	2025-07-26 23:50:11.823212+04:30	32	t1	3		23	1
587	2025-07-26 23:51:19.266439+04:30	35	t1	3		4	1
588	2025-07-27 00:34:38.842964+04:30	23	Majid2	3		4	1
589	2025-07-27 11:59:15.170278+04:30	38	s1	3		23	1
590	2025-07-27 11:59:47.199755+04:30	40	s1	3		4	1
591	2025-07-27 14:52:17.137006+04:30	40	t1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
592	2025-07-27 15:00:37.664635+04:30	40	t1	2	[{"changed": {"fields": ["Is active"]}}]	23	1
593	2025-07-27 15:00:57.430766+04:30	40	t1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
594	2025-07-27 15:01:08.853419+04:30	40	t1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
595	2025-07-27 15:01:23.007228+04:30	40	t1	2	[{"changed": {"fields": ["Is active"]}}]	23	1
596	2025-07-27 15:01:32.600777+04:30	40	t1	2	[{"changed": {"fields": ["Is active"]}}]	23	1
597	2025-07-27 15:41:26.631511+04:30	40	t1	2	[{"changed": {"fields": ["Is active"]}}]	23	1
598	2025-07-27 15:44:55.677372+04:30	40	t1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
599	2025-07-27 16:21:34.472958+04:30	40	t1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
600	2025-07-27 16:21:50.59488+04:30	40	t1	2	[{"changed": {"fields": ["Is active"]}}]	23	1
601	2025-07-27 17:13:33.713595+04:30	40	t1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
602	2025-07-27 18:44:33.3918+04:30	1	lucas	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
603	2025-07-27 18:46:48.245514+04:30	1	lucas	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
604	2025-07-27 19:03:52.545762+04:30	41	s0	3		4	1
605	2025-07-27 19:08:01.281619+04:30	41	t2	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
606	2025-07-27 23:36:31.0577+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
607	2025-07-28 00:36:10.210274+04:30	40	t1	3		23	1
608	2025-07-28 00:36:16.100611+04:30	41	t2	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
609	2025-07-28 02:15:41.525837+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
610	2025-07-28 02:17:10.481925+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
611	2025-07-28 02:19:05.469501+04:30	41	t2	2	[{"changed": {"fields": ["Country", "User type", "Lang native", "Is email verified"]}}]	23	1
612	2025-07-28 02:19:23.97856+04:30	41	t2	2	[{"changed": {"fields": ["Photo"]}}]	23	1
613	2025-07-28 02:20:31.407417+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
614	2025-07-28 02:39:25.62429+04:30	41	t2	2	[{"changed": {"fields": ["Is active"]}}]	23	1
615	2025-07-28 02:39:46.939509+04:30	41	t2	2	[{"changed": {"fields": ["Is active"]}}]	23	1
616	2025-07-28 02:40:31.227043+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
617	2025-07-28 02:41:30.580437+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
618	2025-07-28 02:49:19.068233+04:30	41	t2	2	[{"changed": {"fields": ["Is active"]}}]	23	1
619	2025-07-28 02:49:27.58172+04:30	41	t2	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
620	2025-07-28 02:50:11.960259+04:30	41	t2	2	[{"changed": {"fields": ["Email verification token", "Email token expiry"]}}]	23	1
621	2025-07-28 02:53:01.39495+04:30	41	t2	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
622	2025-07-28 02:56:35.727209+04:30	41	t2	2	[{"changed": {"fields": ["User type"]}}]	23	1
623	2025-07-28 02:58:34.759624+04:30	43	t2	3		4	1
624	2025-07-28 03:01:19.535368+04:30	44	Malena	3		4	1
625	2025-07-28 03:04:22.596996+04:30	43	tina	2	[{"changed": {"fields": ["Gender", "Country", "Photo", "Lang native"]}}]	23	1
626	2025-07-28 03:06:45.524171+04:30	43	tina	2	[{"changed": {"fields": ["User type"]}}]	23	1
627	2025-07-28 03:07:02.382135+04:30	43	tina	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
628	2025-07-28 03:17:15.505204+04:30	43	tina	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
629	2025-07-28 12:13:20.382458+04:30	43	tina	2	[{"changed": {"fields": ["User type"]}}]	23	1
630	2025-07-28 12:21:15.250619+04:30	43	tina	2	[{"changed": {"fields": ["Is active"]}}]	23	1
631	2025-07-28 12:21:30.604497+04:30	43	tina	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
632	2025-07-28 12:21:44.044266+04:30	43	tina	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
633	2025-07-28 16:49:50.893256+04:30	7	tina	2	[{"changed": {"fields": ["Status"]}}]	35	1
634	2025-07-28 16:49:50.903256+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
635	2025-07-28 17:08:19.687805+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
636	2025-07-28 18:22:50.097181+04:30	2	Kate Middelton - invited	3		34	1
637	2025-07-28 18:23:03.139927+04:30	1	Olivia Doe - rejected	3		34	1
638	2025-07-28 20:46:29.569843+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
639	2025-07-28 21:01:32.841465+04:30	2	Olivia	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
640	2025-07-28 21:03:07.742893+04:30	1	lucas	2	[{"changed": {"fields": ["Is active"]}}]	23	1
641	2025-07-28 21:10:21.518704+04:30	2	Olivia	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
642	2025-07-30 12:18:09.127183+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
643	2025-07-30 12:18:21.686902+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
644	2025-07-30 18:15:17.347093+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
645	2025-07-30 18:15:57.606396+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
646	2025-07-30 18:27:44.866849+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
647	2025-07-30 21:38:29.842877+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
648	2025-07-31 01:36:12.340374+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
649	2025-08-01 11:01:07.667516+04:30	58	Olivia - Italian [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
650	2025-08-01 11:13:40.203067+04:30	60	Olivia - chemistry [up to A2 (Elementary)]	1	[{"added": {}}]	22	1
651	2025-08-01 11:14:30.51992+04:30	61	Olivia - mathematics [up to B2 (Upper-Intermediate)]	1	[{"added": {}}]	22	1
652	2025-08-01 11:15:34.649588+04:30	62	Olivia - Hindi [up to C1 (Advanced)]	1	[{"added": {}}]	22	1
653	2025-08-01 11:15:53.422662+04:30	63	Olivia - physics [up to Native (Fluent as a first language)]	1	[{"added": {}}]	22	1
654	2025-08-01 11:50:58.285805+04:30	62	Olivia - Hindi [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
655	2025-08-01 11:50:58.290806+04:30	61	Olivia - mathematics [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
656	2025-08-01 11:53:42.044871+04:30	57	Olivia - Arabic [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
657	2025-08-01 11:53:42.054871+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
658	2025-08-01 11:53:42.054871+04:30	59	Olivia - Turkish [up to B2 (Upper-Intermediate)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
659	2025-08-01 11:53:42.064871+04:30	60	Olivia - chemistry [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
660	2025-08-01 11:53:42.074871+04:30	61	Olivia - mathematics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
661	2025-08-01 14:21:12.872097+04:30	9	Olivia – Master's Degree in Biology (2012)	1	[{"added": {}}]	48	1
662	2025-08-02 02:23:11.864299+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
663	2025-08-02 02:23:11.874299+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
664	2025-08-02 17:49:19.987899+04:30	21	tooltip_skill_thumbnail	1	[{"added": {}}]	11	1
665	2025-08-02 23:39:15.153442+04:30	57	Olivia - Arabic [up to A1 (Beginner)]	2	[{"changed": {"fields": ["Video", "Thumbnail"]}}]	22	1
666	2025-08-03 00:22:19.674268+04:30	62	Olivia - Hindi [up to A2 (Elementary)]	3		22	1
667	2025-08-03 00:22:37.982316+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Thumbnail"]}}]	22	1
668	2025-08-03 00:22:53.117181+04:30	60	Olivia - chemistry [up to C1 (Advanced)]	3		22	1
669	2025-08-03 00:23:00.567607+04:30	61	Olivia - mathematics [up to C2 (Proficient)]	3		22	1
670	2025-08-03 00:23:45.751192+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Certificate", "Video", "Thumbnail"]}}]	22	1
671	2025-08-03 00:47:43.991385+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Thumbnail"]}}]	22	1
672	2025-08-03 00:48:12.74503+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Thumbnail"]}}]	22	1
673	2025-08-03 01:34:41.238475+04:30	64	Olivia - Spanish [up to Native (Fluent as a first language)]	1	[{"added": {}}]	22	1
674	2025-08-03 01:39:07.756719+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Thumbnail"]}}]	22	1
675	2025-08-03 01:39:40.684602+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Thumbnail"]}}]	22	1
676	2025-08-03 10:22:40.106944+04:30	2	Olivia	2	[{"changed": {"fields": ["Gender", "Lang native", "Lang speak", "Bio"]}}]	23	1
677	2025-08-03 10:23:15.646817+04:30	2	Olivia	2	[{"changed": {"fields": ["Phone country code", "Phone number"]}}]	23	1
678	2025-08-03 11:01:01.988046+04:30	64	Olivia - Spanish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
679	2025-08-03 11:01:01.997047+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
680	2025-08-03 11:01:31.678744+04:30	57	Olivia - Arabic [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Level"]}}]	22	1
681	2025-08-03 11:03:06.807186+04:30	9	Olivia – Master's Degree in Biology (2012)	2	[{"changed": {"fields": ["Status"]}}]	48	1
682	2025-08-03 11:03:06.824186+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Status"]}}]	48	1
683	2025-08-03 11:03:06.831187+04:30	4	Olivia – Bachelor's Degree in Matematics123 (2018)	2	[{"changed": {"fields": ["Status"]}}]	48	1
684	2025-08-03 11:07:01.123588+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Status"]}}]	48	1
685	2025-08-03 11:07:01.131588+04:30	4	Olivia – Bachelor's Degree in Matematics123 (2018)	2	[{"changed": {"fields": ["Status"]}}]	48	1
686	2025-08-03 11:11:43.997767+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Status"]}}]	48	1
687	2025-08-03 11:21:36.792673+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
688	2025-08-03 11:23:06.656813+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
689	2025-08-03 12:05:37.837696+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
690	2025-08-03 12:12:35.780601+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
691	2025-08-03 12:13:30.196714+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
692	2025-08-03 12:20:00.35403+04:30	57	Olivia - Arabic [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
693	2025-08-03 12:20:00.36403+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
694	2025-08-03 12:20:00.36903+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
695	2025-08-03 12:22:14.294691+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
696	2025-08-03 12:24:11.731408+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
697	2025-08-03 13:09:03.053342+04:30	57	Olivia - Arabic [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
698	2025-08-03 13:33:00.411555+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
699	2025-08-03 13:36:14.384649+04:30	57	Olivia - Arabic [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
700	2025-08-03 13:37:44.399798+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
701	2025-08-03 13:37:44.408798+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
702	2025-08-03 14:03:39.629127+04:30	2	Olivia	2	[{"changed": {"fields": ["Rating", "Reviews count"]}}]	23	1
703	2025-08-03 14:04:30.720049+04:30	57	Olivia - Arabic [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
704	2025-08-03 14:04:30.73105+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
705	2025-08-03 14:04:30.73505+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
706	2025-08-03 14:04:30.73905+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
707	2025-08-03 14:04:51.53224+04:30	63	Olivia - physics [up to C2 (Proficient)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
708	2025-08-03 16:00:30.517128+04:30	44	test1	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
709	2025-08-03 16:01:30.710571+04:30	44	test1	2	[{"changed": {"fields": ["Country", "User type", "Lang native"]}}]	23	1
710	2025-08-03 16:01:56.714058+04:30	44	test1	2	[{"changed": {"fields": ["User type"]}}]	23	1
711	2025-08-03 16:05:15.732441+04:30	45	mary	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
712	2025-08-03 16:06:34.251933+04:30	45	mary	2	[{"changed": {"fields": ["Gender", "Country", "Lang native", "Rating", "Reviews count"]}}]	23	1
713	2025-08-03 16:06:51.556922+04:30	45	mary	2	[{"changed": {"fields": ["Photo"]}}]	23	1
714	2025-08-03 16:07:44.404945+04:30	65	mary - French [up to C1 (Advanced)]	1	[{"added": {}}]	22	1
715	2025-08-03 16:08:04.679105+04:30	57	Olivia - French [up to A2 (Elementary)]	2	[{"changed": {"fields": ["Skill"]}}]	22	1
716	2025-08-03 16:13:02.309128+04:30	8	mary	2	[{"changed": {"fields": ["Session count", "Student count"]}}]	35	1
717	2025-08-03 16:16:01.692388+04:30	9	richard	2	[{"changed": {"fields": ["Session count", "Student count"]}}]	35	1
718	2025-08-03 16:17:13.385489+04:30	46	richard	2	[{"changed": {"fields": ["Country", "Photo", "Lang native", "Lang speak"]}}]	23	1
719	2025-08-03 16:17:29.48241+04:30	46	richard	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
720	2025-08-03 16:19:03.252773+04:30	66	richard - Ukrainian [up to B2 (Upper-Intermediate)]	1	[{"added": {}}]	22	1
721	2025-08-03 16:19:31.372381+04:30	66	richard - Ukrainian [up to B2 (Upper-Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
722	2025-08-03 16:20:01.630112+04:30	66	richard - physics [up to B2 (Upper-Intermediate)]	2	[{"changed": {"fields": ["Skill"]}}]	22	1
723	2025-08-03 16:31:53.279816+04:30	1	Olivia	2	[{"changed": {"fields": ["Session count", "Student count"]}}]	35	1
724	2025-08-03 16:35:37.122619+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
725	2025-08-04 00:43:26.785482+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
726	2025-08-04 00:43:45.167533+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
727	2025-08-04 01:43:08.648016+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
728	2025-08-04 01:44:56.685195+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
729	2025-08-04 02:15:37.949509+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
730	2025-08-04 02:17:48.724989+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
731	2025-08-04 02:29:10.092961+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
732	2025-08-04 02:30:39.689086+04:30	64	Olivia - Spanish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
733	2025-08-04 02:31:28.108855+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
734	2025-08-04 02:32:36.679777+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
735	2025-08-04 02:32:36.686778+04:30	59	Olivia - Turkish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
736	2025-08-04 02:32:49.251496+04:30	64	Olivia - Spanish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
737	2025-08-04 12:02:00.048587+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
738	2025-08-04 16:36:13.084654+04:30	59	Olivia - German [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
739	2025-08-04 16:36:13.096655+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
740	2025-08-04 16:36:13.100655+04:30	64	Olivia - Spanish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
741	2025-08-04 16:50:19.21805+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
742	2025-08-04 16:51:32.883264+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
743	2025-08-04 17:54:30.14231+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
744	2025-08-04 18:03:32.439328+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
745	2025-08-04 18:09:14.6259+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
746	2025-08-04 18:10:50.533386+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
747	2025-08-04 18:15:02.254783+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
748	2025-08-04 18:15:17.382649+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
749	2025-08-04 18:17:48.044266+04:30	7	tina	2	[{"changed": {"fields": ["Status"]}}]	35	1
750	2025-08-04 18:17:48.052266+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
751	2025-08-04 18:20:59.848236+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
752	2025-08-04 18:21:13.37801+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
753	2025-08-04 18:21:33.82718+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
754	2025-08-04 18:22:41.947076+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
755	2025-08-04 18:24:13.10929+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
756	2025-08-04 18:24:42.553974+04:30	2	Olivia	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
757	2025-08-04 18:25:07.223385+04:30	2	Olivia	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
758	2025-08-04 18:27:08.45932+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
759	2025-08-04 18:29:00.930753+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
760	2025-08-04 18:29:24.122079+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
761	2025-08-04 18:33:28.272044+04:30	59	Olivia - German [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
762	2025-08-04 18:33:28.281044+04:30	58	Olivia - Italian [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
763	2025-08-04 18:33:28.285045+04:30	64	Olivia - Spanish [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
764	2025-08-04 18:50:41.973168+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
765	2025-08-05 02:03:58.952467+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
766	2025-08-05 02:06:57.805696+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
767	2025-08-05 12:24:35.596077+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
868	2025-08-11 17:17:18.729681+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
768	2025-08-07 00:40:53.004263+04:30	59	Olivia - German [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Video"]}}]	22	1
769	2025-08-07 12:48:17.91073+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
770	2025-08-07 15:41:14.532639+04:30	59	Olivia - German [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
771	2025-08-07 15:41:14.54664+04:30	67	Olivia - Hindi [up to B1 (Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
772	2025-08-07 15:41:14.555641+04:30	69	Olivia - Korean [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
773	2025-08-07 19:10:01.206124+04:30	77	Olivia - Chinese [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
774	2025-08-07 19:10:01.213124+04:30	72	Olivia - English [up to B2 (Upper-Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
775	2025-08-07 19:10:01.221125+04:30	75	Olivia - German [up to Native (Fluent as a first language)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
776	2025-08-09 12:25:26.666161+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
777	2025-08-09 14:37:09.993205+04:30	2	Olivia	2	[{"changed": {"fields": ["Phone country code", "Phone number"]}}]	23	1
810	2025-08-09 18:18:53.788012+04:30	2	Olivia	2	[{"changed": {"fields": ["Phone country code"]}}]	23	1
811	2025-08-09 18:21:57.566311+04:30	2	Olivia1111	2	[{"changed": {"fields": ["Lang speak"]}}]	23	1
812	2025-08-09 19:17:15.124001+04:30	2	Olivia	2	[{"changed": {"fields": ["Username"]}}]	4	1
813	2025-08-09 19:30:19.821883+04:30	2	Olivia	2	[{"changed": {"fields": ["Phone country code"]}}]	23	1
814	2025-08-09 23:55:01.953255+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
815	2025-08-09 23:55:13.365908+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
816	2025-08-10 00:07:12.301623+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
817	2025-08-10 00:08:49.600092+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
818	2025-08-10 00:11:04.626815+04:30	79	mary - English [up to C1 (Advanced)]	1	[{"added": {}}]	22	1
819	2025-08-10 00:11:27.392117+04:30	79	mary - English [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
820	2025-08-10 01:32:35.248118+04:30	10	mary – Master's Degree in Molecular Gentics (2025)	1	[{"added": {}}]	48	1
821	2025-08-10 01:32:52.363097+04:30	10	mary – Master's Degree in Molecular Gentics (2025)	2	[{"changed": {"fields": ["Status"]}}]	48	1
822	2025-08-10 01:33:02.115655+04:30	10	mary – Master's Degree in Molecular Gentics (2025)	2	[{"changed": {"fields": ["Status"]}}]	48	1
823	2025-08-10 01:34:27.083515+04:30	2	Olivia	2	[{"changed": {"fields": ["Is active"]}}]	23	1
824	2025-08-10 01:35:27.752985+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
825	2025-08-10 02:01:13.031728+04:30	80	tina - French [up to B2 (Upper-Intermediate)]	1	[{"added": {}}]	22	1
826	2025-08-10 02:01:28.726625+04:30	80	tina - French [up to B2 (Upper-Intermediate)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
827	2025-08-10 02:02:31.759231+04:30	9	Olivia – Master's Degree in Biology (2012)	2	[{"changed": {"fields": ["Status"]}}]	48	1
828	2025-08-10 02:02:31.776232+04:30	8	Olivia – Associate Degree in Computer (1900)	2	[{"changed": {"fields": ["Status"]}}]	48	1
829	2025-08-10 02:03:52.34384+04:30	81	richard - English [up to Native (Fluent as a first language)]	1	[{"added": {}}]	22	1
830	2025-08-10 02:04:43.995794+04:30	82	tina - English [up to C2 (Proficient)]	1	[{"added": {}}]	22	1
831	2025-08-10 02:14:30.293509+04:30	42	t1	3		4	1
832	2025-08-10 02:20:22.007511+04:30	49	katy	2	[{"changed": {"fields": ["Email address"]}}]	4	1
833	2025-08-10 02:31:41.615296+04:30	48	britny	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
834	2025-08-10 02:35:47.379353+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
835	2025-08-10 02:38:34.701923+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
836	2025-08-10 02:38:49.260756+04:30	48	britny	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
837	2025-08-10 02:52:52.692171+04:30	48	britny	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
838	2025-08-10 03:24:24.217751+04:30	84	britny - French [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Skill"]}}]	22	1
839	2025-08-10 03:25:26.218298+04:30	11	britny – Bachelor's Degree in Computer Science (2007)	2	[{"changed": {"fields": ["Status"]}}]	48	1
840	2025-08-10 20:44:58.647339+04:30	48	britny	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
841	2025-08-10 21:43:32.076296+04:30	46	richard	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
842	2025-08-11 02:42:14.275448+04:30	46	richard	2	[{"changed": {"fields": ["Is email verified"]}}]	23	1
843	2025-08-11 02:42:42.855083+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
844	2025-08-11 02:42:48.549408+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
845	2025-08-11 04:09:15.256071+04:30	81	richard - English [up to Native (Fluent as a first language)]	3		22	1
846	2025-08-11 04:09:15.265072+04:30	66	richard - physics [up to B2 (Upper-Intermediate)]	3		22	1
847	2025-08-11 04:12:21.516725+04:30	84	britny - French [up to C1 (Advanced)]	3		22	1
848	2025-08-11 04:12:21.524725+04:30	86	britny - German [up to A2 (Elementary)]	3		22	1
849	2025-08-11 04:12:21.525725+04:30	83	britny - Turkish [up to C1 (Advanced)]	3		22	1
850	2025-08-11 04:12:21.526725+04:30	85	britny - Ukrainian [up to A2 (Elementary)]	3		22	1
851	2025-08-11 04:16:01.3823+04:30	11	britny – Bachelor's Degree in Computer Science (2007)	3		48	1
852	2025-08-11 04:17:18.623718+04:30	8	toefl from Illinois USA	3		51	1
853	2025-08-11 04:27:36.040032+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
854	2025-08-11 04:46:43.630671+04:30	9	richard	2	[{"changed": {"fields": ["Status"]}}]	35	1
855	2025-08-11 04:46:54.364285+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
856	2025-08-11 04:47:02.862771+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
857	2025-08-11 04:47:11.002236+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
858	2025-08-11 04:47:24.902031+04:30	8	mary	2	[{"changed": {"fields": ["Status"]}}]	35	1
859	2025-08-11 04:47:49.199421+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
860	2025-08-11 04:48:13.985839+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
861	2025-08-11 04:49:59.534876+04:30	48	britny	2	[{"changed": {"fields": ["Rating"]}}]	23	1
862	2025-08-11 04:50:25.852381+04:30	43	tina	2	[{"changed": {"fields": ["Rating"]}}]	23	1
863	2025-08-11 12:06:48.685384+04:30	1	Olivia	2	[{"changed": {"fields": ["Status"]}}]	35	1
864	2025-08-11 16:56:41.496444+04:30	79	mary - English [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
865	2025-08-11 16:56:57.756374+04:30	79	mary - English [up to C1 (Advanced)]	2	[{"changed": {"fields": ["Status"]}}]	22	1
866	2025-08-11 16:57:38.630137+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
867	2025-08-11 16:57:52.671845+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
869	2025-08-11 17:17:28.873261+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
870	2025-08-11 17:30:43.229696+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
871	2025-08-11 20:49:56.915077+04:30	48	britny	2	[{"changed": {"fields": ["Is active"]}}]	23	1
872	2025-08-11 20:50:16.867218+04:30	48	britny	2	[{"changed": {"fields": ["Is active"]}}]	23	1
873	2025-08-11 20:50:33.898192+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
874	2025-08-11 20:53:54.905689+04:30	43	tina	2	[{"changed": {"fields": ["Photo"]}}]	23	1
875	2025-08-11 20:56:15.028703+04:30	43	tina	2	[{"changed": {"fields": ["Photo"]}}]	23	1
876	2025-08-12 02:11:27.094703+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
877	2025-08-12 03:27:42.492401+04:30	48	britny	2	[{"changed": {"fields": ["In-person class location", "Offers in-person classes", "Maximum travel distance (km)"]}}]	23	1
878	2025-08-12 18:06:13.15331+04:30	48	britny	2	[{"changed": {"fields": ["Latitude", "Longitude", "Maximum travel distance (km)"]}}]	23	1
879	2025-08-12 18:07:11.957673+04:30	48	britny	2	[{"changed": {"fields": ["Latitude", "Longitude"]}}]	23	1
880	2025-08-13 15:37:56.367137+04:30	45	tina	2	[{"changed": {"fields": ["Email address"]}}]	4	1
881	2025-08-13 23:58:07.263007+04:30	49	s1	2	[{"changed": {"fields": ["Gender", "Lang native", "Meeting Method", "Country", "In-person class location", "Latitude", "Longitude", "Maximum travel distance (km)"]}}]	23	1
882	2025-08-14 00:00:38.259643+04:30	49	s1	2	[{"changed": {"fields": ["Meeting Method", "Latitude", "Longitude", "Maximum travel distance (km)", "Meeting location"]}}]	23	1
883	2025-08-14 13:08:16.846982+04:30	48	britny	2	[{"changed": {"fields": ["Maximum travel distance (km)"]}}]	23	1
884	2025-08-14 17:53:35.795813+04:30	48	britny	2	[{"changed": {"fields": ["Is active"]}}]	23	1
885	2025-08-14 19:27:24.611539+04:30	47	katy	2	[{"changed": {"fields": ["Lang native", "Country", "City area", "Latitude", "Longitude", "Maximum travel distance (km)"]}}]	23	1
886	2025-08-14 21:05:27.070815+04:30	50	maryam	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
887	2025-08-14 21:08:13.286322+04:30	53	Adele	1	[{"added": {}}]	4	1
888	2025-08-14 21:09:08.182462+04:30	51	Adele	1	[{"added": {}}]	23	1
889	2025-08-14 21:09:41.069343+04:30	54	david	1	[{"added": {}}]	4	1
890	2025-08-14 21:10:12.394134+04:30	54	david	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	1
891	2025-08-14 21:10:35.856476+04:30	52	david	1	[{"added": {}}]	23	1
892	2025-08-14 21:11:06.450226+04:30	53	Adele	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	1
893	2025-08-14 21:11:09.825419+04:30	51	Adele	2	[]	23	1
894	2025-08-14 21:11:32.873737+04:30	51	Adele	2	[{"changed": {"fields": ["Photo"]}}]	23	1
895	2025-08-14 21:15:41.165939+04:30	50	maryam	2	[{"changed": {"fields": ["Lang native"]}}]	23	1
896	2025-08-14 21:15:57.147853+04:30	50	maryam	2	[{"changed": {"fields": ["Photo"]}}]	23	1
897	2025-08-14 21:16:24.791434+04:30	52	david	2	[{"changed": {"fields": ["Photo"]}}]	23	1
898	2025-08-14 21:16:54.581138+04:30	49	s1	2	[{"changed": {"fields": ["Photo"]}}]	23	1
899	2025-08-14 21:17:07.258863+04:30	49	s1	2	[{"changed": {"fields": ["Photo"]}}]	23	1
900	2025-08-14 21:22:03.474806+04:30	52	david	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
901	2025-08-14 21:22:03.488807+04:30	51	Adele	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
902	2025-08-14 21:22:37.036725+04:30	55	Tatiana	1	[{"added": {}}]	4	1
903	2025-08-14 21:23:09.98661+04:30	55	Tatiana	2	[{"changed": {"fields": ["First name", "Last name", "Email address"]}}]	4	1
904	2025-08-14 21:24:40.182769+04:30	53	Tatiana	1	[{"added": {}}]	23	1
905	2025-08-14 21:24:48.690256+04:30	53	Tatiana	2	[{"changed": {"fields": ["Is active", "Is email verified"]}}]	23	1
906	2025-08-14 21:26:09.631885+04:30	11	Tatiana	1	[{"added": {}}]	35	1
907	2025-08-14 21:48:26.934383+04:30	47	katy	2	[{"changed": {"fields": ["Photo"]}}]	23	1
908	2025-08-14 22:37:10.375151+04:30	24	david	1	[{"added": {}}]	37	1
909	2025-08-14 22:37:30.001274+04:30	25	Adele	1	[{"added": {}}]	37	1
910	2025-08-15 01:52:30.295066+04:30	46	reza	2	[{"changed": {"fields": ["Username"]}}]	4	1
911	2025-08-15 01:59:14.662194+04:30	51	sara	2	[{"changed": {"fields": ["Username"]}}]	4	1
912	2025-08-15 01:59:40.587677+04:30	49	sara	2	[]	23	1
913	2025-08-15 01:59:42.611793+04:30	22	sara	2	[]	37	1
914	2025-08-15 03:37:00.144084+04:30	49	sara	2	[{"changed": {"fields": ["Meeting Method"]}}]	23	1
915	2025-08-15 03:37:18.735148+04:30	49	sara	2	[{"changed": {"fields": ["Meeting Method"]}}]	23	1
916	2025-08-15 18:05:38.379307+04:30	48	britny	2	[{"changed": {"fields": ["Maximum travel distance (km)"]}}]	23	1
917	2025-08-15 18:06:53.376596+04:30	48	britny	2	[{"changed": {"fields": ["Maximum travel distance (km)"]}}]	23	1
918	2025-08-15 18:45:45.92001+04:30	53	Tatiana	2	[{"changed": {"fields": ["Is active"]}}]	23	1
919	2025-08-15 18:46:10.817434+04:30	48	britny	2	[{"changed": {"fields": ["Is active"]}}]	23	1
920	2025-08-16 17:42:18.410426+04:30	48	britny	2	[{"changed": {"fields": ["Is active"]}}]	23	1
921	2025-08-17 01:24:02.471348+04:30	11	Tatiana	2	[{"changed": {"fields": ["Cost hourly"]}}]	35	1
922	2025-08-17 01:24:21.071412+04:30	10	britny	2	[{"changed": {"fields": ["Cost trial", "Cost hourly"]}}]	35	1
923	2025-08-18 01:22:28.877488+04:30	53	Tatiana	2	[{"changed": {"fields": ["Inp start"]}}]	23	1
924	2025-08-18 01:23:37.993441+04:30	49	sara	2	[{"changed": {"fields": ["Inp aim", "Inp start"]}}]	23	1
925	2025-08-18 01:34:56.302238+04:30	49	sara	2	[{"changed": {"fields": ["Bio", "Inp start"]}}]	23	1
926	2025-08-18 21:34:57.607054+04:30	56	thread1	1	[{"added": {}}]	4	1
927	2025-08-20 04:10:57.680728+04:30	52	maryam	2	[{"changed": {"fields": ["Email address"]}}]	4	1
928	2025-08-20 04:11:20.719046+04:30	2	Olivia	2	[{"changed": {"fields": ["Email address"]}}]	4	1
929	2025-08-20 04:11:57.317139+04:30	53	Adele	2	[{"changed": {"fields": ["Email address"]}}]	4	1
930	2025-08-20 04:12:52.483295+04:30	49	katy	2	[{"changed": {"fields": ["Email address"]}}]	4	1
931	2025-08-20 04:31:48.921295+04:30	1	Conversational Spanish Speaking (Student: €45/h, Tutor: €32/h)	1	[{"added": {}}]	74	1
932	2025-08-20 04:32:55.499103+04:30	1	Request #1 by Adele for Conversational Spanish Speaking	1	[{"added": {}}]	75	1
933	2025-08-20 04:36:09.417195+04:30	2	Piano ordinary class (Student: €60/h, Tutor: €42/h)	1	[{"added": {}}]	74	1
934	2025-08-20 04:38:26.783051+04:30	2	Request #2 by sara for Piano ordinary class	1	[{"added": {}}]	75	1
935	2025-08-20 05:19:46.408878+04:30	3	Physics for school (Student: €55/h, Tutor: €38.5/h)	1	[{"added": {}}]	74	1
936	2025-08-20 05:22:52.406516+04:30	3	Request #3 by maryam for Physics for school	1	[{"added": {}}]	75	1
937	2025-08-20 05:34:37.495845+04:30	10	britny	2	[{"changed": {"fields": ["Status"]}}]	35	1
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 937, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_content_type_id_seq', 75, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-05-18 15:42:13.057667+04:30
2	auth	0001_initial	2025-05-18 15:42:13.161673+04:30
3	admin	0001_initial	2025-05-18 15:42:13.195675+04:30
4	admin	0002_logentry_remove_auto_add	2025-05-18 15:42:13.212676+04:30
5	admin	0003_logentry_add_action_flag_choices	2025-05-18 15:42:13.227677+04:30
6	app_pages	0001_initial	2025-05-18 15:42:13.244678+04:30
7	app_pages	0002_contactus	2025-05-18 15:42:13.260679+04:30
8	app_pages	0003_contactus_is_read	2025-05-18 15:42:13.276679+04:30
9	app_pages	0004_cfboolean_cfdatetime_cfdecimal_cffile_cfimage_cftext_cfurl	2025-05-18 15:42:13.364684+04:30
10	app_pages	0005_cfinteger	2025-05-18 15:42:13.385686+04:30
11	app_pages	0006_cfchar_cfemail_cffloat	2025-05-18 15:42:13.429688+04:30
12	app_pages	0007_auto_20250321_0036	2025-05-18 15:42:13.46269+04:30
13	app_pages	0008_page	2025-05-18 15:42:13.497692+04:30
14	app_pages	0009_auto_20250322_1900	2025-05-18 15:42:13.537694+04:30
15	app_pages	0010_alter_page_content	2025-05-18 15:42:13.545695+04:30
16	app_pages	0011_contactus_message2	2025-05-18 15:42:13.560696+04:30
17	app_pages	0012_remove_contactus_message2	2025-05-18 15:42:13.570696+04:30
18	contenttypes	0002_remove_content_type_name	2025-05-18 15:42:13.608698+04:30
19	auth	0002_alter_permission_name_max_length	2025-05-18 15:42:13.626699+04:30
20	auth	0003_alter_user_email_max_length	2025-05-18 15:42:13.648701+04:30
21	auth	0004_alter_user_username_opts	2025-05-18 15:42:13.664702+04:30
22	auth	0005_alter_user_last_login_null	2025-05-18 15:42:13.681703+04:30
23	auth	0006_require_contenttypes_0002	2025-05-18 15:42:13.687703+04:30
24	auth	0007_alter_validators_add_error_messages	2025-05-18 15:42:13.702704+04:30
25	auth	0008_alter_user_username_max_length	2025-05-18 15:42:13.723705+04:30
26	auth	0009_alter_user_last_name_max_length	2025-05-18 15:42:13.741706+04:30
27	auth	0010_alter_group_name_max_length	2025-05-18 15:42:13.761707+04:30
28	auth	0011_update_proxy_permissions	2025-05-18 15:42:13.782708+04:30
29	auth	0012_alter_user_first_name_max_length	2025-05-18 15:42:13.796709+04:30
30	sessions	0001_initial	2025-05-18 15:42:13.81671+04:30
31	ap2_meeting	0001_initial	2025-05-18 15:43:32.991239+04:30
32	app_accounts	0001_initial	2025-05-18 15:43:33.212252+04:30
33	ap2_tutor	0001_initial	2025-05-18 15:43:33.581273+04:30
34	ap2_student	0001_initial	2025-05-18 15:43:33.801285+04:30
35	app_admin	0001_initial	2025-05-18 15:43:33.857288+04:30
36	app_blog	0001_initial	2025-05-18 15:43:34.077301+04:30
37	app_content_filler	0001_initial	2025-05-18 15:43:34.244311+04:30
38	app_staff	0001_initial	2025-05-18 15:43:34.312314+04:30
39	app_accounts	0002_auto_20250520_0316	2025-05-20 03:16:13.192417+04:30
40	app_accounts	0003_userskill_is_notified	2025-05-20 13:35:16.77854+04:30
41	ap2_tutor	0002_rename_interviewer_comment_providerapplication_reviewer_comment	2025-05-21 18:32:02.463209+04:30
42	app_accounts	0004_auto_20250522_0026	2025-05-22 00:26:35.053003+04:30
43	app_accounts	0005_alter_skill_category	2025-05-22 00:40:26.939584+04:30
44	app_accounts	0006_alter_skill_category	2025-05-22 00:40:26.999587+04:30
45	app_accounts	0007_alter_skill_category	2025-05-22 00:42:12.81364+04:30
46	app_accounts	0008_auto_20250525_1641	2025-05-25 16:41:31.29809+04:30
47	app_accounts	0009_usereducation	2025-05-26 01:37:18.080447+04:30
48	app_accounts	0010_auto_20250526_1432	2025-05-26 14:32:12.923691+04:30
49	ap2_tutor	0003_alter_providerapplication_status	2025-05-29 12:35:17.879666+04:30
50	ap2_tutor	0004_degreelevel_education_studentlevel_teachingcertificate_teachingexperience_tutorresume_tutorstudentle	2025-06-16 01:58:36.588987+04:30
51	ap2_tutor	0005_auto_20250617_0010	2025-06-17 00:10:24.221212+04:30
52	ap2_tutor	0006_auto_20250617_0126	2025-06-17 01:26:15.408758+04:30
53	ap2_tutor	0007_rename_teaching_category_subteachingcategory_category	2025-06-18 23:35:08.41852+04:30
54	ap2_tutor	0004_degreelevel_education_teachingcategory_teachingcertificate	2025-06-20 16:16:23.627671+04:30
55	ap2_tutor	0005_auto_20250620_1616	2025-06-20 16:18:46.376836+04:30
56	ap2_tutor	0006_teachingsubcategory	2025-06-20 16:47:56.88496+04:30
57	ap2_tutor	0004_auto_20250621_0045	2025-06-21 00:49:24.785731+04:30
58	ap2_tutor	0005_auto_20250621_0050	2025-06-21 00:53:40.075333+04:30
59	ap2_tutor	0006_auto_20250621_0408	2025-06-21 04:08:08.862814+04:30
60	app_accounts	0009_auto_20250621_0413	2025-06-21 04:13:11.889146+04:30
61	ap2_tutor	0002_auto_20250622_0106	2025-06-22 01:11:28.739362+04:30
62	ap2_tutor	0003_teachingcertificate_completion_date	2025-06-22 03:42:29.000453+04:30
63	app_accounts	0010_auto_20250622_0339	2025-06-22 03:42:29.157462+04:30
64	ap2_tutor	0004_auto_20250625_0233	2025-06-25 02:33:57.88979+04:30
65	app_accounts	0011_auto_20250625_0233	2025-06-25 02:33:58.0588+04:30
66	ap2_tutor	0005_auto_20250625_1843	2025-06-25 18:43:34.051428+04:30
67	app_accounts	0012_auto_20250625_1843	2025-06-25 18:43:34.240439+04:30
68	ap2_tutor	0006_alter_teachingcertificate_name	2025-06-27 00:34:40.26783+04:30
69	app_accounts	0013_auto_20250627_0034	2025-06-27 00:34:40.906866+04:30
70	app_accounts	0014_alter_userprofile_gender	2025-06-27 03:22:44.255192+04:30
71	ap2_tutor	0007_rename_is_verified_teachingcertificate_is_certified	2025-06-27 22:31:07.681014+04:30
72	app_accounts	0015_auto_20250628_1851	2025-06-28 18:51:23.552415+04:30
73	ap2_tutor	0008_auto_20250629_0421	2025-06-29 04:21:33.286088+04:30
74	app_accounts	0016_auto_20250706_2318	2025-07-06 23:18:43.094846+04:30
75	app_accounts	0017_userprofile_terms_agreed_ip	2025-07-09 14:46:30.245274+04:30
76	app_accounts	0018_loginiplog_userconsentlog	2025-07-10 03:17:04.051207+04:30
77	app_accounts	0019_remove_userprofile_terms_agreed_ip	2025-07-10 03:17:04.10321+04:30
78	app_accounts	0020_auto_20250715_1957	2025-07-15 19:57:59.829147+04:30
79	app_accounts	0021_auto_20250718_2133	2025-07-18 21:34:29.28968+04:30
80	app_accounts	0022_auto_20250719_0043	2025-07-19 00:43:37.953938+04:30
81	ap2_meeting	0002_alter_appointmentsetting_timezone	2025-07-19 02:52:26.054017+04:30
82	ap2_tutor	0009_alter_providerapplication_timezone	2025-07-19 02:54:25.429244+04:30
83	ap2_student	0002_alter_student_profile	2025-07-21 13:56:40.263449+04:30
84	app_pages	0013_articlefeedback_helparticle_helpcategory_helpsection	2025-07-21 13:56:40.509463+04:30
85	app_pages	0014_auto_20250721_1702	2025-07-21 17:02:10.890848+04:30
86	app_pages	0015_alter_helpsection_options	2025-07-21 17:25:59.568564+04:30
87	app_accounts	0023_auto_20250724_1345	2025-07-24 13:45:18.3885+04:30
88	app_marketing	0001_initial	2025-07-26 14:27:11.488726+04:30
89	app_accounts	0024_auto_20250727_1318	2025-07-27 13:18:50.699346+04:30
90	ap2_tutor	0010_auto_20250728_1545	2025-07-28 15:46:03.674974+04:30
91	app_accounts	0025_auto_20250728_1545	2025-07-28 15:46:03.773979+04:30
92	app_accounts	0026_alter_userskill_user	2025-08-01 14:44:23.797522+04:30
93	app_accounts	0027_auto_20250802_1532	2025-08-02 15:32:37.885309+04:30
94	app_accounts	0028_auto_20250812_0210	2025-08-12 02:10:18.490779+04:30
95	app_accounts	0029_userprofile_teaching_radius	2025-08-12 02:26:35.967688+04:30
96	app_accounts	0030_auto_20250812_0318	2025-08-12 03:18:41.520459+04:30
97	app_accounts	0031_auto_20250812_1311	2025-08-12 13:11:08.283695+04:30
98	app_accounts	0032_auto_20250812_1840	2025-08-12 18:40:27.522454+04:30
99	app_accounts	0033_auto_20250813_0158	2025-08-13 01:58:27.285625+04:30
100	app_accounts	0034_auto_20250814_1919	2025-08-14 19:20:02.99528+04:30
101	app_accounts	0035_auto_20250818_0103	2025-08-18 01:03:18.437687+04:30
102	app_accounts	0036_auto_20250818_0212	2025-08-18 02:13:05.501173+04:30
103	messenger	0001_initial	2025-08-18 17:36:15.145363+04:30
104	app_in_person	0001_initial	2025-08-20 04:09:02.814158+04:30
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_migrations_id_seq', 104, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
xysw57xkfrzd62bwknvn4kbwplvmrqw5	.eJxVjEEOwiAQRe_C2hCgzFBcuvcMhBlAqoYmpV0Z765NutDtf-_9lwhxW2vYel7ClMRZaHH63SjyI7cdpHtst1ny3NZlIrkr8qBdXueUn5fD_TuosddvDaSzyQ6NL8biADTS6Bx7FxNGBOUHDwo1s03AiJYNgufiiNEUpVG8P8g1Nyk:1uGbxz:IeUaCVXLFj2fJ0B8jIBDyqVf5PAgmLh2KDEiaqSC_V0	2025-06-01 15:44:03.25597+04:30
s0tv50m5zsd2p7w1490njrqu1417jv2q	.eJxVjMsOwiAURP-FtSFAL1S6dO83EB4Xixow0CYa479bki50NcnMmfMmxq7LbNaG1aRAJiI5OfyWzvob5r6Eq82XQn3JS02OdoTua6PnEvB-2tk_wWzbvL0HJgDGaHn03AYmhYoetfIgZGSgnZZKa35UWwbvghqBOxgiCg0RpVRd2rC1VLLB5yPVF5nY5wuYQD7N:1umuku:XoZp_mz7GboGs67sq1lPfiDo19-W0fPzM6VY-lFmN3o	2025-08-29 18:16:04.012091+04:30
56hl6ld7sa51olbglxttk53szwm64mtm	e30:1ugoVQ:VXd-8DMF3-9NK0IPGHMA916n2uwqhf3GTA9tSjppWMs	2025-08-12 22:22:52.630163+04:30
v4ow608mgcp139xax3ubrmo96l26jj9t	.eJxVjEEOgjAQRe_StWlKgWlh6d4zNDN0kKppSQuJxnh3IWGh2__ef2_hcF0mtxbOLnjRCy1OvxvhcOe4A3_DeE1ySHHJgeSuyIMWeUmeH-fD_QtMWKbtjdYarBs2RgPZSpMeoUML6DutgMgAtsp7o2lAgNaormkq5HEDdU0t79HCpYQUHT_nkF-iV58veUc-5g:1ugoWr:hHZayynckwD5lNUESXZK4s0EBdXXDpyFCmDub3eIwaw	2025-08-12 22:24:21.024022+04:30
f2teb1w9wx008emfelet5y4wkp7ck87c	.eJxVjEEOgjAQRe_StWlKgWlh6d4zNDN0kKppSQuJxnh3IWGh2__ef2_hcF0mtxbOLnjRCy1OvxvhcOe4A3_DeE1ySHHJgeSuyIMWeUmeH-fD_QtMWKbtjdYarBs2RgPZSpMeoUML6DutgMgAtsp7o2lAgNaormkq5HEDdU0t79HCpYQUHT_nkF-iV58veUc-5g:1ugoXo:cc2hPRnkIo4O_Ims8xRAQt45_wwiXPsf6g2RoSXSn7k	2025-08-12 22:25:20.43142+04:30
slqv7ru6sfspr459oir25zxb23yz2ye4	e30:1ugoY5:LQP_2Y1c74Du22sis9WEJyZe01FDrl69zvDdPyY_7us	2025-08-12 22:25:37.589401+04:30
yfaknmp1l7pd737ijo8lkvrotm53ywxj	.eJxVjMsOgyAQRf-FtTEKCuiy-34DmYGx9gXNAKum_15NXLTbe849b-GgltXVTOyuQcxCiuZ3Q_B3ijsIN4iX1PoUC1-x3ZX2oLk9p0CP0-H-BVbI6_YGaw2ogYyRGm0vUS56AqshTLLTiEbD2IVgJHrQejTdNAw90LIBpXCkLbokfjpiTpzFXLhSI3xlplhcLvQSs_p8AZjgRL4:1uL1bH:iUkEbCVJe7o4resS7EVAcNf_cv8FWqsDLju0F1jZArU	2025-06-13 19:54:51.590733+04:30
9selm0la05xott2ab4z8ic0irehpxhjo	.eJxVjEEOwiAQRe_C2hCgzFBcuvcMhBlAqoYmpV0Z765NutDtf-_9lwhxW2vYel7ClMRZaHH63SjyI7cdpHtst1ny3NZlIrkr8qBdXueUn5fD_TuosddvDaSzyQ6NL8biADTS6Bx7FxNGBOUHDwo1s03AiJYNgufiiNEUpVG8P8g1Nyk:1uM5Az:IJ2EFE08wqc0IFhE5IxOS30EH4f5UrJeAHxPN026lZQ	2025-06-16 17:56:05.628275+04:30
8p9m0kslh3vd6e7huui498a2ux4es999	e30:1ugoZI:io26Na2HAA6DBa_z5zFOepBtj6xDyFB3Xc11ue43PVM	2025-08-12 22:26:52.695697+04:30
8099d5c98h3s85eb0v4o7seto0i6yl1c	.eJxVjDsOwyAQBe9CHSHMZ4GU6X0GtAs4OIlAMnYV5e6xJRdJ-2bmvVnAbS1h63kJc2JXJtnldyOMz1wPkB5Y743HVtdlJn4o_KSdjy3l1-10_w4K9rLX6JxFpbO1EsgNkuQEHh1g8lIAkQU0IiUrKSKAscJrPWCedqAUmcw-X9W9N6k:1uQRL8:QRqU12v9bUWEv1d6wYYCer98p1E1LbZO5AZndRUbIA8	2025-06-28 18:24:34.307636+04:30
6uum4js4vfhnwa7n7mk0l8hjtakpzmct	e30:1ugoZI:io26Na2HAA6DBa_z5zFOepBtj6xDyFB3Xc11ue43PVM	2025-08-12 22:26:52.877707+04:30
7mfk707d428rbyg76e4kl726v3xtkyq3	e30:1ugoZc:68HA6fGaKjWST-_qE2Mfg3U2xQplHFYGZPFlT6vI-ZA	2025-08-12 22:27:12.293817+04:30
pk1j10497ykvqtieloufnjx5qkdftv4v	.eJxVjEEOgjAQRe_StWlKgWlh6d4zNDN0kKppSQuJxnh3IWGh2__ef2_hcF0mtxbOLnjRCy1OvxvhcOe4A3_DeE1ySHHJgeSuyIMWeUmeH-fD_QtMWKbtjdYarBs2RgPZSpMeoUML6DutgMgAtsp7o2lAgNaormkq5HEDdU0t79HCpYQUHT_nkF-iV58veUc-5g:1ugobm:Kn71Rk6x7JBOmktXjnzXmKNa6UzTfCn5Z75LSVXdN7M	2025-08-12 22:29:26.180879+04:30
2qt72bdhgvc60hni5g78b68w4u6f0atk	.eJxVjEEOgjAQRe_StWlKgWlh6d4zNDN0kKppSQuJxnh3IWGh2__ef2_hcF0mtxbOLnjRCy1OvxvhcOe4A3_DeE1ySHHJgeSuyIMWeUmeH-fD_QtMWKbtjdYarBs2RgPZSpMeoUML6DutgMgAtsp7o2lAgNaormkq5HEDdU0t79HCpYQUHT_nkF-iV58veUc-5g:1uh1H4:RyRvHsdsuNy4c6EsCRn0K6ZbIzK8vyoSxqp16vBldlU	2025-08-13 12:00:54.007978+04:30
wb2xtdb90acawxe4mcku2vcdznw9kwy3	.eJxVjEEOwiAQRe_C2hCgzFBcuvcMhBlAqoYmpV0Z765NutDtf-_9lwhxW2vYel7ClMRZaHH63SjyI7cdpHtst1ny3NZlIrkr8qBdXueUn5fD_TuosddvDaSzyQ6NL8biADTS6Bx7FxNGBOUHDwo1s03AiJYNgufiiNEUpVG8P8g1Nyk:1uhAHQ:FOFtP1eNyGqUbIRH0pG29Ipp9ctKjBiLG1j5QPo_oJQ	2025-08-13 21:37:52.431737+04:30
fxd99s83s4o5as45v6jrgl6o5hb77i5t	.eJxVjEEOgjAQRe_StWlKgWnL0r1naGboIFXTEgqJxnh3IWGh2__ef2_hcV1GvxaefQyiE1qcfjfC_s5pB-GG6Zpln9MyR5K7Ig9a5CUHfpwP9y8wYhm3N1prsG7YGA1kK016AIcWMDitgMgAtioEo6lHgNYo1zQV8rCBuqaW92jhUmJOnp9TnF-iq7RyoNTnC_U3QBg:1uhijw:p-JqVb2hWhLJJT7m70i84UcqeIaouEN50yTKRgLVYmY	2025-08-15 10:25:36.20662+04:30
z8kmcjckjztnaa2o8k0rmjrjv3yqbfc1	.eJxVjEEOwiAQRe_C2hCgzFBcuvcMhBlAqoYmpV0Z765NutDtf-_9lwhxW2vYel7ClMRZaHH63SjyI7cdpHtst1ny3NZlIrkr8qBdXueUn5fD_TuosddvDaSzyQ6NL8biADTS6Bx7FxNGBOUHDwo1s03AiJYNgufiiNEUpVG8P8g1Nyk:1uc5G2:Qegy7Wy_aRmLgqn8dEUQwUqsgNELUkX8ipk7w0V6BLA	2025-07-30 21:15:26.806458+04:30
9nmmxweudmx5esuponund1zwjzpmezcd	.eJxVjEEOwiAQRe_C2hCgzFBcuvcMhBlAqoYmpV0Z765NutDtf-_9lwhxW2vYel7ClMRZaHH63SjyI7cdpHtst1ny3NZlIrkr8qBdXueUn5fD_TuosddvDaSzyQ6NL8biADTS6Bx7FxNGBOUHDwo1s03AiJYNgufiiNEUpVG8P8g1Nyk:1uho8v:30YuxrCdd421BWk9v1Kd_PyrTN_60e6M3_LaLV8nc24	2025-08-15 16:11:45.535402+04:30
fpdkjfait447zfmlmhkkg3fhbbs936fh	e30:1ucLvV:DQmEJFeso_9VhynRM2ArwcYLobL2oXma9HLVZIh0Pek	2025-07-31 15:03:21.951137+04:30
x3fk2vhw36ek1wlawjaalm6xbybqm4ri	.eJxVjEEOwiAQRe_C2hCh00G6dO8ZyACDRQ2Y0iYa4921SRe6_e_99xKOlnl0S-PJ5SgGoTux-x09hSuXlcQLlXOVoZZ5yl6uitxok6ca-Xbc3L_ASG38vg0kf9BggkIEVIkSo9JkjAraAoLFFKDvLHsw2gNZpQCsjjZ5jL7v12jj1nItjh_3PD3FsH9_AIg1Ppk:1ucTQQ:SHzqGd4Yl80DhkAkRQ03NzfWIvUGutI6u0oO0VTEk6Y	2025-07-31 23:03:46.27245+04:30
r8dg6ech8sitau46qt2l7jkokdsb8zg4	.eJxVjEEOgjAQRe_StWlKgWlh6d4zNDN0kKppSQuJxnh3IWGh2__ef2_hcF0mtxbOLnjRCy1OvxvhcOe4A3_DeE1ySHHJgeSuyIMWeUmeH-fD_QtMWKbtjdYarBs2RgPZSpMeoUML6DutgMgAtsp7o2lAgNaormkq5HEDdU0t79HCpYQUHT_nkF-iV58veUc-5g:1uivKV:jVbFi3H_x9kheCHchJhwEzVI65lnZqLg3HiCUNOkyUI	2025-08-18 18:04:19.137999+04:30
x2bzanzxxe0e1w3o2dvqvk556aiji9sz	.eJxVjEEOwiAQRe_C2hDKAMUu3XsGwjCjRQ2Y0iYa4921SRe6_e_99xIhLvMYlsZTyCQGoY3Y_Y4Y05XLSugSy7nKVMs8ZZSrIjfa5LES3w6b-xcYYxu_b68JDTBAZ7WLKUUE9Io6d1LsgXprwew1k3ekHWjT2R57y-g9KucJ1mjj1nItgR_3PD3FoN4fm6Q-sw:1ucVg6:XOQONAp9XlLH4M_V6yv0QIfpRlP-ZL5FYiZ8lsYHkxk	2025-08-01 01:28:06.564285+04:30
620qyem6bhrvlmbvud0huxw2kppq4mc3	.eJxVjsEOwiAQRP-FsyELKSX06N1vILuwWNSAKW1SY_x3relBr_PeTOYpPC7z6JfGk89RDMKAOPyGhOHKZSPxguVcZahlnjLJTZE7bfJUI9-Ou_s3MGIbP21LKakeEhjtOhcw9Q4SOa2cJlJE2kJwDqLujbFMBm3ijlEFi8po-L5q3FquxfN6z9NDDPB6A7JgPzY:1ul8gc:YTC6FGNu5YgieS1p2UDvzWaD3uuVsjzgJQ5hFUQBLWU	2025-08-24 20:44:18.887065+04:30
4n5xo34i4ca7ugrk7pctto1288gq94qw	.eJxVjsEOwiAQRP-FsyELKSX06N1vILuwWNSAKW1SY_x3relBr_PeTOYpPC7z6JfGk89RDMKAOPyGhOHKZSPxguVcZahlnjLJTZE7bfJUI9-Ou_s3MGIbP21LKakeEhjtOhcw9Q4SOa2cJlJE2kJwDqLujbFMBm3ijlEFi8po-L5q3FquxfN6z9NDDPB6A7JgPzY:1ulRvV:qCGQIMwS-m21UuE3c0GCq9km8XRLLVGIl5_TJT4bkDI	2025-08-25 17:16:57.56447+04:30
6lgrn03xc7jx74hcrkbxpu2ept00d40n	e30:1udQoQ:3YKdwlU2gJAqlpprP-UNP0Q7EeOJvPMYELK9d0BYSvw	2025-08-03 14:28:30.863718+04:30
xh11qjf48xzvyouggwy1a4btlo5odpyu	.eJxVjsEOwiAQRP-FsyELEcj26N1vICwsFjVgSptojP-uNT3odd6byTyFD8s8-qXz5EsSgzAgdr8hhXjhupJ0DvXUZGx1ngrJVZEb7fLYEl8Pm_s3MIY-ftqOclYWMhiNe4whW4RMqBVqIkWkHURESNoa45hMcJn3HFR0QRkN31edey-ter7fyvQQg9KAFuD1BjA_QGg:1umXtC:gk9oBuUC6VPiGe4OWZAVycGmuHbyjh-0FqDPXsUTnoI	2025-08-28 17:51:06.459272+04:30
2r8p6a4ft37sf3dcmvl23bvno9wgzmj1	.eJxVjEEOgjAQRe_StWlKgWlh6d4zNDN0kKppSQuJxnh3IWGh2__ef2_hcF0mtxbOLnjRCy1OvxvhcOe4A3_DeE1ySHHJgeSuyIMWeUmeH-fD_QtMWKbtjdYarBs2RgPZSpMeoUML6DutgMgAtsp7o2lAgNaormkq5HEDdU0t79HCpYQUHT_nkF-iV58veUc-5g:1udQqk:WXI8TpbzNDLSYSfX7VO7OQu812zKaSq-jgftG2OEYHU	2025-08-03 14:30:54.983961+04:30
uzu6cg2ker180bevx4wtybgyfyqavpxp	.eJxVjMEOwiAQBf-FsyFAYSk9evcbCCxbixowpU00xn_XJj3o9c28eTEf1mXya6PZ58QGJtnhd4sBr1Q2kC6hnCvHWpY5R74pfKeNn2qi23F3_wJTaNP3baIkRRaUG5WGzsQ-9taisyFBACNc54wAiaiTQQCNCozD0UYENQoJW7RRa7kWT497np9skEo4EOL9AdqvP5g:1umu3b:zcwetUlXbTv4PyYKLco9GV7_ijDGo6kN2IbvwcDCtSM	2025-08-29 17:31:19.154526+04:30
\.


--
-- Data for Name: messenger_thread; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messenger_thread (id, created_at, updated_at, is_active) FROM stdin;
\.


--
-- Data for Name: messenger_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messenger_message (id, content, is_read, sent_at, read_at, recipient_id, sender_id, thread_id) FROM stdin;
\.


--
-- Name: messenger_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('messenger_message_id_seq', 1, false);


--
-- Name: messenger_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('messenger_thread_id_seq', 1, false);


--
-- Data for Name: messenger_thread_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messenger_thread_participants (id, thread_id, user_id) FROM stdin;
\.


--
-- Name: messenger_thread_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('messenger_thread_participants_id_seq', 1, false);


--
-- Data for Name: messenger_usermessagesettings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messenger_usermessagesettings (id, email_notifications, push_notifications, allow_messages_from, user_id) FROM stdin;
\.


--
-- Data for Name: messenger_usermessagesettings_blocked_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messenger_usermessagesettings_blocked_users (id, usermessagesettings_id, user_id) FROM stdin;
\.


--
-- Name: messenger_usermessagesettings_blocked_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('messenger_usermessagesettings_blocked_users_id_seq', 1, false);


--
-- Name: messenger_usermessagesettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('messenger_usermessagesettings_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

