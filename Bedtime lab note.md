
###### Bedtime article publication plan ##### 2026v

# data analysis 弄懂统计分析背后的知识原理
run the data to get the results 07/29
visualization in APA 07/30

# begin to write the article 07/30 - 08/13 建立学术文章知识库
introduction 07/30 - 08/05 (reference, tense check, revise the words and phases)
method 08/06 (double check)
result 08/07 - 08/08
discussion 08/09 - 08/13
submit to the journal 08/13

# revision and submit 08.13 - 
revise process with Dr. Yu 08/13 - 
collect the key concepts from the data analysis process and understand those concepts (相关、回归到底是什么概念)


# 07.29 Latest progress regarding the article publication
1. data analysis
1) clean data: 
  - delete the unrelated rows and columns
  - divide the data into two waves according to the different collection period
  - rename the variables using the numeric elements
  - check the test question and NA values - 0!!
  - divide the data into different subgroups based on the different questionnaires
  - check the reverse coded items in different questionnaires
  - combine the multiple subgroups into a complete and clean data frame

2) check the questionnaires' reliability and validity:
  - reliability test: cronbach's a >= .70
  - validity test: usually test construct validity CFI > .90, RMSEA < .08, SRMR < .08
CFA is the basis to run the final mediation analysis via lavaan(), because we need to build the latent factors to restore the most suitable variable model

 3) normal data analysis (N = 541):
   - Harman's single factor test to test common method bias (CMB)
   - settle the final data frame for each questionnaires (sum or mean)
   - check the difference between two waves
   - descriptive analysis
   - correlation analysis
   - multiple linear regression analysis
   - mediation analysis using lavaan()
   - moderated mediation analysis using modsem()
 
2. communicating with Dr.Yu
draft_v.1 sent: basic ideas about this article

3. concept understanding
concept of subgroup difference analysis


# 07.30 updated content
1. data analysis
visualization in APA

2. write the article
introduction: collect the targeted articles

3. communicate with Dr. Yu
sent the latest figure 3 final model

Summary: I truly felt the beauty of mathematic models by demostrating the deep mechanism of those seemingly messy numbers. Through models, we can change that chaos into some valuable findings to boost the development of science. Perhaps I haven't grasped the whole knowledge behind the statistical process; I gradually understand why we need to learn statistics and mathematical models to reveal behavioral science's patterns. I believe when we know the importance of the specific knowledge field, we will learn it more seriously, leading to some real difference compared to those machining-type learners. Therefore, I love the learning type of learning by doing. We need, so we learn.


# 07.30 research note
1. data analysis
final check with the appendix figures and tables (especially table 4 - 7 moderated mediation model knowledge)

2. write the article
introduction: begin to write the basic draft
  - analyze the structure of target journal
  - write the basic framework
  - check the requirements of the target journals - JAD

Summary: Today, I try to understand the difficult definition of structural path labels, like b1, b2, b3, c1, etc. At the beginning, I couldn't get the main point of this concept since we have already gotten those variable names. It is a little waste to rename the coefficients. But as I read those instructions line by line, I suddenly realized that the labels of those structural paths is used to save the coefficients of two variables' paths so that we can get the indirect effect or indirect structural path coefficients from one variable to another variable that is not connected with each other, named the (chain) mediation model. So all in all, the letter works for a variable name where different people have different values, while the label works for a path coefficient that only exists between two connected variables.



# 08.01 research note
1. write the article
introduction
- analyze two similar articles' structure
- write the draft

# 08.04 research note (rest for some days...., let's continue....)
1. write the article half

Summary: I discovered a really new concept, involution to describe the background of Chinese stressful academic atmosphere, while introducing the key variables, academic stress and bedtime procrastination or sleep problems. Good!‘

# 08.05 research note
1. write the article
introduction finalized! (reference, tense check)

# 08.06 research note
1. write the article
method finished

Summary: I totally understood the beauty of rechecking the previous materials. Since the method section is really similar with prior one, I need to write the new content based on my previous words and the standard of published article. During this process, I have a feeling that I realize the significance of reviewing, which is to iterate the previous version of ourselves. Through reviewing the content we created before, we can easily discover the good points and limitation. By correcting the limitation, we definitely complete a self-evolution or iteration to become a better man.


# 08.07 research note
1. write the article
result half of the whole section

Summary: Actually I felt very embarrassed to write the result section, especially the translating the results I ran. However, as I analyzed two similar articles, I gradually realized the core secret of the structure behind those seemingly unreasonable numbers and words. I can create my own logical blueprint to write the everything I ran before. Congrats! I believe I can write the following things tomorrow.


# 08.22 - 08. Revising advice from Dr. Yu
Hi Yanyan,

This improves a lot! Good job. This is a preferred story: Academic stress is associated with greater bedtime procrastination, partly through sequential associations involving social media addiction and depressive symptoms. The strength of the depressive-symptom–bedtime-procrastination association varies by chronotype, such that this association is weaker among individuals with greater eveningness. It should not be "Academic stress causes social media addiction, which causes depression, which causes bedtime procrastination, and eveningness protects against this process."

A few more suggestions:

Must change
1. Stop using causal language. T
2. Stop saying “full mediation.” => T
3. Fix/clarify chronotype coding. T
4. Add simple-slopes interaction plot. ? => T
5. Report CFA and measurement invariance (different waves) results fully. !! really important to develop => T
[I write the analysis process in the method section, but i didn't explain it in the result section]
7. Clarify why covariates were selected. => Physical activity T
8. Treat age correctly. ? re-run the models => age (num) - age_group (factor or categorical data) => regression, SEM, => Re-create the models T
9. Add at least one plausible alternative model/sensitivity analysis. => T
10. Remove the claim that preliminary regression “established” the mediation. T
11. Acknowledge the single-item academic stress measure. T

Nice to improve
12. Distinguish total effect, direct effect, and indirect effects clearly. => Re-calculate the result section T
[The original model misses some important content, resulting in the wrong total effect, and indirect effects => I need to re-write the whole result section to get the true values. OK, be patient!]
13. Report effect sizes and 95% CIs consistently. B, β T model 3 can't provide the beta T
14. Clearly distinguish the two survey waves from a longitudinal study (Maybe the cross-sectional study?). => T
15. Reduce the number of redundant analyses. => move the table 3 to the supplementary materials and words T

16. Besides, I need to check the sentence tense and detailed construct. (second round) 1000 words

Summary: I escaped from the review of this article for a while. But I really understand that I need to face the problem that I have encountered. Review actually is a difficult thing for me, which let me to get several lower scores in exams. I need to grasp the power of patience, review.

I came back to Netherlands. When I heard someone saying liberal arts are useless and very poor, I felt sad. Not only I am a liberal student, but also I have a totally different opinion. Mathematics, engineering, medicine indeed matter, but from my opinion, the life without words, liberal arts or spiritual things is just like a machine or AI, which is a life I don't want to live in the future. Therefore, whatever others say liberal arts are useless or poor, I will insist learning those beautiful treasure our ancestors left to us.
Maybe it's the situation in the Netherlands, but I think if someone mastering English or other languages very well, he or she comes to China, and definitely would live a wonderful life. Although the whole tendency is that those technologies associated with engineering or mathematics worth more value and money. But it doesn't mean that other disciplines are useless. I think the key thing during the learning process is to grasp multilevel knowledges and technologies, such as liberal arts, mathematics, neuroscience, etc. The multi-skilled talents are the people the future wants.
I always think that mathematics or statistics knowledges need to be translated into a more common format to benefit public, and the communication skill is the language or liberal arts. Keep learning, bro!
From another perspective, I seem to lose everything I have in China. This will let me go out of the comfort zone and grasp those skills that I haven't mastered, especially the science and engineering. And that is the key thing I came to Netherlands. You don't need to think others' evaluation, you just keep learning and improving yourself, especially the quantitative field. Be patient! There is a old saying in China:"他山之石，可以攻玉”, I believe as a culture bridge communicator, I can grasp the benefits from both sides: the convenient and advanced living and the rigorous teaching and research attitude. Learning forever!

08.31 research note
During the data analysis process, I really saw my weakness, or the things that I can improve in the next step. While analyzing, I realized that I can deal with those scales better, which will help me analyze those data better. Firstly, I should collect the real age number rather than the range, so I can regard these numbers as the continuous variable rather than the factor. Secondly, for the core variables, I need to select the professional scales rather than the one-item scale. Anyway, I really learn a lot during this process and I am excited to do the subsequent research, such as longitudinal or daily diary research to further explore the relationship between these variables :) Crazy!

This article is apporoaching the end, I truly experience the beauty of analyzing data and summarizing a article. Oh, this is research! I can't believe if I find other fields that I interest or I learn other fantastic techniques to boost the research, how enjoyable I am! Although, I hope to learn other advanced research techniques, but I hope to continue doing this area via longitudinal measures or other interesting methods. I believe I will feel the mystery and beauty of the research!

# 09.04 Self revision before the end of Sept.
1. Check the guideline of the target journal T

2. Revise according to the AI T













