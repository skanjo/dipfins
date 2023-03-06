(ns dipfins.s3
  (:require [cognitect.aws.client.api :as aws]
            [cognitect.aws.credentials :as credentials]))

(defn local-credentials-provider
  "Returns a chain-credentials-provider with (in order):

    environment-credentials-provider
    system-property-credentials-provider
    profile-credentials-provider"
  []
  (credentials/chain-credentials-provider
    [(credentials/environment-credentials-provider)
     (credentials/system-property-credentials-provider)
     (credentials/profile-credentials-provider)]))

(def client (aws/client {:api                  :s3
                         :region               "us-east-1"
                         :credentials-provider (local-credentials-provider)}))

(defn list-buckets []
  (-> client
      (aws/invoke {:op :ListBuckets})
      (:Buckets)))

(defn list-objects [bucket]
  (-> client
      (aws/invoke {:op      :ListObjectsV2
                   :request {:Bucket bucket}})))

(defn read-object [bucket key]
  (-> client
      (aws/invoke {:op      :GetObject
                   :request {:Bucket bucket
                             :Key    key}})
      (:Body)
      (slurp)))

(defn write-object [bucket key content]
  (-> client
      (aws/invoke {:op      :PutObject
                   :request {:Bucket bucket
                             :Key    key
                             :Body   (.getBytes content)}})))

(defn delete-object [bucket key]
  (-> client
      (aws/invoke {:op      :DeleteObject
                   :request {:Bucket bucket
                             :Key    key}})))
