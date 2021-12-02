(use 'clojure.java.io
     'clojure.string)

(defn get-lines [fname]
  ;; Reads lines of 'fname' into array
  (with-open [r (reader fname)]
    (doall (line-seq r))
    )
  )

(defn to-int [string]
  ;; Coerces string to integer
  (Integer/parseInt string))

(defn parse-instruction [row]
  ;;
  (let [splitted (split row #"[ ]+")]
   [(splitted 0)  (to-int (splitted 1))]
   )
  )

(defn run-instruction [instruction index accumulator]
  ;;
  (let [name (instruction 0)
        number (instruction 1)]
    (if (= name "acc")
      (do
        (inc index)
        (swap! accumulator inc))
      (if (= name "jmp")
        (+ index number)
        (if (= name "nop")
          (inc index)
          false))))
 )

(let [input-file "./input/day8.txt"
      input-array (vec (parse-instruction (get-lines input-file)))
      example ((vec input-array) 0)
      index (atom 0)
      accumulator (atom 0)
      has-been-run (atom (vec (for [i (range 0 (count input-array))] false)))]
  (println example)
  (println
   (run-instruction
    (parse-instruction example) 0 accumulator))

  (while (not (@has-been-run @index))
    (do
      (swap!
       index
       #(run-instruction (input-array @index) %1 accumulator))
      (swap! has-been-run #(assoc %1 @index true))
      )
    )
  
  ;; (println @has-been-run)
  ;; (println (swap! has-been-run #(assoc % 0 true)))
  ;; (println @has-been-run)
 )
