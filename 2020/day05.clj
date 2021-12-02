(use 'clojure.java.io
     'clojure.string)

(defn get-lines [fname]
  ;; Reads lines of 'fname' into array
  (with-open [r (reader fname)]
    (doall (line-seq r))
    )
  )

(defn ** [x n]
  ;; Exponentiation
  (reduce * (repeat n x))
  )

(defn midpoint [m M]
  ;; m + ((M - m) / 2)
  (+ m (/ (- M m) 2))
  )

(defn semantic-partitioning [s exponent left-char right-char]
  ;; 
  (let [n (** 2 exponent)
        min (atom 0)
        max (atom n)]
    (doseq [i (range 0 exponent)]
      (if (= (subs s i (inc i)) left-char)
        (swap! max #(midpoint @min %1))
        (when (= (subs s i (inc i)) right-char)
          (swap! min #(midpoint %1 @max))
          )
        )
      )
    @min
  )
  )

(defn get-row [boarding-pass]
  ;; 
  (let [s (subs boarding-pass 0 8)]
    (semantic-partitioning s 7 "F" "B")
    )
  )

(defn get-column [boarding-pass]
  ;;
  (let [len (count boarding-pass)
        s (subs boarding-pass (- len 3) len)]
    (semantic-partitioning s 3 "L" "R")
    )
  )

(defn get-id [boarding-pass]
  ;; Compute boarding pass id:
  ;; id = (row * 8) + col
  (let [row (get-row boarding-pass)
        col (get-column boarding-pass)]
    (+ col (* 8 row))
    )
  )

(defn find-missing-seat [id-coll]
  ;;
  (let [sorted-ids (vec (sort id-coll))]
    (doseq [i (range 1 (count sorted-ids))]
      (when (not= (- (sorted-ids i) (sorted-ids (dec i))) 1)
        (println "Your seat is between seats:" (sorted-ids (dec i)) (sorted-ids i))
        )
     )
    )
  )

(let [input-path "./input/day5.txt"
      boarding-passes (get-lines input-path)]
  (println
   "Highest seat ID on a boarding pass:"
   (reduce max (map get-id boarding-passes)))
  
  (find-missing-seat (map get-id boarding-passes))
  )
