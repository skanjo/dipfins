(ns dipfins.ip
  (:require [clojure.data.json :as json]
            [clojure.set :as set]))

(def ipv4-pattern (re-pattern "^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\\.){3}(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$"))

(defn is-ipv4? [s]
  (if (string? s)
    (some? (re-matches ipv4-pattern s))
    false))

(defn scan-for-ipv4 [m]
  (reduce-kv
    (fn [acc _ v]
      (cond
        (nil? v) acc
        (string? v) (if (is-ipv4? v) (conj acc v) acc)
        (or (map? v) (vector? v)) (set/union acc (scan-for-ipv4 v))
        :else acc))
    #{}
    m))
