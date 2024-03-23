//Realizar un programa que presente un menú con opciones para:
//	a. Crear un archivo de registros no ordenados de empleados y completarlo con
//	datos ingresados desde teclado. De cada empleado se registra: número de
//	empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
//	DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
//	b. Abrir el archivo anteriormente generado y
//		i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
//		determinado, el cual se proporciona desde el teclado.
//		ii. Listar en pantalla los empleados de a uno por línea.
//		iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

program ejer3;
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
	writeln('3 - Salir');
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

var
	nombre_fisico : string;
	arEmp:ArchivoEmpleados;
	opcion:integer;
begin
	
	opcion := menuOpciones();
	while (opcion <> 3) do begin
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
		end;
		opcion := menuOpciones();	
	
	end;

end.
