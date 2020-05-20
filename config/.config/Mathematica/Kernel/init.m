(** User Mathematica initialization file **)
With[{dir = $UserDocumentsDirectory <> "/Wolfram Mathematica"},
  If[DirectoryQ[dir], DeleteDirectory[dir]]
]
