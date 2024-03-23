program ejer4;
type
	empleado = record
		nro_empleado : integer;
		apellido : string;
		nombre : string;
		edad : integer;
		dni : string;
	end;
	
	ArchivoEmpleados = file of empleado;
	
procedure leerEmpleado (var e : empleado);
begin
	writeln();
	writeln('------ Se leera Informacion de un Empleado ------');
	with e do begin
		write('Ingrese el NRO del Empleado: ');
		readln(nro_empleado);
		write('Ingrese el apellido del Empleado: ');
		readln(apellido);
		if (apellido <> 'fin') then begin
			write('Ingrese el nombre del Empleado: ');
			readln(nombre);
			write('Ingrese el edad del Empleado: ');
			readln(edad);
			write('Ingrese el dni del Empleado: ');
			readln(dni);
		end;
	end;
	writeln('-------------------------------------------------');
end;
procedure cargarArchivo(var arEmp:ArchivoEmpleados);
var
	e:empleado;
begin	
	rewrite(arEmp);
	writeln();
	writeln('------ Se cargará el archivo ------');
	leerEmpleado(e);
	while (e.apellido <> 'fin') do begin
		write(arEmp,e);
		leerEmpleado(e);
	end;
	close(arEmp);	
	writeln('------------------------------');
end;

procedure informarEmpleado (e : empleado);
begin
	writeln('------ Informacion de un Empleado ------');
	with e do begin
		writeln('NRO del Empleado: ',nro_empleado);
		writeln('Apellido del Empleado: ',apellido);
		writeln('Nombre del Empleado: ',nombre);
		writeln('Edad del Empleado: ',edad);
		writeln('DNI del Empleado: ',dni);
	end;
	writeln('----------------------------------------');
end;
function menuOpciones():integer;
begin
	writeln();
	writeln('--------- Bienvenido ---------');
	writeln('Elija alguna de las siguientes opciones ingresando el numero correspondiente:');
	writeln('1 - Crear un Archivo de Empleados');
	writeln('2 - Abrir el Archivo Generado');
	writeln('3 - Añadir Uno o Mas Empleados');
	writeln('4 - Modificar la Edad de un Empleado');
	writeln('5 - Exportar a Archivo de Texto');
	writeln('6 - Exportar a Empleados Sin DNI');
	writeln('7 - Salir');
	writeln('------------------------------');
	writeln();
	write('Ingrese una opcion: ');
	readln(menuOpciones);
end;

procedure nomyape(var arEmp:ArchivoEmpleados);
var
	e:empleado;
	contador:integer;
	nom,ape : string;
begin
	contador:=0;
	reset(arEmp);
	writeln();
	writeln('--------------------------------------------------------------------------------------');
	writeln('------ Se listaran todas las ocurrencias que coincidan con el nombre ingresado -------');
	write('Ingrese un nombre: ');
	readln(nom);
	write('Ingrese un apellido: ');
	readln(ape);
	while not eof(arEmp) do begin
		read(arEmp,e);
		if (e.nombre = nom) and (e.apellido = ape) then begin
			contador := contador + 1;
			writeln();
			writeln('Ocurrencia nro ',contador);
			informarEmpleado(e);
		end;			
	end;
	writeln();
	if (contador = 0) then writeln('No se encontro ninguna ocurrencia.');
	close(arEmp);
	writeln('--------------------------------------------------------------------------------------');
end;

procedure masSetenta(var arEmp:ArchivoEmpleados);
var
	contador:integer;
	e:empleado;
begin
	contador:=0;
	reset(arEmp);
	writeln();
	writeln('---------------------------------------------------------------------------------');
	writeln('------ Se listaran todas las ocurrencias de empleados con mas de 70 años -------');
	while not eof(arEmp) do begin
		read(arEmp,e);
		if (e.edad > 70) then begin
			contador := contador + 1;
			writeln();
			writeln('Ocurrencia nro ',contador);
			informarEmpleado(e);
		end;						
	end;
	writeln();
	if (contador = 0) then writeln('No se encontro ninguna ocurrencia.');
	close(arEmp);
	writeln('---------------------------------------------------------------------------------');
end;

procedure listarEmpleados(var arEmp:ArchivoEmpleados);
var
	e:empleado;
begin
	reset(arEmp);
	writeln();
	writeln('----------------------------------------------------------');
	writeln('------ Se listaran todos los empleados del archivo -------');
	while not eof(arEmp) do begin
		read(arEmp,e);
		informarEmpleado(e);			
	end;
	close(arEmp);
	writeln('----------------------------------------------------------');
end;

function yaExiste(var arEmp:ArchivoEmpleados; nroEmp : integer):boolean;
var
	e:empleado;
begin
	yaExiste:= false;
	seek(arEmp,0);
	while ((not eof(arEmp)) and (not yaExiste)) do begin
		read(arEmp,e);
		if (nroEmp = e.nro_empleado) then yaExiste := true;			
	end;
end;

procedure agregarEmpleados(var arEmp:ArchivoEmpleados);
var
	e:empleado;
begin
	reset(arEmp);
	writeln();
	writeln('-----------------------------------------------------');
	writeln('------ Se cargaran nuevos empleado al archivo -------');
	leerEmpleado(e);
	while (e.apellido <> 'fin') do begin
		if (not yaExiste(arEmp, e.nro_empleado)) then begin
			seek(arEmp,filesize(arEmp));
			write(arEmp,e);
			writeln(' ========== Se agrego al empleado con EXITO ==========');
		end
		else writeln(' ========== NO se puede AGREGAR - El Empleado ya EXISTE. ==========');
		leerEmpleado(e);
	end;
	close(arEmp);	
	writeln('-----------------------------------------------------');	
end;

procedure modificarEdadEmp(var arEmp:ArchivoEmpleados);
var
	exito:boolean;
	e:empleado;
	nro: integer;
begin
	reset(arEmp);
	exito := false;
	writeln();
	writeln('---------------------------------------------------');
	writeln('------ Se modificara la edad de un empleado -------');
	writeln();
	write('Ingrese el Nro del Empleado: ');
	readln(nro);
	while ((not eof(arEmp)) and (not exito)) do begin
		read(arEmp,e);
		if (e.nro_empleado = nro) then begin
			write('Ingrese la nueva edad para el empleado ', e.nombre,': ');
			readln(e.edad);
			exito:=true;
			seek(arEmp,filepos(arEmp)-1);
			write(arEmp,e);
		end;
	end;
	if (exito) then writeln(' ====== Se cammbio la edad con exito ======')
	else writeln(' ====== Fallo en cambiar la edad, el empleado no existe ======');
	close(arEmp);	
	writeln('---------------------------------------------------');	
end;

procedure ExportarATexto(var arEmp:ArchivoEmpleados);
var
	arTxT : ArchivoEmpleados;
	e:empleado;
begin	
	assign(arTxT,'todos_empleados.txt');
	rewrite(arTxT);
	reset(arEmp);
	writeln();
	writeln('------ Se exportara el archivo a un .txt ------');
	while (not eof(arEmp)) do begin
		read(arEmp,e);
		write(arTxT,e);
	end;
	close(arTxT);	
	close(arEmp);	
	writeln('-----------------------------------------------');
end;

procedure ExportarSinDni(var arEmp:ArchivoEmpleados);
var
	arSinDni : ArchivoEmpleados;
	e:empleado;
begin	
	assign(arSinDni,'faltaDNIEmpleado.txt');
	rewrite(arSinDni);
	reset(arEmp);
	writeln();
	writeln('------ Se exportaran los empleados sin DNI ------');
	while (not eof(arEmp)) do begin
		read(arEmp,e);
		if (e.dni = '00') then write(arSinDni,e);
	end;
	close(arSinDni);	
	close(arEmp);	
	writeln('-----------------------------------------------');
end;

var
	nombre_fisico : string;
	arEmp:ArchivoEmpleados;
	opcion:integer;
begin
	opcion := menuOpciones();
	while (opcion < 7) do begin
		case opcion of
			1:
				begin
					writeln();
					write('Ingrese un nombre para el archivo: ');
					readln(nombre_fisico);
					assign(arEmp,nombre_fisico);
					cargarArchivo(arEmp);	
				end;
			2:
				begin
					writeln();
					write('Ingrese el nombre del archivo a procesar: ');
					readln(nombre_fisico);
					assign(arEmp,nombre_fisico);
					listarEmpleados(arEmp);
					nomyape(arEmp);
					masSetenta(arEmp);
				end;
			3:
				begin
					writeln();
					write('Ingrese el nombre del archivo al que quiere añadir empleados: ');
					readln(nombre_fisico);
					assign(arEmp,nombre_fisico);
					agregarEmpleados(arEmp);
				end;
			4:
				begin
					writeln();
					write('Ingrese el nombre del archivo que quiere modificar: ');
					readln(nombre_fisico);
					assign(arEmp,nombre_fisico);
					modificarEdadEmp(arEmp);
				end;
			5:
				begin
					writeln();
					write('Ingrese el nombre del archivo que quiere exportar: ');
					readln(nombre_fisico);
					assign(arEmp,nombre_fisico);
					ExportarATexto(arEmp);
				end;
			6:
				begin
					writeln();
					write('Ingrese el nombre del archivo que quiere exportar los empleados sin DNI: ');
					readln(nombre_fisico);
					assign(arEmp,nombre_fisico);
					ExportarSinDni(arEmp);
				end;
		end;
		opcion := menuOpciones();	
	
	end;
end.
