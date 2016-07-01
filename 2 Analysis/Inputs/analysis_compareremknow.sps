

GET DATA /TYPE=XLSX
 /FILE='D:\Dropbox\SCRIPPS\9 Deacon project\3 Analysis\3 Analysis inputs\Reported v1 and v2 (3-5 and 3-3)\AllMemScores.xlsx'
  /SHEET=name 'remknow'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.



*Sort Variables ############################################################################.
VALUE LABELS Condition
  1 'NoContext'
  2 'Context'
  3 'ContextControl'.
EXECUTE.
FORMATS  Condition(F3.0).
VARIABLE LABELS  Condition 'Experimental condition'.
FORMATS  overallDprime(F4.2).
FORMATS  overallSurehitrate(F4.2).
FORMATS NS_1(F3.0).
FORMATS NS_2(F3.0).
FORMATS NS_3(F3.0).
FORMATS NS_4(F3.0).
FORMATS RD_1(F3.0).
FORMATS RD_2(F3.0).
FORMATS RD_3(F3.0).
FORMATS RD_4(F3.0).
COMPUTE NSmean= (NS_1+NS_2+NS_3+NS_4)/4.
FORMATS NSmean(F3.2).
VARIABLE LABELS  NSmean 'Novelty Seeking score'.
COMPUTE RDmean= (RD_1+RD_2+RD_3+RD_4)/4.
FORMATS RDmean(F3.2).
VARIABLE LABELS  RDmean 'Reward dependency score'.
EXECUTE.

FORMATS  r_OverallOverall(F4.2).
FORMATS  r_SummSim(F4.2).
FORMATS  r_SummDis(F4.2).
FORMATS  r_SummR(F4.2).
FORMATS  r_SummN(F4.2).
FORMATS  r_CellSim_iR(F4.2).
FORMATS  r_CellSim_iN(F4.2).
FORMATS  r_CellDis_iR(F4.2).
FORMATS  r_CellDis_iN(F4.2).
FORMATS  r_OverallCueeffect(F4.2).
FORMATS  r_OverallItemeffect(F4.2).
FORMATS  r_CellSim_itemeffect(F4.2).
FORMATS  r_CellDis_itemeffect(F4.2).
FORMATS  r_CellR_cueeffect(F4.2).
FORMATS  r_CellN_cueeffect(F4.2).
VARIABLE LABELS  r_OverallOverall  'Overall remember rate'.
VARIABLE LABELS  r_SummSim  'Similar'.
VARIABLE LABELS  r_SummDis  'Dissimilar'.
VARIABLE LABELS  r_SummR  'Remember-Reward'.
VARIABLE LABELS  r_SummN  'Remember-Neutral'.
VARIABLE LABELS  r_CellSim_iR  'Similar-Reward'.
VARIABLE LABELS  r_CellSim_iN  'Similar-Neutral'.
VARIABLE LABELS  r_CellDis_iR  'Dissimilar-Reward'.
VARIABLE LABELS  r_CellDis_iN  'Dissimilar-Neutral'.
VARIABLE LABELS  r_OverallCueeffect  'Remember Similarity effect'.
VARIABLE LABELS  r_OverallItemeffect  'Remember Valence effect'.
FORMATS  k_OverallOverall(F4.2).
FORMATS  k_SummSim(F4.2).
FORMATS  k_SummDis(F4.2).
FORMATS  k_SummR(F4.2).
FORMATS  k_SummN(F4.2).
FORMATS  k_CellSim_iR(F4.2).
FORMATS  k_CellSim_iN(F4.2).
FORMATS  k_CellDis_iR(F4.2).
FORMATS  k_CellDis_iN(F4.2).
FORMATS  k_OverallCueeffect(F4.2).
FORMATS  k_OverallItemeffect(F4.2).
FORMATS  k_CellSim_itemeffect(F4.2).
FORMATS  k_CellDis_itemeffect(F4.2).
FORMATS  k_CellR_cueeffect(F4.2).
FORMATS  k_CellN_cueeffect(F4.2).
VARIABLE LABELS  k_OverallOverall  'Overall know rate'.
VARIABLE LABELS  k_SummSim  'Similar'.
VARIABLE LABELS  k_SummDis  'Dissimilar'.
VARIABLE LABELS  k_SummR  'Know-Reward'.
VARIABLE LABELS  k_SummN  'Know-Neutral'.
VARIABLE LABELS  k_CellSim_iR  'Similar-Reward'.
VARIABLE LABELS  k_CellSim_iN  'Similar-Neutral'.
VARIABLE LABELS  k_CellDis_iR  'Dissimilar-Reward'.
VARIABLE LABELS  k_CellDis_iN  'Dissimilar-Neutral'.
VARIABLE LABELS  k_OverallCueeffect  'Know Similarity effect'.
VARIABLE LABELS  k_OverallItemeffect  'Know Valence effect'.
EXECUTE.


FORMATS  accSummR(F4.2).
VARIABLE LABELS accSummR 'Reward (encoding task accuracy)'.
FORMATS  accSummN(F4.2).
VARIABLE LABELS accSummN 'Neutral (encoding task accuracy)'.
FORMATS  accValfx(F4.2).
VARIABLE LABELS  accValfx 'Effect of valence on encoding-task accuracy (reward - neutral)'.
EXECUTE.
COMPUTE rtValfx=rtSummN-rtSummR.
FORMATS  rtSummR(F4.2).
VARIABLE LABELS rtSummR 'Reward (encoding task RT)'.
FORMATS  rtSummN(F4.2).
VARIABLE LABELS rtSummN 'Neutral (encoding task RT)'.
FORMATS  rtValfx(F4.2).
VARIABLE LABELS  rtValfx 'RT speeding in encoding-phase task'.
EXECUTE.




COMPUTE rk_percentR = r_SummR + k_SummR. 
COMPUTE rk_percentN = r_SummN + k_SummN. 
EXECUTE. 
COMPUTE rp_R =r_SummR/rk_percentR. 
COMPUTE rp_N =r_SummN/rk_percentN. 
COMPUTE kp_R =k_SummR/rk_percentR. 
COMPUTE kp_N =k_SummN/rk_percentN. 
EXECUTE. 


COMPUTE test = rp_R +kp_R.
COMPUTE test = rp_N+kp_N.
EXECUTE. 



* (0) Selections! ##########################.

COMPUTE filter_Context_ContextControl_only=(Condition=2 OR Condition =3).
VARIABLE LABELS filter_Context_ContextControl_only 'Context & ContextControl only(FILTER)'.
VALUE LABELS filter_Context_ContextControl_only 0 'Not Selected' 1 'Selected'.
FORMATS filter_Context_ContextControl_only (f1.0).
EXECUTE.
COMPUTE filter_ContextControl_only=(Condition=3).
VARIABLE LABELS filter_ContextControl_only 'ContextControl only(FILTER)'.
VALUE LABELS filter_ContextControl_only 0 'Not Selected' 1 'Selected'.
FORMATS filter_ContextControl_only (f1.0).
EXECUTE.
COMPUTE filter_Context_NoContext_only=(Condition=2 OR Condition =1).
VARIABLE LABELS filter_Context_NoContext_only 'Context & NoContext only(FILTER)'.
VALUE LABELS filter_Context_NoContext_only 0 'Not Selected' 1 'Selected'.
FORMATS filter_Context_NoContext_only (f1.0).
EXECUTE.
COMPUTE filter_ContextOnly=(Condition = 2).
VARIABLE LABELS filter_ContextOnly 'Condition = 2 (FILTER)'.
VALUE LABELS filter_ContextOnly 0 'Not Selected' 1 'Selected'.
FORMATS filter_ContextOnly (f1.0).
EXECUTE.


* Context and NoContext only.
FILTER BY filter_Context_NoContext_only .
EXECUTE.

USE ALL.

SORT CASES  BY filter_Context_NoContext_only.
SPLIT FILE SEPARATE BY filter_Context_NoContext_only.
SPLIT FILE OFF.

* (1a) Graphs: Split by conditin (Remember&Know together) #######################################################################################.

* Context and NoContext only.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(r_SummR, 1) MEANSE(r_SummN, 1) 
    MEANSE(k_SummR, 1) MEANSE(k_SummN, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())  
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition/Memory type"))
  GUIDE: axis(dim(2), label("Mean remember/know rate"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Experimental condition"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  GUIDE: text.title(label("Remember and Know rates by valence and experimental condition"))
  SCALE: cat(dim(3), include("1",  "2"))
  SCALE: linear(dim(2), include(0,0.35))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1", "2", "3"))
  SCALE: cat(dim(1), include("0", "1", "2", "3"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.

* (1b) Graphs: Split by Memtype (Rem & know Separately) ##############################################################.
* Context and NoContext only.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(r_SummR, 1) MEANSE(r_SummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean remember rate"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Remember rates by valence and experimental condition"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(k_SummR, 1) MEANSE(k_SummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean know rate"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Know rates by valence and experimental condition"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.

* Valence effect. 
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(r_OverallItemeffect, 1) 
    MEANSE(k_OverallItemeffect, 1) Condition MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(2), label("Mean effect of valence"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Experimental condition"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("0", "1"))
  SCALE: linear(dim(2), include(-0.1, 0.1))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("1", "2", "3"))
  SCALE: cat(dim(1), include("1", "2", "3"))
  ELEMENT: interval(position(Condition*SUMMARY*INDEX), color.interior(Condition), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(Condition*(LOW+HIGH)*INDEX)), 
    shape.interior(shape.ibeam))
END GPL.



* (1c) Split by valence #########################################################.

* Context and NoContext only..
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(r_SummR, 1) MEANSE(k_SummR, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean Remember/Know rate"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Remember and Know rates for Rewarding items"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(r_SummN, 1) MEANSE(k_SummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))  
GUIDE: axis(dim(2), label("Mean Remember/Know rate"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Remember and Know rates for Neutral items"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.



* (1d) ContextControl only ###############################################################################.
FILTER BY filter_ContextControl_only.
EXECUTE.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(r_SummR, 1) MEANSE(r_SummN, 1) MEANSE(k_SummR, 
    1) MEANSE(k_SummN, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean Remember/Know rates"))
  GUIDE: text.title(label("Remember and Know rates by valence"))
  GUIDE: text.subtitle(label("									Remember																																																			    		Know"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "1.5",  "2", "3"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
USE ALL.



* (2a) STATS (all conditions) ###################################################. 

* (2b) STATS (Context and NoContext only). ##########################################.

FILTER BY filter_Context_NoContext_only .
EXECUTE.

* Full anova.
GLM r_SummR r_SummN k_SummR k_SummN BY Condition
  /WSFACTOR=MEMTYPE 2 Polynomial VALENCE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*MEMTYPE*VALENCE) 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=MEMTYPE VALENCE MEMTYPE*VALENCE
  /DESIGN=Condition.


* split by Condition/experiment.
SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.
      GLM r_SummR r_SummN k_SummR k_SummN
        /WSFACTOR=MEM 2 Polynomial VALENCE 2 Polynomial 
        /METHOD=SSTYPE(3)
        /CRITERIA=ALPHA(.05)
        /WSDESIGN=MEM VALENCE MEM*VALENCE.
         T-TEST PAIRS=r_SummR r_SummN r_SummR k_SummR WITH k_SummR k_SummN r_SummN k_SummN (PAIRED)
           /CRITERIA=CI(.9500)
           /MISSING=ANALYSIS.
SPLIT FILE OFF.

* split by memtype (rem only, know only).
GLM r_SummR r_SummN BY Condition
  /WSFACTOR=VALENCE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VALENCE 
  /DESIGN=Condition.
      T-TEST PAIRS=r_SummR WITH r_SummN (PAIRED)
        /CRITERIA=CI(.9500)
        /MISSING=ANALYSIS.
      T-TEST GROUPS=Condition(1 2)
        /MISSING=ANALYSIS
        /VARIABLES=r_SummR r_SummN
        /CRITERIA=CI(.95).
GLM k_SummR k_SummN BY Condition
  /WSFACTOR=VALENCE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VALENCE 
  /DESIGN=Condition.
      T-TEST PAIRS=k_SummR WITH k_SummN (PAIRED)
        /CRITERIA=CI(.9500)
        /MISSING=ANALYSIS.
      T-TEST GROUPS=Condition(1 2)
        /MISSING=ANALYSIS
        /VARIABLES=k_SummR k_SummN
        /CRITERIA=CI(.95).


* split by valence (reward only, neutral only).
GLM r_SummR k_SummR BY Condition
  /WSFACTOR=MEM 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=MEM 
  /DESIGN=Condition.
         T-TEST PAIRS=r_SummR WITH k_SummR (PAIRED)
           /CRITERIA=CI(.9500)
           /MISSING=ANALYSIS.
         T-TEST GROUPS=Condition(1 2)
           /MISSING=ANALYSIS
           /VARIABLES=r_SummR k_SummR
           /CRITERIA=CI(.95).
GLM r_SummN k_SummN BY Condition
  /WSFACTOR=MEM 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=MEM 
  /DESIGN=Condition.
         T-TEST PAIRS=r_SummN WITH k_SummN (PAIRED)
           /CRITERIA=CI(.9500)
           /MISSING=ANALYSIS.
         T-TEST GROUPS=Condition(1 2)
           /MISSING=ANALYSIS
           /VARIABLES=r_SummN k_SummN
           /CRITERIA=CI(.95).


USE ALL.
* #################################################################################.












 

*##################################################################################

* (3a) Control: Better remembering for rewarding items is just attention?.

SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.

      CORRELATIONS
        /VARIABLES=r_SummR 
         rtSummR accSummR 
        /PRINT=TWOTAIL NOSIG
        /MISSING=PAIRWISE.
      CORRELATIONS
        /VARIABLES=r_OverallItemeffect 
            rtValfx accValfx
        /PRINT=TWOTAIL NOSIG
        /MISSING=PAIRWISE.
      GGRAPH
        /GRAPHDATASET NAME="graphdataset" VARIABLES=accValfx r_OverallItemeffect MISSING=LISTWISE 
          REPORTMISSING=NO
        /GRAPHSPEC SOURCE=INLINE.
      BEGIN GPL
        SOURCE: s=userSource(id("graphdataset"))
        DATA: accValfx=col(source(s), name("accValfx"))
        DATA: r_OverallItemeffect=col(source(s), name("r_OverallItemeffect"))
        GUIDE: axis(dim(1), label("accValfx"))
        GUIDE: axis(dim(2), label("Remember Valence effect"))
        ELEMENT: point(position(accValfx*r_OverallItemeffect))
      END GPL.
SPLIT FILE OFF.



* Attentional disengagement for Neutral condition in Context condition produces better Rem?
COMPUTE filter_ContextOnly=(Condition=2).
VARIABLE LABELS filter_ContextOnly 'Context condition only'.
VALUE LABELS filter_ContextOnly 0 'Not Selected' 1 'Selected'.
FORMATS filter_ContextOnly (f1.0).
FILTER BY filter_ContextOnly.
EXECUTE.


USE ALL.


CORRELATIONS
  /VARIABLES=r_SummN r_OverallItemeffect accSummN accValfx
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


* Sim x Val ################################################.

FILTER BY filter_ContextOnly.
EXECUTE.

GLM r_CellSim_iR r_CellSim_iN r_CellDis_iR r_CellDis_iN k_CellSim_iR k_CellSim_iN k_CellDis_iR 
    k_CellDis_iN
  /WSFACTOR=Memtype 2 Polynomial Sim 2 Polynomial Val 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Memtype Sim Val Memtype*Sim Memtype*Val Sim*Val Memtype*Sim*Val.


* Proportion RemKnow ####################################################################################.
FILTER BY filter_Context_NoContext_only .
EXECUTE.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(rp_R, 2) MEANSE(rp_N, 2) 
    MEANSE(kp_R, 2) MEANSE(kp_N, 2) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean %"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("% Rem or Know"))
  GUIDE: text.footnote(label("Error Bars: +/- 2 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1", "2", "3"))
  SCALE: cat(dim(1), include("0", "1", "2", "3"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.
GLM rp_R rp_N kp_R kp_N BY Condition
  /WSFACTOR=MEM 2 Polynomial VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=MEM VAL MEM*VAL
  /DESIGN=Condition.
GLM rp_R rp_N BY Condition
  /WSFACTOR=VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VAL 
  /DESIGN=Condition.
GLM kp_R kp_N BY Condition
  /WSFACTOR=VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VAL 
  /DESIGN=Condition.




* Simple fx.
SPLIT FILE SEPARATE BY Condition.
T-TEST PAIRS=rp_R kp_R rp_R rp_N WITH rp_N kp_N kp_R kp_N (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.

SPLIT FILE OFF.
USE ALL. 
FILTER BY filter_Context_NoContext_only .
EXECUTE.

T-TEST GROUPS=Condition(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=rp_R rp_N kp_R kp_N
  /CRITERIA=CI(.95).




