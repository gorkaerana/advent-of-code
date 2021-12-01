(use 'clojure.java.io)

(defn get-lines [fname]
  ;; Reads lines of 'fname' into array
  (with-open [r (reader fname)]
    (doall (line-seq r))
    )
  )

(defn slice [coll i j]
  ;; Takes slice from coll, i.e., items between
  ;; indexes i (included) and j (not included)
  (->> coll (take j) (drop i))
  )

(defn get-blank-line-indexes [coll]
  ;; Returns indexes of empty lines
  ;; as vectors with two elements
  (let [indexes (vec (filter
                      #(= (coll %1) "")
                      (range 0 (count coll))))]
    (for [i (range 0 (dec (count indexes)))]
      [(inc (indexes i)) (indexes (inc i))]
      )
    )
  )

(defn consolidate-group-forms [coll]
  ;;
  (apply str coll)
  )

(defn unique-chars [string]
  ;;
  (set string)
  )

(defn consolidate-for-comparison [coll]
  ;;
  (let [answers (->> coll
                     (consolidate-group-forms)
                     (unique-chars)
                     (into []))
        vec-coll (vec coll)]
    (for [i (range 0 (count vec-coll))]
      ;; TODO: check whether answer is contained in each response
      (println (vec-coll i))
      )
    )
  )

;; NOTE: remember to add blank line to beginning and end of input file
(let [input-path "./input/day6.txt"
      declaration-forms (vec (get-lines input-path))
      group-forms-indexes (vec (get-blank-line-indexes declaration-forms))]

  ;; (println "Sum of 'yes' answers for all groups:"
  ;;          (->> group-forms-indexes
  ;;               (map #(slice declaration-forms (%1 0) (%1 1)))
  ;;               (map consolidate-group-forms)
  ;;               (map unique-chars)
  ;;               (map count)
  ;;               (reduce +)))
  
  (println
           (->> group-forms-indexes
                (map #(slice declaration-forms (%1 0) (%1 1)))
                (map consolidate-for-comparison)
                ))

  )
