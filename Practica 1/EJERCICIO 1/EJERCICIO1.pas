// Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
// incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
// cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
// archivo debe ser proporcionado por el usuario desde teclado.
program ejer1;
type
    ArchivoEnteros = file of integer;
var
   nombre_fisico:string;
   arEnt:ArchivoEnteros;
   nro:integer;
begin
    write('Ingrese el nombre para el archivo: ');
    readln(nombre_fisico);
    assign(arEnt,nombre_fisico);
    rewrite(arEnt);

    writeln('-------------------------------');
    write('Ingrese un numero: ');
    readln(nro);

    while (nro <> 30000) do begin
          write(arEnt,nro);

          writeln('-------------------------------');
          write('Ingrese un numero: ');
          readln(nro);
    end;

    close(arEnt);
end.





