(defproject dipfins "0.1.0-SNAPSHOT"
  :description "Extract IPv4 addresses from S3 file and write result back to S3"
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [org.clojure/data.json "2.4.0"]
                 [com.amazonaws/aws-lambda-java-core "1.2.2"]]
  :aot :all)
