
 /FILE='D:\Dropbox\SANDISK\9 Deacon project\3 Analysis\3 Analysis inputs\Reported v1 and v2 (3-5 and 3-3)\'+
    'AllEncodingStats.xlsx'

 /FILE='/Users/EleanorL/Dropbox/SCRIPPS/9 Deacon project/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/'+
    'AllEncodingStats.xlsx'



GET DATA /TYPE=XLSX
    /FILE='D:\Dropbox\SCRIPPS\9 Deacon project\3 Analysis\3 Analysis inputs\Reported v1 and v2 (3-5 and 3-3)\'+
    'AllEncodingStats.xlsx'  
   /SHEET=name 'EncWMem'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.
DATASET ACTIVATE DataSet1.


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

COMPUTE accRewfx=accSummR-accSummN.
COMPUTE rtRewfx=rtSummN-rtSummR.
COMPUTE r_Rewfx=r_SummR-r_SummN.
COMPUTE k_Rewfx=k_SummR-k_SummN.
COMPUTE rew_Memfx=r_SummR-k_SummR.
COMPUTE neu_Memfx=r_SummN-k_SummN.
EXECUTE.



* Selections ###################.
COMPUTE filter_Context_NoContext_only=(Condition=2 OR Condition =1).
VARIABLE LABELS filter_Context_NoContext_only 'Context & NoContext only(FILTER)'.
VALUE LABELS filter_Context_NoContext_only 0 'Not Selected' 1 'Selected'.
FORMATS filter_Context_NoContext_only (f1.0).
EXECUTE.
FILTER BY filter_Context_NoContext_only .
EXECUTE.

* ####################################.



* Do encoding stage variables correlate w mem fx?.
CORRELATIONS
  /VARIABLES=accRewfx rtRewfx r_Rewfx r_SummN
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=accRewfx r_Rewfx MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: accRewfx=col(source(s), name("accRewfx"))
  DATA: r_Rewfx=col(source(s), name("r_Rewfx"))
  GUIDE: axis(dim(1), label("Difference in encoding task accuracy (reward - neutral)"))
  GUIDE: axis(dim(2), label("Difference in remember rates (reward - neutral)"))
  ELEMENT: point(position(accRewfx*r_Rewfx))
END GPL.




* Memscores correlated w enc-stage measures?.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=rtRewfx r_Rewfx MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: rtRewfx=col(source(s), name("rtRewfx"))
  DATA: r_Rewfx=col(source(s), name("r_Rewfx"))
  GUIDE: axis(dim(1), label("Difference in encoding task RTs (reward - neutral)"))
  GUIDE: axis(dim(2), label("Difference in remember rates (reward - neutral)"))
  ELEMENT: point(position(rtRewfx*r_Rewfx))
END GPL.


* Mem scores.


DATASET ACTIVATE DataSet1.
* Chart Builder.
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
  GUIDE: axis(dim(2), label("Mean"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
