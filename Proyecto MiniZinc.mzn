%------------------PROYECTO 2: CONJUNTO RESIDENCIAL-----------------
%--------------------CARLOS DANIEL LONDOÑO AVILA--------------------
%---------------------------PROGRAMACIÓN 3--------------------------
%-----------------UNIVERSIDAD TECNOLÓGICA DE PEREIRA----------------
%-------------------------------2020-1------------------------------

%-----Librerías
include "alldifferent.mzn";

%-----Variables y parametros
enum Casas = {Casa227, Casa213, Casa210, Casa317, Casa110, Casa107, LIBRE};
enum Dias = {VIERNES, SABADO, DOMINGO};
enum Horarios = {H8_10, H10_12, H12_2, H2_4, H4_6};
enum Zonas = {Piscina, Gimnsaio};
array[Zonas, Horarios, Dias] of var Casas: Asignacion;

%-----Restricciones

 % Esta restricción se encarga de que a cada casa le toque solo 2 bloques por semana en cada zona
constraint forall(z in Zonas)( forall(i in Casas where i<card(Casas))( sum(f in Horarios, c in Dias)(Asignacion[z,f,c] = i) = 2 ));  

 % Esta restricción se encarga de que a una casa no le toquen los dos bloques semanales de una zona, en un solo día.
constraint forall(z in Zonas)( forall(i in Casas where i<card(Casas))( forall(f in Dias)(sum(c in Horarios)(Asignacion[z,c,f] = i) <= 1) ));

 % Esta restricción se encarga de que no queden asignadas dos zonas distintas a una misma casa en el mismo día y hora 
constraint forall(f in Horarios, c in Dias)( Asignacion[Zonas[1],f,c] != Asignacion[Zonas[2],f,c] );   

%-----Tipo de solución
solve satisfy;

%-----Salida
output["Zona: ", "\(Zonas[1])\n"]++["\t"]++["\( Dias[d] )\t"| d in Dias]++["\n----------------------------------\n"]++
[if d=1 then "\(Horarios[h]): \t" else "" endif ++ "\(Asignacion[Zonas[1],h,d])" ++
if d=card(Dias) then "\n" else "\t" endif | h in Horarios, d in Dias]++
["\nZona: ", "\(Zonas[2])\n"]++["\t"]++["\( Dias[d] )\t"| d in Dias]++["\n----------------------------------\n"]++
[if d=1 then "\(Horarios[h]): \t" else "" endif ++ "\(Asignacion[Zonas[2],h,d])" ++
if d=card(Dias) then "\n" else "\t" endif | h in Horarios, d in Dias];
