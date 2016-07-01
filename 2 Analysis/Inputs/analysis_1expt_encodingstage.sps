
GET DATA /TYPE=XLSX
 /FILE='/Users/EleanorL/Dropbox/SANDISK/9 Deacon project/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/'+
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
FILTER BY filter_Context_NoContext_only .
EXECUTE.
USE ALL.


* (0) Which expt? #########################

SORT CASES  BY Condition.
SPLIT FILE SEPARATE BY Condition.



* (1) Encoding Accuracy  #########################

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(accSummR, 1) MEANSE(accSummN, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean"))
  GUIDE: text.title(label("Encoding-stage accuracy"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0.8,1))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.

T-TEST PAIRS=accSummR WITH accSummN (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.





STOPPED HERE BECAUSE: Looks like encoding-stage stats are problematic w this frmaing!
