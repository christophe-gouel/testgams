$title 1-2-3 GE model

VARIABLE
  C    Consumption
  M    Import demand
  PC   Composite price for final consumption
  X    Export
  PY   Production price
  E    Exchange rate
  P    Price
  W    Welfare change
;

PARAMETER
  thetaM    Import budget share / 0.1 /
  thetaX    Export budget share / 0.1 /
  sigma     Armington substitution elasticity / 3 /
  omega     Elasticity of transformation / -2 /
  PWM       World price for imports / 1 /
  PWX       World price for exports / 1 /
  Y         Production /1 /
  r         Ratio of factor income to total income / 1 /
  t         Counterfactual tariff / 0 /
  t0        Initial tariff / 0 /
;

EQUATION
  EQ_C
  EQ_M
  EQ_PC
  EQ_X
  EQ_PY
  EQ_E
  EQ_P
  EQ_W
;

EQ_C..  PC*C =e= r*PY*Y + t*thetaM*M*E*PWM/(1+t0);
EQ_M..  M =e= C*[(1+t0)*PC/((1+t)*E*PWM)]**sigma;
EQ_PC.. PC =e= [thetaM*((1+t)*E*PWM/(1+t0))**(1-sigma)+(1-thetaM)*P**(1-sigma)]**(1/(1-sigma));
EQ_X..  X =e= Y*(PY/(E*PWX))**omega;
EQ_PY.. PY =e= [thetaX*(E*PWX)**(1-omega)+(1-thetaX)*P**(1-omega)]**(1/(1-omega));
EQ_P..  (PY/P)**omega*Y =e= (PC/P)**sigma*C;
EQ_E..  PWM*M =e= PWX*X;
EQ_W..  W =e= (C-1)*100;

MODEL
  GE123 Model without trade balance equation /
  EQ_C
  EQ_M
  EQ_PC
  EQ_X
  EQ_PY
  EQ_P
  EQ_W
 /
;

* Calibration
** Variables initialization
C.L          = 1;
M.L          = 1;
PC.L         = 1;
X.L          = 1;
PY.L         = 2;
P.L          = 1;
** Fix numeraire
E.FX         = 1;

* Check benchmark equilibrium
GE123.iterlim = 0;
solve GE123 using cns;
Abort$(GE123.sumInfes >= 1E-6) "Benchmark Replication Failed";
Abort$(abs(PWM*M.L-PWX*X.L) >= 1E-6) "Walras' law not satisfied";
GE123.iterlim = 1000;

$ontext
* Check homogeneity of degree 0
E.FX = 2;
solve GE123 using cns;
Abort$(abs(P.L-2) >= 1E-6) "Homogeneity of degree 0 not satisfied";
Abort$(abs(C.L-1) >= 1E-6) "Homogeneity of degree 0 not satisfied";
Abort$(abs(PWM*M.L-PWX*X.L) >= 1E-6) "Walras' law not satisfied";
$exit
$offtext
