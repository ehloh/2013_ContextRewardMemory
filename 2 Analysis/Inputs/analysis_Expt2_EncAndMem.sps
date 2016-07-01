* INSTRUCTIONS!
D:\Dropbox\SANDISK\9 Deacon project\3 Analysis\1 Analysis scripts\v3-6 analysis\a2_analysemem
copy data from d_all into new SPSS table, manually load the titles (copy into excel first, cos of ' s), then run this script

DATASET ACTIVATE DataSet2.

* Which memory measure?.
COMPUTE mem_context=msh_context.
COMPUTE mem_nocontext=msh_nocontext.
COMPUTE mem_confx=msh_confx.
EXECUTE.


* Memfx corr w accuracy & RT fx?.
CORRELATIONS
  /VARIABLES=mem_confx eacc_confx ert_confx
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=ert_confx mem_confx MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: ert_confx=col(source(s), name("ert_confx"))
  DATA: mem_confx=col(source(s), name("mem_confx"))
  GUIDE: axis(dim(1), label("Context effect on RTs"))
  GUIDE: axis(dim(2), label("Context effect on memory score"))
  ELEMENT: point(position(ert_confx*mem_confx))
END GPL.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=eacc_confx mem_confx MISSING=LISTWISE REPORTMISSING=NO    
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: eacc_confx=col(source(s), name("eacc_confx"))
  DATA: mem_confx=col(source(s), name("mem_confx"))
  GUIDE: axis(dim(1), label("Context effect on accuracy scores"))
  GUIDE: axis(dim(2), label("Context effect on memory score"))
  ELEMENT: point(position(eacc_confx*mem_confx))
END GPL.

* Group memscore means etc.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(mem_context, 1) MEANSE(mem_nocontext, 1) 
    MEANSE(mem_confx, 1) MISSING=LISTWISE REPORTMISSING=NO
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
  SCALE: cat(dim(1), include("0", "1", "2"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
T-TEST PAIRS=mem_context WITH mem_nocontext (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.

* Enc stage means.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(eacc_context, 1) MEANSE(eacc_nocontext, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean accuracy score"))
  GUIDE: text.title(label("Encoding task accuracy"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0.8))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.
T-TEST PAIRS=eacc_context WITH eacc_nocontext (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.




GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(ert_context, 1) MEANSE(ert_nocontext, 1) 
    MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean RTs"))
  GUIDE: text.title(label("Encoding RTs"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(800))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.

