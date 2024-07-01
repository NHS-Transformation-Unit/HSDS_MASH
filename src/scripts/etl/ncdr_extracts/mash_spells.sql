SELECT APCS.[APCS_Ident]
    ,APCS.[Admission_Date]
	  ,APCS.[Discharge_Date]
    ,APCS.[Ethnic_Group]
    ,ETH.[Ethnic_Category_Desc]
	  ,PG.[Person_Gender_Desc]
	  ,MSTAT.[Marital_Status_Desc]
	  ,APCS.[Der_Postcode_LSOA_Code]
	  ,LSOA.[LSOA_Name]
	  ,IMD.[IMD_Score]
	  ,IMD.[IMD_Decile]
	  ,IMD.[IMD_Rank]
	  ,ADMCAT.[Administrative_Category_Desc]
	  ,CSI.[Carer_Support_Ind_Desc]
	  ,ORGPRO.[Organisation_Name]
	  ,ORGPRO.[STP_Code] AS [Provider_ICB_Code]
	  ,ORGPRO.[STP_Name] AS [Provider_ICB_Name]
	  ,ORGPRO.[Region_Code] AS [Provider_Region_Code]
	  ,ORGPRO.[Region_Name] AS [Provider_Region_Name]
	  ,PRO_SITE.[Site_Name]
	  ,ORGCOMM.[Organisation_Name] AS [Commissioner_Name]
	  ,ORGCOMM.[STP_Code] AS [Commissioner_ICB_Code]
	  ,ORGCOMM.[STP_Name] AS [Commissioner_ICB_Name]
	  ,ORGCOMM.[Region_Code] AS [Commissioner_Region_Code]
	  ,WARD.[Ward_Name]
	  ,APCS.[Admission_Method]
	  ,ADM.[Admission_Method_Desc]
	  ,APCS.[Source_of_Admission]
	  ,ADMS.[Admission_Source_Desc]
	  ,APCS.[Discharge_Destination]
	  ,DISDES.[Discharge_Destination_Desc]
	  ,APCS.[Discharge_Method]
	  ,DISMET.[Discharge_Method_Desc]
	  ,APCS.[Intended_Management]
	  ,INTM.[Intended_Management_Desc]
	  ,APCS.[Patient_Classification]
	  ,PTCLASS.[Patient_Classification_Desc]
	  ,APCS.[Der_Diagnosis_All]
	  ,CASE WHEN (APCS.[Der_Diagnosis_All] LIKE '%||K760%' AND APCS.[Der_Diagnosis_All] LIKE '%||K740%') THEN 'Both'
			WHEN APCS.[Der_Diagnosis_All] LIKE '%||K760%' THEN 'Fatty (change of) liver, not elsewhere classified'
			WHEN APCS.[Der_Diagnosis_All] LIKE '%||K740%' THEN 'Hepatic fibrosis'
			ELSE 'Other' END AS [Diag_Group]
	  ,CASE WHEN (APCS.[Der_Diagnosis_All] LIKE '%,E244%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,F10%' OR
				  APCS.[Der_Diagnosis_ALL] LIKE '%,G132%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,G621%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,G721%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,I426%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,K292%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,K70%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,K860%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,T510%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,T511%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,T519%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,X45%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,X65%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,Y15%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,K852%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,Q860%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,R780%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,Y90%' OR
				  APCS.[Der_Diagnosis_All] LIKE '%,Y91%') THEN 1 ELSE 0 END AS [Alcohol_Wholly_Att_Flag]

FROM [NHSE_SUSPlus_Live].[dbo].[tbl_Data_SEM_APCS] as [APCS]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_ZZZ_EthnicCategory] as [ETH]
ON APCS.[Ethnic_Group] = ETH.[Ethnic_Category]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_ZZZ_PersonGender] as [PG]
ON APCS.[Sex] = PG.[Person_Gender_Code]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_ZZZ_MaritalStatus] as [MSTAT]
ON APCS.[Marital_Status] = MSTAT.[Marital_Status]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_ODS_LSOA] as [LSOA]
ON APCS.[Der_Postcode_LSOA_Code] = LSOA.[LSOA]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_Other_Deprivation_By_LSOA] as [IMD]
ON LSOA.[LSOA] = IMD.[LSOA_Code]
AND IMD.[Effective_Snapshot_Date] = '2019-12-31'

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_ZZZ_AdministrativeCategory] as [ADMCAT]
ON APCS.[Administrative_Category] = ADMCAT.[Administrative_Category]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_ZZZ_CarerSupportIndicator] as [CSI]
ON APCS.[Carer_Support_Indicator] = CSI.[Carer_Support_Ind]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_ODS_Provider_Hierarchies] as [ORGPRO]
ON APCS.[Der_Provider_Code] = ORGPRO.[Organisation_Code]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_ODS_Provider_Site_Mappings] as [PRO_SITE]
ON APCS.[Der_Provider_Site_Code] = PRO_SITE.[Site_Code]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_ODS_Commissioner_Hierarchies] as [ORGCOMM]
ON APCS.[Der_Commissioner_Code] = ORGCOMM.[Organisation_Code]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_ODS_Wards] as [WARD]
ON APCS.[Der_Postcode_Electoral_Ward] = WARD.[Ward_Code]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_APC_AdmissionMethod] as [ADM]
ON APCS.[Admission_Method] = ADM.[Admission_Method_Der]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_APC_AdmissionSource] as [ADMS]
ON APCS.[Source_of_Admission] = ADMS.[Admission_Source]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_APC_DischargeDestination] as [DISDES]
ON APCS.[Discharge_Destination] = DISDES.[Discharge_Destination]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_APC_DischargeMethod] as [DISMET]
ON APCS.[Discharge_Method] = DISMET.[Discharge_Method]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_APC_IntendedManagement] as [INTM]
ON APCS.[Intended_Management] = INTM.[Intended_Management]

LEFT JOIN [NHSE_Reference].[dbo].[tbl_Ref_DataDic_APC_PatientClassification] as [PTCLASS]
ON APCS.[Patient_Classification] = PTCLASS.[Patient_Classification]

WHERE APCS.[Admission_Date] between '2023-04-01' AND '2024-03-31'
AND (APCS.[Der_Diagnosis_All] LIKE '%||K760%' OR
	   APCS.[Der_Diagnosis_All] LIKE '%||K740%')