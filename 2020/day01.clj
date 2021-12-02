(use 'clojure.java.io)

(defn get-lines [fname]
  ;; Reads lines of 'fname' into array
  (with-open [r (reader fname)]
    (doall (line-seq r))
    )
  )

(defn to-int [string]
  ;; Coerces string to integer
  (Integer/parseInt string))

(defn sum-eq [array, z]
  ;; Check whether the sum of an array is a given number
  (= (reduce + array) z)
  )


(let
    [input-path "./input/1-1.txt"
     input-array (vec (map to-int (get-lines input-path)))
     len-input-array (count input-array)]

  ;; Traverse input-array
  (doseq [i (range len-input-array)]
    (doseq [j (range i len-input-array)]
      ;; Check whether any two elements sum to 2020
      (let [x (input-array i)
            y (input-array j)]
        (if (sum-eq [x y] 2020)
          (println
           "The product of the two integers summing up to 2020 is:"
           (* x y))))))

  ;; Traverse input-array
  (doseq [i (range len-input-array)]
    (doseq [j (range i len-input-array)]
      (doseq [k (range j len-input-array)]
        (let [x (input-array i)
              y (input-array j)
              z (input-array k)]
          (if (sum-eq [x y z] 2020)
            (println
             "The product of the three integers summing up to 2020 is:"
             (* x y z)))))))
  )
