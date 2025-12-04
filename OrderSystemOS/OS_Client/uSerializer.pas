(*
Source - https://stackoverflow.com/a/11514088
Posted by LU RD, modified by community. See post 'Timeline' for change history
Retrieved 2025-11-28, License - CC BY-SA 3.0
*)

unit uSerializer;

interface

uses
  System.SysUtils, Classes, RTTI, TypInfo;

Type
  TSerializer = record
  private
    FSumIndent: string;
    procedure IncIndent;
    procedure DecIndent;
  public
    procedure Serialize(const name: string; thing: TValue;
      sList: TStrings; first: boolean = true);
  end;

implementation

procedure TSerializer.IncIndent;
begin
  FSumIndent := FSumIndent + '  ';
end;

procedure TSerializer.DecIndent;
begin
  SetLength(FSumIndent, Length(FSumIndent) - 2);
end;

procedure TSerializer.Serialize(const name: string; thing: TValue;
  sList: TStrings; first: boolean);
type
  PPByte = ^PByte;
var
  LContext: TRTTIContext;
  LField: TRTTIField;
  LProperty: TRTTIProperty;
  LRecord: TRTTIRecordType;
  LClass: TRTTIInstanceType;
  LStaticArray: TRTTIArrayType;
  LDynArray: TRTTIDynamicArrayType;
  LDimType: TRttiOrdinalType;
  LArrayIx: array of integer;
  LArrayMinIx: array of integer;
  LArrayMaxIx: array of integer;
  LNewValue: TValue;
  i: integer;
  // Generic N-dimensional array indexing
  procedure IncIx(var ArrayIx, ArrayMinIx, ArrayMaxIx: array of integer);
  var
    dimIx: integer;
  begin
    dimIx := Length(ArrayIx) - 1;
    repeat
      if (ArrayIx[dimIx] < ArrayMaxIx[dimIx]) then
      begin
        Inc(ArrayIx[dimIx]);
        break;
      end
      else
      begin
        ArrayIx[dimIx] := ArrayMinIx[dimIx];
        Dec(dimIx);
        if (dimIx < 0) then
          break;
      end;
    until (true = false);
  end;
  // Convert N-dimensional index to a string
  function IxToString(const ArrayIx: array of integer): string;
  var
    i: integer;
  begin
    Result := '';
    for i := 0 to High(ArrayIx) do
      Result := Result + '[' + IntToStr(ArrayIx[i]) + ']';
  end;
  // Get correct reference
  function GetValue(Addr: Pointer; Typ: TRTTIType): TValue;
  begin
    TValue.Make(Addr, Typ.Handle, Result);
  end;

begin
  if first then
    FSumIndent := '';

  case thing.Kind of
    { - Number calls }
    tkInteger, // Identifies an ordinal type.
    tkInt64, // Identifies the Int64/UInt64 types.
    tkPointer: // Identifies a pointer type.
      begin
        sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
          thing.ToString);
      end;
    tkEnumeration:
      begin
        if (thing.TypeInfo = TypeInfo(boolean)) then
        begin
          sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
            BoolToStr(thing.AsBoolean));
        end
        else begin
          // ToDO : Implement this
        end;
      end; // Identifies an enumeration type.
    tkSet: // Identifies a set type.
      begin
        // ToDO : Implement this
      end;
    { - Float calls }
    tkFloat: // Identifies a floating-point type. (plus Date,Time,DateTime)
      begin
        if (thing.TypeInfo = TypeInfo(TDate)) then
        begin
          sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
            DateToStr(thing.AsExtended));
        end
        else if (thing.TypeInfo = TypeInfo(TTime)) then
        begin
          sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
            TimeToStr(thing.AsExtended));
        end
        else if (thing.TypeInfo = TypeInfo(TDateTime)) then
        begin
          sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
            DateTimeToStr(thing.AsExtended));
        end
        else
        begin
          sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
            FloatToStr(thing.AsExtended));
        end;
        // ToDO : Handle currency
      end;

    { - String,character calls }
    tkChar, // Identifies a single-byte character.
    tkString, // Identifies a short string type.
    tkLString: // Identifies an AnsiString type.
      begin
        sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
          thing.AsString);
      end;
    tkWString: // Identifies a WideString type.
      begin
        sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
          thing.ToString);
      end;
    tkInterface: // Identifies an interface type.
      begin
        // ToDO : Implement this
      end;
    tkWChar, // Identifies a 2-byte (wide) character type.
    tkUString: // Identifies a UnicodeString type.
      begin
        sList.Add(FSumIndent + name + ':' + thing.TypeInfo.name + '=' +
          thing.AsString);
      end;

    tkVariant: // Identifies a Variant type.
      begin
        // ToDO : Implement this
      end;

    { - Generates recursive calls }
    tkArray: // Identifies a static array type.
      begin
        LStaticArray := LContext.GetType(thing.TypeInfo) as TRTTIArrayType;
        SetLength(LArrayIx, LStaticArray.DimensionCount);
        SetLength(LArrayMinIx, LStaticArray.DimensionCount);
        SetLength(LArrayMaxIx, LStaticArray.DimensionCount);
        sList.Add(FSumIndent + 'static array ' + name + ':' +
          LStaticArray.ElementType.name);
        IncIndent();
        for i := 0 to LStaticArray.DimensionCount - 1 do
        begin
          LDimType := LStaticArray.Dimensions[i] as TRttiOrdinalType;
          LArrayMinIx[i] := LDimType.MinValue;
          LArrayMaxIx[i] := LDimType.MaxValue;
          LArrayIx[i] := LDimType.MinValue;
        end;
        for i := 0 to LStaticArray.TotalElementCount - 1 do
        begin
          Serialize(Name + IxToString(LArrayIx),
            GetValue( PByte(thing.GetReferenceToRawData) +
              LStaticArray.ElementType.TypeSize * i,
              LStaticArray.ElementType),
            sList,false);
          IncIx(LArrayIx, LArrayMinIx, LArrayMaxIx);
        end;
        DecIndent();
        sList.Add(FSumIndent + 'end');
      end;
    tkDynArray: // Identifies a dynamic array type.
      begin
        LDynArray := LContext.GetType(thing.TypeInfo) as TRTTIDynamicArrayType;
        sList.Add(FSumIndent + 'dynamic array ' + name + ':' +
          LDynArray.ElementType.name);
        IncIndent();
        for i := 0 to thing.GetArrayLength - 1 do
        begin
          Serialize(Name + '[' + IntToStr(i) + ']',
            GetValue( PPByte(thing.GetReferenceToRawData)^ +
              LDynArray.ElementType.TypeSize * i,
              LDynArray.ElementType),
            sList,false);
        end;
        DecIndent();
        sList.Add(FSumIndent + 'end');
      end;
    tkRecord: // Identifies a record type.
      begin
        sList.Add(FSumIndent + 'record ' + name +':' +thing.TypeInfo.name);
        LRecord := LContext.GetType(thing.TypeInfo).AsRecord;
        IncIndent();
        for LField in LRecord.GetFields do
        begin
          Serialize(LField.name, LField.GetValue(thing.GetReferenceToRawData),
            sList, false);
        end;
        DecIndent();
        sList.Add(FSumIndent + 'end');
      end;
    tkClass: // Identifies a class type.
      begin
        sList.Add(FSumIndent + 'object ' + name + ':' + thing.TypeInfo.name);
        IncIndent();
        LClass := LContext.GetType(thing.TypeInfo).AsInstance;
        for LField in LClass.GetFields do
        begin
          Serialize(LField.name,
            // A hack to get a reference to the object
            // See https://stackoverflow.com/questions/2802864/rtti-accessing-fields-and-properties-in-complex-data-structures
            GetValue(PPByte(thing.GetReferenceToRawData)^ + LField.Offset,
            LField.FieldType),
            sList,false);
        end;
        // ToDO : Implement a more complete class serializer
        DecIndent();
        sList.Add(FSumIndent + 'end');
      end;

    { - Not implemented }
    tkClassRef: ; // Identifies a metaclass type.
    tkMethod: ; // Identifies a class method type.
    tkProcedure: ; // Identifies a procedural type.
    tkUnknown: ; // Identifies an unknown type that has RTTI.
  end;
end;

end.

end.
