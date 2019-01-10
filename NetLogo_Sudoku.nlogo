__includes ["Sudoku1.nls" "Sudoku2.nls" "Sudoku3.nls"]
breed [kvadratici kvadratic]
globals [lista lista2 x2 y2]

kvadratici-own
[
  kvadraticX
  kvadraticY
  broj
  regija
  uRelaciji
  kandidati
  isti-red
  isti-stupac
  ista-regija
]

to Setup-Game

  clear-all
  ask patches [set pcolor green]
  nacrtaj-resetku
  setup-kvadratice

  ask kvadratici
  [

    set isti-red kvadratici with
      [self != myself and (kvadraticY = [kvadraticY] of myself) ]
    set isti-stupac kvadratici with
      [ self != myself and (kvadraticX = [kvadraticX] of myself) ]
    set ista-regija kvadratici with
      [ self != myself and (regija = [regija] of myself) ]
    set uRelaciji kvadratici with
      [self != myself and (kvadraticX = [kvadraticX] of myself or kvadraticY = [kvadraticY] of myself or regija = [regija] of myself)]

  ]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;; CRTANJE REŠETKE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to nacrtaj-Red [start-x kraj-x y]
  ask patches
  [
    if (pxcor >= start-x) and (pxcor <= kraj-x) and (pycor = y)
      [ set pcolor black ]
  ]
end


to nacrtaj-Stupac [x start-y kraj-y]
  ask patches
  [
     if (pxcor = x) and (pycor >= start-y) and (pycor <= kraj-y)
       [ set pcolor black ]
  ]
end

to nacrtaj-Retke [start-y]

  let y start-y

  nacrtaj-Red -90 90 y
  nacrtaj-Red -90 90 y + 1
  nacrtaj-Red -90 90 y + 21
  nacrtaj-Red -90 90 y + 41
end


to nacrtaj-Stupce [start-x]

  let x start-x

  nacrtaj-Stupac x -90 90
  nacrtaj-Stupac x + 1 -90 90
  nacrtaj-Stupac x + 21 -90 90
  nacrtaj-Stupac x + 41 -90 90
end


to nacrtaj-resetku

  nacrtaj-Retke -92
  nacrtaj-Retke -31
  nacrtaj-Retke 30
  nacrtaj-Red -92 92 91
  nacrtaj-Red -92 -92 92

  nacrtaj-Stupce -92
  nacrtaj-Stupce -31
  nacrtaj-Stupce 30
  nacrtaj-Stupac 91 -92 90
  nacrtaj-Stupac 92 -92 90
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sluzi za raspored brojeva po rešetki
; vraca listu lokacija
; kad se vrijednost unese u kvadratic koordinate tog kvadratica se spreme u listu


to-report kvadratic-lokacija [ovaj-kvadratic-x ovaj-kvadratic-y]

  report
     list
       (-99 + ovaj-kvadratic-x * 20 + int (ovaj-kvadratic-x / 3))
       (-103 + ovaj-kvadratic-y * 20 + int (ovaj-kvadratic-y / 3))
end


to setup-kvadratic [ovaj-kvadratic-x ovaj-kvadratic-y]  ;; (1,1) lijevo dolje (9,9) desno gore

  let lokacija (kvadratic-lokacija ovaj-kvadratic-x ovaj-kvadratic-y)
  let x first lokacija
  let y last lokacija

  create-kvadratici 1
  [
   set size 0
   setxy x y
   set kvadraticX ovaj-kvadratic-x
   set kvadraticY ovaj-kvadratic-y
   set broj 0
   set lista []
   set lista2 []
   set kandidati []
   set regija (floor ((who mod 9) / 3)) + (3 * (floor (who / 27)))
  ]
end

to setup-kvadratice

  let x 1
  let y 1

  while [x <= 9]
  [
    set y 1
    while [y <= 9]
    [
      setup-kvadratic x y
      set y y + 1
    ]
    set x x + 1
  ]
end



to oboji-Kvadratic [x y]
  ask patches
  [
    let x1 (-99 + x * 20 + int (x / 3))
    let y1 (-103 + y * 20 + int (y / 3))
    if (pxcor >= x1 - 10) and (pxcor <= x1 + 6) and (pycor >= y1 - 5) and (pycor <= y1 + 10)
      [ set pcolor yellow ]
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



to play

;  if not any? kvadratici with [broj = 0]
;  [
;    user-message (word "Sudoku je uspješno riješen! :)")
;  ]
;





if Nule?
      [
        ask kvadratici with [broj = 0]
        [
          set label (word broj)
          set label-color orange
        ]
      ]

  ask kvadratici with [ broj = 0 ]
  [
        foreach [1 2 3 4 5 6 7 8 9]
        [
          let x ?
          if (not any? isti-red with [broj = x])
          and (not any? isti-stupac with [broj = x])
          and (not any? ista-regija with [broj = x])
           [set kandidati lput x kandidati ]
        ]

       if(length kandidati = 1 )
       [
         let y first kandidati
         set broj y
         set label (word broj)
         set label-color black ]

       set kandidati[]
  ]



       foreach [ 1 2 3 4 5 6 7 8 9 ]
      [
        let w ?

        foreach [1 2 3 4 5 6 7 8 9]
        [
          let x ?

          foreach [1 2 3 4 5 6 7 8 9]
          [
            let y ?
            ask kvadratici with [broj = 0 and kvadraticX = x and kvadraticY = y]
            [
                 if (not any? uRelaciji with [broj = w])
                 [set lista lput y lista]
            ]
          ]

           if(length lista = 1)
           [let z first lista
             ask kvadratici with [broj = 0 and kvadraticX = x and kvadraticY = z]
             [set broj w
             set label (word broj)
             set label-color blue]]
           set lista[]
        ] ]



         foreach [ 1 2 3 4 5 6 7 8 9 ]
      [
        let w ?

        foreach [1 2 3 4 5 6 7 8 9]
        [
          let y ?

          foreach [1 2 3 4 5 6 7 8 9]
          [
            let x ?
            ask kvadratici with [broj = 0 and kvadraticX = x and kvadraticY = y]
            [
                 if (not any? uRelaciji with [broj = w])
                 [set lista lput x lista]
            ]
          ]

           if(length lista = 1)
           [let z first lista
             ask kvadratici with [broj = 0 and kvadraticX = z and kvadraticY = y]
             [set broj w
             set label (word broj)
             set label-color red ]]
           set lista[]
        ]

      ]



  if (count kvadratici with [broj = 0] = 0)
  [
    user-message (word "Sudoku je uspješno riješen! :)")
  ]
end


to oznaci
  ask patches with [pcolor = yellow][set pcolor green]
    foreach[1 2 3 4 5 6 7 8 9]
    [
      let x ?
      foreach [1 2 3 4 5 6 7 8 9]
      [
        let y ?
        ask kvadratici with [kvadraticX = x and kvadraticY = y]
        [if (broj = Oznaci-broj)[set x2 x set y2 y]]
        oboji-Kvadratic x2 y2
        set x2 0
        set y2 0
      ]
    ]


end


to prikazi-regije

;  ca
;  ask patches [set pcolor green]
;  nacrtaj-resetku
;  setup-kvadratice
   ask patches with [pcolor = yellow][set pcolor green]
  ask kvadratici [set label (word regija) set label-color black]

end


