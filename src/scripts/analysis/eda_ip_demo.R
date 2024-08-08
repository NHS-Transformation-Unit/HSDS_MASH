
# Age Demographics --------------------------------------------------------

spells_demo_age_df <- spells_df_proc %>%
  group_by(age_group) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE))

spells_demo_age_stats <- quantile(spells_df_proc$Age, probs = c(0.25, 0.50, 0.75))

# Age Demographics by Admission Group -------------------------------------

spells_demo_age_ag_df <- spells_df_proc %>%
  group_by(admission_group, age_group) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE))

spells_demo_age_ag_stats <- spells_df_proc %>%
  group_by(admission_group) %>%
  summarise(LQ = quantile(Age, probs = 0.25),
            Median = quantile(Age, probs = 0.50),
            UQ = quantile(Age, probs = 0.75)
  )


# Deprivation Decile Demographics -----------------------------------------

# Calculate CIs using Wilson Method
wilson_ci <- function(num, den, ci_level = 0.95){
  
  result <- binom.confint(x = num, n = den, methods = "wilson", conf.level = ci_level)
  return(result)
  
}

spells_demo_dep_df <- spells_df_proc %>%
  group_by(IMD_Decile) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE),
         GT = sum(Total, na.rm = TRUE)) %>%
  rowwise() %>%
  mutate(ci = list(wilson_ci(Total, GT))) %>%
  unnest(cols = ci)


# Comorbidities -----------------------------------------------------------

spells_demo_cmb_df <- spells_df_proc %>%
  mutate(Group = "All") %>%
  group_by(Group) %>%
  summarise(CC_AMI = sum(CC_AMI_Flag),
            CC_CVA = sum(CC_CVA_Flag),
            CC_CHF = sum(CC_CHF_Flag),
            CC_CTD = sum(CC_CTD_Flag),
            CC_DEM = sum(CC_DEM_Flag),
            CC_DIA = sum(CC_DIA_Flag),
            #CC_LIV = sum(CC_LIV_Flag),
            CC_PEP = sum(CC_PEP_Flag),
            CC_PVD = sum(CC_PVD_Flag),
            CC_PUL = sum(CC_PUL_Flag),
            CC_CAN = sum(CC_CAN_Flag),
            CC_DIACOM = sum(CC_DIACOM_Flag),
            CC_PARA = sum(CC_PARA_Flag),
            CC_REN = sum(CC_REN_Flag),
            CC_METC = sum(CC_METC_Flag),
            CC_SLD = sum(CC_SLD_Flag),
            CC_HIV = sum(CC_HIV_Flag)) %>%
  gather("Comorbidity", "Total", -c(1)) %>%
  mutate("Comorbidity_Name" = case_when(Comorbidity == "CC_AMI" ~ "Acute Myocardial Infarction",
                                        Comorbidity == "CC_CVA" ~ "Cerebral Vascular Accident",
                                        Comorbidity == "CC_CHF" ~ "Congestive Heart Failure",
                                        Comorbidity == "CC_CTD" ~ "Connective Tissue Disorder",
                                        Comorbidity == "CC_DEM" ~ "Dementia",
                                        Comorbidity == "CC_DIA" ~ "Diabetes",
                                        Comorbidity == "CC_PEP" ~ "Peptic Ulcer",
                                        Comorbidity == "CC_PVD" ~ "Peripheral Vascular Disease",
                                        Comorbidity == "CC_PUL" ~ "Pulmonary Disease",
                                        Comorbidity == "CC_CAN" ~ "Cancer",
                                        Comorbidity == "CC_DIACOM" ~ "Diabetes Complications",
                                        Comorbidity == "CC_PARA" ~ "Paraplegia",
                                        Comorbidity == "CC_REN" ~ "Renal Disease",
                                        Comorbidity == "CC_METC" ~ "Metastatic Cancer",
                                        Comorbidity == "CC_SLD" ~ "Severe Liver Disease",
                                        Comorbidity == "CC_HIV" ~ "HIV")) %>%
  mutate(Total_Spells = nrow(spells_df_proc),
         Prop = Total/Total_Spells)
  
