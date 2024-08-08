SELECT APCS.[APCS_Ident],
       APCS.[Admission_Date],
       APCS.[Discharge_Date],
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
       APCS.[Der_Diagnosis_All],
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
       END AS [Alcohol_Wholly_Att_Flag]
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
WHERE APCS.[Admission_Date]
      BETWEEN '2023-04-01' AND '2024-03-31'
      AND (
              APCS.[Der_Diagnosis_All] LIKE '%||K760%'
              OR APCS.[Der_Diagnosis_All] LIKE '%||K740%'
          )
          