unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls
  , mormot.orm.base
  , mormot.orm.core
  , mormot.core.base
  , mormot.core.os
  , mormot.core.json
  , mormot.core.variants
  , mormot.rest.sqlite3
  , mormot.db.raw.sqlite3.static
  , system.Generics.Collections
;

type
  TMember = packed record
    Name: RawUTF8;
    Age: integer;
  end;

  TOrmFamily = class(TOrm)
    private
      fFamilyName: RawUTF8;
      fMembers: Variant;
    public
      procedure AddMember(member: TMember);
    published
      property FamilyName: RawUTF8 read fFamilyName write fFamilyName;
      property Members: variant read fMembers write fMembers;
  end;
  TFamilyArray = array of TOrmFamily;


  TFamClient = class(TRestClientDB)
  end;

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    btnNewTest: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    Families: RawUTF8;
    Model: TOrmModel;
    server: TFamClient;
    function addFamily(const pmcFam: TOrmFamily): boolean;
    function addMember(const pmcFam: TOrmFamily; const pmcMbr: TMember): boolean;
  public
    { Public declarations }
  end;

function CreateOSModel: TOrmModel;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function InitServer: TFamClient;
var
  model: TOrmModel;
  client: TFamClient;
begin
  Model := CreateOSModel;
  Client := TFamClient.Create(Model, nil, ChangeFileExt(Executable.ProgramFileName,'.db3'), TRestServerDB, false, '');
  Client.Server.Server.CreateMissingTables;
  result := Client;
end;

function CreateOSModel: TOrmModel;
begin
  result := TOrmModel.Create([TOrmFamily]);
end;

function TForm2.addFamily(const pmcFam: TOrmFamily): boolean;
var
  ID: TID;
begin
  ID := Server.Server.orm.Add(pmcFam,true);
  result := ID > 0;
end;

function TForm2.addMember(const pmcFam: TOrmFamily;
  const pmcMbr: TMember): boolean;
var
  Jss, js, js2: RawByteString;
  val: variant;
  list,list2: IDocList;
  Dict: IDocDict;
  f: TDocDictFields;

  DocVariant: TDocVariant;
  v: variant;
  doc: TDocVariantData;
begin
  Js := RecordSaveJson(pmcMbr, TypeInfo(TMember));
  val := _JsonFast(js);
  js2 := _JsonFast(pmcFam.Members);
  list := DocList(js2);
  List.Append(val);
  v := List.AsVariant;
    if list.Len > 0 then
    while list.PopItem(v) do
    begin
      assert(list.Count(v) = 0); // count the number of appearances
      assert(not list.Exists(v));
      Listbox1.Items.Add(v.Name); // late binding
      dict := DocDictFrom(v); // transtyping from variant to IDocDict
      // enumerate the key:value elements of this dictionary
      for f in dict do
      begin
        Listbox2.Items.Add(f.Key);
        Listbox3.Items.Add(f.Value);
      end;
    end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  OLList: TList<TMember>;
  DocList: IDocList;
  olv: TDocVariant;
  JsonString: RawByteString;
  newFamily: TOrmFamily;
var
  fam1, fam2, fam: TOrmFamily;
  mbr11, mbr12, mbr21, mbr22, mbr: TMember;

begin
  Server := initServer;

  fam1 := TOrmFamily.Create;
  fam1.FamilyName := 'Larson';
  fam1.fMembers := '[{"name":"Alice","age":30}]';
  addFamily(fam1);

  mbr11.Name := 'Tommy'; mbr11.Age := 45;
//  addMember(fam1, mbr11);
  mbr12.Name := 'Linda'; mbr12.Age := 43;
//  addMember(fam1, mbr12);
  fam1.AddMember(mbr11);
  fam1.AddMember(mbr12);

  fam2 := TOrmFamily.Create;
  fam2.FamilyName := 'Svenson';
  addFamily(fam2);

  mbr21.Name := 'Erik'; mbr21.Age := 25;
//  addMember(fam2, mbr21);
  mbr22.Name := 'Lena'; mbr22.Age := 23;
  fam2.AddMember(mbr21);
  fam2.AddMember(mbr22);
 // addMember(fam2, mbr22);

  fam1.Free;
  fam2.Free;
  Server.Model.Free;
  Server.Free;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  JsonArray: IDocList;
  MyJsonString: RawUtf8;
  ResultJson: RawUtf8;
begin
(*  JsonArray := TDocVariantData.CreateList; // Creates an empty IDocListend;

    MyJsonString := '{"key": "value"}';
    JsonArray.Add(TDocVariantData.CreateJson(MyJsonString)); // Parses and adds directly
    JsonArray.Add(TDocVariantData.CreateJson(MyJsonString)); // Parses and adds directly
    ResultJson := JsonArray.SaveJson;

*)end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  model := CreateOSModel;
  server := InitServer;
end;

{ TOrmFamily }

procedure TOrmFamily.AddMember(member: TMember);
begin
  TDocVariantData(fMembers).AddItem(_JsonFast(RecordSaveJson(member, TypeInfo(TMember))));
end;

initialization
TJSONSerializer.RegisterObjArrayForJSON([TypeInfo(TFamilyArray), TOrmFamily]);

end.
