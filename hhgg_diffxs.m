(* Script to compute the partonic diff cross sectio for the double Higgs production from gluon fusion in the SM *)
(* There are 2 topologies fro the process gg -> HH, trinagle and box *)
(* Loading packages FormCalc and FeynArts *)

<< FormCalc`FormCalc`
<< HEP`FeynArts`

(* generate the topologies, make sure to exclude topoligies of NLO, like ggg -> fermion triangle -> HH *)
TriangleTop = CreateTopologies[1, 2 -> 2, ExcludeTopologies -> Loops[Except[3]]];
BoxTop = CreateTopologies[1,2->2 , ExcludeTopologies -> Loops[Except[4]]];

(* insert fields *)
(* gluon == V[5], Higgs == S[1], onl[y top diagram *)

TriDiag  = InsertFields[TriangleTop, {V[5], V[5]} -> {S[1], S[1]},
   Model -> {SMQCD}, InsertionLevel -> {Particles} ,
   Restrictions -> {NoLightFHCoupling},
   ExcludeFieldPoints -> {FieldPoint[V[5], V[5], V[5]]}] ;


BoxDiag  = InsertFields[BoxTop, {V[5], V[5]} -> {S[1], S[1]},
   Model -> {SMQCD}, InsertionLevel -> {Particles} ,
   Restrictions -> {NoLightFHCoupling}] ; (* No need here for the gg copupling exclusion *)

(* Generate Feynman amplitude and then process them with FROM via FormCalc  *)

TriAP = CreateFeynAmp[TriDiag];
BoxAP = CreateFeynAmp[BoxDiag];

(* Enable ::  Passario Veltman  reduction of  tensor to scalar integrals*)

TriA = CalcFeynAmp[TriAP, PaVeReduce -> True] ;

BoxA = CalcFeynAmp[BoxAP, PaVeReduce -> True] ;

(* Colour traces result in an additional 2 factor *)

M = TriA + BoxA;

M2 = SquaredME[M,M] ;

(* Polirisation sums *)
(* Remove abbrivations *)
M = Combine[TriA , BoxA];

M2 = SquaredME[M,M] ;

(* Polirisation sums *)
(* Remove abbrivations *)
AvgM2 = PolarizationSum[M2] //Simplify //UnAbbr
Export["Xs.dat",AvgM2 //FortranForm]
