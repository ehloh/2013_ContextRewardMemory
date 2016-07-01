GET
  FILE='/Users/EleanorL/Dropbox/SCRIPPS/9 Deacon project/3 Analysis/1 Analysis scripts/v3-6 analysis/d_mem_correctenconly.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

* Which memory measure?.
COMPUTE mem_context=md_context.
COMPUTE mem_nocontext=md_nocontext.
*COMPUTE mem_confx=mr_confx.
EXECUTE.

* Memory plots and stats. 
VARIABLE LABELS  mem_context 'Context'.
VARIABLE LABELS  mem_nocontext 'No Context'.
EXECUTE.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(mem_nocontext, 1) MEANSE(mem_context, 1) 
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
  GUIDE: text.title(label("Memory scores"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
T-TEST PAIRS=mem_context WITH mem_nocontext (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.











* Explicitly compare remknow.
GLM mr_context mk_context mr_nocontext mk_nocontext
  /WSFACTOR=CONTEXT 2 Polynomial MEMTYPE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=CONTEXT MEMTYPE CONTEXT*MEMTYPE.
GLM msr_context msk_context msr_nocontext msk_nocontext
  /WSFACTOR=CONTEXT 2 Polynomial MEMTYPE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=CONTEXT MEMTYPE CONTEXT*MEMTYPE.




* Encoding stage beh.
VARIABLE LABELS  eacc_context 'Context'.
VARIABLE LABELS  eacc_nocontext 'No Context'.
VARIABLE LABELS  ert_context 'Context'.
VARIABLE LABELS  ert_nocontext 'No Context'.
FORMATS  ert_context(F8.0).
FORMATS  ert_nocontext(F8.0).
EXECUTE.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(eacc_nocontext, 1) MEANSE(eacc_context, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean accuracy"))
  GUIDE: text.title(label("Encoding stage accuracy scores"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0.9))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(ert_nocontext, 1) MEANSE(ert_context, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean RT"))
  GUIDE: text.title(label("Encoding stage RTs"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(900))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
T-TEST PAIRS=eacc_context ert_context WITH eacc_nocontext ert_nocontext (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.




