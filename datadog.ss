;; -*- Gerbil -*-
package: datadog
namespace: datadog
(export main)

(import
  :gerbil/gambit
  :scheme/base
  :std/debug/heap
  :std/format
  :std/generic
  :std/generic/dispatch
  :std/misc/ports
  :std/net/address
  :std/net/request
  :std/pregexp
  :std/srfi/13
  :std/srfi/19
  :std/srfi/95
  :std/sugar
  :std/text/base64
  :std/text/json
  :std/text/utf8
  :std/text/yaml
  :std/xml/ssax
  )

(import (rename-in :gerbil/gambit/os (current-time builtin-current-time)))

(def DEBUG (getenv "DEBUG" #f))

(def program-name "dda")

(def interactives
  (hash
   ("test" (hash (description: "test static functions") (usage: "test") (count: 0)))
   ))

(def (main . args)
  (if (null? args)
    (usage))
  (let* ((argc (length args))
	 (verb (car args))
	 (args2 (cdr args)))
    (unless (hash-key? interactives verb)
      (usage))
    (let* ((info (hash-get interactives verb))
	   (count (hash-get info count:)))
      (unless count
	(set! count 0))
      (unless (= (length args2) count)
	(usage-verb verb))
      (apply (eval (string->symbol (string-append "datadog#" verb))) args2))))

(def (usage-verb verb)
  (let ((howto (hash-get interactives verb)))
    (displayln "Wrong number of arguments. Usage is:")
    (displayln program-name " " (hash-get howto usage:))
    (exit 2)))

(def (test)
     "Generic function to test gerbil static function error"
     (displayln "test is working as expected"))



(def (usage)
  (displayln "Usage: datadog <verb>")
  (displayln "Verbs:")
  (for-each
    (lambda (k)
      (displayln (format "~a: ~a" k (hash-get (hash-get interactives k) description:))))
    (sort! (hash-keys interactives) string<?))
  (exit 2))

(def (nth n l)
  (if (or (> n (length l)) (< n 0))
    (error "Index out of bounds.")
    (if (eq? n 0)
      (car l)
      (nth (- n 1) (cdr l)))))
