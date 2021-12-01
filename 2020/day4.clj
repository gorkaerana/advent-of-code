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

(defn slice [coll i j]
  ;; Takes slice from coll, i.e., items between
  ;; indexes i (included) and j (not included)
  (->> coll (take j) (drop i))
  )

(defn get-blank-line-indexes [coll]
  ;; Returns indexes of empty lines
  (filter
    #(= (coll %1) "")
    (range 0 (count coll)))
  )

(defn consolidate-batch [coll]
  ;; Given some non-empty lines representing a passport,
  ;; consolidate it into a hash-map
  (let [passport (->> coll
                      (map #(split %1 #"[ ]+"))
                      (vec)
                      (apply concat)
                      (vec)
                      (map #(split %1 #":"))
                      )]
    (zipmap
     (map #(keyword (%1 0)) passport)
     (map #(%1 1) passport))
    )
  )

(defn validate-passport-keys [passport]
  ;; Given a passport, check whether it contains all
  ;; necessary fields. Validation is done by checking
  ;; whether the hash-map contains all keys defined
  ;; in a list.
  (let [fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]]
    (>=
     (count
      (filter
       #(contains? passport %1)
       (map keyword fields)))
     (count fields))
    )
  )

(defn passport-rules [passport]
  ;;
  (let [eye-colors '("amb" "blu" "brn" "gry" "grn" "hzl" "oth")
        byr (to-int (:byr passport))
        iyr (to-int (:iyr passport))
        eyr (to-int (:eyr passport))
        hgt (:hgt passport)
        hgt-int (to-int (re-find #"^\d+" hgt))
        hcl (:hcl passport)
        ecl (:ecl passport)
        pid (:pid passport)]
    
    (and
    ;; byr
    (and (<= 1920 byr) (<= byr 2002))
    ;; iyr
    (and (<= 2010 iyr) (<= iyr 2020))
    ;; eyr
    (and (<= 2020 eyr) (<= eyr 2030))
    ;; hgt
    (if (includes? hgt "cm")
      (and (<= 150 hgt-int) (<= hgt-int 193))
      (if (includes? hgt "in")
        (and (<= 59 hgt-int) (<= hgt-int 76))
        false
        )
      )
    ;; hcl
    (re-matches #"^#[0-9a-zA-Z]{6}" hcl)
    ;; ecl
    (some #(= ecl %1) eye-colors)
    ;; pid
    (= (count pid) 9)
    )
          )
    )

(defn validate-passport [passport]
  ;; Returns whether a passport is valid or not
  ;; based on
  ;; 1.- All keys are contained
  ;; 2.- Values of those keys follow the rules
  ;; specified in passport rules
  (if (validate-passport-keys passport)
    (passport-rules passport)
    false
      )
  )


;; NOTE: remember to add empty lines to beginning and end of input file
(let [input-path "./input/day4.txt"
      batch-file (vec (get-lines input-path))
      blank-line-indexes (vec (get-blank-line-indexes batch-file))
      key-counter (atom 0)
      rules-counter (atom 0)]

  (doseq [i (range 0 (dec (count blank-line-indexes)))]
    (when
        (->> (-> batch-file
                 (slice
                  (inc (blank-line-indexes i))
                  (blank-line-indexes (inc i))))
             (consolidate-batch)
             (validate-passport-keys))
      (swap! key-counter inc)
      )
    (when
        (->> (-> batch-file
                 (slice
                  (inc (blank-line-indexes i))
                  (blank-line-indexes (inc i))))
             (consolidate-batch)
             (validate-passport))
      (swap! rules-counter inc)
      )
    )
  (println "# of valid passports (keys):" @key-counter)
  (println "# of valid passports (rules):" @rules-counter)
  )
