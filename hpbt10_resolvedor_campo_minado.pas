(*Name: Hugo Paulino Bonfim Takiuchi*)
(*Login: hpbt10*)
(*GRR20102447*)

program resolvedor_campo_minado;

const min=8;max=40;

type matriz= array [1..max,1..max] of integer;
     matriz_booleana= array [1..max,1..max] of boolean;

var dados: text;
    m: matriz;
    p,q :matriz_booleana;
    tam,numero_bombas,linha,coluna: integer;
    terminou :boolean;

(*coloca os n??meros em volta das bombas*)
procedure colocarnumeros (var m:matriz;var tam:integer);
var linha,coluna: integer;
begin
	for linha:=1 to tam do
		for coluna:=1 to tam do
		begin
			if m[linha,coluna]=9 then
			begin
				if m[linha-1,coluna] <> 9 then
					m[linha-1,coluna]:=m[linha-1,coluna] + 1;
				if m[linha+1,coluna] <> 9 then
					m[linha+1,coluna]:=m[linha+1,coluna] + 1;
				if m[linha,coluna+1] <> 9 then
					m[linha,coluna+1]:=m[linha,coluna+1] + 1;
				if m[linha,coluna-1] <> 9 then
					m[linha,coluna-1]:=m[linha,coluna-1] + 1;
				if m[linha+1,coluna+1] <> 9 then
					m[linha+1,coluna+1]:=m[linha+1,coluna+1] + 1;
				if m[linha-1,coluna+1] <> 9 then
					m[linha-1,coluna+1]:=m[linha-1,coluna+1] + 1;
				if m[linha+1,coluna-1] <> 9 then
					m[linha+1,coluna-1]:=m[linha+1,coluna-1] + 1;
				if m[linha-1,coluna-1] <> 9 then
					m[linha-1,coluna-1]:=m[linha-1,coluna-1] + 1;
			end;
		end;
end;

(*ira ler o arquivo gerado pelo gerador_campo_minado e inicializar o campo*)
procedure inicializar (var dados: text;var m:matriz;var tam,numero_bombas: integer);
var linha,coluna,i: integer;
begin
	assign (dados,paramstr(1));
	reset (dados);
	readln (dados,tam,numero_bombas);
	for linha:=0 to tam+1 do
		for coluna:=0 to tam+1 do
			m[linha,coluna]:=0;
        for i:=1 to numero_bombas do
        begin
                readln(dados,linha,coluna);  
                m[linha,coluna]:=9;
        end;
        colocarnumeros (m,tam);
        writeln ('tamanho do campo: ',tam);
        writeln('quantidades de bombas: ',numero_bombas);
        close (dados);
end;

(*vai inicializar a matriz booleana,que serve para ver se uma posicao esta aberta ou fechada*)
procedure inicializarbooleana (var p: matriz_booleana;var tam: integer);
var linha,coluna: integer;
begin
	for linha:=1 to tam do
		for coluna:=1 to tam do
			p[linha,coluna]:=false
end;

(*ira revelar o campo para conferir as posicoes*)
procedure revelarcampo (var m:matriz;var tam:integer);
var linha,coluna: integer;
begin
	write ('   ');
	for linha:=1 to tam do
		write (' ',tam div 10);
	writeln;
	write ('   ');
	for linha:=1 to tam do
		write (' ',linha mod 10);
	writeln;
	write ('   ');
	for linha:=1 to tam do
		write ('--');
	writeln;
	for linha:=1 to tam do
        begin
		write(linha:2,'|');
                for coluna:=1 to tam do
			write (' ',m[linha,coluna]);
		writeln;
        end;
end;

(*imprime a matriz m*)
procedure imprimircampo (var m:matriz;var p :matriz_booleana;var tam:integer);
var linha,coluna: integer;
begin
	write ('   ');
	for linha:=1 to tam do
		write (' ',tam div 10);
	writeln;
	write ('   ');
	for linha:=1 to tam do
		write (' ',linha mod 10);
	writeln;
	write ('   ');
	for linha:=1 to tam do
		write ('--');
	writeln;
	for linha:=1 to tam do
        begin
		write(linha:2,'|');
                for coluna:=1 to tam do
			if p[linha,coluna]=false then
             			write (' ','#')
			else
			begin
				if m[linha,coluna] = 0 then
					write ('  ')
				else
					write (' ',m[linha,coluna]);
			end;
		writeln;
        end;
end;

(*vai abrir todas as posicoes que forem zero*)
procedure abrirzero (var m: matriz;var p: matriz_booleana;var tam: integer);
var linha,coluna,metade: integer;
begin
	metade:=(tam div 2);
	for linha:=metade downto 1 do
	begin
		for coluna:=metade downto 1 do
			if m[linha,coluna]=0 then
				p[linha,coluna]:=true;
	end;
	for linha:=metade downto 1 do
	begin
		for coluna:=metade to tam do
			if m[linha,coluna]=0 then
				p[linha,coluna]:=true;
	end;
	for linha:=metade to tam do
	begin
		for coluna:=metade downto 1 do
			if m[linha,coluna]=0 then
				p[linha,coluna]:=true;
	end;
	for linha:=metade to tam do
	begin
		for coluna:=metade to tam do
			if m[linha,coluna]=0 then
				p[linha,coluna]:=true;
	end;
end;

(*verifica se tem bomba em tal lugar*)
procedure verificacao (var m: matriz;var p: matriz_booleana;var tam: integer;var terminou: boolean);
var linha,coluna,metade: integer;
begin
	metade:=(tam div 2);
	if m[metade,metade] <> 9 then
		p[metade,metade]:=true;
	for linha:=metade downto 1 do
		for coluna:=metade downto 1 do
		begin
				if m[linha,coluna]=0 then
					abrirzero (m,p,tam);
				if m[linha,coluna]=1 then
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna+1]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha+1,coluna+2]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha,coluna+2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna+1]:=true;
						p[linha+1,coluna+2]:=true;
						p[linha-1,coluna+1]:=true;
						p[linha-1,coluna+2]:=true;
						p[linha,coluna+2]:=true;
					end;
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna-1]=1) 
and (m[linha-1,coluna-1]=1)
and (m[linha+1,coluna-2]=1)
and (m[linha-1,coluna-2]=1)
and (m[linha,coluna-2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna-1]:=true;
						p[linha+1,coluna-2]:=true;
						p[linha-1,coluna-1]:=true;
						p[linha-1,coluna-2]:=true;
						p[linha,coluna-2]:=true;
						imprimircampo (m,p,tam);
					end;
		end;
	for linha:=metade downto 1 do
		for coluna:=metade to tam do
		begin
				if m[linha,coluna]=0 then
					abrirzero (m,p,tam);
				if m[linha,coluna]=1 then
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna+1]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha+1,coluna+2]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha,coluna+2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna+1]:=true;
						p[linha+1,coluna+2]:=true;
						p[linha-1,coluna+1]:=true;
						p[linha-1,coluna+2]:=true;
						p[linha,coluna+2]:=true;
					end;
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna-1]=1) 
and (m[linha-1,coluna-1]=1)
and (m[linha+1,coluna-2]=1)
and (m[linha-1,coluna-2]=1)
and (m[linha,coluna-2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna-1]:=true;
						p[linha+1,coluna-2]:=true;
						p[linha-1,coluna-1]:=true;
						p[linha-1,coluna-2]:=true;
						p[linha,coluna-2]:=true;
						imprimircampo (m,p,tam);
					end;
		end;
				if m[linha,coluna]=0 then
					abrirzero (m,p,tam);
				if m[linha,coluna]=1 then
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna+1]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha+1,coluna+2]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha,coluna+2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna+1]:=true;

	for linha:=metade downto 1 do
		for coluna:=metade downto 1 do
		begin	p[linha+1,coluna+2]:=true;
						p[linha-1,coluna+1]:=true;
						p[linha-1,coluna+2]:=true;
						p[linha,coluna+2]:=true;
					end;
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna-1]=1) 
and (m[linha-1,coluna-1]=1)
and (m[linha+1,coluna-2]=1)
and (m[linha-1,coluna-2]=1)
and (m[linha,coluna-2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna-1]:=true;
						p[linha+1,coluna-2]:=true;
						p[linha-1,coluna-1]:=true;
						p[linha-1,coluna-2]:=true;
						p[linha,coluna-2]:=true;
						imprimircampo (m,p,tam);
					end;
		end;
	for linha:=metade to tam do
		for coluna:=metade to tam do
		begin
				if m[linha,coluna]=0 then
					abrirzero (m,p,tam);
				if m[linha,coluna]=1 then
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna+1]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha+1,coluna+2]=1) 
and (m[linha-1,coluna+1]=1) 
and (m[linha,coluna+2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna+1]:=true;
						p[linha+1,coluna+2]:=true;
						p[linha-1,coluna+1]:=true;
						p[linha-1,coluna+2]:=true;
						p[linha,coluna+2]:=true;
					end;
					if (m[linha-1,coluna]=1) 
and (m[linha+1,coluna]=1) 
and (m[linha+1,coluna-1]=1) 
and (m[linha-1,coluna-1]=1)
and (m[linha+1,coluna-2]=1)
and (m[linha-1,coluna-2]=1)
and (m[linha,coluna-2]=1) then
					begin
						p[linha,coluna]:=true;
						p[linha+1,coluna]:=true;
						p[linha-1,coluna]:=true;
						p[linha+1,coluna-1]:=true;
						p[linha+1,coluna-2]:=true;
						p[linha-1,coluna-1]:=true;
						p[linha-1,coluna-2]:=true;
						p[linha,coluna-2]:=true;
						imprimircampo (m,p,tam);
					end;
		end;
end;

begin (*Programa principal*)
	terminou:=false;
	while not terminou do
	begin
		inicializar (dados,m,tam,numero_bombas);
		inicializarbooleana (p,tam);
		imprimircampo (m,p,tam);
		verificacao (m,p,tam,terminou);
		revelarcampo (m,tam);
		terminou:=true;
	end;
end.