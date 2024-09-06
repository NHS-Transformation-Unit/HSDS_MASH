-- ===========================================================
-- Section: Drop any instances of the temp tables
-- ===========================================================

IF OBJECT_ID('TempDB..#AdmAll') IS NOT NULL DROP TABLE #AdmAll
IF OBJECT_ID('TempDB..#OPAAll') IS NOT NULL DROP TABLE #OPAAll
IF OBJECT_ID('TempDB..#AdmAllFirst') IS NOT NULL DROP TABLE #AdmAllFirst
IF OBJECT_ID('TempDB..#OPAAllFirst') IS NOT NULL DROP TABLE #OPAAllFirst
IF OBJECT_ID('TempDB..#mpi_initial') IS NOT NULL DROP TABLE #mpi_initial
IF OBJECT_ID('TempDB..#Adm') IS NOT NULL DROP TABLE #Adm
IF OBJECT_ID('TempDB..#OPA') IS NOT NULL DROP TABLE #OPA

-- ===========================================================
-- Section: Find all MASH admissions and order		
-- ===========================================================

SELECT APCS.[APCS_Ident],
       APCS.[Der_Pseudo_NHS_Number],
       APCS.[Admission_Date],
       APCS.[Discharge_Date],
	   APCS.[Der_Age_at_CDS_Activity_Date] AS [Age],
	   APCS.[Der_Spell_LoS],
       APCS.[Ethnic_Group],
       ETH.[Main_Description] AS [Ethnic_Category_Desc],
       PG.[Main_Description] AS [Person_Gender_Desc],
       MSTAT.[Main_Description] AS [Marital_Status_Desc],
       APCS.[Der_Postcode_LSOA_Code],
       LSOA.[LSOA11NM] AS [LSOA_Name],
       IMD.[IMD_Score],
       IMD.[IMD_Decile],
       IMD.[IMD_Rank],
       ADMCAT.[Main_Description] AS [Administrative_Category_Desc],
       CSI.[Main_Description] AS [Carer_Support_Ind_Desc],
       ORGPRO.[Organisation_Name],
       ORGPRO.[STP_No] AS [Provider_ICB_Code],
       ORGPRO.[STP_Name] AS [Provider_ICB_Name],
       ORGPRO.[Region_Code] AS [Provider_Region_Code],
       ORGPRO.[Region_Name] AS [Provider_Region_Name],
       PRO_SITE.[Organisation_Name] AS [Site_Name],
       ORGCOMM.[Organisation_Name] AS [Commissioner_Name],
       ORGCOMM.[STP_Code] AS [Commissioner_ICB_Code],
       ORGCOMM.[STP_Name] AS [Commissioner_ICB_Name],
       ORGCOMM.[Region_Code] AS [Commissioner_Region_Code],
       WARD.[Ward_Name],
       APCS.[Admission_Method],
       ADM.[Main_Description] AS [Admission_Method_Desc],
       APCS.[Source_of_Admission],
       ADMS.[Main_Description] AS [Admission_Source_Desc],
       APCS.[Discharge_Destination],
       DISDES.[Main_Description] AS [Discharge_Destination_Desc],
       APCS.[Discharge_Method],
       DISMET.[Main_Description] AS [Discharge_Method_Desc],
       APCS.[Intended_Management],
       INTM.[Main_Description] AS [Intended_Management_Desc],
       APCS.[Patient_Classification],
       PTCLASS.[Main_Description] AS [Patient_Classification_Desc],
	   APCS.[Der_Management_Type],
       APCS.[Der_Diagnosis_All],
	   APCS.[Der_Procedure_All],
	   OPCS.[Title] as [OPCS_Desc],
       CASE
           WHEN
           (
               APCS.[Der_Diagnosis_All] LIKE '%||K760%'
               AND APCS.[Der_Diagnosis_All] LIKE '%||K740%'
           ) THEN
               'Both'
           WHEN APCS.[Der_Diagnosis_All] LIKE '%||K760%' THEN
               'Fatty (change of) liver, not elsewhere classified'
           WHEN APCS.[Der_Diagnosis_All] LIKE '%||K740%' THEN
               'Hepatic fibrosis'
           ELSE
               'Other'
       END AS [Diag_Group],
       CASE
           WHEN
           (
               APCS.[Der_Diagnosis_All] LIKE '%,E244%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,F10%'
               OR APCS.[Der_Diagnosis_ALL] LIKE '%,G132%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,G621%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,G721%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,I426%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K292%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K70%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K860%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,T510%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,T511%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,T519%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,X45%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,X65%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Y15%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K852%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Q860%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,R780%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Y90%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Y91%'
           ) THEN
               1
           ELSE
               0
       END AS [Alcohol_Wholly_Att_Flag],
	   CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I21%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I22%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I23%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I252%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I258%'
			) THEN
				1
			ELSE
				0
		END AS [CC_AMI_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,G450%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G451%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G452%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G454%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G458%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G459%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G46%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I6%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CVA_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I50%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CHF_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,M05%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M060%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M063%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M069%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M32%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M332%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M34%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M353%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CTD_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,F00%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F01%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F02%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F03%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F051%'
			) THEN
				1
			ELSE
				0
		END AS [CC_DEM_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,E101%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E105%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E106%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E108%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E109%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E111%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E115%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E116%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E118%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E119%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E131%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E135%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E136%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E138%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E139%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E141%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E145%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E146%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E148%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E149%'

			) THEN
				1
			ELSE
				0
		END AS [CC_DIA_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K702%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K703%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K717%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K73%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K74%'
			) THEN
				1
			ELSE
				0
		END AS [CC_LIV_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K25%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K26%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K27%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K28%'
			) THEN
				1
			ELSE
				0
		END AS [CC_PEP_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I71%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I739%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I790%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,R02%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,Z958%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,Z959%'
			) THEN
				1
			ELSE
				0
		END AS [CC_PVD_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,J40%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J41%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J42%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J43%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J44%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J45%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J46%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J47%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J60%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J61%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J62%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J63%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J64%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J65%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J66%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J67%'

			) THEN
				1
			ELSE
				0
		END AS [CC_PUL_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,C0%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C1%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C2%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C3%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C4%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C5%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C6%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C70%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C71%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C72%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C73%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C74%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C75%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C76%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C81%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C82%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C83%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C84%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C85%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C86%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C87%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C88%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C89%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C90%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C91%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C92%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C93%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C94%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C95%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C96%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C97%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CAN_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,E102%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E103%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E104%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E107%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E112%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E113%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E114%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E117%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E132%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E133%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E134%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E137%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E142%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E143%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E144%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E147%'
			) THEN
				1
			ELSE
				0
		END AS [CC_DIACOM_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,G041%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G81%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G820%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G821%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G822%'
			) THEN
				1
			ELSE
				0
		END AS [CC_PARA_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I12%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I13%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N01%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N03%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N052%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N053%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N054%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N055%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N056%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N072%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N073%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N074%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N18%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N19%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N25%'
			) THEN
				1
			ELSE
				0
		END AS [CC_REN_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,C77%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C78%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C79%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C80%'
			) THEN
				1
			ELSE
				0
		END AS [CC_METC_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K721%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K729%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K766%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K767%'
			) THEN
				1
			ELSE
				0
		END AS [CC_SLD_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,B20%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B21%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B22%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B23%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B24%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,O987%'
			) THEN
				1
			ELSE
				0
		END AS [CC_HIV_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K741%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K742%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K743%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K744%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K745%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K746%'
			) THEN
				1
			ELSE
				0
			END AS [LC_Flag],
		
		ROW_NUMBER() OVER (PARTITION BY APCS.[Der_Pseudo_NHS_Number] ORDER BY APCS.[Admission_Date]) AS [Der_First_Adm]
INTO #AdmAll
FROM [Reporting_MESH_APC].[APCS_Core_Daily] AS [APCS]
    LEFT JOIN [UKHD_Data_Dictionary].[Ethnic_Category_Code_SCD] AS [ETH]
        ON APCS.[Ethnic_Group] = ETH.[Main_Code_Text]
           AND ETH.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Person_Gender_Code_SCD] AS [PG]
        ON APCS.[Sex] = PG.[Main_Code_Text]
           AND PG.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Person_Marital_Status_Code_SCD] AS [MSTAT]
        ON APCS.[Marital_Status] = MSTAT.[Main_Code_Text]
           AND MSTAT.[Is_Latest] = 1
    LEFT JOIN [UKHD_Ordnance_Survey].[LSOA_2011] AS [LSOA]
        ON APCS.[Der_Postcode_LSOA_Code] = LSOA.[LSOA11CD]
    LEFT JOIN [UKHF_Demography].[Domains_Of_Deprivation_By_LSOA1] AS [IMD]
        ON LSOA.[LSOA11CD] = IMD.[LSOA_Code]
           AND IMD.[Effective_Snapshot_Date] = '2019-12-31'
    LEFT JOIN [UKHD_Data_Dictionary].[Administrative_Category_Code_SCD] AS [ADMCAT]
        ON APCS.[Administrative_Category] = ADMCAT.[Main_Code_Text]
           AND ADMCAT.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Carer_Support_Indicator_SCD] AS [CSI]
        ON APCS.[Carer_Support_Indicator] = CSI.[Main_Code_Text]
           AND CSI.[Is_Latest] = 1
    LEFT JOIN [Internal_Reference].[Provider_Geography] AS [ORGPRO]
        ON APCS.[Der_Provider_Code] = ORGPRO.[Organisation_Code]
    LEFT JOIN [Internal_Reference].[Site] AS [PRO_SITE]
        ON APCS.[Der_Provider_Site_Code] = PRO_SITE.[Organisation_Code]
           AND PRO_SITE.[is_latest] = 1
    LEFT JOIN [Reporting_UKHD_ODS].[Commissioner_Hierarchies_ICB] AS [ORGCOMM]
        ON APCS.[Der_Commissioner_Code] = ORGCOMM.[Organisation_Code]
    LEFT JOIN [UKHD_ODS].[Wards_UK_v2_SCD] AS [WARD]
        ON APCS.[Der_Postcode_Electoral_Ward] = WARD.[Ward_Code]
           AND WARD.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Admission_Method_SCD] AS [ADM]
        ON APCS.[Admission_Method] = ADM.[Main_Code_Text]
           AND ADM.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Source_Of_Admission_SCD] AS [ADMS]
        ON APCS.[Source_of_Admission] = ADMS.[Main_Code_Text]
           AND ADMS.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Discharge_Destination_SCD] AS [DISDES]
        ON APCS.[Discharge_Destination] = DISDES.[Main_Code_Text]
           AND DISDES.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Discharge_Method_SCD] AS [DISMET]
        ON APCS.[Discharge_Method] = DISMET.[Main_Code_Text]
           AND DISMET.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Intended_Management_SCD] AS [INTM]
        ON APCS.[Intended_Management] = INTM.[Main_Code_Text]
           AND INTM.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Patient_Classification_SCD] AS [PTCLASS]
        ON APCS.[Patient_Classification] = PTCLASS.[Main_Code_Text]
           AND PTCLASS.[Is_Latest] = 1
	LEFT JOIN [UKHD_OPCS4].[Codes_And_Titles] as [OPCS]
		ON RIGHT(LEFT(APCS.[Der_Procedure_All],6),4) = OPCS.[Code_Without_Decimal]
			AND OPCS.[Effective_To] IS NULL
WHERE APCS.[Admission_Date]
      BETWEEN '2019-04-01' AND '2024-03-31'
      AND (
              APCS.[Der_Diagnosis_All] LIKE '%||K760%'
              OR APCS.[Der_Diagnosis_All] LIKE '%||K740%'
          )
	 AND APCS.[Der_Pseudo_NHS_Number] IS NOT NULL

-- ===========================================================
-- Section: Find all MASH outpatients and order		
-- ===========================================================

SELECT OPA.[Der_Pseudo_NHS_Number],
	   OPA.[OPA_Ident],
	   OPA.[Appointment_Date],
	   OPA.[Der_Age_At_CDS_Activity_Date] AS [Age],
	   ETH.[Main_Description] AS [Ethnic_Category_Desc],
	   PG.[Main_Description] AS [Person_Gender_Desc],
	   LSOA.[LSOA11NM] AS [LSOA_Name],
	   IMD.[IMD_Score],
	   IMD.[IMD_Decile],
	   IMD.[IMD_Rank],
	   ORGPRO.[Organisation_Name],
       ORGPRO.[STP_No] AS [Provider_ICB_Code],
       ORGPRO.[STP_Name] AS [Provider_ICB_Name],
       ORGPRO.[Region_Code] AS [Provider_Region_Code],
       ORGPRO.[Region_Name] AS [Provider_Region_Name],
	   ORGCOMM.[Organisation_Name] AS [Commissioner_Name],
       ORGCOMM.[STP_Code] AS [Commissioner_ICB_Code],
       ORGCOMM.[STP_Name] AS [Commissioner_ICB_Name],
       ORGCOMM.[Region_Code] AS [Commissioner_Region_Code],
	   TFC.[Main_Description] AS [Treatment_Function_Desc],
       TFC.[Category] AS [Treatment_Function_Group],
	   FFU.[Main_Description] AS [First_Attendance_Desc],
	   OPA.[Attendance_Status],
	   ATTSTAT.[Main_Description] AS [Attendance_Status_Desc],
	   ATTOUT.[Main_Description] AS [Attendance_Outcome_Desc],
	   CONMED.[Main_Description] AS [Consultation_Medium_Used_Desc],
	   PT.[Main_Description] AS [Priority_Type_Desc],
	   RS.[Main_Description] AS [Referral_Source_Desc],
	   OPA.[Der_Diagnosis_All],
	   OPA.[Der_Procedure_All],
	   LEFT(OPA.[Der_Diagnosis_All], 4) as [PrimDiag],
	   LEFT(OPA.[Der_Procedure_All], 4) as [PrimProc],
	   OPCS.[Title] as [OPCS_Desc],
	   
	   ROW_NUMBER() OVER (PARTITION BY OPA.[Der_Pseudo_NHS_Number] ORDER BY OPA.[Appointment_Date]) AS [Der_First_OPA]
INTO #OPAAll
FROM [SUS_OPA].[OPA_Core] AS [OPA]

LEFT JOIN [UKHD_Data_Dictionary].[Ethnic_Category_Code_SCD] AS ETH
ON OPA.[Ethnic_Category] = ETH.[Main_Code_Text]
AND ETH.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Person_Gender_Code_SCD] AS PG
ON OPA.[Sex] = PG.[Main_Code_Text]
AND PG.[Is_Latest] = 1

LEFT JOIN [UKHD_Ordnance_Survey].[LSOA_2011] AS LSOA
ON OPA.[Der_Postcode_LSOA_Code] = LSOA.[LSOA11CD]

LEFT JOIN [UKHF_Demography].[Domains_Of_Deprivation_By_LSOA1] AS IMD
ON LSOA.[LSOA11CD]  = IMD.[LSOA_Code]
AND IMD.[Effective_Snapshot_Date] = '2019-12-31'

LEFT JOIN [Internal_Reference].[Provider_Geography] AS [ORGPRO]
ON OPA.[Der_Provider_Code] = ORGPRO.[Organisation_Code]

LEFT JOIN [Reporting_UKHD_ODS].[Commissioner_Hierarchies_ICB] AS [ORGCOMM]
ON OPA.[Der_Commissioner_Code] = ORGCOMM.[Organisation_Code]

LEFT JOIN [UKHD_Data_Dictionary].[Treatment_Function_Code_SCD] AS TFC
ON OPA.[Treatment_Function_Code] = TFC.[Main_Code_Text]
AND TFC.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[First_Attendance_SCD] AS FFU
ON OPA.[First_Attendance] = FFU.[Main_Code_Text]
AND FFU.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Attended_Or_Did_Not_Attend_SCD] AS ATTSTAT
ON OPA.[Attendance_Status] = ATTSTAT.[Main_Code_Text]
AND ATTSTAT.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Outcome_Of_Attendance_SCD] AS ATTOUT
ON OPA.[Outcome_of_Attendance] = ATTOUT.[Main_Code_Text]
AND ATTOUT.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Consultation_Medium_Used_SCD] AS CONMED
ON OPA.[Consultation_Medium_Used] = CONMED.[Main_Code_Text]
AND CONMED.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Priority_Type_SCD] AS PT
ON OPA.[Priority_Type] = PT.[Main_Code_Text]
AND PT.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Source_Of_Referral_For_Out_Patients_SCD] AS RS
ON OPA.[OPA_Referral_Source] = RS.[Main_Code_Text]
AND RS.[Is_Latest] = 1

LEFT JOIN [UKHD_OPCS4].[Codes_And_Titles] as [OPCS]
ON LEFT(OPA.[Der_Procedure_All], 4) = OPCS.[Code_Without_Decimal]
AND OPCS.[Effective_To] IS NULL

WHERE OPA.[Appointment_Date] BETWEEN '2019-04-01' AND '2024-03-31'
AND (OPA.[Der_Diagnosis_All] LIKE 'K740%' OR
	 OPA.[Der_Diagnosis_All] LIKE 'K760%')
AND OPA.[Der_Pseudo_NHS_Number] IS NOT NULL

-- ===========================================================
-- Section: Find first appointments and admissions	
-- ===========================================================

SELECT *
INTO #AdmAllFirst
FROM #AdmAll
WHERE [Der_First_Adm] = 1


SELECT *
INTO #OPAAllFirst
FROM #OPAAll
WHERE [Der_First_OPA] = 1

-- ===========================================================
-- Section: Create initial combined mpi
-- ===========================================================

SELECT Adm.[Der_Pseudo_NHS_Number] AS [Der_Pseudo_NHS_Number_Adm],
	   Adm.[Admission_Date],
	   Adm.[Der_Management_Type],
       Adm.[Diag_Group],
	   Adm.[OPCS_Desc] AS [OPCS_Desc_Adm],
	   OPA.[Der_Pseudo_NHS_Number]  AS [Der_Pseudo_NHS_Number_OPA],
	   OPA.[Appointment_Date],
	   OPA.[OPCS_Desc] AS [OPCS_Desc_OPA],
	   COALESCE(Adm.[Der_Pseudo_NHS_Number], OPA.[Der_Pseudo_NHS_Number]) AS [Der_Pseudo_NHS_Number]
INTO #mpi_initial
FROM #AdmAllFirst as Adm

FULL OUTER JOIN #OPAAllFirst AS OPA
ON Adm.[Der_Pseudo_NHS_Number] = OPA.[Der_Pseudo_NHS_Number]

-- ===========================================================
-- Section: Find all MPI patient relevant admissions
-- ===========================================================

SELECT APCS.[APCS_Ident],
       APCS.[Der_Pseudo_NHS_Number],
       APCS.[Admission_Date],
       APCS.[Discharge_Date],
	   APCS.[Der_Age_at_CDS_Activity_Date] AS [Age],
	   APCS.[Der_Spell_LoS],
       APCS.[Ethnic_Group],
       ETH.[Main_Description] AS [Ethnic_Category_Desc],
       PG.[Main_Description] AS [Person_Gender_Desc],
       MSTAT.[Main_Description] AS [Marital_Status_Desc],
       APCS.[Der_Postcode_LSOA_Code],
       LSOA.[LSOA11NM] AS [LSOA_Name],
       IMD.[IMD_Score],
       IMD.[IMD_Decile],
       IMD.[IMD_Rank],
       ADMCAT.[Main_Description] AS [Administrative_Category_Desc],
       CSI.[Main_Description] AS [Carer_Support_Ind_Desc],
       ORGPRO.[Organisation_Name],
       ORGPRO.[STP_No] AS [Provider_ICB_Code],
       ORGPRO.[STP_Name] AS [Provider_ICB_Name],
       ORGPRO.[Region_Code] AS [Provider_Region_Code],
       ORGPRO.[Region_Name] AS [Provider_Region_Name],
       PRO_SITE.[Organisation_Name] AS [Site_Name],
       ORGCOMM.[Organisation_Name] AS [Commissioner_Name],
       ORGCOMM.[STP_Code] AS [Commissioner_ICB_Code],
       ORGCOMM.[STP_Name] AS [Commissioner_ICB_Name],
       ORGCOMM.[Region_Code] AS [Commissioner_Region_Code],
       WARD.[Ward_Name],
       APCS.[Admission_Method],
       ADM.[Main_Description] AS [Admission_Method_Desc],
       APCS.[Source_of_Admission],
       ADMS.[Main_Description] AS [Admission_Source_Desc],
       APCS.[Discharge_Destination],
       DISDES.[Main_Description] AS [Discharge_Destination_Desc],
       APCS.[Discharge_Method],
       DISMET.[Main_Description] AS [Discharge_Method_Desc],
       APCS.[Intended_Management],
       INTM.[Main_Description] AS [Intended_Management_Desc],
       APCS.[Patient_Classification],
       PTCLASS.[Main_Description] AS [Patient_Classification_Desc],
	   APCS.[Der_Management_Type],
       APCS.[Der_Diagnosis_All],
	   APCS.[Der_Procedure_All],
	   OPCS.[Title] as [OPCS_Desc],
       CASE
           WHEN
           (
               APCS.[Der_Diagnosis_All] LIKE '%||K760%'
               AND APCS.[Der_Diagnosis_All] LIKE '%||K740%'
           ) THEN
               'Both'
           WHEN APCS.[Der_Diagnosis_All] LIKE '%||K760%' THEN
               'Fatty (change of) liver, not elsewhere classified'
           WHEN APCS.[Der_Diagnosis_All] LIKE '%||K740%' THEN
               'Hepatic fibrosis'
           ELSE
               'Other'
       END AS [Diag_Group],
       CASE
           WHEN
           (
               APCS.[Der_Diagnosis_All] LIKE '%,E244%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,F10%'
               OR APCS.[Der_Diagnosis_ALL] LIKE '%,G132%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,G621%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,G721%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,I426%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K292%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K70%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K860%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,T510%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,T511%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,T519%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,X45%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,X65%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Y15%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,K852%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Q860%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,R780%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Y90%'
               OR APCS.[Der_Diagnosis_All] LIKE '%,Y91%'
           ) THEN
               1
           ELSE
               0
       END AS [Alcohol_Wholly_Att_Flag],
	   CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I21%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I22%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I23%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I252%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I258%'
			) THEN
				1
			ELSE
				0
		END AS [CC_AMI_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,G450%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G451%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G452%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G454%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G458%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G459%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G46%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I6%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CVA_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I50%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CHF_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,M05%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M060%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M063%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M069%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M32%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M332%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M34%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,M353%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CTD_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,F00%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F01%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F02%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F03%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,F051%'
			) THEN
				1
			ELSE
				0
		END AS [CC_DEM_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,E101%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E105%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E106%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E108%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E109%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E111%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E115%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E116%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E118%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E119%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E131%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E135%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E136%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E138%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E139%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E141%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E145%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E146%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E148%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E149%'

			) THEN
				1
			ELSE
				0
		END AS [CC_DIA_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K702%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K703%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K717%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K73%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K74%'
			) THEN
				1
			ELSE
				0
		END AS [CC_LIV_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K25%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K26%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K27%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K28%'
			) THEN
				1
			ELSE
				0
		END AS [CC_PEP_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I71%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I739%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I790%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,R02%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,Z958%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,Z959%'
			) THEN
				1
			ELSE
				0
		END AS [CC_PVD_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,J40%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J41%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J42%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J43%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J44%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J45%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J46%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J47%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J60%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J61%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J62%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J63%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J64%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J65%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J66%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,J67%'

			) THEN
				1
			ELSE
				0
		END AS [CC_PUL_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,C0%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C1%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C2%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C3%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C4%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C5%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C6%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C70%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C71%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C72%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C73%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C74%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C75%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C76%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C81%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C82%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C83%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C84%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C85%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C86%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C87%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C88%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C89%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C90%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C91%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C92%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C93%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C94%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C95%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C96%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C97%'
			) THEN
				1
			ELSE
				0
		END AS [CC_CAN_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,E102%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E103%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E104%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E107%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E112%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E113%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E114%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E117%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E132%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E133%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E134%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E137%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E142%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E143%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E144%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,E147%'
			) THEN
				1
			ELSE
				0
		END AS [CC_DIACOM_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,G041%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G81%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G820%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G821%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,G822%'
			) THEN
				1
			ELSE
				0
		END AS [CC_PARA_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,I12%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,I13%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N01%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N03%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N052%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N053%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N054%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N055%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N056%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N072%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N073%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N074%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N18%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N19%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,N25%'
			) THEN
				1
			ELSE
				0
		END AS [CC_REN_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,C77%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C78%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C79%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,C80%'
			) THEN
				1
			ELSE
				0
		END AS [CC_METC_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K721%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K729%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K766%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K767%'
			) THEN
				1
			ELSE
				0
		END AS [CC_SLD_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,B20%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B21%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B22%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B23%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,B24%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,O987%'
			) THEN
				1
			ELSE
				0
		END AS [CC_HIV_Flag],
		CASE
		   WHEN
		   (
				APCS.[Der_Diagnosis_All] LIKE '%,K741%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K742%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K743%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K744%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K745%'
				OR APCS.[Der_Diagnosis_All] LIKE '%,K746%'
			) THEN
				1
			ELSE
				0
			END AS [LC_Flag],
		ROW_NUMBER() OVER (PARTITION BY APCS.[Der_Pseudo_NHS_Number] ORDER BY APCS.[Admission_Date]) AS [Der_First_Adm]
INTO #Adm
FROM [Reporting_MESH_APC].[APCS_Core_Daily] AS [APCS]
    LEFT JOIN [UKHD_Data_Dictionary].[Ethnic_Category_Code_SCD] AS [ETH]
        ON APCS.[Ethnic_Group] = ETH.[Main_Code_Text]
           AND ETH.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Person_Gender_Code_SCD] AS [PG]
        ON APCS.[Sex] = PG.[Main_Code_Text]
           AND PG.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Person_Marital_Status_Code_SCD] AS [MSTAT]
        ON APCS.[Marital_Status] = MSTAT.[Main_Code_Text]
           AND MSTAT.[Is_Latest] = 1
    LEFT JOIN [UKHD_Ordnance_Survey].[LSOA_2011] AS [LSOA]
        ON APCS.[Der_Postcode_LSOA_Code] = LSOA.[LSOA11CD]
    LEFT JOIN [UKHF_Demography].[Domains_Of_Deprivation_By_LSOA1] AS [IMD]
        ON LSOA.[LSOA11CD] = IMD.[LSOA_Code]
           AND IMD.[Effective_Snapshot_Date] = '2019-12-31'
    LEFT JOIN [UKHD_Data_Dictionary].[Administrative_Category_Code_SCD] AS [ADMCAT]
        ON APCS.[Administrative_Category] = ADMCAT.[Main_Code_Text]
           AND ADMCAT.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Carer_Support_Indicator_SCD] AS [CSI]
        ON APCS.[Carer_Support_Indicator] = CSI.[Main_Code_Text]
           AND CSI.[Is_Latest] = 1
    LEFT JOIN [Internal_Reference].[Provider_Geography] AS [ORGPRO]
        ON APCS.[Der_Provider_Code] = ORGPRO.[Organisation_Code]
    LEFT JOIN [Internal_Reference].[Site] AS [PRO_SITE]
        ON APCS.[Der_Provider_Site_Code] = PRO_SITE.[Organisation_Code]
           AND PRO_SITE.[is_latest] = 1
    LEFT JOIN [Reporting_UKHD_ODS].[Commissioner_Hierarchies_ICB] AS [ORGCOMM]
        ON APCS.[Der_Commissioner_Code] = ORGCOMM.[Organisation_Code]
    LEFT JOIN [UKHD_ODS].[Wards_UK_v2_SCD] AS [WARD]
        ON APCS.[Der_Postcode_Electoral_Ward] = WARD.[Ward_Code]
           AND WARD.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Admission_Method_SCD] AS [ADM]
        ON APCS.[Admission_Method] = ADM.[Main_Code_Text]
           AND ADM.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Source_Of_Admission_SCD] AS [ADMS]
        ON APCS.[Source_of_Admission] = ADMS.[Main_Code_Text]
           AND ADMS.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Discharge_Destination_SCD] AS [DISDES]
        ON APCS.[Discharge_Destination] = DISDES.[Main_Code_Text]
           AND DISDES.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Discharge_Method_SCD] AS [DISMET]
        ON APCS.[Discharge_Method] = DISMET.[Main_Code_Text]
           AND DISMET.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Intended_Management_SCD] AS [INTM]
        ON APCS.[Intended_Management] = INTM.[Main_Code_Text]
           AND INTM.[Is_Latest] = 1
    LEFT JOIN [UKHD_Data_Dictionary].[Patient_Classification_SCD] AS [PTCLASS]
        ON APCS.[Patient_Classification] = PTCLASS.[Main_Code_Text]
           AND PTCLASS.[Is_Latest] = 1
	LEFT JOIN [UKHD_OPCS4].[Codes_And_Titles] as [OPCS]
		ON RIGHT(LEFT(APCS.[Der_Procedure_All],6),4) = OPCS.[Code_Without_Decimal]
			AND OPCS.[Effective_To] IS NULL
WHERE APCS.[Der_Pseudo_NHS_Number] IN (SELECT [Der_Pseudo_NHS_Number]
										FROM #mpi_initial)

AND (     APCS.[Der_Diagnosis_All] LIKE '%||K760%'
              OR APCS.[Der_Diagnosis_All] LIKE '%||K740%'
          )

-- ===========================================================
-- Section: Find all MPI patient relevant appointments
-- ===========================================================

SELECT OPA.[Der_Pseudo_NHS_Number],
	   OPA.[OPA_Ident],
	   OPA.[Appointment_Date],
	   OPA.[Der_Age_At_CDS_Activity_Date] AS [Age],
	   ETH.[Main_Description] AS [Ethnic_Category_Desc],
	   PG.[Main_Description] AS [Person_Gender_Desc],
	   LSOA.[LSOA11NM] AS [LSOA_Name],
	   IMD.[IMD_Score],
	   IMD.[IMD_Decile],
	   IMD.[IMD_Rank],
	   ORGPRO.[Organisation_Name],
       ORGPRO.[STP_No] AS [Provider_ICB_Code],
       ORGPRO.[STP_Name] AS [Provider_ICB_Name],
       ORGPRO.[Region_Code] AS [Provider_Region_Code],
       ORGPRO.[Region_Name] AS [Provider_Region_Name],
	   ORGCOMM.[Organisation_Name] AS [Commissioner_Name],
       ORGCOMM.[STP_Code] AS [Commissioner_ICB_Code],
       ORGCOMM.[STP_Name] AS [Commissioner_ICB_Name],
       ORGCOMM.[Region_Code] AS [Commissioner_Region_Code],
	   TFC.[Main_Description] AS [Treatment_Function_Desc],
       TFC.[Category] AS [Treatment_Function_Group],
	   FFU.[Main_Description] AS [First_Attendance_Desc],
	   OPA.[Attendance_Status],
	   ATTSTAT.[Main_Description] AS [Attendance_Status_Desc],
	   ATTOUT.[Main_Description] AS [Attendance_Outcome_Desc],
	   CONMED.[Main_Description] AS [Consultation_Medium_Used_Desc],
	   PT.[Main_Description] AS [Priority_Type_Desc],
	   RS.[Main_Description] AS [Referral_Source_Desc],
	   OPA.[Der_Diagnosis_All],
	   OPA.[Der_Procedure_All],
	   LEFT(OPA.[Der_Diagnosis_All], 4) as [PrimDiag],
	   LEFT(OPA.[Der_Procedure_All], 4) as [PrimProc],
	   OPCS.[Title] as [OPCS_Desc],
	   ROW_NUMBER() OVER (PARTITION BY OPA.[Der_Pseudo_NHS_Number] ORDER BY OPA.[Appointment_Date]) AS [Der_First_OPA]
INTO #OPA
FROM [SUS_OPA].[OPA_Core] AS [OPA]

LEFT JOIN [UKHD_Data_Dictionary].[Ethnic_Category_Code_SCD] AS ETH
ON OPA.[Ethnic_Category] = ETH.[Main_Code_Text]
AND ETH.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Person_Gender_Code_SCD] AS PG
ON OPA.[Sex] = PG.[Main_Code_Text]
AND PG.[Is_Latest] = 1

LEFT JOIN [UKHD_Ordnance_Survey].[LSOA_2011] AS LSOA
ON OPA.[Der_Postcode_LSOA_Code] = LSOA.[LSOA11CD]

LEFT JOIN [UKHF_Demography].[Domains_Of_Deprivation_By_LSOA1] AS IMD
ON LSOA.[LSOA11CD]  = IMD.[LSOA_Code]
AND IMD.[Effective_Snapshot_Date] = '2019-12-31'

LEFT JOIN [Internal_Reference].[Provider_Geography] AS [ORGPRO]
ON OPA.[Der_Provider_Code] = ORGPRO.[Organisation_Code]

LEFT JOIN [Reporting_UKHD_ODS].[Commissioner_Hierarchies_ICB] AS [ORGCOMM]
ON OPA.[Der_Commissioner_Code] = ORGCOMM.[Organisation_Code]

LEFT JOIN [UKHD_Data_Dictionary].[Treatment_Function_Code_SCD] AS TFC
ON OPA.[Treatment_Function_Code] = TFC.[Main_Code_Text]
AND TFC.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[First_Attendance_SCD] AS FFU
ON OPA.[First_Attendance] = FFU.[Main_Code_Text]
AND FFU.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Attended_Or_Did_Not_Attend_SCD] AS ATTSTAT
ON OPA.[Attendance_Status] = ATTSTAT.[Main_Code_Text]
AND ATTSTAT.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Outcome_Of_Attendance_SCD] AS ATTOUT
ON OPA.[Outcome_of_Attendance] = ATTOUT.[Main_Code_Text]
AND ATTOUT.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Consultation_Medium_Used_SCD] AS CONMED
ON OPA.[Consultation_Medium_Used] = CONMED.[Main_Code_Text]
AND CONMED.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Priority_Type_SCD] AS PT
ON OPA.[Priority_Type] = PT.[Main_Code_Text]
AND PT.[Is_Latest] = 1

LEFT JOIN [UKHD_Data_Dictionary].[Source_Of_Referral_For_Out_Patients_SCD] AS RS
ON OPA.[OPA_Referral_Source] = RS.[Main_Code_Text]
AND RS.[Is_Latest] = 1

LEFT JOIN [UKHD_OPCS4].[Codes_And_Titles] as [OPCS]
ON LEFT(OPA.[Der_Procedure_All], 4) = OPCS.[Code_Without_Decimal]
AND OPCS.[Effective_To] IS NULL

WHERE OPA.[Der_Pseudo_NHS_Number] IN  (SELECT [Der_Pseudo_NHS_Number]
									   FROM #mpi_initial)
AND (OPA.[Der_Diagnosis_All] LIKE 'K740%' OR
	 OPA.[Der_Diagnosis_All] LIKE 'K760%')