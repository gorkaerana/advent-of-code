(use 'clojure.java.io)

(defn get-lines [fname]
  ;; Reads lines of 'fname' into array
  (with-open [r (reader fname)]
    (doall (line-seq r))
    )
  )

(defn count-trees [vector]
  ;;
  (count
   (vec
    (re-seq #"#"
            (apply str vector))))
  )

(let [r-steps 3
      d-steps 1
      input-path "./input/day3.txt"
      forest-map (vec (map vec (get-lines input-path)))
      nrow (count forest-map)
      ncol (count (forest-map 1))
      col (atom 0)
      tree-counter (atom -1)]
  ;; Traverse rows of forest-map by d-steps
  (doseq [i (range 1 nrow d-steps)]
    ;; Take r-steps to the right
    (doseq [j (range 0 r-steps)]
      (doseq [k (range -1 1)]
        ;; Increment col and take (mod col ncol) to save a single copy of the map in memory
        (when  (= (str ((forest-map i) (swap! col #(mod (inc %1) ncol)))) "#")
          (swap! tree-counter inc)
          )
        )
      )
    )
  (println @tree-counter)
  )
