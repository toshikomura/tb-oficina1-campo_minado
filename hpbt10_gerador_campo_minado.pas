(*Name: Hugo Paulino Bonfim Takiuchi*)
(*Login: hpbt10*)
(*GRR20102447*)

program gerador_campo_minado;

uses sysutils;

const min=8;max=40;

type matriz= array [1..max,1..max] of integer;
     matriz_booleana= array [1..max,1..max] of boolean;

var m,n: matriz;
    p: matriz_booleana;
    tam,numero_bombas: integer;

(*ler o n??mero de bombas e o tamanho da matriz*) 
procedure lerbombamatriz (var m:matriz;var tam,numero_bombas:integer);
var num_str,num_str1 :string;
begin
	num_str:= paramstr(1);
	tam:= strtoint(num_str);
	if tam > max then
		tam:=max;
	if tam < min then
		tam:=min;
	num_str1:= paramstr(2);
	numero_bombas:= strtoint(num_str1);
end;

(*zera ambas as matrizes*)
procedure zerarmatriz (var n,m: matriz;var p: matriz_booleana;var tam:integer);
var linha,coluna: integer;
begin
	for linha:=1 to tam do
		for coluna:=1 to tam do
			n[linha,coluna]:=0;
			m[linha,coluna]:=0;
			p[linha,coluna]:=false;
end;

(*coloca os parametros e imprime o tamanho da matriz,a quantidade das bombas e as coordenadas destas*)
procedure imprimircampo (var m:matriz;var p :matriz_booleana;var tam,numero_bombas:integer);
var linha,coluna: integer;
    dados: text;
begin
	assign(dados,paramstr(3));
	rewrite (dados);
	writeln (dados,tam,' ',numero_bombas);
	for linha:=1 to tam do
		for coluna:=1 to tam do
		begin
			if m[linha,coluna]=9 then
				writeln (dados,linha,' ',coluna);
		end;
	close (dados);
end;

(*randomiza e coloca as bombas aleatoriamanete na matriz*)
procedure colocarbomba (var n:matriz;var tam,numero_bombas:integer);
var i,j,linha,coluna,tempbombas:integer;
begin
	for i:=1 to tam do
		for j:=1 to tam do
			n[i,j]:=0;
        tempbombas:=numero_bombas;
        for i:=1 to tam do
        	for j:=1 to tam do
        		while (tempbombas>0) do
        		begin
				linha:= random (tam)+1;
				coluna:= random (tam)+1;
				if (n[linha,coluna]<>9) and ((linha <> (tam div 2)) or (coluna <> (tam div 2))) then
				begin
					n[linha,coluna]:=9;
                     			tempbombas:=tempbombas-1;
				end;
			end;
end;

(*copia os valores da matriz 'n' para a matriz 'm'*)
procedure copiarvalores (var m: matriz;var n: matriz);
var linha,coluna: integer;
begin
	for linha:=1 to tam do
		for coluna:=1 to tam do
			m[linha,coluna]:=n[linha,coluna];
end;

begin (*programa principal*)
        randomize();
	lerbombamatriz (m,tam,numero_bombas);
	zerarmatriz (n,m,p,tam);
	colocarbomba (n,tam,numero_bombas);
	copiarvalores (m,n);
	imprimircampo (m,p,tam,numero_bombas);
end.
