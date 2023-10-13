The search results list can be obtained in XML format by appending a URL parameter, "displayxml=true", to the end of a search request URL.
Example:   http://clinicaltrials.gov/search?term=%22lyme+disease%22&displayxml=true
By default, this option will return the first 20 search results. A parameter, "count=100", can be used to get the first 100 results. Another parameter, "start=101", can be used to get subsequent sets of studies.
In the following example, all three parameters are used to get results 1201-1400 out of more than 16,000 results found by a search of "cancer".
Example:   http://clinicaltrials.gov/search?term=%22cancer%22&displayxml=true&count=200&start=1201


For XML you add this parameter
&displayxml=true

Searching for polycythema like this:
http://www.clinicaltrials.gov/ct2/results?term=polycythemia&recr=&rslt=&type=&cond=&intr=&outc=&lead=&spons=&id=&state1=&cntry1=&state2=&cntry2=&state3=&cntry3=&locn=&gndr=&rcv_s=&rcv_e=&lup_s=&lup_e=&displayxml=true

<?xml version="1.0" encoding="UTF-8"?>
<search_results count="148">
	<query>polycythemia [ALL-FIELDS]</query>
		<clinical_study>
			<order>1</order>
			<score>0.95146</score>
			<nct_id>NCT00928707</nct_id>
			<url>http://ClinicalTrials.gov/show/NCT00928707</url>
			<title>Phase II Study of GIVINOSTAT (ITF2357) in Combination With Hydroxyurea in Polycythemia Vera</title>
			<status open="Y">Recruiting</status>
			<condition_summary>Polycythemia Vera</condition_summary>
			<last_changed>June 26, 2009</last_changed>
		</clinical_study>
		<clinical_study>
			<order>2</order>
			<score>0.95079</score>
			<nct_id>NCT00715247</nct_id>
			<url>http://ClinicalTrials.gov/show/NCT00715247</url>
			<title>Polycythemia Vera, Myelofibrosis and Essential Thrombocythemia: Identification of PV, MF &amp; ET Genes</title>
			<status open="Y">Recruiting</status>
			<condition_summary>Polycythemia Vera; Essential Thrombocythemia; Myelofibrosis</condition_summary>
			<last_changed>February 17, 2009</last_changed>
		</clinical_study>
</search_results>

Getting details like so:
http://www.clinicaltrials.gov/ct2/show/NCT00928707?term=polycythemia&rank=1&displayxml=true


<?xml version="1.0" encoding="UTF-8"?>
<clinical_study rank="1">
<required_header>
<download_date>Information obtained from ClinicalTrials.gov on September 10, 2009</download_date>
<link_text>Link to the current ClinicalTrials.gov record.</link_text>
<url>http://clinicaltrials.gov/show/NCT00928707</url>
</required_header>
<id_info>
<org_study_id>DSC/08/2357/38</org_study_id>
<nct_id>NCT00928707</nct_id>
</id_info>
<brief_title>Phase II Study of GIVINOSTAT (ITF2357) in Combination With Hydroxyurea in Polycythemia Vera</brief_title>
<acronym>PV</acronym>
<official_title>Phase II Study of the Histone-Deacetylase Inhibitor GIVINOSTAT (ITF2357) in Combination With Hydroxyurea in Patients With JAK2V617F Positive Polycythemia Vera Non-Responder to Hydroxyurea Monotherapy.</official_title>
<sponsors>
<lead_sponsor>
<agency>Italfarmaco</agency>
</lead_sponsor>
</sponsors>
<source>Italfarmaco</source>
<oversight_info>
<authority>Italy: Ministry of Health</authority>
<has_dmc>No</has_dmc>
</oversight_info>
<brief_summary>
<textblock>
This is a multicentre, randomized, open-label, phase II study testing GIVINOSTAT (ITF2357) in
combination with hydroxyurea in a population of patients with JAK2V617F positive Polycythemia
Vera non-responders to the maximum tolerated dose of hydroxyurea monotherapy for at least 3
months.

Recruited patients will be randomly assigned to one of the following treatment groups:

-  group A: 50 mg o.d. of oral GIVINOSTAT (ITF2357) in combination with the maximum
tolerated dose of hydroxyurea monotherapy already in use before admission to the study;

-  group B: 50 mg b.i.d. of oral GIVINOSTAT (ITF2357) in combination with the maximum
tolerated dose of hydroxyurea monotherapy already in use before admission to the study.
The two groups will be balanced for number and for Centre in order to provide valuable
information on both treatment regimens. In both groups assigned doses shall remain
stable until week 12, which is when the primary endpoint is assessed, unless specific
tolerability issues arise which impose dose reduction. After the primary endpoint
assessment at week 12, one of the following treatment schedules will be chosen case by
case on the basis of the achieved clinical response and continued for up to 12 further
weeks:

-  Partial or Complete Response at week 12:

-  group A: continue 50 mg o.d.;

-  group B: continue 50 mg b.i.d.;

-  No Response at week 12:

-  group A: increase to 50 mg b.i.d.;

-  group B: increase to 50 mg t.i.d.. At any time during study course, if toxicity is
observed, GIVINOSTAT (ITF2357) treatment will be discontinued until recovery and then
restarted at a reduced dose level. The drug will be definitively withdrawn in case of
reappearance of toxicity even at a reduced daily dose. Overall, the treatment will last
up to a maximum of 24 cumulative weeks of drug administration. The study will recruit
subjects of both genders with an established diagnosis of JAK2V617F positive
Polycythemia Vera according to the revised WHO criteria, in need of cytoreductive
therapy, non-responders to the maximum tolerated dose of hydroxyurea monotherapy for at
least 3 months.
</textblock>
</brief_summary>
<overall_status>Recruiting</overall_status>
<start_date>June 2009</start_date>
<end_date>December 2010</end_date>
<completion_date type="Anticipated">December 2010</completion_date>
<primary_completion_date type="Anticipated">June 2010</primary_completion_date>
<phase>Phase 2</phase>
<study_type>Interventional</study_type>
<study_design>Treatment, Randomized, Open Label, Uncontrolled, Parallel Assignment, Safety/Efficacy Study</study_design>
<primary_outcome>
<measure>To evaluate the efficacy of GIVINOSTAT (ITF2357) in combination with hydroxyurea in patients with JAK2V617F
positive Polycythemia Vera non-responders to the maximum tolerated dose of hydroxyurea monotherapy.</measure>
<time_frame>after 12 weeks of treatment</time_frame>
<safety_issue>No</safety_issue>
</primary_outcome>
<secondary_outcome>
<measure>To evaluate the safety and tolerability of GIVINOSTAT-HU combination in patients with JAK2V617F positive PV NR to
the MTD of HU monotherapy; to evaluate the molecular response.</measure>
<time_frame>after 24 weeks of treatment</time_frame>
<safety_issue>Yes</safety_issue>
</secondary_outcome>
<number_of_arms>2</number_of_arms>
<enrollment type="Anticipated">44</enrollment>
<condition>Polycythemia Vera</condition>
<arm_group>
<arm_group_label>GIVINOSTAT + MTD Hydroxyurea_1</arm_group_label>
<arm_group_type>Experimental</arm_group_type>
<description>50 mg o.d. of GIVINOSTAT + MTD of HU monotherapy</description>
</arm_group>
<arm_group>
<arm_group_label>GIVINOSTAT + MTD Hydroxyurea_2</arm_group_label>
<arm_group_type>Experimental</arm_group_type>
<description>50 mg b.i.d. of GIVINOSTAT + MTD of HU monotherapy</description>
</arm_group>
<intervention>
<intervention_type>Drug</intervention_type>
<intervention_name>GIVINOSTAT (ITF2357) 50 mg o.d. + MTD Hydroxyurea</intervention_name>
<description>50 mg o.d. of GIVINOSTAT + MTD of HU monotherapy</description>
<arm_group_label>GIVINOSTAT + MTD Hydroxyurea_1</arm_group_label>
<other_name>GIVINOSTAT (ITF2357)</other_name>
<other_name>ONCOCARBIDE (HYDROXYUREA)</other_name>
</intervention>
<intervention>
<intervention_type>Drug</intervention_type>
<intervention_name>GIVINOSTAT (ITF2357) 50 mg b.i.d. + MTD Hydroxyurea</intervention_name>
<description>50 mg b.i.d. of GIVINOSTAT + MTD HU monotherapy</description>
<arm_group_label>GIVINOSTAT + MTD Hydroxyurea_2</arm_group_label>
<other_name>GIVINOSTAT (ITF2357)</other_name>
<other_name>ONCOCARBIDE (HYDROXYUREA)</other_name>
</intervention>
<eligibility>
<criteria>
<textblock>
Inclusion Criteria:

-  Written Informed Consent.

-  Age ≥18 years.

-  Confirmed diagnosis of Polycythemia Vera according to the revised WHO criteria.

-  JAK2V617F positivity.

-  Non-response to the maximum tolerated dose of hydroxyurea monotherapy for at least 3
months.

-  ECOG performance status &lt;3.

-  Use of an effective means of contraception for women of childbearing potential and men
with partners of childbearing potential.

-  Willingness and capability to comply with the requirements of the study.

Exclusion Criteria:

-  Active bacterial or mycotic infection requiring antimicrobial treatment.

-  Pregnancy or lactation.

-  A marked baseline prolongation of QT/QTc interval (e.g. repeated demonstration of a
													  QTc interval &gt; 450 ms, according to Bazett's correction formula).

-  Use of concomitant medications that prolong the QT/QTc interval.

-  Clinically significant cardiovascular disease including:

-  Uncontrolled hypertension, myocardial infarction, unstable angina;

-  New York Heart Association (NYHA) Grade II or greater congestive heart failure;

-  History of any cardiac arrhythmia requiring medication (irrespective of its
severity);

-  A history of additional risk factors for TdP (e.g., heart failure, hypokalemia,
family history of Long QT Syndrome).

-  Positive blood test for HIV.

-  Active HBV and/or HCV infection.

-  Platelets count &lt;100x109/L within 14 days before enrolment.

-  Absolute neutrophil count &lt;1.2x109/L within 14 days before enrolment.

-  Serum creatinine &gt;2xULN.

-  Total serum bilirubin &gt;1.5xULN.

-  Serum AST/ALT &gt; 3xULN.

-  History of other diseases, metabolic dysfunctions, physical examination findings, or
clinical laboratory findings giving reasonable suspicion of a disease or condition
that contraindicates use of an investigational drug or that might affect
interpretation of the results of the study or render the subject at high risk from
treatment complications.

-  Interferon alpha within 14 days before enrolment.

-  Anagrelide within 7 days before enrolment.

-  Any other investigational drug within 28 days before enrolment.
</textblock>
</criteria>
<gender>Both</gender>
<minimum_age>18 Years</minimum_age>
<maximum_age>80 Years</maximum_age>
<healthy_volunteers>No</healthy_volunteers>
</eligibility>
<overall_official>
<last_name>Alessandro Rambaldi, MD</last_name>
<role>Principal Investigator</role>
<affiliation>Azienda Ospedaliera Ospedali Riuniti di Bergamo</affiliation>
</overall_official>
<overall_contact>
<last_name>Tiziano Oldoni, MD</last_name>
<phone>+39 02 6443 2540</phone>
<email>t.oldoni@italfarmaco.com</email>
</overall_contact>
<location>
<facility>
<name>Azienda Ospedaliera Ospedali Riuniti di Bergamo</name>
<address>
<city>Bergamo</city>
<zip>24100</zip>
<country>Italy</country>
</address>
</facility>
<status>Recruiting</status>
<contact>
<last_name>Alessandro Rambaldi, MD</last_name>
<phone>+39 035 269492</phone>
<email>arambaldi@ospedaliriuniti.bergamo.it</email>
</contact>
<investigator>
<last_name>Giovanni Barosi, MD</last_name>
<role>Sub-Investigator</role>
</investigator>
<investigator>
<last_name>Alessandro M. Vannucchi, MD</last_name>
<role>Sub-Investigator</role>
</investigator>
<investigator>
<last_name>Giorgina Specchia, MD</last_name>
<role>Sub-Investigator</role>
</investigator>
<investigator>
<last_name>Enrico M. Pogliani, MD</last_name>
<role>Sub-Investigator</role>
</investigator>
<investigator>
<last_name>Francesco Rodeghiero, MD</last_name>
<role>Sub-Investigator</role>
</investigator>
</location>
<verification_date>June 2009</verification_date>
<lastchanged_date>June 26, 2009</lastchanged_date>
<firstreceived_date>June 25, 2009</firstreceived_date>
</clinical_study>
