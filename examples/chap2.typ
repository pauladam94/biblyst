#import "../multi-bib.typ" : multi-bib
#show: multi-bib
#counter("global_counter").step()
#counter("cite_counter").update(0)

#set page(width: auto, height: auto)
== Chapter 2 @first @third

#bibliography("../examples/bib.yaml")
