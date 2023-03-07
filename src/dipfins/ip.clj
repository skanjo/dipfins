(ns dipfins.ip
  (:require [clojure.data.json :as json]
            [clojure.set :as set]))

(def ipv4-pattern
  "Regular expression precisely matching IPv4 addresses"
  (re-pattern "^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\\.){3}(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$"))

(defn ipv4? [s]
  "Given a string determine if it represents an IPv4 address"
  (if (string? s)
    (some? (re-matches ipv4-pattern s))
    false))

(defn scan-for-ipv4 [m]
  "Given a map, scan all values for IPv4 addresses. Collect all IP addresses
  found into a set and return the set. No duplicates will be returned."
  (reduce-kv
    (fn [acc _ v]
      (cond
        (nil? v) acc
        (string? v) (if (ipv4? v) (conj acc v) acc)
        (or (map? v) (vector? v)) (set/union acc (scan-for-ipv4 v))
        :else acc))
    #{} m))
