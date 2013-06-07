program gera_campo_minado;

uses crt, sysutils;

const
   MIN = 8;
   MAX = 40;

type
   matriz_int = array [1..MAX,1..MAX] of integer;

var
   tamanho, bombas : integer;
   mi		   : matriz_int;
   transfere	   : text;

{###############################################}


procedure le_confirma(var tamanho, bombas : integer);
begin
   tamanho:=strtoint(paramstr(1)); {L?? da entrada padr??o o tamanho do campo.}
   bombas:=strtoint(paramstr(2)); {L?? da entrada padr??o o n??mero de bombas.}
   if (tamanho < MIN) or (tamanho > MAX) then {Condicional para verifica????o do tamanho informado para o campo.}
   begin
      repeat {Repetir at?? que as especifica????es sejam atendidas.}
	 writeln('Digite um valor de 8 at?? 40');
	 readln(tamanho);
      until (tamanho > MIN) and (tamanho < MAX);
   end;
   if (bombas > (tamanho*tamanho)) then {Condicional para verifica????o do valor informado para o n??mero de bombas.}
   begin
      repeat {Repetir at?? que as especifica????es sejam atendidas.}
	 writeln('Digite um valor menor que o quadrado do tamanho');
	 readln(bombas);
      until bombas < (tamanho*tamanho);
   end;
end; { le_confirma }


{###############################################}


procedure distribui_bombas( tamanho, bombas : integer; var mi : matriz_int);

var
   i, j,  x, y : integer;

begin
   for i:=1 to tamanho do {Zera todos os campos da matriz.}
      for j:=1 to tamanho do
	 mi[i,j]:=0;
   for i:=1 to bombas do {Distribui as bombas pela matriz.}
   begin
      x:=(1+random(tamanho)); {Sorteia uma linha da matriz, onde ser?? colocada uma bomba.}
      y:=(1+random(tamanho)); {Sorteia a posi????o da linha escolhida anteriormente para colocar a bomba.}
      while (mi[x,y]=9) do
      begin
	 x:=(1+random(tamanho));
	 y:=(1+random(tamanho));
	 while (x=((tamanho div 2)-1)) or (x=(tamanho div 2)) or (x=((tamanho div 2)+1)) or (y=((tamanho div 2)-1)) or (y=(tamanho div 2)) or (y=((tamanho div 2)+1)) do {Verifica se a posi????o j?? est?? ocupada por uma bomba. Caso esteja, sorteia novamente at?? achar uma posi????o vazia.}
	 begin
	    x:=(1+random(tamanho));
	    y:=(1+random(tamanho));
	 end;
      end;
      mi[x,y]:=9; {Marca a posi????o como contendo uma bomba.}
   end;
end; { distribui_bombas }


{###############################################}


procedure escreve_arquivo(tamanho, bombas : integer; var mi : matriz_int);

var
   x, y	: integer;

begin
   assign(transfere, paramstr(3));
   rewrite(transfere);
   writeln(transfere, tamanho, ' ', bombas);
   for x:=1 to tamanho do {Percorre a matriz em busca de bombas.}
   begin
      for y:=1 to tamanho do
      begin
	 if mi[x,y]=9 then {Se a posi????o possuir uma bomba, escreve no arquivo as coordenadas da bomba.}
	    writeln(transfere, x, ' ', y);
      end;
   end;
   close(transfere);
end; { escreve_arquivo }


{###############################################}


{Programa principal}

begin
   randomize;
   le_confirma(tamanho, bombas);
   distribui_bombas( tamanho, bombas, mi);
   escreve_arquivo(tamanho, bombas, mi);
end.