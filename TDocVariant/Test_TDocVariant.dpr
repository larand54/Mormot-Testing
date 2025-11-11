program Test_TDocVariant;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils
  , mormot.core.variants
  , mormot.core.base                // Required by TID
  , mormot.core.text
  , mormot.orm.base
  , mormot.orm.core
  , mormot.rest.sqlite3
  , mormot.db.raw.sqlite3.static
  , mormot.core.os
  , TDVData in 'TDVData.pas'
  , uTDVClient in 'uTDVClient.pas'
;

function InitServer: TDVClient;
var
  model: TOrmModel;
  client: TDVClient;
begin
  Model := CreateSampleModel;
  Client := TDVClient.Create(Model, nil, ChangeFileExt(Executable.ProgramFileName,'.db'), TRestServerDB, false, '');
  Client.Server.Server.CreateMissingTables;
  result := Client;
end;

procedure addSimpleData;
var
  aRec: TOrmT1;
  aID: TID;
  client: TDVClient;
begin
  Client := InitServer;
  aRec := TOrmT1.Create;
  aRec.Name := 'Joe';                              // one unique key
  aRec.Age := 66;
  aID := Client.orm.Add(aRec,true);

end;

procedure addSomeData;
var aRec: TOrmTDV;
    aID: TID;
    client: TDVClient;
    s: RawUTF8;
begin
  // initialization of one record
  aRec := TOrmTDV.Create;
  aRec.Name := 'Joel8';                              // one unique key
  aRec.data := _JSONFast('{name:"Joel",age:30}');   // create a TDocVariant
  // or we can use this overloaded constructor for simple fields
//  aRec := TOrmTDV.Create(['Joe',_ObjFast(['name','Joe','age',30])]);
  // now we can play with the data, e.g. via late-binding:
  writeln(aRec.Name);     // will write 'Joe'
  writeln(aRec.Data);     // will write '{"name":"Joe","age":30}' (auto-converted to JSON string)
  aRec.Data.age := aRec.Data.age+1;    // one year older
  aRec.Data.interests := 'football';   // add a property to the schema
  Client := InitServer;
  aID := Client.orm.Add(aRec,true);       // will store {"name":"Joe","age":31,"interests":"footbal"}
  aRec.Free;
  // now we can retrieve the data either via the aID created integer, or via Name='Joe'
  aRec := TOrmTDV.Create;
  if client.retrieve( aID, aRec) then begin
    s := aRec.Data;
    writeln('!!--- '+s)
  end
  else
    writeln('ERROR');
  readln;
  aRec.Free;
  aRec := nil;
end;

var
  V, V1, V2: variant;
begin
  TDocVariant.New(V);
  TDocVariant.New(V1);
  TDocVariant.New(V2);
  V.name := 'John';
  V.Age := 77;
  V1 := _obj(['Name','John', 'Age', 87]);
  V2 := _obj(['Name','John', 'doc',_obj(['Year', 1942])]);

  writeln(VariantSaveJson(V));
  writeln(VariantSaveJson(V1));
  writeln(VariantSaveJson(V2));
  readln;
  addSomeData;
  addSimpleData;
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
