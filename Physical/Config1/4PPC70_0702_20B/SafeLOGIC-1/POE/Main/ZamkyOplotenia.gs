[LIT]
49
128	296	34	296	33
129	296	33	298	33
139	334	33	342	33
140	342	33	351	33
141	342	49	361	49
142	342	33	342	49
143	71	34	85	34
144	85	41	94	41
145	85	34	85	41
146	148	68	148	38
147	72	68	84	68
148	84	68	148	68
149	84	75	95	75
150	84	68	84	75
151	153	104	153	42
152	73	104	85	104
153	85	104	153	104
154	85	111	96	111
155	85	104	85	111
156	158	143	158	46
157	74	143	87	143
158	87	143	158	143
159	87	151	99	151
160	87	143	87	151
161	164	178	164	50
162	71	178	87	178
163	87	178	164	178
164	87	185	100	185
165	87	178	87	185
166	169	216	169	54
167	72	216	86	216
168	86	216	169	216
169	86	224	103	224
170	86	216	86	224
175	169	54	189	54
176	164	50	189	50
177	158	46	189	46
178	153	42	189	42
179	148	38	189	38
180	85	34	189	34
185	279	34	296	34
186	245	34	266	34
187	202	34	233	34
191	222	82	231	82
192	231	82	231	38
193	231	38	233	38
194	256	51	265	51
195	265	51	265	38
196	265	38	266	38

[TET]
38
10	20	29	28	31	4	5	TRUE
11	0	33	28	35	4	5	siServisneDvere1_KanalA
12	0	37	28	39	4	5	siServisneDvere1_KanalB
13	12	41	28	43	4	5	TIME#200ms
21	121	40	145	42	4	3	Stav_BZ1_Zamknuty
87	21	63	29	65	4	5	TRUE
88	22	99	30	101	4	5	TRUE
89	23	138	31	140	4	5	TRUE
90	20	173	28	175	4	5	TRUE
91	21	211	29	213	4	5	TRUE
92	13	75	29	77	4	5	TIME#200ms
93	14	111	30	113	4	5	TIME#200ms
94	15	150	31	152	4	5	TIME#200ms
95	12	185	28	187	4	5	TIME#200ms
96	13	223	29	225	4	5	TIME#200ms
101	122	74	146	76	4	3	Stav_BZ2_Zamknuty
102	123	110	147	112	4	3	Stav_BZ3_Zamknuty
103	126	150	150	152	4	3	Stav_BZ4_Zamknuty
104	127	184	151	186	4	3	Stav_BZ5_Zamknuty
105	130	223	154	225	4	3	Stav_BZ6_Zamknuty
106	1	67	29	69	4	5	siServisneDvere2_KanalA
107	1	71	29	73	4	5	siServisneDvere2_KanalB
108	2	103	30	105	4	5	siServisneDvere3_KanalA
109	2	107	30	109	4	5	siServisneDvere3_KanalB
110	3	142	31	144	4	5	siServisneDvere4_KanalA
111	3	146	31	148	4	5	siServisneDvere4_KanalB
112	0	177	28	179	4	5	siServisneDvere5_KanalA
113	0	181	28	183	4	5	siServisneDvere5_KanalB
114	1	215	29	217	4	5	siServisneDvere6_KanalA
115	1	219	29	221	4	5	siServisneDvere6_KanalB
127	290	28	298	30	4	5	TRUE
130	284	36	298	38	4	5	SAFEFALSE
131	284	40	298	42	4	5	SAFEFALSE
132	280	44	298	46	4	5	ResetOplotenia
133	235	50	256	52	4	5	OkruhCS_Aktivny
134	351	32	377	34	4	3	OkruhZamkov_Aktivny
138	388	48	424	50	4	3	BezpOkruhOplotenia_Aktivovany
197	180	81	195	83	4	5	RezimServis

[FBS]
18
8	30	26	69	46	0	SF_Equivalent_V1_00	StavDveri_1
17	191	30	200	62	1	AND_S	
20	96	37	119	45	1	SAFEBOOL_TO_BOOL	
24	97	71	120	79	1	SAFEBOOL_TO_BOOL	
27	98	107	121	115	1	SAFEBOOL_TO_BOOL	
30	101	147	124	155	1	SAFEBOOL_TO_BOOL	
33	102	181	125	189	1	SAFEBOOL_TO_BOOL	
36	105	220	128	228	1	SAFEBOOL_TO_BOOL	
45	31	60	70	80	0	SF_Equivalent_V1_00	StavDveri_2
55	32	96	71	116	0	SF_Equivalent_V1_00	StavDveri_3
65	33	135	72	155	0	SF_Equivalent_V1_00	StavDveri_4
75	30	170	69	190	0	SF_Equivalent_V1_00	StavDveri_5
85	31	208	70	228	0	SF_Equivalent_V1_00	StavDveri_6
125	300	25	332	49	0	SF_EmergencyStop_V1_00	BezpecnostnyOkruhZamky
137	363	45	386	53	1	SAFEBOOL_TO_BOOL	
174	268	30	277	42	1	AND_S	
184	235	30	243	42	1	OR_S	
190	197	78	220	86	1	BOOL_TO_SAFEBOOL	

[FPT]
86
0	30	29	41	31	Activate	0	128	0	BOOL
1	30	33	45	35	S_ChannelA	0	128	0	SAFEBOOL
2	30	37	45	39	S_ChannelB	0	128	0	SAFEBOOL
3	30	41	50	43	DiscrepancyTime	0	128	0	TIME
4	61	29	69	31	Ready	1	0	128	BOOL
5	50	33	69	35	S_EquivalentOut	1	0	128	SAFEBOOL
6	62	37	69	39	Error	1	0	128	BOOL
7	57	41	69	43	DiagCode	1	0	128	WORD
14	191	33	193	35		0	1665	0	ANY_SAFEBIT
15	191	37	193	39		0	1665	0	ANY_SAFEBIT
16	199	33	200	35		1	0	643	ANY_SAFEBIT
18	96	40	98	42		0	640	0	SAFEBOOL
19	118	40	119	42		1	0	640	BOOL
22	97	74	99	76		0	640	0	SAFEBOOL
23	119	74	120	76		1	0	640	BOOL
25	98	110	100	112		0	640	0	SAFEBOOL
26	120	110	121	112		1	0	640	BOOL
28	101	150	103	152		0	640	0	SAFEBOOL
29	123	150	124	152		1	0	640	BOOL
31	102	184	104	186		0	640	0	SAFEBOOL
32	124	184	125	186		1	0	640	BOOL
34	105	223	107	225		0	640	0	SAFEBOOL
35	127	223	128	225		1	0	640	BOOL
37	31	63	42	65	Activate	0	128	0	BOOL
38	31	67	46	69	S_ChannelA	0	128	0	SAFEBOOL
39	31	71	46	73	S_ChannelB	0	128	0	SAFEBOOL
40	31	75	51	77	DiscrepancyTime	0	128	0	TIME
41	62	63	70	65	Ready	1	0	128	BOOL
42	51	67	70	69	S_EquivalentOut	1	0	128	SAFEBOOL
43	63	71	70	73	Error	1	0	128	BOOL
44	58	75	70	77	DiagCode	1	0	128	WORD
47	32	99	43	101	Activate	0	128	0	BOOL
48	32	103	47	105	S_ChannelA	0	128	0	SAFEBOOL
49	32	107	47	109	S_ChannelB	0	128	0	SAFEBOOL
50	32	111	52	113	DiscrepancyTime	0	128	0	TIME
51	63	99	71	101	Ready	1	0	128	BOOL
52	52	103	71	105	S_EquivalentOut	1	0	128	SAFEBOOL
53	64	107	71	109	Error	1	0	128	BOOL
54	59	111	71	113	DiagCode	1	0	128	WORD
57	33	138	44	140	Activate	0	128	0	BOOL
58	33	142	48	144	S_ChannelA	0	128	0	SAFEBOOL
59	33	146	48	148	S_ChannelB	0	128	0	SAFEBOOL
60	33	150	53	152	DiscrepancyTime	0	128	0	TIME
61	64	138	72	140	Ready	1	0	128	BOOL
62	53	142	72	144	S_EquivalentOut	1	0	128	SAFEBOOL
63	65	146	72	148	Error	1	0	128	BOOL
64	60	150	72	152	DiagCode	1	0	128	WORD
67	30	173	41	175	Activate	0	128	0	BOOL
68	30	177	45	179	S_ChannelA	0	128	0	SAFEBOOL
69	30	181	45	183	S_ChannelB	0	128	0	SAFEBOOL
70	30	185	50	187	DiscrepancyTime	0	128	0	TIME
71	61	173	69	175	Ready	1	0	128	BOOL
72	50	177	69	179	S_EquivalentOut	1	0	128	SAFEBOOL
73	62	181	69	183	Error	1	0	128	BOOL
74	57	185	69	187	DiagCode	1	0	128	WORD
77	31	211	42	213	Activate	0	128	0	BOOL
78	31	215	46	217	S_ChannelA	0	128	0	SAFEBOOL
79	31	219	46	221	S_ChannelB	0	128	0	SAFEBOOL
80	31	223	51	225	DiscrepancyTime	0	128	0	TIME
81	62	211	70	213	Ready	1	0	128	BOOL
82	51	215	70	217	S_EquivalentOut	1	0	128	SAFEBOOL
83	63	219	70	221	Error	1	0	128	BOOL
84	58	223	70	225	DiagCode	1	0	128	WORD
97	191	41	193	43		0	1665	0	ANY_SAFEBIT
98	191	45	193	47		0	1665	0	ANY_SAFEBIT
99	191	49	193	51		0	1665	0	ANY_SAFEBIT
100	191	53	193	55		0	1665	0	ANY_SAFEBIT
116	300	28	311	30	Activate	0	128	0	BOOL
117	300	32	314	34	S_EStopIn	0	128	0	SAFEBOOL
118	300	36	317	38	S_StartReset	0	128	0	SAFEBOOL
119	300	40	317	42	S_AutoReset	0	128	0	SAFEBOOL
120	300	44	309	46	Reset	0	128	0	BOOL
121	324	28	332	30	Ready	1	0	128	BOOL
122	317	32	332	34	S_EStopOut	1	0	128	SAFEBOOL
123	325	36	332	38	Error	1	0	128	BOOL
124	320	40	332	42	DiagCode	1	0	128	WORD
135	363	48	365	50		0	640	0	SAFEBOOL
136	385	48	386	50		1	0	640	BOOL
171	268	33	270	35		0	1665	0	ANY_SAFEBIT
172	268	37	270	39		0	1665	0	ANY_SAFEBIT
173	276	33	277	35		1	0	641	ANY_SAFEBIT
181	235	33	237	35		0	1665	0	ANY_SAFEBIT
182	235	37	237	39		0	1665	0	ANY_SAFEBIT
183	242	33	243	35		1	0	641	ANY_SAFEBIT
188	197	81	199	83		0	640	0	BOOL
189	219	81	220	83		1	0	640	SAFEBOOL

[KOT]
0

[VER]
0

