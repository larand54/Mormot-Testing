program ProjectTestRtti;

{$APPTYPE CONSOLE}

uses
  Rtti,
  SysUtils;

type
  MyRecord=record
   Field1 : integer;
   Field2 : boolean;
   Field3 : string;
  end;

var
 ctx   : TRttiContext;
 t     : TRttiType;
 field : TRttiField;
begin
 try
     ctx := TRttiContext.Create;
     for field in ctx.GetType(TypeInfo(MyRecord)).GetFields do
     begin
       t := field.FieldType;
       writeln(Format('Field : %s : Type : %s',[field.Name,field.FieldType.Name]));
     end;
 except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
 end;

  Readln;
end.end.
