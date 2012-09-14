(include "./runtime")

(defn with-meta
  "Returns identical value with given metadata associated to it."
  [value metadata]
  (set! value.metadata metadata)
  value)

(defn meta
  "Returns the metadata of the given value or nil if there is no metadata."
  [value]
  (if (object? value) (.-metadata value)))



(defn Symbol
  "Symbol type"
  [name ns]
  (set! this.name name)
  (set! this.ns ns)
  this)
(set! Symbol.prototype.to-string
      (fn [] (if (string? this.ns)
               (.concat this.ns "/" this.name)
               this.name)))


(defn ^boolean symbol? [x]
  (.prototype-of? Symbol.prototype x))

(defn symbol
  "Returns a Symbol with the given namespace and name."
  [ns id]
  (cond
    (symbol? ns) ns
    (keyword? ns) (new Symbol (name ns))
    :else (if (string? id) (new Symbol id ns) (new Symbol ns))))

(defn symbol-identical?
  ;; We can not use `identical?` or `=` since in JS we can not
  ;; make `==` or `===` on object which we use to implement symbols.
  "Returns true if symbol is identical"
  [actual expected]
  (and
    (symbol? actual)
    (symbol? expected)
    (identical? (name actual) (name expected))))



(defn ^boolean keyword? [x]
  (and (string? x)
       (identical? (.char-at x 0) "\uA789")))

(defn keyword
  "Returns a Keyword with the given namespace and name. Do not use :
  in the keyword strings, it will be added automatically."
  [ns id]
  (cond
   (keyword? ns) ns
   (symbol? ns) (.concat "\uA789" (name ns))
   :else (if (nil? id)
           (.concat "\uA789" ns)
           (.concat "\uA789" ns "/" id))))


(defn name
  "Returns the name String of a string, symbol or keyword."
  [value]
  (cond
    (keyword? value)
      (if (>= (.index-of value "/") 0)
        (.substr value (+ (.index-of value "/") 1))
        (.substr value 1))
    (symbol? value) (.-name value)
    (string? value) value))


;; Common symbols

(def unquote (symbol "unquote"))
(def unquote-splicing (symbol "unquote-splicing"))
(def syntax-quote (symbol "syntax-quote"))
(def quote (symbol "quote"))
(def deref (symbol "deref"))

;; sets are not part of standard library but implementations can be provided
;; if necessary.
(def set (symbol "set"))


(defn ^boolean unquote?
  "Returns true if it's unquote form: ~foo"
  [form]
  (and (list? form) (identical? (first form) unquote)))

(defn ^boolean unquote-splicing?
  "Returns true if it's unquote-splicing form: ~@foo"
  [form]
  (and (list? form) (identical? (first form) unquote-splicing)))

(defn ^boolean quote?
  "Returns true if it's quote form: 'foo '(foo)"
  [form]
  (and (list? form) (identical? (first form) quote)))

(defn ^boolean syntax-quote?
  "Returns true if it's syntax quote form: `foo `(foo)"
  [form]
  (and (list? form) (identical? (first form) syntax-quote)))



(export meta with-meta
        symbol? symbol
        keyword? keyword
        name deref set

        unquote? unquote
        unquote-splicing? unquote-splicing
        quote? quote
        syntax-quote? syntax-quote)
