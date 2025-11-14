unit uOS_Server;

interface

{$I mormot.defines.inc}

uses
  System.SysUtils
  , mormot.rest.sqlite3
  , mormot.core.text
  , mormot.db.raw.sqlite3.static
  , mormot.core.os
  , mormot.orm.core
  ,  mormot.core.base // TID
  , uOS_Data;

type
  TOS_Client = class(TRestClientDB)
  end;

function InitServer: TOS_Client;
function addOrder(client: TOS_Client; const pmcOrder: TOrmOSOrder): boolean;
function UpdateOrder(client: TOS_Client; const pmcOrder: TOrmOSOrder): boolean;
function addClient(client: TOS_Client; const pmcClient: TOrmClient): boolean;
function addProduct(client: TOS_Client; const pmcProduct: TOrmProduct): boolean;

implementation

function InitServer: TOS_Client;
var
  model: TOrmModel;
  client: TOS_Client;
begin
  model := CreateOSModel;
  client := TOS_Client.Create(model, nil,
    ChangeFileExt(Executable.ProgramFileName, '.db'), TRestServerDB, false, '');
  client.Server.Server.CreateMissingTables;
  result := client;
end;

function addOrder(client: TOS_Client; const pmcOrder: TOrmOSOrder): boolean;
var
  ID: TID;
begin
  ID := client.orm.Add(pmcOrder, true);
  result := ID > 0;
end;

function UpdateOrder(client: TOS_Client; const pmcOrder: TOrmOSOrder): boolean;
begin
  result := client.orm.Update(pmcOrder);
end;

function addClient(client: TOS_Client; const pmcClient: TOrmClient): boolean;
var
  ID: TID;
begin
  ID := client.orm.Add(pmcClient, true);
  result := ID > 0;
end;

function addProduct(client: TOS_Client; const pmcProduct: TOrmProduct): boolean;
var
  ID: TID;
begin
  ID := client.orm.Add(pmcProduct, true);
  result := ID > 0;
end;

end.
