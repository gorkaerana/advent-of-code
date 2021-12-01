(use 'clojure.java.io
     '[clojure.string :as str]
     '[clojure.pprint :as pprint])

(defn get-lines
  "Reads lines of 'fname' into array"
  [fname]
  (with-open [r (reader fname)]
    (doall (line-seq r))
    )
  )

(defn to-int
  "Coerces string to integer"
  [string]
  (Integer/parseInt string)
  )

(defn parse-bag-quantity
  ""
  [s]
  (let [[quantity color] (str/split s #" " 2)
        color-kwd (keyword (str/replace color #" " "-"))]
    (if (= quantity "no")
      {}
      (into {} [[color-kwd (to-int quantity)]])
      )
    )
  )

(defn parse-rules
  ""
  [row]
  (let [[color-str bags-str] (str/split
                              (str/replace row #"[.]" "")
                              #" bags contain ")
        color-kwd (keyword (str/replace color-str #" " "-"))
        clean-bags-str (str/replace bags-str #" bag[s]?" "")
        bags-list (map
                   parse-bag-quantity
                   (str/split clean-bags-str #", "))
        ]
    (into {} [[color-kwd (apply merge bags-list)]])
    )
  )

(let [input-file "./input/day7.txt"
      input-list (get-lines input-file)
      data-map (apply merge (map parse-rules input-list))
      my-bag :shiny-gold
      bags-containing-mine (filter
                            #(contains? (second %) my-bag)
                            data-map)
      bags-containing-mine2 (apply concat
                                   (for [k (keys bags-containing-mine)]
                                     (filter
                                      #(contains? (second %) k)
                                      data-map)))]
  ;; (pprint/pprint (into {} bags-containing-mine))
  ;; (pprint/pprint (into {} bags-containing-mine2))
  (pprint/pprint
   (count
   (merge
    (into {} bags-containing-mine)
    (into {} bags-containing-mine2))))
  ;; (pprint/pprint (+ (count bags-containing-mine) (count bags-containing-mine2)))
  )
