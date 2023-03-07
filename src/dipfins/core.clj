(ns dipfins.core
  (:require [clojure.data.json :as json]
            [clojure.java.io :as io]))

(gen-class
  :name "dipfins.core.handler"
  :implements [com.amazonaws.services.lambda.runtime.RequestStreamHandler])

(defn -handleRequest
  [_this in out context]
  (prn (json/read-str (slurp in)))
  (prn (.getAwsRequestId context))
  (let [handle (io/writer out)]
    (.write handle (str "hello" "world"))
    (.flush handle)))
