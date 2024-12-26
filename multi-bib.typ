// counter update for each citation (id of the citation)
#let cite_counter = counter("cite_counter")
// counter that update for each document (has to be increased in a template
// document for example) (id of the document)
#let global_counter = counter("global_counter")

#let multi-bib(body) = {
	show bibliography: it => {
		if it.path.len() != 1 { assert(false, message: "Only accepts one bibliography file") }

		let path = "examples/bib.yaml"
		let file = yaml(path)

		let done = ()
		text(underline[*Bibliography* #linebreak()])
		// function that take and author (ie. "Tom Paul Andersen")
		// and turn it into a resume version T. P. Andersen
		let resume_author(author) = {
		  let l = author.split(" ").filter(x=>x != "")
		  l.enumerate().map(((i, name)) => 
			if i != l.len() - 1 [#name.slice(0,1).]
			else {name}).join(" ")
		}
		// Go through all of the citation in the current document
		// current document being the one identified with the number inside the 
		// counter "global_counter"
		for i in range(cite_counter.get().at(0)) {
		  let lab = label("cite_" + str(i) + "_" + global_counter.display())
		  let pos = locate(lab).position()
		  let item = query(lab).at(0).value
		  if not item in done { // only write once each document (book, article...)
			if item in file {
			  // specific code for typeset a basic book bibliography
			  // Other type of citation can be taken into account and it must be
			  // done by scripting here in typst
			  let book = file.at(item)
			  let a = book.author
			  let type_author = type(a)
			  let authors
			  if type(book.author) == array {
				authors = book.author
			  } else if type(book.author) == str {
				authors = book.author.split(",")
			  }
			  let resume_authors = authors.map(a => resume_author(a)).join(" & ")
			  [#h(0.8em) [#item]#h(0.5em)#resume_authors, #emph(book.title). #linebreak()]
			} else {
			  assert(false, message:[#item not in #it.path.at(0)])
			}
		  }
		  done.push(item)
		}
	}
	show cite : it => [
		[#str(it.key)#if it.supplement != none [ #it.supplement]]
		#metadata(str(it.key)) // Metadata of the key used by the citation
		#label("cite_" + cite_counter.display() + "_" + global_counter.display())
		#cite_counter.step()
		// Here we have added a label connected to the citation metadata just to
		// know what have been cited in the document
	]
	body
}
