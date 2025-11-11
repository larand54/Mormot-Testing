program DynArray;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils
  , mormot.core.base
  , mormot.core.data
  , mormot.core.text
  , mormot.core.json
;

/// initialize the wrapper with a one-dimension dynamic array
    // - the dynamic array must have been defined with its own type
    // (e.g. TIntegerDynArray = array of integer)
    // - if aCountPointer is set, it will be used instead of length() to store
    // the dynamic array items count - it will be much faster when adding
    // items to the array, because the dynamic array won't need to be
    // resized each time - but in this case, you should use the Count property
    // instead of length(array) or high(array) when accessing the data: in fact
    // length(array) will store the memory size reserved, not the items count
    // - if aCountPointer is set, its content will be set to 0, whatever the
    // array length is, or the current aCountPointer^ value is
    // - a sample usage may be:
    // !var
    // !  DA: TDynArray;
    // !  A: TIntegerDynArray;
    // !begin
    // !  DA.Init(TypeInfo(TIntegerDynArray), A);
    // ! (...)
    // - a sample usage may be (using a count variable):
    // !var
    // !  DA: TDynArray;
    // !  A: TIntegerDynArray;
    // !  ACount: integer;
    // !  i: integer;
    // !begin
    // !  DA.Init(TypeInfo(TIntegerDynArray), A, @ACount);
    // !  for i := 1 to 100000 do
    // !    DA.Add(i); // MUCH faster using the ACount variable
    // ! (...)   // now you should use DA.Count or Count instead of length(A)
type
  TmyRec = packed record
    id: integer;
    name: RawUTF8;
    age: integer;
  end;
  TRecArr = array of TmyRec;

procedure test1;
var
  DA: TDynArray;
  A: TIntegerDynArray;
  ACount: integer;
  i: integer;
begin
  DA.Init(TypeInfo(TIntegerDynArray), A, @ACount);
  for i := 1 to 100000 do
    DA.Add(i); // MUCH faster using the ACount variable
end;

procedure test2;
type
  TMyRecord = record
    ID: Integer;
    Name: RawUTF8;
  end;
  TDynRec = array of TMyRecord;
var
  MyRecords: array of TMyRecord;
  DynArray: TDynArray;
  JSONData: RawUTF8;
  count:integer;
  i: integer;
begin
  // Initialize dynamic array
  SetLength(MyRecords, 2);
  MyRecords[0].ID := 1;
  MyRecords[0].Name := 'Alpha';
  MyRecords[1].ID := 2;
  MyRecords[1].Name := 'Beta';

  // Wrap the dynamic array with TDynArray
  DynArray.Init(TypeInfo(TDynRec), MyRecords, @count);
  for i := 0 to length(MyRecords)-1 do
    DynArray.Add(MyRecords[i]);
  // Serialize to JSON
  JSONData := DynArray.SaveToJSON;
  writeln(JSONDATA);
  readln;

  // ... further operations like loading from JSON, sorting, etc.
end;

var
  DA:  TDynArray;
  recArr: TRecArr;
  rec, aRec: TmyRec;
  i, aCount: integer;
  n: RawUTF8;
  JSONData: RawUTF8;
  RBS: RawByteString;

begin
  DA.Capacity := 1;         // Pre-allocate memory for faster handling, if this is to low, it re-allocate memory as needed(slower).
  DA.Init(TypeInfo(TRecArr), recArr, @ACount);
  setLength(recArr,2);
  recArr[0].name := 'Lars';
  recArr[0].age := 71;
  recArr[0].id := 1;
  recArr[1].name := 'Gunnar';
  recArr[1].age := 76;
  recArr[1].id := 2;
  for  i := 0 to length(recArr)-1 do begin
    DA.Add(recArr[i]);
  end;
  JSONData := DA.SaveToJSON(true);//, TJSONWriter);
  writeln(jsondata);
  test1;
  test2;

(*
    try
      for i := 0 to DA.Count-1 do
      begin
        aRec := TmyRec(DA[i]);
        n := aRec.name;
      end;
      writeln(rec(DA[i]).name);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;

*)
end.
