a m* Memtypes: dprime, surehit, rem, know, surerem, sureknow, assoc, assocpercentrec
 /FILE='/Users/EleanorL/Dropbox/SANDISK/9 Deacon project/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/'+

GET DATA /TYPE=XLSX
 /FILE='D:\Dropbox\SCRIPPS\9 Deacon project\3 Analysis\3 Analysis inputs\Reported v1 and v2 (3-5 and 3-3)\AllMemScores.xlsx'
  /SHEET=name 'surerem'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

*Sort Variables ############################################################################.
VALUE LABELS Condition
  1 'No Context'
  2 'Context'
  3 'Context Control'.
EXECUTE.

FORMATS NS_1(F3.0).
FORMATS NS_2(F3.0).
FORMATS NS_3(F3.0).
FORMATS NS_4(F3.0).
FORMATS RD_1(F3.0).
FORMATS RD_2(F3.0).
FORMATS RD_3(F3.0).
FORMATS RD_4(F3.0).
FORMATS  Condition(F3.0).
FORMATS  overallDprime(F4.2).
FORMATS  overallSurehitrate(F4.2).
FORMATS  OverallOverall(F4.2).
FORMATS  SummSim(F4.2).
FORMATS  SummDis(F4.2).
FORMATS  SummR(F4.2).
FORMATS  SummN(F4.2).
FORMATS  CellSim_iR(F4.2).
FORMATS  CellSim_iN(F4.2).
FORMATS  CellDis_iR(F4.2).
FORMATS  CellDis_iN(F4.2).
FORMATS  OverallCueeffect(F4.2).
FORMATS  OverallItemeffect(F4.2).
FORMATS  CellSim_itemeffect(F4.2).
FORMATS  CellDis_itemeffect(F4.2).
FORMATS  CellR_cueeffect(F4.2).
FORMATS  CellN_cueeffect(F4.2).
EXECUTE.
VARIABLE LABELS  Condition 'Experimental condition'.
VARIABLE LABELS  overallDprime  'Overall d'.
VARIABLE LABELS  overallSurehitrate  'Overall Sure-Hitrate'.
VARIABLE LABELS  OverallOverall  'Overall memory score'.
VARIABLE LABELS  SummSim  'Similar'.
VARIABLE LABELS  SummDis  'Dissimilar'.
VARIABLE LABELS  SummR  'Reward'.
VARIABLE LABELS  SummN  'Neutral'.
VARIABLE LABELS  CellSim_iR  'Similar-Reward'.
VARIABLE LABELS  CellSim_iN  'Similar-Neutral'.
VARIABLE LABELS  CellDis_iR  'Dissimilar-Reward'.
VARIABLE LABELS  CellDis_iN  'Dissimilar-Neutral'.
VARIABLE LABELS  OverallCueeffect  'Similarity effect'.
VARIABLE LABELS  OverallItemeffect  'Valence effect'.
EXECUTE.
COMPUTE NSmean= (NS_1+NS_2+NS_3+NS_4)/4.
FORMATS NSmean(F3.2).
VARIABLE LABELS  NSmean 'Novelty Seeking score'.
COMPUTE RDmean= (RD_1+RD_2+RD_3+RD_4)/4.
FORMATS RDmean(F3.2).
VARIABLE LABELS  RDmean 'Reward dependency score'.
EXECUTE.


* (0) Selections! ##########################.

COMPUTE filter_Context_ContextControl_only=(Condition=2 OR Condition =3).
VARIABLE LABELS filter_Context_ContextControl_only 'Context & ContextControl only(FILTER)'.
VALUE LABELS filter_Context_ContextControl_only 0 'Not Selected' 1 'Selected'.
FORMATS filter_Context_ContextControl_only (f1.0).
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

* ( Actually select) #############################################################.


* Context and NoContext only.
FILTER BY filter_Context_NoContext_only .  
*FILTER BY filter_ContextOnly.
EXECUTE.


*USE ALL.


EXAMINE VARIABLES=SummR SummN BY ExptVersion
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


STOP HERE 



DESCRIPTIVES VARIABLES=SummR SummN
  /STATISTICS=MEAN STDDEV.

* (1) GRAPHS #############################################################.


* By valence (Context and NoContext only).
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(SummR, 1) MEANSE(SummN, 1) 
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
  GUIDE: axis(dim(2), label("Mean memory score"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Memory for rewarding and neutral items (by Experimental Condition)"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
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
GLM SummR SummN BY Condition
  /WSFACTOR=VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*VAL) 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VAL 
  /DESIGN=Condition.





























* By valence.
GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(SummR, 1) MEANSE(SummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
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
  GUIDE: axis(dim(2), label("Mean memory score"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Memory for rewarding and neutral items (by Experimental Condition)"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0,0.3))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.


* By valence (ContextControl only).
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(SummR, 1) MEANSE(SummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("1", "2"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean memory score"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Memory for rewarding and neutral items (by Experimental Condition)"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.









* By similarity (only Context and ContextControl).
USE ALL.
FILTER BY filter_Context_ContextControl_only.
EXECUTE.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(SummSim, 1) MEANSE(SummDis, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
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
  GUIDE: axis(dim(3), label("Experimenta condition"))
  GUIDE: axis(dim(2), label("Mean memory score"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Mean memory for items presented with Similar and Dissimilar contexts (by Experimental condition)"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("2", "3"))
  SCALE: linear(dim(2), include(0, 0.3))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.
USE ALL.

* Similarity x Valence (only Context and ContextControl).
FILTER BY filter_Context_ContextControl_only.
USE ALL.
EXECUTE.


GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(CellSim_iR, 1) MEANSE(CellSim_iN, 
    1) MEANSE(CellDis_iR, 1) MEANSE(CellDis_iN, 1) MISSING=LISTWISE REPORTMISSING=NO
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
  GUIDE: axis(dim(3), label("Condition"))
  GUIDE: axis(dim(2), label("Mean"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Memory by Similarity x Valence in each experimental condition"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: linear(dim(2), include(0,0.3))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1", "2", "3"))
  SCALE: cat(dim(1), include("0", "1", "2", "3"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.

* (2) STATS #############################################################.

* Context and NoContext only.
FILTER BY filter_Context_NoContext_only .
EXECUTE.


*USE ALL.



ONEWAY OverallOverall BY Condition
  /STATISTICS HOMOGENEITY 
  /MISSING ANALYSIS
  /POSTHOC=BONFERRONI ALPHA(0.05).

GLM SummR SummN BY Condition
  /WSFACTOR=VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*VAL) 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VAL 
  /DESIGN=Condition.

* By similarity (only Context and ContextControl).
USE ALL.
FILTER BY filter_Context_ContextControl_only.
EXECUTE.
GLM SummSim SummDis BY Condition
  /WSFACTOR=SIM 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*SIM) 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIM 
  /DESIGN=Condition.
USE ALL.

* Dummy.
EXAMINE VARIABLES=NS_1
  /PLOT NONE
  /STATISTICS NONE
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Similarity x Valence (only Context and ContextControl).
FILTER BY filter_Context_ContextControl_only.
EXECUTE.

GLM CellSim_iR CellSim_iN CellDis_iR CellDis_iN BY Condition
  /WSFACTOR=SIM 2 Polynomial VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*SIM*VAL) 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIM VAL SIM*VAL
  /DESIGN=Condition.
USE ALL.

* (3) Correlations? ##################################.


* Memory in reward and neutral conditions. 
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=SummN SummR Condition MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SummN=col(source(s), name("SummN"))
  DATA: SummR=col(source(s), name("SummR"))
  DATA: Condition=col(source(s), name("Condition"),
notIn("3"), unit.category())
  GUIDE: axis(dim(1), label("Neutral"))
  GUIDE: axis(dim(2), label("Reward"))
  GUIDE: legend(aesthetic(aesthetic.color.exterior), label("Experimental condition"))
  GUIDE: text.title(label("Remember and Know rates are positive correlated"))
  SCALE: cat(aesthetic(aesthetic.color.exterior), include("1", "2"))
  ELEMENT: point(position(SummN*SummR), color.exterior(Condition))
END GPL.

* (4) Persoality? ##########################################.

ONEWAY NSmean RDmean NS_1 NS_2 NS_3 NS_4 RD_1 RD_2 RD_3 RD_4 BY Condition
  /MISSING ANALYSIS
  /POSTHOC=LSD ALPHA(0.05).

*valence effects.
CORRELATIONS
  /VARIABLES= RDmean NSmean OverallItemeffect
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE.

SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.

         CORRELATIONS
           /VARIABLES= RDmean OverallItemeffect
           /PRINT=ONETAIL NOSIG
           /MISSING=PAIRWISE.
         CORRELATIONS
           /VARIABLES= NSmean OverallItemeffect
           /PRINT=ONETAIL NOSIG
           /MISSING=PAIRWISE.
         CORRELATIONS
           /VARIABLES=NS_1 RD_1 OverallItemeffect
           /PRINT=ONETAIL NOSIG
           /MISSING=PAIRWISE.
            CORRELATIONS
              /VARIABLES=RDmean SummR SummN
              /PRINT=ONETAIL NOSIG
              /MISSING=PAIRWISE.
            CORRELATIONS
              /VARIABLES=NSmean SummR SummN
              /PRINT=ONETAIL NOSIG
              /MISSING=PAIRWISE.
SPLIT FILE OFF.

* Similarity effects. 

FILTER BY filter_Context_ContextControl_only.
EXECUTE.


CORRELATIONS
  /VARIABLES=NSmean
      OverallCueeffect SummSim SummDis 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE.
CORRELATIONS
  /VARIABLES=RDmean
      OverallCueeffect SummSim SummDis 
  /PRINT=ONETAIL NOSIG
  /MISSING=PAIRWISE.


GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=RDmean OverallCueeffect MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: RDmean=col(source(s), name("RDmean"))
  DATA: OverallCueeffect=col(source(s), name("OverallCueeffect"))
  GUIDE: axis(dim(1), label("Reward dependency score"))
  GUIDE: axis(dim(2), label("Effect of context similarity on memory score"))
  GUIDE: text.title(label("Reward dependency scores correlate with the effect of context similarity on memory"))
  ELEMENT: point(position(RDmean*OverallCueeffect))
END GPL.

* graphs for effects.
SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.
            CORRELATIONS
              /VARIABLES=NSmean
                  OverallCueeffect SummSim SummDis 
              /PRINT=ONETAIL NOSIG
              /MISSING=PAIRWISE.
            CORRELATIONS
              /VARIABLES=RDmean
                  OverallCueeffect SummSim SummDis 
              /PRINT=ONETAIL NOSIG
              /MISSING=PAIRWISE.

               GGRAPH
                 /GRAPHDATASET NAME="graphdataset" VARIABLES=RDmean OverallCueeffect MISSING=LISTWISE 
                   REPORTMISSING=NO
                 /GRAPHSPEC SOURCE=INLINE.
               BEGIN GPL
                 SOURCE: s=userSource(id("graphdataset"))
                 DATA: RDmean=col(source(s), name("RDmean"))
                 DATA: OverallCueeffect=col(source(s), name("OverallCueeffect"))
                 GUIDE: axis(dim(1), label("Reward dependency score"))
                 GUIDE: axis(dim(2), label("Effect of context similarity on memory score"))
                 GUIDE: text.title(label("Reward dependency scores correlate with the effect of context similarity on memory"))
                 ELEMENT: point(position(RDmean*OverallCueeffect))
               END GPL.

SPLIT FILE OFF.

* graph for reward and neutral, similar & dissimilar.
SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.
            GGRAPH
              /GRAPHDATASET NAME="graphdataset" VARIABLES=RDmean SummR MISSING=LISTWISE REPORTMISSING=NO
              /GRAPHSPEC SOURCE=INLINE.
            BEGIN GPL
              SOURCE: s=userSource(id("graphdataset"))
              DATA: RDmean=col(source(s), name("RDmean"))
              DATA: SummR=col(source(s), name("SummR"))
              GUIDE: axis(dim(1), label("Reward dependency score"))
              GUIDE: axis(dim(2), label("Memory score"))
              GUIDE: text.title(label("Reward dependency and memory for items in Rewarding contexts"))
              ELEMENT: point(position(RDmean*SummR))
            END GPL.
            GGRAPH
              /GRAPHDATASET NAME="graphdataset" VARIABLES=RDmean SummN MISSING=LISTWISE REPORTMISSING=NO
              /GRAPHSPEC SOURCE=INLINE.
            BEGIN GPL
              SOURCE: s=userSource(id("graphdataset"))
              DATA: RDmean=col(source(s), name("RDmean"))
              DATA: SummN=col(source(s), name("SummN"))
              GUIDE: axis(dim(1), label("Reward dependency score"))
              GUIDE: axis(dim(2), label("Memory score"))
              GUIDE: text.title(label("Reward dependency and memory for items in Neutral contexts"))
              ELEMENT: point(position(RDmean*SummN))
            END GPL.

            GGRAPH
              /GRAPHDATASET NAME="graphdataset" VARIABLES=RDmean SummSim MISSING=LISTWISE REPORTMISSING=NO
              /GRAPHSPEC SOURCE=INLINE.
            BEGIN GPL
              SOURCE: s=userSource(id("graphdataset"))
              DATA: RDmean=col(source(s), name("RDmean"))
              DATA: SummSim=col(source(s), name("SummSim"))
              GUIDE: axis(dim(1), label("Reward dependency score"))
              GUIDE: axis(dim(2), label("Memory score in Similar condition"))
              GUIDE: text.title(label("Reward dependency and memory for items in Similar contexts"))
              ELEMENT: point(position(RDmean*SummSim))
            END GPL.
            GGRAPH
              /GRAPHDATASET NAME="graphdataset" VARIABLES=RDmean SummDis MISSING=LISTWISE REPORTMISSING=NO
              /GRAPHSPEC SOURCE=INLINE.
            BEGIN GPL
              SOURCE: s=userSource(id("graphdataset"))
              DATA: RDmean=col(source(s), name("RDmean"))
              DATA: SummDis=col(source(s), name("SummDis"))
              GUIDE: axis(dim(1), label("Reward dependency score"))
              GUIDE: axis(dim(2), label("Memory score in Dissimilar condition"))
              GUIDE: text.title(label("Reward dependency and memory for items in Dissimilar contexts"))
              ELEMENT: point(position(RDmean*SummDis))
            END GPL.


SPLIT FILE OFF
USE ALL.


* Context and NoContext only.
FILTER BY filter_Context_NoContext_only .
EXECUTE.




* ( SIM X VAL, ContextOnly ) ########################.
FILTER BY filter_ContextOnly.
EXECUTE.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(CellSim_iR, 1) MEANSE(CellSim_iN, 1) 
    MEANSE(CellDis_iR, 1) MEANSE(CellDis_iN, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean Memory scores"))
  GUIDE: text.title(label("Similarity x Valence"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "1.5", "2", "3"))
  SCALE: linear(dim(2), include(0.3))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
GLM CellSim_iR CellSim_iN CellDis_iR CellDis_iN
  /WSFACTOR=SIM 2 Polynomial VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIM VAL SIM*VAL.