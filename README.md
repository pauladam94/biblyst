# Multiple Bibliography
This Typst package allow multiple bibliographie using the build-in typst syntax
fonction for citation an bibliography.

# Working example

Here is the code of a basic example, one bibliography file and two chapter that
are included in a main file. Yes we are calling multiple times in the same file
the `bibliography` function but it works because it has been complety overriden.

```yaml
# bib.yaml
first:
    type: book
    title: Some First Book
    author: Paul Adam, Surname Name
second:
    type: book
    title: Some Second Book
    author: Surname Name
third:
    type: book
    title: Some Third Book
    author: Surname Name, Other Name
```

```typ
// chap1.typ
#import "../multi-bib.typ" : multi-bib
#show: multi-bib
#counter("global_counter").step()
#counter("cite_counter").update(0)

#set page(width: auto, height: auto)
== Chapter 1 @first @second

#bibliography("../examples/bib.yaml")
```

```typ
// chap2.typ
#import "../multi-bib.typ" : multi-bib
#show: multi-bib
#counter("global_counter").step()
#counter("cite_counter").update(0)

#set page(width: auto, height: auto)
== Chapter 2 @first @third

#bibliography("../examples/bib.yaml")
```


![](examples/main.typ)

```typ
// main.typ
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
```

Here the two chapter (we can imagine that there are very long chapter and you
want multiple bibliography in multiple files).

Here is the result of the compilation of the main.typ file. (the one in the
repository).

![](examples/main_1.svg)

![](examples/main_2.svg)

![](examples/main_3.svg)

![](examples/main_4.svg)

# Why this package ?
This package tries to resolve the missing feature of importing multiple
bibliogrphies in typst.

This has already been discussed in multiple issues and in the typst community :
- [Github feature request](https://github.com/typst/typst/issues/1097)
- [Typst forum multi file setup question](https://forum.typst.app/t/how-to-share-bibliography-in-a-multi-file-setup/1605)

This package is not feature full but the code is very simple. This kind of issue
with bibliography usually occurs with big document (a thesis document for
example) where I assumed people have some form of custom template. The idea is
to take the code of this package and adapt it to your liking.

# Benefits and Drawbacks
## Benefits
### Allow easy customization of citation and bibliography
- this allows complete customization (in typst and not a citation language) over
how citate are showed and customization of the bibliographie. This is the first
reason why I have written this. For writing (non verified) scientific paper, I
want to have custom citation and bibliography that are very clear (not the usual
\[1\] \[2\] citation style of IEEE). In this package, the citation are seen as
the same name as they are called in the typst file. If you write @PAT then you
will see \[PAT\] in the file and in the bibliography at the end there will be
\[PAT\] at the end. This works only if there is an element in the `yaml`
bibliography named "PAT".

## Drawbacks
### Predefined bibliography style not supported
- this does not permit to use the citation style predefined that can be usually
  used in the bibliography file.

**Fix** : you can write (in typst) your own citation style. Just a bit of scripting and
  you have whatever you want.
### Path problem
- the path given to the bibliography function is not used. The file used is the
  one given by the first function TODO. Indeed the path given can be relative
  and is from the file that imports the template. So the template have a
  relative from this file but not from the template itself. The simplest way to

**Fix** : hardcoding the path that the template is looking is an easy way to fix this
issue.
### Only support yaml bibliography
- only the yaml file in parsed using the `yaml` function in typst.

**Fix** : this template parse him self the bibliographie file. If you add some code to
parse a `.bib` file this easily works with an other format than
## Title Specific Bibliography given a language
- as said none of the feature of the bibliography are preserved. If you set a
specific language, the title of the bibliographie will not change.
**Fix** : Hardcode the title in the code

# How it works
- The citation function is also overriden. I add a `label` and a `metadata` to
be able to reference the citation in the bibliography.
- The bibliographie function is completely override. It does nothing of what is
  has done previously, none of its parameter are taken into account either. It
mainly parses the yaml file, 

<details>
    <summary> Show Code </summary>

Here is the show rules to make this works. This is pretty short and thus can be
copied easily in your template to make it work as you want.

![](multi-bib.typ)
```typ
// counter update for each citation (id of the citation)
#let cite_counter = counter("cite_counter")
// counter that update for each document (has to be increased in a template
// document for example) (id of the document)
#let global_counter = counter("global_counter")

#show bibliography: it => {
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
#show cite : it => [
    [#str(it.key)#if it.supplement != none [ #it.supplement]]
    #metadata(str(it.key)) // Metadata of the key used by the citation
    #label("cite_" + cite_counter.display() + "_" + global_counter.display())
    #cite_counter.step()
    // Here we have added a label connected to the citation metadata just to
    // know what have been cited in the document
]
```
</details>

# Using it as a package only
Warning: this package is not feature full and only support books with a title
and some authors.

If you want more support, go see the contributing part or copy past the code.

Warning: This has not be well tested yet.
```typ
// file.typ
#import "@preview/biblyst:0.1.0" : multi-bib
#show: multi-bib

// ... some document
@some-citation-name

#bibliography("path-to-bibliography-in-yaml-format")
```

`file.typ` can now be included in a file, even a file with it's own
bibliography, even a file that has other bibliography from other files.


# Contributing
- Don't hesitate to contribute [here in github](https://github.com/pauladam94/multi-bib)
- If you don't understand what I have done don't hesitate to open issue even
just for asking a question on [github](https://github.com/pauladam94/multi-bib)
