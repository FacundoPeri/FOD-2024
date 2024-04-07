{
Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para
a.Actualizar el archivo maestro de la siguiente manera:
	i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
	y se decrementa en uno la cantidad de materias sin final aprobado.
	
	ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
	final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
}

program ejercicio2;
const
	valor_alto = '9999';
type
    alumno = record
        cod_alum : string;
        ape_alum : string;
        nom_alum : string;
        cursadas: integer;
        finales: integer;
    end;
	
	materia = record
		cod_alum : string;
		aprobo_final : boolean;
		aprobo_cursada : boolean;
	end;
	
	maestro = file of alumno;
	detalle = file of materia;
	
procedure LeerMateria(var m : materia);
var si_no : string;
begin
	writeln('');
	writeln('------ Se cargara informacion de una Materia -----');
	with m do begin
		write('- Codigo De Alumno: ');
		readln(cod_alum);
		if (cod_alum <> '9999') then begin
			write('¿Aprobo la cursada? Si/No: ');
			readln(si_no);
			if ((si_no = 'si') or (si_no = 'Si') or (si_no = 'SI')) then aprobo_cursada := true
			else aprobo_cursada := false;
	
			write('¿Aprobo el final? Si/No: ');
			readln(si_no);
			if ((si_no = 'si') or (si_no = 'Si') or (si_no = 'SI')) then aprobo_final := true
			else aprobo_final := false;
		end;
	end;
	writeln('--------------------------------------------------');
end;

procedure CargarDetalle(var det : detalle);
var m:materia;
begin
	rewrite(det);
	writeln('');
	writeln('------ Se cargara el archivo de Materias -----');
	LeerMateria(m);
	while (m.cod_alum <> '9999') do begin
		write(det,m);
		LeerMateria(m);
	end;
	writeln('----------------------------------------------');
	close(det);
end;

procedure LeerAlumno(var a : alumno);
begin
	writeln('');
	writeln('------ Se cargara informacion de un Alumno -----');
	with a do begin
		write('- Codigo: ');
		readln(cod_alum);
		if (cod_alum <> '9999') then begin
			write('- Nombre: ');
			readln(nom_alum);
			write('- Apellido: ');
			readln(ape_alum);
			cursadas := 0;
			finales := 0;
		end;
	end;
	writeln('--------------------------------------------------');
end;

procedure CargarMaestro(var mae : maestro);
var a:alumno;
begin
	rewrite(mae);
	writeln('');
	writeln('------ Se cargara el archivo de Alumnos -----');
	LeerAlumno(a);
	while (a.cod_alum <> '9999') do begin
		write(mae,a);
		LeerAlumno(a);
	end;
	writeln('----------------------------------------------');
	close(mae);
end;

procedure LeerDetalle(var det : detalle; var m:materia);
begin
	if (not eof(det)) then read(det,m)
	else m.cod_alum := '9999';
end;

procedure ActualizarMaestro(var mae:maestro; var det:detalle);
var 
	cod_act : string;
	a:alumno;
	m:materia;
begin
	reset(mae);
	reset(det);
	
	read(mae,a);
	LeerDetalle(det,m);
	
	while (m.cod_alum <> '9999') do begin
		
		cod_act := m.cod_alum;
		
		while (a.cod_alum <> cod_act) do read(mae,a);
		
		while (cod_act = m.cod_alum) do begin
			if (m.aprobo_cursada) then a.cursadas := a.cursadas + 1;
			if (m.aprobo_final) then begin
				a.cursadas := a.cursadas - 1;
				a.finales := a.finales + 1;
			end;
			LeerDetalle(det,m);
		end;
		
		seek(mae,filepos(mae)-1);
		
		write(mae,a);
		
		if(not eof(mae)) then read(mae,a);
	
	end;
	close(mae);
	close(det);
end;

procedure ImprimirDetalle(var det: detalle);
var 
	m : materia;
begin
	reset(det);
	writeln('');
	writeln('------ Se imprimira la informacion del archivo de materias ------');
	while (not eof(det)) do begin
		read(det,m);
		with m do begin
			writeln('------ Materia ------');
			writeln('- Codigo Alumno: ',cod_alum);
			writeln('- Aprobo Cursada: ',aprobo_cursada);
			writeln('- Aprobo Final: ',aprobo_final);
			writeln('----------------------');
		end;
	end;	
	writeln('------------------------------------------------------------------');
	close(det);
end;

procedure ImprimirMaestro(var mae: maestro);
var 
	a : alumno;
begin
	reset(mae);
	writeln('');
	writeln('------ Se imprimira la informacion del archivo de resumen ------');
	while (not eof(mae)) do begin
		read(mae,a);
		with a do begin
			writeln('------ Alumno ------');
			writeln('- Codigo: ',cod_alum);
			writeln('- Nombre: ',nom_alum);
			writeln('- Apellido: ',ape_alum);
			writeln('- Cursadas aprobadas: ',cursadas);
			writeln('- Finales aprobados: ',finales);
			writeln('----------------------');
		end;
	end;	
	writeln('------------------------------------------------------------------');
	close(mae);
end;
procedure InformarTXT(var mae:maestro);
var
	a:alumno;
	info : text;
begin
	assign(info,'Informe.txt');
	rewrite(info);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae, a);
		with a do begin
			if (finales > cursadas) then
				write(info,cod_alum,' ',nom_alum,' ',ape_alum,' ',cursadas,' ',finales);
		end;
	end;
	close(mae);
	close(info);
end;

procedure MenuOpciones (var op : integer);
begin
	writeln('------ Seleccione Una Opcion ------');
	writeln('1- Cargar Archivo Alumnos');
	writeln('2- Cargar Archivo Materias');
	writeln('3- Actualizar Archivo Alumnos');
	writeln('4- Imprimir Archivo Alumno');
	writeln('5- Imprimir Archivo Materias');
	writeln('6- Informar en Texto');
	writeln('7- Salir');
	write('Ingrese una opcion: ');
	readln(op);
end;
var
	mae : maestro;
	det : detalle;
	op:integer;
begin
	assign(det,'Materias');
	assign(mae,'Alumnos');
	
	MenuOpciones(op);
	while (op <> 7) do begin
		case op of
			1: CargarMaestro(mae);
			2: CargarDetalle(det);
			3: ActualizarMaestro(mae,det);
			4: ImprimirMaestro(mae);
			5: ImprimirDetalle(det);
			6: InformarTXT(mae);
			else writeln('!!!!!! No se selecciono una opcion valida !!!!!!');
		end;
		MenuOpciones(op);
	end;
end.	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
