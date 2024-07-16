#lang scribble/manual

@title{Another JSON I/O for Racket}

@author[(author+email "JavaCommons Technologies" "javacommons@gmail.com")]

@defmodule[meta-json]

This basically provides @racket[to-json], and @racket[from-json].

@table-of-contents[]

@section{Example and usage}

@codeblock|{
#lang racket/base
(require meta-json)
(require pprint-all)

(dump (from-json (to-json (void))))
(dump (from-json (to-json null)))
(dump (from-json (to-json '())))
(dump (from-json (to-json '(11 22 #"apple"))))
(dump (from-json (to-json '#(11 22 #"apple"))))
}|

@section{Reference}

@defform[(to-json x #:indent? [indent? #f])]{
Generates a JSON source string for x.
}

@defform[(from-json json)]{
Parses a recognizable prefix of the string str as an object. Raises exn:fail:read if the string is malformed JSON.
}
