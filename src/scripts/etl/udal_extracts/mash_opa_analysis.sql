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
	   OPCS.[Title] as [OPCS_Desc]

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