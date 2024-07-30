#lang racket
(require "./main.rkt")
(require pprint-all)

(dump (to-json (void)))
(dump (to-json #"apple"))
(dump (to-json '(11 22 #"apple")))
(dump (to-json '#(11 22 #"apple")))
(dump (to-json '#hash(((a b c) . "bytes") (? . "YXBwbGU"))))

(dump (from-json (to-json (void))))
(dump (from-json (to-json null)))
(dump (from-json (to-json '())))
(dump (from-json (to-json '(11 22 #"apple"))))
(dump (from-json (to-json '#(11 22 #"apple"))))
(dump (from-json (to-json '#hash(((a b c) . "bytes") (? . "YXBwbGU")))))
(dump (from-json (to-json '#hash((abc . 777)))))
