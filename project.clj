(defproject dipfins "0.1.0-SNAPSHOT"
  :description "Extract IPv4 addresses from S3 file and write result back to S3"
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [org.clojure/data.json "2.4.0"]
                 [com.amazonaws/aws-lambda-java-core "1.2.2"]
                 [com.cognitect.aws/api "0.8.652"]
                 [com.cognitect.aws/endpoints "1.1.12.415"]
                 [com.cognitect.aws/s3 "825.2.1250.0"]]
  :aot :all)
