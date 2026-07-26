             #####################################
             ####### Bedtime data analysis #######
             #####################################

### Preface ### N = 543
# raw: raw data from excel == df_waves: raw data conbined from wave1 (2024 collected) and wave2 (2026 collected)
#   wave1_raw/final: first wave; wave2_raw/final: second wave
# clean_test: data without missing value and insufficient data
# clean_gender: the remain data after getting rid of the "other" option
# clean_effective: effective questionnaire data without sub-items and non-rated items
# df_final: effective questionnaire data with reversed-coded correction
# df_final_w: include the char and numeric variable of different waves - final analysis data frame for multiple linear regression and chain mediation within moderation analysis
# df_cor: correlation data frame
#效度paper check 统计分析的概念理解




####### 1.1 数据前置处理以确保能顺利进行分析 clean data #######
# import the data
getwd()
setwd("/Users/heyanyan/Desktop/Research/✅Online Yu - Research/2.0_Bedtime")
install.packages("readxl")
library(readxl)
raw <- read_excel("1.0_raw.xlsx")

head(raw)
ncol(raw)#79
nrow(raw)#595

# working on column: delete 8 columns' data due to the null meaning
# raw$序号 <- NULL
raw$提交答卷时间 <- NULL
raw$所用时间 <- NULL
raw$`知情同意书：阅读上面的说明。如果您同意并同意上述内容，请点击“是，我同意”。 下面的按钮开始回答问题。 如果您不同意或不同意上述内容，请点击“不，我不同意”。 下面的按钮可终止此调查问卷项目。`<- NULL
raw$来自IP <- NULL
raw$总分 <- NULL
raw$来源详情 <- NULL
raw$来源 <- NULL
ncol(raw)#72

# divide two waves of data collection into two waves in order to check the difference
head(raw)
install.packages("dplyr")
library(dplyr)
wave1_raw <- raw %>%
  filter(raw$序号 <= 209)
nrow(wave1_raw)
tail(wave1_raw)

wave2_raw <- raw %>%
  filter(raw$序号 > 209)
nrow(wave2_raw)
head(wave2_raw)
386 + 209 # 595
install.packages("dplyr")
library(dplyr)
df_waves <- bind_rows(wave1_raw, wave2_raw)
df_waves
ncol(df_waves) #72

# working on column: replace the original name to better divide different scales' data
names(df_waves) <- c("pp_code", "age", "gender", "student_id", # 4
                "BP_1", "BP_2", "BP_3","BP_4", "BP_5", "BP_6", "BP_7", "BP_8", "BP_9", # 9
                "ME_1", "ME_2", "ME_3", "ME_4", "ME_5", # 5
                "PA_1.1", "PA_1.2", "PA_1.3", "PA_1.4", "PA_1.5", "PA_1.6", "PA_1.7", "PA_1.8", "PA_1.9", "PA_1.10", "PA_1.11", "PA_1.12", "PA_1.13", "PA_1.14", "PA_1.15", "PA_1.16", "PA_1.17", "PA_1.18", "PA_1.19", "PA_1.20", "PA_1.21", "PA_1.22", "PA_1.23",
                "PA_2", "PA_3", "PA_4", "PA_5", "PA_6", "PA_7.1", "PA_7.2", "PA_7.3", "PA_7.4", "PA_7.5", "PA_7.6", "PA_7.7", "PA_test", "PA_8", # 37
                "SM_1","SM_2", "SM_3", "SM_4", "SM_5", "SM_6", # 6
                "S_1", # 1
                "DP_1", "DP_2", "DP_3", "DP_4", "DP_5", "DP_6", "DP_7", "DP_8", "DP_9", "DP_10") # 10

df_waves[,c(1,2,3,4,5,6,7,8,9,10)]#double-check
df_waves[,c(11,12,13,14,15,16,17)]
head(df_waves)

# working on row/pp: detect and exclude the invalid participants' data: 
# 1) PA_test: 52
install.packages("dplyr")
library(dplyr)
# create a new df to exclude those data that didn't pass the test
clean_test <- df_waves %>%
  filter(PA_test == 2) # 2 == B
num_excluded <- nrow(df_waves) - nrow(clean_test)
num_excluded # 52
nrow(clean_test) # target data = 543

head(clean_test)
table(clean_test$gender)
# 2) create a new df to exclude the gender data that belongs to the "other" type
clean_gender <- clean_test %>%
  filter(gender != 3) # 3 == other
nrow(clean_gender) # target data = 541

# 3) NA: 0
install.packages("naniar")
library(naniar)
vis_miss(clean_gender) #0
gg_miss_var(clean_gender) #0

ncol(clean_gender)#72
nrow(clean_gender)#541

# divide the data to different sub-groups to run the following analysis,according to corresponding scales
head(clean_gender)
des_clean <- clean_gender[,c(1,2,3,4)]
des_clean
nrow(des_clean) #check 541
ncol(des_clean) #check 4

BP_clean <- clean_gender[,c(5,6,7,8,9,10,11,12,13)]
BP_clean
nrow(BP_clean) #check 541
ncol(BP_clean) #check 9

ME_clean <- clean_gender[,c(14,15,16,17,18)]
ME_clean
nrow(ME_clean) #check 541
ncol(ME_clean) #check 5

PA_clean <- clean_gender[,c(19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55)]
PA_clean
nrow(PA_clean) #check 541
ncol(PA_clean) #check 37 (PA_test:clean_test[,c(54)])
# delete the PA_test
PA_clean$PA_test <- NULL
PA_clean$PA_8 <- NULL #功能性测试 不计分
ncol(PA_clean) #check 35
install.packages("dplyr")
library(dplyr)
PA_clean <- PA_clean %>%
  mutate(
    PA_1 = rowMeans(select(., PA_1.1:PA_1.23), na.rm = TRUE), # accumulate all sub-items into one total item
    PA_7 = rowMeans(select(., PA_7.1:PA_7.7), na.rm = TRUE)
  )
names(PA_clean) #PA_1:PA_7 Combine the sub-items in the PA_1 and PA_7
PA_clean_concentrated <- PA_clean[c(36, 24, 25, 26, 27, 28, 37)]
names(PA_clean_concentrated)
PA_clean_concentrated

SM_clean <- clean_gender[,c(56,57,58,59,60,61)]
SM_clean
nrow(SM_clean) #check 541
ncol(SM_clean) #check 6

S_clean <- clean_gender[,c(62)]
S_clean
nrow(S_clean) #check 541
ncol(S_clean) #check 1

DP_clean <- clean_gender[,c(63,64,65,66,67,68,69,70,71,72)]
DP_clean
nrow(DP_clean) #check 541
ncol(DP_clean) #check 10
DP_clean$DP_10 <- NULL
ncol(DP_clean) #check 9

#combine the multiple df: cbind(, ,) or left_join() from dplyr packages using the target: pp_id
clean_effective <- cbind(des_clean, BP_clean, ME_clean, PA_clean_concentrated, SM_clean, S_clean, DP_clean)
head(clean_effective)
nrow(clean_effective) # 541 = final participants' number
ncol(clean_effective)# 41

# check the reverse coded item => 第X题为反向计分题，已进行反向转换 [before checking the reliability via alpha() or we can use the check.keys = TRUE command to help us automatically find the reverse-coded items via principal component 主成分分析]
# BP 2,3,7,9
BP_clean$BP_2_r <- 6 - BP_clean$BP_2 # 5+1 - x
BP_clean$BP_3_r <- 6 - BP_clean$BP_3
BP_clean$BP_7_r <- 6 - BP_clean$BP_7
BP_clean$BP_9_r <- 6 - BP_clean$BP_9
names(BP_clean)
BP_clean$BP_2 <- NULL
BP_clean$BP_3 <- NULL
BP_clean$BP_7 <- NULL
BP_clean$BP_9 <- NULL
names(BP_clean)
BP_clean_order <- BP_clean[, c(1,6,7,2,3,4,8,5,9)]
names(BP_clean_order)

# ME 2
ME_clean$ME_2_r <- 5 - ME_clean$ME_2
ME_clean$ME_2 <- NULL
names(ME_clean)
ME_clean_order <- ME_clean[, c(1,5,2,3,4)]
names(ME_clean_order)

# PA no need == higher scores indicate higher PA

# SM no need == higher scores indicate higher addiction to SM

# S one item == no need

# DP no need == higher scores indicate higher DP

# combine multiple data frame into a complete one
df_final <- cbind(des_clean, BP_clean_order, ME_clean_order, PA_clean_concentrated, SM_clean, S_clean, DP_clean)
head(df_final)
str(df_final)
nrow(df_final) # 541
ncol(df_final) # 41








####### 1.2 检查所用问卷的信度和效度 questionnaire check #######
# check the questionnaires' reliability and validity with new data 证明量表在这批学生样本中是可用的
## reliability testing 信度检验：检查一个量表测量的一致性和稳定性 cronbach's a (a >= .70)
install.packages("psych")
library(psych) #check.keys = TRUE
alpha(BP_clean %>% select(BP_1, BP_2_r, BP_3_r, BP_4, BP_5, BP_6, BP_7_r, BP_8, BP_9_r)) #raw_alpha = 0.87
alpha(ME_clean %>% select(ME_1, ME_2_r, ME_3, ME_4, ME_5)) #raw_alpha = 0.7
alpha(PA_clean %>% select(PA_1, PA_2, PA_3, PA_4, PA_5, PA_6, PA_7)) #raw_alpha = 0.87
alpha(SM_clean %>% select(SM_1:SM_6)) #raw_alpha = 0.89
alpha(DP_clean %>% select(DP_1:DP_9)) #raw_alpha = 0.9 (without the DP_10 附加功能损害评估题)

## validity testing 效度检验：这个量表测到了它声称要测的东西 (content validity 内容 == 专家评审, criterion validity 效标 量表分数和另一个已知有效的指标是否相关, construct validity 结构 题目结构是否真的如理论所说，聚成了预期的维度或同一个因子，而不是分裂成了两三个不相关的小群 == 能用统计方法直接检验、也是最常见需要报告的)
## confirmatory factor analysis (CFA) to test construct validity (CFI > .90, RMSEA < .08, SRMR < .08)
# 1) before: single factor or? from theory: original articles 2) fitted models via cfa() including single or two-factors 3) exploratory via fa.parallel()
install.packages("lavaan")
library(lavaan)
BP_model <- 'bedtime_procrastination =~ BP_1 + BP_2_r + BP_3_r + BP_4 + BP_5 + BP_6 + BP_7_r + BP_8 + BP_9_r'
fit_factor <- cfa(BP_model, data = BP_clean)
summary(fit_factor, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.93, RMSEA = 0.103, SRMR = 0.056 => RMSEA (reverse-coded items' method effect)
modindices(fit_factor, sort = TRUE) %>% head(10) #high mi



BP_model_revised <- 'bedtime_procrastination =~ BP_1 + BP_2_r + BP_3_r + BP_4 + BP_5 + BP_6 + BP_7_r + BP_8 + BP_9_r
  BP_2_r ~~ BP_3_r # (Add a residual covariance term)
  BP_2_r ~~ BP_7_r
  BP_2_r ~~ BP_9_r
  BP_3_r ~~ BP_7_r
  BP_3_r ~~ BP_9_r
  BP_7_r ~~ BP_9_r'
fit_revised <- cfa(BP_model_revised, data = BP_clean)
summary(fit_revised, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.986, RMSEA = 0.052, SRMR = 0.022 (Add a residual covariance term)

BP_model_method <- '  #method factor 方法因子（把其中四道反向共同的方差单独建摸出来）
  bedtime_procrastination =~ BP_1 + BP_2_r + BP_3_r + BP_4 + BP_5 + BP_6 + BP_7_r + BP_8 + BP_9_r
  method_reverse =~ BP_2_r + BP_3_r + BP_7_r + BP_9_r
  method_reverse ~~ 0*bedtime_procrastination   # 方法因子与实质因子正交（不相关）
'
fit_method <- cfa(BP_model_method, data = BP_clean)
summary(fit_method, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.985, RMSEA = 0.052, SRMR = 0.023

ME_model <- 'Morningness_Eveningness =~ ME_1 + ME_2_r + ME_3 + ME_4 + ME_5'
fit_factor <- cfa(ME_model, data = ME_clean)
summary(fit_factor, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.991, RMSEA = 0.038, SRMR = 0.020

PA_model <- 'Physical_Activity =~ PA_1 + PA_2 + PA_3 + PA_4 + PA_5 + PA_6 + PA_7'
fit_factor <- cfa(PA_model, data = PA_clean)
summary(fit_factor, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.97, RMSEA = 0.080, SRMR = 0.032 => RMSEA 正好0.08?
modindices(fit_factor, sort = TRUE) %>% head(5)

PA_model_revised <- 'Physical_Activity =~ PA_1 + PA_2 + PA_3 + PA_4 + PA_5 + PA_6 + PA_7
  PA_6 ~~ PA_7'
fit_PA_revised <- cfa(PA_model_revised, data = PA_clean)
summary(fit_PA_revised, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.982, RMSEA = 0.064, SRMR = 0.027

SM_model <- 'social_media_use =~ SM_1 + SM_2 + SM_3 + SM_4 + SM_5 + SM_6'
fit_factor <- cfa(SM_model, data = SM_clean)
summary(fit_factor, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.877, RMSEA = 0.22, SRMR = 0.072 => CFI, RMSEA 太高 => 需要非常低
residuals(fit_factor, type = "cor")$cov # Standardized Residual Correlation Matrix 标准化残差相关矩阵
modindices(fit_factor, sort = TRUE) %>% head(10) # modification indices => SM_1 & SM_2 mi is very high

SM_model_revised <- 'social_media_use =~ SM_1 + SM_2 + SM_3 + SM_4 + SM_5 + SM_6
  SM_1 ~~ SM_2' # (Add a residual covariance term) 
fit_SM_revised <- cfa(SM_model_revised, data = SM_clean)
summary(fit_SM_revised, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.992, RMSEA = 0.060, SRMR = 0.021
modindices(fit_SM_revised, sort = TRUE) %>% head(10) # good!

DP_model <- 'depression =~ DP_1 + DP_2 + DP_3 + DP_4 + DP_5 + DP_6 + DP_7 + DP_8 + DP_9'
fit_factor <- cfa(DP_model, data = DP_clean)
summary(fit_factor, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.91, RMSEA = 0.122, SRMR = 0.055 => RMSEA
modindices(fit_factor, sort = TRUE) %>% head(10) # => mi不是一枝独秀，也就是说PHQ-9可能是两因子

DP_model_2factor <- '
  somatic =~ DP_3 + DP_4 + DP_5 + DP_7 + DP_8
  cognitive_affective =~ DP_1 + DP_2 + DP_6 + DP_9
'
fit_2factor <- cfa(DP_model_2factor, data = DP_clean)
summary(fit_2factor, fit.measures = TRUE, standardized = TRUE)
# CFI = 0.917, RMSEA = 0.12, SRMR = 0.054

# 和原来的单因子模型比较拟合优劣
anova(fit_factor, fit_2factor)

# 也可以直接对比AIC/BIC（数值更小更好）
fitMeasures(fit_factor, c("aic", "bic"))
fitMeasures(fit_2factor, c("aic", "bic")) # => 还是单因子模型

DP_model_revised <- '
   depression =~ DP_1 + DP_2 + DP_3 + DP_4 + DP_5 + DP_6 + DP_7 + DP_8 + DP_9
   DP_3 ~~ DP_4
   DP_4 ~~ DP_9
   DP_8 ~~ DP_9
   DP_6 ~~ DP_8
   '
fit_DP_revised <- cfa(DP_model_revised, data = DP_clean)
summary(fit_DP_revised, fit.measures = TRUE, standardized = TRUE)







####### 2.1 正式进入数据分析 data analysis ####### (N = 541)
# 2.1.1 Harman's single-factor test to test common method bias (CMB) first factor < 40% or 50%
install.packages("psych")
library(psych)
head(df_final)
nrow(df_final)#541
df_final_num <- df_final
df_final_num$pp_code <- NULL
df_final_num$age <- NULL
df_final_num$gender <- NULL
df_final_num$student_id <- NULL
df_final_num

ev <- eigen(cor(df_final_num, use = "pairwise.complete.obs"))$values
sum(ev > 1) # 6

efa_result <- fa(df_final_num, nfactors = sum(ev > 1), rotate = "none", fm = "pa")
efa_result$Vaccounted # proportion var = 24% < 40% = no common method bias

# 2.1.2 create the final two difference collection waves to run the check test and add the wave item
nrow(df_final)#541
wave1_final <- df_final %>%
  filter(df_final$pp_code <= 209)
nrow(wave1_final) # 194
tail(wave1_final)

wave2_final <- df_final %>%
  filter(df_final$pp_code > 209)
nrow(wave2_final) # 347
tail(wave2_final)
347 + 194 # 541

wave1_final$wave <- "Wave1"
wave2_final$wave <- "Wave2"
df_final_w <- bind_rows(wave1_final, wave2_final)
head(df_final_w)

# 2.1.3 create the final sub-questionnaire total objects 
str(df_final_w)
df_final_w <- df_final_w %>%
  mutate(wave_num = case_when(
    wave == "Wave1" ~ 1,
    wave == "Wave2" ~ 2,
    TRUE ~ NA_real_
  ))
nrow(df_final_w) #541

# final each variable's data frame: pp_code, age, gender, student_ide, wave, BP_total, S_1, ME_total, PA_total, SM_total, DP_total
library(dplyr)
df_final_w <- df_final_w %>%
  mutate(
    BP_total = rowSums(select(., BP_1:BP_9_r), na.rm = TRUE),
    ME_total = rowSums(select(., ME_1:ME_5), na.rm = TRUE),
    PA_total = rowMeans(select(., PA_1:PA_7), na.rm = TRUE),
    SM_total = rowSums(select(., SM_1:SM_6), na.rm = TRUE),
    DP_total = rowSums(select(., DP_1:DP_9), na.rm = TRUE)
  )
str(df_final_w)

pp_code <- df_final_w$pp_code
age <- df_final_w$age
gender <- df_final_w$gender
student_id <- df_final_w$student_id
wave <- df_final_w$wave_num
BP_total <- df_final_w$BP_total
ME_total <- df_final_w$ME_total
PA_total <- df_final_w$PA_total
SM_total <- df_final_w$SM_total
DP_total <- df_final_w$DP_total
S_total <- df_final_w$S_1

# 2.1.4 check the difference between two waves
# descriptive composition：人口统计学构成是否有系统性差异：年龄连续变量-t-test,性别、学生身份分类变量-chi-squire 卡方检验 两组数据
t.test(age ~ wave, data = df_final_w) # p = 0.48 > 0.05 not significant

chisq.test(table(df_final_w$wave, df_final_w$gender)) # p < 2.2e-16 < 0.05 significant - gender has significant difference between two collection waves
table(df_final_w$wave, df_final_w$gender)
prop.table(table(df_final_w$wave, df_final_w$gender), margin = 1)

chisq.test(table(df_final_w$wave, df_final_w$student_id)) # p = 0.1076 not significant

fisher.test(table(df_final_w$wave, df_final_w$gender)) # after-check
fisher.test(table(df_final_w$wave, df_final_w$student_id)) # after-check

# VIF 方差膨胀因子: gender is correlated with wave 检测是否有较强共线性
install.packages("car")
library(car)
str(df_final_w)
vif_check_model <- lm(BP_total ~ wave + gender + age, data = df_final_w)
vif(vif_check_model) # VIF < 3 = both variables can put into the final model
# wave和gender在数据分布上确实存在一定关联（刻意在第二批多招募了男性），但这种关联的程度还不足以在模型里造成实质性的共线性，也就是说模型能比较干净地把“批次的独立贡献”和“性别的独立贡献”分开估计，不会互相干扰到无法解读的地步。

# Measurement invariance - CFA comparasion 跨批次测量不变性检验 - 两批数据能不能放心当作同一个总体、合并起来分析
# 比较指标：如果anova()比较的p值都不显著（p>.05），或者每一步CFI下降幅度小于.01（ΔCFI<.01，这是最常用的判断标准，来自Cheung & Rensvold, 2002）
install.packages("lavaan")
library(lavaan)

BP_model_revised <- 'bedtime_procrastination =~ BP_1 + BP_2_r + BP_3_r + BP_4 + BP_5 + BP_6 + BP_7_r + BP_8 + BP_9_r
  BP_2_r ~~ BP_3_r # (Add a residual covariance term)
  BP_2_r ~~ BP_7_r
  BP_2_r ~~ BP_9_r
  BP_3_r ~~ BP_7_r
  BP_3_r ~~ BP_9_r
  BP_7_r ~~ BP_9_r
'
# configural invariance 结构、因子结构（SEM模型能合并跑的根本指标）相同，载荷、载距都不限制相等
fit_configural <- cfa(BP_model_revised, data = df_final_w, group = "wave")
# metric invariance 在结构相同基础上，限制因子载荷在两组相等 = 题目和构念之间的关联强度
fit_metric <- cfa(BP_model_revised, data = df_final_w, group = "wave", group.equal = "loadings")
# scalar invariance 在载荷相等基础上进一步限制题目截距也相等
fit_scalar <- cfa(BP_model_revised, data = df_final_w, group = "wave", group.equal = c("loadings", "intercepts"))
# 逐层比较，看每加一层限制，模型拟合是否显著变差
anova(fit_configural, fit_metric) # 0.902
anova(fit_metric, fit_scalar) # 0.0006
# 直接看CFI下降幅度
fitMeasures(fit_configural, "cfi") # 0.976
fitMeasures(fit_metric, "cfi") # 0.979
fitMeasures(fit_scalar, "cfi") # 0.969

DP_model_revised <- '
   depression =~ DP_1 + DP_2 + DP_3 + DP_4 + DP_5 + DP_6 + DP_7 + DP_8 + DP_9
   DP_3 ~~ DP_4
   DP_4 ~~ DP_9
   DP_8 ~~ DP_9
   DP_6 ~~ DP_8
   '
fit_configural <- cfa(DP_model_revised, data = df_final_w, group = "wave")
fit_metric <- cfa(DP_model_revised, data = df_final_w, group = "wave", group.equal = "loadings")
fit_scalar <- cfa(DP_model_revised, data = df_final_w, group = "wave", group.equal = c("loadings", "intercepts"))

# 逐层比较，看每加一层限制，模型拟合是否显著变差
anova(fit_configural, fit_metric) # p = 0.013 < 0.05
anova(fit_metric, fit_scalar) # P = 0.096 > 0.05

# 直接看CFI下降幅度
fitMeasures(fit_configural, "cfi") # 0.964
fitMeasures(fit_metric, "cfi") # 0.959
fitMeasures(fit_scalar, "cfi") # 0.957

SM_model_revised <- 'social_media_use =~ SM_1 + SM_2 + SM_3 + SM_4 + SM_5 + SM_6
  SM_1 ~~ SM_2' # (Add a residual covariance term) 
fit_configural <- cfa(SM_model_revised, data = df_final_w, group = "wave")
fit_metric <- cfa(SM_model_revised, data = df_final_w, group = "wave", group.equal = "loadings")
fit_scalar <- cfa(SM_model_revised, data = df_final_w, group = "wave", group.equal = c("loadings", "intercepts"))
# 逐层比较，看每加一层限制，模型拟合是否显著变差
anova(fit_configural, fit_metric) # p = 0.07 > 0.05
anova(fit_metric, fit_scalar) # P = 0.15 > 0.05
# 直接看CFI下降幅度
fitMeasures(fit_configural, "cfi") # 0.977
fitMeasures(fit_metric, "cfi") # 0.975
fitMeasures(fit_scalar, "cfi") # 0.973

# 2.1.5 descriptive analysis 不同量表的数据特征 n(%) (N = 541)
nrow(des_clean)# 541
psych::describe(des_clean)
table(df_final_w$wave) # wave 1 194 wave 2 349
prop.table(table(df_final_w$wave)) *100 # 35.7% 64.3%

table(df_final_w$gender) # male 250 female 291
prop.table(table(df_final_w$gender)) *100 # 46.0% 53.6% 0.4%

table(df_final_w$age) # 205 304 20 7 7
prop.table(table(df_final_w$age)) *100 # 37.8% 55.9% 3.7% 1.3% 1.3%

table(df_final_w$student_id) # 502 30 6 5
prop.table(table(df_final_w$student_id)) *100 # 92.5% 5.5% 1.1% 0.9%

psych::describe(S_clean) # mean = 3.43, sd = 1.06
psych::describe(SM_total) # mean = 17.23, sd = 5.51
psych::describe(DP_total) # mean = 16.57, sd = 5.41
psych::describe(BP_total) # mean = 27.82, sd = 7.14
psych::describe(ME_total) # mean = 16.62, sd = 3.13
psych::describe(PA_total) # mean = 1.83, sd = 0.73

# 2.1.6 correlation analysis (N = 541)
df_cor <- data.frame(S_total, SM_total, DP_total, BP_total, ME_total, PA_total)
df_cor
nrow(df_cor)#541
cor(df_cor) #相关系数矩阵

install.packages("psych")
library(psych)
corr.test(df_cor)

install.packages("Hmisc")
library(Hmisc)
res <- rcorr(as.matrix(df_cor))
res$r #相关系数矩阵 = cor()
res$P #p值矩阵
res$n #每对变量实际参与计算的样本量

# directly output the complete correlation table from R 不准
install.packages("apaTables")
library(apaTables)
apa.cor.table(df_cor, filename = "Table_Correlations.doc", show.conf.interval = FALSE)

# 2.1.7 multiple linear regression analysis (N = 541)
# age: continuous = numeric, gender: categorical = factor(delete two pp), student_id: cate = factor, wave: two levels = numeric

df_final_w$gender <- factor(
  df_final_w$gender,
  levels = c(1,2,3),
  labels = c("Male", "Female", "Other")
)
levels(df_final_w$age)

df_final_w <- df_final_w %>% filter(gender != "Other") # delete the "other" level
df_final_w$gender <- droplevels(df_final_w$gender)
levels(df_final_w$gender)
names(df_final_w) # check other variabls' column data were deleted accordingly.

nrow(df_final_w) #541 = 543 - 2
S_total <- df_final_w$S_total

df_final_w$student_id <- factor(
  df_final_w$student_id,
  levels = c(1,2,3,4),
  labels = c("Undergraduate", "Master's", "Doctoral", "Other")
)
levels(df_final_w$student_id)

str(df_final_w)
table(df_final_w$student_id)

age <- df_final_w$age
gender <- df_final_w$gender
student <- df_final_w$student_id
wave <- df_final_w$wave
str(df_final_w)

model_lm <- lm(BP_total ~ S_1 + SM_total + DP_total + PA_total + ME_total + age + gender + student + wave, data = df_final_w)
summary(model_lm)
# contrasts can be applied only to factors with 2 or more levels => fixed through changing into the factors with multiple levels' variables

install.packages("lm.beta")
library(lm.beta) # β
model_lm_std <- lm.beta(model_lm)
summary(model_lm_std)

library(car)
vif(model_lm) # VIF < 3

# residual normality 残差正态性
plot(model_lm, which = 2) # Q_Q = 看残差是否大致落在对角线
shapiro.test(residuals(model_lm)) # p > .05 = 没有检测到统计学的显著差异说明残差偏离了正态分布 = 符合正态分布

# 同方差性
plot(model_lm, which = 1) # residuals vs fitted

install.packages("lmtest")
library(lmtest)
bptest(model_lm) # Breusch-Pagan test p <.05 = 异方差存在问题

# 强影响点/离群值
plot(model_lm, which = 4) # Cook's distance = 找出对模型影响过大的个别观测值 175, 319, 528

# directly output the complete correlation table from R
library(apaTables)
apa.reg.table(model_lm, filename = "Table_3")


# 2.1.8 mediation analysis using lavaan() (N = 541) 需要掌握重要知识

# step 1: main model without moderator: chronotype (measure model, chain mediation and covariate variables)
str(df_final_w)
install.packages("lavaan")
install.packages("dplyr")
library(lavaan)
library(dplyr)

chain_model <-'
 # ---------- 测量模型 ---------- latent variable 潜变量 3 （Academic stress 单条目无法估计因子载荷，直接作为观察变量放进结构路径）
 SM =~ SM_1 + SM_2 + SM_3 + SM_4 + SM_5 + SM_6
 SM_1 ~~ SM_2
 
 DP =~ DP_1 + DP_2 + DP_3 + DP_4 + DP_5 + DP_6 + DP_7 + DP_8 + DP_9
 DP_3 ~~ DP_4
 DP_4 ~~ DP_9
 DP_8 ~~ DP_9
 DP_6 ~~ DP_8
 
 BP =~ BP_1 + BP_2_r + BP_3_r + BP_4 + BP_5 + BP_6 + BP_7_r + BP_8 + BP_9_r
 BP_3_r ~~ BP_7_r
 BP_3_r ~~ BP_9_r
 BP_7_r ~~ BP_9_r
 BP_2_r ~~ BP_9_r
 BP_2_r ~~ BP_3_r
 BP_2_r ~~ BP_7_r
 
 # ---------- 结构模型（链式中介 + 协变量）----------
 SM ~ a1*S_1 + age + gender + wave_num
 DP ~ a2*S_1 + d21*SM + age + gender + wave_num
 BP ~ cprime*S_1 + c_SM*SM + b1*DP + PA_total + age + gender + wave_num
 
 # ---------- 间接效应 ----------
 indirect_via_DP_only := a2*b1
 indirect_via_chain := a1*d21*b1
 total_indirect := indirect_via_DP_only + indirect_via_chain
 total_effect := cprime + indirect_via_DP_only + indirect_via_chain
'
fit_chain <- sem(chain_model, data = df_final_w, se = "bootstrap", bootstrap = 5000)
summary(fit_chain, standardized = TRUE, fit.measures = TRUE)
#CFI = 0.939, TLI = 0.93, RMSEA = 0.049, SRMR = 0.049 == indicating that the fitted model is overall good
parameterEstimates(fit_chain, boot.ci.type = "bca.simple") %>% filter(op == ":=") # p = .003 < .05

# step 2: moderated mediation: professional package to run the latent variables' interaction
install.packages("modsem")
library(modsem)

model_syntax <- '
  SM =~ SM_1 + SM_2 + SM_3 + SM_4 + SM_5 + SM_6
  SM_1 ~~ SM_2
  
  DP =~ DP_1 + DP_2 + DP_3 + DP_4 + DP_5 + DP_6 + DP_7 + DP_8 + DP_9
   DP_3 ~~ DP_4
  DP_4 ~~ DP_9
  DP_8 ~~ DP_9
  DP_6 ~~ DP_8

  BP =~ BP_1 + BP_2_r + BP_3_r + BP_4 + BP_5 + BP_6 + BP_7_r + BP_8 + BP_9_r
  BP_3_r ~~ BP_7_r
  BP_3_r ~~ BP_9_r
  BP_7_r ~~ BP_9_r
  BP_2_r ~~ BP_9_r
  BP_2_r ~~ BP_3_r
  BP_2_r ~~ BP_7_r

  ME =~ ME_1 + ME_2_r + ME_3 + ME_4 + ME_5

  SM ~ a1*S_1 + age + gender + wave_num
  DP ~ a2*S_1 + d21*SM + age + gender + wave_num
  BP ~ cprime*S_1 + c_SM*SM + b1*DP + b2*ME + b3*DP:ME + PA_total + age + gender + wave_num

  indirect_via_DP_only := a2*b1
  indirect_via_chain := a1*d21*b1
  index_mod_med := a1*d21*b3
'
fit_modsem <- modsem(model_syntax, data = df_final_w, method = "lms") # or other method = "qml
summary(fit_modsem)


# draw the plot
std_est <- standardized_estimates(fit_modsem)
std_est # get the std coefficients

library(modsem) # inner ggplot() from modsem package to reflect the interaction between DP,BP,ME(Chronotype)
plot_interaction(
  x = "DP",
  z = "ME",
  y = "BP",
  xz = "DP:ME",
  vals_z = c(-1, 1),
  model = fit_modsem
)

# apa type plot
library(ggplot2)
my_plot <- plot_interaction(
  x = "DP", z = "ME", y = "BP", xz = "DP:ME",
  vals_z = c(-1,1),
  model = fit_modsem
)
my_plot$data

apa_plot <- my_plot +
  aes(linetype = factor(cat_z)) +
  scale_color_manual(values = c("black", "black"), guide = "none") +
  scale_fill_manual(values = c("grey75", "grey75"), guide = "none") +
  scale_linetype_manual(
    values = c("-0.68" = "solid", "0.68" = "dashed"),
    labels = c("Morning-type (-1 SD)", "Evening-type (+1 SD)")
  ) +
  labs(
    title = NULL,
    x = "Depressive Symptoms (standardized)",
    y = "Bedtime Procrastination (standardized)",
    linetype = "Chronotype"
  ) +
  theme_classic(base_size = 12, base_family = "serif") +
  theme(
    legend.position = c(0.25, 0.85),
    legend.background = element_rect(fill = "white", color = "black", linewidth = 0.3),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.4),
    axis.text = element_text(color = "black")
  )

apa_plot

ggsave("Figure_ModerateMediation.png", plot = apa_plot,
       width = 6, height = 4.5, dpi = 300, units = "in")


