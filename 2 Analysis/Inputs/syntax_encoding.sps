
GET DATA /TYPE=XLSX
  /FILE='/Volumes/SANDISK/9 Matthew Deacon manuscript/3 Analysis/3 Analysis inputs/Reported v1 '+
    'and v2 (3-5 and 3-3)/Encoding.xlsx'
  /SHEET=name 'Encoding'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.
DATASET ACTIVATE DataSet3.


VALUE LABELS Condition
  1 'No context'
  2 'Context'.
EXECUTE.
FORMATS  acc.Overall.Overall(F7.2).
FORMATS  acc.Summ.Sim(F7.2).
FORMATS  acc.Summ.Dis(F7.2).
FORMATS  acc.Overall.R(F7.2).
FORMATS  acc.Overall.N(F7.2).
FORMATS  acc.Cell.Sim_R(F7.2).
FORMATS  acc.Cell.Sim_N(F7.2).
FORMATS  acc.Cell.Dis_R(F7.2).
FORMATS  acc.Cell.Dis_N(F7.2).
VARIABLE LABELS  acc.Overall.R 'Reward'.
VARIABLE LABELS  acc.Overall.N 'Neutral'.
VARIABLE LABELS  acc.Summ.Sim 'Similar'.
VARIABLE LABELS  acc.Summ.Dis 'Dissimilar'.
VARIABLE LABELS  acc.Cell.Sim_R 'Similar-Reward'.
VARIABLE LABELS  acc.Cell.Sim_N 'Similar-Neutral'.
VARIABLE LABELS  acc.Cell.Dis_R 'Dissimilar-Reward'.
VARIABLE LABELS  acc.Cell.Dis_N 'Dissimilar-Neutral'.
EXECUTE.
FORMATS  rt.Overall.Overall(F11.0).
FORMATS  rt.Summ.Sim(F11.0).
FORMATS  rt.Summ.Dis(F11.0).
FORMATS  rt.Overall.R(F11.0).
FORMATS  rt.Overall.N(F11.0).
FORMATS  rt.Cell.Sim_R(F11.0).
FORMATS  rt.Cell.Sim_N(F11.0).
FORMATS  rt.Cell.Dis_R(F11.0).
FORMATS  rt.Cell.Dis_N(F11.0).
VARIABLE LABELS  rt.Overall.R 'Reward'.
VARIABLE LABELS  rt.Overall.N 'Neutral'.
VARIABLE LABELS  rt.Summ.Sim 'Similar'.
VARIABLE LABELS  rt.Summ.Dis 'Dissimilar'.
VARIABLE LABELS  rt.Cell.Sim_R 'Similar-Reward'.
VARIABLE LABELS  rt.Cell.Sim_N 'Similar-Neutral'.
VARIABLE LABELS  rt.Cell.Dis_R 'Dissimilar-Reward'.
VARIABLE LABELS  rt.Cell.Dis_N 'Dissimilar-Neutral'.
EXECUTE.



*(1) Accuracy ##############################.

EXAMINE VARIABLES=acc.Overall.Overall acc.Overall.R acc.Overall.N  
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.
EXAMINE VARIABLES=acc.Overall.Overall acc.Overall.R acc.Overall.N   
 BY Condition
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(acc.Overall.R, 1) MEANSE(acc.Overall.N, 1) 
    Condition MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: Condition=col(source(s), name("Condition"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(2), label("Mean acuracy (%)"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Condition"))
  GUIDE: text.title(label("Accuracy of semantic judgments"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("1", "2"))
  SCALE: cat(dim(1), include("1", "2"))
  ELEMENT: interval(position(Condition*SUMMARY*INDEX), color.interior(Condition), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(Condition*(LOW+HIGH)*INDEX)), 
    shape.interior(shape.ibeam))
END GPL.
GLM acc.Overall.R acc.Overall.N BY Condition
  /WSFACTOR=Reward 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*Reward) COMPARE(Reward)
  /EMMEANS=TABLES(Reward) COMPARE ADJ(LSD)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Reward 
  /DESIGN=Condition.

* No context rewfx.
USE ALL.
COMPUTE filter_$=(Condition=1).
VARIABLE LABELS filter_$ 'Condition=2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
T-TEST PAIRS=acc.Overall.R WITH acc.Overall.N (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.
* Context rewfx.
USE ALL.
COMPUTE filter_$=(Condition=2).
VARIABLE LABELS filter_$ 'Condition=2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
T-TEST PAIRS=acc.Overall.R WITH acc.Overall.N (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.
USE ALL.

* by Condition.
T-TEST GROUPS=Condition(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=acc.Overall.Overall acc.Overall.R acc.Overall.N
  /CRITERIA=CI(.95).






* (2) RT ##############################.

EXAMINE VARIABLES=  rt.Overall.Overall rt.Overall.R rt.Overall.N 
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=acc.Overall.Overall acc.Overall.R acc.Overall.N    rt.Overall.Overall rt.Overall.R rt.Overall.N 
 BY Condition
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(rt.Overall.R, 1) MEANSE(rt.Overall.N, 1) 
    Condition MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: Condition=col(source(s), name("Condition"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(2), label("Mean RT (ms)"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Condition"))
  GUIDE: text.title(label("RTs of semantic judgments during Encoding"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(3), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("1", "2"))
  SCALE: cat(dim(1), include("1", "2"))
  ELEMENT: interval(position(Condition*SUMMARY*INDEX), color.interior(Condition), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(Condition*(LOW+HIGH)*INDEX)), 
    shape.interior(shape.ibeam))
END GPL.


GLM rt.Overall.R rt.Overall.N BY Condition
  /WSFACTOR=Reward 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(Condition*Reward) COMPARE(Reward)
  /EMMEANS=TABLES(Reward) COMPARE ADJ(LSD)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Reward 
  /DESIGN=Condition.



* No context rewfx.
USE ALL.
COMPUTE filter_$=(Condition=1).
VARIABLE LABELS filter_$ 'Condition=2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
T-TEST PAIRS=rt.Overall.R WITH rt.Overall.N (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.
* Context rewfx.
USE ALL.
COMPUTE filter_$=(Condition=2).
VARIABLE LABELS filter_$ 'Condition=2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
T-TEST PAIRS=rt.Overall.R WITH rt.Overall.N (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.
USE ALL.

* by Condition.

T-TEST GROUPS=Condition(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=rt.Overall.Overall rt.Overall.R rt.Overall.N
  /CRITERIA=CI(.95).



* Context condition only: Sim x Val.

USE ALL.
COMPUTE filter_$=(Condition=2).
VARIABLE LABELS filter_$ 'Condition=2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(acc.Cell.Sim_R, 1) MEANSE(acc.Cell.Sim_N, 1) 
    MEANSE(acc.Cell.Dis_R, 1) MEANSE(acc.Cell.Dis_N, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: text.title(label("Accuracy of semantic judgments during Encoding"))
  GUIDE: axis(dim(2), label("Mean accuracy (%)"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "1.5", "2", "3"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.


GLM acc.Cell.Sim_R acc.Cell.Sim_N acc.Cell.Dis_R acc.Cell.Dis_N
  /WSFACTOR=Sim 2 Polynomial Valence 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Sim Valence Sim*Valence.


GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(rt.Cell.Sim_R, 1) MEANSE(rt.Cell.Sim_N, 1) 
    MEANSE(rt.Cell.Dis_R, 1) MEANSE(rt.Cell.Dis_N, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: text.title(label("RTs of semantic judgments during Encoding"))
  GUIDE: axis(dim(2), label("Mean RT (ms)"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "1.5", "2", "3"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.

GLM rt.Cell.Sim_R rt.Cell.Sim_N rt.Cell.Dis_R rt.Cell.Dis_N
  /WSFACTOR=Sim 2 Polynomial Valence 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Sim Valence Sim*Valence.

USE ALL.

