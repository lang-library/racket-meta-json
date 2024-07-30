#lang racket
(require json)
(require base64)
(require pprint-all)
(require access)

(define (to-meta-pair name data)
  (hasheq '! name '? data)
  )

(define (from-meta-pair ht)
  (with-handlers ([exn:fail? (lambda (_) ht)])
    (let ([key (hash-ref ht '!)])
      (cond
        ((equal? key "racket")
         (define sp (open-input-string (hash-ref ht '?)))
         (read sp))
        (#t ht)
        )
      )
    )
  )

(define (to-meta-object x)
  (define mo
    (cond
      #;((void? x) x)
      ((void? x) #f)
      ((bytes? x) (to-base64 x))
      ((cons? x) (cons (to-meta-object (car x)) (to-meta-object (cdr x))))
      ((hash? x)
       (hash-map/copy
        x
        (lambda (k v)
          (values k (to-meta-object k))
          (values k (to-meta-object v))
          )))
      ((vector? x) (vector->list (vector-map to-meta-object x)))
      (#t x)
      )
    )
  (cond
    #;((void? mo) mo)
    ((jsexpr? mo #:null (void)) mo)
    (#t (to-meta-pair "racket" (output->string mo)))
    )
  )

(define (from-meta-object mo)
  (define x
    (cond
      ((cons? mo) (cons (from-meta-object (car mo)) (from-meta-object (cdr mo))))
      ((hash? mo)
       (if (hash-has-key? mo '!)
           (from-meta-pair mo)
           (hash-map/copy
            mo
            (lambda (k v)
              (values k (from-meta-object v))
              ))))
      ((vector? mo) (vector-map from-meta-object mo))
      (#t mo)
      )
    )
  x
  )

(define (to-base64 x)
  (bytes->string/latin-1 (base64-encode x))
  )

(define (from-base64 x)
  (base64-decode x)
  )

(define (to-json x #:indent? [indent? #f])
  (! x
     (to-meta-object !)
     #;(jsexpr->string ! #:null (void) #:indent (if indent? 2 #f))
     (jsexpr->string ! #:null #f #:indent (if indent? 2 #f))
     )
  )

(define (from-json json)
  (! json
     #;(string->jsexpr ! #:null (void))
     (string->jsexpr ! #:null #f)
     (from-meta-object !)
     )
  )

(provide
 to-json
 from-json
 )
