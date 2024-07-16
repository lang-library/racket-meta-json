# Another JSON I/O for Racket

JavaCommons Technologies
<[javacommons@gmail.com](mailto:javacommons@gmail.com)>

 (require meta-json) package: [meta-json](https://pkgs.racket-lang.org/package/meta-json)

This basically provides `to-json`, and `from-json`.

    1 Example and usage
                       
    2 Reference        

## 1. Example and usage

```racket
#lang racket/base                              
(require meta-json)                            
(require pprint-all)                           
                                               
(dump (from-json (to-json (void))))            
(dump (from-json (to-json null)))              
(dump (from-json (to-json '())))               
(dump (from-json (to-json '(11 22 #"apple")))) 
(dump (from-json (to-json '#(11 22 #"apple"))))
```

## 2. Reference

```racket
(to-json x #:indent? [indent? #f])
```

Generates a JSON source string for x.

```racket
(from-json json)
```

Parses a recognizable prefix of the string str as an object. Raises
exn:fail:read if the string is malformed JSON.
