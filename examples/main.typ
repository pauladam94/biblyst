#import "../multi-bib.typ" : multi-bib
#show: multi-bib

#set page(width: auto, height: auto)
== Main file

#include "chap1.typ"
#include "chap2.typ"

#counter("global_counter").step()
#counter("cite_counter").update(0)

@first @second @third

#bibliography("../examples/bib.yaml")
