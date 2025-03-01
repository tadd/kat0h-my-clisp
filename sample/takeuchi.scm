(define count 0)
(define tarai
  (lambda (x y z)
    (begin
      (set! count (+ count 1))
      (if (<= x y) 
        y
        (tarai (tarai (- x 1) y z) (tarai (- y 1) z x) (tarai (- z 1) x y))))))
(tarai 10 6 0)
