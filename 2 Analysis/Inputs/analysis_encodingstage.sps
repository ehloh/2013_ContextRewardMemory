*   /FILE='/Volumes/SANDISK/9 Matthew Deacon manuscript/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/'+
* 
 /FILE='/Users/EleanorL/Dropbox/SCRIPPS/9 Deacon project/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/'+
    'AllEncodingStats.xlsx'
  /FILE='F:\9 Matthew Deacon manuscript\3 Analysis\3 Analysis inputs\Reported v1 and v2 (3-5 and 3-3)\'+
  /FILE='D:\Dropbox\SCRIPPS\9 Deacon project\3 Analysis\3 Analysis inputs\Reported v1 and v2 (3-5 and 3-3)\'+
    'AllEncodingStats.xlsx'


GET DATA /TYPE=XLSX
 /FILE='/Users/EleanorL/Dropbox/SCRIPPS/9 Deacon project/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/'+
    'AllEncodingStats.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet2 WINDOW=FRONT.


*Sort Variables ############################################################################.
VALUE LABELS Condition
  1 'No Context'
  2 'Context'
  3 'Context Control'.
EXECUTE.
FORMATS  Condition(F3.0).
FORMATS accSummR(F4.2).
FORMATS accSummN(F4.2).
FORMATS rtSummR(F4.0).
FORMATS rtSummN(F4.0).
VARIABLE LABELS  Condition 'Experimental condition'.
VARIABLE LABELS  accSummR 'Reward'.
VARIABLE LABELS  accSummN 'Neutral'.
VARIABLE LABELS  rtSummR 'Reward'.
VARIABLE LABELS  rtSummN 'Neutral'.
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

* Context and NoContext only.
FILTER BY filter_Context_NoContext_only .
EXECUTE.


USE ALL.


COMPUTE filter_Exclude=(Exclude=0).
VARIABLE LABELS filter_Exclude 'Exclude=0 (FILTER)'.
VALUE LABELS filter_Exclude 0 'Not Selected' 1 'Selected'.
FORMATS filter_Exclude(f1.0).
COMPUTE filter_NewSubs=(NewSubs=0).
VARIABLE LABELS filter_NewSubs 'NewSubs=0 (FILTER)'.
VALUE LABELS filter_NewSubs 0 'Not Selected' 1 'Selected'.
FORMATS filter_NewSubs(f1.0).
COMPUTE filter_OldSubjsInclude=(NewSubs=0 & Exclude=0).
VARIABLE LABELS filter_OldSubjsInclude 'Exclude=0 (FILTER)'.
VALUE LABELS filter_OldSubjsInclude 0 'Not Selected' 1 'Selected'.
FORMATS filter_OldSubjsInclude(f1.0).





* Accuracy sanity checks.

USE ALL.
FILTER BY filter_Exclude.
EXECUTE.


USE ALL.
FILTER BY filter_NewSubs.
EXECUTE.


USE ALL.
FILTER BY filter_OldSubjsInclude.
EXECUTE.


USE ALL.

EXAMINE VARIABLES=accOverallOverall accSummR accSummN accValfx 
  /PLOT BOXPLOT
  /COMPARE GROUPS
  /STATISTICS NONE
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=accOverallOverall accSummR accSummN accValfx BY Condition
  /PLOT BOXPLOT
  /COMPARE GROUPS
  /STATISTICS NONE
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


* Accuracy.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(accSummR, 1) MEANSE(accSummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"), notIn("3"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean accuracy"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Accuracy of item semantic judgments during Encoding"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(0.8, 1))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.
   GLM accSummR accSummN BY Condition
     /WSFACTOR=VALENCE 2 Polynomial 
     /METHOD=SSTYPE(3)
     /CRITERIA=ALPHA(.05)
     /WSDESIGN=VALENCE 
     /DESIGN=Condition.



GLM accSummR accSummN BY Condition Counterbal
  /WSFACTOR=VALENCE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VALENCE 
  /DESIGN=Condition Counterbal Condition*Counterbal.



* #################################################################################################################.41







      SORT CASES  BY Condition.
      SPLIT FILE SEPARATE BY Condition.
      T-TEST PAIRS=accSummR WITH accSummN (PAIRED)
        /CRITERIA=CI(.9500)
        /MISSING=ANALYSIS.
      SPLIT FILE OFF.
         ONEWAY accSummR accSummN BY Condition
           /MISSING ANALYSIS.
               T-TEST GROUPS=Condition(1 2)
                 /MISSING=ANALYSIS
                 /VARIABLES=accSummR accSummN
                 /CRITERIA=CI(.95).



* Encoding RT.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(rtSummR, 1) MEANSE(rtSummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Condition=col(source(s), name("Condition"), notIn("3"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("Experimental condition"))
  GUIDE: axis(dim(2), label("Mean RT (ms)"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("Item semantic judgment RTs during Encoding"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2"))
  SCALE: linear(dim(2), include(500, 600))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.
   GLM rtSummR rtSummN BY Condition
     /WSFACTOR=VALENCE 2 Polynomial 
     /METHOD=SSTYPE(3)
     /CRITERIA=ALPHA(.05)
     /WSDESIGN=VALENCE 
     /DESIGN=Condition.
      SORT CASES  BY Condition.
      SPLIT FILE SEPARATE BY Condition.
      T-TEST PAIRS=rtSummR WITH rtSummN (PAIRED)
        /CRITERIA=CI(.9500)
        /MISSING=ANALYSIS.
      SPLIT FILE OFF.
         ONEWAY rtSummR rtSummN BY Condition
           /MISSING ANALYSIS.
               T-TEST GROUPS=Condition(1 2)
                 /MISSING=ANALYSIS
                 /VARIABLES=rtSummR rtSummN
                 /CRITERIA=CI(.95).




* All 3 conditions. 



* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(rtSummR, 1) MEANSE(rtSummN, 1) 
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
  GUIDE: axis(dim(2), label("Mean"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("ENCODING-STAGE RT"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Condition MEANSE(accSummR, 1) MEANSE(accSummN, 1) 
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
  GUIDE: axis(dim(2), label("Mean"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.title(label("ENCODING-STAGE RT"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*Condition), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*Condition)), 
    shape.interior(shape.ibeam))
END GPL.



* Similarity ######################################################.
* Accuracy.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(accCellSim_iR, 1) MEANSE(accCellSim_iN, 1) 
    MEANSE(accCellDis_iR, 1) MEANSE(accCellDis_iN, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean accuracy"))
  GUIDE: text.title(label("Encoding stage task accuracy"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "1.5", "2", "3"))
  SCALE: linear(dim(2), include(0.8))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
GLM accCellSim_iR accCellSim_iN accCellDis_iR accCellDis_iN
  /WSFACTOR=SIM 2 Polynomial VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIM VAL SIM*VAL.


* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(rtCellSim_iR, 1) MEANSE(rtCellSim_iN, 1) 
    MEANSE(rtCellDis_iR, 1) MEANSE(rtCellDis_iN, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean RT (ms)"))
  GUIDE: text.title(label("Encoding stage task accuracy"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "1.5", "2", "3"))
  SCALE: linear(dim(2), include(0.8))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
GLM rtCellSim_iR rtCellSim_iN rtCellDis_iR rtCellDis_iN
  /WSFACTOR=SIM 2 Polynomial VAL 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIM VAL SIM*VAL.

