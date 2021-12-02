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

(defn parse-row [row]
  ;; Parse input row and return hash map with the following keys
  ;; min: minimum amount of times 'letter' ought to appear in 'password'
  ;; max: maximum amount of times 'letter' ought to appear in 'password'
  ;; letter: character that ought to appear between 'min' and 'max' times in 'password'
  ;; password: 
  (let [splitted-row (split row #"[ ]+")
        thresholds (split (splitted-row 0) #"[-]+")
        letter (splitted-row 1)
        password (splitted-row 2)]
    {:min (to-int (thresholds 0))
     :max (to-int (thresholds 1))
     :letter ((split letter #":") 0)
     :password password}
    )
  )

(defn old-policy [hash-map]
  ;; Checks whether a (:password hash-map) fills
  ;; fills the following requisites:
  ;; 1.- it contains at least (:min hash-map)
  ;; ocurrences of (:letter hash-map)
  ;; 2.- it contains at most (:max hash-map)
  ;; occurrences of (:letter hash-map)
  (let [letter-occurrences (re-seq
                            (java.util.regex.Pattern/compile
                             (:letter hash-map))
                            (:password hash-map))
        n-occurrences (count letter-occurrences)
        min (:min hash-map)
        max (:max hash-map)]
    (and (<= min n-occurrences) (<= n-occurrences max))
    )
  )

(defn new-policy [hash-map]
  ;; Checks whether (:password hash-map) fulfills exactly
  ;; one of the following requirements:
  ;; 1.- character in position (:min hash-map)
  ;; --non-zero-indexed!-- is (:letter hash-map)
  ;; 2.- character in position (:max hash-map)
  ;; --non-zero-indexed!-- is (:letter hash-map)
  (let [min (dec (:min hash-map))
        max (dec (:max hash-map))
        letter (:letter hash-map)]
    (=
     (count
      (filter identity
              [(= (subs (:password hash-map) min (inc min)) letter)
               (= (subs (:password hash-map) max (inc max)) letter)]))
     1)
    )
  )

(let [input-path "./input/2-1.txt"
      input-array (vec (get-lines input-path))]
  (println "# of valid passwords (old policy):"
   (count
    (filter old-policy
            (map parse-row input-array))))
  (println "# of valid passwords (new policy):"
   (count
    (filter new-policy
            (map parse-row input-array))))
  )
