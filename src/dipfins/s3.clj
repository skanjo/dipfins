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

(def ^:private client
  "AWS S3 client used to access buckets and objects."
  (aws/client {:api                  :s3
               :region               "us-east-1"
               :credentials-provider (local-credentials-provider)}))

(defn list-buckets []
  "List all buckets. Returns a map of buckets."
  (-> client
      (aws/invoke {:op :ListBuckets})
      (:Buckets)))

(defn list-objects [bucket]
  "List all objects in a bucket. Returns a map of objects."
  (-> client
      (aws/invoke {:op      :ListObjectsV2
                   :request {:Bucket bucket}})))

(defn read-object [bucket key]
  "Read the contents of an object from a bucket. Return the content as a string."
  (-> client
      (aws/invoke {:op      :GetObject
                   :request {:Bucket bucket
                             :Key    key}})
      (:Body)
      (slurp)))

(defn write-object [bucket key content]
  "Write an object containing the specified content to a bucket. The content is
  expected to be a string."
  (-> client
      (aws/invoke {:op      :PutObject
                   :request {:Bucket bucket
                             :Key    key
                             :Body   (.getBytes content)}})))

(defn delete-object [bucket key]
  "Delete an object from a bucket."
  (-> client
      (aws/invoke {:op      :DeleteObject
                   :request {:Bucket bucket
                             :Key    key}})))
