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
      ((void? x) x)
      #;((void? x) #f)
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
    ((jsexpr? mo #:null (void)) mo)
    (#t (to-meta-pair "racket" (output->string mo)))
    )
  )

(define (from-meta-object mo #:string-key? [string-key? #f])
  (define x
    (cond
      ((cons? mo)
       (cons (from-meta-object (car mo) #:string-key? string-key?)
             (from-meta-object (cdr mo) #:string-key? string-key?)))
      ((hash? mo)
       (if (hash-has-key? mo '!)
           (from-meta-pair mo)
           (if (not string-key?)
               (hash-map/copy
                mo
                (lambda (k v)
                  (values k (from-meta-object v #:string-key? string-key?))
                  )
                )
               (let ([result (make-hash)])
                 (hash-map
                  mo
                  (lambda (k v)
                    (hash-set!
                     result
                     (symbol->string k)
                     (from-meta-object v #:string-key? string-key?)
                     )
                    )
                  )
                 result
                 )
               )
           ))
      ((vector? mo) (vector-map from-meta-object mo #:string-key? string-key?))
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
     (jsexpr->string ! #:null (void) #:indent (if indent? 2 #f))
     )
  )

(define (from-json json #:string-key? [string-key? #f])
  (! json
     (string->jsexpr ! #:null (void))
     (from-meta-object ! #:string-key? string-key?)
     )
  )

(provide
 to-json
 from-json
 )
