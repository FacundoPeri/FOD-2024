program ejer7;
type
	novela = record
		cod : integer;
		nom : string;
		genero: string;
		precio : real;
	end;
	
	ArchivoNovelas = file of novela;

	procedure leerNovela(var n:novela);
	begin
		writeln();
		writeln('====== Ingrese los Datos de la Novela ======');
		with n do begin
			write('Ingrese el codigo de la novela: ');
			readln(cod);
			if (cod <> 0) then begin
				write('Ingrese el nombre de la novela: ');
				readln(nom);
				write('Ingrese el genero de la novela: ');
				readln(genero);
				write('Ingrese el precio de la novela: ');
				readln(precio);
			end;
		end;
		writeln('============================================');
	end;

	procedure cargarNovelasTxt(var novTxt : text);
	var
		n:novela;
	begin
		rewrite(novTxt);
		writeln();
		writeln('====== Se cargara un archivo TXT de novelas ======');
		leerNovela(n);
		while (n.cod <> 0) do begin
			with n do begin
				writeln(novTxt,cod,' ',precio:2:2,' ',genero);
				writeln(novTxt,nom);
			end;
			leerNovela(n);
		end;
		close(novTxt);
		writeln('==================================================');
	end;
	
	procedure cargarNovelasBin(var novBin : ArchivoNovelas;var novTxt : text);
	var		
		n:novela;
	begin
		rewrite(novBin);
		reset(novTxt);
		writeln();
		writeln('====== Se importaran los datos de un archivo TXT a un BIN ======');
		while (not eof(novTxt)) do begin
			with n do begin
				readln(novTxt,cod,precio,genero);
				readln(novTxt,nom);
			end;
			write(novBin,n);
		end;
		close(novTxt);
		close(novBin);
		writeln('================================================================');
	end;
	
	procedure agregarNovela(var novBin : ArchivoNovelas);
	var
		n:novela;
	begin
		reset(novBin);
		seek(novBin,filesize(novBin));
		writeln();
		writeln('====== Se agregara una Novelas al archivo ======');
		leerNovela(n);
		if (n.cod <> 0) then write(novBin,n);
		writeln('================================================');
		close(novBin);
	end;
	
	procedure modificarNovelas(var novBin : ArchivoNovelas);
	var
		n:novela;
		exito:boolean;
		cod:integer;
	begin
		exito:=false;
		reset(novBin);
		writeln();
		writeln('====== Se modificará una Novelas al archivo ======');
		write('Ingrese el codigo de la novela a modificar: ');
		readln(cod);
		while ((not eof(novBin)) and (not exito)) do begin
			read(novBin,n);
			if (n.cod = cod) then begin
				seek(novBin, filepos(novBin)-1);
				leerNovela(n);
				write(novBin,n);
				exito:=true;
			end;
		end;
		if (exito = true) then writeln('====== Se modifico la novela con exito ======')
		else writeln('====== Fallo la modificacion, la novela no existe ======');
		writeln('==================================================');
		close(novBin);
	end;
	
	procedure ExportarATexto(var novBin:ArchivoNovelas; var novTxt : text);
	var
		n:novela;
	begin
		reset(novBin);
		rewrite(novTxt);
		writeln('====== Se exportaran los datos de binario a texto ======');
		writeln('========================================================');
		while (not eof(novBin)) do begin
			read(novBin,n);
			with n do begin
				writeln(novTxt,cod,' ',precio:2:2,' ',genero);
				writeln(novTxt,nom);
			end;
		end;
		writeln('========================================================');
		close(novBin);
		close(novTxt);
	end;
	
	
	function menuOpciones():integer;
	begin
		writeln();
		writeln('--------- Bienvenido ---------');
		writeln('Elija alguna de las siguientes opciones ingresando el numero correspondiente:');
		writeln('1 - Crear un Archivo de Novelas Binario.');
		writeln('2 - Agregar Novela.');
		writeln('3 - Modificar Novela.');
		writeln('4 - Exportar Binario A Texto');
		writeln('5 - Salir');
		writeln('------------------------------');
		writeln('6 - Cargar Archivo de Texto.');
		writeln();
		write('Ingrese una opcion: ');
		readln(menuOpciones);
	end;
var	
	opcion : integer;
	novTxt : text;
	novBin : ArchivoNovelas;
	nom_fisico : string;
begin
	write('Ingrese el nombre del archivo binario con el que trabajara: ');
	readln(nom_fisico);
	assign(novBin,nom_fisico);
	assign(novTxt,'novelas.txt');
	opcion := menuOpciones();
	while (opcion <> 5) do begin
		case opcion of
			1:	cargarNovelasBin(novBin,novTxt);
			2:  agregarNovela(novBin);
			3:  modificarNovelas(novBin);
			4:	ExportarATexto(novBin,novTxt);
			6:	cargarNovelasTxt(novTxt);
			else writeln('====== No se Selecciono una Opcion Valida ======');
		end;
		opcion := menuOpciones();
	end;	
end.
		
