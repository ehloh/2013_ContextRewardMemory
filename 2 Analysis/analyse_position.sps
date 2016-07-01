
DATASET ACTIVATE DataSet1.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(Cell.Sim_iR_0, 1) MEANSE(Cell.Sim_iR_1, 1) 
    MEANSE(Cell.Sim_iN_0, 1) MEANSE(Cell.Sim_iN_1, 1) MEANSE(Cell.Dis_iR_0, 1) MEANSE(Cell.Dis_iR_1, 1) 
    MEANSE(Cell.Dis_iN_0, 1) MEANSE(Cell.Dis_iN_1, 1) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(2), label("Mean accuracy (associative memory)"))
  GUIDE: text.footnote(label("Error Bars: +/- 1 SE"))
  SCALE: cat(dim(1), include("0", "1", "2", "3", "3.5", "4", "5", "6", "7"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(INDEX*SUMMARY), shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH))), shape.interior(shape.ibeam))
END GPL.

GLM Summ.Sim_iR Summ.Sim_iN Summ.Dis_iR Summ.Dis_iN
  /WSFACTOR=SIMILARITY 2 Polynomial VALENCE 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIMILARITY VALENCE SIMILARITY*VALENCE.


GLM Cell.Sim_iR_0 Cell.Sim_iR_1 Cell.Sim_iN_0 Cell.Sim_iN_1 Cell.Dis_iR_0 Cell.Dis_iR_1 
    Cell.Dis_iN_0 Cell.Dis_iN_1
  /WSFACTOR=SIMILARITY 2 Polynomial VALENCE 2 Polynomial SEEDS 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=SIMILARITY VALENCE SEEDS SIMILARITY*VALENCE SIMILARITY*SEEDS VALENCE*SEEDS 
    SIMILARITY*VALENCE*SEEDS.


GLM Cell.Sim_iR_0 Cell.Sim_iR_1 Cell.Sim_iN_0 Cell.Sim_iN_1
  /WSFACTOR=VALENCE 2 Polynomial SEEDS 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VALENCE SEEDS VALENCE*SEEDS.

GLM Cell.Dis_iR_0 Cell.Dis_iR_1 Cell.Dis_iN_0 Cell.Dis_iN_1
  /WSFACTOR=VALENCE 2 Polynomial SEEDS 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=VALENCE SEEDS VALENCE*SEEDS.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEANSE(Summ.iR_0, 1) MEANSE(Summ.iR_1, 1) 
    MEANSE(Summ.iN_0, 1) MEANSE(Summ.iN_1, 1) MISSING=LISTWISE REPORTMISSING=NO
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

T-TEST PAIRS=Summ.iR_0 Summ.iN_0 Summ.iR_0 Summ.iR_1 WITH Summ.iR_1 Summ.iN_1 Summ.iN_0 Summ.iN_1 
    (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.
