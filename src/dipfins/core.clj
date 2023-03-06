(ns dipfins.core
  (:require [clojure.java.io :as io])
  (:import (com.amazonaws.services.lambda.runtime Context)))

(gen-class
  :name "dipfins.core.handler"
  :implements [com.amazonaws.services.lambda.runtime.RequestStreamHandler])

;(defprotocol ConvertibleToClojure
;  (->cljmap [o]))
;
;(extend-protocol ConvertibleToClojure
;  java.util.Map
;  (->cljmap [o] (let [entries (.entrySet o)]
;                  (reduce (fn [m [^String k v]]
;                            (assoc m (keyword k) (->cljmap v)))
;                          {} entries)))
;
;  java.util.List
;  (->cljmap [o] (vec (map ->cljmap o)))
;
;  java.lang.Object
;  (->cljmap [o] o)
;
;  nil
;  (->cljmap [_] nil))
;
;(defn -handler [s]
;  (println (->cljmap s))
;  (println "Hello World!"))

(defn -handleRequest
  [this input-stream output-stream context]
  (prn (slurp input-stream))
  (prn context)
  (let [handle (io/writer output-stream)]
    (.write handle (str "hello" "world"))
    (.flush handle)))