(ns dipfins.core
  (:require [clojure.data.json :as json]
            [clojure.java.io :as io]
            [clojure.string :as str]
            [dipfins.s3 :as s3]
            [dipfins.ip :as ip]))

(gen-class
  :name "dipfins.core.handler"
  :implements [com.amazonaws.services.lambda.runtime.RequestStreamHandler])

(defn process-record [record]
  (let [bucket (get-in record [:s3 :bucket :name])
        key-src (get-in record [:s3 :object :key])
        key-dest (str/replace key-src "in" "out")]
    (->>
      (s3/read-object bucket key-src)
      (json/read-str)
      (ip/scan-for-ipv4)
      (json/write-str)
      (s3/write-object bucket key-dest))))

(defn -handleRequest
  [_this in out _ctx]
  (let [evt (json/read-str (slurp in) :key-fn keyword)
        records (:Records evt)]
    (dorun (map process-record records)))

  (let [handle (io/writer out)]
    (.write handle (str "hello" "world"))
    (.flush handle)))
