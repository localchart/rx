(define (test-re-adt)
  (check (re-string? (make-re-string "blah")) => #t)
  (check (re-string? (make-re-char-set "blah")) => #f)
  (check (re-string? (re-string "blah")) => #t)
  (check (re-string:chars (re-string "blah")) => "blah")
  (check (re-char-set? (make-re-char-set "blah")) => #t)
  (check (re-char-set? (make-re-string "blah")) => #f)
  (check (re-char-set? (re-char-set "blah")) => #t)
  (check (re-char-set:cset (re-char-set "blah")) => "blah")
  (let* ((foo (re-string "foo"))
         (bar (re-string "bar"))
         (baz (re-char-set "baz"))
         (bla (make-re-submatch bar)))

    (check (re-seq? (make-re-seq (list foo bar))) => #t)
    (check (re-seq? (re-seq (list bar baz))) => #t)
    (check (re-seq? foo) => #f)
    (check (re-seq:elts (make-re-seq '())) => '())
    (check (re-seq:elts (make-re-seq (list foo bar))) => (list foo bar))
    (check (re-seq:tsm (make-re-seq (list baz bla))) => 1)

    (check (re-choice? (make-re-choice (list bar baz))) => #t)
    (check (re-choice? (re-choice (list bar baz))) => #t)
    (check (re-choice? baz) => #f)
    (check (re-choice? (re-choice '())) => #f)
    (check (re-choice? (re-choice (list baz))) => #f)
    (check (re-choice:elts (make-re-choice (list foo baz))) => (list foo baz))
    (check (re-choice:tsm (make-re-choice (list foo bar baz))) => 0)

    (check (re-repeat? (make-re-repeat 0 1 bar)) => #t)
    (check (re-repeat? bar) => #f)
    (check (re-repeat? (re-repeat 10 1 foo)) => #f)
    (check (re-repeat? (re-repeat 0 10 (re-choice (list foo bar)))) => #t)
    (check (re-repeat:from (re-repeat 10 12 baz)) => 10)
    (check (re-repeat:to (re-repeat 0 5 bar)) => 5)
    (check (re-repeat:tsm (re-repeat 0 3 bar)) => 0)

    (check (re-submatch? (make-re-submatch bar)) => #t)
    (check (re-submatch? bar) => #f)
    (check (re-submatch:pre-dsm (re-submatch bar)) => 0)
    (check (re-submatch:pre-dsm (re-submatch bar 2 3)) => 2)
    (check (re-submatch:post-dsm (re-submatch foo 4)) => 0)
    (check (re-submatch:post-dsm (re-submatch foo 4 7)) => 7)
    (check (re-submatch:tsm (re-submatch foo)) => 1)
    (check (re-submatch:tsm (re-submatch bla 1 1)) => 4)

    (check (re-dsm? (make-re-dsm bla 1 0)) => #t)
    (check (re-dsm? (re-dsm bar 2 3)) => #t)
    (check (re-dsm? (make-re-submatch bar 2 3)) => #f)
    (check (re-dsm:body (re-dsm foo 0 2)) => foo)
    (check (re-dsm:pre-dsm (re-dsm foo 2 0)) => 2)
    (check (re-dsm:post-dsm (re-dsm bar 1 3)) => 3)
    (check (re-dsm:tsm (re-dsm bla 2 3)) => 6)

    (check (re-bos? re-bos) => #t)
    (check (re-bos? bar) => #f)
    (check (re-eos? re-eos) => #t)
    (check (re-eos? foo) => #f)
    (check (re-bol? re-bol) => #t)
    (check (re-bol? bla) => #f)
    (check (re-eol? re-eol) => #t)
    (check (re-eol? baz) => #f)
    (check (re-trivial? re-trivial) => #t)
    (check (re-trivial? bla) => #f)
    (check (re-empty? re-empty) => #t)
    (check (re-empty? bla) => #f)
    (check (re-any? re-any) => #t)
    (check (re-any? bla) => #f)

    (check (re-tsm bla) => 1)
    (check (re-tsm foo) => 0)
    (check (re-tsm (re-dsm foo 4 4)) => 8)))
