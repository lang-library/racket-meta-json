#lang info
(define collection "meta-json")
(define name "meta-json: Another JSON I/O for Racket")
(define blurb '("Another JSON I/O for Racket."))
(define scribblings '(("meta-json.scrbl")))
(define categories '(devtools))
(define can-be-loaded-with 'all)
(define required-core-version "5.1.1")
(define version "1.0")
(define repositories '("4.x"))
(define primary-file "main.rkt")
(define release-notes '((p "First release")))
(define deps '(
               "reprovide-lang-lib"
               "access"
               "base"
               "pprint-all"
               "while-until"
               ))
(define build-deps '("racket-doc"
                     "scribble-lib"))
