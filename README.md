# multi-bib
Typst multiple bibliographie using same citation an bibliographie syntax.

# Why this package ?
This package tries to resolve the missing feature of importing multiple
bibliogrphies in typst.

This has already been discussed in multiple issues and in the typst forum here :
- 
-
- 

# Working example

Here is a basic example :

The bibliographie file in yaml :

```yaml
first:
    type: book
    title: Some Book
    authors: Paul Adam
second:
    type: book
    authors: Surname Name
```

Here the two chapter (we can imagine that there very long chapter and you want
multiple bibliography).


Here the result :
![](examples/main_1.svg)
![](examples/main_2.svg)
![](examples/main_3.svg)
![](examples/main_4.svg)

# How it works
- The citation function is also overriden. I add a `label` and a `metadata` to
be able to reference the citation in the bibliography.
- The bibliographie function is completely override. It does nothing of what is
  has done previously, none of its parameter are taken into account either. It
mainly parses the yaml file, 


Here is an extract of the show rules to make this works. This is pretty short
and thus can be copied easily in your template to make it work as you want.
```typ


```

# Benefits and Drawbacks
## Benefits
- this allows complete customization (in typst and not a citation language) over
how citate are showed and customization of the bibliographie.
## Drawbacks
### Predefined bibliography style not supported
- this does not permit to use the citation style predefined that can be usually
  used in the bibliography file.
### Fix
- you can write (in typst) your own citation style. Just a bit of scripting and
  you have whatever you want.
### Path problem
- the path given to the bibliography function is not used. The file used is the
  one given by the first function TODO. Indeed the path given can be relative
  and is from the file that imports the template. So the template have a
relative from this file but not from the template itself. The simplest way to
### Fix
- Hardcoding the path that the template is looking is an easy way to fix this
issue.
### Only support yaml bibliography
- only the yaml file in parsed using the `yaml` function in typst.
### Fix
- this template parse him self the bibliographie file. If you add some code to
parse a `.bib` file this easily works with an other format than
### Title Specific Bibliography given a language
- as said none of the feature of the bibliography are preserved. If you set a
specific language, the title of the bibliographie will not change.
### Fix
- Hardcode the title in the code

# TODO


# Contributing
- Don't hesitate to contribute [here in github]()
- If you don't understand what I have done don't hesitate to open issue even
just for asking a question on [github]()
